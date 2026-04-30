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
; >>> PHASE 2: UNDEREXTRUSION REPAIRS (2)
;     Re-deposit material into voids on levelled surface
;     Travel optimised: 20.5 -> 20.1 mm (2% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.85 ---
;     bed region: (-7.05,-5.07) -> (-4.86,-2.95)
G1 A0.00000 F60
G1 Z1.400 F600
G0 X-7.045 Y-5.068 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G0 X-7.045 Y-5.068 F7800
G1 X-4.855 Y-5.068 A0.00093 F300
G0 X-4.855 Y-3.835 F7800
G1 X-7.045 Y-3.835 A0.00186 F300
G1 A0.00186 F60
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.92 ---
;     bed region: (4.93,-5.17) -> (8.97,-0.66)
G1 A0.00186 F60
G1 Z1.400 F600
G0 X4.925 Y-5.173 F7800
G1 Z0.400 F600
G1 A0.00186 F60
G0 X4.925 Y-5.173 F7800
G1 X8.970 Y-5.173 A0.00358 F300
G0 X8.970 Y-3.940 F7800
G1 X4.925 Y-3.940 A0.00530 F300
G0 X4.925 Y-2.707 F7800
G1 X8.970 Y-2.707 A0.00703 F300
G0 X8.970 Y-1.474 F7800
G1 X4.925 Y-1.474 A0.00875 F300
G1 A0.00875 F60
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
