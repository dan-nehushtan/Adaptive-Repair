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
;     Travel optimised: 9.6 -> 9.6 mm (0% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.94 ---
;     bed region: (3.37,-1.24) -> (8.45,3.93)
G1 A0.00000 F60
G1 Z1.400 F600
G0 X3.368 Y-1.235 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G0 X3.368 Y-1.235 F7800
G1 X8.445 Y-1.235 A0.00216 F300
G0 X8.445 Y-0.002 F7800
G1 X3.368 Y-0.002 A0.00432 F300
G0 X3.368 Y1.231 F7800
G1 X8.445 Y1.231 A0.00648 F300
G0 X8.445 Y2.464 F7800
G1 X3.368 Y2.464 A0.00864 F300
G0 X3.368 Y3.697 F7800
G1 X8.445 Y3.697 A0.01080 F300
G1 A0.01080 F60
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.90 ---
;     bed region: (7.41,-1.99) -> (10.20,0.76)
G1 A0.01080 F60
G1 Z1.400 F600
G0 X7.410 Y-1.988 F7800
G1 Z0.400 F600
G1 A0.01080 F60
G0 X7.410 Y-1.988 F7800
G1 X10.195 Y-1.988 A0.01198 F300
G0 X10.195 Y-0.754 F7800
G1 X7.410 Y-0.754 A0.01317 F300
G0 X7.410 Y0.479 F7800
G1 X10.195 Y0.479 A0.01435 F300
G1 A0.01435 F60
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
