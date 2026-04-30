; ============================================================
; ADAPTIVE REPAIR G-CODE
; Layer 0   Z=0.400 mm
; Defects: 4
; ============================================================

G21          ; millimetres
G90          ; absolute positioning
G58          ; work coordinate system
G92 A0

; 
; >>> PHASE 1: OVEREXTRUSION REPAIRS (4)
;     Remove excess material to re-establish layer plane
;     Travel optimised: 78.6 -> 56.3 mm (28% saved)
; 
; --- Overextrusion repair (skim)  conf=0.87 ---
;     bed region: (-6.33,-17.32) -> (-3.02,-13.76)
G1 Z1.400 F600
G0 X-6.328 Y-17.318 F7800
G1 Z0.400 F600
G0 X-6.328 Y-17.318 F7800
G1 X-3.018 Y-17.318 F300
G0 X-3.018 Y-16.085 F7800
G1 X-6.328 Y-16.085 F300
G0 X-6.328 Y-14.852 F7800
G1 X-3.018 Y-14.852 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

; --- Overextrusion repair (skim)  conf=0.89 ---
;     bed region: (-6.54,-19.35) -> (-3.18,-17.32)
G1 Z1.400 F600
G0 X-6.538 Y-19.348 F7800
G1 Z0.400 F600
G0 X-6.538 Y-19.348 F7800
G1 X-3.175 Y-19.348 F300
G0 X-3.175 Y-18.114 F7800
G1 X-6.538 Y-18.114 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

; --- Overextrusion repair (skim)  conf=0.90 ---
;     bed region: (0.24,-17.56) -> (2.93,-15.78)
G1 Z1.400 F600
G0 X0.235 Y-17.562 F7800
G1 Z0.400 F600
G0 X0.235 Y-17.562 F7800
G1 X2.933 Y-17.562 F300
G0 X2.933 Y-16.329 F7800
G1 X0.235 Y-16.329 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

; --- Overextrusion repair (skim)  conf=0.94 ---
;     bed region: (-29.24,-29.59) -> (-24.91,-25.26)
G1 Z1.400 F600
G0 X-29.235 Y-29.585 F7800
G1 Z0.400 F600
G0 X-29.235 Y-29.585 F7800
G1 X-24.910 Y-29.585 F300
G0 X-24.910 Y-28.352 F7800
G1 X-29.235 Y-28.352 F300
G0 X-29.235 Y-27.119 F7800
G1 X-24.910 Y-27.119 F300
G0 X-24.910 Y-25.886 F7800
G1 X-29.235 Y-25.886 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

G1 Z2.400 F600
; --- Phase 1 complete: layer plane re-established ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
