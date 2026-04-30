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
;     Travel optimised: 68.9 -> 68.9 mm (0% saved)
; 
; --- Mill skim: Overextrusion  conf=0.90 ---
;     bed region: (13.04,-24.11) -> (16.60,-20.62)
G1 Z2.400 F600
G0 X13.038 Y-24.110 F7800
G1 Z0.400 F600
G1 X16.605 Y-24.110 F200
G1 X16.605 Y-22.877 F200
G1 X13.038 Y-22.877 F200
G1 X13.038 Y-21.644 F200
G1 X16.605 Y-21.644 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.90 ---
;     bed region: (-28.72,-28.71) -> (-25.32,-25.27)
G1 Z2.400 F600
G0 X-28.719 Y-28.713 F7800
G1 Z0.400 F600
G1 X-25.321 Y-28.713 F200
G1 X-25.321 Y-27.480 F200
G1 X-28.719 Y-27.480 F200
G1 X-28.719 Y-26.247 F200
G1 X-25.321 Y-26.247 F200
G1 Z2.400 F600
; --- end mill skim ---

G1 Z2.400 F600
M5  ; spindle off after milling
; --- Phase 1 complete: all regions milled ---

; >>> RETURNING MILL (no underextrusion to fill)
M5  ; spindle off
; --- TOOL CHANGE: ceramic nozzle ---
G1 Z50.000 F600
G0 X0.000 Y0.000 F7800
M6 T0  ; pick up ceramic nozzle
; Tool T0 loaded
G92 A0

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
