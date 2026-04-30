; ============================================================
; ADAPTIVE REPAIR G-CODE
; Layer 0   Z=0.400 mm
; Defects: 16
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
; >>> PHASE 1: MILL ALL BOUNDING BOXES (16)
;     Overextrusion  : 16 regions (skim excess)
;     Underextrusion : 0 regions (cut clean cavity)
;     Travel optimised: 304.5 -> 187.0 mm (39% saved)
; 
; --- Mill skim: Overextrusion  conf=0.92 ---
;     bed region: (-4.88,-0.89) -> (-0.85,3.63)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-4.875 Y-0.885 F7800
G1 Z0.400 F600
G1 X-0.848 Y-0.885 F200
G1 X-0.848 Y0.348 F200
G1 X-4.875 Y0.348 F200
G1 X-4.875 Y1.581 F200
G1 X-0.848 Y1.581 F200
G1 X-0.848 Y2.814 F200
G1 X-4.875 Y2.814 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.89 ---
;     bed region: (-10.23,-1.06) -> (-8.09,0.80)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-10.230 Y-1.060 F7800
G1 Z0.400 F600
G1 X-8.093 Y-1.060 F200
G1 X-8.093 Y0.173 F200
G1 X-10.230 Y0.173 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.89 ---
;     bed region: (-11.21,-0.71) -> (-9.11,1.52)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-11.210 Y-0.710 F7800
G1 Z0.400 F600
G1 X-9.108 Y-0.710 F200
G1 X-9.108 Y0.523 F200
G1 X-11.210 Y0.523 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.88 ---
;     bed region: (-8.88,4.44) -> (-6.43,7.71)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-8.883 Y4.435 F7800
G1 Z0.400 F600
G1 X-6.430 Y4.435 F200
G1 X-6.430 Y5.668 F200
G1 X-8.883 Y5.668 F200
G1 X-8.883 Y6.901 F200
G1 X-6.430 Y6.901 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.92 ---
;     bed region: (-10.79,6.61) -> (-8.60,8.92)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-10.790 Y6.605 F7800
G1 Z0.400 F600
G1 X-8.600 Y6.605 F200
G1 X-8.600 Y7.838 F200
G1 X-10.790 Y7.838 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.93 ---
;     bed region: (-18.68,6.03) -> (-14.92,9.01)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-18.683 Y6.028 F7800
G1 Z0.400 F600
G1 X-14.918 Y6.028 F200
G1 X-14.918 Y7.261 F200
G1 X-18.683 Y7.261 F200
G1 X-18.683 Y8.494 F200
G1 X-14.918 Y8.494 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.92 ---
;     bed region: (-3.97,11.21) -> (-1.92,13.64)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-3.965 Y11.208 F7800
G1 Z0.400 F600
G1 X-1.915 Y11.208 F200
G1 X-1.915 Y12.441 F200
G1 X-3.965 Y12.441 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.94 ---
;     bed region: (-2.57,9.13) -> (0.17,11.81)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-2.565 Y9.125 F7800
G1 Z0.400 F600
G1 X0.167 Y9.125 F200
G1 X0.167 Y10.358 F200
G1 X-2.565 Y10.358 F200
G1 X-2.565 Y11.591 F200
G1 X0.167 Y11.591 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.85 ---
;     bed region: (2.39,9.83) -> (4.21,11.70)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X2.388 Y9.825 F7800
G1 Z0.400 F600
G1 X4.210 Y9.825 F200
G1 X4.210 Y11.058 F200
G1 X2.388 Y11.058 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.91 ---
;     bed region: (6.78,11.14) -> (9.85,14.15)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X6.780 Y11.138 F7800
G1 Z0.400 F600
G1 X9.845 Y11.138 F200
G1 X9.845 Y12.371 F200
G1 X6.780 Y12.371 F200
G1 X6.780 Y13.604 F200
G1 X9.845 Y13.604 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.87 ---
;     bed region: (13.92,14.71) -> (16.02,16.64)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X13.920 Y14.708 F7800
G1 Z0.400 F600
G1 X16.023 Y14.708 F200
G1 X16.023 Y15.941 F200
G1 X13.920 Y15.941 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.90 ---
;     bed region: (16.02,-0.59) -> (20.01,3.56)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X16.020 Y-0.588 F7800
G1 Z0.400 F600
G1 X20.013 Y-0.588 F200
G1 X20.013 Y0.646 F200
G1 X16.020 Y0.646 F200
G1 X16.020 Y1.879 F200
G1 X20.013 Y1.879 F200
G1 X20.013 Y3.112 F200
G1 X16.020 Y3.112 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.87 ---
;     bed region: (-8.22,-8.83) -> (-6.40,-7.20)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-8.218 Y-8.830 F7800
G1 Z0.400 F600
G1 X-6.395 Y-8.830 F200
G1 X-6.395 Y-7.597 F200
G1 X-8.218 Y-7.597 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.89 ---
;     bed region: (-6.66,-19.44) -> (-4.19,-16.97)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-6.660 Y-19.435 F7800
G1 Z0.400 F600
G1 X-4.190 Y-19.435 F200
G1 X-4.190 Y-18.202 F200
G1 X-6.660 Y-18.202 F200
G1 X-6.660 Y-16.969 F200
G1 X-4.190 Y-16.969 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.94 ---
;     bed region: (-29.06,-29.46) -> (-25.33,-25.72)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-29.060 Y-29.463 F7800
G1 Z0.400 F600
G1 X-25.330 Y-29.463 F200
G1 X-25.330 Y-28.230 F200
G1 X-29.060 Y-28.230 F200
G1 X-29.060 Y-26.997 F200
G1 X-25.330 Y-26.997 F200
G1 X-25.330 Y-25.764 F200
G1 X-29.060 Y-25.764 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.88 ---
;     bed region: (-7.62,16.49) -> (-4.16,19.14)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-7.623 Y16.493 F7800
G1 Z0.400 F600
G1 X-4.155 Y16.493 F200
G1 X-4.155 Y17.726 F200
G1 X-7.623 Y17.726 F200
G1 X-7.623 Y18.959 F200
G1 X-4.155 Y18.959 F200
G1 Z2.400 F600
; --- end mill skim ---

G1 Z2.400 F600
M5  ; spindle off after milling
; --- DUST EXTRACTION (placeholder) ---
;     TODO: set DUST_EXTRACT_COMMAND in config.py
;     Ceramic chips must be cleared before deposition
; --- Phase 1 complete: all regions milled ---

; >>> RETURNING MILL (no underextrusion to fill)
M5  ; spindle off
; --- TOOL CHANGE: ceramic nozzle ---
G1 Z50.000 F600
G0 X0.000 Y0.000 F7800
M6 T0  ; pick up ceramic nozzle
; Tool T0 loaded
G92 A0

; --- CAMERA SCAN (re-inspection) ---
M311  ; trigger camera scan

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
