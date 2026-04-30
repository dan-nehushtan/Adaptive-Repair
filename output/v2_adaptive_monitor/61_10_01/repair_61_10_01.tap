; ============================================================
; ADAPTIVE REPAIR G-CODE
; Layer 0   Z=0.400 mm
; Defects: 3
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
; >>> PHASE 1: MILL ALL BOUNDING BOXES (3)
;     Overextrusion  : 3 regions (skim excess)
;     Underextrusion : 0 regions (cut clean cavity)
;     Travel optimised: 102.4 -> 88.5 mm (14% saved)
; 
; --- Mill skim: Overextrusion  conf=0.90 ---
;     bed region: (-6.73,14.09) -> (-3.59,17.19)
G1 Z2.400 F600
G0 X-6.729 Y14.088 F7800
G1 Z0.400 F600
G1 X-3.588 Y14.088 F200
G1 X-3.588 Y15.321 F200
G1 X-6.729 Y15.321 F200
G1 X-6.729 Y16.554 F200
G1 X-3.588 Y16.554 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.85 ---
;     bed region: (6.86,-17.32) -> (10.44,-14.25)
G1 Z2.400 F600
G0 X6.859 Y-17.324 F7800
G1 Z0.400 F600
G1 X10.442 Y-17.324 F200
G1 X10.442 Y-16.091 F200
G1 X6.859 Y-16.091 F200
G1 X6.859 Y-14.858 F200
G1 X10.442 Y-14.858 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.90 ---
;     bed region: (-29.36,-29.34) -> (-25.15,-25.11)
G1 Z2.400 F600
G0 X-29.358 Y-29.335 F7800
G1 Z0.400 F600
G1 X-25.150 Y-29.335 F200
G1 X-25.150 Y-28.102 F200
G1 X-29.358 Y-28.102 F200
G1 X-29.358 Y-26.869 F200
G1 X-25.150 Y-26.869 F200
G1 X-25.150 Y-25.636 F200
G1 X-29.358 Y-25.636 F200
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
