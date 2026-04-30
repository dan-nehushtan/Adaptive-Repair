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
;     Travel optimised: 85.4 -> 69.4 mm (19% saved)
; 
; --- Mill skim: Overextrusion  conf=0.87 ---
;     bed region: (16.79,-14.57) -> (18.90,-12.58)
G1 Z2.400 F600
G0 X16.786 Y-14.573 F7800
G1 Z0.400 F600
G1 X18.901 Y-14.573 F200
G1 X18.901 Y-13.340 F200
G1 X16.786 Y-13.340 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.89 ---
;     bed region: (-28.97,-29.29) -> (-25.07,-25.44)
G1 Z2.400 F600
G0 X-28.966 Y-29.288 F7800
G1 Z0.400 F600
G1 X-25.070 Y-29.288 F200
G1 X-25.070 Y-28.055 F200
G1 X-28.966 Y-28.055 F200
G1 X-28.966 Y-26.822 F200
G1 X-25.070 Y-26.822 F200
G1 X-25.070 Y-25.589 F200
G1 X-28.966 Y-25.589 F200
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
