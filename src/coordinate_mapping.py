# src/coordinate_mapping.py
"""
Coordinate mapping module.

Converts defect bounding boxes from **pixel space** (image coordinates)
to **machine / printer-bed space** (millimetres) so that the repair
toolpath generator knows exactly where to deposit or mill material.

The mapping assumes a simple affine (scale + translate) transformation
between the camera image and the print bed.  If a more complex
transformation is needed (e.g. lens distortion, perspective warp) the
``PixelToBedMapper`` class can be sub-classed.
"""

from __future__ import annotations

import json
from dataclasses import dataclass
from pathlib import Path
from typing import List, Optional

import numpy as np

from config import (
    BED_RADIUS_MM,
    CAMERA_FOV_X_MM,
    CAMERA_FOV_Y_MM,
    IMAGE_HEIGHT_PX,
    IMAGE_WIDTH_PX,
    MM_PER_PIXEL,
    REPAIR_MARGIN_MM,
)
from defect_detection import BoundingBox, Defect, LayerDetectionResult


# ── Data structure for bed-space defects ─────────────────────────────

@dataclass
class BedBoundingBox:
    """Bounding box in printer-bed millimetres."""
    x_min: float   # mm
    y_min: float   # mm
    x_max: float   # mm
    y_max: float   # mm

    @property
    def width(self) -> float:
        return self.x_max - self.x_min

    @property
    def height(self) -> float:
        return self.y_max - self.y_min

    @property
    def area(self) -> float:
        return self.width * self.height

    @property
    def centre(self) -> tuple[float, float]:
        return ((self.x_min + self.x_max) / 2, (self.y_min + self.y_max) / 2)


@dataclass
class MappedDefect:
    """A defect with both pixel and bed-space coordinates."""
    class_name: str
    confidence: float
    pixel_bbox: BoundingBox         # original pixel coords
    bed_bbox: BedBoundingBox        # converted machine coords (mm)


@dataclass
class MappedLayerResult:
    """All mapped defects for a single layer."""
    layer_number: int
    mapped_defects: List[MappedDefect]

    @property
    def has_defects(self) -> bool:
        return len(self.mapped_defects) > 0


# ── Mapper ───────────────────────────────────────────────────────────

class PixelToBedMapper:
    """
    Converts pixel coordinates to printer-bed coordinates using a
    centre-referenced affine transformation:

        bed_x =  (pixel_x - image_cx) * mm_per_pixel
        bed_y = -(pixel_y - image_cy) * mm_per_pixel   (Y inverted)

    The image centre maps to the bed origin (0, 0), which is where
    all CHAMP parts are printed.

    Parameters
    ----------
    image_width_px, image_height_px : int
        Resolution of the RAW camera image (bounding boxes are in this
        coordinate space, NOT the downscaled defects image).
    mm_per_pixel : float
        Uniform scale factor.  Must be calibrated to the camera setup.
    invert_y : bool
        If True (default), image-Y-down is mapped to bed-Y-up.
    margin_mm : float
        Extra margin added around each defect bbox for safer repair.
    bed_radius_mm : float
        Radius of the circular CHAMP bed, used for clamping.
    """

    def __init__(
        self,
        image_width_px: int = IMAGE_WIDTH_PX,
        image_height_px: int = IMAGE_HEIGHT_PX,
        mm_per_pixel: float = MM_PER_PIXEL,
        invert_y: bool = True,
        margin_mm: float = REPAIR_MARGIN_MM,
        bed_radius_mm: float = BED_RADIUS_MM,
    ):
        self.image_width_px = image_width_px
        self.image_height_px = image_height_px
        self.mm_per_pixel = mm_per_pixel
        self.invert_y = invert_y
        self.margin_mm = margin_mm
        self.bed_radius_mm = bed_radius_mm

        # Image centre (pixel coordinates of bed origin)
        self.cx = image_width_px / 2.0
        self.cy = image_height_px / 2.0

    # ── Core conversion ──────────────────────────────────────────────

    def pixel_to_bed(self, px_x: float, px_y: float) -> tuple[float, float]:
        """Convert a single (px_x, px_y) point to bed (mm_x, mm_y)."""
        mm_x = (px_x - self.cx) * self.mm_per_pixel
        if self.invert_y:
            mm_y = -(px_y - self.cy) * self.mm_per_pixel
        else:
            mm_y = (px_y - self.cy) * self.mm_per_pixel
        return (mm_x, mm_y)

    def bed_to_pixel(self, mm_x: float, mm_y: float) -> tuple[float, float]:
        """Convert a bed coordinate (mm) back to pixel space (inverse)."""
        px_x = mm_x / self.mm_per_pixel + self.cx
        if self.invert_y:
            px_y = -(mm_y / self.mm_per_pixel) + self.cy
        else:
            px_y = mm_y / self.mm_per_pixel + self.cy
        return (px_x, px_y)

    def bbox_pixel_to_bed(
        self,
        bbox: BoundingBox,
        margin: Optional[float] = None,
    ) -> BedBoundingBox:
        """
        Convert a pixel bounding box to a bed bounding box in mm,
        optionally adding a safety margin.
        """
        margin = margin if margin is not None else self.margin_mm

        # Convert all four corners
        x1_bed, y1_bed = self.pixel_to_bed(bbox.x1, bbox.y1)
        x2_bed, y2_bed = self.pixel_to_bed(bbox.x2, bbox.y2)

        # Ensure min < max (Y inversion swaps top/bottom)
        x_min = min(x1_bed, x2_bed)
        x_max = max(x1_bed, x2_bed)
        y_min = min(y1_bed, y2_bed)
        y_max = max(y1_bed, y2_bed)

        # Apply safety margin
        x_min -= margin
        y_min -= margin
        x_max += margin
        y_max += margin

        # Clamp to bed limits (circular bed approximated as square bound)
        r = self.bed_radius_mm
        x_min = max(x_min, -r)
        y_min = max(y_min, -r)
        x_max = min(x_max, r)
        y_max = min(y_max, r)

        return BedBoundingBox(x_min=x_min, y_min=y_min,
                              x_max=x_max, y_max=y_max)

    # ── Map a full detection result ──────────────────────────────────

    def map_layer(self, layer_result: LayerDetectionResult) -> MappedLayerResult:
        """
        Convert every defect in a ``LayerDetectionResult`` from pixel to
        bed coordinates.
        """
        mapped: List[MappedDefect] = []
        for defect in layer_result.defects:
            bed_bbox = self.bbox_pixel_to_bed(defect.bbox)
            mapped.append(
                MappedDefect(
                    class_name=defect.class_name,
                    confidence=defect.confidence,
                    pixel_bbox=defect.bbox,
                    bed_bbox=bed_bbox,
                )
            )
        return MappedLayerResult(
            layer_number=layer_result.layer_number,
            mapped_defects=mapped,
        )

    # ── Convenience: auto-detect image resolution ────────────────────

    @classmethod
    def from_image(
        cls,
        image_path: Path,
        mm_per_pixel: float = MM_PER_PIXEL,
        invert_y: bool = True,
        margin_mm: float = REPAIR_MARGIN_MM,
        bed_radius_mm: float = BED_RADIUS_MM,
    ) -> "PixelToBedMapper":
        """
        Create a mapper by reading the actual image dimensions from
        the file header (avoids hard-coding resolution).
        """
        from PIL import Image

        with Image.open(image_path) as img:
            w, h = img.size
        return cls(
            image_width_px=w,
            image_height_px=h,
            mm_per_pixel=mm_per_pixel,
            invert_y=invert_y,
            margin_mm=margin_mm,
            bed_radius_mm=bed_radius_mm,
        )


# ── Utility: load coordinate geometry for cross-referencing ──────────

def load_coordinate_geometry(geometry_path: Path) -> list[dict]:
    """
    Load a ``*_coordinate_geometry.txt`` JSON file that contains the
    original toolpath X/Y coordinates extracted from the AM G-code.
    Useful for cross-referencing defect locations with the original
    print path.
    """
    with open(geometry_path, "r") as f:
        return json.load(f)


# ── CLI demo ─────────────────────────────────────────────────────────

def main():
    from config import PROJECT_DATA_DIR
    from defect_detection import find_defects_file, load_defects_from_file

    sample = PROJECT_DATA_DIR / "1_13_35"
    defects_file = find_defects_file(sample)
    if defects_file is None:
        print("No Disk_Defects.txt found. Exiting.")
        return

    layer_results = load_defects_from_file(defects_file)
    if not layer_results:
        print("No layers found. Exiting.")
        return

    mapper = PixelToBedMapper()
    for lr in layer_results:
        mapped = mapper.map_layer(lr)
        if not mapped.has_defects:
            continue
        print(f"\nLayer {mapped.layer_number}: "
              f"{len(mapped.mapped_defects)} defects mapped")
        for md in mapped.mapped_defects[:5]:
            cx, cy = md.bed_bbox.centre
            print(f"  {md.class_name:16s}  conf={md.confidence:.2f}  "
                  f"bed centre=({cx:+.2f}, {cy:+.2f}) mm  "
                  f"size={md.bed_bbox.width:.2f}x{md.bed_bbox.height:.2f} mm")


if __name__ == "__main__":
    main()