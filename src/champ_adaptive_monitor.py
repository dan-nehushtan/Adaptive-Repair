# src/champ_adaptive_monitor.py
"""
CHAMP Adaptive Process Monitor
===============================

Integrates CHAMP process monitoring with **per-defect adaptive repair**
across all 120 samples.

Detection modes
---------------
  Cached (default):  reads the pre-existing ``Disk_Defects.txt`` in each
                     sample folder -- fully reproducible, directly comparable
                     to the original dataset.  Output: v3_cached_monitor/
  Live (--live):     runs YOLOv8_LSM inference on the camera image.
                     Output: v2_adaptive_monitor/

Key difference from the original CHAMP_monitoring approach
----------------------------------------------------------
  Original:  binary layer-level decision
             -> planarize (mill entire layer) OR rework (remove + reprint)
  Adaptive:  per-defect targeted repair
             -> mill only overextrusion bounding boxes (skim)
             -> mill underextrusion bounding boxes (clean cavity)
             -> deposit ceramic into underextrusion cavities only
             -> continue printing the next layer

Workflow per sample (simulated CHAMP layer-by-layer loop)
---------------------------------------------------------
    Step 1  PRINT       Load the AM G-code and simulate printing the part
    Step 2  CAPTURE     Load the camera .bmp image (simulated camera capture)
    Step 3  DETECT      Read Disk_Defects.txt (cached) OR run YOLOv8_LSM (live)
    Step 4  DECIDE      No defects -> continue  |  Defects -> adaptive repair
    Step 5  MILL        Pick up T1, mill ALL defect bboxes
                          * overextrusion -> skim excess material
                          * underextrusion -> cut clean rectangular cavity
    Step 6  FILL        Return T1, pick up T0, deposit ceramic into
                        underextrusion cavities only
    Step 7  DRY         IR lamp drying of repaired ceramic (M20, 60s)
    Step 8  RE-INSPECT  Camera re-scan (M311) to verify repair success;
                        retry up to MAX_REPAIR_RETRIES times if defects remain
    Step 9  CONTINUE    Repair complete -> continue to next layer

Usage
-----
    # Process ALL 120 samples using cached Disk_Defects.txt (default):
    python champ_adaptive_monitor.py

    # Process a single sample (cached):
    python champ_adaptive_monitor.py --sample 1_13_35

    # Use live YOLO inference instead of cached data:
    python champ_adaptive_monitor.py --live

    # Skip overlay images (faster):
    python champ_adaptive_monitor.py --no-overlay

    # Custom confidence / Z height (live mode only):
    python champ_adaptive_monitor.py --live --conf 0.90 --z 0.8
"""

from __future__ import annotations

import argparse
import json
import shutil
import sys
import time
from datetime import datetime
from pathlib import Path
from typing import Optional

import numpy as np
from PIL import Image

# -- Project imports --------------------------------------------------
from config import (
    AM_GCODE_DIR,
    CONFIDENCE_THRESHOLD,
    COORD_GEOM_DIR,
    IMAGE_SIZE,
    IOU_THRESHOLD,
    IR_DRY_TIME_S,
    LAYER_HEIGHT_MM,
    MAX_REPAIR_RETRIES,
    OUTPUT_DIR,
    PROJECT_DATA_DIR,
    REPAIR_EXTRUSION_MULTIPLIER,
)
from coordinate_mapping import (
    MappedLayerResult,
    PixelToBedMapper,
    load_coordinate_geometry,
)
from defect_detection import (
    DefectDetector,
    LayerDetectionResult,
    find_defects_file,
    load_defects_from_file,
)
from gcode_validator import GCodeValidator, plot_toolpath
from repair_toolpath import generate_repair_gcode


# =====================================================================
#  Helper utilities
# =====================================================================

def _find_camera_image(sample_dir: Path) -> Optional[Path]:
    """Return the raw camera .bmp (excluding defectsImage files)."""
    cam_dir = sample_dir / "Camera"
    if not cam_dir.exists():
        return None
    for f in sorted(cam_dir.iterdir()):
        if f.suffix.lower() == ".bmp" and not f.name.lower().startswith("defects"):
            return f
    return None


def _find_am_gcode(sample_name: str) -> Optional[Path]:
    """Find the original AM G-code for a sample number."""
    sample_num = sample_name.split("_")[0]
    gcode_path = AM_GCODE_DIR / f"{sample_num}.gcode"
    return gcode_path if gcode_path.exists() else None


def _load_original_coords(sample_name: str) -> Optional[dict]:
    """Load coordinate geometry (original print toolpath) for overlay."""
    sample_num = sample_name.split("_")[0]
    geom_path = COORD_GEOM_DIR / f"{sample_num}_coordinate_geometry.txt"
    if not geom_path.exists():
        return None
    try:
        geom_data = load_coordinate_geometry(geom_path)
        if geom_data:
            return geom_data[0].get("Coordinate Data")
    except Exception:
        pass
    return None


def _discover_all_samples() -> list[str]:
    """Return sorted list of all numbered sample folder names."""
    import re
    samples = []
    for d in PROJECT_DATA_DIR.iterdir():
        if d.is_dir() and re.match(r"^\d+_\d+_\d+$", d.name):
            samples.append(d.name)
    # Sort by numeric sample number (first component)
    samples.sort(key=lambda s: int(s.split("_")[0]))
    return samples


# =====================================================================
#  Adaptive Process Monitor
# =====================================================================

class AdaptiveProcessMonitor:
    """
    CHAMP-style process monitor with per-defect adaptive repair.

    Processes one or all 120 samples through the full CHAMP workflow:
      Print -> Capture -> Detect -> Decide -> Mill -> Fill ->
      Dry -> Re-inspect -> Continue

    Instead of binary planarize/rework GPIO signals, this monitor
    generates targeted repair G-code for each detected defect:
      - Overextrusion bboxes  -> milled (skim) with T1
      - Underextrusion bboxes -> milled (cavity) then filled with T0
      - IR drying after deposition (M20)
      - Post-repair camera re-scan (M311) with up to 2 retries
    """

    def __init__(
        self,
        z_height: float = LAYER_HEIGHT_MM,
        confidence: float = CONFIDENCE_THRESHOLD,
        iou: float = IOU_THRESHOLD,
        imgsz: int = IMAGE_SIZE,
        generate_overlay: bool = True,
        use_cached: bool = True,
    ):
        self.z_height = z_height
        self.confidence = confidence
        self.iou = iou
        self.imgsz = imgsz
        self.generate_overlay_flag = generate_overlay
        self.use_cached = use_cached

        # Output folder: separate cached vs live runs so both are preserved
        if use_cached:
            self.output_root = OUTPUT_DIR / "v3_cached_monitor"
        else:
            self.output_root = OUTPUT_DIR / "v2_adaptive_monitor"

        # Lazy-loaded detector (only used in live mode)
        self.detector: Optional[DefectDetector] = None

        # Batch-level accumulators
        self.all_summaries: list[dict] = []

    # -- Model loading ------------------------------------------------

    def _load_model(self) -> None:
        """Load the YOLOv8_LSM model (lazy, first call only)."""
        if self.detector is not None:
            return
        print("\n  Loading YOLOv8_LSM model ...", end=" ", flush=True)
        t0 = time.time()
        self.detector = DefectDetector()
        print(f"done ({time.time() - t0:.1f}s)")
        print(f"  Model  : {self.detector.model_path.name}")
        print(f"  Classes: {self.detector._class_names}")

    # -- Run all samples ----------------------------------------------

    def run_all(self, samples: Optional[list[str]] = None) -> list[dict]:
        """
        Process every sample through the full CHAMP workflow.

        Parameters
        ----------
        samples : list of sample names, or None for all 120.

        Returns
        -------
        list of per-sample summary dicts.
        """
        if samples is None:
            samples = _discover_all_samples()

        n = len(samples)
        t_batch_start = time.time()
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")

        # -- Clean output directory --------------------------------
        if self.output_root.exists():
            print(f"\n  Clearing previous output: {self.output_root}")
            shutil.rmtree(self.output_root)
        self.output_root.mkdir(parents=True, exist_ok=True)

        # -- Banner ------------------------------------------------
        print("\n" + "=" * 70)
        print("  CHAMP ADAPTIVE PROCESS MONITOR -- BATCH RUN")
        print("=" * 70)
        detect_mode = "Cached (Disk_Defects.txt)" if self.use_cached else f"Live YOLOv8 (imgsz={self.imgsz}, conf={self.confidence})"
        print(f"  Samples     : {n}")
        print(f"  Detection   : {detect_mode}")
        print(f"  Output root : {self.output_root}")
        print(f"  Z height    : {self.z_height} mm")
        print(f"  Overlay     : {'yes' if self.generate_overlay_flag else 'no'}")
        print("=" * 70)

        # Pre-load YOLO model only if running live inference
        if not self.use_cached:
            self._load_model()

        self.all_summaries = []

        for idx, sample_name in enumerate(samples, 1):
            print(f"\n{'#' * 70}")
            print(f"  SAMPLE {idx}/{n}: {sample_name}")
            print(f"{'#' * 70}")

            summary = self.process_sample(sample_name, idx, n)
            self.all_summaries.append(summary)

        # -- Batch summary -----------------------------------------
        t_batch_total = time.time() - t_batch_start
        batch_report = self._generate_batch_report(timestamp, t_batch_total)

        return self.all_summaries

    # ==================================================================
    #  Per-sample workflow: the 7-step CHAMP loop
    # ==================================================================

    def process_sample(
        self,
        sample_name: str,
        idx: int = 1,
        total: int = 1,
    ) -> dict:
        """
        Execute the full CHAMP adaptive workflow for one sample:
          Step 1 PRINT  ->  Step 2 CAPTURE  ->  Step 3 DETECT  ->
          Step 4 DECIDE ->  Step 5 MILL     ->  Step 6 FILL    ->
          Step 7 DRY    ->  Step 8 RE-INSPECT -> Step 9 CONTINUE
        """
        t_start = time.time()
        sample_dir = PROJECT_DATA_DIR / sample_name
        out_dir = self.output_root / sample_name
        out_dir.mkdir(parents=True, exist_ok=True)

        if not sample_dir.exists():
            print(f"  ERROR: sample directory not found: {sample_dir}")
            return {"sample": sample_name, "error": "sample_not_found"}

        # ==============================================================
        #  STEP 1: PRINT -- load the AM G-code for this part
        # ==============================================================
        print(f"\n  Step 1/9  PRINT")
        am_gcode_path = _find_am_gcode(sample_name)
        if am_gcode_path:
            am_gcode_text = am_gcode_path.read_text(encoding="utf-8")
            n_am_lines = len(am_gcode_text.splitlines())
            print(f"    AM G-code : {am_gcode_path.name} ({n_am_lines} lines)")
        else:
            am_gcode_text = ""
            n_am_lines = 0
            print(f"    AM G-code : not found for sample {sample_name}")
        print(f"    [Simulated] Part printed at Z={self.z_height} mm")

        # ==============================================================
        #  STEP 2: CAPTURE -- load camera image
        # ==============================================================
        print(f"\n  Step 2/9  CAPTURE")
        image_path = _find_camera_image(sample_dir)
        if image_path is None:
            print(f"    ERROR: no camera image in {sample_dir / 'Camera'}")
            return {"sample": sample_name, "error": "no_camera_image"}

        with Image.open(image_path) as img:
            w, h = img.size
        print(f"    Image : {image_path.name}  ({w}x{h} px)")

        # ==============================================================
        #  STEP 3: DETECT -- cached Disk_Defects.txt or live YOLOv8
        # ==============================================================
        t0 = time.time()

        if self.use_cached:
            print(f"\n  Step 3/9  DETECT  (cached -- Disk_Defects.txt)")
            defects_file = find_defects_file(sample_dir)
            if defects_file is None:
                print(f"    ERROR: Disk_Defects.txt not found in {sample_dir}")
                return {"sample": sample_name, "error": "no_disk_defects_file"}
            layer_results = load_defects_from_file(defects_file)
            layer_result = layer_results[0] if layer_results else LayerDetectionResult(layer_number=0)
            print(f"    Source: {defects_file.name}")
        else:
            print(f"\n  Step 3/9  DETECT  (YOLOv8_LSM live, imgsz={self.imgsz}, "
                  f"conf={self.confidence})")
            layer_result = self.detector.detect(
                image_path,
                confidence=self.confidence,
                iou=self.iou,
                imgsz=self.imgsz,
                layer_number=0,
            )

        t_detect = time.time() - t0

        n_total = len(layer_result.defects)
        n_over = sum(1 for d in layer_result.defects
                     if d.class_name == "Overextrusion")
        n_under = sum(1 for d in layer_result.defects
                      if d.class_name == "Underextrusion")

        print(f"    Defects: {n_total}  "
              f"(over={n_over}, under={n_under})  "
              f"[{t_detect:.2f}s]")

        for i, d in enumerate(layer_result.defects, 1):
            bb = d.bbox
            print(f"      [{i:2d}] {d.class_name:<16s}  conf={d.confidence:.3f}  "
                  f"px=({bb.x1:.0f},{bb.y1:.0f})->({bb.x2:.0f},{bb.y2:.0f})")

        # ==============================================================
        #  STEP 4: DECIDE -- adaptive repair or continue
        # ==============================================================
        print(f"\n  Step 4/9  DECIDE")

        if n_total == 0:
            print(f"    DECISION: NO DEFECTS -- continue to next layer")
            t_total = time.time() - t_start
            summary = self._build_summary(
                sample_name, n_total, n_over, n_under,
                decision="continue", repair_needed=False,
                t_detect=t_detect, t_total=t_total,
            )
            self._save_sample_summary(summary, out_dir)
            self._print_sample_done(sample_name, summary, idx, total)
            return summary

        print(f"    DECISION: ADAPTIVE REPAIR")
        print(f"      Compared to CHAMP_monitoring binary approach:")
        if n_under > 0:
            print(f"        Original: rework entire layer (D6) -- "
                  f"remove + reprint all")
            print(f"        Adaptive: mill {n_over} over + "
                  f"{n_under} under bboxes, deposit under only")
        else:
            print(f"        Original: planarize entire layer (D5) -- "
                  f"mill everything")
            print(f"        Adaptive: mill ONLY {n_over} overextrusion bboxes")

        # Map pixel coords to bed mm
        mapper = PixelToBedMapper.from_image(image_path)
        mapped_layer = mapper.map_layer(layer_result)

        for i, d in enumerate(mapped_layer.mapped_defects, 1):
            bb = d.bed_bbox
            print(f"      [{i:2d}] {d.class_name:<16s}  "
                  f"bed=({bb.x_min:+.1f},{bb.y_min:+.1f})"
                  f"->({bb.x_max:+.1f},{bb.y_max:+.1f}) mm  "
                  f"{bb.width:.1f}x{bb.height:.1f}")

        # ==============================================================
        #  STEP 5: MILL -- pick up T1, mill all defect bounding boxes
        # ==============================================================
        print(f"\n  Step 5/9  MILL  (T1 milling tool)")
        print(f"    Pick up milling tool T1 via ATC")
        print(f"    Mill {n_over + n_under} bounding box(es):")
        if n_over > 0:
            print(f"      {n_over} overextrusion  -> skim excess "
                  f"at Z={self.z_height}")
        if n_under > 0:
            print(f"      {n_under} underextrusion -> cut clean cavity "
                  f"for re-fill")
        print(f"    Spindle on (M3 S1000), mill passes with Z-hops "
              f"between bboxes")
        print(f"    Spindle off (M5) after all milling complete")

        # ==============================================================
        #  STEP 6: FILL -- return T1, pick up T0, deposit underextrusion
        # ==============================================================
        print(f"\n  Step 6/9  FILL  (T0 ceramic nozzle)")
        if n_under > 0:
            print(f"    Return mill T1 -> pick up nozzle T0 via ATC")
            print(f"    Deposit ceramic into {n_under} underextrusion "
                  f"cavity(ies)")
            print(f"    Raster fill pattern with nozzle diameter overlap")
        else:
            print(f"    No underextrusion to fill -- return mill T1, "
                  f"pick up nozzle T0")
            print(f"    (overextrusion skimmed only, no deposition needed)")

        # Generate repair G-code (covers both Phase 1 mill + Phase 2 fill)
        gcode_path = out_dir / f"repair_{sample_name}.gcode"
        tap_path = out_dir / f"repair_{sample_name}.tap"

        t0 = time.time()
        gcode_text = generate_repair_gcode(
            mapped_layer,
            z_height=self.z_height,
            output_path=gcode_path,
        )
        t_gcode = time.time() - t0

        tap_path.write_text(gcode_text, encoding="utf-8")
        n_lines = len(gcode_text.splitlines())

        print(f"    Repair G-code: {gcode_path.name} ({n_lines} lines)")
        print(f"    TAP file     : {tap_path.name}")

        # Validate
        validator = GCodeValidator()
        report = validator.validate_file(gcode_path)
        status = "PASS" if report.is_valid else "FAIL"
        print(f"    Validation   : {status}")

        report_path = gcode_path.with_suffix(".validation.txt")
        report_path.write_text(report.summary(), encoding="utf-8")

        # Toolpath preview
        preview_path = out_dir / f"toolpath_{sample_name}.png"
        plot_toolpath(
            gcode_text,
            title=f"Adaptive Repair -- {sample_name} (Z={self.z_height}mm)",
            show=False,
            save_path=preview_path,
        )

        # Overlay visualisation
        if self.generate_overlay_flag:
            try:
                from overlay_visualisation import generate_overlay as gen_overlay
                original_coords = _load_original_coords(sample_name)
                overlay_path = out_dir / f"overlay_{sample_name}.png"
                detect_src = "Cached Disk_Defects.txt" if self.use_cached else "Live YOLOv8"
                gen_overlay(
                    image_path=image_path,
                    layer_result=layer_result,
                    mapped_layer=mapped_layer,
                    gcode_text=gcode_text,
                    mapper=mapper,
                    original_coords=original_coords,
                    title=(f"CHAMP Adaptive Monitor -- {sample_name}\n"
                           f"{detect_src} | {n_total} defects | "
                           f"Per-defect repair"),
                    save_path=overlay_path,
                    show=False,
                )
            except Exception as e:
                print(f"    Overlay failed: {e}")

        # ==============================================================
        #  STEP 7: DRY -- IR lamp drying of repaired ceramic
        # ==============================================================
        print(f"\n  Step 7/9  DRY  (IR lamp)")
        if n_under > 0:
            print(f"    IR drying deposited ceramic for {IR_DRY_TIME_S:.0f}s "
                  f"(M20 #620={IR_DRY_TIME_S:.0f} #621={self.z_height})")
            print(f"    [Simulated] Ceramic paste cured under IR lamp")
        else:
            print(f"    No deposition occurred -- IR drying skipped")
            print(f"    (overextrusion skim only, no wet paste to cure)")

        # ==============================================================
        #  STEP 8: RE-INSPECT -- camera re-scan to verify repair
        # ==============================================================
        print(f"\n  Step 8/9  RE-INSPECT  (M311 camera scan)")
        print(f"    Trigger camera scan to verify repair quality")
        print(f"    Max retries allowed: {MAX_REPAIR_RETRIES} "
              f"(matching CHAMP system)")
        # In batch simulation, we assume the repair succeeded on first
        # attempt since we cannot re-run the physical machine.  The
        # generated G-code includes the M311 command so the CHAMP
        # controller can perform the actual re-inspection.
        repair_attempts = 1
        print(f"    [Simulated] Re-inspection passed (attempt "
              f"{repair_attempts}/{MAX_REPAIR_RETRIES + 1})")
        print(f"    Note: on physical CHAMP, M311 triggers a real "
              f"camera scan.")
        print(f"          If defects remain, the repair loop repeats "
              f"(up to {MAX_REPAIR_RETRIES} retries).")

        # ==============================================================
        #  STEP 9: CONTINUE -- repair done, next layer
        # ==============================================================
        print(f"\n  Step 9/9  CONTINUE")

        # Efficiency stats
        part_area = 40.0 * 40.0
        repair_area = sum(d.bed_bbox.area for d in mapped_layer.mapped_defects)
        savings_pct = (1.0 - repair_area / part_area) * 100

        print(f"    Repair covers {repair_area:.1f} mm^2 of "
              f"{part_area:.0f} mm^2 -> "
              f"{savings_pct:.1f}% less than full-layer approach")
        print(f"    Extrusion multiplier: {REPAIR_EXTRUSION_MULTIPLIER:.2f}x")
        print(f"    [Simulated] Repair executed -> continuing to next layer")

        t_total = time.time() - t_start

        summary = self._build_summary(
            sample_name, n_total, n_over, n_under,
            decision="adaptive_repair", repair_needed=True,
            t_detect=t_detect, t_total=t_total,
            n_lines=n_lines, validation=status,
            tap_file=str(tap_path),
            repair_area=repair_area, savings_pct=savings_pct,
            mapped_defects=mapped_layer.mapped_defects,
            repair_attempts=repair_attempts,
        )
        self._save_sample_summary(summary, out_dir)
        self._print_sample_done(sample_name, summary, idx, total)
        return summary

    # -- Summary builders ---------------------------------------------

    def _build_summary(
        self,
        sample_name: str,
        n_total: int,
        n_over: int,
        n_under: int,
        *,
        decision: str,
        repair_needed: bool,
        t_detect: float,
        t_total: float,
        n_lines: int = 0,
        validation: str = "",
        tap_file: str = "",
        repair_area: float = 0.0,
        savings_pct: float = 0.0,
        mapped_defects=None,
        repair_attempts: int = 0,
    ) -> dict:
        summary = {
            "sample": sample_name,
            "z_height": self.z_height,
            "confidence_threshold": self.confidence,
            "defects_found": n_total,
            "overextrusions": n_over,
            "underextrusions": n_under,
            "decision": decision,
            "repair_needed": repair_needed,
            "inference_time_s": round(t_detect, 3),
            "total_time_s": round(t_total, 3),
        }
        if repair_needed:
            summary["repair_strategy"] = {
                "phase_1_mill_total": n_total,
                "phase_1_over_skim": n_over,
                "phase_1_under_cavity": n_under,
                "phase_2_deposit": n_under,
                "ir_dry_s": IR_DRY_TIME_S if n_under > 0 else 0,
                "extrusion_multiplier": REPAIR_EXTRUSION_MULTIPLIER,
                "repair_attempts": repair_attempts,
                "max_retries": MAX_REPAIR_RETRIES,
            }
            summary["gcode_lines"] = n_lines
            summary["validation"] = validation
            summary["tap_file"] = tap_file
            summary["repair_area_mm2"] = round(repair_area, 2)
            summary["area_savings_pct"] = round(savings_pct, 1)
            if mapped_defects:
                summary["defects"] = [
                    {
                        "class": d.class_name,
                        "confidence": round(d.confidence, 4),
                        "bed_bbox": {
                            "x_min": round(d.bed_bbox.x_min, 2),
                            "y_min": round(d.bed_bbox.y_min, 2),
                            "x_max": round(d.bed_bbox.x_max, 2),
                            "y_max": round(d.bed_bbox.y_max, 2),
                        },
                        "size_mm": {
                            "width": round(d.bed_bbox.width, 2),
                            "height": round(d.bed_bbox.height, 2),
                        },
                    }
                    for d in mapped_defects
                ]
        return summary

    def _save_sample_summary(self, summary: dict, out_dir: Path) -> None:
        path = out_dir / f"summary_{summary['sample']}.json"
        path.write_text(json.dumps(summary, indent=2), encoding="utf-8")

    def _print_sample_done(
        self, sample_name: str, summary: dict, idx: int, total: int,
    ) -> None:
        repair = summary.get("repair_needed", False)
        defects = summary.get("defects_found", 0)
        t = summary.get("total_time_s", 0)
        tag = "REPAIR" if repair else "CLEAN"
        print(f"\n  [{idx}/{total}] {sample_name}  {tag}  "
              f"defects={defects}  {t:.1f}s")

    # -- Batch report -------------------------------------------------

    def _generate_batch_report(
        self, timestamp: str, t_batch: float,
    ) -> dict:
        """Write a batch-level JSON report and print a summary table."""
        n = len(self.all_summaries)
        n_clean = sum(1 for s in self.all_summaries
                      if not s.get("repair_needed", False))
        n_repair = sum(1 for s in self.all_summaries
                       if s.get("repair_needed", False))
        n_err = sum(1 for s in self.all_summaries if "error" in s)

        total_defects = sum(s.get("defects_found", 0)
                            for s in self.all_summaries)
        total_over = sum(s.get("overextrusions", 0)
                         for s in self.all_summaries)
        total_under = sum(s.get("underextrusions", 0)
                          for s in self.all_summaries)
        total_repair_area = sum(s.get("repair_area_mm2", 0)
                                for s in self.all_summaries)
        avg_savings = (
            np.mean([s["area_savings_pct"] for s in self.all_summaries
                     if "area_savings_pct" in s])
            if n_repair > 0 else 0.0
        )
        avg_inference = np.mean([s.get("inference_time_s", 0)
                                 for s in self.all_summaries])

        batch = {
            "timestamp": timestamp,
            "total_samples": n,
            "clean_layers": n_clean,
            "repair_layers": n_repair,
            "errors": n_err,
            "total_defects": total_defects,
            "total_overextrusions": total_over,
            "total_underextrusions": total_under,
            "total_repair_area_mm2": round(total_repair_area, 2),
            "avg_area_savings_pct": round(float(avg_savings), 1),
            "avg_inference_time_s": round(float(avg_inference), 3),
            "batch_time_s": round(t_batch, 1),
            "confidence_threshold": self.confidence,
            "image_size": self.imgsz,
            "z_height": self.z_height,
            "samples": self.all_summaries,
        }

        # Save batch report
        report_path = self.output_root / "batch_report.json"
        report_path.write_text(json.dumps(batch, indent=2), encoding="utf-8")

        # Print summary table
        print(f"\n\n{'=' * 70}")
        print(f"  BATCH COMPLETE -- ALL {n} SAMPLES PROCESSED")
        print(f"{'=' * 70}")
        print(f"  Clean layers (no defects) : {n_clean}")
        print(f"  Repair layers             : {n_repair}")
        print(f"  Errors                    : {n_err}")
        print(f"  Total defects detected    : {total_defects}")
        print(f"    Overextrusion           : {total_over}")
        print(f"    Underextrusion          : {total_under}")
        print(f"  Total repair area         : {total_repair_area:.1f} mm^2")
        print(f"  Avg area savings          : {avg_savings:.1f}%")
        print(f"  Avg inference time        : {avg_inference:.3f}s")
        print(f"  Total batch time          : {t_batch:.1f}s "
              f"({t_batch/60:.1f} min)")
        print(f"  Batch report              : {report_path.name}")
        print(f"  Output directory          : {self.output_root}")

        # Per-sample summary table
        print(f"\n  {'Sample':<14s} {'Decision':<18s} {'Defects':>7s} "
              f"{'Over':>5s} {'Under':>5s} {'Area':>8s} {'Time':>6s}")
        print(f"  {'-'*14} {'-'*18} {'-'*7} {'-'*5} {'-'*5} {'-'*8} {'-'*6}")
        for s in self.all_summaries:
            if "error" in s:
                print(f"  {s['sample']:<14s} {'ERROR':<18s}")
                continue
            area_str = (f"{s.get('repair_area_mm2', 0):>6.1f}"
                        if s.get("repair_needed") else "     -")
            print(f"  {s['sample']:<14s} {s['decision']:<18s} "
                  f"{s['defects_found']:>7d} "
                  f"{s['overextrusions']:>5d} "
                  f"{s['underextrusions']:>5d} "
                  f"{area_str:>8s} "
                  f"{s['total_time_s']:>5.1f}s")

        print(f"{'=' * 70}\n")
        return batch


# =====================================================================
#  CLI
# =====================================================================

def main():
    parser = argparse.ArgumentParser(
        description="CHAMP Adaptive Process Monitor -- per-defect repair",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""\
Examples:
  python champ_adaptive_monitor.py                     # all 120 samples, cached
  python champ_adaptive_monitor.py --sample 1_13_35    # single sample, cached
  python champ_adaptive_monitor.py --no-overlay        # skip overlays (faster)
  python champ_adaptive_monitor.py --live              # live YOLOv8 inference
  python champ_adaptive_monitor.py --live --conf 0.90 --z 0.8
""",
    )
    parser.add_argument(
        "--sample", type=str, default=None,
        help="Process a single sample folder name (default: all 120)",
    )
    parser.add_argument(
        "--z", type=float, default=LAYER_HEIGHT_MM,
        help=f"Layer Z height in mm (default: {LAYER_HEIGHT_MM})",
    )
    parser.add_argument(
        "--conf", type=float, default=CONFIDENCE_THRESHOLD,
        help=f"YOLOv8 confidence threshold, live mode only (default: {CONFIDENCE_THRESHOLD})",
    )
    parser.add_argument(
        "--imgsz", type=int, default=IMAGE_SIZE,
        help=f"YOLOv8 inference image size, live mode only (default: {IMAGE_SIZE})",
    )
    parser.add_argument(
        "--no-overlay", action="store_true",
        help="Skip overlay visualisation generation (faster)",
    )
    parser.add_argument(
        "--live", action="store_true",
        help="Use live YOLOv8 inference instead of cached Disk_Defects.txt",
    )

    args = parser.parse_args()

    monitor = AdaptiveProcessMonitor(
        z_height=args.z,
        confidence=args.conf,
        imgsz=args.imgsz,
        generate_overlay=not args.no_overlay,
        use_cached=not args.live,
    )

    if args.sample:
        # Single sample mode
        samples = [args.sample]
    else:
        # All 120 samples
        samples = None

    results = monitor.run_all(samples)

    # Non-zero exit if any errors
    if any("error" in s for s in results):
        sys.exit(1)


if __name__ == "__main__":
    main()
