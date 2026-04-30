; ============================================================
; ADAPTIVE REPAIR G-CODE
; Layer 0   Z=0.400 mm
; Defects: 5
; ============================================================

G21          ; millimetres
G90          ; absolute positioning
G58          ; work coordinate system
G92 A0

; 
; >>> PHASE 2: UNDEREXTRUSION REPAIRS (5)
;     Re-deposit material into voids on levelled surface
;     Travel optimised: 84.2 -> 49.0 mm (42% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.86 ---
;     bed region: (-18.00,1.65) -> (-16.28,3.51)
G1 A0.00000 F60
G1 Z1.400 F600
G0 X-18.000 Y1.653 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G0 X-18.000 Y1.653 F7800
G1 X-16.283 Y1.653 A0.00073 F300
G0 X-16.283 Y2.886 F7800
G1 X-18.000 Y2.886 A0.00146 F300
G1 A0.00146 F60
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.89 ---
;     bed region: (-1.85,16.44) -> (0.45,18.37)
G1 A0.00146 F60
G1 Z1.400 F600
G0 X-1.848 Y16.440 F7800
G1 Z0.400 F600
G1 A0.00146 F60
G0 X-1.848 Y16.440 F7800
G1 X0.448 Y16.440 A0.00244 F300
G0 X0.448 Y17.673 F7800
G1 X-1.848 Y17.673 A0.00341 F300
G1 A0.00341 F60
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.90 ---
;     bed region: (1.18,16.49) -> (3.51,18.40)
G1 A0.00341 F60
G1 Z1.400 F600
G0 X1.180 Y16.493 F7800
G1 Z0.400 F600
G1 A0.00341 F60
G0 X1.180 Y16.493 F7800
G1 X3.510 Y16.493 A0.00440 F300
G0 X3.510 Y17.726 F7800
G1 X1.180 Y17.726 A0.00540 F300
G1 A0.00540 F60
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.86 ---
;     bed region: (4.61,16.77) -> (6.61,18.39)
G1 A0.00540 F60
G1 Z1.400 F600
G0 X4.610 Y16.773 F7800
G1 Z0.400 F600
G1 A0.00540 F60
G0 X4.610 Y16.773 F7800
G1 X6.608 Y16.773 A0.00625 F300
G0 X6.608 Y18.006 F7800
G1 X4.610 Y18.006 A0.00710 F300
G1 A0.00710 F60
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.86 ---
;     bed region: (7.87,16.93) -> (9.79,18.42)
G1 A0.00710 F60
G1 Z1.400 F600
G0 X7.865 Y16.930 F7800
G1 Z0.400 F600
G1 A0.00710 F60
G0 X7.865 Y16.930 F7800
G1 X9.793 Y16.930 A0.00792 F300
G0 X9.793 Y18.163 F7800
G1 X7.865 Y18.163 A0.00874 F300
G1 A0.00874 F60
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
