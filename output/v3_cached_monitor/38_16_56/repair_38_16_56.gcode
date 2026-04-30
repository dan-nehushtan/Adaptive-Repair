; ============================================================
; ADAPTIVE REPAIR G-CODE
; Layer 0   Z=0.400 mm
; Defects: 2
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
; >>> PHASE 1: MILL ALL BOUNDING BOXES (2)
;     Overextrusion  : 2 regions (skim excess)
;     Underextrusion : 0 regions (cut clean cavity)
;     Travel optimised: 96.5 -> 77.8 mm (19% saved)
; 
; --- Mill skim: Overextrusion  conf=0.87 ---
;     bed region: (16.56,8.30) -> (18.56,10.41)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X16.562 Y8.303 F7800
G1 Z0.400 F600
G1 X18.560 Y8.303 F200
G1 X18.560 Y9.536 F200
G1 X16.562 Y9.536 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.94 ---
;     bed region: (-29.22,-29.53) -> (-25.07,-25.37)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-29.218 Y-29.533 F7800
G1 Z0.400 F600
G1 X-25.068 Y-29.533 F200
G1 X-25.068 Y-28.300 F200
G1 X-29.218 Y-28.300 F200
G1 X-29.218 Y-27.067 F200
G1 X-25.068 Y-27.067 F200
G1 X-25.068 Y-25.834 F200
G1 X-29.218 Y-25.834 F200
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
