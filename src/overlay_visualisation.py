# src/overlay_visualisation.py
"""
Overlay visualisation module.

Renders the raw camera image with:
  - YOLOv8 defect bounding boxes (pixel space)
  - Generated repair toolpath (converted back from bed mm → pixel space)
  - Optional original print toolpath from coordinate geometry

This provides a direct visual check of:
  1. Whether the pixel → bed coordinate mapping is accurate.
  2. Whether the repair bounding boxes cover the correct defect regions.
  3. Whether the repair raster lines are correctly sized and positioned.
"""

from __future__ import annotations

import re
from pathlib import Path
from typing import List, Optional

import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import numpy as np
from matplotlib.collections import LineCollection
from PIL import Image

from config import (
    EXTRUDER_AXIS,
    IMAGE_HEIGHT_PX,
    IMAGE_WIDTH_PX,
    MM_PER_PIXEL,
    OUTPUT_DIR,
    PROJECT_DATA_DIR,
)
from coordinate_mapping import (
    MappedDefect,
    MappedLayerResult,
    PixelToBedMapper,
    load_coordinate_geometry,
)
from defect_detection import (
    BoundingBox,
    Defect,
    LayerDetectionResult,
    find_defects_file,
    find_sample_images,
    load_defects_from_file,
)


# ── Colour scheme ───────────────────────────────────────────────────

COLOURS = {
    # Detection bounding boxes
    "overextrusion_box":   "#FF4444",   # red
    "underextrusion_box":  "#4488FF",   # blue
    # Repair toolpath phases
    "mill_over":           "#FF6B35",   # vivid orange — skim overextrusion
    "mill_under":          "#00B4D8",   # bright cyan  — mill underextrusion cavity
    "deposit":             "#2DC653",   # bright green — fill underextrusion
    "travel":              "#BBBBBB",   # light grey
    "original_toolpath":   "#CCCCCC",   # light grey
    # Bed-space bounding boxes
    "bed_bbox_over":       "#FF666680", # semi-transparent red
    "bed_bbox_under":      "#6688FF80", # semi-transparent blue
}


# ── G-code parser (extract toolpath segments in bed mm) ──────────────

_AXIS_RE = re.compile(
    r"(?P<axis>[XYZABEF])\s*(?P<value>[+-]?\d+\.?\d*)", re.IGNORECASE
)


def _parse_axes(line: str) -> dict[str, float]:
    return {m.group("axis").upper(): float(m.group("value"))
            for m in _AXIS_RE.finditer(line)}


def parse_gcode_segments(gcode_text: str, working_z: float | None = None) -> dict:
    """
    Parse repair G-code and return segments split by repair phase.

    Uses G-code comments to distinguish the three repair operations:
      1. mill_over  — milling / skimming overextrusion regions
      2. mill_under — milling clean cavities in underextrusion regions
      3. deposit    — extruding material to fill underextrusion cavities

    Parameters
    ----------
    gcode_text : str
        The repair G-code.
    working_z : float, optional
        The Z height of the repair layer.  If None, auto-detected from the
        first ``G1 Z`` move below 5 mm.

    Returns
    -------
    dict with keys:
        "travel"     : list of ((x1,y1),(x2,y2)) – rapid / Z-hopped moves
        "mill_over"  : list of ((x1,y1),(x2,y2)) – overextrusion skim
        "mill_under" : list of ((x1,y1),(x2,y2)) – underextrusion cavity mill
        "deposit"    : list of ((x1,y1),(x2,y2)) – underextrusion fill
    """
    travel_segs = []
    mill_over_segs = []
    mill_under_segs = []
    deposit_segs = []

    cur_x = cur_y = cur_z = 0.0

    # Try to extract working Z from the G-code header comment:
    #   "; Layer 0   Z=0.400 mm"
    if working_z is None:
        z_header = re.search(r";\s*Layer\s+\d+\s+Z\s*=\s*([0-9.]+)", gcode_text)
        if z_header:
            working_z = float(z_header.group(1))

    # Track which repair operation we're inside, based on G-code comments
    # from repair_toolpath.py:
    #   "; --- Mill skim: Overextrusion ..."   -> mill_over
    #   "; --- Mill cavity: Underextrusion ..." -> mill_under
    #   "; --- Underextrusion repair ..."       -> deposit
    #   "; --- end ..."                         -> reset
    current_phase = None  # "mill_over" | "mill_under" | "deposit" | None

    for raw_line in gcode_text.splitlines():
        stripped = raw_line.strip()

        # Parse comment lines to track which phase we're in
        if stripped.startswith(";"):
            comment = stripped[1:].strip().lower()
            if "mill skim" in comment or ("mill" in comment and "overextrusion" in comment.split("conf")[0]):
                current_phase = "mill_over"
            elif "mill cavity" in comment or ("mill" in comment and "underextrusion" in comment.split("conf")[0]):
                current_phase = "mill_under"
            elif "underextrusion repair" in comment or "deposit into" in comment:
                current_phase = "deposit"
            elif comment.startswith("--- end"):
                current_phase = None
            continue

        line = stripped.split(";")[0].strip()
        if not line:
            continue
        upper = line.upper()

        is_rapid = upper.startswith("G0 ") or upper.startswith("G0\t") or upper == "G0"
        is_linear = upper.startswith("G1 ") or upper.startswith("G1\t") or upper == "G1"

        if not (is_rapid or is_linear):
            continue

        axes = _parse_axes(line)
        new_x = axes.get("X", cur_x)
        new_y = axes.get("Y", cur_y)
        new_z = axes.get("Z", cur_z)
        has_ext = EXTRUDER_AXIS in axes

        # Auto-detect working Z from first plunge below 5 mm
        if working_z is None and new_z != cur_z and new_z < 5.0:
            working_z = new_z

        cur_z = new_z

        # Skip pure-Z or pure-extruder moves (no XY change)
        if new_x == cur_x and new_y == cur_y:
            cur_x, cur_y = new_x, new_y
            continue

        seg = ((cur_x, cur_y), (new_x, new_y))

        at_working_z = (working_z is not None
                        and abs(cur_z - working_z) < 0.01)

        if is_rapid:
            travel_segs.append(seg)
        elif at_working_z and current_phase == "mill_over":
            mill_over_segs.append(seg)
        elif at_working_z and current_phase == "mill_under":
            mill_under_segs.append(seg)
        elif at_working_z and has_ext:
            deposit_segs.append(seg)
        elif at_working_z and current_phase == "deposit":
            deposit_segs.append(seg)
        elif at_working_z:
            # Fallback: untagged skim moves (e.g. from v1 G-code)
            mill_over_segs.append(seg)
        else:
            travel_segs.append(seg)

        cur_x, cur_y = new_x, new_y

    return {
        "travel": travel_segs,
        "mill_over": mill_over_segs,
        "mill_under": mill_under_segs,
        "deposit": deposit_segs,
    }


# ── Main overlay function ───────────────────────────────────────────

def generate_overlay(
    image_path: Path,
    layer_result: LayerDetectionResult,
    mapped_layer: MappedLayerResult,
    gcode_text: str,
    mapper: PixelToBedMapper,
    original_coords: Optional[dict] = None,
    title: str = "Defect Detection & Repair Toolpath Overlay",
    save_path: Optional[Path] = None,
    show: bool = True,
    figsize: tuple = (18, 12),
) -> None:
    """
    Generate an overlay visualisation.

    Parameters
    ----------
    image_path : Path
        Raw camera image (full resolution).
    layer_result : LayerDetectionResult
        Defect detections with pixel-space bounding boxes.
    mapped_layer : MappedLayerResult
        Defects mapped to bed coordinates.
    gcode_text : str
        The generated repair G-code.
    mapper : PixelToBedMapper
        The mapper used (needed for bed→pixel inverse).
    original_coords : dict, optional
        Coordinate geometry dict with "X coordinates" and "Y coordinates"
        of the original print toolpath.
    title : str
        Plot title.
    save_path : Path, optional
        Where to save the overlay image.
    show : bool
        Whether to call plt.show().
    figsize : tuple
        Figure size in inches.
    """
    # Load camera image
    img = Image.open(image_path)
    img_array = np.array(img)

    fig, ax = plt.subplots(1, 1, figsize=figsize)
    ax.imshow(img_array)

    # ── 1. Draw original print toolpath (if provided) ────────────────
    if original_coords is not None:
        xs_mm = original_coords.get("X coordinates", [])
        ys_mm = original_coords.get("Y coordinates", [])
        if xs_mm and ys_mm:
            orig_segs_px = []
            for i in range(len(xs_mm) - 1):
                px1 = mapper.bed_to_pixel(xs_mm[i], ys_mm[i])
                px2 = mapper.bed_to_pixel(xs_mm[i + 1], ys_mm[i + 1])
                orig_segs_px.append((px1, px2))
            if orig_segs_px:
                lc = LineCollection(
                    orig_segs_px,
                    colors=COLOURS["original_toolpath"],
                    linewidths=0.5,
                    alpha=0.4,
                    label="Original toolpath",
                )
                ax.add_collection(lc)

    # ── 2. Draw defect bounding boxes (pixel space) ──────────────────
    over_count = under_count = 0
    for defect in layer_result.defects:
        bbox = defect.bbox
        is_over = defect.class_name == "Overextrusion"

        colour = COLOURS["overextrusion_box"] if is_over else COLOURS["underextrusion_box"]
        label_prefix = "Over" if is_over else "Under"

        rect = mpatches.Rectangle(
            (bbox.x1, bbox.y1),
            bbox.width,
            bbox.height,
            linewidth=2,
            edgecolor=colour,
            facecolor=colour + "20",   # 12% opacity fill
            linestyle="-",
        )
        ax.add_patch(rect)

        # Confidence label
        ax.text(
            bbox.x1 + 2, bbox.y1 - 5,
            f"{label_prefix} {defect.confidence:.0%}",
            fontsize=7,
            color=colour,
            fontweight="bold",
            bbox=dict(boxstyle="round,pad=0.15", facecolor="black", alpha=0.6),
        )

        if is_over:
            over_count += 1
        else:
            under_count += 1

    # ── 3. Draw mapped bed-space bounding boxes (converted back to px) 
    for md in mapped_layer.mapped_defects:
        bb = md.bed_bbox
        # Convert bed bbox corners to pixel
        px_min = mapper.bed_to_pixel(bb.x_min, bb.y_max)  # y_max → top (inverted)
        px_max = mapper.bed_to_pixel(bb.x_max, bb.y_min)  # y_min → bottom

        is_over = md.class_name == "Overextrusion"
        colour = COLOURS["bed_bbox_over"] if is_over else COLOURS["bed_bbox_under"]

        rect = mpatches.Rectangle(
            (px_min[0], px_min[1]),
            px_max[0] - px_min[0],
            px_max[1] - px_min[1],
            linewidth=1.5,
            edgecolor=colour[:7],
            facecolor="none",
            linestyle="--",
        )
        ax.add_patch(rect)

    # ── 4. Draw repair toolpath (bed mm → pixel conversion) ──────────
    segments = parse_gcode_segments(gcode_text)

    def _bed_segs_to_pixel(segs):
        return [
            (mapper.bed_to_pixel(x1, y1), mapper.bed_to_pixel(x2, y2))
            for (x1, y1), (x2, y2) in segs
        ]

    # Travel moves (Z-hopped between bounding boxes)
    if segments["travel"]:
        travel_px = _bed_segs_to_pixel(segments["travel"])
        lc_travel = LineCollection(
            travel_px,
            colors=COLOURS["travel"],
            linewidths=0.8,
            linestyles="dotted",
            alpha=0.4,
            label="Travel (Z-hop)",
        )
        ax.add_collection(lc_travel)

    # Phase 1a: Mill overextrusion — skim excess material
    if segments["mill_over"]:
        mo_px = _bed_segs_to_pixel(segments["mill_over"])
        lc_mo = LineCollection(
            mo_px,
            colors=COLOURS["mill_over"],
            linewidths=1.2,
            alpha=0.9,
            label="Phase 1a: Mill overextrusion (skim)",
        )
        ax.add_collection(lc_mo)

    # Phase 1b: Mill underextrusion — cut clean cavity
    if segments["mill_under"]:
        mu_px = _bed_segs_to_pixel(segments["mill_under"])
        lc_mu = LineCollection(
            mu_px,
            colors=COLOURS["mill_under"],
            linewidths=1.2,
            alpha=0.9,
            label="Phase 1b: Mill underextrusion (cavity)",
        )
        ax.add_collection(lc_mu)

    # Phase 2: Deposit — fill underextrusion cavities
    if segments["deposit"]:
        dep_px = _bed_segs_to_pixel(segments["deposit"])
        lc_dep = LineCollection(
            dep_px,
            colors=COLOURS["deposit"],
            linewidths=1.5,
            alpha=0.9,
            label="Phase 2: Deposit (fill cavity)",
        )
        ax.add_collection(lc_dep)

    # ── 5. Draw part boundary (40mm square centred at origin) ────────
    from config import PART_SIZE_MM
    half = PART_SIZE_MM / 2.0
    corners_mm = [(-half, -half), (half, -half), (half, half), (-half, half), (-half, -half)]
    corners_px = [mapper.bed_to_pixel(x, y) for x, y in corners_mm]
    xs_px = [c[0] for c in corners_px]
    ys_px = [c[1] for c in corners_px]
    ax.plot(xs_px, ys_px, color="white", linewidth=1.5, linestyle="-.", alpha=0.6,
            label="Part boundary (40 mm)")

    # ── Legend & labels ──────────────────────────────────────────────
    # Build custom legend
    handles = [
        mpatches.Patch(edgecolor=COLOURS["overextrusion_box"], facecolor="none",
                       linewidth=2, label=f"Overextrusion ({over_count})"),
        mpatches.Patch(edgecolor=COLOURS["underextrusion_box"], facecolor="none",
                       linewidth=2, label=f"Underextrusion ({under_count})"),
        plt.Line2D([0], [0], color=COLOURS["mill_over"], linewidth=1.5,
                   label="1a: Mill overextrusion (skim)"),
        plt.Line2D([0], [0], color=COLOURS["mill_under"], linewidth=1.5,
                   label="1b: Mill underextrusion (cavity)"),
        plt.Line2D([0], [0], color=COLOURS["deposit"], linewidth=1.5,
                   label="2: Deposit (fill cavity)"),
        plt.Line2D([0], [0], color=COLOURS["travel"], linewidth=0.8,
                   linestyle="dotted", label="Travel"),
        plt.Line2D([0], [0], color="white", linewidth=1.5, linestyle="-.",
                   label="Part boundary"),
    ]
    if original_coords is not None:
        handles.append(
            plt.Line2D([0], [0], color=COLOURS["original_toolpath"],
                       linewidth=1, alpha=0.5, label="Original toolpath")
        )

    ax.legend(
        handles=handles,
        loc="upper left",
        fontsize=8,
        framealpha=0.7,
        facecolor="black",
        edgecolor="grey",
        labelcolor="white",
    )

    ax.set_title(title, fontsize=13, fontweight="bold")
    ax.set_xlabel("Pixel X")
    ax.set_ylabel("Pixel Y")
    ax.set_xlim(0, img_array.shape[1])
    ax.set_ylim(img_array.shape[0], 0)
    ax.set_aspect("equal")

    plt.tight_layout()

    if save_path:
        save_path.parent.mkdir(parents=True, exist_ok=True)
        fig.savefig(save_path, dpi=200, bbox_inches="tight")
        print(f"Saved overlay: {save_path}")

    if show:
        plt.show()
    else:
        plt.close(fig)


# ── Convenience: build overlay for a sample ──────────────────────────

def overlay_for_sample(
    sample_name: str,
    show: bool = True,
    include_original_toolpath: bool = True,
) -> Optional[Path]:
    """
    Generate the full overlay for a given sample.

    Parameters
    ----------
    sample_name : str
        e.g. "1_13_35"
    show : bool
        Show the plot interactively.
    include_original_toolpath : bool
        Overlay the original print coordinate geometry.

    Returns
    -------
    Path to the saved overlay PNG, or None on failure.
    """
    from config import COORD_GEOM_DIR

    sample_dir = PROJECT_DATA_DIR / sample_name
    if not sample_dir.exists():
        print(f"Sample directory not found: {sample_dir}")
        return None

    # 1. Find camera image
    images = find_sample_images(sample_dir)
    if not images:
        print(f"No camera images found in {sample_dir}")
        return None
    image_path = images[0]  # raw image

    # 2. Load defect detections
    defects_file = find_defects_file(sample_dir)
    if defects_file is None:
        print(f"No Disk_Defects.txt found in {sample_dir}")
        return None
    layer_results = load_defects_from_file(defects_file)
    if not layer_results:
        print("No layer results found.")
        return None
    layer_result = layer_results[0]

    # 3. Create mapper (auto-detect image resolution)
    mapper = PixelToBedMapper.from_image(image_path)

    # 4. Map defects
    mapped_layer = mapper.map_layer(layer_result)

    # 5. Load or generate repair G-code
    # Extract sample number for G-code file lookup
    sample_num = sample_name.split("_")[0]

    gcode_path = OUTPUT_DIR / sample_name / f"repair_{sample_name}_layer0.gcode"
    if gcode_path.exists():
        gcode_text = gcode_path.read_text(encoding="utf-8")
    else:
        # Generate on-the-fly
        from repair_toolpath import generate_repair_gcode
        gcode_text = generate_repair_gcode(mapped_layer, z_height=0.4)

    # 6. Load original print coordinate geometry (optional)
    original_coords = None
    if include_original_toolpath:
        geom_path = COORD_GEOM_DIR / f"{sample_num}_coordinate_geometry.txt"
        if geom_path.exists():
            geom_data = load_coordinate_geometry(geom_path)
            if geom_data:
                original_coords = geom_data[0].get("Coordinate Data")

    # 7. Generate overlay
    save_path = OUTPUT_DIR / sample_name / f"overlay_{sample_name}.png"
    generate_overlay(
        image_path=image_path,
        layer_result=layer_result,
        mapped_layer=mapped_layer,
        gcode_text=gcode_text,
        mapper=mapper,
        original_coords=original_coords,
        title=f"Defect Detection & Repair Toolpath — Sample {sample_name}",
        save_path=save_path,
        show=show,
    )
    return save_path


# ── CLI ──────────────────────────────────────────────────────────────

def main():
    import argparse

    parser = argparse.ArgumentParser(
        description="Generate overlay of defect detections and repair toolpath",
    )
    parser.add_argument(
        "--sample", type=str, default="1_13_35",
        help="Sample folder name (default: 1_13_35)",
    )
    parser.add_argument(
        "--no-original", action="store_true",
        help="Omit original print toolpath from the overlay",
    )
    parser.add_argument(
        "--no-show", action="store_true",
        help="Don't show the plot interactively (just save)",
    )
    args = parser.parse_args()

    result = overlay_for_sample(
        sample_name=args.sample,
        show=not args.no_show,
        include_original_toolpath=not args.no_original,
    )
    if result:
        print(f"Done: {result}")
    else:
        print("Overlay generation failed.")


if __name__ == "__main__":
    main()
