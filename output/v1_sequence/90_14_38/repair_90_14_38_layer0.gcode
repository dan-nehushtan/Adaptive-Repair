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
; >>> PHASE 2: UNDEREXTRUSION REPAIRS (4)
;     Re-deposit material into voids on levelled surface
;     Travel optimised: 61.2 -> 56.4 mm (8% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.94 ---
;     bed region: (3.49,-6.38) -> (11.47,1.80)
G1 A0.00000 F60
G1 Z1.400 F600
G0 X3.490 Y-6.380 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G0 X3.490 Y-6.380 F7800
G1 X11.473 Y-6.380 A0.00340 F300
G0 X11.473 Y-5.147 F7800
G1 X3.490 Y-5.147 A0.00679 F300
G0 X3.490 Y-3.914 F7800
G1 X11.473 Y-3.914 A0.01019 F300
G0 X11.473 Y-2.681 F7800
G1 X3.490 Y-2.681 A0.01358 F300
G0 X3.490 Y-1.448 F7800
G1 X11.473 Y-1.448 A0.01698 F300
G0 X11.473 Y-0.215 F7800
G1 X3.490 Y-0.215 A0.02037 F300
G0 X3.490 Y1.018 F7800
G1 X11.473 Y1.018 A0.02377 F300
G1 A0.02377 F60
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.95 ---
;     bed region: (-5.84,-14.06) -> (2.16,-6.01)
G1 A0.02377 F60
G1 Z1.400 F600
G0 X-5.838 Y-14.063 F7800
G1 Z0.400 F600
G1 A0.02377 F60
G0 X-5.838 Y-14.063 F7800
G1 X2.163 Y-14.063 A0.02717 F300
G0 X2.163 Y-12.830 F7800
G1 X-5.838 Y-12.830 A0.03058 F300
G0 X-5.838 Y-11.597 F7800
G1 X2.163 Y-11.597 A0.03398 F300
G0 X2.163 Y-10.364 F7800
G1 X-5.838 Y-10.364 A0.03738 F300
G0 X-5.838 Y-9.130 F7800
G1 X2.163 Y-9.130 A0.04078 F300
G0 X2.163 Y-7.897 F7800
G1 X-5.838 Y-7.897 A0.04419 F300
G0 X-5.838 Y-6.664 F7800
G1 X2.163 Y-6.664 A0.04759 F300
G1 A0.04759 F60
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.86 ---
;     bed region: (-17.56,2.93) -> (-15.92,4.79)
G1 A0.04759 F60
G1 Z1.400 F600
G0 X-17.562 Y2.930 F7800
G1 Z0.400 F600
G1 A0.04759 F60
G0 X-17.562 Y2.930 F7800
G1 X-15.915 Y2.930 A0.04829 F300
G0 X-15.915 Y4.163 F7800
G1 X-17.562 Y4.163 A0.04899 F300
G1 A0.04899 F60
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.88 ---
;     bed region: (-7.33,15.02) -> (-5.19,16.97)
G1 A0.04899 F60
G1 Z1.400 F600
G0 X-7.325 Y15.023 F7800
G1 Z0.400 F600
G1 A0.04899 F60
G0 X-7.325 Y15.023 F7800
G1 X-5.188 Y15.023 A0.04990 F300
G0 X-5.188 Y16.256 F7800
G1 X-7.325 Y16.256 A0.05081 F300
G1 A0.05081 F60
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
