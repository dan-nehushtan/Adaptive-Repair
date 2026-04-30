; ============================================================
; ADAPTIVE REPAIR G-CODE
; Layer 0   Z=0.400 mm
; Defects: 7
; ============================================================

G21          ; millimetres
G90          ; absolute positioning
G58          ; work coordinate system
G92 A0

; 
; >>> PHASE 1: OVEREXTRUSION REPAIRS (4)
;     Remove excess material to re-establish layer plane
;     Travel optimised: 103.1 -> 109.5 mm (-6% saved)
; 
; --- Overextrusion repair (skim)  conf=0.88 ---
;     bed region: (-3.07,-17.20) -> (-0.41,-15.29)
G1 Z1.400 F600
G0 X-3.073 Y-17.195 F7800
G1 Z0.400 F600
G0 X-3.073 Y-17.195 F7800
G1 X-0.410 Y-17.195 F300
G0 X-0.410 Y-15.962 F7800
G1 X-3.073 Y-15.962 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

; --- Overextrusion repair (skim)  conf=0.88 ---
;     bed region: (6.90,-17.28) -> (10.42,-14.52)
G1 Z1.400 F600
G0 X6.903 Y-17.283 F7800
G1 Z0.400 F600
G0 X6.903 Y-17.283 F7800
G1 X10.423 Y-17.283 F300
G0 X10.423 Y-16.050 F7800
G1 X6.903 Y-16.050 F300
G0 X6.903 Y-14.817 F7800
G1 X10.423 Y-14.817 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

; --- Overextrusion repair (skim)  conf=0.94 ---
;     bed region: (-6.75,14.17) -> (-3.65,17.09)
G1 Z1.400 F600
G0 X-6.748 Y14.165 F7800
G1 Z0.400 F600
G0 X-6.748 Y14.165 F7800
G1 X-3.647 Y14.165 F300
G0 X-3.647 Y15.398 F7800
G1 X-6.748 Y15.398 F300
G0 X-6.748 Y16.631 F7800
G1 X-3.647 Y16.631 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

; --- Overextrusion repair (skim)  conf=0.94 ---
;     bed region: (-29.66,-29.64) -> (-25.00,-25.00)
G1 Z1.400 F600
G0 X-29.655 Y-29.638 F7800
G1 Z0.400 F600
G0 X-29.655 Y-29.638 F7800
G1 X-24.998 Y-29.638 F300
G0 X-24.998 Y-28.405 F7800
G1 X-29.655 Y-28.405 F300
G0 X-29.655 Y-27.172 F7800
G1 X-24.998 Y-27.172 F300
G0 X-24.998 Y-25.939 F7800
G1 X-29.655 Y-25.939 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

G1 Z2.400 F600
; --- Phase 1 complete: layer plane re-established ---

; 
; >>> PHASE 2: UNDEREXTRUSION REPAIRS (3)
;     Re-deposit material into voids on levelled surface
;     Travel optimised: 53.9 -> 47.7 mm (11% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.89 ---
;     bed region: (-13.24,-17.21) -> (-10.63,-15.29)
G1 A0.00000 F60
G1 Z1.400 F600
G0 X-13.240 Y-17.213 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G0 X-13.240 Y-17.213 F7800
G1 X-10.630 Y-17.213 A0.00111 F300
G0 X-10.630 Y-15.980 F7800
G1 X-13.240 Y-15.980 A0.00222 F300
G1 A0.00222 F60
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.90 ---
;     bed region: (-9.93,-17.18) -> (-7.22,-15.39)
G1 A0.00222 F60
G1 Z1.400 F600
G0 X-9.933 Y-17.178 F7800
G1 Z0.400 F600
G1 A0.00222 F60
G0 X-9.933 Y-17.178 F7800
G1 X-7.218 Y-17.178 A0.00338 F300
G0 X-7.218 Y-15.945 F7800
G1 X-9.933 Y-15.945 A0.00453 F300
G1 A0.00453 F60
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.88 ---
;     bed region: (15.81,-14.36) -> (17.51,-12.36)
G1 A0.00453 F60
G1 Z1.400 F600
G0 X15.810 Y-14.360 F7800
G1 Z0.400 F600
G1 A0.00453 F60
G0 X15.810 Y-14.360 F7800
G1 X17.510 Y-14.360 A0.00525 F300
G0 X17.510 Y-13.127 F7800
G1 X15.810 Y-13.127 A0.00598 F300
G1 A0.00598 F60
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
