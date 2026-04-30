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
; >>> PHASE 1: OVEREXTRUSION REPAIRS (1)
;     Remove excess material to re-establish layer plane
;     Travel optimised: 38.9 -> 38.9 mm (0% saved)
; 
; --- Overextrusion repair (skim)  conf=0.94 ---
;     bed region: (-29.29,-29.46) -> (-25.56,-25.73)
G1 Z1.400 F600
G0 X-29.288 Y-29.463 F7800
G1 Z0.400 F600
G0 X-29.288 Y-29.463 F7800
G1 X-25.558 Y-29.463 F300
G0 X-25.558 Y-28.230 F7800
G1 X-29.288 Y-28.230 F300
G0 X-29.288 Y-26.997 F7800
G1 X-25.558 Y-26.997 F300
G0 X-25.558 Y-25.764 F7800
G1 X-29.288 Y-25.764 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

G1 Z2.400 F600
; --- Phase 1 complete: layer plane re-established ---

; 
; >>> PHASE 2: UNDEREXTRUSION REPAIRS (3)
;     Re-deposit material into voids on levelled surface
;     Travel optimised: 54.7 -> 41.7 mm (24% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.92 ---
;     bed region: (-11.96,-10.28) -> (-7.85,-6.13)
G1 A0.00000 F60
G1 Z1.400 F600
G0 X-11.963 Y-10.283 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G0 X-11.963 Y-10.283 F7800
G1 X-7.848 Y-10.283 A0.00175 F300
G0 X-7.848 Y-9.050 F7800
G1 X-11.963 Y-9.050 A0.00350 F300
G0 X-11.963 Y-7.816 F7800
G1 X-7.848 Y-7.816 A0.00525 F300
G0 X-7.848 Y-6.583 F7800
G1 X-11.963 Y-6.583 A0.00700 F300
G1 A0.00700 F60
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.93 ---
;     bed region: (-9.90,-1.31) -> (-5.71,2.93)
G1 A0.00700 F60
G1 Z1.400 F600
G0 X-9.898 Y-1.305 F7800
G1 Z0.400 F600
G1 A0.00700 F60
G0 X-9.898 Y-1.305 F7800
G1 X-5.713 Y-1.305 A0.00878 F300
G0 X-5.713 Y-0.072 F7800
G1 X-9.898 Y-0.072 A0.01056 F300
G0 X-9.898 Y1.161 F7800
G1 X-5.713 Y1.161 A0.01234 F300
G0 X-5.713 Y2.394 F7800
G1 X-9.898 Y2.394 A0.01412 F300
G1 A0.01412 F60
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.94 ---
;     bed region: (-5.49,-2.00) -> (2.43,5.52)
G1 A0.01412 F60
G1 Z1.400 F600
G0 X-5.488 Y-2.005 F7800
G1 Z0.400 F600
G1 A0.01412 F60
G0 X-5.488 Y-2.005 F7800
G1 X2.425 Y-2.005 A0.01749 F300
G0 X2.425 Y-0.772 F7800
G1 X-5.488 Y-0.772 A0.02085 F300
G0 X-5.488 Y0.461 F7800
G1 X2.425 Y0.461 A0.02422 F300
G0 X2.425 Y1.694 F7800
G1 X-5.488 Y1.694 A0.02759 F300
G0 X-5.488 Y2.927 F7800
G1 X2.425 Y2.927 A0.03095 F300
G0 X2.425 Y4.160 F7800
G1 X-5.488 Y4.160 A0.03432 F300
G0 X-5.488 Y5.393 F7800
G1 X2.425 Y5.393 A0.03768 F300
G1 A0.03768 F60
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
