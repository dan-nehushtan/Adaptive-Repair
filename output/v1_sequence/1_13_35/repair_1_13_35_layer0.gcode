; ============================================================
; ADAPTIVE REPAIR G-CODE
; Layer 0   Z=0.400 mm
; Defects: 19
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
; >>> PHASE 1: MILL ALL BOUNDING BOXES (19)
;     Overextrusion  : 14 regions (skim excess)
;     Underextrusion : 5 regions (cut clean cavity)
;     Travel optimised: 346.2 -> 136.2 mm (61% saved)
; 
; --- Mill skim: Overextrusion  conf=0.92 ---
;     bed region: (-4.21,-14.06) -> (-0.03,-10.96)
G1 Z2.400 F600
G0 X-4.210 Y-14.063 F7800
G1 Z0.400 F600
G1 X-0.025 Y-14.063 F200
G1 X-0.025 Y-12.830 F200
G1 X-4.210 Y-12.830 F200
G1 X-4.210 Y-11.597 F200
G1 X-0.025 Y-11.597 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill cavity: Underextrusion  conf=0.88 ---
;     bed region: (-3.27,-17.20) -> (0.76,-13.97)
G1 Z2.400 F600
G0 X-3.265 Y-17.195 F7800
G1 Z0.400 F600
G1 X0.762 Y-17.195 F200
G1 X0.762 Y-15.962 F200
G1 X-3.265 Y-15.962 F200
G1 X-3.265 Y-14.729 F200
G1 X0.762 Y-14.729 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill skim: Overextrusion  conf=0.88 ---
;     bed region: (-2.44,-19.51) -> (0.15,-16.63)
G1 Z2.400 F600
G0 X-2.442 Y-19.505 F7800
G1 Z0.400 F600
G1 X0.150 Y-19.505 F200
G1 X0.150 Y-18.272 F200
G1 X-2.442 Y-18.272 F200
G1 X-2.442 Y-17.039 F200
G1 X0.150 Y-17.039 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.89 ---
;     bed region: (-5.86,-19.33) -> (-3.35,-16.72)
G1 Z2.400 F600
G0 X-5.855 Y-19.330 F7800
G1 Z0.400 F600
G1 X-3.350 Y-19.330 F200
G1 X-3.350 Y-18.097 F200
G1 X-5.855 Y-18.097 F200
G1 X-5.855 Y-16.864 F200
G1 X-3.350 Y-16.864 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.92 ---
;     bed region: (1.04,-19.40) -> (3.60,-16.69)
G1 Z2.400 F600
G0 X1.040 Y-19.400 F7800
G1 Z0.400 F600
G1 X3.598 Y-19.400 F200
G1 X3.598 Y-18.167 F200
G1 X1.040 Y-18.167 F200
G1 X1.040 Y-16.934 F200
G1 X3.598 Y-16.934 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.91 ---
;     bed region: (4.23,-19.42) -> (6.91,-16.63)
G1 Z2.400 F600
G0 X4.225 Y-19.418 F7800
G1 Z0.400 F600
G1 X6.905 Y-19.418 F200
G1 X6.905 Y-18.184 F200
G1 X4.225 Y-18.184 F200
G1 X4.225 Y-16.951 F200
G1 X6.905 Y-16.951 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.91 ---
;     bed region: (10.79,-19.52) -> (13.82,-16.72)
G1 Z2.400 F600
G0 X10.788 Y-19.523 F7800
G1 Z0.400 F600
G1 X13.818 Y-19.523 F200
G1 X13.818 Y-18.290 F200
G1 X10.788 Y-18.290 F200
G1 X10.788 Y-17.056 F200
G1 X13.818 Y-17.056 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.88 ---
;     bed region: (14.18,-15.38) -> (17.65,-12.47)
G1 Z2.400 F600
G0 X14.183 Y-15.375 F7800
G1 Z0.400 F600
G1 X17.650 Y-15.375 F200
G1 X17.650 Y-14.142 F200
G1 X14.183 Y-14.142 F200
G1 X14.183 Y-12.909 F200
G1 X17.650 Y-12.909 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.86 ---
;     bed region: (14.06,-8.69) -> (17.48,-5.75)
G1 Z2.400 F600
G0 X14.060 Y-8.690 F7800
G1 Z0.400 F600
G1 X17.475 Y-8.690 F200
G1 X17.475 Y-7.457 F200
G1 X14.060 Y-7.457 F200
G1 X14.060 Y-6.224 F200
G1 X17.475 Y-6.224 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.87 ---
;     bed region: (14.41,-5.05) -> (17.67,-2.06)
G1 Z2.400 F600
G0 X14.410 Y-5.050 F7800
G1 Z0.400 F600
G1 X17.668 Y-5.050 F200
G1 X17.668 Y-3.817 F200
G1 X14.410 Y-3.817 F200
G1 X14.410 Y-2.584 F200
G1 X17.668 Y-2.584 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.87 ---
;     bed region: (17.07,-4.98) -> (20.22,-1.39)
G1 Z2.400 F600
G0 X17.070 Y-4.980 F7800
G1 Z0.400 F600
G1 X20.223 Y-4.980 F200
G1 X20.223 Y-3.747 F200
G1 X17.070 Y-3.747 F200
G1 X17.070 Y-2.514 F200
G1 X20.223 Y-2.514 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.90 ---
;     bed region: (13.55,-2.43) -> (17.41,2.53)
G1 Z2.400 F600
G0 X13.553 Y-2.425 F7800
G1 Z0.400 F600
G1 X17.405 Y-2.425 F200
G1 X17.405 Y-1.192 F200
G1 X13.553 Y-1.192 F200
G1 X13.553 Y0.041 F200
G1 X17.405 Y0.041 F200
G1 X17.405 Y1.274 F200
G1 X13.553 Y1.274 F200
G1 X13.553 Y2.507 F200
G1 X17.405 Y2.507 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.88 ---
;     bed region: (14.95,2.14) -> (17.34,4.70)
G1 Z2.400 F600
G0 X14.953 Y2.143 F7800
G1 Z0.400 F600
G1 X17.335 Y2.143 F200
G1 X17.335 Y3.376 F200
G1 X14.953 Y3.376 F200
G1 X14.953 Y4.609 F200
G1 X17.335 Y4.609 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill cavity: Underextrusion  conf=0.90 ---
;     bed region: (13.13,14.22) -> (16.65,17.11)
G1 Z2.400 F600
G0 X13.133 Y14.218 F7800
G1 Z0.400 F600
G1 X16.652 Y14.218 F200
G1 X16.652 Y15.451 F200
G1 X13.133 Y15.451 F200
G1 X13.133 Y16.684 F200
G1 X16.652 Y16.684 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.88 ---
;     bed region: (10.95,14.95) -> (13.78,17.35)
G1 Z2.400 F600
G0 X10.945 Y14.953 F7800
G1 Z0.400 F600
G1 X13.783 Y14.953 F200
G1 X13.783 Y16.186 F200
G1 X10.945 Y16.186 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill skim: Overextrusion  conf=0.86 ---
;     bed region: (11.52,17.40) -> (16.51,20.49)
G1 Z2.400 F600
G0 X11.523 Y17.403 F7800
G1 Z0.400 F600
G1 X16.513 Y17.403 F200
G1 X16.513 Y18.636 F200
G1 X11.523 Y18.636 F200
G1 X11.523 Y19.869 F200
G1 X16.513 Y19.869 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.87 ---
;     bed region: (-5.63,13.50) -> (-3.89,16.04)
G1 Z2.400 F600
G0 X-5.628 Y13.500 F7800
G1 Z0.400 F600
G1 X-3.893 Y13.500 F200
G1 X-3.893 Y14.733 F200
G1 X-5.628 Y14.733 F200
G1 X-5.628 Y15.966 F200
G1 X-3.893 Y15.966 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill cavity: Underextrusion  conf=0.85 ---
;     bed region: (-16.85,-11.84) -> (-14.69,-9.09)
G1 Z2.400 F600
G0 X-16.845 Y-11.840 F7800
G1 Z0.400 F600
G1 X-14.690 Y-11.840 F200
G1 X-14.690 Y-10.607 F200
G1 X-16.845 Y-10.607 F200
G1 X-16.845 Y-9.374 F200
G1 X-14.690 Y-9.374 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.86 ---
;     bed region: (-17.16,-17.56) -> (-14.17,-15.48)
G1 Z2.400 F600
G0 X-17.160 Y-17.562 F7800
G1 Z0.400 F600
G1 X-14.165 Y-17.562 F200
G1 X-14.165 Y-16.329 F200
G1 X-17.160 Y-16.329 F200
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
; >>> PHASE 2: DEPOSIT INTO UNDEREXTRUSION CAVITIES (5)
;     Fill milled cavities with ceramic
;     Travel optimised: 102.0 -> 58.6 mm (43% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.86 ---
;     bed region: (-17.16,-17.56) -> (-14.17,-15.48)
G1 A0.00000 F60
G1 Z2.400 F600
G0 X-17.160 Y-17.562 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G1 X-14.165 Y-17.562 A0.00127 F300
G1 X-14.165 Y-16.329 F7800
G1 X-17.160 Y-16.329 A0.00255 F300
G1 A0.00255 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.85 ---
;     bed region: (-16.85,-11.84) -> (-14.69,-9.09)
G1 A0.00255 F60
G1 Z2.400 F600
G0 X-16.845 Y-11.840 F7800
G1 Z0.400 F600
G1 A0.00255 F60
G1 X-14.690 Y-11.840 A0.00346 F300
G1 X-14.690 Y-10.607 F7800
G1 X-16.845 Y-10.607 A0.00438 F300
G1 X-16.845 Y-9.374 F7800
G1 X-14.690 Y-9.374 A0.00530 F300
G1 A0.00530 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.88 ---
;     bed region: (-3.27,-17.20) -> (0.76,-13.97)
G1 A0.00530 F60
G1 Z2.400 F600
G0 X-3.265 Y-17.195 F7800
G1 Z0.400 F600
G1 A0.00530 F60
G1 X0.762 Y-17.195 A0.00701 F300
G1 X0.762 Y-15.962 F7800
G1 X-3.265 Y-15.962 A0.00872 F300
G1 X-3.265 Y-14.729 F7800
G1 X0.762 Y-14.729 A0.01044 F300
G1 A0.01044 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.88 ---
;     bed region: (10.95,14.95) -> (13.78,17.35)
G1 A0.01044 F60
G1 Z2.400 F600
G0 X10.945 Y14.953 F7800
G1 Z0.400 F600
G1 A0.01044 F60
G1 X13.783 Y14.953 A0.01164 F300
G1 X13.783 Y16.186 F7800
G1 X10.945 Y16.186 A0.01285 F300
G1 A0.01285 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.90 ---
;     bed region: (13.13,14.22) -> (16.65,17.11)
G1 A0.01285 F60
G1 Z2.400 F600
G0 X13.133 Y14.218 F7800
G1 Z0.400 F600
G1 A0.01285 F60
G1 X16.652 Y14.218 A0.01435 F300
G1 X16.652 Y15.451 F7800
G1 X13.133 Y15.451 A0.01585 F300
G1 X13.133 Y16.684 F7800
G1 X16.652 Y16.684 A0.01734 F300
G1 A0.01734 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
