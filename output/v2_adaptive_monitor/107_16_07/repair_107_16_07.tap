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
; >>> PICKING UP MILLING TOOL
; --- TOOL CHANGE: milling tool ---
G1 Z50.000 F600
G0 X0.000 Y0.000 F7800
M6 T1  ; pick up milling tool
; Tool T1 loaded
M3 S1000  ; spindle on

; 
; >>> PHASE 1: MILL ALL BOUNDING BOXES (4)
;     Overextrusion  : 1 regions (skim excess)
;     Underextrusion : 3 regions (cut clean cavity)
;     Travel optimised: 100.4 -> 44.0 mm (56% saved)
; 
; --- Mill cavity: Underextrusion  conf=0.94 ---
;     bed region: (-5.50,-2.11) -> (2.38,5.73)
G1 Z2.400 F600
G0 X-5.497 Y-2.107 F7800
G1 Z0.400 F600
G1 X2.381 Y-2.107 F200
G1 X2.381 Y-0.874 F200
G1 X-5.497 Y-0.874 F200
G1 X-5.497 Y0.359 F200
G1 X2.381 Y0.359 F200
G1 X2.381 Y1.592 F200
G1 X-5.497 Y1.592 F200
G1 X-5.497 Y2.825 F200
G1 X2.381 Y2.825 F200
G1 X2.381 Y4.058 F200
G1 X-5.497 Y4.058 F200
G1 X-5.497 Y5.291 F200
G1 X2.381 Y5.291 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.92 ---
;     bed region: (-9.92,-1.35) -> (-5.60,2.96)
G1 Z2.400 F600
G0 X-9.918 Y-1.347 F7800
G1 Z0.400 F600
G1 X-5.602 Y-1.347 F200
G1 X-5.602 Y-0.114 F200
G1 X-9.918 Y-0.114 F200
G1 X-9.918 Y1.119 F200
G1 X-5.602 Y1.119 F200
G1 X-5.602 Y2.352 F200
G1 X-9.918 Y2.352 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.92 ---
;     bed region: (-12.13,-10.35) -> (-7.85,-6.17)
G1 Z2.400 F600
G0 X-12.135 Y-10.349 F7800
G1 Z0.400 F600
G1 X-7.849 Y-10.349 F200
G1 X-7.849 Y-9.116 F200
G1 X-12.135 Y-9.116 F200
G1 X-12.135 Y-7.883 F200
G1 X-7.849 Y-7.883 F200
G1 X-7.849 Y-6.650 F200
G1 X-12.135 Y-6.650 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill skim: Overextrusion  conf=0.90 ---
;     bed region: (-29.11,-29.30) -> (-25.64,-25.80)
G1 Z2.400 F600
G0 X-29.106 Y-29.296 F7800
G1 Z0.400 F600
G1 X-25.644 Y-29.296 F200
G1 X-25.644 Y-28.063 F200
G1 X-29.106 Y-28.063 F200
G1 X-29.106 Y-26.830 F200
G1 X-25.644 Y-26.830 F200
G1 Z2.400 F600
; --- end mill skim ---

G1 Z2.400 F600
M5  ; spindle off after milling
; --- Phase 1 complete: all regions milled ---

; >>> RETURNING MILL, PICKING UP NOZZLE FOR DEPOSITION
M5  ; spindle off
; --- TOOL CHANGE: ceramic nozzle ---
G1 Z50.000 F600
G0 X0.000 Y0.000 F7800
M6 T0  ; pick up ceramic nozzle
; Tool T0 loaded
G92 A0

; 
; >>> PHASE 2: DEPOSIT INTO UNDEREXTRUSION CAVITIES (3)
;     Fill milled cavities with ceramic
;     Travel optimised: 61.6 -> 41.6 mm (32% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.92 ---
;     bed region: (-12.13,-10.35) -> (-7.85,-6.17)
G1 A0.00000 F60
G1 Z2.400 F600
G0 X-12.135 Y-10.349 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G1 X-7.849 Y-10.349 A0.00182 F300
G1 X-7.849 Y-9.116 F7800
G1 X-12.135 Y-9.116 A0.00365 F300
G1 X-12.135 Y-7.883 F7800
G1 X-7.849 Y-7.883 A0.00547 F300
G1 X-7.849 Y-6.650 F7800
G1 X-12.135 Y-6.650 A0.00729 F300
G1 A0.00729 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.92 ---
;     bed region: (-9.92,-1.35) -> (-5.60,2.96)
G1 A0.00729 F60
G1 Z2.400 F600
G0 X-9.918 Y-1.347 F7800
G1 Z0.400 F600
G1 A0.00729 F60
G1 X-5.602 Y-1.347 A0.00913 F300
G1 X-5.602 Y-0.114 F7800
G1 X-9.918 Y-0.114 A0.01096 F300
G1 X-9.918 Y1.119 F7800
G1 X-5.602 Y1.119 A0.01280 F300
G1 X-5.602 Y2.352 F7800
G1 X-9.918 Y2.352 A0.01464 F300
G1 A0.01464 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.94 ---
;     bed region: (-5.50,-2.11) -> (2.38,5.73)
G1 A0.01464 F60
G1 Z2.400 F600
G0 X-5.497 Y-2.107 F7800
G1 Z0.400 F600
G1 A0.01464 F60
G1 X2.381 Y-2.107 A0.01799 F300
G1 X2.381 Y-0.874 F7800
G1 X-5.497 Y-0.874 A0.02134 F300
G1 X-5.497 Y0.359 F7800
G1 X2.381 Y0.359 A0.02469 F300
G1 X2.381 Y1.592 F7800
G1 X-5.497 Y1.592 A0.02804 F300
G1 X-5.497 Y2.825 F7800
G1 X2.381 Y2.825 A0.03139 F300
G1 X2.381 Y4.058 F7800
G1 X-5.497 Y4.058 A0.03474 F300
G1 X-5.497 Y5.291 F7800
G1 X2.381 Y5.291 A0.03809 F300
G1 A0.03809 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
