; ============================================================
; ADAPTIVE REPAIR G-CODE
; Layer 0   Z=0.400 mm
; Defects: 6
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
; >>> PHASE 1: MILL ALL BOUNDING BOXES (6)
;     Overextrusion  : 6 regions (skim excess)
;     Underextrusion : 0 regions (cut clean cavity)
;     Travel optimised: 95.8 -> 61.7 mm (36% saved)
; 
; --- Mill skim: Overextrusion  conf=0.88 ---
;     bed region: (-6.29,6.76) -> (-4.58,8.95)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-6.293 Y6.763 F7800
G1 Z0.400 F600
G1 X-4.575 Y6.763 F200
G1 X-4.575 Y7.996 F200
G1 X-6.293 Y7.996 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.85 ---
;     bed region: (-4.32,9.06) -> (-2.60,11.39)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-4.315 Y9.055 F7800
G1 Z0.400 F600
G1 X-2.598 Y9.055 F200
G1 X-2.598 Y10.288 F200
G1 X-4.315 Y10.288 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.88 ---
;     bed region: (-6.71,9.77) -> (-4.70,12.31)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-6.713 Y9.773 F7800
G1 Z0.400 F600
G1 X-4.698 Y9.773 F200
G1 X-4.698 Y11.006 F200
G1 X-6.713 Y11.006 F200
G1 X-6.713 Y12.239 F200
G1 X-4.698 Y12.239 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.85 ---
;     bed region: (-8.92,11.07) -> (-6.87,13.56)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-8.918 Y11.068 F7800
G1 Z0.400 F600
G1 X-6.868 Y11.068 F200
G1 X-6.868 Y12.301 F200
G1 X-8.918 Y12.301 F200
G1 X-8.918 Y13.534 F200
G1 X-6.868 Y13.534 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.89 ---
;     bed region: (-12.28,3.25) -> (-10.09,5.42)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-12.278 Y3.245 F7800
G1 Z0.400 F600
G1 X-10.088 Y3.245 F200
G1 X-10.088 Y4.478 F200
G1 X-12.278 Y4.478 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.94 ---
;     bed region: (-29.10,-29.57) -> (-24.89,-25.28)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-29.095 Y-29.568 F7800
G1 Z0.400 F600
G1 X-24.893 Y-29.568 F200
G1 X-24.893 Y-28.335 F200
G1 X-29.095 Y-28.335 F200
G1 X-29.095 Y-27.102 F200
G1 X-24.893 Y-27.102 F200
G1 X-24.893 Y-25.869 F200
G1 X-29.095 Y-25.869 F200
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
