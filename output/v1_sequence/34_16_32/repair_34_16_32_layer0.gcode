; ============================================================
; ADAPTIVE REPAIR G-CODE
; Layer 0   Z=0.400 mm
; Defects: 6
; ============================================================

G21          ; millimetres
G90          ; absolute positioning
G58          ; work coordinate system
G92 A0

; 
; >>> PHASE 1: OVEREXTRUSION REPAIRS (6)
;     Remove excess material to re-establish layer plane
;     Travel optimised: 95.8 -> 61.7 mm (36% saved)
; 
; --- Overextrusion repair (skim)  conf=0.88 ---
;     bed region: (-6.29,6.76) -> (-4.58,8.95)
G1 Z1.400 F600
G0 X-6.293 Y6.763 F7800
G1 Z0.400 F600
G0 X-6.293 Y6.763 F7800
G1 X-4.575 Y6.763 F300
G0 X-4.575 Y7.996 F7800
G1 X-6.293 Y7.996 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

; --- Overextrusion repair (skim)  conf=0.85 ---
;     bed region: (-4.32,9.06) -> (-2.60,11.39)
G1 Z1.400 F600
G0 X-4.315 Y9.055 F7800
G1 Z0.400 F600
G0 X-4.315 Y9.055 F7800
G1 X-2.598 Y9.055 F300
G0 X-2.598 Y10.288 F7800
G1 X-4.315 Y10.288 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

; --- Overextrusion repair (skim)  conf=0.88 ---
;     bed region: (-6.71,9.77) -> (-4.70,12.31)
G1 Z1.400 F600
G0 X-6.713 Y9.773 F7800
G1 Z0.400 F600
G0 X-6.713 Y9.773 F7800
G1 X-4.698 Y9.773 F300
G0 X-4.698 Y11.006 F7800
G1 X-6.713 Y11.006 F300
G0 X-6.713 Y12.239 F7800
G1 X-4.698 Y12.239 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

; --- Overextrusion repair (skim)  conf=0.85 ---
;     bed region: (-8.92,11.07) -> (-6.87,13.56)
G1 Z1.400 F600
G0 X-8.918 Y11.068 F7800
G1 Z0.400 F600
G0 X-8.918 Y11.068 F7800
G1 X-6.868 Y11.068 F300
G0 X-6.868 Y12.301 F7800
G1 X-8.918 Y12.301 F300
G0 X-8.918 Y13.534 F7800
G1 X-6.868 Y13.534 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

; --- Overextrusion repair (skim)  conf=0.89 ---
;     bed region: (-12.28,3.25) -> (-10.09,5.42)
G1 Z1.400 F600
G0 X-12.278 Y3.245 F7800
G1 Z0.400 F600
G0 X-12.278 Y3.245 F7800
G1 X-10.088 Y3.245 F300
G0 X-10.088 Y4.478 F7800
G1 X-12.278 Y4.478 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

; --- Overextrusion repair (skim)  conf=0.94 ---
;     bed region: (-29.10,-29.57) -> (-24.89,-25.28)
G1 Z1.400 F600
G0 X-29.095 Y-29.568 F7800
G1 Z0.400 F600
G0 X-29.095 Y-29.568 F7800
G1 X-24.893 Y-29.568 F300
G0 X-24.893 Y-28.335 F7800
G1 X-29.095 Y-28.335 F300
G0 X-29.095 Y-27.102 F7800
G1 X-24.893 Y-27.102 F300
G0 X-24.893 Y-25.869 F7800
G1 X-29.095 Y-25.869 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

G1 Z2.400 F600
; --- Phase 1 complete: layer plane re-established ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
