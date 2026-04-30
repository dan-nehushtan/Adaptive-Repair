# src/config.py
"""
Centralised configuration for the Adaptive Repair Strategies pipeline.
All tuneable parameters live here so they are easy to find and change.
"""

from pathlib import Path
from data_paths import DATA_ROOT

# ── Paths ────────────────────────────────────────────────────────────
MODEL_PATH          = DATA_ROOT / "YOLOv8_LSM.pt"
PROJECT_DATA_DIR    = DATA_ROOT / "Lvl 4 Project Data"
AM_GCODE_DIR        = DATA_ROOT / "GCODEs" / "AM GCODEs"
COMPILED_GCODE_DIR  = DATA_ROOT / "GCODEs" / "Compiled GCODEs"
COORD_GEOM_DIR      = DATA_ROOT / "GCODEs" / "Coordinate Geometries"
STL_DIR             = DATA_ROOT / "STLs"
OUTPUT_DIR          = DATA_ROOT.parent / "output"        # GitHub/output

# ── YOLOv8 Inference ────────────────────────────────────────────────
CONFIDENCE_THRESHOLD = 0.85        # minimum confidence to keep a detection
IOU_THRESHOLD        = 0.45        # NMS IoU threshold
IMAGE_SIZE           = 2560        # inference image size (matches training resolution)

# ── Coordinate Mapping ──────────────────────────────────────────────
# The CHAMP bed is a circle with 60 mm radius (120 mm diameter).
# The camera captures a rectangular region centred over the bed.
# All parts are printed centred at the bed origin (0, 0).
#
# The mapping model is centre-referenced:
#   bed_x =  (pixel_x - image_cx) * MM_PER_PIXEL
#   bed_y = -(pixel_y - image_cy) * MM_PER_PIXEL   (Y axis inverted)
#
# MM_PER_PIXEL must be calibrated to your camera setup.
# Default estimated from defect bbox ranges across 120 samples.

# Image resolution of the RAW camera photos (pixels)
# (Disk_Defects.txt bounding boxes are in this coordinate space)
IMAGE_WIDTH_PX  = 5472
IMAGE_HEIGHT_PX = 3648

# Scale factor – millimetres per pixel (uniform, same in X and Y)
# Estimated so that detected defects fall within the 40 mm part boundary.
# Adjust this value if the overlay in CAMotics is still offset.
MM_PER_PIXEL = 0.0175

# Camera field of view (derived – for reference / validation bounds)
CAMERA_FOV_X_MM = IMAGE_WIDTH_PX * MM_PER_PIXEL   # ~95.8 mm
CAMERA_FOV_Y_MM = IMAGE_HEIGHT_PX * MM_PER_PIXEL  # ~63.8 mm

# Part dimensions (from G-code / STL metadata)
PART_SIZE_MM = 40.0               # bounding box of printed parts

# Bed physical limits (circular bed, radius 60 mm)
BED_RADIUS_MM = 60.0

# ── Repair Toolpath Generation ──────────────────────────────────────
# Printing / repair parameters (from SuperSlicer config in 1.gcode)
NOZZLE_DIAMETER_MM   = 1.37       # ceramic nozzle diameter (nozzle_diameter)
LAYER_HEIGHT_MM      = 0.4        # first_layer_height in G-code
EXTRUSION_WIDTH_MM   = 1.37       # extrusion width from G-code
FILAMENT_DIAMETER_MM = 40.5       # ceramic paste auger diameter (filament_diameter)

# Feed rates (mm/min)
PRINT_FEED_RATE      = 300        # extrusion moves
TRAVEL_FEED_RATE     = 7800       # non-extrusion rapid moves
Z_FEED_RATE          = 600        # Z axis moves

# Repair strategy
REPAIR_INFILL_OVERLAP = 0.10      # fraction overlap between adjacent repair lines
REPAIR_MARGIN_MM      = 0.5       # margin around defect bounding box
RETRACT_LENGTH_MM     = 0.0       # ceramic extruder: no retraction (retract_length=0)
RETRACT_SPEED         = 60        # retract_speed for ceramic extruder (mm/min)
REPAIR_EXTRUSION_MULTIPLIER = 1.0 # multiplier for repair deposit extrusion volume
                                  # >1.0 overfills to compensate for cavity walls
                                  # <1.0 underfills (unlikely to be useful)

# ── Post-Repair: IR Drying & Re-inspection ─────────────────────────
# After repair deposition, IR drying cures the ceramic paste.
# Then a camera rescan checks whether the repair was successful.
# The CHAMP system permits up to 2 re-inspection retries (Masters 2025).
IR_DRY_TIME_S         = 60        # IR lamp dwell time in seconds (video-confirmed)
IR_DRY_COMMAND        = "M20"     # CHAMP IR drying M-code
CAMERA_SCAN_COMMAND   = "M311"    # CHAMP camera/laser scan trigger
MAX_REPAIR_RETRIES    = 2         # max re-inspect + re-repair attempts per layer

# Extruder axis label (CHAMP system uses 'A' instead of 'E')
EXTRUDER_AXIS = "A"

# ── Tool Change (CHAMP ATC) ──────────────────────────────────────────
# The CHAMP machine has an automatic tool changer (ATC).
# TODO: Update these commands once confirmed with the CHAMP team.
#
# Tool indices:
#   T0 = Ceramic extrusion nozzle (default)
#   T1 = Milling tool (6 mm end mill for defect removal)
#
# ATC sequence observed from AM G-code and video analysis:
#   Pickup:  G1 Z{TOOL_PARK_Z} → G0 X{PARK_X} Y{PARK_Y} → M6 T{N}
#   Return:  M5 (spindle off) → G1 Z{TOOL_PARK_Z} → G0 X{PARK_X} Y{PARK_Y} → M6 T{N}
#
# Safe Z heights (from existing AM G-code analysis):
#   Z50   — initial safe / ATC tool change height (START GCODE: Z50 F1500)
#   Z20   — setup travel height (G0 Z20 before print)
#   Z+2   — Z-hop between defect bounding boxes during repair
#   Z+5   — final retract after repair complete
TOOL_NOZZLE      = "T0"           # ceramic nozzle tool ID
TOOL_MILL        = "T1"           # milling tool ID
TOOL_CHANGE_CMD  = "M6"           # ATC tool change M-code
TOOL_PARK_X      = 0.0            # ATC park X (mm) — TODO: set from CHAMP
TOOL_PARK_Y      = 0.0            # ATC park Y (mm) — TODO: set from CHAMP
TOOL_PARK_Z      = 50.0           # safe Z for tool change (mm, from AM G-code)
MILL_SPINDLE_ON  = "M3 S1000"     # spindle on (CW) — TODO: confirm speed
MILL_SPINDLE_OFF = "M5"           # spindle off
MILL_FEED_RATE   = 200            # milling feed rate (mm/min) — TODO: tune

# ── Dust Extraction (after milling) ─────────────────────────────────
# Ceramic milling produces fine chips that must be cleared before
# deposition to prevent contamination.  The exact M-code is TBD
# pending confirmation from the CHAMP team.
DUST_EXTRACT_COMMAND = None        # TODO: set M-code from CHAMP engineer
DUST_EXTRACT_DWELL_S = 5.0        # dwell time for dust clearance

# ── G-code Validation ───────────────────────────────────────────────
CAMOTIX_EXECUTABLE = "camotics"   # name or full path to CAMotics CLI
