"""
fig19_savings_vs_defects.py
---------------------------
Scatter of per-layer area savings (%) vs defect count, to review as an
alternative visualisation for Chapter 4.3. Not wired into main.tex.

Usage:
    cd src
    python fig19_savings_vs_defects.py
"""

import json
import shutil
import sys
from pathlib import Path

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np

SRC_DIR = Path(__file__).parent
PROJECT_DIR = SRC_DIR.parent
_v3 = PROJECT_DIR / "output" / "v3_cached_monitor" / "batch_report.json"
_v2 = PROJECT_DIR / "output" / "v2_adaptive_monitor" / "batch_report.json"
BATCH_REPORT = _v3 if _v3.exists() else _v2
OUTPUT_DIR = PROJECT_DIR / "output" / "results_analysis"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
REPORT_FIGURES_DIR = PROJECT_DIR.parent / "Individual Report" / "figures"

plt.rcParams.update({
    "font.family": "serif",
    "font.size": 15,
    "axes.labelsize": 15,
    "xtick.labelsize": 13,
    "ytick.labelsize": 13,
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

GREEN = "#2CA02C"
ORANGE = "#E87722"
RED = "#C0392B"
BLUE = "#1F77B4"
GREY = "#888888"


def main():
    if not BATCH_REPORT.exists():
        print(f"ERROR: {BATCH_REPORT} not found", file=sys.stderr)
        sys.exit(1)

    with open(BATCH_REPORT) as f:
        report = json.load(f)
    rep = [s for s in report["samples"] if s["repair_needed"]]

    defect_counts = np.array([s["defects_found"] for s in rep])
    savings = np.array([s["area_savings_pct"] for s in rep])

    fig, ax = plt.subplots(figsize=(8.5, 5.0))

    # Colour by regime so the "degradation with defect load" story is visible
    colors = np.where(savings >= 95, GREEN,
             np.where(savings >= 50, ORANGE, RED))
    ax.scatter(defect_counts, savings, c=colors, s=55, alpha=0.75,
               edgecolors="white", linewidths=0.7, zorder=3)

    # 95% reference band -- the "excellent" regime
    ax.axhspan(95, 100, color=GREEN, alpha=0.08, zorder=0)
    ax.axhline(95, color=GREEN, linestyle=":", linewidth=1.0, zorder=1)

    # Mean reference
    mean_pct = float(savings.mean())
    ax.axhline(mean_pct, color="#1a6b1a", linestyle="--", linewidth=1.5,
               label=f"Mean: {mean_pct:.1f}%", zorder=2)

    # Annotate the outlier
    worst_idx = int(np.argmin(savings))
    ax.annotate(
        f"Sample 92_14_48\n({int(defect_counts[worst_idx])} defects, {savings[worst_idx]:.1f}%)",
        xy=(defect_counts[worst_idx], savings[worst_idx]),
        xytext=(defect_counts[worst_idx] - 9, savings[worst_idx] + 25),
        fontsize=12,
        arrowprops=dict(arrowstyle="->", color="#555555", lw=0.8),
    )

    # Annotate the "most layers cluster here" regime
    n_low_defect_high_saving = int(((defect_counts <= 5) & (savings >= 95)).sum())
    ax.text(0.98, 0.08,
            f"{n_low_defect_high_saving} of {len(rep)} layers:\n"
            f"<=5 defects and >=95% saved",
            transform=ax.transAxes, fontsize=12,
            ha="right", va="bottom",
            bbox=dict(boxstyle="round,pad=0.4", facecolor="white",
                      edgecolor=GREY, linewidth=0.8))

    ax.set_xlabel("Defects per layer")
    ax.set_ylabel("Area savings per layer (%)")
    ax.set_xlim(0, max(defect_counts) + 2)
    ax.set_ylim(-60, 108)
    ax.set_yticks([-50, -25, 0, 25, 50, 75, 95, 100])
    ax.legend(loc="lower left", framealpha=0.95)

    fig.tight_layout()
    out = OUTPUT_DIR / "fig19_savings_vs_defects.png"
    fig.savefig(out)
    plt.close(fig)
    print(f"Saved: {out}")

    if REPORT_FIGURES_DIR.exists():
        shutil.copy2(out, REPORT_FIGURES_DIR / out.name)
        print(f"Synced: {REPORT_FIGURES_DIR / out.name}")


if __name__ == "__main__":
    main()
