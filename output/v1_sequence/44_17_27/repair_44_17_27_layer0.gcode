; ============================================================
; ADAPTIVE REPAIR G-CODE
; Layer 0   Z=0.400 mm
; Defects: 16
; ============================================================

G21          ; millimetres
G90          ; absolute positioning
G58          ; work coordinate system
G92 A0

; 
; >>> PHASE 1: OVEREXTRUSION REPAIRS (1)
;     Remove excess material to re-establish layer plane
;     Travel optimised: 38.7 -> 38.7 mm (0% saved)
; 
; --- Overextrusion repair (skim)  conf=0.94 ---
;     bed region: (-29.11,-29.45) -> (-25.30,-25.63)
G1 Z1.400 F600
G0 X-29.113 Y-29.445 F7800
G1 Z0.400 F600
G0 X-29.113 Y-29.445 F7800
G1 X-25.295 Y-29.445 F300
G0 X-25.295 Y-28.212 F7800
G1 X-29.113 Y-28.212 F300
G0 X-29.113 Y-26.979 F7800
G1 X-25.295 Y-26.979 F300
G0 X-25.295 Y-25.746 F7800
G1 X-29.113 Y-25.746 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

G1 Z2.400 F600
; --- Phase 1 complete: layer plane re-established ---

; 
; >>> PHASE 2: UNDEREXTRUSION REPAIRS (15)
;     Re-deposit material into voids on levelled surface
;     Travel optimised: 242.4 -> 67.5 mm (72% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.85 ---
;     bed region: (-15.97,-17.69) -> (-14.11,-16.23)
G1 A0.00000 F60
G1 Z1.400 F600
G0 X-15.970 Y-17.685 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G0 X-15.970 Y-17.685 F7800
G1 X-14.113 Y-17.685 A0.00079 F300
G0 X-14.113 Y-16.452 F7800
G1 X-15.970 Y-16.452 A0.00158 F300
G1 A0.00158 F60
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.88 ---
;     bed region: (-17.53,-16.06) -> (-15.50,-13.73)
G1 A0.00158 F60
G1 Z1.400 F600
G0 X-17.527 Y-16.058 F7800
G1 Z0.400 F600
G1 A0.00158 F60
G0 X-17.527 Y-16.058 F7800
G1 X-15.495 Y-16.058 A0.00244 F300
G0 X-15.495 Y-14.825 F7800
G1 X-17.527 Y-14.825 A0.00331 F300
G1 A0.00331 F60
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.88 ---
;     bed region: (-12.98,-17.70) -> (-10.68,-16.04)
G1 A0.00331 F60
G1 Z1.400 F600
G0 X-12.978 Y-17.703 F7800
G1 Z0.400 F600
G1 A0.00331 F60
G0 X-12.978 Y-17.703 F7800
G1 X-10.683 Y-17.703 A0.00429 F300
G0 X-10.683 Y-16.470 F7800
G1 X-12.978 Y-16.470 A0.00526 F300
G1 A0.00526 F60
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.87 ---
;     bed region: (-9.62,-17.76) -> (-7.36,-16.11)
G1 A0.00526 F60
G1 Z1.400 F600
G0 X-9.618 Y-17.755 F7800
G1 Z0.400 F600
G1 A0.00526 F60
G0 X-9.618 Y-17.755 F7800
G1 X-7.358 Y-17.755 A0.00622 F300
G0 X-7.358 Y-16.522 F7800
G1 X-9.618 Y-16.522 A0.00718 F300
G1 A0.00718 F60
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.87 ---
;     bed region: (-13.57,-9.02) -> (-10.47,-5.85)
G1 A0.00718 F60
G1 Z1.400 F600
G0 X-13.573 Y-9.023 F7800
G1 Z0.400 F600
G1 A0.00718 F60
G0 X-13.573 Y-9.023 F7800
G1 X-10.473 Y-9.023 A0.00850 F300
G0 X-10.473 Y-7.790 F7800
G1 X-13.573 Y-7.790 A0.00982 F300
G0 X-13.573 Y-6.556 F7800
G1 X-10.473 Y-6.556 A0.01114 F300
G1 A0.01114 F60
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.94 ---
;     bed region: (-13.82,-7.40) -> (-7.50,-1.25)
G1 A0.01114 F60
G1 Z1.400 F600
G0 X-13.818 Y-7.395 F7800
G1 Z0.400 F600
G1 A0.01114 F60
G0 X-13.818 Y-7.395 F7800
G1 X-7.498 Y-7.395 A0.01383 F300
G0 X-7.498 Y-6.162 F7800
G1 X-13.818 Y-6.162 A0.01652 F300
G0 X-13.818 Y-4.929 F7800
G1 X-7.498 Y-4.929 A0.01921 F300
G0 X-7.498 Y-3.696 F7800
G1 X-13.818 Y-3.696 A0.02189 F300
G0 X-13.818 Y-2.463 F7800
G1 X-7.498 Y-2.463 A0.02458 F300
G1 A0.02458 F60
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.93 ---
;     bed region: (-8.41,-2.09) -> (-4.80,1.53)
G1 A0.02458 F60
G1 Z1.400 F600
G0 X-8.410 Y-2.093 F7800
G1 Z0.400 F600
G1 A0.02458 F60
G0 X-8.410 Y-2.093 F7800
G1 X-4.803 Y-2.093 A0.02612 F300
G0 X-4.803 Y-0.860 F7800
G1 X-8.410 Y-0.860 A0.02765 F300
G0 X-8.410 Y0.373 F7800
G1 X-4.803 Y0.373 A0.02919 F300
G1 A0.02919 F60
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.89 ---
;     bed region: (-5.75,0.59) -> (-3.58,2.69)
G1 A0.02919 F60
G1 Z1.400 F600
G0 X-5.750 Y0.585 F7800
G1 Z0.400 F600
G1 A0.02919 F60
G0 X-5.750 Y0.585 F7800
G1 X-3.578 Y0.585 A0.03011 F300
G0 X-3.578 Y1.818 F7800
G1 X-5.750 Y1.818 A0.03103 F300
G1 A0.03103 F60
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.93 ---
;     bed region: (-4.28,0.41) -> (-0.52,4.11)
G1 A0.03103 F60
G1 Z1.400 F600
G0 X-4.280 Y0.410 F7800
G1 Z0.400 F600
G1 A0.03103 F60
G0 X-4.280 Y0.410 F7800
G1 X-0.515 Y0.410 A0.03264 F300
G0 X-0.515 Y1.643 F7800
G1 X-4.280 Y1.643 A0.03424 F300
G0 X-4.280 Y2.876 F7800
G1 X-0.515 Y2.876 A0.03584 F300
G1 A0.03584 F60
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.88 ---
;     bed region: (-3.60,2.81) -> (-0.90,5.38)
G1 A0.03584 F60
G1 Z1.400 F600
G0 X-3.598 Y2.808 F7800
G1 Z0.400 F600
G1 A0.03584 F60
G0 X-3.598 Y2.808 F7800
G1 X-0.900 Y2.808 A0.03699 F300
G0 X-0.900 Y4.040 F7800
G1 X-3.598 Y4.040 A0.03813 F300
G0 X-3.598 Y5.274 F7800
G1 X-0.900 Y5.274 A0.03928 F300
G1 A0.03928 F60
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.92 ---
;     bed region: (-0.78,3.88) -> (2.93,7.61)
G1 A0.03928 F60
G1 Z1.400 F600
G0 X-0.780 Y3.875 F7800
G1 Z0.400 F600
G1 A0.03928 F60
G0 X-0.780 Y3.875 F7800
G1 X2.933 Y3.875 A0.04086 F300
G0 X2.933 Y5.108 F7800
G1 X-0.780 Y5.108 A0.04244 F300
G0 X-0.780 Y6.341 F7800
G1 X2.933 Y6.341 A0.04402 F300
G0 X2.933 Y7.574 F7800
G1 X-0.780 Y7.574 A0.04560 F300
G1 A0.04560 F60
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.88 ---
;     bed region: (2.48,8.81) -> (4.40,10.77)
G1 A0.04560 F60
G1 Z1.400 F600
G0 X2.475 Y8.810 F7800
G1 Z0.400 F600
G1 A0.04560 F60
G0 X2.475 Y8.810 F7800
G1 X4.402 Y8.810 A0.04642 F300
G0 X4.402 Y10.043 F7800
G1 X2.475 Y10.043 A0.04724 F300
G1 A0.04724 F60
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.92 ---
;     bed region: (3.30,7.99) -> (6.08,10.69)
G1 A0.04724 F60
G1 Z1.400 F600
G0 X3.298 Y7.988 F7800
G1 Z0.400 F600
G1 A0.04724 F60
G0 X3.298 Y7.988 F7800
G1 X6.083 Y7.988 A0.04842 F300
G0 X6.083 Y9.221 F7800
G1 X3.298 Y9.221 A0.04961 F300
G0 X3.298 Y10.454 F7800
G1 X6.083 Y10.454 A0.05079 F300
G1 A0.05079 F60
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.87 ---
;     bed region: (5.49,8.64) -> (7.57,10.63)
G1 A0.05079 F60
G1 Z1.400 F600
G0 X5.485 Y8.635 F7800
G1 Z0.400 F600
G1 A0.05079 F60
G0 X5.485 Y8.635 F7800
G1 X7.570 Y8.635 A0.05168 F300
G0 X7.570 Y9.868 F7800
G1 X5.485 Y9.868 A0.05257 F300
G1 A0.05257 F60
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.86 ---
;     bed region: (6.94,10.04) -> (9.88,12.98)
G1 A0.05257 F60
G1 Z1.400 F600
G0 X6.938 Y10.035 F7800
G1 Z0.400 F600
G1 A0.05257 F60
G0 X6.938 Y10.035 F7800
G1 X9.880 Y10.035 A0.05382 F300
G0 X9.880 Y11.268 F7800
G1 X6.938 Y11.268 A0.05507 F300
G0 X6.938 Y12.501 F7800
G1 X9.880 Y12.501 A0.05632 F300
G1 A0.05632 F60
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
