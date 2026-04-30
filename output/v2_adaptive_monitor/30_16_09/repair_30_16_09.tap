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
;     Travel optimised: 86.0 -> 56.0 mm (35% saved)
; 
; --- Mill skim: Overextrusion  conf=0.86 ---
;     bed region: (6.88,2.73) -> (9.14,4.63)
G1 Z2.400 F600
G0 X6.877 Y2.730 F7800
G1 Z0.400 F600
G1 X9.140 Y2.730 F200
G1 X9.140 Y3.963 F200
G1 X6.877 Y3.963 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.91 ---
;     bed region: (-29.43,-29.63) -> (-25.22,-25.51)
G1 Z2.400 F600
G0 X-29.428 Y-29.634 F7800
G1 Z0.400 F600
G1 X-25.219 Y-29.634 F200
G1 X-25.219 Y-28.401 F200
G1 X-29.428 Y-28.401 F200
G1 X-29.428 Y-27.168 F200
G1 X-25.219 Y-27.168 F200
G1 X-25.219 Y-25.935 F200
G1 X-29.428 Y-25.935 F200
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
