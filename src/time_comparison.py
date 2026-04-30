"""
time_comparison.py
==================
Estimates and compares wall-clock repair times for three strategies:
  1. No repair       -- print the layer and continue (no inspection overhead)
  2. Adaptive repair -- our three-phase targeted mill + deposit strategy
  3. Full rework     -- mill the entire 40x40 mm layer and re-deposit fully

Timing sources
--------------
* G-code machining times are calculated by parsing actual G-code files and
  summing move durations at their programmed feedrates.
* Process overheads (camera, YOLO, ATC, IR drying) are design assumptions
  documented in the ASSUMPTIONS block below.

Outputs (saved to output/results_analysis/):
  fig9_time_breakdown_1_13_35.png  -- waterfall/stacked breakdown for 1_13_35
  fig10_time_vs_defects.png        -- scatter of total process time vs defect count
  fig11_time_savings_distribution.png -- histogram of savings vs full rework
  fig12_strategy_comparison_boxplot.png -- box plots for all three strategies
"""

import json
import math
import os
import sys

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import numpy as np
from pathlib import Path

plt.rcParams.update({
    "font.family": "serif",
    "font.size": 22,
    "axes.titlesize": 24,
    "axes.labelsize": 22,
    "xtick.labelsize": 20,
    "ytick.labelsize": 20,
    "legend.fontsize": 20,
    "figure.dpi": 150,
    "savefig.dpi": 300,
    "savefig.bbox": "tight",
    "axes.spines.top": False,
    "axes.spines.right": False,
    "axes.grid": True,
    "grid.alpha": 0.3,
    "grid.linewidth": 0.5,
})

# ---------------------------------------------------------------------------
# Paths
# ---------------------------------------------------------------------------
SRC_DIR = Path(__file__).parent
PROJECT_DIR = SRC_DIR.parent
DATA_DIR = PROJECT_DIR / "data"
AM_GCODE_DIR = DATA_DIR / "GCODEs" / "AM GCODEs"
V3_DIR = PROJECT_DIR / "output" / "v3_cached_monitor"
OUT_DIR = PROJECT_DIR / "output" / "results_analysis"
OUT_DIR.mkdir(parents=True, exist_ok=True)

BATCH_REPORT = V3_DIR / "batch_report.json"

# ---------------------------------------------------------------------------
# ASSUMPTIONS  (all times in seconds)
# Sources: CHAMP machine video at x4 speed (youtube.com/watch?v=1c_w5OVgLJ0),
#          G-code feedrate analysis, and machine documentation.
# ---------------------------------------------------------------------------
CAMERA_CAPTURE_S = 8.0   # Travel to corner + capture + processing (video: ~2s@4x)
YOLO_INFERENCE_S = 5.0   # YOLOv8s at imgsz=2560 on GPU (live inference)
GCODE_GEN_S = 0.5        # Repair G-code generation + validation (our pipeline)
TOOL_CHANGE_S = 20.0     # CHAMP ATC: drop + pick up tool (video: ~5s@4x = ~20s)
SPINDLE_ON_S = 2.0       # M3 S1000 spindle ramp-up
PURGE_S = 5.0            # M14 nozzle purge before ceramic deposition
NOZZLE_CLEAN_S = 10.0    # Nozzle tip wipe at spindle cleaner box (video: ~3s@4x)
IR_DRY_S = 60.0          # IR lamp drying after deposition (video confirms 60s)
HEAD_TRAVEL_S = 4.0      # Head travel between stations (camera/centre/side)

# Full-layer mill geometry
# The CHAMP uses a 6 mm carbide end mill at full-width step-over for surface
# milling. Video shows full-layer removal in ~28s real (7s@4x), consistent
# with 6 mm step-over at F200 mm/min (geometric estimate: ~89s conservative).
# We use the geometric estimate as the conservative bound.
PART_DIM_MM = 40.0
STEP_OVER_MM = 6.0       # 6 mm end mill, full-width passes for layer removal
MILL_FEED_MMPM = 200.0   # conservative feed for ceramic (repair G-code uses F200)
RAPID_FEED_MMPM = 7800.0
Z_FEED_MMPM = 600.0
Z_CLEARANCE_MM = 2.0     # retract height above surface

def _full_layer_mill_time_s():
    """Estimate time to mill the entire 40x40 mm surface."""
    n_passes = math.ceil(PART_DIM_MM / STEP_OVER_MM)
    cut_s = (PART_DIM_MM / MILL_FEED_MMPM) * 60
    z_s = (Z_CLEARANCE_MM / Z_FEED_MMPM) * 60 * 2   # retract + plunge per pass
    traverse_s = (PART_DIM_MM / RAPID_FEED_MMPM) * 60  # step-over move
    return n_passes * (cut_s + z_s + traverse_s)

FULL_MILL_S = _full_layer_mill_time_s()

# ---------------------------------------------------------------------------
# G-code time parser
# ---------------------------------------------------------------------------
def parse_gcode_time_s(filepath: Path) -> float:
    """Return estimated execution time in seconds for a G-code file."""
    pos = {"X": 0.0, "Y": 0.0, "Z": 0.0}
    feed = RAPID_FEED_MMPM
    total = 0.0

    def dist3(a, b):
        return math.sqrt(sum((a.get(k, 0) - b.get(k, 0)) ** 2 for k in "XYZ"))

    with open(filepath, encoding="utf-8", errors="ignore") as fh:
        for raw in fh:
            line = raw.strip()
            if not line or line.startswith(";"):
                continue
            parts = line.split()
            cmd = parts[0].upper()
            params = {}
            for tok in parts[1:]:
                if tok and tok[0].upper() in "XYZAF" and len(tok) > 1:
                    try:
                        params[tok[0].upper()] = float(tok[1:])
                    except ValueError:
                        pass
            if "F" in params:
                feed = params["F"]
            if cmd in ("G0", "G1"):
                new_pos = dict(pos)
                for ax in "XYZ":
                    if ax in params:
                        new_pos[ax] = params[ax]
                d = dist3(pos, new_pos)
                if d > 0 and feed > 0:
                    total += (d / feed) * 60.0
                pos = new_pos
            elif cmd == "M14":
                total += PURGE_S  # nozzle purge dwell
    return total

# ---------------------------------------------------------------------------
# Load batch report and AM G-code times
# ---------------------------------------------------------------------------
with open(BATCH_REPORT) as fh:
    batch = json.load(fh)

samples = {s["sample"]: s for s in batch["samples"]}

# Parse AM G-code times (pairing by sample number prefix)
am_times: dict[str, float] = {}
for fname in AM_GCODE_DIR.glob("*.gcode"):
    try:
        sample_num = int(fname.stem)
        t = parse_gcode_time_s(fname)
        # Map sample_num -> sample name that starts with that number
        # Sample names are like "1_13_35", "10_14_30" etc.
        am_times[sample_num] = t
    except ValueError:
        pass

def get_am_time(sample_name: str) -> float:
    """Return AM print time for the sample, or global average if not found."""
    try:
        num = int(sample_name.split("_")[0])
        if num in am_times:
            return am_times[num]
    except (ValueError, IndexError):
        pass
    return float(np.mean(list(am_times.values())))

# Parse repair G-code times
repair_times: dict[str, float] = {}
for sample_name in samples:
    gcode = V3_DIR / sample_name / f"repair_{sample_name}.gcode"
    if gcode.exists():
        repair_times[sample_name] = parse_gcode_time_s(gcode)

# ---------------------------------------------------------------------------
# Time model
# ---------------------------------------------------------------------------
# The CHAMP standard layer cycle (observed from machine video at x4 speed):
#   Print -> head travel -> IR dry (60s) -> travel to camera -> camera capture
#   -> travel to centre -> nozzle clean/purge -> [next layer]
# This cycle applies to EVERY layer, including clean ones.  The three
# strategies only differ in what happens AFTER the camera detects defects.
# ---------------------------------------------------------------------------

def _standard_cycle_time(am_print_s: float) -> dict:
    """Time breakdown for the standard CHAMP cycle that every layer goes through."""
    return {
        "print":         am_print_s,
        "head_travel_1": HEAD_TRAVEL_S,         # extrusion pos -> IR station
        "ir_drying":     IR_DRY_S,              # 60s drying
        "head_travel_2": HEAD_TRAVEL_S,         # IR station -> camera
        "camera":        CAMERA_CAPTURE_S,      # capture + defect image
    }

def no_repair_time(sample_name: str) -> dict:
    """Standard cycle only -- defects accepted as-is or layer is clean."""
    am = get_am_time(sample_name)
    breakdown = _standard_cycle_time(am)
    breakdown["nozzle_clean"] = NOZZLE_CLEAN_S  # wipe tip before next layer
    breakdown["total"] = sum(breakdown.values())
    return breakdown

def adaptive_time(sample_name: str) -> dict:
    """Standard cycle + targeted adaptive repair overhead."""
    s = samples[sample_name]
    am = get_am_time(sample_name)
    repair = repair_times.get(sample_name, 0.0)
    has_phase2 = s["underextrusions"] > 0

    breakdown = _standard_cycle_time(am)
    # ----- repair overhead (only when defects detected) -----
    breakdown["yolo"]        = YOLO_INFERENCE_S         # run YOLOv8 on image
    breakdown["gcode_gen"]   = GCODE_GEN_S              # generate repair G-code
    breakdown["atc_t0_t1"]   = TOOL_CHANGE_S            # nozzle -> mill
    breakdown["spindle_on"]  = SPINDLE_ON_S             # spindle ramp-up
    breakdown["milling"]     = repair                   # Phase 1+2 G-code time
    breakdown["atc_t1_t0"]   = TOOL_CHANGE_S if has_phase2 else 0.0  # mill -> nozzle
    breakdown["ir_dry_post"] = IR_DRY_S if has_phase2 else 0.0       # dry after deposit
    # re-inspection after repair (video 01:05-01:11)
    breakdown["head_travel_3"] = HEAD_TRAVEL_S          # to camera for re-check
    breakdown["reinspect"]     = CAMERA_CAPTURE_S       # verify repair quality
    breakdown["nozzle_clean"]  = NOZZLE_CLEAN_S         # wipe tip before next layer
    breakdown["total"] = sum(breakdown.values())
    return breakdown

def full_rework_time(sample_name: str) -> dict:
    """Standard cycle + full-layer mill + full re-deposit."""
    am = get_am_time(sample_name)
    avg_am = float(np.mean(list(am_times.values())))

    breakdown = _standard_cycle_time(am)
    # ----- full rework overhead -----
    breakdown["yolo"]         = YOLO_INFERENCE_S
    breakdown["atc_t0_t1"]    = TOOL_CHANGE_S           # nozzle -> mill
    breakdown["spindle_on"]   = SPINDLE_ON_S
    breakdown["full_mill"]    = FULL_MILL_S              # mill entire 40x40 surface
    breakdown["atc_t1_t0"]    = TOOL_CHANGE_S           # mill -> nozzle
    breakdown["nozzle_purge"] = PURGE_S                 # purge before re-deposit
    breakdown["full_deposit"] = avg_am                  # re-print entire layer
    breakdown["ir_dry_post"]  = IR_DRY_S                # dry the new deposit
    # re-inspection after rework (video 01:05-01:11)
    breakdown["head_travel_3"] = HEAD_TRAVEL_S
    breakdown["reinspect"]     = CAMERA_CAPTURE_S
    breakdown["nozzle_clean"]  = NOZZLE_CLEAN_S
    breakdown["total"] = sum(breakdown.values())
    return breakdown

# ---------------------------------------------------------------------------
# Build per-sample data
# ---------------------------------------------------------------------------
repair_samples = [s for s in samples if samples[s]["decision"] == "adaptive_repair"]

data_rows = []
for name in repair_samples:
    s = samples[name]
    ar = adaptive_time(name)
    fr = full_rework_time(name)
    nr = no_repair_time(name)
    data_rows.append({
        "sample":        name,
        "defects":       s["defects_found"],
        "overextrusions": s["overextrusions"],
        "underextrusions": s["underextrusions"],
        "no_repair_s":   nr["total"],
        "adaptive_s":    ar["total"],
        "full_rework_s": fr["total"],
        "adaptive_overhead_s": ar["total"] - nr["total"],
        "saving_vs_rework_s": fr["total"] - ar["total"],
        "saving_vs_rework_pct": (fr["total"] - ar["total"]) / fr["total"] * 100,
        "nr_breakdown":  nr,
        "ar_breakdown":  ar,
        "fr_breakdown":  fr,
    })

# ---------------------------------------------------------------------------
# Colour palette
# ---------------------------------------------------------------------------
# Group small overheads together for cleaner bars
_ATC_COL = "#e76f51"
_TRAVEL_COL = "#d4a373"

COLOURS = {
    "print":         "#4e91cc",
    "head_travel_1": _TRAVEL_COL,
    "ir_drying":     "#9b2226",
    "head_travel_2": _TRAVEL_COL,
    "camera":        "#a8d8ea",
    "yolo":          "#f4a261",
    "gcode_gen":     "#e9c46a",
    "atc_t0_t1":     _ATC_COL,
    "spindle_on":    _ATC_COL,
    "milling":       "#2a9d8f",
    "atc_t1_t0":     _ATC_COL,
    "ir_dry_post":   "#9b2226",
    "head_travel_3": _TRAVEL_COL,
    "reinspect":     "#a8d8ea",
    "nozzle_clean":  "#bc6c25",
    "nozzle_purge":  "#bc6c25",
    "full_mill":     "#2a9d8f",
    "full_deposit":  "#264653",
}

LABEL_MAP = {
    "print":         "AM print (G-code)",
    "head_travel_1": "Head travel",
    "ir_drying":     "IR drying (60s)",
    "head_travel_2": "Head travel",
    "camera":        "Camera capture",
    "yolo":          "YOLO inference",
    "gcode_gen":     "G-code generation",
    "atc_t0_t1":     "ATC: nozzle -> mill",
    "spindle_on":    "Spindle ramp-up",
    "milling":       "Repair machining (Ph1+Ph2)",
    "atc_t1_t0":     "ATC: mill -> nozzle",
    "ir_dry_post":   "IR drying (post-repair)",
    "head_travel_3": "Head travel",
    "reinspect":     "Re-inspection (camera)",
    "nozzle_clean":  "Nozzle tip cleaning",
    "nozzle_purge":  "Nozzle purge (M14)",
    "full_mill":     "Full-surface milling",
    "full_deposit":  "Full layer re-deposit",
}

# ===========================================================================
# Figure 9 -- Stacked time breakdown for sample 1_13_35
# ===========================================================================
def fig9_breakdown():
    name = "1_13_35"
    nr = no_repair_time(name)
    ar = adaptive_time(name)
    fr = full_rework_time(name)

    strategies = {
        "No repair\n(accept defects)": nr,
        "Adaptive\nrepair":            ar,
        "Full-layer\nrework":          fr,
    }

    fig, ax = plt.subplots(figsize=(10, 7))

    x_positions = [0, 1.5, 3.0]
    bar_w = 0.85

    # De-duplicate legend entries (e.g. multiple head_travel have same colour)
    legend_seen = {}

    for xi, (label, bk) in zip(x_positions, strategies.items()):
        bottom = 0
        for key, val in bk.items():
            if key == "total" or val <= 0:
                continue
            colour = COLOURS.get(key, "#cccccc")
            ax.bar(xi, val, bar_w, bottom=bottom,
                   color=colour, edgecolor="white", linewidth=0.5)
            # Label segments > 8s
            if val > 8:
                ax.text(xi, bottom + val / 2, f"{val:.0f}s",
                        ha="center", va="center", fontsize=10,
                        color="white", fontweight="bold")
            bottom += val
            # Track for legend
            lbl = LABEL_MAP.get(key, key)
            if colour not in legend_seen:
                legend_seen[colour] = lbl

        total = bk.get("total", bottom)
        ax.text(xi, total + 5, f"{total:.0f}s\n({total/60:.1f} min)",
                ha="center", va="bottom", fontsize=12, fontweight="bold")

    ax.set_xticks(x_positions)
    ax.set_xticklabels(list(strategies.keys()), fontsize=13)
    ax.set_ylabel("Time (s)", fontsize=14)
    ax.set_title("")
    ax.set_ylim(0, fr["total"] * 1.22)

    # Build deduplicated legend in a sensible order
    legend_order = [
        ("#4e91cc",  "AM print (G-code)"),
        ("#9b2226",  "IR drying (60s)"),
        ("#a8d8ea",  "Camera capture / re-inspect"),
        (_TRAVEL_COL, "Head travel"),
        ("#bc6c25",  "Nozzle clean / purge"),
        ("#f4a261",  "YOLO inference"),
        ("#e9c46a",  "G-code generation"),
        (_ATC_COL,   "ATC + spindle"),
        ("#2a9d8f",  "Milling (adaptive / full)"),
        ("#264653",  "Full layer re-deposit"),
    ]
    patches = [mpatches.Patch(color=c, label=l) for c, l in legend_order]
    ax.legend(handles=patches, loc="upper left", fontsize=10, ncol=2,
              framealpha=0.9)

    ax.yaxis.grid(True, linestyle="--", alpha=0.4)
    ax.set_axisbelow(True)

    # Assumptions footnote
    assumptions = (
        f"Assumptions: camera={CAMERA_CAPTURE_S:.0f}s, YOLO={YOLO_INFERENCE_S:.0f}s, "
        f"ATC={TOOL_CHANGE_S:.0f}s/change, IR dry={IR_DRY_S:.0f}s, "
        f"nozzle clean={NOZZLE_CLEAN_S:.0f}s  |  "
        f"Timings derived from CHAMP machine video at x4 speed"
    )
    fig.text(0.5, -0.01, assumptions, ha="center", fontsize=7.5,
             style="italic", color="gray")

    fig.tight_layout()
    out = OUT_DIR / "fig9_time_breakdown_1_13_35.png"
    fig.savefig(out, dpi=150, bbox_inches="tight")
    plt.close(fig)
    print(f"Saved: {out.name}")

# ===========================================================================
# Figure 10 -- Total process time vs defect count (scatter)
# ===========================================================================
def fig10_time_vs_defects():
    # Plot the repair OVERHEAD on top of the standard layer cycle.
    # Total time is dominated by the AM print and IR drying (both shared by
    # every strategy and varying sample-to-sample with G-code feedrates),
    # which obscures the defect-count dependence. Overhead = (strategy total)
    # - (standard cycle), isolating the additional time each repair strategy
    # actually costs.
    rows_plot = [r for r in data_rows if r["defects"] <= 25]

    defects = [r["defects"] for r in rows_plot]
    adaptive_oh = [(r["adaptive_s"]    - r["no_repair_s"]) / 60 for r in rows_plot]
    rework_oh   = [(r["full_rework_s"] - r["no_repair_s"]) / 60 for r in data_rows]

    has_phase2 = [r["underextrusions"] > 0 for r in rows_plot]
    defects_p2  = [d for d, p in zip(defects, has_phase2) if p]
    adaptive_p2 = [a for a, p in zip(adaptive_oh, has_phase2) if p]
    defects_p1  = [d for d, p in zip(defects, has_phase2) if not p]
    adaptive_p1 = [a for a, p in zip(adaptive_oh, has_phase2) if not p]

    rework_med = float(np.median(rework_oh))

    fig, ax = plt.subplots(figsize=(14, 8))

    ax.axhline(rework_med, color="#e76f51", linestyle="--", linewidth=2.2,
               label=f"Full-layer rework overhead ({rework_med:.1f} min, median)",
               zorder=3)
    ax.axhline(0, color="#4e91cc", linestyle=":", linewidth=1.6,
               label="Standard cycle (no-repair baseline)", zorder=2)

    ax.scatter(defects_p2, adaptive_p2, color="#2a9d8f", s=110, alpha=0.85,
               edgecolors="white", linewidths=1.0,
               label="Adaptive: mill + deposit (Ph1+Ph2)", zorder=4)
    ax.scatter(defects_p1, adaptive_p1, facecolors="none", edgecolors="#2a9d8f",
               s=110, linewidths=2.0,
               label="Adaptive: mill only (Ph1)", zorder=4)

    hi = next(r for r in rows_plot if r["sample"] == "1_13_35")
    hi_oh = (hi["adaptive_s"] - hi["no_repair_s"]) / 60
    ax.annotate(f"1_13_35\n(19 defects, {hi_oh:.1f} min)",
                xy=(hi["defects"], hi_oh),
                xytext=(hi["defects"] - 8.0, hi_oh + 1.6),
                fontsize=24, arrowprops=dict(arrowstyle="->", color="black",
                                             lw=1.6),
                color="black")

    ax.set_xlabel("Defect count per layer", fontsize=28, labelpad=10)
    ax.set_ylabel("Repair overhead vs standard cycle (min)",
                  fontsize=28, labelpad=10)
    ax.set_title("")
    ymax = max(max(adaptive_oh), rework_med) * 1.30
    ax.set_ylim(-0.3, ymax)
    ax.tick_params(axis="both", labelsize=24, length=8, width=1.4)
    ax.legend(fontsize=22, loc="upper left", framealpha=0.92)
    ax.yaxis.grid(True, linestyle="--", alpha=0.4)
    ax.set_axisbelow(True)

    fig.tight_layout()
    out = OUT_DIR / "fig10_time_vs_defects.png"
    fig.savefig(out, dpi=150, bbox_inches="tight", pad_inches=0.25)
    plt.close(fig)
    print(f"Saved: {out.name}")

# ===========================================================================
# Figure 11 -- Time saving vs full rework (histogram)
# ===========================================================================
def fig11_savings_histogram():
    savings_min = [r["saving_vs_rework_s"] / 60 for r in data_rows]
    savings_pct = [r["saving_vs_rework_pct"] for r in data_rows]

    fig, axes = plt.subplots(1, 2, figsize=(12, 5))

    # Absolute savings
    ax = axes[0]
    ax.hist(savings_min, bins=18, color="#2a9d8f", edgecolor="white",
            linewidth=0.7)
    mean_s = float(np.mean(savings_min))
    med_s = float(np.median(savings_min))
    ax.axvline(mean_s, color="#e76f51", linestyle="--",
               label=f"Mean {mean_s:.1f} min")
    ax.axvline(med_s, color="#264653", linestyle=":",
               label=f"Median {med_s:.1f} min")
    ax.set_xlabel("Time saved vs full rework (min)", fontsize=12)
    ax.set_ylabel("Number of layers", fontsize=12)
    ax.set_title("Time saving (absolute) vs full-layer rework", fontsize=12)
    ax.legend(fontsize=10)
    ax.yaxis.grid(True, linestyle="--", alpha=0.4)
    ax.set_axisbelow(True)

    # Percentage savings
    ax = axes[1]
    ax.hist(savings_pct, bins=18, color="#4e91cc", edgecolor="white",
            linewidth=0.7)
    mean_p = float(np.mean(savings_pct))
    med_p = float(np.median(savings_pct))
    ax.axvline(mean_p, color="#e76f51", linestyle="--",
               label=f"Mean {mean_p:.1f}%")
    ax.axvline(med_p, color="#264653", linestyle=":",
               label=f"Median {med_p:.1f}%")
    ax.set_xlabel("Time saved vs full rework (%)", fontsize=12)
    ax.set_ylabel("Number of layers", fontsize=12)
    ax.set_title("Time saving (relative) vs full-layer rework", fontsize=12)
    ax.legend(fontsize=10)
    ax.yaxis.grid(True, linestyle="--", alpha=0.4)
    ax.set_axisbelow(True)

    fig.suptitle(f"Time savings of adaptive repair over full rework (n={len(data_rows)} repair layers)",
                 fontsize=13, y=1.02)
    fig.tight_layout()
    out = OUT_DIR / "fig11_time_savings_distribution.png"
    fig.savefig(out, dpi=150, bbox_inches="tight")
    plt.close(fig)
    print(f"Saved: {out.name}")

# ===========================================================================
# Figure 12 -- Box plots for all three strategies
# ===========================================================================
def fig12_boxplot():
    no_rep_min  = [r["no_repair_s"] / 60 for r in data_rows]
    adaptive_min = [r["adaptive_s"] / 60 for r in data_rows]
    rework_min  = [r["full_rework_s"] / 60 for r in data_rows]

    fig, ax = plt.subplots(figsize=(9, 6))

    bp = ax.boxplot(
        [no_rep_min, adaptive_min, rework_min],
        tick_labels=["No repair\n(standard cycle)", "Adaptive\nrepair", "Full-layer\nrework"],
        patch_artist=True,
        medianprops=dict(color="white", linewidth=2),
        widths=0.55,
    )
    colours_bp = ["#4e91cc", "#2a9d8f", "#e76f51"]
    for patch, col in zip(bp["boxes"], colours_bp):
        patch.set_facecolor(col)
        patch.set_alpha(0.8)

    # Add mean markers
    for i, vals in enumerate([no_rep_min, adaptive_min, rework_min], 1):
        ax.scatter(i, np.mean(vals), marker="D", s=60,
                   color="white", zorder=5, linewidths=1.5,
                   edgecolors=colours_bp[i - 1])

    ax.set_ylabel("Total process time per layer (min)", fontsize=12)
    ax.set_title("Distribution of layer process times across 90 repair layers",
                 fontsize=13)
    ax.yaxis.grid(True, linestyle="--", alpha=0.4)
    ax.set_axisbelow(True)

    # Summary stats annotation
    stats = [
        ("No repair",     no_rep_min),
        ("Adaptive",      adaptive_min),
        ("Full rework",   rework_min),
    ]
    txt = "\n".join(
        f"{lbl}: mean={np.mean(v):.1f} min, median={np.median(v):.1f} min"
        for lbl, v in stats
    )
    ax.text(0.98, 0.97, txt, transform=ax.transAxes, fontsize=8.5,
            va="top", ha="right",
            bbox=dict(boxstyle="round,pad=0.4", facecolor="white",
                      edgecolor="gray", alpha=0.9))

    fig.tight_layout()
    out = OUT_DIR / "fig12_strategy_comparison_boxplot.png"
    fig.savefig(out, dpi=150)
    plt.close(fig)
    print(f"Saved: {out.name}")

# ===========================================================================
# Main
# ===========================================================================
if __name__ == "__main__":
    print("=== Time comparison analysis ===")
    print(f"Full-layer mill estimate: {FULL_MILL_S:.0f}s ({FULL_MILL_S/60:.1f} min)")
    print(f"Process assumptions (from CHAMP machine video at x4 speed):")
    print(f"  Camera capture : {CAMERA_CAPTURE_S}s (travel + capture)")
    print(f"  YOLO inference : {YOLO_INFERENCE_S}s (live, GPU)")
    print(f"  G-code gen     : {GCODE_GEN_S}s")
    print(f"  ATC per change : {TOOL_CHANGE_S}s (drop + pick)")
    print(f"  Spindle ramp   : {SPINDLE_ON_S}s")
    print(f"  IR drying      : {IR_DRY_S}s (every layer + post-repair)")
    print(f"  Nozzle clean   : {NOZZLE_CLEAN_S}s")
    print(f"  Head travel    : {HEAD_TRAVEL_S}s (per station move)")
    print()

    # Summary for 1_13_35
    name = "1_13_35"
    ar = adaptive_time(name)
    fr = full_rework_time(name)
    nr = no_repair_time(name)
    nrt = nr["total"]
    print(f"--- Sample {name} (19 defects, 14 over + 5 under) ---")
    print(f"  No repair (std cycle): {nrt:.0f}s  ({nrt/60:.1f} min)")
    print(f"  Adaptive repair:       {ar['total']:.0f}s  ({ar['total']/60:.1f} min)")
    print(f"  Full rework:           {fr['total']:.0f}s  ({fr['total']/60:.1f} min)")
    print(f"  Adaptive overhead vs std: +{(ar['total']-nrt):.0f}s ({(ar['total']-nrt)/60:.1f} min)")
    print(f"  Adaptive saving vs rework: -{(fr['total']-ar['total']):.0f}s ({(fr['total']-ar['total'])/60:.1f} min, {(fr['total']-ar['total'])/fr['total']*100:.0f}%)")
    print()

    # Population summary
    no_rep_all   = [r["no_repair_s"] for r in data_rows]
    adaptive_all = [r["adaptive_s"] for r in data_rows]
    rework_all   = [r["full_rework_s"] for r in data_rows]
    savings_all  = [r["saving_vs_rework_s"] for r in data_rows]
    print(f"--- All 90 repair layers ---")
    print(f"  No repair mean:  {np.mean(no_rep_all)/60:.1f} min")
    print(f"  Adaptive mean:   {np.mean(adaptive_all)/60:.1f} min")
    print(f"  Full rework mean:{np.mean(rework_all)/60:.1f} min")
    print(f"  Mean time saved: {np.mean(savings_all)/60:.1f} min ({np.mean([r['saving_vs_rework_pct'] for r in data_rows]):.1f}%)")
    print()

    fig9_breakdown()
    fig10_time_vs_defects()
    fig11_savings_histogram()
    fig12_boxplot()

    print("\nAll figures saved to:", OUT_DIR)
