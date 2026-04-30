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
;     Travel optimised: 106.9 -> 75.5 mm (29% saved)
; 
; --- Overextrusion repair (skim)  conf=0.89 ---
;     bed region: (0.64,-6.50) -> (3.02,-4.03)
G1 Z1.400 F600
G0 X0.638 Y-6.503 F7800
G1 Z0.400 F600
G0 X0.638 Y-6.503 F7800
G1 X3.020 Y-6.503 F300
G0 X3.020 Y-5.270 F7800
G1 X0.638 Y-5.270 F300
G0 X0.638 Y-4.037 F7800
G1 X3.020 Y-4.037 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

; --- Overextrusion repair (skim)  conf=0.86 ---
;     bed region: (-0.26,-11.51) -> (3.69,-8.60)
G1 Z1.400 F600
G0 X-0.255 Y-11.508 F7800
G1 Z0.400 F600
G0 X-0.255 Y-11.508 F7800
G1 X3.685 Y-11.508 F300
G0 X3.685 Y-10.274 F7800
G1 X-0.255 Y-10.274 F300
G0 X-0.255 Y-9.041 F7800
G1 X3.685 Y-9.041 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

; --- Overextrusion repair (skim)  conf=0.90 ---
;     bed region: (6.89,2.74) -> (9.18,4.60)
G1 Z1.400 F600
G0 X6.885 Y2.738 F7800
G1 Z0.400 F600
G0 X6.885 Y2.738 F7800
G1 X9.180 Y2.738 F300
G0 X9.180 Y3.971 F7800
G1 X6.885 Y3.971 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

; --- Overextrusion repair (skim)  conf=0.89 ---
;     bed region: (1.39,4.14) -> (4.51,6.42)
G1 Z1.400 F600
G0 X1.390 Y4.138 F7800
G1 Z0.400 F600
G0 X1.390 Y4.138 F7800
G1 X4.508 Y4.138 F300
G0 X4.508 Y5.370 F7800
G1 X1.390 Y5.370 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

; --- Overextrusion repair (skim)  conf=0.94 ---
;     bed region: (-29.64,-29.95) -> (-25.03,-25.38)
G1 Z1.400 F600
G0 X-29.638 Y-29.953 F7800
G1 Z0.400 F600
G0 X-29.638 Y-29.953 F7800
G1 X-25.033 Y-29.953 F300
G0 X-25.033 Y-28.720 F7800
G1 X-29.638 Y-28.720 F300
G0 X-29.638 Y-27.487 F7800
G1 X-25.033 Y-27.487 F300
G0 X-25.033 Y-26.254 F7800
G1 X-29.638 Y-26.254 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

G1 Z2.400 F600
; --- Phase 1 complete: layer plane re-established ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
