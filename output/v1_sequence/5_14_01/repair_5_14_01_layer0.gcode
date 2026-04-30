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
;     Travel optimised: 44.4 -> 44.4 mm (0% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.96 ---
;     bed region: (9.09,-15.17) -> (15.43,-8.88)
G1 A0.00000 F60
G1 Z1.400 F600
G0 X9.090 Y-15.165 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G0 X9.090 Y-15.165 F7800
G1 X15.428 Y-15.165 A0.00270 F300
G0 X15.428 Y-13.932 F7800
G1 X9.090 Y-13.932 A0.00539 F300
G0 X9.090 Y-12.699 F7800
G1 X15.428 Y-12.699 A0.00809 F300
G0 X15.428 Y-11.466 F7800
G1 X9.090 Y-11.466 A0.01078 F300
G0 X9.090 Y-10.233 F7800
G1 X15.428 Y-10.233 A0.01348 F300
G0 X15.428 Y-9.000 F7800
G1 X9.090 Y-9.000 A0.01618 F300
G1 A0.01618 F60
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.86 ---
;     bed region: (3.86,-17.44) -> (5.94,-15.60)
G1 A0.01618 F60
G1 Z1.400 F600
G0 X3.858 Y-17.440 F7800
G1 Z0.400 F600
G1 A0.01618 F60
G0 X3.858 Y-17.440 F7800
G1 X5.943 Y-17.440 A0.01706 F300
G0 X5.943 Y-16.207 F7800
G1 X3.858 Y-16.207 A0.01795 F300
G1 A0.01795 F60
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.86 ---
;     bed region: (16.35,-3.55) -> (18.16,-1.58)
G1 A0.01795 F60
G1 Z1.400 F600
G0 X16.353 Y-3.545 F7800
G1 Z0.400 F600
G1 A0.01795 F60
G0 X16.353 Y-3.545 F7800
G1 X18.158 Y-3.545 A0.01872 F300
G0 X18.158 Y-2.312 F7800
G1 X16.353 Y-2.312 A0.01948 F300
G1 A0.01948 F60
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
