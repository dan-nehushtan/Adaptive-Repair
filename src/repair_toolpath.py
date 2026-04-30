# src/repair_toolpath.py
"""
Repair toolpath generator.

Takes mapped defects (bed-space bounding boxes) and produces G-code that
repairs **only** the defective regions.  The repair order is:

1. **Phase 1 — Mill ALL bounding boxes** (tool T1)
     • Overextrusion regions → skim off excess material.
     • Underextrusion regions → mill a clean rectangular cavity
       (removes irregular edges and creates a known-depth pocket
       for reliable re-fill).
   All milling is done in one pass before any tool change.

2. **Phase 2 — Deposit into underextrusion cavities** (tool T0)
     • Re-deposit ceramic into the milled-out underextrusion
       cavities using raster infill.
     • Overextrusion regions are NOT revisited.

Within each phase defects are visited in **nearest-neighbour order** to
minimise total travel distance.

The generated G-code uses the CHAMP machine conventions discovered in the
existing AM G-code files:
  - Extruder axis = **A** (not E)
  - Coordinate systems G55 / G58
  - Purge = M14, Laser on/off = M15 / M16
"""

from __future__ import annotations

import math
from dataclasses import dataclass
from pathlib import Path
from typing import List

from config import (
    CAMERA_SCAN_COMMAND,
    DUST_EXTRACT_COMMAND,
    DUST_EXTRACT_DWELL_S,
    EXTRUDER_AXIS,
    EXTRUSION_WIDTH_MM,
    FILAMENT_DIAMETER_MM,
    IR_DRY_COMMAND,
    IR_DRY_TIME_S,
    LAYER_HEIGHT_MM,
    MILL_FEED_RATE,
    MILL_SPINDLE_OFF,
    MILL_SPINDLE_ON,
    NOZZLE_DIAMETER_MM,
    PRINT_FEED_RATE,
    REPAIR_EXTRUSION_MULTIPLIER,
    REPAIR_INFILL_OVERLAP,
    RETRACT_LENGTH_MM,
    RETRACT_SPEED,
    TOOL_CHANGE_CMD,
    TOOL_MILL,
    TOOL_NOZZLE,
    TOOL_PARK_X,
    TOOL_PARK_Y,
    TOOL_PARK_Z,
    TRAVEL_FEED_RATE,
    Z_FEED_RATE,
)
from coordinate_mapping import BedBoundingBox, MappedDefect, MappedLayerResult


# ── Helpers ──────────────────────────────────────────────────────────

def _extrusion_per_mm(
    layer_height: float = LAYER_HEIGHT_MM,
    extrusion_width: float = EXTRUSION_WIDTH_MM,
    filament_diameter: float = FILAMENT_DIAMETER_MM,
) -> float:
    """
    Calculate the extruder axis distance per mm of linear travel.

    Uses volumetric equivalence:
        cross_section_deposited = layer_height * extrusion_width
        cross_section_filament  = pi/4 * filament_diameter**2
        extrusion_per_mm = deposited / filament
    """
    area_deposited = layer_height * extrusion_width
    area_filament = math.pi / 4 * filament_diameter ** 2
    return area_deposited / area_filament


def _line_length(x1: float, y1: float, x2: float, y2: float) -> float:
    return math.hypot(x2 - x1, y2 - y1)


# ── G-code building blocks ──────────────────────────────────────────

class GCodeBuilder:
    """Accumulates G-code lines with helper methods for common commands."""

    def __init__(self):
        self.lines: List[str] = []
        self._extruder_pos: float = 0.0   # running A/E position

    # ── Low-level ────────────────────────────────────────────────────

    def comment(self, text: str):
        self.lines.append(f"; {text}")

    def raw(self, line: str):
        self.lines.append(line)

    # ── Motion ───────────────────────────────────────────────────────

    def rapid_move(self, x: float | None = None, y: float | None = None,
                   z: float | None = None, f: float = TRAVEL_FEED_RATE):
        parts = ["G0"]
        if x is not None:
            parts.append(f"X{x:.3f}")
        if y is not None:
            parts.append(f"Y{y:.3f}")
        if z is not None:
            parts.append(f"Z{z:.3f}")
        parts.append(f"F{f:.0f}")
        self.lines.append(" ".join(parts))

    def linear_move(self, x: float, y: float,
                    extrude_length: float = 0.0,
                    f: float = PRINT_FEED_RATE):
        self._extruder_pos += extrude_length
        parts = [f"G1 X{x:.3f} Y{y:.3f}"]
        if extrude_length > 0:
            parts.append(f"{EXTRUDER_AXIS}{self._extruder_pos:.5f}")
        parts.append(f"F{f:.0f}")
        self.lines.append(" ".join(parts))

    def move_z(self, z: float, f: float = Z_FEED_RATE):
        self.lines.append(f"G1 Z{z:.3f} F{f:.0f}")

    # ── Retraction ───────────────────────────────────────────────────

    def retract(self):
        self._extruder_pos -= RETRACT_LENGTH_MM
        self.lines.append(
            f"G1 {EXTRUDER_AXIS}{self._extruder_pos:.5f} F{RETRACT_SPEED}"
        )

    def unretract(self):
        self._extruder_pos += RETRACT_LENGTH_MM
        self.lines.append(
            f"G1 {EXTRUDER_AXIS}{self._extruder_pos:.5f} F{RETRACT_SPEED}"
        )

    # ── Machine specifics (CHAMP) ────────────────────────────────────

    def reset_extruder(self):
        self._extruder_pos = 0.0
        self.lines.append(f"G92 {EXTRUDER_AXIS}0")

    def purge_nozzle(self):
        self.lines.append("M14  ; purge nozzle")

    def tool_change(self, tool: str, label: str = ""):
        """Automatic tool change via ATC."""
        self.comment(f"--- TOOL CHANGE: {label or tool} ---")
        # Retract to safe Z and park at ATC position
        self.move_z(TOOL_PARK_Z)
        self.rapid_move(x=TOOL_PARK_X, y=TOOL_PARK_Y)
        # Execute tool change
        self.raw(f"{TOOL_CHANGE_CMD} {tool}  ; pick up {label or tool}")
        self.comment(f"Tool {tool} loaded")

    def pickup_mill(self):
        """Pick up the milling tool and start the spindle."""
        self.tool_change(TOOL_MILL, label="milling tool")
        self.raw(f"{MILL_SPINDLE_ON}  ; spindle on")

    def return_mill_pickup_nozzle(self):
        """Return the mill, pick up the nozzle, ready for extrusion."""
        self.raw(f"{MILL_SPINDLE_OFF}  ; spindle off")
        self.tool_change(TOOL_NOZZLE, label="ceramic nozzle")
        self.reset_extruder()

    def dust_extract(self):
        """Trigger dust extraction after milling to clear ceramic chips."""
        if DUST_EXTRACT_COMMAND is not None:
            self.comment("--- DUST EXTRACTION ---")
            self.raw(f"{DUST_EXTRACT_COMMAND}  ; clear milling debris")
            self.raw(f"G4 P{DUST_EXTRACT_DWELL_S * 1000:.0f}"
                     f"  ; dwell {DUST_EXTRACT_DWELL_S}s for extraction")
        else:
            self.comment("--- DUST EXTRACTION (placeholder) ---")
            self.comment("    TODO: set DUST_EXTRACT_COMMAND in config.py")
            self.comment("    Ceramic chips must be cleared before deposition")

    def ir_dry(self, time_s: float = IR_DRY_TIME_S,
               z_height: float = LAYER_HEIGHT_MM):
        """IR lamp drying after deposition (CHAMP M20 command)."""
        self.comment("--- IR DRYING ---")
        self.raw(f"{IR_DRY_COMMAND} #620={time_s:.0f} #621={z_height}"
                 f"  ; IR dry {time_s:.0f}s at Z={z_height}")

    def camera_scan(self):
        """Trigger camera/laser scan for post-repair re-inspection."""
        self.comment("--- CAMERA SCAN (re-inspection) ---")
        self.raw(f"{CAMERA_SCAN_COMMAND}  ; trigger camera scan")

    def laser_on(self, power: float = 1.5):
        self.lines.append(f"M15 #600={power}  ; laser on")

    def laser_off(self):
        self.lines.append("M16  ; laser off")

    # ── Output ───────────────────────────────────────────────────────

    def build(self) -> str:
        return "\n".join(self.lines) + "\n"

    def save(self, path: Path):
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(self.build(), encoding="utf-8")
        print(f"Saved repair G-code: {path}")


# ── Repair strategies ───────────────────────────────────────────────

def _raster_infill_lines(
    bbox: BedBoundingBox,
    line_spacing: float,
) -> list[tuple[float, float, float, float]]:
    """
    Generate raster scan lines (x1, y1, x2, y2) that fill *bbox*
    in the Y direction with the given line spacing.
    Returns alternating left→right / right→left segments.
    """
    lines = []
    y = bbox.y_min
    left_to_right = True
    while y <= bbox.y_max:
        if left_to_right:
            lines.append((bbox.x_min, y, bbox.x_max, y))
        else:
            lines.append((bbox.x_max, y, bbox.x_min, y))
        y += line_spacing
        left_to_right = not left_to_right
    return lines


def _defect_centre(defect: MappedDefect) -> tuple[float, float]:
    """Return the (x, y) centre of a defect's bed bounding box."""
    return defect.bed_bbox.centre


def _nearest_neighbour_order(
    defects: list[MappedDefect],
    start: tuple[float, float] = (0.0, 0.0),
) -> list[MappedDefect]:
    """
    Sort *defects* in nearest-neighbour order starting from *start*.
    Greedy: always travel to the closest un-visited defect next.
    This minimises total rapid-travel distance between repair regions.
    """
    if len(defects) <= 1:
        return list(defects)

    remaining = list(defects)
    ordered: list[MappedDefect] = []
    cx, cy = start

    while remaining:
        best_idx = 0
        best_dist = float("inf")
        for i, d in enumerate(remaining):
            dx, dy = _defect_centre(d)
            dist = math.hypot(dx - cx, dy - cy)
            if dist < best_dist:
                best_dist = dist
                best_idx = i
        chosen = remaining.pop(best_idx)
        ordered.append(chosen)
        cx, cy = _defect_centre(chosen)

    return ordered


def _total_travel(defects: list[MappedDefect],
                  start: tuple[float, float] = (0.0, 0.0)) -> float:
    """Calculate total travel distance through a defect list (for logging)."""
    total = 0.0
    cx, cy = start
    for d in defects:
        dx, dy = _defect_centre(d)
        total += math.hypot(dx - cx, dy - cy)
        cx, cy = dx, dy
    return total


def generate_underextrusion_repair(
    gc: GCodeBuilder,
    defect: MappedDefect,
    z_height: float,
    line_spacing: float | None = None,
    extrusion_multiplier: float = REPAIR_EXTRUSION_MULTIPLIER,
):
    """
    Generate extrusion-based repair for an under-extruded region.
    Deposits material in a raster pattern across the defect bbox.

    The *extrusion_multiplier* scales the deposited volume relative to
    standard layer geometry.  Values >1.0 overfill slightly to compensate
    for paste shrinkage or cavity wall adhesion.
    """
    if line_spacing is None:
        line_spacing = EXTRUSION_WIDTH_MM * (1.0 - REPAIR_INFILL_OVERLAP)

    e_per_mm = _extrusion_per_mm() * extrusion_multiplier
    bbox = defect.bed_bbox

    gc.comment(f"--- Underextrusion repair  conf={defect.confidence:.2f} ---")
    gc.comment(f"    bed region: ({bbox.x_min:.2f},{bbox.y_min:.2f})"
               f" -> ({bbox.x_max:.2f},{bbox.y_max:.2f})")

    raster = _raster_infill_lines(bbox, line_spacing)
    if not raster:
        gc.comment("    (empty region, skipped)")
        return

    # Z-hop to safe height, travel to bbox start, plunge
    gc.retract()
    gc.move_z(z_height + 2.0)
    gc.rapid_move(x=raster[0][0], y=raster[0][1])
    gc.move_z(z_height)
    gc.unretract()

    # Raster infill — alternating direction keeps the tool inside the bbox.
    # Only a Y step-over is needed between rows (no XY rapid).
    for i, (x1, y1, x2, y2) in enumerate(raster):
        if i > 0:
            # Step-over to next row (short Y move within bbox)
            gc.linear_move(x1, y1, extrude_length=0.0, f=TRAVEL_FEED_RATE)
        length = _line_length(x1, y1, x2, y2)
        gc.linear_move(x2, y2, extrude_length=length * e_per_mm)

    # Z-hop away when done
    gc.retract()
    gc.move_z(z_height + 2.0)
    gc.comment("--- end underextrusion repair ---")


def generate_mill_pass(
    gc: GCodeBuilder,
    defect: MappedDefect,
    z_height: float,
    line_spacing: float | None = None,
):
    """
    Generate a milling raster pass over a defect bounding box.

    The milling Z depth depends on the defect type:

      • **Overextrusion** → skim at *z_height* (the layer surface).
        The excess material sits above the nominal surface; the mill
        passes across the top to restore a flat layer.

      • **Underextrusion** → mill to the *floor* of the layer
        (``z_height - LAYER_HEIGHT_MM``, i.e. the previous-layer
        surface).  The irregular void is cleaned into a known-depth
        rectangular pocket that Phase 2 can fill predictably.  The
        nozzle then deposits at *z_height*, which places it exactly
        one layer height above the pocket floor — the same geometry
        as normal layer-by-layer printing.

    No extrusion — purely cutting/motion commands.
    """
    if line_spacing is None:
        line_spacing = NOZZLE_DIAMETER_MM * (1.0 - REPAIR_INFILL_OVERLAP)

    bbox = defect.bed_bbox
    is_overextrusion = defect.class_name == "Overextrusion"
    label = "skim" if is_overextrusion else "cavity"

    # Overextrusion: skim at layer surface.
    # Underextrusion: plunge to previous-layer floor to create a clean pocket.
    if is_overextrusion:
        mill_z = z_height
    else:
        mill_z = max(z_height - LAYER_HEIGHT_MM, 0.0)

    gc.comment(f"--- Mill {label}: {defect.class_name}  "
               f"conf={defect.confidence:.2f} ---")
    gc.comment(f"    bed region: ({bbox.x_min:.2f},{bbox.y_min:.2f})"
               f" -> ({bbox.x_max:.2f},{bbox.y_max:.2f})")
    gc.comment(f"    mill Z={mill_z:.3f} mm"
               f" ({'layer surface' if is_overextrusion else 'pocket floor'})")

    raster = _raster_infill_lines(bbox, line_spacing)
    if not raster:
        gc.comment("    (empty region, skipped)")
        return

    # Z-hop to safe height, travel to bbox start, plunge to mill depth
    gc.move_z(z_height + 2.0)
    gc.rapid_move(x=raster[0][0], y=raster[0][1])
    gc.move_z(mill_z)

    # Raster mill — alternating direction keeps the tool inside the bbox.
    # Only a Y step-over is needed between rows (no XY rapid).
    for i, (x1, y1, x2, y2) in enumerate(raster):
        if i > 0:
            # Step-over to next row (short Y move within bbox)
            gc.linear_move(x1, y1, extrude_length=0.0, f=MILL_FEED_RATE)
        gc.linear_move(x2, y2, extrude_length=0.0, f=MILL_FEED_RATE)

    # Z-hop away when done
    gc.move_z(z_height + 2.0)
    gc.comment(f"--- end mill {label} ---")


# ── Top-level generator ─────────────────────────────────────────────

def generate_repair_gcode(
    mapped_layer: MappedLayerResult,
    z_height: float = LAYER_HEIGHT_MM,
    output_path: Path | None = None,
) -> str:
    """
    Generate a complete repair G-code file for one layer.

    Parameters
    ----------
    mapped_layer : MappedLayerResult
        Layer with defects already mapped to bed coordinates.
    z_height : float
        The Z height of the layer being repaired (mm).
    output_path : Path, optional
        If given, save the G-code to this file.

    Returns
    -------
    str  – the G-code text.
    """
    gc = GCodeBuilder()

    # ── Header ───────────────────────────────────────────────────────
    gc.comment("=" * 60)
    gc.comment("ADAPTIVE REPAIR G-CODE")
    gc.comment(f"Layer {mapped_layer.layer_number}   Z={z_height:.3f} mm")
    gc.comment(f"Defects: {len(mapped_layer.mapped_defects)}")
    gc.comment("=" * 60)
    gc.raw("")

    # Machine setup (CHAMP conventions)
    gc.raw("G21          ; millimetres")
    gc.raw("G90          ; absolute positioning")
    gc.raw("G58          ; work coordinate system")
    gc.reset_extruder()
    gc.raw("")

    if not mapped_layer.has_defects:
        gc.comment("No defects detected – nothing to repair.")
        gcode_text = gc.build()
        if output_path:
            gc.save(output_path)
        return gcode_text

    # ── Separate defect types ────────────────────────────────────────
    over  = [d for d in mapped_layer.mapped_defects
             if d.class_name == "Overextrusion"]
    under = [d for d in mapped_layer.mapped_defects
             if d.class_name == "Underextrusion"]

    all_defects = over + under              # mill both types in Phase 1

    # ── Phase 1: MILL all bounding boxes (overextrusion + underextrusion)
    #    • Overextrusion  → skim excess at layer height
    #    • Underextrusion → cut clean rectangular cavity for re-fill
    #    One continuous milling pass, nearest-neighbour order.
    if all_defects:
        gc.comment("")
        gc.comment(">>> PICKING UP MILLING TOOL")
        gc.pickup_mill()
        gc.raw("")

        mill_ordered = _nearest_neighbour_order(all_defects, start=(0.0, 0.0))
        naive_dist   = _total_travel(all_defects)
        opt_dist     = _total_travel(mill_ordered)

        gc.comment("")
        gc.comment(f">>> PHASE 1: MILL ALL BOUNDING BOXES ({len(all_defects)})")
        gc.comment(f"    Overextrusion  : {len(over)} regions (skim excess)")
        gc.comment(f"    Underextrusion : {len(under)} regions (cut clean cavity)")
        gc.comment(f"    Travel optimised: {naive_dist:.1f} -> {opt_dist:.1f} mm "
                   f"({(1-opt_dist/naive_dist)*100:.0f}% saved)"
                   if naive_dist > 0 else "")
        gc.comment("")

        for defect in mill_ordered:
            generate_mill_pass(gc, defect, z_height)
            gc.raw("")

        # Safe retract + spindle off after all milling
        gc.move_z(z_height + 2.0)
        gc.raw(f"{MILL_SPINDLE_OFF}  ; spindle off after milling")
        gc.dust_extract()
        gc.comment("--- Phase 1 complete: all regions milled ---")
        gc.raw("")

    # ── Phase 2: DEPOSIT into underextrusion cavities only ───────────
    #    The cavities were milled to a clean rectangular pocket in Phase 1.
    #    Now fill them with ceramic using the extrusion nozzle.
    #    Overextrusion regions are NOT revisited.
    if under:
        gc.comment(">>> RETURNING MILL, PICKING UP NOZZLE FOR DEPOSITION")
        gc.return_mill_pickup_nozzle()
        gc.raw("")

        # Start nearest-neighbour from end of milling pass, or origin
        if all_defects:
            start_pos = _defect_centre(mill_ordered[-1])
        else:
            start_pos = (0.0, 0.0)

        under_ordered = _nearest_neighbour_order(under, start=start_pos)
        naive_dist  = _total_travel(under, start=start_pos)
        opt_dist    = _total_travel(under_ordered, start=start_pos)

        gc.comment("")
        gc.comment(f">>> PHASE 2: DEPOSIT INTO UNDEREXTRUSION CAVITIES ({len(under)})")
        gc.comment(f"    Fill milled cavities with ceramic")
        gc.comment(f"    Travel optimised: {naive_dist:.1f} -> {opt_dist:.1f} mm "
                   f"({(1-opt_dist/naive_dist)*100:.0f}% saved)"
                   if naive_dist > 0 else "")
        gc.comment("")
        gc.purge_nozzle()
        gc.raw("")

        for defect in under_ordered:
            generate_underextrusion_repair(gc, defect, z_height)
            gc.raw("")
    elif all_defects:
        # Only overextrusion — just return the mill, no deposition needed
        gc.comment(">>> RETURNING MILL (no underextrusion to fill)")
        gc.return_mill_pickup_nozzle()
        gc.raw("")

    # ── IR Drying ──────────────────────────────────────────────────────
    #    Ceramic paste must be dried after deposition to cure properly.
    #    This matches the standard CHAMP layer sequence (M20).
    if under:
        gc.raw("")
        gc.ir_dry(time_s=IR_DRY_TIME_S, z_height=z_height)
        gc.raw("")

    # ── Post-Repair Re-inspection ────────────────────────────────────
    #    Trigger a camera scan so the controller (or a subsequent
    #    software pass) can verify the repair succeeded.  The CHAMP
    #    system permits up to 2 retries per layer (Masters 2025).
    gc.camera_scan()
    gc.raw("")

    # ── Footer ───────────────────────────────────────────────────────
    gc.comment("--- Repair complete ---")
    gc.rapid_move(z=z_height + 5.0)   # safe retract
    gc.rapid_move(x=0, y=0)           # park
    gc.raw("M2  ; program end")

    gcode_text = gc.build()
    if output_path:
        gc.save(output_path)
    return gcode_text


# ── CLI demo ─────────────────────────────────────────────────────────

def main():
    from config import OUTPUT_DIR, PROJECT_DATA_DIR
    from coordinate_mapping import PixelToBedMapper
    from defect_detection import find_defects_file, load_defects_from_file

    sample = PROJECT_DATA_DIR / "1_13_35"
    defects_file = find_defects_file(sample)
    if defects_file is None:
        print("No Disk_Defects.txt found. Exiting.")
        return

    layer_results = load_defects_from_file(defects_file)
    if not layer_results:
        print("No layer data. Exiting.")
        return

    mapper = PixelToBedMapper()
    mapped = mapper.map_layer(layer_results[0])

    out_path = OUTPUT_DIR / "repair_sample_1.gcode"
    gcode = generate_repair_gcode(mapped, z_height=0.4, output_path=out_path)
    print(f"\nGenerated {len(gcode.splitlines())} lines of repair G-code.")
    print(f"First 30 lines:\n")
    for line in gcode.splitlines()[:30]:
        print(line)


if __name__ == "__main__":
    main()
