; ============================================================
; ADAPTIVE REPAIR G-CODE
; Layer 0   Z=0.400 mm
; Defects: 4
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
; >>> PHASE 1: MILL ALL BOUNDING BOXES (4)
;     Overextrusion  : 4 regions (skim excess)
;     Underextrusion : 0 regions (cut clean cavity)
;     Travel optimised: 78.6 -> 56.3 mm (28% saved)
; 
; --- Mill skim: Overextrusion  conf=0.87 ---
;     bed region: (-6.33,-17.32) -> (-3.02,-13.76)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-6.328 Y-17.318 F7800
G1 Z0.400 F600
G1 X-3.018 Y-17.318 F200
G1 X-3.018 Y-16.085 F200
G1 X-6.328 Y-16.085 F200
G1 X-6.328 Y-14.852 F200
G1 X-3.018 Y-14.852 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.89 ---
;     bed region: (-6.54,-19.35) -> (-3.18,-17.32)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-6.538 Y-19.348 F7800
G1 Z0.400 F600
G1 X-3.175 Y-19.348 F200
G1 X-3.175 Y-18.114 F200
G1 X-6.538 Y-18.114 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.90 ---
;     bed region: (0.24,-17.56) -> (2.93,-15.78)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X0.235 Y-17.562 F7800
G1 Z0.400 F600
G1 X2.933 Y-17.562 F200
G1 X2.933 Y-16.329 F200
G1 X0.235 Y-16.329 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.94 ---
;     bed region: (-29.24,-29.59) -> (-24.91,-25.26)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-29.235 Y-29.585 F7800
G1 Z0.400 F600
G1 X-24.910 Y-29.585 F200
G1 X-24.910 Y-28.352 F200
G1 X-29.235 Y-28.352 F200
G1 X-29.235 Y-27.119 F200
G1 X-24.910 Y-27.119 F200
G1 X-24.910 Y-25.886 F200
G1 X-29.235 Y-25.886 F200
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
