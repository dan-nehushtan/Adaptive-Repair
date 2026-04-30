# Adaptive Repair Strategies for 3D Printing

> **Repo location**: This project lives at `Machine Learning In Advanced Manufacturing/Adaptive Repair Strategies/` within the `MECH5080-Team-Project` repository. All paths below are relative to that subfolder unless otherwise noted.

An automated pipeline that detects defects in ceramic 3D-printed layers using a YOLOv8 computer vision model, maps them from pixel space to printer-bed coordinates, generates targeted repair G-code toolpaths with automatic tool changes (milling + deposition), validates the output, and produces overlay visualisations for accuracy verification — all without reprinting the entire layer.

## Overview

Traditional additive manufacturing treats every layer as all-or-nothing: if a defect is found, the entire layer must be reprinted. This project takes a smarter approach by targeting only the defective regions, saving time and material.

## Source of Truth

Use [PROJECT_CONTEXT.md](PROJECT_CONTEXT.md#0-source-of-truth-matrix) as the authoritative cross-check when different docs mention different counts, outputs, or integration assumptions. The short version is:

| Topic | Canonical state | Notes |
|---|---|---|
| Canonical report benchmark | `v3_cached_monitor`: 120 samples, 30 clean layers, 90 repair layers, 310 defects, 93.7% mean area savings, 0 errors | Uses cached `Disk_Defects.txt` for direct comparability with the original CHAMP dataset |
| Live comparison run | `v2_adaptive_monitor`: 120 samples, 28 clean layers, 92 repair layers, 278 defects, 95.5% mean area savings, 0 errors | Uses live YOLOv8 inference; differs because detections near the threshold are slightly non-deterministic |
| Controller context | Legacy literature = Mach4 + GPIO; current planned machine testing = Duet Net serial firmware | `champ_integration.py` / `DuetHandoff` provide the software handoff path |
| Repair monitor | The current full monitor is a 9-step workflow: PRINT → CAPTURE → DETECT → DECIDE → MILL → FILL → DRY → RE-INSPECT → CONTINUE | Older "7-step" wording refers to the pre-drying / pre-reinspection milestone |

### Pipeline Steps

1. **Detect** — Identify over-extrusion and under-extrusion defects in layer camera images using a pre-trained YOLOv8 model (`YOLOv8_LSM.pt`) at 2560×2560 resolution with confidence threshold 0.85, or read cached detections from `Disk_Defects.txt`.
2. **Map** — Convert defect bounding boxes from pixel coordinates (5472×3648 image) to real printer-bed millimetres using a centre-referenced affine transformation with Y-axis inversion.
3. **Generate** — Create three-phase repair G-code with automatic tool changes (2 tool changes total: extruder → mill → extruder):
   - **Phase 1a (Mill overextrusion, T1)**: Pick up the milling tool and skim overextrusion regions flat.
   - **Phase 1b (Mill underextrusion, T1)**: Mill clean rectangular cavities into underextrusion regions (same tool, no tool change needed between 1a and 1b). Z-hops between each bounding box.
   - **Phase 2 (Deposit, T0)**: Return the mill, pick up the ceramic nozzle, and deposit material into the underextrusion cavities only. Overextrusion regions are not revisited.
4. **Validate** — Static G-code analysis (bounds checking, motion counting), optional CAMotics simulation, and 3-phase colour-coded 2D toolpath preview plots.
5. **Overlay** — Render the camera image with YOLO bounding boxes, mapped bed-space bounding boxes, and repair toolpath segments colour-coded by phase: orange (mill overextrusion), cyan (mill underextrusion cavity), green (deposit fill), grey (travel).

### Repair Strategy Rationale

**Why mill underextrusion cavities before filling?** A raw underextrusion "pothole" has irregular geometry — unknown depth, rough walls, random shape. Milling a clean rectangular pocket first gives:
- Known depth (layer height) for predictable fill volume
- Flat bottom + vertical walls for better adhesion
- Consistent surface with no bridging over voids

This is why ALL bounding boxes are milled in Phase 1 (single tool, one pass) before any deposition occurs in Phase 2.

### Hardware Platform

The system is built for the **CHAMP** (Ceramic Hybrid Additive Manufacturing Platform) custom AM/CNC machine:
- Extruder axis = `A` (not `E`)
- Work coordinate system = `G58`
- Ceramic paste extrusion (1.37 mm nozzle, 40.5 mm filament diameter)
- Circular bed, 60 mm radius
- Parts printed centred at origin (0, 0), 40×40 mm square geometry
- **Automatic Tool Changer (ATC)**: T0 = ceramic nozzle, T1 = milling tool
- Spindle control: M3 S1000 (on), M5 (off)

## Project Structure

```
Adaptive Repair Strategies/
├── data/
│   ├── Lvl 4 Project Data/                # 122 sample folders, each containing:
│   │   └── {id}_{time}/
│   │       ├── Camera/
│   │       │   ├── image_*.bmp            #   Raw camera image (5472×3648) [gitignored]
│   │       │   └── defectsImage_*.bmp     #   Annotated defect image (1368×912) [gitignored]
│   │       ├── Laser/
│   │       │   └── *.csv                  #   Laser profilometry data
│   │       └── Disk_Defects.txt           #   Cached YOLOv8 detections (JSON)
│   ├── GCODEs/
│   │   ├── AM GCODEs/                     # Original print G-code (120 files)
│   │   ├── Compiled GCODEs/               # Machine-ready compiled files (.tap)
│   │   ├── Coordinate Geometries/         # Extracted toolpath X/Y coordinates (JSON)
│   │   └── Scoping Experiment GCODE/      # Scoping experiment G-codes
│   ├── STLs/                              # 12 STL models (4 shapes × 3 heights)
│   ├── yolo_training/                     # YOLOv8 training dataset (train/valid/test splits)
│   ├── ExperimentalDesignRandomized 1.xlsx
│   └── ReadMe.docx
│
├── src/
│   ├── config.py                          # All tuneable parameters & paths (inc. ATC)
│   ├── data_paths.py                      # DATA_ROOT path helper
│   ├── defect_detection.py                # YOLOv8 inference & Disk_Defects.txt parser
│   ├── coordinate_mapping.py              # Pixel ↔ bed coordinate transformations
│   ├── repair_toolpath.py                 # Three-phase repair G-code with tool changes
│   ├── gcode_validator.py                 # Static analysis, CAMotics, 3-phase toolpath plots
│   ├── overlay_visualisation.py           # 3-phase colour-coded camera + toolpath overlay
│   ├── pipeline.py                        # End-to-end orchestrator (CLI)
│   ├── champ_sequence.py                  # Full CHAMP workflow (v1): Print → Scan → Detect → Repair
│   ├── champ_live.py                      # CHAMP machine integration (watch/image/folder modes)
│   ├── champ_adaptive_monitor.py          # 9-step adaptive monitor (cached canonical + live comparison)
│   ├── inspect_yolo_model.py              # YOLOv8 model metadata extraction
│   └── check_table.py                     # Utility: verify experimental design table
│
├── output/
│   ├── v1_sequence/                       #   Older pipeline (champ_sequence.py, no ATC)
│   │   └── {sample_name}/
│   │       ├── repair_*_layer0.gcode      #     Repair G-code
│   │       ├── repair_*_layer0.validation.txt
│   │       ├── repair_*_layer0.png        #     Toolpath preview
│   │       └── overlay_*.png              #     Full overlay visualisation
│   ├── v2_adaptive_monitor/               #   Live YOLO comparison run (champ_adaptive_monitor.py --live)
│   │   └── {sample_name}/
│   │       ├── repair_{sample}.gcode      #     Repair G-code (with ATC tool changes)
│   │       ├── repair_{sample}.tap        #     CHAMP-ready copy
│   │       ├── repair_{sample}.validation.txt
│   │       ├── toolpath_{sample}.png      #     3-phase colour-coded toolpath preview
│   │       ├── overlay_{sample}.png       #     Full overlay visualisation
│   │       └── summary_{sample}.json      #     Per-sample summary
│   └── v3_cached_monitor/                 #   Canonical cached benchmark (champ_adaptive_monitor.py default)
│       └── {sample_name}/
│           ├── repair_{sample}.gcode      #     Repair G-code (with ATC tool changes)
│           ├── repair_{sample}.tap        #     CHAMP-ready copy
│           ├── repair_{sample}.validation.txt
│           ├── toolpath_{sample}.png      #     3-phase colour-coded toolpath preview
│           ├── overlay_{sample}.png       #     Full overlay visualisation
│           └── summary_{sample}.json      #     Per-sample summary
│
└── README.md                     # In-depth project context document
```



**Note**: Camera `.bmp` images (3.0 GB total) are gitignored as well as YOLOv8_LSM.pt

## Quick Start

### 1. CHAMP Adaptive Process Monitor

The `champ_adaptive_monitor.py` script integrates CHAMP process monitoring with **per-defect adaptive repair** across all 120 samples.

It supports two modes:
- **Cached (default)**: reads `Disk_Defects.txt`, writes to `output/v3_cached_monitor/`, and matches the canonical report benchmark.
- **Live (`--live`)**: re-runs YOLOv8 inference, writes to `output/v2_adaptive_monitor/`, and is retained for comparison / non-determinism analysis.

Each sample goes through the full **9-step CHAMP workflow**:

| Step | Name | Action |
|---|---|---|
| 1 | **PRINT** | Load the AM G-code and simulate printing the part |
| 2 | **CAPTURE** | Load the camera `.bmp` image (simulated camera capture) |
| 3 | **DETECT** | Read cached `Disk_Defects.txt` detections by default, or run live YOLOv8_LSM inference with `--live` |
| 4 | **DECIDE** | No defects → continue to next layer \| Defects → adaptive repair |
| 5 | **MILL** | Pick up T1, mill ALL defect bboxes (over=skim, under=cavity) |
| 6 | **FILL** | Return T1, pick up T0, deposit ceramic into underextrusion cavities only |
| 7 | **DRY** | Emit the IR drying command `M20 #620=60 #621={Z}` after deposition |
| 8 | **RE-INSPECT** | Emit `M311` camera re-scan command and encode up to 2 retry attempts in the controller workflow |
| 9 | **CONTINUE** | Repair complete → continue to the next layer |

**Key advantage over binary CHAMP_monitoring approach**: Instead of planarizing or reworking the *entire layer* (GPIO D5/D6 signals), this monitor targets only the defective bounding boxes — achieving 93.7% less processed area in the canonical cached benchmark and 95.5% in the retained live comparison run.

```bash
cd "Machine Learning In Advanced Manufacturing/Adaptive Repair Strategies/src"

# Process ALL 120 samples (default):
python champ_adaptive_monitor.py

# Process a single sample:
python champ_adaptive_monitor.py --sample 1_13_35

# Skip overlay images (faster):
python champ_adaptive_monitor.py --no-overlay

# Custom confidence / Z height / image size:
python champ_adaptive_monitor.py --conf 0.90 --z 0.8 --imgsz 2560
```

**Batch results** (120 samples, cached `Disk_Defects.txt`):
- 30 clean layers (no defects), 90 repair layers, 0 errors
- 310 total defects: 131 overextrusion + 179 underextrusion
- Average area savings: 93.7% (median 98.8%) vs full-layer approach
- Output: `output/v3_cached_monitor/` with per-sample folders

> Add `--live` to run live YOLOv8 inference instead. The retained live comparison produced 28 clean layers, 92 repair layers, 278 total defects, and 95.5% mean area savings in `output/v2_adaptive_monitor/`.

**Note on YOLO non-determinism**: The v2 pipeline runs live YOLO inference rather than reading cached `Disk_Defects.txt`. Due to GPU non-determinism in Ultralytics, re-running inference produces slightly different detection counts (~62% exact match with original data, ±1–4 defects for the rest). See [PROJECT_CONTEXT.md](PROJECT_CONTEXT.md) Section 3.7 for details.

### 2. Check the output

Monitor results are saved to `output/v3_cached_monitor/<sample_name>/` by default, or `output/v2_adaptive_monitor/<sample_name>/` with `--live`:

| File | Description |
|---|---|
| `repair_{sample}.gcode` | Repair G-code with tool changes for the CHAMP machine |
| `repair_{sample}.tap` | CHAMP-ready copy (`.tap` extension for the controller) |
| `repair_{sample}.validation.txt` | Static validation report (PASS/FAIL) |
| `toolpath_{sample}.png` | 3-phase toolpath preview (orange=mill over, cyan=mill under, green=deposit, grey=travel) |
| `overlay_{sample}.png` | Full overlay: camera image + detections + toolpath |
| `summary_{sample}.json` | Per-sample sequence metadata (defect counts, timings, area savings, etc.) |
| `batch_report.json` | Aggregate run statistics at the output-root level |

### 3. Individual modules

Each module can be run standalone:

```bash
cd "Machine Learning In Advanced Manufacturing/Adaptive Repair Strategies/src"
python defect_detection.py          # Print defect summary for sample 1
python coordinate_mapping.py        # Show pixel → bed mapping
python repair_toolpath.py           # Generate & preview repair G-code
python gcode_validator.py           # Validate an existing repair file
python overlay_visualisation.py     # Generate overlay image
python overlay_visualisation.py --sample 42_17_17 --no-show
```

## Pipeline Modules

### Defect Detection (`defect_detection.py`)
- **Live mode**: Loads the YOLOv8s model (`YOLOv8_LSM.pt`, 11.1M params) and runs inference at 2560×2560 with deterministic mode enabled.
- **Cached mode**: Reads existing `Disk_Defects.txt` JSON files containing bounding boxes, class labels (`Overextrusion` / `Underextrusion`), and confidence scores.
- Confidence threshold: **0.85** (raised from 0.50 after benchmarking — eliminates false positives in frame edges/background).
- Outputs uniform `Defect` / `LayerDetectionResult` dataclass objects for downstream processing.

### Coordinate Mapping (`coordinate_mapping.py`)
- Centre-referenced affine transformation: image centre = bed origin (0, 0).
- Y-axis inversion: image Y-down → bed Y-up.
- Scale factor: `MM_PER_PIXEL = 0.0175` (calibrated across 120 samples).
- Bidirectional: `pixel_to_bed()` for G-code generation, `bed_to_pixel()` for overlay rendering.
- Auto-detects image resolution from file headers via `from_image()` classmethod.

### Repair Toolpath Generation (`repair_toolpath.py`)
- **Automatic tool changer (ATC)** support built in: `pickup_mill()` / `return_mill_pickup_nozzle()` emit T0/T1, M6, M3/M5 commands.
- **Phase 1a — Mill overextrusion (T1)**: Skim overextrusion regions flat (layer-height depth, no extrusion).
- **Phase 1b — Mill underextrusion (T1)**: Cut clean rectangular cavities into underextrusion regions (removes irregular pothole geometry, creating known-depth pockets).
- **Phase 2 — Deposit (T0)**: Raster extrusion **only** into underextrusion cavities with volumetric flow calculation. Overextrusion regions are skipped (already flat from skim).
- **Z-hop between bounding boxes**: The tool lifts to `z_height + 2 mm` before rapid-moving between bounding boxes. Within each bbox, only G1 linear moves are used (no G0 rapids at working Z outside a defect region).
- Nearest-neighbour travel ordering within each phase (typically 50–60% travel reduction).
- CHAMP-specific G-code: `A` axis extrusion, `G58` work coordinates, `M14` purge, `G92 A0` reset.

### G-code Validation (`gcode_validator.py`)
- **Static analysis**: Checks for out-of-bounds moves (circular bed, 60 mm radius), missing G21/G90 modes, and counts motion vs extrusion commands.
- **CAMotics integration**: Optional headless simulation (requires CAMotics on PATH).
- **3-phase toolpath preview**: Parses G-code comment markers to distinguish repair phases. Renders Phase 1a mill overextrusion (orange), Phase 1b mill underextrusion (cyan), Phase 2 deposit (green), and Z-hop travel (grey dashed).

### Overlay Visualisation (`overlay_visualisation.py`)
- Renders the raw camera image with all of the following overlaid:
  - YOLO defect bounding boxes (red = overextrusion, blue = underextrusion)
  - Mapped bed-space bounding boxes (dashed outlines, for accuracy verification)
  - Repair toolpath — **3-phase colour-coded**: Phase 1a mill overextrusion (orange), Phase 1b mill underextrusion (cyan), Phase 2 deposit (green); travel between boxes (grey, alpha=0.4)
  - Original print toolpath from coordinate geometry files
  - 40 mm part boundary outline
- Provides direct visual validation that the pixel → bed mapping is accurate.

### Pipeline Orchestrator (`pipeline.py`)
- Runs all five steps in sequence for single or batch processing.
- CLI interface with `--sample`, `--all`, `--live`, `--z`, `--show` options.
- Produces a `batch_summary.json` when processing all samples.

### CHAMP Sequence (`champ_sequence.py`)
- End-to-end workflow: **Print → Scan → Detect → Repair**.
- Scan step is a placeholder for the CHAMP camera API (falls back to existing sample images or `--image` path).
- Runs detection via YOLOv8 at conf 0.85 / imgsz 2560.
- Generates two-phase repair G-code with tool changes, validates, produces overlay, and writes sequence summary JSON.
- CLI: `--sample`, `--image`, `--conf`, `--z`, `--show`.

### CHAMP Live (`champ_live.py`)
- Self-contained script for test-day use on the CHAMP machine.
- **`--watch D:\`** — Polls a USB drive for new `.bmp`/`.jpg`/`.png` images and processes each one automatically.
- **`--image path`** — Single-shot mode: process one image and exit.
- **`--folder path`** — Batch mode: process all images in a directory.
- Outputs `.gcode` + `.tap` + `.png` + `.json` to `output/champ_live/`.

### CHAMP Adaptive Monitor (`champ_adaptive_monitor.py`)
- Integrates CHAMP process monitoring with **per-defect adaptive repair** across all 120 samples in either cached mode (default) or live YOLOv8 mode (`--live`).
- Each sample follows a **9-step CHAMP workflow**: PRINT → CAPTURE → DETECT → DECIDE → MILL → FILL → DRY → RE-INSPECT → CONTINUE.
- **Step 1 PRINT**: Loads the original AM G-code for the sample part.
- **Step 2 CAPTURE**: Loads the raw camera `.bmp` image from the sample's `Camera/` folder.
- **Step 3 DETECT**: Reads cached `Disk_Defects.txt` detections by default, or runs live YOLOv8_LSM inference (conf=0.85, imgsz=2560) when `--live` is enabled.
- **Step 4 DECIDE**: If zero defects → continue (no repair needed). Otherwise → adaptive repair.
- **Step 5 MILL**: Phase 1 with T1 — mill ALL defect bounding boxes (overextrusion=skim, underextrusion=cavity). Z-hop between each bbox.
- **Step 6 FILL**: Phase 2 with T0 — deposit ceramic into underextrusion cavities only. Purge nozzle (M14) before first deposit.
- **Step 7 DRY**: Emits `M20 #620=60 #621={Z}` to dry the repair deposit before the next layer.
- **Step 8 RE-INSPECT**: Emits `M311` and encodes up to `MAX_REPAIR_RETRIES = 2` repair retries in the controller workflow.
- **Step 9 CONTINUE**: Repair complete, log efficiency statistics (area savings vs full-layer approach), save summary.
- **Batch mode** (`run_all()`): Processes all 120 samples sequentially, writes the canonical cached benchmark to `output/v3_cached_monitor/`, and writes the live comparison run to `output/v2_adaptive_monitor/` when `--live` is used.
- **Comparison with CHAMP_monitoring**: The original approach uses binary GPIO signals (D5=planarize, D6=rework) on the entire layer. This adaptive monitor targets only defective regions, saving 93.7% of processed area in the canonical cached run.
- CLI: `--sample NAME`, `--no-overlay`, `--conf FLOAT`, `--z FLOAT`, `--imgsz INT`.
- Output: `output/v3_cached_monitor/<sample>/` by default, or `output/v2_adaptive_monitor/<sample>/` with `--live`, plus a `batch_report.json` at the run root.

### Model Inspector (`inspect_yolo_model.py`)
- Extracts and prints all YOLOv8 model metadata: class names, input size, parameter count, architecture summary.
- Useful for verifying the model file before deployment.

## Configuration

All tuneable parameters are in [`src/config.py`](src/config.py):

| Parameter | Value | Description |
|---|---|---|
| `IMAGE_WIDTH_PX` | 5472 | Raw camera image width (pixels) |
| `IMAGE_HEIGHT_PX` | 3648 | Raw camera image height (pixels) |
| `IMAGE_SIZE` | 2560 | YOLOv8 inference resolution |
| `MM_PER_PIXEL` | 0.0175 | Scale factor (mm per pixel) |
| `PART_SIZE_MM` | 40.0 | Printed part bounding box (mm) |
| `BED_RADIUS_MM` | 60.0 | CHAMP circular bed radius (mm) |
| `CONFIDENCE_THRESHOLD` | 0.85 | Minimum YOLOv8 confidence |
| `NOZZLE_DIAMETER_MM` | 1.37 | Ceramic nozzle diameter (mm) |
| `LAYER_HEIGHT_MM` | 0.4 | Z height per layer (mm) |
| `EXTRUSION_WIDTH_MM` | 1.37 | Extrusion width (mm) |
| `FILAMENT_DIAMETER_MM` | 40.5 | Ceramic paste auger diameter (mm) |
| `PRINT_FEED_RATE` | 300 | Extrusion speed (mm/min) |
| `TRAVEL_FEED_RATE` | 7800 | Rapid travel speed (mm/min) |
| `MILL_FEED_RATE` | 200 | Mill raster speed (mm/min) |
| `REPAIR_MARGIN_MM` | 0.5 | Safety margin around defect bboxes (mm) |
| `EXTRUDER_AXIS` | `"A"` | Extruder axis label (CHAMP convention) |
| `RETRACT_LENGTH_MM` | 0.0 | No retraction for ceramic extruder |
| `TOOL_NOZZLE` | `"T0"` | Nozzle tool index (ATC) |
| `TOOL_MILL` | `"T1"` | Mill tool index (ATC) |
| `TOOL_CHANGE_CMD` | `"M6"` | Tool change command |
| `MILL_SPINDLE_ON` | `"M3 S1000"` | Spindle on (milling) |
| `MILL_SPINDLE_OFF` | `"M5"` | Spindle off |
| `TOOL_PARK_X/Y/Z` | 0 / 0 / 50 | Tool change park position (mm) |

> **Note:** Tool change commands (`T0`/`T1`, `M6`, `M3`/`M5`, park position) are placeholders — confirm with the CHAMP team before running on hardware.

## Data Formats

### Disk_Defects.txt (per sample)

```json
[
  {
    "Layer number": 0,
    "Number of defects": 19,
    "Overextrusions": 14,
    "Underextrusions": 5,
    "Defect data": [
      {
        "Class": "Overextrusion",
        "Confidence": 0.92,
        "Defect coordinates": [2824, 2806, 2913, 2904],
        "Box area (px)": 8722,
        "Box aspect ratio": 0.908
      }
    ]
  }
]
```

Bounding box coordinates `[x1, y1, x2, y2]` are in the raw image pixel space (5472×3648).

### Coordinate Geometries (per sample)

```json
[
  {
    "Layer Z position": 0.4,
    "Coordinate Data": {
      "X coordinates": [19.315, -19.315, ...],
      "Y coordinates": [19.315, 19.315, ...]
    },
    "Pictures per layer": 0
  }
]
```

## Requirements

- Python 3.13+
- Key packages: `ultralytics`, `opencv-python`, `numpy`, `matplotlib`, `pillow`, `scipy`, `torch`
- Optional: [CAMotics](https://camotics.org/) for G-code simulation

## Research Papers & References

The following papers from the CHAMP research group informed design decisions.

| Paper | Key Relevance |
|---|---|
| Masters et al. (2025) — *Strategic Layer Reworking using Hybrid AM* | The journal publication of the existing full-layer planarize/rework system. **Explicitly calls for per-defect targeted repair as future work — our pipeline answers this.** |
| Davie et al. (2024) — *The Effect of Interlayer Drying on Ceramic Paste Extrusion* | IR drying causes 4.3–6.4% Z shrinkage. Repair deposits need drying + extrusion multiplier compensation. |
| Davie et al. (2024) — *Process Development and Control for Sensor-Informed Hybrid-AM* | Definitive CHAMP hardware reference. GPIO via ft232h, Mach4 control, IR lamp, polymer raft, dust extraction. |
| Masters et al. (2024) — *Defect-Free Ceramic Hybrid-AM using Intelligent Layer Reworking* | Two-step monitoring: camera then laser. YOLO cannot quantify Z-deviation of overextrusions. |
| MECH5080M Team Report 167 (2025) | Predecessor team: YOLOv11 outperforms YOLOv8 for segmentation masks. DBSCAN clustering. 3-class detection (over/under/debris). |
| Green (2024) — *Laser Assisted Print Optimisation* | Laser point cloud quality metrics, auger screw rate optimisation, layer extraction algorithm. |

> **Note:** Files removed to align with report appendix requirements.