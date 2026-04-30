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
;     Travel optimised: 41.4 -> 41.4 mm (0% saved)
; 
; --- Mill skim: Overextrusion  conf=0.94 ---
;     bed region: (-29.03,-29.59) -> (-25.02,-25.72)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-29.025 Y-29.585 F7800
G1 Z0.400 F600
G1 X-25.015 Y-29.585 F200
G1 X-25.015 Y-28.352 F200
G1 X-29.025 Y-28.352 F200
G1 X-29.025 Y-27.119 F200
G1 X-25.015 Y-27.119 F200
G1 X-25.015 Y-25.886 F200
G1 X-29.025 Y-25.886 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.92 ---
;     bed region: (-28.26,-31.98) -> (-25.00,-28.67)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-28.255 Y-31.983 F7800
G1 Z0.400 F600
G1 X-24.998 Y-31.983 F200
G1 X-24.998 Y-30.750 F200
G1 X-28.255 Y-30.750 F200
G1 X-28.255 Y-29.517 F200
G1 X-24.998 Y-29.517 F200
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
