; ============================================================
; ADAPTIVE REPAIR G-CODE
; Layer 0   Z=0.400 mm
; Defects: 18
; ============================================================

G21          ; millimetres
G90          ; absolute positioning
G58          ; work coordinate system
G92 A0

; 
; >>> PICKING UP MILLING TOOL
; --- TOOL CHANGE: milling tool ---
G1 Z50.000 F600
G0 X0.000 Y0.000 F7800
M6 T1  ; pick up milling tool
; Tool T1 loaded
M3 S1000  ; spindle on

; 
; >>> PHASE 1: MILL ALL BOUNDING BOXES (18)
;     Overextrusion  : 11 regions (skim excess)
;     Underextrusion : 7 regions (cut clean cavity)
;     Travel optimised: 398.0 -> 126.2 mm (68% saved)
; 
; --- Mill skim: Overextrusion  conf=0.90 ---
;     bed region: (-4.23,-14.07) -> (0.02,-10.92)
G1 Z2.400 F600
G0 X-4.230 Y-14.074 F7800
G1 Z0.400 F600
G1 X0.018 Y-14.074 F200
G1 X0.018 Y-12.841 F200
G1 X-4.230 Y-12.841 F200
G1 X-4.230 Y-11.608 F200
G1 X0.018 Y-11.608 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.85 ---
;     bed region: (-6.13,-17.10) -> (-2.60,-14.05)
G1 Z2.400 F600
G0 X-6.126 Y-17.096 F7800
G1 Z0.400 F600
G1 X-2.600 Y-17.096 F200
G1 X-2.600 Y-15.863 F200
G1 X-6.126 Y-15.863 F200
G1 X-6.126 Y-14.630 F200
G1 X-2.600 Y-14.630 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.86 ---
;     bed region: (-10.09,-17.22) -> (-5.86,-13.40)
G1 Z2.400 F600
G0 X-10.086 Y-17.221 F7800
G1 Z0.400 F600
G1 X-5.863 Y-17.221 F200
G1 X-5.863 Y-15.988 F200
G1 X-10.086 Y-15.988 F200
G1 X-10.086 Y-14.755 F200
G1 X-5.863 Y-14.755 F200
G1 X-5.863 Y-13.522 F200
G1 X-10.086 Y-13.522 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.88 ---
;     bed region: (-2.39,-19.50) -> (0.18,-16.57)
G1 Z2.400 F600
G0 X-2.392 Y-19.499 F7800
G1 Z0.400 F600
G1 X0.177 Y-19.499 F200
G1 X0.177 Y-18.266 F200
G1 X-2.392 Y-18.266 F200
G1 X-2.392 Y-17.033 F200
G1 X0.177 Y-17.033 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.89 ---
;     bed region: (0.99,-19.33) -> (3.65,-16.66)
G1 Z2.400 F600
G0 X0.994 Y-19.330 F7800
G1 Z0.400 F600
G1 X3.648 Y-19.330 F200
G1 X3.648 Y-18.097 F200
G1 X0.994 Y-18.097 F200
G1 X0.994 Y-16.864 F200
G1 X3.648 Y-16.864 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.87 ---
;     bed region: (4.18,-19.31) -> (6.96,-16.57)
G1 Z2.400 F600
G0 X4.180 Y-19.309 F7800
G1 Z0.400 F600
G1 X6.964 Y-19.309 F200
G1 X6.964 Y-18.076 F200
G1 X4.180 Y-18.076 F200
G1 X4.180 Y-16.843 F200
G1 X6.964 Y-16.843 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.86 ---
;     bed region: (10.76,-19.34) -> (13.86,-16.67)
G1 Z2.400 F600
G0 X10.760 Y-19.341 F7800
G1 Z0.400 F600
G1 X13.859 Y-19.341 F200
G1 X13.859 Y-18.108 F200
G1 X10.760 Y-18.108 F200
G1 X10.760 Y-16.875 F200
G1 X13.859 Y-16.875 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.87 ---
;     bed region: (17.07,-4.93) -> (19.92,-1.44)
G1 Z2.400 F600
G0 X17.070 Y-4.932 F7800
G1 Z0.400 F600
G1 X19.916 Y-4.932 F200
G1 X19.916 Y-3.699 F200
G1 X17.070 Y-3.699 F200
G1 X17.070 Y-2.466 F200
G1 X19.916 Y-2.466 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.89 ---
;     bed region: (13.56,-2.33) -> (17.37,2.51)
G1 Z2.400 F600
G0 X13.565 Y-2.328 F7800
G1 Z0.400 F600
G1 X17.372 Y-2.328 F200
G1 X17.372 Y-1.095 F200
G1 X13.565 Y-1.095 F200
G1 X13.565 Y0.138 F200
G1 X17.372 Y0.138 F200
G1 X17.372 Y1.371 F200
G1 X13.565 Y1.371 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.89 ---
;     bed region: (15.01,2.18) -> (17.39,4.76)
G1 Z2.400 F600
G0 X15.011 Y2.181 F7800
G1 Z0.400 F600
G1 X17.387 Y2.181 F200
G1 X17.387 Y3.414 F200
G1 X15.011 Y3.414 F200
G1 X15.011 Y4.647 F200
G1 X17.387 Y4.647 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill cavity: Underextrusion  conf=0.87 ---
;     bed region: (14.22,4.99) -> (17.29,8.48)
G1 Z2.400 F600
G0 X14.217 Y4.989 F7800
G1 Z0.400 F600
G1 X17.290 Y4.989 F200
G1 X17.290 Y6.222 F200
G1 X14.217 Y6.222 F200
G1 X14.217 Y7.455 F200
G1 X17.290 Y7.455 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.88 ---
;     bed region: (14.60,8.80) -> (17.60,11.80)
G1 Z2.400 F600
G0 X14.595 Y8.795 F7800
G1 Z0.400 F600
G1 X17.598 Y8.795 F200
G1 X17.598 Y10.028 F200
G1 X14.595 Y10.028 F200
G1 X14.595 Y11.261 F200
G1 X17.598 Y11.261 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.89 ---
;     bed region: (14.86,12.45) -> (17.39,14.80)
G1 Z2.400 F600
G0 X14.861 Y12.445 F7800
G1 Z0.400 F600
G1 X17.392 Y12.445 F200
G1 X17.392 Y13.678 F200
G1 X14.861 Y13.678 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.89 ---
;     bed region: (13.17,14.35) -> (16.56,17.09)
G1 Z2.400 F600
G0 X13.174 Y14.355 F7800
G1 Z0.400 F600
G1 X16.558 Y14.355 F200
G1 X16.558 Y15.588 F200
G1 X13.174 Y15.588 F200
G1 X13.174 Y16.821 F200
G1 X16.558 Y16.821 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.88 ---
;     bed region: (11.01,14.91) -> (13.83,17.22)
G1 Z2.400 F600
G0 X11.007 Y14.909 F7800
G1 Z0.400 F600
G1 X13.832 Y14.909 F200
G1 X13.832 Y16.142 F200
G1 X11.007 Y16.142 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill skim: Overextrusion  conf=0.89 ---
;     bed region: (-19.50,-7.73) -> (-17.13,-5.27)
G1 Z2.400 F600
G0 X-19.503 Y-7.728 F7800
G1 Z0.400 F600
G1 X-17.131 Y-7.728 F200
G1 X-17.131 Y-6.495 F200
G1 X-19.503 Y-6.495 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill cavity: Underextrusion  conf=0.86 ---
;     bed region: (-16.92,-11.83) -> (-14.64,-8.97)
G1 Z2.400 F600
G0 X-16.918 Y-11.833 F7800
G1 Z0.400 F600
G1 X-14.639 Y-11.833 F200
G1 X-14.639 Y-10.600 F200
G1 X-16.918 Y-10.600 F200
G1 X-16.918 Y-9.367 F200
G1 X-14.639 Y-9.367 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.87 ---
;     bed region: (-16.81,-15.24) -> (-14.49,-12.42)
G1 Z2.400 F600
G0 X-16.811 Y-15.240 F7800
G1 Z0.400 F600
G1 X-14.494 Y-15.240 F200
G1 X-14.494 Y-14.007 F200
G1 X-16.811 Y-14.007 F200
G1 X-16.811 Y-12.774 F200
G1 X-14.494 Y-12.774 F200
G1 Z2.400 F600
; --- end mill cavity ---

G1 Z2.400 F600
M5  ; spindle off after milling
; --- Phase 1 complete: all regions milled ---

; >>> RETURNING MILL, PICKING UP NOZZLE FOR DEPOSITION
M5  ; spindle off
; --- TOOL CHANGE: ceramic nozzle ---
G1 Z50.000 F600
G0 X0.000 Y0.000 F7800
M6 T0  ; pick up ceramic nozzle
; Tool T0 loaded
G92 A0

; 
; >>> PHASE 2: DEPOSIT INTO UNDEREXTRUSION CAVITIES (7)
;     Fill milled cavities with ceramic
;     Travel optimised: 169.5 -> 51.1 mm (70% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.87 ---
;     bed region: (-16.81,-15.24) -> (-14.49,-12.42)
G1 A0.00000 F60
G1 Z2.400 F600
G0 X-16.811 Y-15.240 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G1 X-14.494 Y-15.240 A0.00099 F300
G1 X-14.494 Y-14.007 F7800
G1 X-16.811 Y-14.007 A0.00197 F300
G1 X-16.811 Y-12.774 F7800
G1 X-14.494 Y-12.774 A0.00296 F300
G1 A0.00296 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.86 ---
;     bed region: (-16.92,-11.83) -> (-14.64,-8.97)
G1 A0.00296 F60
G1 Z2.400 F600
G0 X-16.918 Y-11.833 F7800
G1 Z0.400 F600
G1 A0.00296 F60
G1 X-14.639 Y-11.833 A0.00393 F300
G1 X-14.639 Y-10.600 F7800
G1 X-16.918 Y-10.600 A0.00490 F300
G1 X-16.918 Y-9.367 F7800
G1 X-14.639 Y-9.367 A0.00586 F300
G1 A0.00586 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.87 ---
;     bed region: (14.22,4.99) -> (17.29,8.48)
G1 A0.00586 F60
G1 Z2.400 F600
G0 X14.217 Y4.989 F7800
G1 Z0.400 F600
G1 A0.00586 F60
G1 X17.290 Y4.989 A0.00717 F300
G1 X17.290 Y6.222 F7800
G1 X14.217 Y6.222 A0.00848 F300
G1 X14.217 Y7.455 F7800
G1 X17.290 Y7.455 A0.00979 F300
G1 A0.00979 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.88 ---
;     bed region: (14.60,8.80) -> (17.60,11.80)
G1 A0.00979 F60
G1 Z2.400 F600
G0 X14.595 Y8.795 F7800
G1 Z0.400 F600
G1 A0.00979 F60
G1 X17.598 Y8.795 A0.01106 F300
G1 X17.598 Y10.028 F7800
G1 X14.595 Y10.028 A0.01234 F300
G1 X14.595 Y11.261 F7800
G1 X17.598 Y11.261 A0.01362 F300
G1 A0.01362 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.89 ---
;     bed region: (14.86,12.45) -> (17.39,14.80)
G1 A0.01362 F60
G1 Z2.400 F600
G0 X14.861 Y12.445 F7800
G1 Z0.400 F600
G1 A0.01362 F60
G1 X17.392 Y12.445 A0.01470 F300
G1 X17.392 Y13.678 F7800
G1 X14.861 Y13.678 A0.01577 F300
G1 A0.01577 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.89 ---
;     bed region: (13.17,14.35) -> (16.56,17.09)
G1 A0.01577 F60
G1 Z2.400 F600
G0 X13.174 Y14.355 F7800
G1 Z0.400 F600
G1 A0.01577 F60
G1 X16.558 Y14.355 A0.01721 F300
G1 X16.558 Y15.588 F7800
G1 X13.174 Y15.588 A0.01865 F300
G1 X13.174 Y16.821 F7800
G1 X16.558 Y16.821 A0.02009 F300
G1 A0.02009 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.88 ---
;     bed region: (11.01,14.91) -> (13.83,17.22)
G1 A0.02009 F60
G1 Z2.400 F600
G0 X11.007 Y14.909 F7800
G1 Z0.400 F600
G1 A0.02009 F60
G1 X13.832 Y14.909 A0.02129 F300
G1 X13.832 Y16.142 F7800
G1 X11.007 Y16.142 A0.02250 F300
G1 A0.02250 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
