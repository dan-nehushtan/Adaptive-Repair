# src/champ_integration.py
"""
CHAMP Machine Integration Wrapper
===================================

Drop-in replacement for the binary ``process_results()`` /
``handle_corrections()`` functions in the legacy **CHAMP_monitoring**
codebase.  Instead of setting GPIO pins (D5 planarize / D6 rework /
D7 continue), this module generates **per-defect repair G-code** and
stages a ``.tap`` file for the CHAMP controller.

Integration modes
-----------------
  **Legacy (Mach4 + GPIO)**:
      Write ``.tap`` to a shared directory that Mach4 polls via MACROB.
      Replace the D5/D6 branch with a single "load and run repair.tap".

  **Current (Duet Net + serial firmware)**:
      Write ``.tap`` to a staging directory.  The Duet Net software
      sends the file to the controller over serial.  File naming
      follows the existing ``{N}_comp.tap`` convention, with repair
      files named ``{N}_repair.tap``.

Architecture
------------
::

    CHAMP_monitoring (or Duet controller wrapper)
        │
        ├─ 1. Print layer  (existing AM G-code)
        ├─ 2. Camera capture  (Baumer neoapi / manual)
        │
        ▼
    adaptive_repair_decision(image_path, z, layer_num)
        │
        ├─ YOLOv8 detection
        ├─ Pixel → bed coordinate mapping
        ├─ Two-phase repair G-code generation
        │      Phase 1: Mill all defects (T1)
        │      Phase 2: Deposit underextrusion (T0)
        │      + IR drying (M20) + camera re-scan (M311)
        ├─ G-code validation
        ├─ Stage .tap file in controller-visible directory
        │
        ▼
    Returns dict:
        action = "continue" | "repair"
        tap_file = path to staged .tap
        defect_count, repair_area, etc.

Usage
-----
    from champ_integration import adaptive_repair_decision, DuetHandoff

    # --- Option A: simple function call ---
    result = adaptive_repair_decision(
        image_path="D:/Camera/layer_01.bmp",
        z_height=0.4,
        layer_number=1,
    )
    if result["action"] == "repair":
        print(f"Load {result['tap_file']} into controller")

    # --- Option B: Duet Net staging ---
    handoff = DuetHandoff(staging_dir="D:/CHAMP/repair_queue")
    result = handoff.process_and_stage(
        image_path="D:/Camera/layer_01.bmp",
        z_height=0.4,
        sample_number=1,
        layer_number=1,
    )
    # .tap file is now in D:/CHAMP/repair_queue/1_repair.tap
    # Duet Net sends it to the controller via serial firmware
"""

from __future__ import annotations

import json
import shutil
import time
from dataclasses import dataclass, field
from datetime import datetime
from pathlib import Path
from typing import Optional

from config import (
    CONFIDENCE_THRESHOLD,
    IMAGE_SIZE,
    IOU_THRESHOLD,
    IR_DRY_TIME_S,
    LAYER_HEIGHT_MM,
    MAX_REPAIR_RETRIES,
    OUTPUT_DIR,
    REPAIR_EXTRUSION_MULTIPLIER,
)
from coordinate_mapping import PixelToBedMapper
from defect_detection import DefectDetector
from gcode_validator import GCodeValidator
from repair_toolpath import generate_repair_gcode


# ═════════════════════════════════════════════════════════════════════
#  Core integration function  (drop-in for process_results)
# ═════════════════════════════════════════════════════════════════════

def adaptive_repair_decision(
    image_path: str | Path,
    z_height: float = LAYER_HEIGHT_MM,
    layer_number: int = 0,
    confidence: float = CONFIDENCE_THRESHOLD,
    iou: float = IOU_THRESHOLD,
    imgsz: int = IMAGE_SIZE,
    output_dir: str | Path | None = None,
    detector: DefectDetector | None = None,
) -> dict:
    """
    Drop-in replacement for ``CHAMP_monitoring.process_results()``.

    Runs the full adaptive repair pipeline on a single camera image
    and returns a decision dict.

    Parameters
    ----------
    image_path : path
        Camera image (.bmp) of the printed layer.
    z_height : float
        Current layer Z height in mm.
    layer_number : int
        Layer index (for file naming and logging).
    confidence : float
        YOLOv8 confidence threshold.
    iou : float
        NMS IoU threshold.
    imgsz : int
        YOLOv8 inference image size.
    output_dir : path, optional
        Where to save repair files.  Defaults to ``output/integration/``.
    detector : DefectDetector, optional
        Pre-loaded detector (avoids reloading the model each call).

    Returns
    -------
    dict with keys:
        action : str
            ``"continue"`` (no defects) or ``"repair"`` (defects found).
        tap_file : str or None
            Absolute path to the generated ``.tap`` file, or None.
        defect_count : int
        overextrusions : int
        underextrusions : int
        repair_area_mm2 : float
        area_savings_pct : float
        validation : str
            ``"PASS"`` or ``"FAIL"``.
        inference_time_s : float
        total_time_s : float
    """
    image_path = Path(image_path).resolve()
    if not image_path.exists():
        raise FileNotFoundError(f"Image not found: {image_path}")

    if output_dir is None:
        output_dir = OUTPUT_DIR / "integration"
    output_dir = Path(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    t_start = time.time()

    # ── Detection ─────────────────────────────────────────────────
    if detector is None:
        detector = DefectDetector()

    t0 = time.time()
    result = detector.detect(
        image_path,
        confidence=confidence,
        iou=iou,
        imgsz=imgsz,
        layer_number=layer_number,
    )
    t_detect = time.time() - t0

    n_over = sum(1 for d in result.defects if d.class_name == "Overextrusion")
    n_under = sum(1 for d in result.defects if d.class_name == "Underextrusion")

    # ── No defects → continue ────────────────────────────────────
    if len(result.defects) == 0:
        return {
            "action": "continue",
            "tap_file": None,
            "defect_count": 0,
            "overextrusions": 0,
            "underextrusions": 0,
            "repair_area_mm2": 0.0,
            "area_savings_pct": 100.0,
            "validation": "N/A",
            "inference_time_s": round(t_detect, 3),
            "total_time_s": round(time.time() - t_start, 3),
        }

    # ── Coordinate mapping ───────────────────────────────────────
    mapper = PixelToBedMapper.from_image(image_path)
    mapped = mapper.map_layer(result)

    # ── Repair G-code generation ─────────────────────────────────
    layer_tag = f"layer{layer_number}"
    gcode_path = output_dir / f"repair_{layer_tag}.gcode"
    tap_path = output_dir / f"repair_{layer_tag}.tap"

    gcode_text = generate_repair_gcode(
        mapped, z_height=z_height, output_path=gcode_path,
    )
    tap_path.write_text(gcode_text, encoding="utf-8")

    # ── Validation ───────────────────────────────────────────────
    validator = GCodeValidator()
    report = validator.validate_file(gcode_path)
    validation_status = "PASS" if report.is_valid else "FAIL"

    # ── Metrics ──────────────────────────────────────────────────
    part_area = 40.0 * 40.0
    repair_area = sum(d.bed_bbox.area for d in mapped.mapped_defects)
    savings_pct = (1.0 - repair_area / part_area) * 100

    t_total = time.time() - t_start

    return {
        "action": "repair",
        "tap_file": str(tap_path),
        "defect_count": len(result.defects),
        "overextrusions": n_over,
        "underextrusions": n_under,
        "repair_area_mm2": round(repair_area, 2),
        "area_savings_pct": round(savings_pct, 1),
        "validation": validation_status,
        "inference_time_s": round(t_detect, 3),
        "total_time_s": round(t_total, 3),
    }


# ═════════════════════════════════════════════════════════════════════
#  Duet Net File Handoff
# ═════════════════════════════════════════════════════════════════════

@dataclass
class DuetHandoff:
    """
    Manages the file-based handoff between the repair pipeline and the
    CHAMP controller via Duet Net serial firmware.

    Workflow
    --------
    1. Repair pipeline generates ``repair_layerN.tap`` in a local dir.
    2. ``DuetHandoff`` copies the ``.tap`` to the **staging directory**
       that Duet Net monitors (e.g. a USB drive or network share).
    3. The file is renamed to match the CHAMP naming convention:
       ``{sample_number}_repair.tap``  (analogous to ``{N}_comp.tap``).
    4. Duet Net sends the file to the controller via serial firmware.

    The staging directory and naming convention can be configured to
    match the specific CHAMP setup.

    Parameters
    ----------
    staging_dir : path
        Directory that Duet Net monitors for new ``.tap`` files.
    naming_pattern : str
        Python format string for the staged file name.
        Available keys: ``sample``, ``layer``, ``timestamp``.
        Default: ``"{sample}_repair.tap"``
    """

    staging_dir: Path = Path("D:/CHAMP/repair_queue")
    naming_pattern: str = "{sample}_repair.tap"
    _detector: Optional[DefectDetector] = field(default=None, repr=False)

    def __post_init__(self):
        self.staging_dir = Path(self.staging_dir)

    def _get_detector(self) -> DefectDetector:
        if self._detector is None:
            self._detector = DefectDetector()
        return self._detector

    def process_and_stage(
        self,
        image_path: str | Path,
        z_height: float = LAYER_HEIGHT_MM,
        sample_number: int = 0,
        layer_number: int = 0,
        confidence: float = CONFIDENCE_THRESHOLD,
    ) -> dict:
        """
        Run the adaptive repair pipeline and stage the ``.tap`` file
        for Duet Net.

        Returns the same dict as ``adaptive_repair_decision()`` with
        an additional ``staged_file`` key pointing to the Duet-ready
        file.
        """
        # Generate repair in a temporary local directory
        local_dir = OUTPUT_DIR / "integration" / f"sample_{sample_number}"
        local_dir.mkdir(parents=True, exist_ok=True)

        result = adaptive_repair_decision(
            image_path=image_path,
            z_height=z_height,
            layer_number=layer_number,
            confidence=confidence,
            output_dir=local_dir,
            detector=self._get_detector(),
        )

        if result["action"] == "continue":
            result["staged_file"] = None
            return result

        # Stage the .tap file for Duet Net
        self.staging_dir.mkdir(parents=True, exist_ok=True)
        staged_name = self.naming_pattern.format(
            sample=sample_number,
            layer=layer_number,
            timestamp=datetime.now().strftime("%H%M%S"),
        )
        staged_path = self.staging_dir / staged_name
        shutil.copy2(result["tap_file"], staged_path)

        result["staged_file"] = str(staged_path)
        return result

    def clear_staging(self):
        """Remove all .tap files from the staging directory."""
        if self.staging_dir.exists():
            for f in self.staging_dir.glob("*.tap"):
                f.unlink()


# ═════════════════════════════════════════════════════════════════════
#  Integration status / diagnostics
# ═════════════════════════════════════════════════════════════════════

def check_integration_readiness() -> dict:
    """
    Run pre-flight checks for CHAMP machine integration.

    Returns a dict of check names → pass/fail with messages,
    useful for verifying the setup before a test day.
    """
    checks = {}

    # 1. YOLOv8 model available
    from config import MODEL_PATH
    checks["yolo_model"] = {
        "pass": MODEL_PATH.exists(),
        "path": str(MODEL_PATH),
        "message": "OK" if MODEL_PATH.exists() else "Model file not found",
    }

    # 2. Config values are non-placeholder
    from config import TOOL_PARK_X, TOOL_PARK_Y, TOOL_PARK_Z
    atc_placeholder = (TOOL_PARK_X == 0.0 and TOOL_PARK_Y == 0.0)
    checks["atc_park_position"] = {
        "pass": not atc_placeholder,
        "values": {"x": TOOL_PARK_X, "y": TOOL_PARK_Y, "z": TOOL_PARK_Z},
        "message": ("OK" if not atc_placeholder
                    else "ATC park X/Y are still at placeholder (0, 0) — "
                         "update config.py with real CHAMP ATC coordinates"),
    }

    # 3. IR drying configured
    checks["ir_drying"] = {
        "pass": IR_DRY_TIME_S > 0,
        "time_s": IR_DRY_TIME_S,
        "message": f"IR drying: {IR_DRY_TIME_S}s",
    }

    # 4. Re-inspection retries
    checks["reinspection"] = {
        "pass": MAX_REPAIR_RETRIES >= 1,
        "max_retries": MAX_REPAIR_RETRIES,
        "message": f"Max {MAX_REPAIR_RETRIES} retries configured",
    }

    # 5. Extrusion multiplier
    checks["extrusion_multiplier"] = {
        "pass": True,
        "value": REPAIR_EXTRUSION_MULTIPLIER,
        "message": (f"{REPAIR_EXTRUSION_MULTIPLIER}x "
                    f"{'(default — consider 1.05-1.10 for shrinkage compensation)'
                       if REPAIR_EXTRUSION_MULTIPLIER == 1.0 else ''}"),
    }

    # Summary
    n_pass = sum(1 for c in checks.values() if c["pass"])
    n_total = len(checks)
    checks["_summary"] = {
        "pass": n_pass == n_total,
        "message": f"{n_pass}/{n_total} checks passed",
    }

    return checks


# ═════════════════════════════════════════════════════════════════════
#  CLI
# ═════════════════════════════════════════════════════════════════════

def main():
    import argparse

    parser = argparse.ArgumentParser(
        description="CHAMP Integration Wrapper — adaptive repair decision",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""\
Examples:
  # Run on a single image:
  python champ_integration.py --image D:\\Camera\\layer_01.bmp

  # Stage for Duet Net:
  python champ_integration.py --image photo.bmp --stage D:\\CHAMP\\queue

  # Pre-flight check:
  python champ_integration.py --check
""",
    )
    parser.add_argument(
        "--image", type=str,
        help="Camera image to process",
    )
    parser.add_argument(
        "--z", type=float, default=LAYER_HEIGHT_MM,
        help=f"Layer Z height in mm (default: {LAYER_HEIGHT_MM})",
    )
    parser.add_argument(
        "--conf", type=float, default=CONFIDENCE_THRESHOLD,
        help=f"Confidence threshold (default: {CONFIDENCE_THRESHOLD})",
    )
    parser.add_argument(
        "--stage", type=str, default=None,
        help="Staging directory for Duet Net handoff",
    )
    parser.add_argument(
        "--check", action="store_true",
        help="Run integration pre-flight checks",
    )

    args = parser.parse_args()

    if args.check:
        print("\n  CHAMP Integration Pre-flight Checks")
        print("  " + "=" * 45)
        checks = check_integration_readiness()
        for name, info in checks.items():
            if name.startswith("_"):
                continue
            status = "PASS" if info["pass"] else "FAIL"
            print(f"  [{status}] {name}: {info['message']}")
        summary = checks["_summary"]
        print("  " + "-" * 45)
        print(f"  {summary['message']}")
        return

    if args.image is None:
        parser.error("--image is required (unless using --check)")

    if args.stage:
        handoff = DuetHandoff(staging_dir=Path(args.stage))
        result = handoff.process_and_stage(
            image_path=args.image,
            z_height=args.z,
            confidence=args.conf,
        )
        if result["staged_file"]:
            print(f"\n  Staged for Duet Net: {result['staged_file']}")
    else:
        result = adaptive_repair_decision(
            image_path=args.image,
            z_height=args.z,
            confidence=args.conf,
        )

    print(f"\n  Decision: {result['action']}")
    if result["tap_file"]:
        print(f"  TAP file: {result['tap_file']}")
    print(f"  Defects : {result['defect_count']} "
          f"(over={result['overextrusions']}, "
          f"under={result['underextrusions']})")
    print(f"  Time    : {result['total_time_s']}s")


if __name__ == "__main__":
    main()
