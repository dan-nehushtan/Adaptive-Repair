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
;     Travel optimised: 12.7 -> 12.7 mm (0% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.90 ---
;     bed region: (-6.49,-13.00) -> (-3.81,-10.18)
G1 A0.00000 F60
G1 Z1.400 F600
G0 X-6.485 Y-12.995 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G0 X-6.485 Y-12.995 F7800
G1 X-3.805 Y-12.995 A0.00114 F300
G0 X-3.805 Y-11.762 F7800
G1 X-6.485 Y-11.762 A0.00228 F300
G0 X-6.485 Y-10.529 F7800
G1 X-3.805 Y-10.529 A0.00342 F300
G1 A0.00342 F60
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
