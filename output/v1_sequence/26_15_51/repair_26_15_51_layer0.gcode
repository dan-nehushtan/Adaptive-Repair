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
; >>> PHASE 1: OVEREXTRUSION REPAIRS (5)
;     Remove excess material to re-establish layer plane
;     Travel optimised: 95.5 -> 89.9 mm (6% saved)
; 
; --- Overextrusion repair (skim)  conf=0.90 ---
;     bed region: (-10.91,-8.06) -> (-8.55,-5.78)
G1 Z1.400 F600
G0 X-10.913 Y-8.060 F7800
G1 Z0.400 F600
G0 X-10.913 Y-8.060 F7800
G1 X-8.548 Y-8.060 F300
G0 X-8.548 Y-6.827 F7800
G1 X-10.913 Y-6.827 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

; --- Overextrusion repair (skim)  conf=0.90 ---
;     bed region: (-10.84,6.62) -> (-8.71,8.94)
G1 Z1.400 F600
G0 X-10.843 Y6.623 F7800
G1 Z0.400 F600
G0 X-10.843 Y6.623 F7800
G1 X-8.705 Y6.623 F300
G0 X-8.705 Y7.856 F7800
G1 X-10.843 Y7.856 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

; --- Overextrusion repair (skim)  conf=0.90 ---
;     bed region: (-12.68,8.15) -> (-9.95,10.88)
G1 Z1.400 F600
G0 X-12.680 Y8.145 F7800
G1 Z0.400 F600
G0 X-12.680 Y8.145 F7800
G1 X-9.948 Y8.145 F300
G0 X-9.948 Y9.378 F7800
G1 X-12.680 Y9.378 F300
G0 X-12.680 Y10.611 F7800
G1 X-9.948 Y10.611 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

; --- Overextrusion repair (skim)  conf=0.90 ---
;     bed region: (-6.99,16.97) -> (-3.75,19.35)
G1 Z1.400 F600
G0 X-6.993 Y16.965 F7800
G1 Z0.400 F600
G0 X-6.993 Y16.965 F7800
G1 X-3.753 Y16.965 F300
G0 X-3.753 Y18.198 F7800
G1 X-6.993 Y18.198 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

; --- Overextrusion repair (skim)  conf=0.93 ---
;     bed region: (-29.27,-29.59) -> (-24.98,-25.21)
G1 Z1.400 F600
G0 X-29.270 Y-29.585 F7800
G1 Z0.400 F600
G0 X-29.270 Y-29.585 F7800
G1 X-24.980 Y-29.585 F300
G0 X-24.980 Y-28.352 F7800
G1 X-29.270 Y-28.352 F300
G0 X-29.270 Y-27.119 F7800
G1 X-24.980 Y-27.119 F300
G0 X-24.980 Y-25.886 F7800
G1 X-29.270 Y-25.886 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

G1 Z2.400 F600
; --- Phase 1 complete: layer plane re-established ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
