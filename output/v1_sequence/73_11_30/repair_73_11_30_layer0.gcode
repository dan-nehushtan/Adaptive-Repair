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
;     Travel optimised: 16.8 -> 16.8 mm (0% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.93 ---
;     bed region: (9.02,-14.83) -> (14.83,-8.95)
G1 A0.00000 F60
G1 Z1.400 F600
G0 X9.020 Y-14.833 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G0 X9.020 Y-14.833 F7800
G1 X14.833 Y-14.833 A0.00247 F300
G0 X14.833 Y-13.600 F7800
G1 X9.020 Y-13.600 A0.00495 F300
G0 X9.020 Y-12.367 F7800
G1 X14.833 Y-12.367 A0.00742 F300
G0 X14.833 Y-11.133 F7800
G1 X9.020 Y-11.133 A0.00989 F300
G0 X9.020 Y-9.900 F7800
G1 X14.833 Y-9.900 A0.01236 F300
G1 A0.01236 F60
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
