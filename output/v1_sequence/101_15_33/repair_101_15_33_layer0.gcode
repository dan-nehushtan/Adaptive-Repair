; ============================================================
; ADAPTIVE REPAIR G-CODE
; Layer 0   Z=0.400 mm
; Defects: 4
; ============================================================

G21          ; millimetres
G90          ; absolute positioning
G58          ; work coordinate system
G92 A0

; 
; >>> PHASE 1: OVEREXTRUSION REPAIRS (1)
;     Remove excess material to re-establish layer plane
;     Travel optimised: 39.1 -> 39.1 mm (0% saved)
; 
; --- Overextrusion repair (skim)  conf=0.94 ---
;     bed region: (-29.60,-29.74) -> (-25.51,-25.66)
G1 Z1.400 F600
G0 X-29.603 Y-29.743 F7800
G1 Z0.400 F600
G0 X-29.603 Y-29.743 F7800
G1 X-25.505 Y-29.743 F300
G0 X-25.505 Y-28.510 F7800
G1 X-29.603 Y-28.510 F300
G0 X-29.603 Y-27.277 F7800
G1 X-25.505 Y-27.277 F300
G0 X-25.505 Y-26.044 F7800
G1 X-29.603 Y-26.044 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

G1 Z2.400 F600
; --- Phase 1 complete: layer plane re-established ---

; 
; >>> PHASE 2: UNDEREXTRUSION REPAIRS (3)
;     Re-deposit material into voids on levelled surface
;     Travel optimised: 51.5 -> 37.5 mm (27% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.91 ---
;     bed region: (-15.45,-10.28) -> (-12.61,-7.67)
G1 A0.00000 F60
G1 Z1.400 F600
G0 X-15.445 Y-10.283 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G0 X-15.445 Y-10.283 F7800
G1 X-12.608 Y-10.283 A0.00121 F300
G0 X-12.608 Y-9.050 F7800
G1 X-15.445 Y-9.050 A0.00241 F300
G0 X-15.445 Y-7.816 F7800
G1 X-12.608 Y-7.816 A0.00362 F300
G1 A0.00362 F60
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.95 ---
;     bed region: (-12.03,-8.79) -> (-5.10,-1.88)
G1 A0.00362 F60
G1 Z1.400 F600
G0 X-12.033 Y-8.795 F7800
G1 Z0.400 F600
G1 A0.00362 F60
G0 X-12.033 Y-8.795 F7800
G1 X-5.100 Y-8.795 A0.00657 F300
G0 X-5.100 Y-7.562 F7800
G1 X-12.033 Y-7.562 A0.00952 F300
G0 X-12.033 Y-6.329 F7800
G1 X-5.100 Y-6.329 A0.01247 F300
G0 X-5.100 Y-5.096 F7800
G1 X-12.033 Y-5.096 A0.01542 F300
G0 X-12.033 Y-3.863 F7800
G1 X-5.100 Y-3.863 A0.01837 F300
G0 X-5.100 Y-2.630 F7800
G1 X-12.033 Y-2.630 A0.02131 F300
G1 A0.02131 F60
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.93 ---
;     bed region: (-5.45,-2.11) -> (-0.71,2.67)
G1 A0.02131 F60
G1 Z1.400 F600
G0 X-5.453 Y-2.110 F7800
G1 Z0.400 F600
G1 A0.02131 F60
G0 X-5.453 Y-2.110 F7800
G1 X-0.708 Y-2.110 A0.02333 F300
G0 X-0.708 Y-0.877 F7800
G1 X-5.453 Y-0.877 A0.02535 F300
G0 X-5.453 Y0.356 F7800
G1 X-0.708 Y0.356 A0.02737 F300
G0 X-0.708 Y1.589 F7800
G1 X-5.453 Y1.589 A0.02939 F300
G1 A0.02939 F60
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
