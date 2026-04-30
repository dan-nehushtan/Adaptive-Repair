# src/defect_detection.py
"""
Defect detection module.

Two modes of operation
1.  **Live inference** – load the YOLOv8 model and run it on a camera image.
2.  **Cached results** – read an existing ``Disk_Defects.txt`` JSON file that
    was written by a previous detection pass.

Both paths return a uniform list of ``Defect`` dataclass instances so that
downstream modules (coordinate mapping, toolpath generation) are agnostic
to the detection source.
"""

from __future__ import annotations

import json
from dataclasses import dataclass, field
from pathlib import Path
from typing import List, Optional

import numpy as np

from config import (
    CONFIDENCE_THRESHOLD,
    IMAGE_SIZE,
    IOU_THRESHOLD,
    MODEL_PATH,
)


# ── Data structures ─────────────────────────────────────────────────

@dataclass
class BoundingBox:
    """Axis-aligned bounding box in pixel coordinates."""
    x1: float
    y1: float
    x2: float
    y2: float

    @property
    def width(self) -> float:
        return self.x2 - self.x1

    @property
    def height(self) -> float:
        return self.y2 - self.y1

    @property
    def area(self) -> float:
        return self.width * self.height

    @property
    def centre(self) -> tuple[float, float]:
        return ((self.x1 + self.x2) / 2, (self.y1 + self.y2) / 2)


@dataclass
class Defect:
    """Single detected defect."""
    class_name: str                   # "Overextrusion" | "Underextrusion"
    confidence: float                 # 0 – 1
    bbox: BoundingBox                 # pixel-space bounding box
    box_area_px: float = 0.0
    box_aspect_ratio: float = 0.0


@dataclass
class LayerDetectionResult:
    """All defects detected in one layer."""
    layer_number: int
    defects: List[Defect] = field(default_factory=list)

    @property
    def num_defects(self) -> int:
        return len(self.defects)

    @property
    def num_overextrusions(self) -> int:
        return sum(1 for d in self.defects if d.class_name == "Overextrusion")

    @property
    def num_underextrusions(self) -> int:
        return sum(1 for d in self.defects if d.class_name == "Underextrusion")


# ── Load from existing Disk_Defects.txt ──────────────────────────────

def load_defects_from_file(defects_path: Path) -> List[LayerDetectionResult]:
    """
    Parse a ``Disk_Defects.txt`` JSON file and return structured results.

    Parameters
    ----------
    defects_path : Path
        Path to the JSON defect file (one per sample folder).

    Returns
    -------
    list[LayerDetectionResult]
    """
    with open(defects_path, "r") as f:
        raw: list[dict] = json.load(f)

    results: List[LayerDetectionResult] = []
    for layer_dict in raw:
        layer_num = layer_dict.get("Layer number", 0)
        defects: List[Defect] = []
        for dd in layer_dict.get("Defect data", []):
            coords = dd["Defect coordinates"]  # [x1, y1, x2, y2]
            defects.append(
                Defect(
                    class_name=dd["Class"],
                    confidence=dd["Confidence"],
                    bbox=BoundingBox(
                        x1=coords[0], y1=coords[1],
                        x2=coords[2], y2=coords[3],
                    ),
                    box_area_px=dd.get("Box area (px)", 0),
                    box_aspect_ratio=dd.get("Box aspect ratio", 0),
                )
            )
        results.append(LayerDetectionResult(layer_number=layer_num, defects=defects))
    return results


# ── Live YOLOv8 inference ────────────────────────────────────────────

class DefectDetector:
    """
    Wraps the YOLOv8 model for on-the-fly defect inference.

    Usage
    -----
    >>> detector = DefectDetector()
    >>> result   = detector.detect("path/to/layer_image.bmp")
    """

    def __init__(self, model_path: Optional[Path] = None):
        from ultralytics import YOLO

        self.model_path = model_path or MODEL_PATH
        if not self.model_path.exists():
            raise FileNotFoundError(f"Model not found: {self.model_path}")
        self.model = YOLO(str(self.model_path))
        # Build a reverse class-name map from the model
        self._class_names: dict[int, str] = self.model.names  # {0: 'Overextrusion', …}

    def detect(
        self,
        image_path: str | Path,
        confidence: float = CONFIDENCE_THRESHOLD,
        iou: float = IOU_THRESHOLD,
        imgsz: int = IMAGE_SIZE,
        layer_number: int = 0,
    ) -> LayerDetectionResult:
        """
        Run inference on a single image.

        Returns
        -------
        LayerDetectionResult
        """
        results = self.model.predict(
            source=str(image_path),
            conf=confidence,
            iou=iou,
            imgsz=imgsz,
            verbose=False,
        )

        defects: List[Defect] = []
        for r in results:
            boxes = r.boxes
            if boxes is None:
                continue
            for i in range(len(boxes)):
                xyxy = boxes.xyxy[i].cpu().numpy()
                cls_id = int(boxes.cls[i].cpu().item())
                conf = float(boxes.conf[i].cpu().item())
                x1, y1, x2, y2 = xyxy
                w, h = x2 - x1, y2 - y1
                defects.append(
                    Defect(
                        class_name=self._class_names.get(cls_id, f"class_{cls_id}"),
                        confidence=conf,
                        bbox=BoundingBox(x1=float(x1), y1=float(y1),
                                         x2=float(x2), y2=float(y2)),
                        box_area_px=float(w * h),
                        box_aspect_ratio=float(w / h) if h > 0 else 0.0,
                    )
                )
        return LayerDetectionResult(layer_number=layer_number, defects=defects)

    def detect_batch(
        self,
        image_paths: list[str | Path],
        **kwargs,
    ) -> List[LayerDetectionResult]:
        """Run detection on multiple images, returning one result per image."""
        return [
            self.detect(p, layer_number=i, **kwargs)
            for i, p in enumerate(image_paths)
        ]


# ── Convenience helpers ──────────────────────────────────────────────

def find_sample_images(sample_dir: Path) -> list[Path]:
    """
    Return the raw camera image(s) inside a sample folder, excluding
    annotated defectsImage files.
    """
    camera_dir = sample_dir / "Camera"
    if not camera_dir.exists():
        return []
    return sorted(
        p for p in camera_dir.glob("*.bmp")
        if not p.name.startswith("defects")
    )


def find_defects_file(sample_dir: Path) -> Optional[Path]:
    """Return the ``Disk_Defects.txt`` path if it exists for a sample."""
    p = sample_dir / "Disk_Defects.txt"
    return p if p.exists() else None


# ── CLI entry point ──────────────────────────────────────────────────

def main():
    """Quick smoke-test: load defects from sample 1 and print summary."""
    from config import PROJECT_DATA_DIR

    sample = PROJECT_DATA_DIR / "1_13_35"
    defects_file = find_defects_file(sample)
    if defects_file is None:
        print("No Disk_Defects.txt found – running live detection instead.")
        images = find_sample_images(sample)
        if not images:
            print("No camera images found either. Exiting.")
            return
        detector = DefectDetector()
        result = detector.detect(images[0])
    else:
        results = load_defects_from_file(defects_file)
        result = results[0] if results else None

    if result is None:
        print("No results.")
        return

    print(f"Layer {result.layer_number}: "
          f"{result.num_defects} defects "
          f"({result.num_overextrusions} over, "
          f"{result.num_underextrusions} under)")
    for d in result.defects[:5]:
        print(f"  {d.class_name:16s}  conf={d.confidence:.2f}  "
              f"bbox=({d.bbox.x1:.0f},{d.bbox.y1:.0f})-"
              f"({d.bbox.x2:.0f},{d.bbox.y2:.0f})")
    if result.num_defects > 5:
        print(f"  … and {result.num_defects - 5} more")


if __name__ == "__main__":
    main()
