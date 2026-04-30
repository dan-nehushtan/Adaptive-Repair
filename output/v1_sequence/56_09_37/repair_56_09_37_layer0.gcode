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
; >>> PHASE 1: OVEREXTRUSION REPAIRS (1)
;     Remove excess material to re-establish layer plane
;     Travel optimised: 38.8 -> 38.8 mm (0% saved)
; 
; --- Overextrusion repair (skim)  conf=0.93 ---
;     bed region: (-29.17,-29.38) -> (-25.49,-25.63)
G1 Z1.400 F600
G0 X-29.165 Y-29.375 F7800
G1 Z0.400 F600
G0 X-29.165 Y-29.375 F7800
G1 X-25.488 Y-29.375 F300
G0 X-25.488 Y-28.142 F7800
G1 X-29.165 Y-28.142 F300
G0 X-29.165 Y-26.909 F7800
G1 X-25.488 Y-26.909 F300
G0 X-25.488 Y-25.676 F7800
G1 X-29.165 Y-25.676 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

G1 Z2.400 F600
; --- Phase 1 complete: layer plane re-established ---

; 
; >>> PHASE 2: UNDEREXTRUSION REPAIRS (1)
;     Re-deposit material into voids on levelled surface
;     Travel optimised: 42.1 -> 42.1 mm (0% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.89 ---
;     bed region: (5.84,-4.75) -> (8.69,-2.23)
G1 A0.00000 F60
G1 Z1.400 F600
G0 X5.835 Y-4.753 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G0 X5.835 Y-4.753 F7800
G1 X8.690 Y-4.753 A0.00121 F300
G0 X8.690 Y-3.520 F7800
G1 X5.835 Y-3.520 A0.00243 F300
G0 X5.835 Y-2.287 F7800
G1 X8.690 Y-2.287 A0.00364 F300
G1 A0.00364 F60
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
