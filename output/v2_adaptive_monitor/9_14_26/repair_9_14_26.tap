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
;     Travel optimised: 80.8 -> 50.0 mm (38% saved)
; 
; --- Mill cavity: Underextrusion  conf=0.85 ---
;     bed region: (5.13,-5.83) -> (7.06,-3.55)
G1 Z2.400 F600
G0 X5.127 Y-5.827 F7800
G1 Z0.400 F600
G1 X7.063 Y-5.827 F200
G1 X7.063 Y-4.594 F200
G1 X5.127 Y-4.594 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.86 ---
;     bed region: (-5.96,-12.44) -> (-3.24,-9.77)
G1 Z2.400 F600
G0 X-5.957 Y-12.439 F7800
G1 Z0.400 F600
G1 X-3.238 Y-12.439 F200
G1 X-3.238 Y-11.206 F200
G1 X-5.957 Y-11.206 F200
G1 X-5.957 Y-9.973 F200
G1 X-3.238 Y-9.973 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.87 ---
;     bed region: (-8.11,-10.57) -> (-6.01,-8.41)
G1 Z2.400 F600
G0 X-8.110 Y-10.570 F7800
G1 Z0.400 F600
G1 X-6.011 Y-10.570 F200
G1 X-6.011 Y-9.337 F200
G1 X-8.110 Y-9.337 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill skim: Overextrusion  conf=0.90 ---
;     bed region: (-28.89,-29.36) -> (-25.13,-25.61)
G1 Z2.400 F600
G0 X-28.889 Y-29.365 F7800
G1 Z0.400 F600
G1 X-25.130 Y-29.365 F200
G1 X-25.130 Y-28.132 F200
G1 X-28.889 Y-28.132 F200
G1 X-28.889 Y-26.899 F200
G1 X-25.130 Y-26.899 F200
G1 X-25.130 Y-25.666 F200
G1 X-28.889 Y-25.666 F200
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
;     Travel optimised: 42.3 -> 42.3 mm (0% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.87 ---
;     bed region: (-8.11,-10.57) -> (-6.01,-8.41)
G1 A0.00000 F60
G1 Z2.400 F600
G0 X-8.110 Y-10.570 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G1 X-6.011 Y-10.570 A0.00089 F300
G1 X-6.011 Y-9.337 F7800
G1 X-8.110 Y-9.337 A0.00179 F300
G1 A0.00179 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.86 ---
;     bed region: (-5.96,-12.44) -> (-3.24,-9.77)
G1 A0.00179 F60
G1 Z2.400 F600
G0 X-5.957 Y-12.439 F7800
G1 Z0.400 F600
G1 A0.00179 F60
G1 X-3.238 Y-12.439 A0.00294 F300
G1 X-3.238 Y-11.206 F7800
G1 X-5.957 Y-11.206 A0.00410 F300
G1 X-5.957 Y-9.973 F7800
G1 X-3.238 Y-9.973 A0.00526 F300
G1 A0.00526 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.85 ---
;     bed region: (5.13,-5.83) -> (7.06,-3.55)
G1 A0.00526 F60
G1 Z2.400 F600
G0 X5.127 Y-5.827 F7800
G1 Z0.400 F600
G1 A0.00526 F60
G1 X7.063 Y-5.827 A0.00608 F300
G1 X7.063 Y-4.594 F7800
G1 X5.127 Y-4.594 A0.00690 F300
G1 A0.00690 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
