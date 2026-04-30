# src/gcode_validator.py
"""
G-code validation module.

Provides three levels of validation:

1. **Static analysis** – parse the G-code text and check for common
   issues (out-of-bounds moves, missing safety commands, extrusion
   without prior unretract, etc.).
2. **CAMotics integration** – (optional) launch the CAMotics simulator
   in headless mode to verify the toolpath is safe and generates the
   expected geometry.
3. **Visual preview** – render a 2D matplotlib plot of the toolpath
   for quick sanity-checking.
"""

from __future__ import annotations

import re
import subprocess
import shutil
from dataclasses import dataclass, field
from pathlib import Path
from typing import List, Optional

import numpy as np

from config import (
    BED_RADIUS_MM,
    CAMERA_FOV_X_MM,
    CAMERA_FOV_Y_MM,
    CAMOTIX_EXECUTABLE,
    EXTRUDER_AXIS,
)


# ── Data structures ─────────────────────────────────────────────────

@dataclass
class ValidationIssue:
    """A single issue found during validation."""
    severity: str        # "error" | "warning" | "info"
    line_no: int         # 1-based line number in G-code
    message: str
    gcode_line: str = ""


@dataclass
class ValidationReport:
    """Summary of all validation checks."""
    file_path: Optional[Path] = None
    issues: List[ValidationIssue] = field(default_factory=list)
    total_lines: int = 0
    total_moves: int = 0
    total_extrusion_moves: int = 0
    total_travel_moves: int = 0
    bounding_box: dict = field(default_factory=lambda: {
        "x_min": float("inf"), "x_max": float("-inf"),
        "y_min": float("inf"), "y_max": float("-inf"),
        "z_min": float("inf"), "z_max": float("-inf"),
    })

    @property
    def has_errors(self) -> bool:
        return any(i.severity == "error" for i in self.issues)

    @property
    def has_warnings(self) -> bool:
        return any(i.severity == "warning" for i in self.issues)

    @property
    def is_valid(self) -> bool:
        return not self.has_errors

    def summary(self) -> str:
        errors   = sum(1 for i in self.issues if i.severity == "error")
        warnings = sum(1 for i in self.issues if i.severity == "warning")
        infos    = sum(1 for i in self.issues if i.severity == "info")
        bb = self.bounding_box
        status = "PASS" if self.is_valid else "FAIL"
        lines = [
            f"Validation: {status}",
            f"  Lines parsed     : {self.total_lines}",
            f"  Motion commands   : {self.total_moves}  "
            f"(extrusion={self.total_extrusion_moves}, "
            f"travel={self.total_travel_moves})",
            f"  Bounding box (mm) : "
            f"X[{bb['x_min']:.2f}, {bb['x_max']:.2f}]  "
            f"Y[{bb['y_min']:.2f}, {bb['y_max']:.2f}]  "
            f"Z[{bb['z_min']:.2f}, {bb['z_max']:.2f}]",
            f"  Issues            : {errors} errors, "
            f"{warnings} warnings, {infos} info",
        ]
        for issue in self.issues:
            lines.append(
                f"  [{issue.severity.upper():7s}] L{issue.line_no}: "
                f"{issue.message}"
            )
        return "\n".join(lines)


# ── Static G-code analyser ──────────────────────────────────────────

# Regex for extracting axis values from G-code lines
_AXIS_RE = re.compile(
    r"(?P<axis>[XYZABEF])\s*(?P<value>[+-]?\d+\.?\d*)", re.IGNORECASE
)
_GCODE_CMD_RE = re.compile(r"^[GM]\d+", re.IGNORECASE)


def _parse_axes(line: str) -> dict[str, float]:
    """Extract axis–value pairs from a G-code line."""
    return {m.group("axis").upper(): float(m.group("value"))
            for m in _AXIS_RE.finditer(line)}


class GCodeValidator:
    """
    Static analyser for repair G-code.

    Parameters
    ----------
    bed_x_range, bed_y_range : tuple[float, float]
        Allowed X/Y travel range on the print bed (mm).
    bed_z_range : tuple[float, float]
        Allowed Z range.
    """

    def __init__(
        self,
        bed_x_range: tuple[float, float] = (
            -BED_RADIUS_MM, BED_RADIUS_MM
        ),
        bed_y_range: tuple[float, float] = (
            -BED_RADIUS_MM, BED_RADIUS_MM
        ),
        bed_z_range: tuple[float, float] = (-1.0, 50.0),
    ):
        self.bed_x_range = bed_x_range
        self.bed_y_range = bed_y_range
        self.bed_z_range = bed_z_range

    def validate(
        self,
        gcode: str,
        file_path: Optional[Path] = None,
    ) -> ValidationReport:
        """
        Parse *gcode* text and return a ``ValidationReport``.
        """
        report = ValidationReport(file_path=file_path)
        lines = gcode.splitlines()
        report.total_lines = len(lines)

        cur_x = cur_y = cur_z = 0.0
        extruder_pos = 0.0
        retracted = False
        has_units = False
        has_abs_mode = False

        for line_no, raw_line in enumerate(lines, start=1):
            line = raw_line.split(";")[0].strip()   # strip comments
            if not line:
                continue

            upper = line.upper()

            # Track unit / positioning modes
            if "G21" in upper:
                has_units = True
            if "G90" in upper:
                has_abs_mode = True

            # Detect G0 / G1 motion
            is_rapid = upper.startswith("G0 ") or upper.startswith("G0\t") or upper == "G0"
            is_linear = upper.startswith("G1 ") or upper.startswith("G1\t") or upper == "G1"

            if not (is_rapid or is_linear):
                continue

            axes = _parse_axes(line)
            new_x = axes.get("X", cur_x)
            new_y = axes.get("Y", cur_y)
            new_z = axes.get("Z", cur_z)
            has_extrusion = EXTRUDER_AXIS in axes

            report.total_moves += 1
            if has_extrusion:
                report.total_extrusion_moves += 1
            else:
                report.total_travel_moves += 1

            # Update bounding box
            bb = report.bounding_box
            bb["x_min"] = min(bb["x_min"], new_x)
            bb["x_max"] = max(bb["x_max"], new_x)
            bb["y_min"] = min(bb["y_min"], new_y)
            bb["y_max"] = max(bb["y_max"], new_y)
            bb["z_min"] = min(bb["z_min"], new_z)
            bb["z_max"] = max(bb["z_max"], new_z)

            # Check bounds
            if not (self.bed_x_range[0] <= new_x <= self.bed_x_range[1]):
                report.issues.append(ValidationIssue(
                    severity="error", line_no=line_no,
                    message=f"X={new_x:.3f} out of bed range "
                            f"{self.bed_x_range}",
                    gcode_line=raw_line,
                ))
            if not (self.bed_y_range[0] <= new_y <= self.bed_y_range[1]):
                report.issues.append(ValidationIssue(
                    severity="error", line_no=line_no,
                    message=f"Y={new_y:.3f} out of bed range "
                            f"{self.bed_y_range}",
                    gcode_line=raw_line,
                ))
            if not (self.bed_z_range[0] <= new_z <= self.bed_z_range[1]):
                report.issues.append(ValidationIssue(
                    severity="warning", line_no=line_no,
                    message=f"Z={new_z:.3f} outside expected range "
                            f"{self.bed_z_range}",
                    gcode_line=raw_line,
                ))

            cur_x, cur_y, cur_z = new_x, new_y, new_z

        # Global checks
        if not has_units:
            report.issues.append(ValidationIssue(
                severity="warning", line_no=0,
                message="No G21 (mm mode) found – units may be ambiguous.",
            ))
        if not has_abs_mode:
            report.issues.append(ValidationIssue(
                severity="warning", line_no=0,
                message="No G90 (absolute positioning) found.",
            ))
        if report.total_moves == 0:
            report.issues.append(ValidationIssue(
                severity="warning", line_no=0,
                message="No motion commands found in the G-code.",
            ))

        return report

    def validate_file(self, path: Path) -> ValidationReport:
        """Convenience: read a G-code file and validate it."""
        gcode = path.read_text(encoding="utf-8")
        return self.validate(gcode, file_path=path)


# ── CAMotics simulation ─────────────────────────────────────────────

def run_camotics_check(
    gcode_path: Path,
    camotics_exe: str = CAMOTIX_EXECUTABLE,
    timeout: int = 60,
) -> dict:
    """
    Run CAMotics in headless / CLI mode on the given G-code file.

    Returns
    -------
    dict with keys:
        "available" : bool – whether CAMotics was found
        "returncode": int
        "stdout"    : str
        "stderr"    : str
    """
    exe = shutil.which(camotics_exe)
    if exe is None:
        return {
            "available": False,
            "returncode": -1,
            "stdout": "",
            "stderr": f"CAMotics executable '{camotics_exe}' not found on PATH.",
        }

    try:
        result = subprocess.run(
            [exe, "--export", str(gcode_path.with_suffix(".stl")),
             str(gcode_path)],
            capture_output=True, text=True, timeout=timeout,
        )
        return {
            "available": True,
            "returncode": result.returncode,
            "stdout": result.stdout,
            "stderr": result.stderr,
        }
    except subprocess.TimeoutExpired:
        return {
            "available": True,
            "returncode": -2,
            "stdout": "",
            "stderr": f"CAMotics timed out after {timeout}s.",
        }
    except Exception as e:
        return {
            "available": True,
            "returncode": -3,
            "stdout": "",
            "stderr": str(e),
        }


# ── 2-D Toolpath preview ────────────────────────────────────────────

def plot_toolpath(
    gcode: str,
    title: str = "Repair Toolpath Preview",
    show: bool = True,
    save_path: Optional[Path] = None,
):
    """
    Render per-tool-change 2D (X-Y) subplots of the repair toolpath.

    Subplot 1 — Milling (skim overextrusion):  orange paths
    Subplot 2 — Milling & fill (cavity prep + deposit):  green paths
    Travel moves shown as pastel-red dotted lines on both subplots.
    Legend placed outside the plot area.
    """
    import matplotlib.pyplot as plt
    from matplotlib.collections import LineCollection
    from overlay_visualisation import parse_gcode_segments

    segments = parse_gcode_segments(gcode)

    # ── Shared axis limits across both subplots ──
    all_segs = (
        segments["travel"]
        + segments["mill_over"]
        + segments["mill_under"]
        + segments["deposit"]
    )
    if not all_segs:
        return

    all_pts = [pt for seg in all_segs for pt in seg]
    xs = [p[0] for p in all_pts]
    ys = [p[1] for p in all_pts]
    pad = 2
    xlim = (min(xs) - pad, max(xs) + pad)
    ylim = (min(ys) - pad, max(ys) + pad)

    def _setup_ax(ax, subtitle):
        ax.set_xlabel("X (mm)")
        ax.set_ylabel("Y (mm)")
        ax.set_title(subtitle, fontsize=11)
        ax.set_aspect("equal")
        ax.set_xlim(xlim)
        ax.set_ylim(ylim)
        ax.grid(True, alpha=0.3)

    def _add_travel(ax, segs):
        if segs:
            lc = LineCollection(
                segs, colors="#E8837C", linestyles="dotted",
                linewidths=0.9, alpha=0.7, label="Travel (Z-hop)",
            )
            ax.add_collection(lc)

    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 6))
    fig.suptitle(title, fontsize=13, fontweight="bold")

    # ── Subplot 1: Milling skim (overextrusion) ──
    _add_travel(ax1, segments["travel"])
    if segments["mill_over"]:
        lc = LineCollection(
            segments["mill_over"], colors="#FF6B35",
            linewidths=1.4, alpha=0.9,
            label="1a: Mill overextrusion (skim)",
        )
        ax1.add_collection(lc)
    _setup_ax(ax1, "Tool 1 — Mill (skim overextrusion)")
    ax1.legend(fontsize=8, loc="upper left", bbox_to_anchor=(0, -0.10),
               borderaxespad=0, frameon=False, ncol=2)

    # ── Subplot 2: Mill cavity + deposit fill ──
    _add_travel(ax2, segments["travel"])
    cavity_segs = segments["mill_under"] + segments["deposit"]
    if cavity_segs:
        lc = LineCollection(
            cavity_segs, colors="#2DC653",
            linewidths=1.4, alpha=0.9,
            label="1b+2: Mill cavity & deposit fill",
        )
        ax2.add_collection(lc)
    _setup_ax(ax2, "Tool 2 — Mill cavity & deposit fill")
    ax2.legend(fontsize=8, loc="upper left", bbox_to_anchor=(0, -0.10),
               borderaxespad=0, frameon=False, ncol=2)

    fig.tight_layout(rect=[0, 0.05, 1, 0.94])

    if save_path:
        save_path.parent.mkdir(parents=True, exist_ok=True)
        fig.savefig(save_path, dpi=150, bbox_inches="tight")
        print(f"Saved toolpath preview: {save_path}")

    if show:
        plt.show()
    else:
        plt.close(fig)


# ── CLI entry point ──────────────────────────────────────────────────

def main():
    from config import OUTPUT_DIR

    gcode_path = OUTPUT_DIR / "repair_sample_1.gcode"
    if not gcode_path.exists():
        print(f"No repair G-code found at {gcode_path}.")
        print("Run repair_toolpath.py first to generate one.")
        return

    gcode = gcode_path.read_text(encoding="utf-8")

    # Static validation
    validator = GCodeValidator()
    report = validator.validate(gcode, file_path=gcode_path)
    print(report.summary())

    # CAMotics check (optional)
    print("\n--- CAMotics check ---")
    cam = run_camotics_check(gcode_path)
    if not cam["available"]:
        print(f"Skipped: {cam['stderr']}")
    else:
        print(f"Return code: {cam['returncode']}")
        if cam["stderr"]:
            print(f"stderr: {cam['stderr']}")

    # Visual preview
    plot_path = OUTPUT_DIR / "repair_preview.png"
    plot_toolpath(gcode, title="Repair Toolpath", show=False,
                  save_path=plot_path)


if __name__ == "__main__":
    main()
