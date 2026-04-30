"""
results_analysis.py
-------------------
Reads batch_report.json from the v2_adaptive_monitor run and generates
publication-quality figures for the report.

Outputs (saved to output/results_analysis/):
  fig1_defect_count_distribution.png   - Defect count per layer histogram
  fig2_area_savings_distribution.png   - Area savings % distribution
  fig3_defect_type_split.png           - Overextrusion vs underextrusion breakdown
  fig4_defect_size_distribution.png    - Bounding box area distribution (mm^2)
  fig5_spatial_defect_map.png          - Defect centres plotted on bed footprint
  fig6_confidence_distribution.png     - Detection confidence score distribution
  fig7_gcode_scaling.png               - G-code lines vs defect count scatter
  fig8_travel_optimisation.png         - Phase travel savings summary (bar chart)

Usage:
    cd src
    python results_analysis.py
"""

import json
import math
import os
import sys
from pathlib import Path

import matplotlib
matplotlib.use("Agg")
import matplotlib.patches as mpatches
import matplotlib.pyplot as plt
import numpy as np

# ---------------------------------------------------------------------------
# Paths
# ---------------------------------------------------------------------------
SRC_DIR = Path(__file__).parent
PROJECT_DIR = SRC_DIR.parent

# Default to cached run (v3) if it exists, else fall back to live run (v2)
_v3 = PROJECT_DIR / "output" / "v3_cached_monitor" / "batch_report.json"
_v2 = PROJECT_DIR / "output" / "v2_adaptive_monitor" / "batch_report.json"
BATCH_REPORT = _v3 if _v3.exists() else _v2

OUTPUT_DIR = PROJECT_DIR / "output" / "results_analysis"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

# The LaTeX report reads figures from Individual Report/figures/ (see
# \graphicspath in main.tex), not from this output folder, so we mirror every
# PNG there after generation to keep the compiled PDF in sync.
REPORT_FIGURES_DIR = (PROJECT_DIR.parent / "Individual Report" / "figures")

# ---------------------------------------------------------------------------
# Style -- match report aesthetics (Times-like, clean, no chartjunk)
# ---------------------------------------------------------------------------
plt.rcParams.update({
    "font.family": "serif",
    "font.size": 15,
    "axes.titlesize": 16,
    "axes.labelsize": 15,
    "xtick.labelsize": 14,
    "ytick.labelsize": 14,
    "legend.fontsize": 13,
    "figure.dpi": 150,
    "savefig.dpi": 300,
    "savefig.bbox": "tight",
    "axes.spines.top": False,
    "axes.spines.right": False,
    "axes.grid": True,
    "grid.alpha": 0.3,
    "grid.linewidth": 0.5,
})

ORANGE  = "#E87722"   # overextrusion / mill-over
CYAN    = "#00A3B4"   # underextrusion / mill-under
GREEN   = "#2CA02C"   # deposit
GREY    = "#888888"   # neutral
BLUE    = "#1F77B4"   # generic

# ---------------------------------------------------------------------------
# Load data
# ---------------------------------------------------------------------------
def load_report(path: Path) -> dict:
    with open(path, "r") as f:
        return json.load(f)


def extract_samples(report: dict) -> list[dict]:
    return report["samples"]


def repair_samples(samples: list[dict]) -> list[dict]:
    return [s for s in samples if s["repair_needed"]]


# ---------------------------------------------------------------------------
# Figure 1 -- Defect count per repair layer
# ---------------------------------------------------------------------------
def fig1_defect_count_distribution(samples):
    rep = repair_samples(samples)
    counts = [s["defects_found"] for s in rep]
    n_repair = len(counts)
    max_count = max(counts)
    bins = list(range(1, max_count + 2))

    total_over  = sum(s["overextrusions"]  for s in rep)
    total_under = sum(s["underextrusions"] for s in rep)
    total       = total_over + total_under

    fig, (ax, ax_pie) = plt.subplots(1, 2, figsize=(11, 4),
                                     gridspec_kw={"width_ratios": [2, 1]})

    # --- Left: histogram ---
    n, edges, patches = ax.hist(counts, bins=bins, align="left", color=BLUE,
                                edgecolor="white", linewidth=0.8, rwidth=0.85)
    ax.set_xlabel("Defects detected per layer")
    ax.set_ylabel("Number of layers")

    # x-ticks every 5, starting at 1
    tick_step = 5
    ax.set_xticks([x for x in bins[:-1] if (x == 1 or x % tick_step == 0)])

    # Annotate worst-case sample
    worst = max(counts)
    worst_idx = bins.index(worst)
    ax.annotate(
        f"Max: {worst}\n(sample 92_14_48)",
        xy=(worst, n[worst_idx]),
        xytext=(worst - 10, n[worst_idx] + 2),
        arrowprops=dict(arrowstyle="->", color="black", lw=0.8),
        fontsize=13,
    )
    # Annotate single-defect layers
    single_count = counts.count(1)
    single_pct = single_count / n_repair * 100
    ax.annotate(
        f"{single_count} layers\n({single_pct:.0f}%)",
        xy=(1, n[0]),
        xytext=(3, n[0] - 5),
        arrowprops=dict(arrowstyle="->", color="black", lw=0.8),
        fontsize=13,
    )
    ax.title.set_visible(False)

    # --- Right: pie chart ---
    wedges, texts, autotexts = ax_pie.pie(
        [total_over, total_under],
        labels=[f"Overextrusion\n({total_over})", f"Underextrusion\n({total_under})"],
        colors=[ORANGE, CYAN],
        autopct="%1.1f%%",
        startangle=90,
        wedgeprops={"edgecolor": "white", "linewidth": 1.5},
    )
    for t in autotexts:
        t.set_fontsize(13)
    ax_pie.set_title("")

    fig.tight_layout()
    fig.subplots_adjust(top=0.92)
    path = OUTPUT_DIR / "fig1_defect_count_distribution.png"
    fig.savefig(path)
    plt.close(fig)
    print(f"  Saved: {path.name}")
    return counts


# ---------------------------------------------------------------------------
# Figure 2 -- Area savings distribution
# ---------------------------------------------------------------------------
def fig2_area_savings_distribution(samples):
    rep = repair_samples(samples)
    savings = [s["area_savings_pct"] for s in rep]
    repair_areas = [s["repair_area_mm2"] for s in rep]
    full_layer_area = 1600.0
    n_repair = len(rep)

    mean_pct = float(np.mean(savings))
    median_pct = float(np.median(savings))
    mean_repair_area = float(np.mean(repair_areas))
    ratio = full_layer_area / mean_repair_area

    # Clip the one negative outlier (sample 92_14_48, -50.7%) to 0 for the
    # histogram so it doesn't stretch the x-axis and squash the real signal.
    # The outlier is called out in the figure caption separately.
    clipped = [max(0.0, s) for s in savings]

    fig, ax = plt.subplots(figsize=(8.5, 4.6))

    bins = np.arange(0, 101, 5)
    counts, edges, patches = ax.hist(clipped, bins=bins, color=GREEN,
                                     edgecolor="white", linewidth=1.0, alpha=0.85)

    # Mean reference line
    ax.axvline(mean_pct, color="#1a6b1a", linestyle="--", linewidth=1.8,
               label=f"Mean: {mean_pct:.1f}%")

    # Single headline text box -- the numbers the reader actually cares about.
    headline = (
        f"n = {n_repair} repair layers\n"
        f"Mean: {mean_pct:.1f}%  |  Median: {median_pct:.1f}%\n"
        f"Avg. area processed: {mean_repair_area:.0f} mm$^2$ per layer\n"
        f"(vs. 1,600 mm$^2$ full-layer rework -> {ratio:.0f}x reduction)"
    )
    ax.text(0.03, 0.97, headline, transform=ax.transAxes,
            fontsize=13, va="top", ha="left",
            bbox=dict(boxstyle="round,pad=0.5", facecolor="white",
                      edgecolor="#888888", linewidth=0.8))

    ax.set_xlabel("Area savings per layer (%)", fontsize=15)
    ax.set_ylabel("Number of layers", fontsize=15)
    ax.set_xlim(0, 100)
    ax.set_xticks(np.arange(0, 101, 10))
    ax.tick_params(labelsize=13)
    ax.legend(loc="upper left", bbox_to_anchor=(0.03, 0.65), fontsize=13,
              framealpha=0.95)

    fig.tight_layout()
    path = OUTPUT_DIR / "fig2_area_savings_distribution.png"
    fig.savefig(path)
    plt.close(fig)
    print(f"  Saved: {path.name}")
    return savings


# ---------------------------------------------------------------------------
# Figure 3 -- Defect type split (stacked bar per layer, sorted by total)
# ---------------------------------------------------------------------------
def fig3_defect_type_split(samples):
    # Defect type breakdown is now included as the right panel of fig1.
    pass


# ---------------------------------------------------------------------------
# Figure 4 -- Bounding box area distribution
# ---------------------------------------------------------------------------
def fig4_defect_size_distribution(samples):
    all_defects = []
    for s in repair_samples(samples):
        for d in s.get("defects", []):
            w = d["size_mm"]["width"]
            h = d["size_mm"]["height"]
            all_defects.append({
                "class": d["class"],
                "area_mm2": w * h,
            })

    over_areas  = [d["area_mm2"] for d in all_defects if d["class"] == "Overextrusion"]
    under_areas = [d["area_mm2"] for d in all_defects if d["class"] == "Underextrusion"]

    fig, ax = plt.subplots(figsize=(6, 3.5))
    bins = np.arange(0, max(over_areas + under_areas) + 3, 2)
    ax.hist(over_areas,  bins=bins, alpha=0.7, color=ORANGE, label="Overextrusion",  edgecolor="white")
    ax.hist(under_areas, bins=bins, alpha=0.7, color=CYAN,   label="Underextrusion", edgecolor="white")
    ax.axvline(np.mean(over_areas),  color=ORANGE, linestyle="--", linewidth=1.2,
               label=f"Over mean: {np.mean(over_areas):.1f} mm^2")
    ax.axvline(np.mean(under_areas), color=CYAN,   linestyle="--", linewidth=1.2,
               label=f"Under mean: {np.mean(under_areas):.1f} mm^2")
    ax.set_xlabel("Bounding box area (mm^2)")
    ax.set_ylabel("Count")
    ax.set_title("")
    ax.legend(fontsize=10)
    fig.tight_layout()
    path = OUTPUT_DIR / "fig4_defect_size_distribution.png"
    fig.savefig(path)
    plt.close(fig)
    print(f"  Saved: {path.name}")
    return all_defects


# ---------------------------------------------------------------------------
# Figure 5 -- Spatial distribution of defect centres on bed
# ---------------------------------------------------------------------------
def fig5_spatial_defect_map(samples):
    over_xy  = []
    under_xy = []

    for s in repair_samples(samples):
        for d in s.get("defects", []):
            bb = d["bed_bbox"]
            cx = (bb["x_min"] + bb["x_max"]) / 2.0
            cy = (bb["y_min"] + bb["y_max"]) / 2.0
            if d["class"] == "Overextrusion":
                over_xy.append((cx, cy))
            else:
                under_xy.append((cx, cy))

    fig, ax = plt.subplots(figsize=(4.2, 4.2))

    # Bed boundary (60 mm radius circle)
    theta = np.linspace(0, 2 * np.pi, 360)
    ax.plot(60 * np.cos(theta), 60 * np.sin(theta), "k-", linewidth=0.8,
            label="Bed boundary (r=60 mm)", alpha=0.4)

    # Part boundary (40x40 mm square)
    rect = plt.Rectangle((-20, -20), 40, 40, fill=False,
                          edgecolor="grey", linewidth=0.8, linestyle="--", label="Part boundary (40x40 mm)")
    ax.add_patch(rect)

    if over_xy:
        ox, oy = zip(*over_xy)
        ax.scatter(ox, oy, c=ORANGE, s=12, alpha=0.55, label=f"Overextrusion (n={len(over_xy)})", zorder=3)
    if under_xy:
        ux, uy = zip(*under_xy)
        ax.scatter(ux, uy, c=CYAN, s=12, alpha=0.55, label=f"Underextrusion (n={len(under_xy)})", zorder=3, marker="^")

    ax.set_xlim(-65, 65)
    ax.set_ylim(-65, 65)
    ax.set_aspect("equal")
    ax.set_xlabel("X (mm)", fontsize=11)
    ax.set_ylabel("Y (mm)", fontsize=11)
    ax.set_title("")
    ax.tick_params(labelsize=10)
    ax.legend(loc="upper right", fontsize=10, bbox_to_anchor=(1.0, 1.0))
    fig.tight_layout()
    path = OUTPUT_DIR / "fig5_spatial_defect_map.png"
    fig.savefig(path)
    plt.close(fig)
    print(f"  Saved: {path.name}")


# ---------------------------------------------------------------------------
# Figure 6 -- Confidence score distribution
# ---------------------------------------------------------------------------
def fig6_confidence_distribution(samples):
    over_conf  = []
    under_conf = []

    for s in repair_samples(samples):
        for d in s.get("defects", []):
            if d["class"] == "Overextrusion":
                over_conf.append(d["confidence"])
            else:
                under_conf.append(d["confidence"])

    # Clip to 0.97 -- only 1 bin above 0.96 so it just stretches the x-axis
    clip = 0.971
    over_conf  = [c for c in over_conf  if c <= clip]
    under_conf = [c for c in under_conf if c <= clip]

    bins = np.arange(0.85, clip + 0.001, 0.01)
    bin_centres = (bins[:-1] + bins[1:]) / 2
    width = 0.009

    over_counts,  _ = np.histogram(over_conf,  bins=bins)
    under_counts, _ = np.histogram(under_conf, bins=bins)

    fig, ax = plt.subplots(figsize=(7, 5.0))
    ax.bar(bin_centres, under_counts, width=width, color=CYAN,   label="Underextrusion", edgecolor="white")
    ax.bar(bin_centres, over_counts,  width=width, color=ORANGE, label="Overextrusion",
           bottom=under_counts, edgecolor="white")
    ax.axvline(0.85, color="red", linestyle="--", linewidth=1.5, label="Threshold (0.85)")
    ax.set_xlabel("Detection confidence score", fontsize=18)
    ax.set_ylabel("Count", fontsize=18)
    ax.tick_params(labelsize=16)
    ax.set_title("")
    ax.legend(loc="upper left", bbox_to_anchor=(0.08, 0.98), ncol=1,
              framealpha=0.95, fontsize=16)
    fig.tight_layout()
    path = OUTPUT_DIR / "fig6_confidence_distribution.png"
    fig.savefig(path)
    plt.close(fig)
    print(f"  Saved: {path.name}")


# ---------------------------------------------------------------------------
# Figure 7 -- G-code line count vs defect count
# ---------------------------------------------------------------------------
def fig7_gcode_scaling(samples):
    rep = repair_samples(samples)
    defect_counts = [s["defects_found"]   for s in rep]
    gcode_lines   = [s["gcode_lines"]     for s in rep]
    proc_times    = [s["total_time_s"]    for s in rep]

    fig, axes = plt.subplots(1, 2, figsize=(9, 3.5))

    # Left -- G-code lines vs defect count
    ax = axes[0]
    ax.scatter(defect_counts, gcode_lines, c=BLUE, s=20, alpha=0.6, edgecolors="none")
    # Fit line
    coeffs = np.polyfit(defect_counts, gcode_lines, 1)
    x_fit = np.linspace(min(defect_counts), max(defect_counts), 100)
    ax.plot(x_fit, np.polyval(coeffs, x_fit), "r--", linewidth=1.2,
            label=f"Linear fit: {coeffs[0]:.0f}xn + {coeffs[1]:.0f}")
    ax.set_xlabel("Number of defects")
    ax.set_ylabel("Repair G-code lines")
    ax.set_title("")
    ax.legend(fontsize=10)

    # Right -- total processing time vs defect count
    ax2 = axes[1]
    ax2.scatter(defect_counts, proc_times, c=GREEN, s=20, alpha=0.6, edgecolors="none")
    coeffs2 = np.polyfit(defect_counts, proc_times, 1)
    x_fit2 = np.linspace(min(defect_counts), max(defect_counts), 100)
    ax2.plot(x_fit2, np.polyval(coeffs2, x_fit2), "r--", linewidth=1.2,
             label=f"Linear fit: {coeffs2[0]:.2f}xn + {coeffs2[1]:.2f} s")
    ax2.set_xlabel("Number of defects")
    ax2.set_ylabel("Total pipeline time (s)")
    ax2.set_title("")
    ax2.legend(fontsize=10)

    fig.tight_layout()
    path = OUTPUT_DIR / "fig7_gcode_scaling.png"
    fig.savefig(path)
    plt.close(fig)
    print(f"  Saved: {path.name}")


# ---------------------------------------------------------------------------
# Figure 8 -- Area savings: per-defect vs full-layer (paired bar comparison)
# ---------------------------------------------------------------------------
def fig8_area_comparison(samples, savings):
    # Merged into fig2_area_savings_distribution (3-panel combined figure).
    pass


# ---------------------------------------------------------------------------
# Print summary statistics to stdout
# ---------------------------------------------------------------------------
def print_summary(report, samples):
    rep = repair_samples(samples)
    all_defects = [d for s in rep for d in s.get("defects", [])]
    areas = [d["size_mm"]["width"] * d["size_mm"]["height"] for d in all_defects]
    savings = [s["area_savings_pct"] for s in rep]
    proc_times = [s["total_time_s"] for s in rep]

    print("\n-- Batch Summary ----------------------------------------")
    print(f"  Total samples:         {report['total_samples']}")
    print(f"  Clean layers:          {report['clean_layers']}")
    print(f"  Repair layers:         {report['repair_layers']}")
    print(f"  Total defects:         {report['total_defects']}  "
          f"(over={report['total_overextrusions']}, under={report['total_underextrusions']})")
    print(f"  Area savings (avg):    {report['avg_area_savings_pct']:.1f}%")
    print(f"  Area savings (median): {np.median(savings):.1f}%")
    print(f"  Area savings (min):    {min(savings):.1f}%")
    print(f"  Defect bbox area (avg):{np.mean(areas):.2f} mm^2")
    print(f"  Defect bbox area (max):{max(areas):.2f} mm^2")
    print(f"  Processing time (avg): {np.mean(proc_times):.1f} s/sample")
    print(f"  Processing time (max): {max(proc_times):.1f} s/sample")
    print(f"  Batch time total:      {report['batch_time_s'] / 60:.1f} min")
    print("---------------------------------------------------------\n")


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
def main():
    print(f"Loading: {BATCH_REPORT}")
    if not BATCH_REPORT.exists():
        print(f"ERROR: batch_report.json not found at {BATCH_REPORT}", file=sys.stderr)
        sys.exit(1)

    report  = load_report(BATCH_REPORT)
    samples = extract_samples(report)

    print_summary(report, samples)
    print(f"Generating figures -> {OUTPUT_DIR}\n")

    counts  = fig1_defect_count_distribution(samples)
    savings = fig2_area_savings_distribution(samples)
    fig3_defect_type_split(samples)
    fig4_defect_size_distribution(samples)
    fig5_spatial_defect_map(samples)
    fig6_confidence_distribution(samples)
    fig7_gcode_scaling(samples)
    fig8_area_comparison(samples, savings)

    print(f"\nAll figures saved to: {OUTPUT_DIR}")
    sync_to_report_figures()


def sync_to_report_figures():
    """Mirror every PNG in OUTPUT_DIR into the report's figures folder."""
    import shutil

    if not REPORT_FIGURES_DIR.exists():
        print(f"\nReport figures folder not found at {REPORT_FIGURES_DIR} -- skipping sync.")
        return

    copied = 0
    for png in sorted(OUTPUT_DIR.glob("*.png")):
        shutil.copy2(png, REPORT_FIGURES_DIR / png.name)
        copied += 1
    print(f"Synced {copied} figures -> {REPORT_FIGURES_DIR}")


if __name__ == "__main__":
    main()
