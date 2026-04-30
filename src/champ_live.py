# src/champ_live.py
"""
CHAMP Live Repair Pipeline
===========================

Self-contained script for running the adaptive repair pipeline
directly on the CHAMP machine during a print.

Workflow
--------
    1. Point the script at a folder (USB drive / shared path)
       where the CHAMP machine saves camera images.
    2. The script watches for new `.bmp` images.
    3. When an image appears it runs:
           YOLOv8 detection → coordinate mapping → repair G-code
    4. The resulting `.tap` file is saved alongside the image,
       ready to be loaded into the CHAMP controller.

Usage
-----
    # Watch mode — waits for images to appear:
    python champ_live.py --watch D:\\CHAMP

    # Single-shot — process one image immediately:
    python champ_live.py --image D:\\CHAMP\\Camera\\image_01.bmp

    # Process all .bmp files already in a folder:
    python champ_live.py --folder D:\\CHAMP\\Camera

    # Override confidence threshold (default 0.85):
    python champ_live.py --image photo.bmp --conf 0.90

    # Specify layer Z height (default 0.4 mm):
    python champ_live.py --image photo.bmp --z 0.8

Quick-start for test day
------------------------
    1. Plug in the USB drive (e.g. D:\\)
    2. Open a terminal in the GitHub\\src folder
    3. Run:  python champ_live.py --watch D:\\
    4. Print the layer on CHAMP — it saves the image to USB
    5. The script detects the new image, generates repair.tap
    6. Load repair.tap into the CHAMP controller
    7. Run the repair pass
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

# ── Project imports ──────────────────────────────────────────────────
from config import (
    CONFIDENCE_THRESHOLD,
    IMAGE_SIZE,
    IOU_THRESHOLD,
    LAYER_HEIGHT_MM,
    OUTPUT_DIR,
)
from coordinate_mapping import PixelToBedMapper
from defect_detection import DefectDetector
from gcode_validator import GCodeValidator, plot_toolpath
from repair_toolpath import generate_repair_gcode


# ── Global state ─────────────────────────────────────────────────────
_detector: Optional[DefectDetector] = None


def get_detector() -> DefectDetector:
    """Lazy-load the YOLOv8 model (takes ~7s first time)."""
    global _detector
    if _detector is None:
        print("\n  Loading YOLOv8 model …", end=" ", flush=True)
        t0 = time.time()
        _detector = DefectDetector()
        print(f"done ({time.time() - t0:.1f}s)")
    return _detector


# ── Core processing function ────────────────────────────────────────

def process_image(
    image_path: Path,
    z_height: float = LAYER_HEIGHT_MM,
    confidence: float = CONFIDENCE_THRESHOLD,
    iou: float = IOU_THRESHOLD,
    imgsz: int = IMAGE_SIZE,
    output_dir: Optional[Path] = None,
    layer_number: int = 0,
) -> dict:
    """
    Run the full pipeline on a single camera image.

    Returns a summary dict with all results.
    """
    image_path = Path(image_path).resolve()
    if not image_path.exists():
        raise FileNotFoundError(f"Image not found: {image_path}")

    # Determine output location
    if output_dir is None:
        output_dir = OUTPUT_DIR / "champ_live"
    output_dir = Path(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    stem = image_path.stem

    print(f"\n{'='*60}")
    print(f"  CHAMP LIVE REPAIR")
    print(f"  Image : {image_path.name}")
    print(f"  Z     : {z_height} mm    Conf: {confidence}")
    print(f"  Output: {output_dir}")
    print(f"{'='*60}")

    t_start = time.time()

    # ── Step 1: Detect defects ───────────────────────────────────────
    print(f"\n  [1/4] Detecting defects (imgsz={imgsz}, conf={confidence}) …")
    detector = get_detector()
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

    print(f"        {len(result.defects)} defects found in {t_detect:.2f}s")
    print(f"        Overextrusion: {n_over}   Underextrusion: {n_under}")

    if len(result.defects) == 0:
        print("\n  ✓ No defects detected — layer is clean. No repair needed.")
        summary = {
            "image": str(image_path),
            "timestamp": timestamp,
            "z_height": z_height,
            "confidence_threshold": confidence,
            "defects_found": 0,
            "overextrusions": 0,
            "underextrusions": 0,
            "repair_needed": False,
            "inference_time_s": round(t_detect, 3),
            "total_time_s": round(time.time() - t_start, 3),
        }
        _save_summary(summary, output_dir, stem, timestamp)
        return summary

    # ── Step 2: Map to bed coordinates ───────────────────────────────
    print(f"\n  [2/4] Mapping pixel → bed coordinates …")
    mapper = PixelToBedMapper.from_image(image_path)
    mapped = mapper.map_layer(result)

    for d in mapped.mapped_defects:
        bb = d.bed_bbox
        print(f"        {d.class_name:<16s} conf={d.confidence:.2f}  "
              f"bed=({bb.x_min:+.1f},{bb.y_min:+.1f})"
              f"→({bb.x_max:+.1f},{bb.y_max:+.1f}) mm")

    # ── Step 3: Generate repair G-code ───────────────────────────────
    print(f"\n  [3/4] Generating repair G-code …")

    # Save as both .gcode (for validation/preview) and .tap (for CHAMP)
    gcode_path = output_dir / f"repair_{stem}_{timestamp}.gcode"
    tap_path   = output_dir / f"repair_{stem}_{timestamp}.tap"

    gcode_text = generate_repair_gcode(
        mapped, z_height=z_height, output_path=gcode_path,
    )

    # Write .tap copy (identical content, CHAMP-compatible extension)
    tap_path.write_text(gcode_text, encoding="utf-8")

    n_lines = len(gcode_text.splitlines())
    print(f"        Generated {n_lines} lines")
    print(f"        G-code : {gcode_path.name}")
    print(f"        TAP    : {tap_path.name}  ← load this into CHAMP")

    # ── Step 4: Validate ─────────────────────────────────────────────
    print(f"\n  [4/4] Validating …")
    validator = GCodeValidator()
    report = validator.validate_file(gcode_path)
    print(f"        {report.summary().splitlines()[0]}")

    # Toolpath preview
    preview_path = gcode_path.with_suffix(".png")
    plot_toolpath(
        gcode_text,
        title=f"Repair toolpath — {stem}",
        show=False,
        save_path=preview_path,
    )
    print(f"        Preview: {preview_path.name}")

    # Save validation report
    report_path = gcode_path.with_suffix(".validation.txt")
    report_path.write_text(report.summary(), encoding="utf-8")

    t_total = time.time() - t_start

    # ── Summary ──────────────────────────────────────────────────────
    summary = {
        "image": str(image_path),
        "timestamp": timestamp,
        "z_height": z_height,
        "confidence_threshold": confidence,
        "defects_found": len(result.defects),
        "overextrusions": n_over,
        "underextrusions": n_under,
        "repair_needed": True,
        "gcode_lines": n_lines,
        "validation": "PASS" if report.is_valid else "FAIL",
        "tap_file": str(tap_path),
        "inference_time_s": round(t_detect, 3),
        "total_time_s": round(t_total, 3),
        "defects": [
            {
                "class": d.class_name,
                "confidence": round(d.confidence, 4),
                "bed_bbox": {
                    "x_min": round(d.bed_bbox.x_min, 2),
                    "y_min": round(d.bed_bbox.y_min, 2),
                    "x_max": round(d.bed_bbox.x_max, 2),
                    "y_max": round(d.bed_bbox.y_max, 2),
                },
            }
            for d in mapped.mapped_defects
        ],
    }
    _save_summary(summary, output_dir, stem, timestamp)

    print(f"\n  {'='*60}")
    print(f"  REPAIR READY — {t_total:.1f}s total")
    print(f"  Load '{tap_path.name}' into the CHAMP controller.")
    print(f"  {'='*60}\n")

    return summary


def _save_summary(summary: dict, output_dir: Path, stem: str, ts: str):
    """Write JSON summary alongside the other output files."""
    path = output_dir / f"summary_{stem}_{ts}.json"
    path.write_text(json.dumps(summary, indent=2), encoding="utf-8")


# ── Watch mode ───────────────────────────────────────────────────────

def watch_folder(
    watch_path: Path,
    z_height: float = LAYER_HEIGHT_MM,
    confidence: float = CONFIDENCE_THRESHOLD,
    poll_interval: float = 2.0,
):
    """
    Continuously watch a folder (USB drive) for new .bmp images.
    When a new image appears, process it immediately.
    """
    watch_path = Path(watch_path).resolve()
    print(f"\n  CHAMP Live Watch Mode")
    print(f"  Watching : {watch_path}")
    print(f"  Z height : {z_height} mm")
    print(f"  Conf     : {confidence}")
    print(f"  Poll     : every {poll_interval}s")
    print(f"\n  Waiting for new .bmp images …  (Ctrl+C to stop)\n")

    # Pre-load the model so first image is fast
    get_detector()

    # Track already-seen files
    seen: set[Path] = set()

    # Scan for existing images so we don't re-process them
    for ext in ("*.bmp", "*.BMP"):
        for f in watch_path.rglob(ext):
            if not f.name.lower().startswith("defects"):
                seen.add(f)
    print(f"  Found {len(seen)} existing image(s) — will skip these.\n")

    layer_counter = 0
    try:
        while True:
            new_images = []
            for ext in ("*.bmp", "*.BMP"):
                for f in watch_path.rglob(ext):
                    if f not in seen and not f.name.lower().startswith("defects"):
                        new_images.append(f)
                        seen.add(f)

            for img in sorted(new_images):
                print(f"\n  >>> New image detected: {img}")
                try:
                    process_image(
                        img,
                        z_height=z_height,
                        confidence=confidence,
                        layer_number=layer_counter,
                    )
                    layer_counter += 1
                except Exception as e:
                    print(f"  ERROR processing {img.name}: {e}")

            time.sleep(poll_interval)

    except KeyboardInterrupt:
        print(f"\n\n  Watch stopped. Processed {layer_counter} image(s).")


# ── Process all images in a folder ───────────────────────────────────

def process_folder(
    folder: Path,
    z_height: float = LAYER_HEIGHT_MM,
    confidence: float = CONFIDENCE_THRESHOLD,
):
    """Process all .bmp images in a folder (non-watch, one-shot)."""
    folder = Path(folder).resolve()
    images = sorted(
        f for f in folder.rglob("*.bmp")
        if not f.name.lower().startswith("defects")
    )
    if not images:
        print(f"No .bmp images found in {folder}")
        return

    print(f"Found {len(images)} image(s) in {folder}")

    # Pre-load model
    get_detector()

    results = []
    for i, img in enumerate(images):
        try:
            summary = process_image(
                img, z_height=z_height, confidence=confidence, layer_number=i,
            )
            results.append(summary)
        except Exception as e:
            print(f"  ERROR: {img.name}: {e}")

    # Print batch summary
    total_defects = sum(r["defects_found"] for r in results)
    repairs = sum(1 for r in results if r["repair_needed"])
    print(f"\n{'='*60}")
    print(f"  BATCH COMPLETE: {len(results)} images processed")
    print(f"  Total defects: {total_defects}")
    print(f"  Repairs generated: {repairs}")
    print(f"{'='*60}")


# ── CLI ──────────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(
        description="CHAMP Live Repair Pipeline",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Watch USB drive for new images:
  python champ_live.py --watch D:\\

  # Process a single image:
  python champ_live.py --image D:\\Camera\\image.bmp

  # Process all images in a folder:
  python champ_live.py --folder D:\\Camera

  # Custom confidence threshold:
  python champ_live.py --watch D:\\ --conf 0.90
        """,
    )
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument(
        "--watch", type=str, metavar="PATH",
        help="Watch a folder/USB drive for new .bmp images",
    )
    mode.add_argument(
        "--image", type=str, metavar="FILE",
        help="Process a single image file",
    )
    mode.add_argument(
        "--folder", type=str, metavar="DIR",
        help="Process all .bmp images in a folder (one-shot)",
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
        "--output", type=str, default=None,
        help="Output directory (default: alongside input images)",
    )

    args = parser.parse_args()
    out = Path(args.output) if args.output else None

    if args.watch:
        watch_folder(
            Path(args.watch), z_height=args.z, confidence=args.conf,
        )
    elif args.image:
        process_image(
            Path(args.image),
            z_height=args.z,
            confidence=args.conf,
            output_dir=out,
        )
    elif args.folder:
        process_folder(
            Path(args.folder), z_height=args.z, confidence=args.conf,
        )


if __name__ == "__main__":
    main()
