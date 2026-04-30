# src/champ_sequence.py
"""
CHAMP Full Sequence — Print → Scan → Detect → Repair
====================================================

Executes the complete adaptive repair workflow for a single G-code
file on the CHAMP machine.

Sequence
--------
    1. PRINT   : Load and send the AM G-code (e.g. 1.gcode / 1_comp.tap)
    2. SCAN    : Trigger camera capture  (placeholder — TODO: add camera API)
    3. DETECT  : Run YOLOv8 on the captured image to find defects
    4. REPAIR  : Generate repair G-code with tool changes:
                   Phase 1 → pick up mill  → skim overextrusion
                   Phase 2 → return mill, pick up nozzle → deposit underextrusion

The output is a single `.tap` file ready to be loaded into the
CHAMP controller for the repair pass.

Usage
-----
    # Run on sample 1 with existing camera image:
    python champ_sequence.py --sample 1_13_35

    # Run with a specific camera image (skip scan step):
    python champ_sequence.py --sample 1_13_35 --image path/to/photo.bmp

    # Specify confidence threshold:
    python champ_sequence.py --sample 1_13_35 --conf 0.85

    # Specify layer Z height:
    python champ_sequence.py --sample 1_13_35 --z 0.4
"""

from __future__ import annotations

import argparse
import json
import sys
import time
from datetime import datetime
from pathlib import Path
from typing import Optional

from config import (
    AM_GCODE_DIR,
    COMPILED_GCODE_DIR,
    CONFIDENCE_THRESHOLD,
    IMAGE_SIZE,
    IOU_THRESHOLD,
    LAYER_HEIGHT_MM,
    OUTPUT_DIR,
    PROJECT_DATA_DIR,
)
from coordinate_mapping import PixelToBedMapper
from defect_detection import DefectDetector, find_sample_images
from gcode_validator import GCodeValidator, plot_toolpath
from overlay_visualisation import overlay_for_sample
from repair_toolpath import generate_repair_gcode


# ═══════════════════════════════════════════════════════════════════════
#  STEP 1: PRINT
# ═══════════════════════════════════════════════════════════════════════

def step_print(sample_name: str) -> dict:
    """
    Locate the AM G-code for this sample.

    On the real CHAMP machine, this step would send the G-code to the
    controller.  Here we just verify it exists and display its details.
    """
    # The sample number is the first part of the folder name (e.g. "1" from "1_13_35")
    sample_num = sample_name.split("_")[0]

    # Check for the compiled .tap (production) or the raw .gcode
    tap_path   = COMPILED_GCODE_DIR / f"{sample_num}_comp.tap"
    gcode_path = AM_GCODE_DIR / f"{sample_num}.gcode"

    am_file = None
    if tap_path.exists():
        am_file = tap_path
    elif gcode_path.exists():
        am_file = gcode_path

    if am_file is None:
        print(f"  [print] WARNING: No AM G-code found for sample {sample_num}")
        print(f"          Looked for: {tap_path.name}, {gcode_path.name}")
        return {"am_gcode": None, "lines": 0}

    lines = am_file.read_text(encoding="utf-8").splitlines()
    print(f"  [print] AM G-code : {am_file.name}  ({len(lines)} lines)")
    print(f"          Path      : {am_file}")
    print()
    print(f"  ┌──────────────────────────────────────────────────┐")
    print(f"  │  On the CHAMP machine, load and run this file    │")
    print(f"  │  to print the layer. Then proceed to scanning.   │")
    print(f"  └──────────────────────────────────────────────────┘")

    return {"am_gcode": str(am_file), "lines": len(lines)}


# ═══════════════════════════════════════════════════════════════════════
#  STEP 2: SCAN (Camera Capture)
# ═══════════════════════════════════════════════════════════════════════

def step_scan(
    sample_dir: Path,
    image_override: Optional[Path] = None,
) -> Optional[Path]:
    """
    Capture or locate the camera image for defect detection.

    If *image_override* is given, use that image directly.
    Otherwise, look for existing camera images in the sample folder.

    TODO: Replace the fallback with the actual CHAMP camera API
    when the camera capture script is available.
    """
    if image_override is not None:
        image_override = Path(image_override).resolve()
        if image_override.exists():
            print(f"  [scan] Using provided image: {image_override.name}")
            return image_override
        else:
            print(f"  [scan] ERROR: Image not found: {image_override}")
            return None

    # ── Camera capture placeholder ───────────────────────────────────
    # TODO: Insert camera capture code here when available.
    #
    # The CHAMP camera capture script should:
    #   1. Trigger the camera to take a photo of the printed layer
    #   2. Save the image as a .bmp file
    #   3. Return the path to the saved image
    #
    # Example (pseudocode):
    #   from champ_camera import capture_image
    #   image_path = capture_image(save_dir=sample_dir / "Camera")
    #   return image_path
    #
    # For now, fall back to existing images in the sample folder.
    # ─────────────────────────────────────────────────────────────────

    images = find_sample_images(sample_dir)
    if images:
        print(f"  [scan] Found existing camera image: {images[0].name}")
        print(f"         (Using existing image — camera capture not yet integrated)")
        return images[0]

    print(f"  [scan] No camera image available.")
    print(f"         To use this step, either:")
    print(f"           --image <path>   to specify an image file")
    print(f"           or place a .bmp in {sample_dir / 'Camera'}")
    return None


# ═══════════════════════════════════════════════════════════════════════
#  STEP 3: DETECT (YOLOv8 Inference)
# ═══════════════════════════════════════════════════════════════════════

def step_detect(
    image_path: Path,
    confidence: float = CONFIDENCE_THRESHOLD,
    iou: float = IOU_THRESHOLD,
    imgsz: int = IMAGE_SIZE,
):
    """Run live YOLOv8 defect detection on the camera image."""
    print(f"  [detect] Running YOLOv8 (imgsz={imgsz}, conf={confidence}) …")

    t0 = time.time()
    detector = DefectDetector()
    result = detector.detect(
        image_path, confidence=confidence, iou=iou, imgsz=imgsz, layer_number=0,
    )
    elapsed = time.time() - t0

    n_over = sum(1 for d in result.defects if d.class_name == "Overextrusion")
    n_under = sum(1 for d in result.defects if d.class_name == "Underextrusion")

    print(f"           {len(result.defects)} defects in {elapsed:.2f}s")
    print(f"           Overextrusion: {n_over}   Underextrusion: {n_under}")

    return result


# ═══════════════════════════════════════════════════════════════════════
#  STEP 4: REPAIR (Coordinate mapping + G-code generation)
# ═══════════════════════════════════════════════════════════════════════

def step_repair(
    result,
    image_path: Path,
    z_height: float,
    output_dir: Path,
    sample_name: str,
    show_plots: bool = False,
) -> Optional[Path]:
    """
    Map defects to bed coordinates and generate repair G-code.

    The repair sequence is:
        Phase 1: Pick up mill → skim all overextrusion defects
        Phase 2: Return mill, pick up nozzle → deposit into underextrusion voids
    """
    # Map pixel → bed coordinates
    print(f"\n  [repair] Mapping {len(result.defects)} defects → bed coordinates …")
    mapper = PixelToBedMapper.from_image(image_path)
    mapped = mapper.map_layer(result)

    if not mapped.has_defects:
        print(f"  [repair] No defects to repair.")
        return None

    # Print defect summary
    for d in mapped.mapped_defects:
        bb = d.bed_bbox
        print(f"           {d.class_name:<16s} conf={d.confidence:.2f}  "
              f"bed=({bb.x_min:+6.1f},{bb.y_min:+6.1f})"
              f"→({bb.x_max:+6.1f},{bb.y_max:+6.1f}) mm")

    # Generate repair G-code (with tool changes)
    print(f"\n  [repair] Generating repair G-code (Z={z_height} mm) …")

    gcode_path = output_dir / f"repair_{sample_name}_layer0.gcode"
    tap_path   = output_dir / f"repair_{sample_name}_layer0.tap"

    gcode_text = generate_repair_gcode(
        mapped, z_height=z_height, output_path=gcode_path,
    )

    # Save .tap copy for CHAMP
    tap_path.write_text(gcode_text, encoding="utf-8")

    n_lines = len(gcode_text.splitlines())
    print(f"           Generated {n_lines} lines")
    print(f"           G-code : {gcode_path.name}")
    print(f"           TAP    : {tap_path.name}  ← load into CHAMP")

    # Validate
    print(f"\n  [repair] Validating …")
    validator = GCodeValidator()
    report = validator.validate_file(gcode_path)
    print(f"           {report.summary().splitlines()[0]}")

    report_path = gcode_path.with_suffix(".validation.txt")
    report_path.write_text(report.summary(), encoding="utf-8")

    # Toolpath preview
    preview_path = gcode_path.with_suffix(".png")
    plot_toolpath(
        gcode_text,
        title=f"Repair toolpath — {sample_name}",
        show=show_plots,
        save_path=preview_path,
    )
    print(f"           Preview : {preview_path.name}")

    return tap_path


# ═══════════════════════════════════════════════════════════════════════
#  FULL SEQUENCE
# ═══════════════════════════════════════════════════════════════════════

def run_sequence(
    sample_name: str,
    z_height: float = LAYER_HEIGHT_MM,
    confidence: float = CONFIDENCE_THRESHOLD,
    image_override: Optional[Path] = None,
    show_plots: bool = False,
) -> dict:
    """
    Execute the complete Print → Scan → Detect → Repair sequence.
    """
    sample_dir = PROJECT_DATA_DIR / sample_name
    output_dir = OUTPUT_DIR / "v1_sequence" / sample_name
    output_dir.mkdir(parents=True, exist_ok=True)

    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")

    print()
    print("╔" + "═" * 58 + "╗")
    print("║   CHAMP ADAPTIVE REPAIR — FULL SEQUENCE                  ║")
    print("╠" + "═" * 58 + "╣")
    print(f"║   Sample  : {sample_name:<44s} ║")
    print(f"║   Z height: {z_height:<6.1f} mm                                    ║")
    print(f"║   Conf    : {confidence:<6.2f}                                      ║")
    print(f"║   Output  : output/{sample_name + '/':<42s} ║")
    print("╚" + "═" * 58 + "╝")

    t_start = time.time()
    summary = {"sample": sample_name, "timestamp": timestamp, "z": z_height,
               "confidence": confidence}

    # ── STEP 1: PRINT ────────────────────────────────────────────────
    print(f"\n{'─'*60}")
    print(f"  STEP 1/4 — PRINT")
    print(f"{'─'*60}")
    print_info = step_print(sample_name)
    summary["am_gcode"] = print_info["am_gcode"]

    # ── STEP 2: SCAN ─────────────────────────────────────────────────
    print(f"\n{'─'*60}")
    print(f"  STEP 2/4 — SCAN (camera capture)")
    print(f"{'─'*60}")
    image_path = step_scan(sample_dir, image_override)
    if image_path is None:
        print("\n  SEQUENCE ABORTED: No image available.")
        summary["status"] = "aborted_no_image"
        return summary

    summary["image"] = str(image_path)

    # ── STEP 3: DETECT ───────────────────────────────────────────────
    print(f"\n{'─'*60}")
    print(f"  STEP 3/4 — DETECT (YOLOv8 live inference)")
    print(f"{'─'*60}")
    result = step_detect(image_path, confidence=confidence)
    summary["defects_found"] = len(result.defects)
    summary["overextrusions"] = sum(
        1 for d in result.defects if d.class_name == "Overextrusion")
    summary["underextrusions"] = sum(
        1 for d in result.defects if d.class_name == "Underextrusion")

    if len(result.defects) == 0:
        print("\n  ✓ Layer is clean — no repair needed.")
        summary["status"] = "clean"
        summary["repair_needed"] = False
        _save_sequence_summary(summary, output_dir, timestamp)
        return summary

    # ── STEP 4: REPAIR ───────────────────────────────────────────────
    print(f"\n{'─'*60}")
    print(f"  STEP 4/4 — REPAIR (tool change + G-code generation)")
    print(f"{'─'*60}")
    print(f"  Repair order:")
    print(f"    Phase 1: Pick up MILL  → mill ALL bounding boxes")
    print(f"             (overextrusion skim + underextrusion cavity prep)")
    print(f"    Phase 2: Return mill, pick up NOZZLE → fill underextrusion cavities")
    tap_path = step_repair(
        result, image_path, z_height, output_dir, sample_name,
        show_plots=show_plots,
    )

    # ── Overlay visualisation ────────────────────────────────────────
    print(f"\n  [overlay] Generating overlay …")
    try:
        overlay_path = overlay_for_sample(
            sample_name, show=show_plots, include_original_toolpath=True,
        )
        if overlay_path:
            print(f"           Saved: {overlay_path.name}")
    except Exception as e:
        print(f"           Overlay skipped: {e}")

    # ── Summary ──────────────────────────────────────────────────────
    elapsed = time.time() - t_start
    summary["status"] = "repair_generated"
    summary["repair_needed"] = True
    summary["tap_file"] = str(tap_path) if tap_path else None
    summary["total_time_s"] = round(elapsed, 1)

    _save_sequence_summary(summary, output_dir, timestamp)

    print(f"\n╔{'═'*58}╗")
    print(f"║   SEQUENCE COMPLETE — {elapsed:.1f}s total{' '*(32-len(f'{elapsed:.1f}'))}║")
    if tap_path:
        tap_name = tap_path.name
        padding = 53 - len(tap_name)
        print(f"║   Load: {tap_name}{' '*padding}║")
    print(f"║   into the CHAMP controller to execute repair.           ║")
    print(f"╚{'═'*58}╝\n")

    return summary


def _save_sequence_summary(summary: dict, output_dir: Path, timestamp: str):
    path = output_dir / f"sequence_summary_{timestamp}.json"
    path.write_text(json.dumps(summary, indent=2), encoding="utf-8")


# ═══════════════════════════════════════════════════════════════════════
#  CLI
# ═══════════════════════════════════════════════════════════════════════

def main():
    parser = argparse.ArgumentParser(
        description="CHAMP Full Sequence: Print → Scan → Detect → Repair",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Run on sample 1 (uses existing camera image):
  python champ_sequence.py --sample 1_13_35

  # Run with a specific camera image:
  python champ_sequence.py --sample 1_13_35 --image D:\\photo.bmp

  # Custom confidence:
  python champ_sequence.py --sample 1_13_35 --conf 0.90
        """,
    )
    parser.add_argument(
        "--sample", type=str, default="1_13_35",
        help="Sample folder name (default: 1_13_35)",
    )
    parser.add_argument(
        "--image", type=str, default=None,
        help="Path to camera image (skips scan step)",
    )
    parser.add_argument(
        "--conf", type=float, default=CONFIDENCE_THRESHOLD,
        help=f"Confidence threshold (default: {CONFIDENCE_THRESHOLD})",
    )
    parser.add_argument(
        "--z", type=float, default=LAYER_HEIGHT_MM,
        help=f"Layer Z height in mm (default: {LAYER_HEIGHT_MM})",
    )
    parser.add_argument(
        "--show", action="store_true",
        help="Show plots interactively",
    )

    args = parser.parse_args()

    img = Path(args.image) if args.image else None
    run_sequence(
        sample_name=args.sample,
        z_height=args.z,
        confidence=args.conf,
        image_override=img,
        show_plots=args.show,
    )


if __name__ == "__main__":
    main()
