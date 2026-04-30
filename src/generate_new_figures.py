"""
generate_new_figures.py
-----------------------
Generates methodology-focused figures for the report:

  fig17_travel_optimisation.png  - Naive sequential vs nearest-neighbour travel paths
  fig18_repair_cross_section.png - Cross-section schematic: overextrusion skim vs
                                   underextrusion excavate-and-fill

Usage:
    cd src
    python generate_new_figures.py
"""

import json
import math
from pathlib import Path

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import matplotlib.patches as FancyArrowPatch
import numpy as np

# ---------------------------------------------------------------------------
# Paths
# ---------------------------------------------------------------------------
SRC_DIR = Path(__file__).parent
PROJECT_DIR = SRC_DIR.parent
_v3 = PROJECT_DIR / "output" / "v3_cached_monitor" / "batch_report.json"
_v2 = PROJECT_DIR / "output" / "v2_adaptive_monitor" / "batch_report.json"
BATCH_REPORT = _v3 if _v3.exists() else _v2
OUTPUT_DIR = PROJECT_DIR / "output" / "results_analysis"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

# ---------------------------------------------------------------------------
# Style -- match existing report figures
# ---------------------------------------------------------------------------
plt.rcParams.update({
    "font.family": "serif",
    "font.size": 18,
    "axes.titlesize": 20,
    "axes.labelsize": 18,
    "xtick.labelsize": 16,
    "ytick.labelsize": 16,
    "legend.fontsize": 16,
    "figure.dpi": 150,
    "savefig.dpi": 300,
    "savefig.bbox": "tight",
    "axes.spines.top": False,
    "axes.spines.right": False,
    "axes.grid": True,
    "grid.alpha": 0.3,
    "grid.linewidth": 0.5,
})

ORANGE = "#E87722"
CYAN   = "#00A3B4"
GREEN  = "#2CA02C"
GREY   = "#888888"
BLUE   = "#1F77B4"
RED    = "#D62728"


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
def load_report(path: Path) -> dict:
    with open(path, "r") as f:
        return json.load(f)


def defect_centre(d: dict) -> tuple[float, float]:
    bb = d["bed_bbox"]
    return ((bb["x_min"] + bb["x_max"]) / 2.0,
            (bb["y_min"] + bb["y_max"]) / 2.0)


def total_travel(centres, start=(0.0, 0.0)):
    total = 0.0
    cx, cy = start
    for dx, dy in centres:
        total += math.hypot(dx - cx, dy - cy)
        cx, cy = dx, dy
    return total


def nearest_neighbour_order(centres, start=(0.0, 0.0)):
    if len(centres) <= 1:
        return list(centres)
    remaining = list(centres)
    ordered = []
    cx, cy = start
    while remaining:
        best_idx = 0
        best_dist = float("inf")
        for i, (dx, dy) in enumerate(remaining):
            dist = math.hypot(dx - cx, dy - cy)
            if dist < best_dist:
                best_dist = dist
                best_idx = i
        chosen = remaining.pop(best_idx)
        ordered.append(chosen)
        cx, cy = chosen
    return ordered


# ---------------------------------------------------------------------------
# Figure 17 -- Travel path comparison: naive sequential vs nearest-neighbour
# ---------------------------------------------------------------------------
def fig17_travel_optimisation(report):
    # Use sample 1_13_35 (19 defects) as the example
    samples = report["samples"]
    sample = next(s for s in samples if s["sample"] == "1_13_35")
    defects = sample["defects"]

    # Get centres and classes
    centres = [defect_centre(d) for d in defects]
    classes = [d["class"] for d in defects]

    # Naive order = detection order (as they come from YOLO)
    naive_order = list(centres)
    # Nearest-neighbour order from origin
    nn_order = nearest_neighbour_order(centres, start=(0.0, 0.0))

    naive_dist = total_travel(naive_order)
    nn_dist = total_travel(nn_order)
    saving_pct = (1 - nn_dist / naive_dist) * 100

    fig, axes = plt.subplots(1, 2, figsize=(10, 5.0))

    for ax_idx, (ax, order, label, dist, colour) in enumerate(zip(
        axes,
        [naive_order, nn_order],
        ["Sequential (detection order)", "Nearest-neighbour"],
        [naive_dist, nn_dist],
        [RED, GREEN],
    )):
        # Draw bed
        theta = np.linspace(0, 2 * np.pi, 360)
        ax.plot(60 * np.cos(theta), 60 * np.sin(theta), "k-",
                linewidth=0.6, alpha=0.3)
        rect = plt.Rectangle((-20, -20), 40, 40, fill=False,
                              edgecolor="grey", linewidth=0.6, linestyle="--")
        ax.add_patch(rect)

        # Draw travel path
        path_x = [0.0] + [c[0] for c in order]
        path_y = [0.0] + [c[1] for c in order]
        ax.plot(path_x, path_y, color=colour, linewidth=1.0, alpha=0.6,
                zorder=2)

        # Draw arrows along path segments
        for i in range(len(path_x) - 1):
            dx = path_x[i+1] - path_x[i]
            dy = path_y[i+1] - path_y[i]
            seg_len = math.hypot(dx, dy)
            if seg_len > 0.5:
                mid_x = path_x[i] + dx * 0.5
                mid_y = path_y[i] + dy * 0.5
                ax.annotate("", xy=(mid_x + dx*0.01, mid_y + dy*0.01),
                           xytext=(mid_x, mid_y),
                           arrowprops=dict(arrowstyle="->", color=colour,
                                          lw=0.8))

        # Draw defect bounding boxes
        for j, d in enumerate(defects):
            bb = d["bed_bbox"]
            w = bb["x_max"] - bb["x_min"]
            h = bb["y_max"] - bb["y_min"]
            c = ORANGE if d["class"] == "Overextrusion" else CYAN
            r = plt.Rectangle((bb["x_min"], bb["y_min"]), w, h,
                              facecolor=c, alpha=0.4, edgecolor=c,
                              linewidth=0.8, zorder=3)
            ax.add_patch(r)

        # Origin marker
        ax.plot(0, 0, "k+", markersize=12, markeredgewidth=2.0, zorder=4)
        ax.annotate("Origin\n(0, 0)", xy=(0, 0), xytext=(5, 8),
                    fontsize=14, color="black")

        # Number the visit order
        for i, (cx, cy) in enumerate(order):
            ax.text(cx, cy, str(i+1), fontsize=13, ha="center", va="center",
                    fontweight="bold", color="white",
                    bbox=dict(boxstyle="round,pad=0.15", facecolor="black",
                             alpha=0.7),
                    zorder=5)

        ax.set_xlim(-25, 25)
        ax.set_ylim(-25, 20)
        ax.set_aspect("equal")
        ax.set_xlabel("X (mm)", fontsize=16)
        ax.set_ylabel("Y (mm)", fontsize=16)
        ax.tick_params(labelsize=14)

    # Legend for defect types
    over_patch = mpatches.Patch(facecolor=ORANGE, alpha=0.4,
                                edgecolor=ORANGE, label="Overextrusion")
    under_patch = mpatches.Patch(facecolor=CYAN, alpha=0.4,
                                 edgecolor=CYAN, label="Underextrusion")
    fig.legend(handles=[over_patch, under_patch], loc="lower center",
               ncol=2, fontsize=16, frameon=False,
               bbox_to_anchor=(0.5, -0.02))

    fig.tight_layout()
    path = OUTPUT_DIR / "fig17_travel_optimisation.png"
    fig.savefig(path, bbox_inches="tight")
    plt.close(fig)
    print(f"  Saved: {path.name}  (naive={naive_dist:.1f} mm, "
          f"NN={nn_dist:.1f} mm, saving={saving_pct:.0f}%)")


# ---------------------------------------------------------------------------
# Figure 18 -- Repair cross-section schematic
# ---------------------------------------------------------------------------
def fig18_repair_cross_section():
    """
    Side-view schematic showing the two repair strategies:
      Left:  Overextrusion -- skim at Z_layer
      Right: Underextrusion -- excavate to Z_layer-0.4mm, then fill
    """
    fig, axes = plt.subplots(1, 2, figsize=(13, 4.5))

    # Disable grid for schematic diagrams
    for ax in axes:
        ax.grid(False)
        ax.spines["top"].set_visible(False)
        ax.spines["right"].set_visible(False)

    # --- Left panel: Overextrusion skim ---
    ax = axes[0]

    # Layer below (previous layer)
    ax.fill_between([0, 10], -0.4, 0, color="#D4C5A9", alpha=0.6,
                    label="Previous layer")

    # Current layer with overextrusion bump
    # Normal region left
    ax.fill_between([0, 3], 0, 0.4, color="#C4B08B", alpha=0.8)
    # Overextrusion bump
    bump_x = np.array([3, 3.5, 4, 4.5, 5, 5.5, 6, 6.5, 7])
    bump_y = np.array([0.4, 0.52, 0.62, 0.68, 0.7, 0.68, 0.60, 0.48, 0.4])
    ax.fill_between(bump_x, 0, bump_y, color="#C4B08B", alpha=0.8)
    # Normal region right
    ax.fill_between([7, 10], 0, 0.4, color="#C4B08B", alpha=0.8,
                    label="Current layer")

    # Excess material (above Z_layer) in red
    ax.fill_between(bump_x, 0.4, bump_y, color=ORANGE, alpha=0.5,
                    label="Excess material\n(removed by skim)")

    # Z_layer line
    ax.axhline(0.4, color="black", linewidth=1.2, linestyle="--")
    ax.annotate("$Z_{layer}$", xy=(10.2, 0.47), fontsize=14,
                va="center")

    # Mill tool indicator
    ax.annotate("", xy=(5, 0.85), xytext=(5, 0.4),
                arrowprops=dict(arrowstyle="<-", color="black", lw=1.5))
    ax.text(5, 0.92, "T1 Mill\n(skim)", ha="center", va="bottom",
            fontsize=13, fontweight="bold")

    # Dashed line showing material removal
    ax.plot([3, 7], [0.4, 0.4], color="red", linewidth=2, linestyle="-",
            alpha=0.8)

    ax.set_xlim(-0.5, 11.5)
    ax.set_ylim(-0.7, 1.3)
    ax.set_xlabel("X position (mm)")
    ax.set_ylabel("Z height (mm)")
    ax.set_title("")
    ax.legend(loc="upper left", fontsize=12, framealpha=0.9,
              bbox_to_anchor=(0.75, 1.0), borderaxespad=0)

    # --- Right panel: Underextrusion excavate + fill ---
    ax = axes[1]

    # Layer below
    ax.fill_between([0, 10], -0.4, 0, color="#D4C5A9", alpha=0.6,
                    label="Previous layer")

    # Current layer with void
    ax.fill_between([0, 3.5], 0, 0.4, color="#C4B08B", alpha=0.8)
    ax.fill_between([6.5, 10], 0, 0.4, color="#C4B08B", alpha=0.8,
                    label="Current layer")
    # Partial/thin material in the void region
    void_x = np.array([3.5, 4.0, 4.5, 5.0, 5.5, 6.0, 6.5])
    void_y = np.array([0.4, 0.15, 0.08, 0.05, 0.10, 0.20, 0.4])
    ax.fill_between(void_x, 0, void_y, color="#C4B08B", alpha=0.4)

    # Show the void region
    ax.fill_between(void_x, void_y, 0.4, color="white", alpha=0.9)
    # Mark void with hatching
    ax.fill_between(void_x, void_y, 0.4, facecolor="none",
                    edgecolor=CYAN, alpha=0.4, hatch="///",
                    label="Void (underextrusion)")

    # Z_layer line
    ax.axhline(0.4, color="black", linewidth=1.2, linestyle="--")
    ax.annotate("$Z_{layer}$", xy=(10.2, 0.30), fontsize=14, va="center")

    # Z_layer - 0.4 line
    ax.axhline(0.0, color="grey", linewidth=0.8, linestyle=":")
    ax.annotate("$Z_{layer} - 0.4$", xy=(10.2, 0.0), fontsize=14,
                va="center", color="grey")

    # Phase 1: Mill arrow (excavate) -- shifted left to avoid overlap
    ax.annotate("", xy=(4.0, 0.0), xytext=(4.0, 0.55),
                arrowprops=dict(arrowstyle="->", color="black", lw=1.5))
    ax.text(3.8, 0.62, "Phase 1\nT1 Mill\n(excavate)", ha="center",
            va="bottom", fontsize=13, fontweight="bold")

    # Phase 2: Fill arrow (deposit) -- shifted right to avoid overlap
    # Show fill material
    ax.fill_between([3.5, 6.5], 0, 0.4, color=GREEN, alpha=0.25,
                    label="Deposited fill\n(Phase 2)")
    ax.annotate("", xy=(6.0, 0.55), xytext=(6.0, 0.85),
                arrowprops=dict(arrowstyle="->", color=GREEN, lw=1.5))
    ax.text(6.2, 0.92, "Phase 2\nT0 Nozzle\n(fill)", ha="center",
            va="bottom", fontsize=13, fontweight="bold", color=GREEN)

    ax.set_xlim(-0.5, 11.5)
    ax.set_ylim(-0.7, 1.3)
    ax.set_xlabel("X position (mm)")
    ax.set_ylabel("Z height (mm)")
    ax.set_title("")
    ax.legend(loc="upper left", fontsize=12, framealpha=0.9,
              bbox_to_anchor=(0.75, 1.0), borderaxespad=0)

    fig.tight_layout()
    path = OUTPUT_DIR / "fig18_repair_cross_section.png"
    fig.savefig(path, bbox_inches="tight")
    plt.close(fig)
    print(f"  Saved: {path.name}")


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
def main():
    print(f"Loading: {BATCH_REPORT}")
    report = load_report(BATCH_REPORT)

    print("Generating new methodology figures...\n")
    fig17_travel_optimisation(report)
    fig18_repair_cross_section()
    print("\nDone.")


if __name__ == "__main__":
    main()
