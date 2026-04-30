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
;     Travel optimised: 24.9 -> 24.9 mm (0% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.96 ---
;     bed region: (-12.94,-5.45) -> (-1.55,5.79)
G1 A0.00000 F60
G1 Z1.400 F600
G0 X-12.943 Y-5.453 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G0 X-12.943 Y-5.453 F7800
G1 X-1.548 Y-5.453 A0.00485 F300
G0 X-1.548 Y-4.220 F7800
G1 X-12.943 Y-4.220 A0.00969 F300
G0 X-12.943 Y-2.986 F7800
G1 X-1.548 Y-2.986 A0.01454 F300
G0 X-1.548 Y-1.753 F7800
G1 X-12.943 Y-1.753 A0.01939 F300
G0 X-12.943 Y-0.520 F7800
G1 X-1.548 Y-0.520 A0.02424 F300
G0 X-1.548 Y0.713 F7800
G1 X-12.943 Y0.713 A0.02908 F300
G0 X-12.943 Y1.946 F7800
G1 X-1.548 Y1.946 A0.03393 F300
G0 X-1.548 Y3.179 F7800
G1 X-12.943 Y3.179 A0.03878 F300
G0 X-12.943 Y4.412 F7800
G1 X-1.548 Y4.412 A0.04363 F300
G0 X-1.548 Y5.645 F7800
G1 X-12.943 Y5.645 A0.04847 F300
G1 A0.04847 F60
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.91 ---
;     bed region: (-15.20,-9.44) -> (-9.97,-4.28)
G1 A0.04847 F60
G1 Z1.400 F600
G0 X-15.200 Y-9.443 F7800
G1 Z0.400 F600
G1 A0.04847 F60
G0 X-15.200 Y-9.443 F7800
G1 X-9.965 Y-9.443 A0.05070 F300
G0 X-9.965 Y-8.210 F7800
G1 X-15.200 Y-8.210 A0.05293 F300
G0 X-15.200 Y-6.976 F7800
G1 X-9.965 Y-6.976 A0.05515 F300
G0 X-9.965 Y-5.743 F7800
G1 X-15.200 Y-5.743 A0.05738 F300
G0 X-15.200 Y-4.510 F7800
G1 X-9.965 Y-4.510 A0.05961 F300
G1 A0.05961 F60
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.86 ---
;     bed region: (-15.25,-6.12) -> (-13.47,-4.19)
G1 A0.05961 F60
G1 Z1.400 F600
G0 X-15.253 Y-6.118 F7800
G1 Z0.400 F600
G1 A0.05961 F60
G0 X-15.253 Y-6.118 F7800
G1 X-13.465 Y-6.118 A0.06037 F300
G0 X-13.465 Y-4.885 F7800
G1 X-15.253 Y-4.885 A0.06113 F300
G1 A0.06113 F60
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.85 ---
;     bed region: (-15.15,-12.56) -> (-13.27,-10.53)
G1 A0.06113 F60
G1 Z1.400 F600
G0 X-15.148 Y-12.558 F7800
G1 Z0.400 F600
G1 A0.06113 F60
G0 X-15.148 Y-12.558 F7800
G1 X-13.273 Y-12.558 A0.06193 F300
G0 X-13.273 Y-11.325 F7800
G1 X-15.148 Y-11.325 A0.06272 F300
G1 A0.06272 F60
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
