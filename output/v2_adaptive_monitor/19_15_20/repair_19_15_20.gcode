; ============================================================
; ADAPTIVE REPAIR G-CODE
; Layer 0   Z=0.400 mm
; Defects: 1
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
; >>> PHASE 1: MILL ALL BOUNDING BOXES (1)
;     Overextrusion  : 1 regions (skim excess)
;     Underextrusion : 0 regions (cut clean cavity)
;     Travel optimised: 38.4 -> 38.4 mm (0% saved)
; 
; --- Mill skim: Overextrusion  conf=0.90 ---
;     bed region: (-28.96,-29.27) -> (-25.03,-25.37)
G1 Z2.400 F600
G0 X-28.955 Y-29.271 F7800
G1 Z0.400 F600
G1 X-25.035 Y-29.271 F200
G1 X-25.035 Y-28.038 F200
G1 X-28.955 Y-28.038 F200
G1 X-28.955 Y-26.805 F200
G1 X-25.035 Y-26.805 F200
G1 X-25.035 Y-25.572 F200
G1 X-28.955 Y-25.572 F200
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
