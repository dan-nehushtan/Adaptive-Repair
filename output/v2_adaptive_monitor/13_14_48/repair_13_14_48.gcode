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
; --- Mill skim: Overextrusion  conf=0.91 ---
;     bed region: (-28.84,-29.41) -> (-25.11,-25.74)
G1 Z2.400 F600
G0 X-28.843 Y-29.413 F7800
G1 Z0.400 F600
G1 X-25.111 Y-29.413 F200
G1 X-25.111 Y-28.180 F200
G1 X-28.843 Y-28.180 F200
G1 X-28.843 Y-26.947 F200
G1 X-25.111 Y-26.947 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.88 ---
;     bed region: (-28.10,-31.81) -> (-25.19,-28.88)
G1 Z2.400 F600
G0 X-28.099 Y-31.808 F7800
G1 Z0.400 F600
G1 X-25.195 Y-31.808 F200
G1 X-25.195 Y-30.575 F200
G1 X-28.099 Y-30.575 F200
G1 X-28.099 Y-29.342 F200
G1 X-25.195 Y-29.342 F200
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
