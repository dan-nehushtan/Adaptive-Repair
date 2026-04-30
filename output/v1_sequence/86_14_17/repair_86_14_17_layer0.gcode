; ============================================================
; ADAPTIVE REPAIR G-CODE
; Layer 0   Z=0.400 mm
; Defects: 3
; ============================================================

G21          ; millimetres
G90          ; absolute positioning
G58          ; work coordinate system
G92 A0

; 
; >>> PHASE 2: UNDEREXTRUSION REPAIRS (3)
;     Re-deposit material into voids on levelled surface
;     Travel optimised: 37.0 -> 33.6 mm (9% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.86 ---
;     bed region: (16.53,2.67) -> (18.26,4.60)
G1 A0.00000 F60
G1 Z1.400 F600
G0 X16.527 Y2.668 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G0 X16.527 Y2.668 F7800
G1 X18.263 Y2.668 A0.00074 F300
G0 X18.263 Y3.901 F7800
G1 X16.527 Y3.901 A0.00148 F300
G1 A0.00148 F60
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.86 ---
;     bed region: (16.44,-6.80) -> (18.23,-4.93)
G1 A0.00148 F60
G1 Z1.400 F600
G0 X16.440 Y-6.800 F7800
G1 Z0.400 F600
G1 A0.00148 F60
G0 X16.440 Y-6.800 F7800
G1 X18.228 Y-6.800 A0.00224 F300
G0 X18.228 Y-5.567 F7800
G1 X16.440 Y-5.567 A0.00300 F300
G1 A0.00300 F60
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.86 ---
;     bed region: (16.46,-13.15) -> (18.18,-11.26)
G1 A0.00300 F60
G1 Z1.400 F600
G0 X16.458 Y-13.153 F7800
G1 Z0.400 F600
G1 A0.00300 F60
G0 X16.458 Y-13.153 F7800
G1 X18.175 Y-13.153 A0.00373 F300
G0 X18.175 Y-11.920 F7800
G1 X16.458 Y-11.920 A0.00446 F300
G1 A0.00446 F60
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
