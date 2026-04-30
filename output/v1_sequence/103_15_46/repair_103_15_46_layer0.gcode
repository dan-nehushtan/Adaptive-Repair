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
;     Travel optimised: 38.4 -> 38.4 mm (0% saved)
; 
; --- Overextrusion repair (skim)  conf=0.93 ---
;     bed region: (-28.75,-28.99) -> (-25.33,-25.56)
G1 Z1.400 F600
G0 X-28.745 Y-28.990 F7800
G1 Z0.400 F600
G0 X-28.745 Y-28.990 F7800
G1 X-25.330 Y-28.990 F300
G0 X-25.330 Y-27.757 F7800
G1 X-28.745 Y-27.757 F300
G0 X-28.745 Y-26.524 F7800
G1 X-25.330 Y-26.524 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

G1 Z2.400 F600
; --- Phase 1 complete: layer plane re-established ---

; 
; >>> PHASE 2: UNDEREXTRUSION REPAIRS (1)
;     Re-deposit material into voids on levelled surface
;     Travel optimised: 42.0 -> 42.0 mm (0% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.89 ---
;     bed region: (6.15,-4.46) -> (8.73,-2.18)
G1 A0.00000 F60
G1 Z1.400 F600
G0 X6.150 Y-4.455 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G0 X6.150 Y-4.455 F7800
G1 X8.725 Y-4.455 A0.00110 F300
G0 X8.725 Y-3.222 F7800
G1 X6.150 Y-3.222 A0.00219 F300
G1 A0.00219 F60
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
