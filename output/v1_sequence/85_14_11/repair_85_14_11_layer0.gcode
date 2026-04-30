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
;     Travel optimised: 38.9 -> 38.9 mm (0% saved)
; 
; --- Overextrusion repair (skim)  conf=0.94 ---
;     bed region: (-29.08,-29.48) -> (-25.54,-25.96)
G1 Z1.400 F600
G0 X-29.078 Y-29.480 F7800
G1 Z0.400 F600
G0 X-29.078 Y-29.480 F7800
G1 X-25.540 Y-29.480 F300
G0 X-25.540 Y-28.247 F7800
G1 X-29.078 Y-28.247 F300
G0 X-29.078 Y-27.014 F7800
G1 X-25.540 Y-27.014 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

G1 Z2.400 F600
; --- Phase 1 complete: layer plane re-established ---

; 
; >>> PHASE 2: UNDEREXTRUSION REPAIRS (1)
;     Re-deposit material into voids on levelled surface
;     Travel optimised: 42.2 -> 42.2 mm (0% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.93 ---
;     bed region: (9.93,-14.27) -> (14.10,-10.28)
G1 A0.00000 F60
G1 Z1.400 F600
G0 X9.930 Y-14.273 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G0 X9.930 Y-14.273 F7800
G1 X14.098 Y-14.273 A0.00177 F300
G0 X14.098 Y-13.040 F7800
G1 X9.930 Y-13.040 A0.00355 F300
G0 X9.930 Y-11.806 F7800
G1 X14.098 Y-11.806 A0.00532 F300
G0 X14.098 Y-10.573 F7800
G1 X9.930 Y-10.573 A0.00709 F300
G1 A0.00709 F60
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
