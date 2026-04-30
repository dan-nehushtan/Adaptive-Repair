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
;     Travel optimised: 106.9 -> 75.5 mm (29% saved)
; 
; --- Mill skim: Overextrusion  conf=0.89 ---
;     bed region: (0.64,-6.50) -> (3.02,-4.03)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X0.638 Y-6.503 F7800
G1 Z0.400 F600
G1 X3.020 Y-6.503 F200
G1 X3.020 Y-5.270 F200
G1 X0.638 Y-5.270 F200
G1 X0.638 Y-4.037 F200
G1 X3.020 Y-4.037 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.86 ---
;     bed region: (-0.26,-11.51) -> (3.69,-8.60)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-0.255 Y-11.508 F7800
G1 Z0.400 F600
G1 X3.685 Y-11.508 F200
G1 X3.685 Y-10.274 F200
G1 X-0.255 Y-10.274 F200
G1 X-0.255 Y-9.041 F200
G1 X3.685 Y-9.041 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.90 ---
;     bed region: (6.89,2.74) -> (9.18,4.60)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X6.885 Y2.738 F7800
G1 Z0.400 F600
G1 X9.180 Y2.738 F200
G1 X9.180 Y3.971 F200
G1 X6.885 Y3.971 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.89 ---
;     bed region: (1.39,4.14) -> (4.51,6.42)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X1.390 Y4.138 F7800
G1 Z0.400 F600
G1 X4.508 Y4.138 F200
G1 X4.508 Y5.370 F200
G1 X1.390 Y5.370 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.94 ---
;     bed region: (-29.64,-29.95) -> (-25.03,-25.38)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-29.638 Y-29.953 F7800
G1 Z0.400 F600
G1 X-25.033 Y-29.953 F200
G1 X-25.033 Y-28.720 F200
G1 X-29.638 Y-28.720 F200
G1 X-29.638 Y-27.487 F200
G1 X-25.033 Y-27.487 F200
G1 X-25.033 Y-26.254 F200
G1 X-29.638 Y-26.254 F200
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
