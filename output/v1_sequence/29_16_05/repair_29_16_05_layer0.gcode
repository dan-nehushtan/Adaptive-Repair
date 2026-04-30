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
; >>> PHASE 2: UNDEREXTRUSION REPAIRS (1)
;     Re-deposit material into voids on levelled surface
;     Travel optimised: 17.2 -> 17.2 mm (0% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.96 ---
;     bed region: (9.27,-15.01) -> (15.15,-9.14)
G1 A0.00000 F60
G1 Z1.400 F600
G0 X9.265 Y-15.008 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G0 X9.265 Y-15.008 F7800
G1 X15.148 Y-15.008 A0.00250 F300
G0 X15.148 Y-13.775 F7800
G1 X9.265 Y-13.775 A0.00500 F300
G0 X9.265 Y-12.542 F7800
G1 X15.148 Y-12.542 A0.00751 F300
G0 X15.148 Y-11.309 F7800
G1 X9.265 Y-11.309 A0.01001 F300
G0 X9.265 Y-10.075 F7800
G1 X15.148 Y-10.075 A0.01251 F300
G1 A0.01251 F60
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
