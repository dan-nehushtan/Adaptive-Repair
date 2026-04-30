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
;     Travel optimised: 80.4 -> 68.9 mm (14% saved)
; 
; --- Mill skim: Overextrusion  conf=0.91 ---
;     bed region: (13.06,-23.97) -> (16.64,-20.57)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X13.063 Y-23.968 F7800
G1 Z0.400 F600
G1 X16.635 Y-23.968 F200
G1 X16.635 Y-22.735 F200
G1 X13.063 Y-22.735 F200
G1 X13.063 Y-21.502 F200
G1 X16.635 Y-21.502 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.94 ---
;     bed region: (-28.87,-28.89) -> (-25.23,-25.19)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-28.868 Y-28.885 F7800
G1 Z0.400 F600
G1 X-25.225 Y-28.885 F200
G1 X-25.225 Y-27.652 F200
G1 X-28.868 Y-27.652 F200
G1 X-28.868 Y-26.419 F200
G1 X-25.225 Y-26.419 F200
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
