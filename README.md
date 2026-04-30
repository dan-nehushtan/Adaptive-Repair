# Adaptive Repair Strategies for 3D Printing — Appendix

> **Repo location**: This folder contains the software appendix for the MECH5080 Team Project on Adaptive Repair Strategies. Full project documentation is in `Machine Learning In Advanced Manufacturing/Adaptive Repair Strategies/` within the `MECH5080-Team-Project` repository.

## Project Overview

An automated pipeline that detects defects in ceramic 3D-printed layers using a YOLOv8 model, maps them from pixel space to printer-bed coordinates, generates targeted repair G-code with automatic tool changes (milling + deposition), and produces overlay visualisations — all without reprinting the entire layer.

## Structure

```
Adaptive Repair Strategies/
├── data/                          # Sample data (120 folders with images, laser scans, cached detections)
├── src/                           # Core pipeline modules
├── output/                        # Generated repair G-code, validation reports, and visualisations
├── requirements.txt               # Python dependencies
└── PROJECT_CONTEXT.md             # Detailed technical documentation
```

## Quick Reference

For the full software documentation, implementation details, technical context, and project status, refer to [PROJECT_CONTEXT.md](PROJECT_CONTEXT.md) in the main repository.

| File/Folder | Purpose |
|---|---|
| `src/` | Core pipeline modules for detection, mapping, G-code generation, and validation |
| `data/Lvl 4 Project Data/` | 120 sample folders with camera images, laser scans, and cached defect detections |
| `output/v3_cached_monitor/` | Canonical benchmark results (90 repair layers, 310 defects, 93.7% area savings) |
| `output/v2_adaptive_monitor/` | Live YOLO comparison results (92 repair layers, 278 defects, 95.5% area savings) |
| `requirements.txt` | Python dependencies |

## Installation & Usage

```bash
# Install dependencies
pip install -r requirements.txt

# Run the adaptive monitor on all 120 samples (default: cached defects)
cd src
python champ_adaptive_monitor.py

# Process a single sample
python champ_adaptive_monitor.py --sample 1_13_35

# Use live YOLOv8 inference instead of cached detections
python champ_adaptive_monitor.py --live
```

For detailed CLI options, module references, configuration parameters, and hardware integration notes, see the [main README](../README.md) or [PROJECT_CONTEXT.md](PROJECT_CONTEXT.md).
