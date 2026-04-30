; ============================================================
; ADAPTIVE REPAIR G-CODE
; Layer 0   Z=0.400 mm
; Defects: 5
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
; >>> PHASE 1: MILL ALL BOUNDING BOXES (5)
;     Overextrusion  : 5 regions (skim excess)
;     Underextrusion : 0 regions (cut clean cavity)
;     Travel optimised: 95.5 -> 89.9 mm (6% saved)
; 
; --- Mill skim: Overextrusion  conf=0.90 ---
;     bed region: (-10.91,-8.06) -> (-8.55,-5.78)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-10.913 Y-8.060 F7800
G1 Z0.400 F600
G1 X-8.548 Y-8.060 F200
G1 X-8.548 Y-6.827 F200
G1 X-10.913 Y-6.827 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.90 ---
;     bed region: (-10.84,6.62) -> (-8.71,8.94)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-10.843 Y6.623 F7800
G1 Z0.400 F600
G1 X-8.705 Y6.623 F200
G1 X-8.705 Y7.856 F200
G1 X-10.843 Y7.856 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.90 ---
;     bed region: (-12.68,8.15) -> (-9.95,10.88)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-12.680 Y8.145 F7800
G1 Z0.400 F600
G1 X-9.948 Y8.145 F200
G1 X-9.948 Y9.378 F200
G1 X-12.680 Y9.378 F200
G1 X-12.680 Y10.611 F200
G1 X-9.948 Y10.611 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.90 ---
;     bed region: (-6.99,16.97) -> (-3.75,19.35)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-6.993 Y16.965 F7800
G1 Z0.400 F600
G1 X-3.753 Y16.965 F200
G1 X-3.753 Y18.198 F200
G1 X-6.993 Y18.198 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.93 ---
;     bed region: (-29.27,-29.59) -> (-24.98,-25.21)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-29.270 Y-29.585 F7800
G1 Z0.400 F600
G1 X-24.980 Y-29.585 F200
G1 X-24.980 Y-28.352 F200
G1 X-29.270 Y-28.352 F200
G1 X-29.270 Y-27.119 F200
G1 X-24.980 Y-27.119 F200
G1 X-24.980 Y-25.886 F200
G1 X-29.270 Y-25.886 F200
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
