import json

with open("output/v3_cached_monitor/batch_report.json") as f:
    report = json.load(f)

samples = {s["sample"]: s for s in report["samples"]}

# LaTeX table rows: (sample, decision, defects, over, under, area, time)
latex_rows = [
    ("1_13_35",   "adaptive_repair",  19, 14,  5,  178.2,  6.6),
    ("2_13_43",   "adaptive_repair",   5,  0,  5,   18.2,  4.4),
    ("3_13_48",   "continue",          0,  0,  0,    None,  0.0),
    ("4_13_52",   "adaptive_repair",   4,  0,  4,  493.9,  4.2),
    ("5_14_01",   "adaptive_repair",   3,  0,  3,   47.2,  4.3),
    ("6_14_12",   "adaptive_repair",   1,  1,  0,   15.7,  4.0),
    ("7_14_18",   "adaptive_repair",   8,  8,  0,   70.7,  3.9),
    ("8_14_22",   "adaptive_repair",   1,  1,  0,   15.9,  3.9),
    ("9_14_26",   "adaptive_repair",   6,  1,  5,   41.5,  3.8),
    ("10_14_30",  "adaptive_repair",   4,  0,  4,  162.3,  4.1),
    ("11_14_34",  "continue",          0,  0,  0,    None,  0.0),
    ("12_14_40",  "adaptive_repair",   1,  1,  0,   13.7,  3.9),
    ("13_14_48",  "adaptive_repair",   2,  2,  0,   26.3,  4.0),
    ("14_14_54",  "continue",          0,  0,  0,    None,  0.0),
    ("15_15_03",  "adaptive_repair",   1,  1,  0,   18.0,  3.8),
    ("16_15_08",  "adaptive_repair",   2,  1,  1,   22.5,  3.8),
    ("17_15_11",  "adaptive_repair",   4,  0,  4,   88.1,  3.8),
    ("18_15_16",  "adaptive_repair",   1,  1,  0,   18.1,  4.2),
    ("19_15_20",  "adaptive_repair",   4,  4,  0,   42.1,  4.3),
    ("20_15_28",  "continue",          0,  0,  0,    None,  0.0),
    ("21_15_33",  "adaptive_repair",   1,  1,  0,    8.1,  4.1),
    ("22_15_37",  "continue",          0,  0,  0,    None,  0.0),
    ("23_15_41",  "adaptive_repair",   2,  1,  1,   16.9,  3.9),
    ("24_15_44",  "adaptive_repair",   1,  1,  0,   19.6,  4.0),
    ("25_15_48",  "adaptive_repair",   1,  0,  1,    7.6,  3.8),
    ("26_15_51",  "adaptive_repair",   5,  5,  0,   44.3,  4.3),
    ("27_15_57",  "adaptive_repair",   1,  1,  0,   18.8,  3.9),
    ("28_16_01",  "adaptive_repair",   1,  1,  0,   12.2,  3.9),
    ("29_16_05",  "adaptive_repair",   1,  0,  1,   34.5,  4.2),
    ("30_16_09",  "adaptive_repair",   5,  5,  0,   49.8,  4.0),
    ("31_16_13",  "adaptive_repair",  11,  0, 11,  229.7,  3.9),
    ("32_16_18",  "adaptive_repair",   2,  1,  1,   17.0,  3.8),
    ("33_16_27",  "adaptive_repair",   1,  1,  0,   12.7,  3.8),
    ("34_16_32",  "adaptive_repair",   6,  6,  0,   40.8,  3.7),
    ("35_16_36",  "continue",          0,  0,  0,    None,  0.0),
    ("36_16_45",  "continue",          0,  0,  0,    None,  0.0),
    ("37_16_51",  "adaptive_repair",   8,  0,  8,  214.4,  3.7),
    ("38_16_56",  "adaptive_repair",   2,  2,  0,   21.5,  3.8),
    ("39_17_00",  "adaptive_repair",   1,  1,  0,   13.5,  3.8),
    ("40_17_05",  "adaptive_repair",  16, 16,  0,  129.0,  3.8),
    ("41_17_12",  "continue",          0,  0,  0,    None,  0.0),
    ("42_17_17",  "adaptive_repair",   1,  1,  0,   16.7,  3.8),
    ("43_17_21",  "adaptive_repair",   1,  1,  0,   13.9,  3.8),
    ("44_17_27",  "adaptive_repair",  16,  1, 15,  154.7,  3.7),
    ("45_08_49",  "adaptive_repair",   1,  1,  0,   27.4,  3.7),
    ("46_08_52",  "adaptive_repair",   1,  1,  0,   14.1,  3.7),
    ("47_08_56",  "continue",          0,  0,  0,    None,  0.0),
    ("48_08_59",  "adaptive_repair",   1,  1,  0,   13.3,  3.7),
    ("49_09_02",  "continue",          0,  0,  0,    None,  0.0),
    ("50_09_06",  "adaptive_repair",   1,  1,  0,   16.6,  3.8),
    ("51_09_09",  "continue",          0,  0,  0,    None,  0.0),
    ("52_09_12",  "adaptive_repair",   1,  1,  0,   13.3,  3.7),
    ("53_09_18",  "adaptive_repair",   2,  1,  1,  420.1,  3.9),
    ("54_09_24",  "adaptive_repair",   1,  1,  0,   12.6,  3.7),
    ("55_09_31",  "continue",          0,  0,  0,    None,  0.0),
    ("56_09_37",  "adaptive_repair",   2,  1,  1,   21.0,  3.8),
    ("57_09_45",  "adaptive_repair",   1,  1,  0,   15.8,  3.8),
    ("58_09_49",  "continue",          0,  0,  0,    None,  0.0),
    ("59_09_53",  "adaptive_repair",   1,  1,  0,   12.8,  3.8),
    ("60_09_58",  "adaptive_repair",   1,  1,  0,   19.7,  3.7),
    ("61_10_01",  "adaptive_repair",   7,  4,  3,   58.8,  3.7),
    ("62_10_09",  "continue",          0,  0,  0,    None,  0.0),
    ("63_10_12",  "adaptive_repair",   1,  1,  0,    5.7,  3.7),
    ("64_10_17",  "continue",          0,  0,  0,    None,  0.0),
    ("65_10_25",  "adaptive_repair",   2,  0,  2,   33.9,  3.8),
    ("66_10_50",  "adaptive_repair",   2,  1,  1,   11.4,  3.7),
    ("67_11_00",  "continue",          0,  0,  0,    None,  0.0),
    ("68_11_03",  "continue",          0,  0,  0,    None,  0.0),
    ("69_11_11",  "continue",          0,  0,  0,    None,  0.0),
    ("70_11_15",  "continue",          0,  0,  0,    None,  0.0),
    ("71_11_20",  "adaptive_repair",   1,  1,  0,    5.8,  3.7),
    ("72_11_24",  "adaptive_repair",   1,  1,  0,   19.0,  3.7),
    ("73_11_30",  "adaptive_repair",   1,  0,  1,   34.2,  3.8),
    ("74_11_33",  "adaptive_repair",   6,  1,  5,  141.8,  3.7),
    ("75_11_37",  "continue",          0,  0,  0,    None,  0.0),
    ("76_11_41",  "adaptive_repair",   1,  1,  0,    5.0,  3.7),
    ("77_11_48",  "adaptive_repair",   1,  1,  0,   17.7,  3.8),
    ("78_11_56",  "adaptive_repair",   1,  1,  0,   15.9,  3.8),
    ("79_13_33",  "adaptive_repair",   1,  1,  0,   15.4,  3.7),
    ("80_13_38",  "continue",          0,  0,  0,    None,  0.0),
    ("81_13_44",  "adaptive_repair",   2,  0,  2,   22.9,  3.6),
    ("82_13_48",  "continue",          0,  0,  0,    None,  0.0),
    ("83_14_00",  "adaptive_repair",   9,  0,  9,  518.9,  3.8),
    ("84_14_06",  "continue",          0,  0,  0,    None,  0.0),
    ("85_14_11",  "adaptive_repair",   2,  1,  1,   29.1,  3.7),
    ("86_14_17",  "adaptive_repair",   3,  0,  3,    9.9,  3.7),
    ("87_14_22",  "adaptive_repair",   7,  0,  7,  340.1,  3.7),
    ("88_14_28",  "adaptive_repair",   1,  1,  0,   12.1,  3.7),
    ("89_14_34",  "adaptive_repair",  12,  1, 11,  872.8,  3.8),
    ("90_14_38",  "adaptive_repair",   4,  0,  4,  136.9,  3.6),
    ("91_14_44",  "adaptive_repair",   1,  1,  0,   14.3,  3.7),
    ("92_14_48",  "adaptive_repair",  33,  0, 33, 2410.7,  3.9),
    ("93_14_53",  "continue",          0,  0,  0,    None,  0.0),
    ("94_14_59",  "adaptive_repair",   1,  1,  0,   17.7,  3.7),
    ("95_15_02",  "adaptive_repair",   1,  1,  0,   13.3,  3.7),
    ("96_15_06",  "continue",          0,  0,  0,    None,  0.0),
    ("97_15_11",  "adaptive_repair",   1,  1,  0,   18.2,  3.8),
    ("98_15_16",  "adaptive_repair",   2,  2,  0,   25.6,  3.8),
    ("99_15_21",  "adaptive_repair",  19,  1, 18,  889.5,  4.0),
    ("100_15_30", "continue",          0,  0,  0,    None,  0.0),
    ("101_15_33", "adaptive_repair",   4,  1,  3,   94.7,  3.9),
    ("102_15_38", "continue",          0,  0,  0,    None,  0.0),
    ("103_15_46", "adaptive_repair",   2,  1,  1,   17.6,  3.7),
    ("104_15_51", "adaptive_repair",   1,  1,  0,   18.5,  3.8),
    ("105_15_56", "continue",          0,  0,  0,    None,  0.0),
    ("106_16_02", "adaptive_repair",   1,  1,  0,   17.6,  4.0),
    ("107_16_07", "adaptive_repair",   4,  1,  3,  108.3,  3.8),
    ("108_08_48", "adaptive_repair",   1,  1,  0,   23.2,  3.7),
    ("109_08_55", "adaptive_repair",   1,  1,  0,   12.6,  3.7),
    ("110_08_58", "adaptive_repair",   2,  2,  0,   27.1,  3.7),
    ("111_09_02", "continue",          0,  0,  0,    None,  0.0),
    ("112_09_10", "adaptive_repair",   2,  1,  1,   39.8,  3.7),
    ("113_09_19", "continue",          0,  0,  0,    None,  0.0),
    ("114_09_26", "adaptive_repair",   1,  1,  0,   18.5,  3.7),
    ("115_09_31", "adaptive_repair",   1,  1,  0,   12.5,  3.8),
    ("116_09_34", "adaptive_repair",   1,  1,  0,   19.7,  3.7),
    ("117_09_40", "adaptive_repair",   1,  1,  0,   15.0,  3.6),
    ("118_09_49", "adaptive_repair",   1,  1,  0,   16.7,  3.7),
    ("119_09_58", "adaptive_repair",   1,  1,  0,   14.4,  3.7),
    ("120_10_04", "adaptive_repair",   1,  1,  0,   21.8,  3.8),
]

errors = []
for row in latex_rows:
    name, l_dec, l_def, l_over, l_under, l_area, l_time = row
    if name not in samples:
        errors.append(f"MISSING in JSON: {name}")
        continue
    s = samples[name]
    j_dec   = s["decision"]
    j_def   = s["defects_found"]
    j_over  = s["overextrusions"]
    j_under = s["underextrusions"]
    j_area  = round(s.get("repair_area_mm2", 0.0), 1) if s["repair_needed"] else None
    j_time  = round(s["total_time_s"], 1)

    diffs = []
    if l_dec != j_dec:
        diffs.append(f"decision: LaTeX={l_dec!r} JSON={j_dec!r}")
    if l_def != j_def:
        diffs.append(f"defects: LaTeX={l_def} JSON={j_def}")
    if l_over != j_over:
        diffs.append(f"over: LaTeX={l_over} JSON={j_over}")
    if l_under != j_under:
        diffs.append(f"under: LaTeX={l_under} JSON={j_under}")
    if l_area is not None and j_area is not None and abs(l_area - j_area) > 0.15:
        diffs.append(f"area: LaTeX={l_area} JSON={j_area}")
    if abs(l_time - j_time) > 0.15:
        diffs.append(f"time: LaTeX={l_time} JSON={j_time}")

    if diffs:
        errors.append(f"  {name}: " + "; ".join(diffs))

if errors:
    print(f"ERRORS FOUND ({len(errors)}):")
    for e in errors:
        print(e)
else:
    print("ALL 120 ROWS MATCH - table is correct.")
