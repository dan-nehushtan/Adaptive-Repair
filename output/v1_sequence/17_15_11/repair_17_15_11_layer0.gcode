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
;     Travel optimised: 26.2 -> 18.3 mm (30% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.93 ---
;     bed region: (0.64,-3.74) -> (6.26,1.76)
G1 A0.00000 F60
G1 Z1.400 F600
G0 X0.638 Y-3.738 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G0 X0.638 Y-3.738 F7800
G1 X6.258 Y-3.738 A0.00239 F300
G0 X6.258 Y-2.505 F7800
G1 X0.638 Y-2.505 A0.00478 F300
G0 X0.638 Y-1.272 F7800
G1 X6.258 Y-1.272 A0.00717 F300
G0 X6.258 Y-0.038 F7800
G1 X0.638 Y-0.038 A0.00956 F300
G0 X0.638 Y1.195 F7800
G1 X6.258 Y1.195 A0.01195 F300
G1 A0.01195 F60
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.93 ---
;     bed region: (2.39,-5.14) -> (8.50,0.87)
G1 A0.01195 F60
G1 Z1.400 F600
G0 X2.388 Y-5.138 F7800
G1 Z0.400 F600
G1 A0.01195 F60
G0 X2.388 Y-5.138 F7800
G1 X8.498 Y-5.138 A0.01455 F300
G0 X8.498 Y-3.905 F7800
G1 X2.388 Y-3.905 A0.01715 F300
G0 X2.388 Y-2.671 F7800
G1 X8.498 Y-2.671 A0.01975 F300
G0 X8.498 Y-1.438 F7800
G1 X2.388 Y-1.438 A0.02235 F300
G0 X2.388 Y-0.205 F7800
G1 X8.498 Y-0.205 A0.02495 F300
G1 A0.02495 F60
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.87 ---
;     bed region: (1.97,-7.48) -> (5.49,-4.03)
G1 A0.02495 F60
G1 Z1.400 F600
G0 X1.968 Y-7.483 F7800
G1 Z0.400 F600
G1 A0.02495 F60
G0 X1.968 Y-7.483 F7800
G1 X5.488 Y-7.483 A0.02645 F300
G0 X5.488 Y-6.250 F7800
G1 X1.968 Y-6.250 A0.02794 F300
G0 X1.968 Y-5.017 F7800
G1 X5.488 Y-5.017 A0.02944 F300
G1 A0.02944 F60
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.88 ---
;     bed region: (-5.05,-11.37) -> (-2.09,-8.53)
G1 A0.02944 F60
G1 Z1.400 F600
G0 X-5.050 Y-11.368 F7800
G1 Z0.400 F600
G1 A0.02944 F60
G0 X-5.050 Y-11.368 F7800
G1 X-2.090 Y-11.368 A0.03070 F300
G0 X-2.090 Y-10.135 F7800
G1 X-5.050 Y-10.135 A0.03196 F300
G0 X-5.050 Y-8.902 F7800
G1 X-2.090 Y-8.902 A0.03322 F300
G1 A0.03322 F60
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
