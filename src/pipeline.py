# src/pipeline.py
"""
Adaptive Repair Strategies – Main Pipeline
===========================================

End-to-end workflow:
    1. Detect defects  (YOLOv8 inference **or** cached Disk_Defects.txt)
    2. Map pixel → bed coordinates
    3. Generate repair G-code
    4. Validate the G-code (static analysis + optional CAMotics)
    5. Save outputs (G-code, validation report, toolpath preview)

Usage
-----
    # Process a specific sample with cached defects:
    python pipeline.py --sample 1_13_35

    # Process a sample with live YOLOv8 detection:
    python pipeline.py --sample 1_13_35 --live

    # Process all samples:
    python pipeline.py --all

    # Specify layer Z height:
    python pipeline.py --sample 1_13_35 --z 0.4
"""

from __future__ import annotations

import argparse
import json
import sys
import time
from pathlib import Path
from typing import List

# ── Project imports ──────────────────────────────────────────────────
from config import (
    LAYER_HEIGHT_MM,
    MODEL_PATH,
    OUTPUT_DIR,
    PROJECT_DATA_DIR,
)
from coordinate_mapping import MappedLayerResult, PixelToBedMapper
from defect_detection import (
    DefectDetector,
    LayerDetectionResult,
    find_defects_file,
    find_sample_images,
    load_defects_from_file,
)
from gcode_validator import (
    GCodeValidator,
    plot_toolpath,
    run_camotics_check,
)
from overlay_visualisation import overlay_for_sample
from repair_toolpath import generate_repair_gcode


# ── Pipeline steps ───────────────────────────────────────────────────

def step_detect(
    sample_dir: Path,
    live: bool = False,
) -> List[LayerDetectionResult]:
    """
    Step 1 – Detect defects.

    If *live* is True, load the YOLOv8 model and run inference on
    the camera images.  Otherwise, read the cached Disk_Defects.txt.
    """
    if not live:
        defects_file = find_defects_file(sample_dir)
        if defects_file is not None:
            print(f"  [detect] Reading cached defects: {defects_file.name}")
            return load_defects_from_file(defects_file)
        print("  [detect] No cached defects – falling back to live detection.")

    images = find_sample_images(sample_dir)
    if not images:
        print("  [detect] No camera images found. Nothing to detect.")
        return []

    print(f"  [detect] Running YOLOv8 on {len(images)} image(s) …")
    detector = DefectDetector()
    return detector.detect_batch(images)


def step_map(
    layer_results: List[LayerDetectionResult],
    sample_dir: Path | None = None,
) -> List[MappedLayerResult]:
    """
    Step 2 – Map pixel coordinates to bed coordinates.

    If a camera image is available the mapper auto-detects the image
    resolution; otherwise it uses the defaults from config.
    """
    mapper: PixelToBedMapper
    if sample_dir is not None:
        images = find_sample_images(sample_dir)
        if images:
            mapper = PixelToBedMapper.from_image(images[0])
        else:
            mapper = PixelToBedMapper()
    else:
        mapper = PixelToBedMapper()

    mapped: List[MappedLayerResult] = []
    for lr in layer_results:
        m = mapper.map_layer(lr)
        mapped.append(m)
        if m.has_defects:
            print(f"  [map] Layer {m.layer_number}: "
                  f"{len(m.mapped_defects)} defects mapped to bed coords")
    return mapped


def step_generate(
    mapped_layers: List[MappedLayerResult],
    z_height: float,
    output_dir: Path,
    sample_name: str,
) -> List[Path]:
    """
    Step 3 – Generate repair G-code for each layer with defects.
    """
    gcode_paths: List[Path] = []
    for ml in mapped_layers:
        if not ml.has_defects:
            continue
        fname = f"repair_{sample_name}_layer{ml.layer_number}.gcode"
        out_path = output_dir / fname
        gcode = generate_repair_gcode(ml, z_height=z_height,
                                      output_path=out_path)
        gcode_paths.append(out_path)
        print(f"  [generate] {fname}  ({len(gcode.splitlines())} lines)")
    return gcode_paths


def step_validate(
    gcode_paths: List[Path],
    output_dir: Path,
    show_plots: bool = False,
) -> bool:
    """
    Step 4 – Validate every generated G-code file.

    Returns True if all files pass static validation.
    """
    validator = GCodeValidator()
    all_pass = True

    for gp in gcode_paths:
        report = validator.validate_file(gp)
        print(f"\n  [validate] {gp.name}")
        print("  " + report.summary().replace("\n", "\n  "))
        if not report.is_valid:
            all_pass = False

        # Save validation report
        report_path = gp.with_suffix(".validation.txt")
        report_path.write_text(report.summary(), encoding="utf-8")

        # Toolpath preview
        gcode_text = gp.read_text(encoding="utf-8")
        preview_path = gp.with_suffix(".png")
        plot_toolpath(
            gcode_text,
            title=f"Toolpath – {gp.stem}",
            show=show_plots,
            save_path=preview_path,
        )

        # Optional CAMotics
        cam = run_camotics_check(gp)
        if cam["available"]:
            if cam["returncode"] == 0:
                print("  [camotics] PASS")
            else:
                print(f"  [camotics] FAIL – {cam['stderr']}")
        else:
            print(f"  [camotics] Skipped ({cam['stderr']})")

    return all_pass


# ── Full pipeline ────────────────────────────────────────────────────

def run_pipeline(
    sample_dir: Path,
    z_height: float = LAYER_HEIGHT_MM,
    live: bool = False,
    show_plots: bool = False,
) -> bool:
    """
    Execute the full pipeline for a single sample.

    Returns True if all validations passed.
    """
    sample_name = sample_dir.name
    out_dir = OUTPUT_DIR / sample_name
    out_dir.mkdir(parents=True, exist_ok=True)

    print(f"\n{'='*60}")
    print(f"  ADAPTIVE REPAIR PIPELINE – sample: {sample_name}")
    print(f"{'='*60}")

    t0 = time.time()

    # 1. Detect
    layer_results = step_detect(sample_dir, live=live)
    if not layer_results:
        print("  No defect data available. Pipeline complete (nothing to do).")
        return True

    total_defects = sum(lr.num_defects for lr in layer_results)
    print(f"  [detect] Total defects across {len(layer_results)} layer(s): "
          f"{total_defects}")

    if total_defects == 0:
        print("  No defects detected. Pipeline complete (nothing to repair).")
        return True

    # 2. Map
    mapped_layers = step_map(layer_results, sample_dir)

    # 3. Generate
    gcode_paths = step_generate(mapped_layers, z_height, out_dir, sample_name)
    if not gcode_paths:
        print("  No repair G-code generated.")
        return True

    # 4. Validate
    all_pass = step_validate(gcode_paths, out_dir, show_plots=show_plots)
    # 5. Overlay visualisation
    print("\n  [overlay] Generating detection + toolpath overlay …")
    overlay_path = overlay_for_sample(
        sample_name, show=show_plots, include_original_toolpath=True,
    )
    if overlay_path:
        print(f"  [overlay] Saved: {overlay_path.name}")
    elapsed = time.time() - t0
    print(f"\n  Pipeline finished in {elapsed:.1f}s  "
          f"({'PASS' if all_pass else 'ISSUES FOUND'})")
    return all_pass


# ── Multi-sample runner ──────────────────────────────────────────────

def list_sample_dirs() -> List[Path]:
    """Return all numbered sample directories under PROJECT_DATA_DIR."""
    if not PROJECT_DATA_DIR.exists():
        return []
    return sorted(
        p for p in PROJECT_DATA_DIR.iterdir()
        if p.is_dir() and p.name[0].isdigit()
    )


def run_all(z_height: float = LAYER_HEIGHT_MM, live: bool = False):
    """Run the pipeline on every sample."""
    samples = list_sample_dirs()
    print(f"Found {len(samples)} samples in {PROJECT_DATA_DIR}")
    results = {}
    for s in samples:
        ok = run_pipeline(s, z_height=z_height, live=live, show_plots=False)
        results[s.name] = ok

    # Summary
    print(f"\n{'='*60}")
    print("  BATCH SUMMARY")
    print(f"{'='*60}")
    passed = sum(1 for v in results.values() if v)
    failed = len(results) - passed
    print(f"  Passed: {passed}   Failed: {failed}   Total: {len(results)}")
    if failed:
        for name, ok in results.items():
            if not ok:
                print(f"    FAIL: {name}")

    # Save summary JSON
    summary_path = OUTPUT_DIR / "batch_summary.json"
    summary_path.parent.mkdir(parents=True, exist_ok=True)
    summary_path.write_text(
        json.dumps(results, indent=2), encoding="utf-8"
    )
    print(f"  Summary saved: {summary_path}")


# ── CLI ──────────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(
        description="Adaptive Repair Strategies Pipeline",
    )
    parser.add_argument(
        "--sample", type=str, default=None,
        help="Sample folder name, e.g. '1_13_35'",
    )
    parser.add_argument(
        "--all", action="store_true",
        help="Process all samples in the data directory",
    )
    parser.add_argument(
        "--live", action="store_true",
        help="Run live YOLOv8 inference instead of cached defects",
    )
    parser.add_argument(
        "--z", type=float, default=LAYER_HEIGHT_MM,
        help=f"Layer Z height in mm (default: {LAYER_HEIGHT_MM})",
    )
    parser.add_argument(
        "--show", action="store_true",
        help="Show matplotlib toolpath previews interactively",
    )

    args = parser.parse_args()

    if args.all:
        run_all(z_height=args.z, live=args.live)
    elif args.sample:
        sample_dir = PROJECT_DATA_DIR / args.sample
        if not sample_dir.exists():
            print(f"Sample directory not found: {sample_dir}")
            sys.exit(1)
        ok = run_pipeline(
            sample_dir,
            z_height=args.z,
            live=args.live,
            show_plots=args.show,
        )
        sys.exit(0 if ok else 1)
    else:
        # Default: run on sample 1
        sample_dir = PROJECT_DATA_DIR / "1_13_35"
        if not sample_dir.exists():
            print(f"Default sample not found: {sample_dir}")
            print("Use --sample <name> or --all to specify a target.")
            sys.exit(1)
        run_pipeline(
            sample_dir,
            z_height=args.z,
            live=args.live,
            show_plots=args.show,
        )


if __name__ == "__main__":
    main()
