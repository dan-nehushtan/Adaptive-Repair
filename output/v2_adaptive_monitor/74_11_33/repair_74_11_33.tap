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
; >>> PICKING UP MILLING TOOL
; --- TOOL CHANGE: milling tool ---
G1 Z50.000 F600
G0 X0.000 Y0.000 F7800
M6 T1  ; pick up milling tool
; Tool T1 loaded
M3 S1000  ; spindle on

; 
; >>> PHASE 1: MILL ALL BOUNDING BOXES (6)
;     Overextrusion  : 1 regions (skim excess)
;     Underextrusion : 5 regions (cut clean cavity)
;     Travel optimised: 95.0 -> 55.7 mm (41% saved)
; 
; --- Mill cavity: Underextrusion  conf=0.90 ---
;     bed region: (-5.52,2.35) -> (-2.18,5.64)
G1 Z2.400 F600
G0 X-5.518 Y2.352 F7800
G1 Z0.400 F600
G1 X-2.177 Y2.352 F200
G1 X-2.177 Y3.585 F200
G1 X-5.518 Y3.585 F200
G1 X-5.518 Y4.818 F200
G1 X-2.177 Y4.818 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.92 ---
;     bed region: (-7.69,3.42) -> (-3.36,7.73)
G1 Z2.400 F600
G0 X-7.686 Y3.419 F7800
G1 Z0.400 F600
G1 X-3.362 Y3.419 F200
G1 X-3.362 Y4.652 F200
G1 X-7.686 Y4.652 F200
G1 X-7.686 Y5.885 F200
G1 X-3.362 Y5.885 F200
G1 X-3.362 Y7.118 F200
G1 X-7.686 Y7.118 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.94 ---
;     bed region: (-13.83,0.58) -> (-5.51,8.91)
G1 Z2.400 F600
G0 X-13.833 Y0.578 F7800
G1 Z0.400 F600
G1 X-5.507 Y0.578 F200
G1 X-5.507 Y1.811 F200
G1 X-13.833 Y1.811 F200
G1 X-13.833 Y3.044 F200
G1 X-5.507 Y3.044 F200
G1 X-5.507 Y4.277 F200
G1 X-13.833 Y4.277 F200
G1 X-13.833 Y5.510 F200
G1 X-5.507 Y5.510 F200
G1 X-5.507 Y6.743 F200
G1 X-13.833 Y6.743 F200
G1 X-13.833 Y7.976 F200
G1 X-5.507 Y7.976 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.92 ---
;     bed region: (-13.43,4.14) -> (-8.01,9.66)
G1 Z2.400 F600
G0 X-13.434 Y4.145 F7800
G1 Z0.400 F600
G1 X-8.013 Y4.145 F200
G1 X-8.013 Y5.378 F200
G1 X-13.434 Y5.378 F200
G1 X-13.434 Y6.611 F200
G1 X-8.013 Y6.611 F200
G1 X-8.013 Y7.844 F200
G1 X-13.434 Y7.844 F200
G1 X-13.434 Y9.077 F200
G1 X-8.013 Y9.077 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.92 ---
;     bed region: (-9.42,-0.14) -> (-5.63,3.81)
G1 Z2.400 F600
G0 X-9.420 Y-0.140 F7800
G1 Z0.400 F600
G1 X-5.633 Y-0.140 F200
G1 X-5.633 Y1.093 F200
G1 X-9.420 Y1.093 F200
G1 X-9.420 Y2.326 F200
G1 X-5.633 Y2.326 F200
G1 X-5.633 Y3.559 F200
G1 X-9.420 Y3.559 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill skim: Overextrusion  conf=0.90 ---
;     bed region: (-28.89,-28.88) -> (-25.73,-25.70)
G1 Z2.400 F600
G0 X-28.893 Y-28.877 F7800
G1 Z0.400 F600
G1 X-25.731 Y-28.877 F200
G1 X-25.731 Y-27.644 F200
G1 X-28.893 Y-27.644 F200
G1 X-28.893 Y-26.411 F200
G1 X-25.731 Y-26.411 F200
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
; >>> PHASE 2: DEPOSIT INTO UNDEREXTRUSION CAVITIES (5)
;     Fill milled cavities with ceramic
;     Travel optimised: 56.4 -> 48.9 mm (13% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.92 ---
;     bed region: (-9.42,-0.14) -> (-5.63,3.81)
G1 A0.00000 F60
G1 Z2.400 F600
G0 X-9.420 Y-0.140 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G1 X-5.633 Y-0.140 A0.00161 F300
G1 X-5.633 Y1.093 F7800
G1 X-9.420 Y1.093 A0.00322 F300
G1 X-9.420 Y2.326 F7800
G1 X-5.633 Y2.326 A0.00483 F300
G1 X-5.633 Y3.559 F7800
G1 X-9.420 Y3.559 A0.00644 F300
G1 A0.00644 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.94 ---
;     bed region: (-13.83,0.58) -> (-5.51,8.91)
G1 A0.00644 F60
G1 Z2.400 F600
G0 X-13.833 Y0.578 F7800
G1 Z0.400 F600
G1 A0.00644 F60
G1 X-5.507 Y0.578 A0.00999 F300
G1 X-5.507 Y1.811 F7800
G1 X-13.833 Y1.811 A0.01353 F300
G1 X-13.833 Y3.044 F7800
G1 X-5.507 Y3.044 A0.01707 F300
G1 X-5.507 Y4.277 F7800
G1 X-13.833 Y4.277 A0.02061 F300
G1 X-13.833 Y5.510 F7800
G1 X-5.507 Y5.510 A0.02415 F300
G1 X-5.507 Y6.743 F7800
G1 X-13.833 Y6.743 A0.02769 F300
G1 X-13.833 Y7.976 F7800
G1 X-5.507 Y7.976 A0.03123 F300
G1 A0.03123 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.92 ---
;     bed region: (-13.43,4.14) -> (-8.01,9.66)
G1 A0.03123 F60
G1 Z2.400 F600
G0 X-13.434 Y4.145 F7800
G1 Z0.400 F600
G1 A0.03123 F60
G1 X-8.013 Y4.145 A0.03354 F300
G1 X-8.013 Y5.378 F7800
G1 X-13.434 Y5.378 A0.03585 F300
G1 X-13.434 Y6.611 F7800
G1 X-8.013 Y6.611 A0.03815 F300
G1 X-8.013 Y7.844 F7800
G1 X-13.434 Y7.844 A0.04046 F300
G1 X-13.434 Y9.077 F7800
G1 X-8.013 Y9.077 A0.04276 F300
G1 A0.04276 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.92 ---
;     bed region: (-7.69,3.42) -> (-3.36,7.73)
G1 A0.04276 F60
G1 Z2.400 F600
G0 X-7.686 Y3.419 F7800
G1 Z0.400 F600
G1 A0.04276 F60
G1 X-3.362 Y3.419 A0.04460 F300
G1 X-3.362 Y4.652 F7800
G1 X-7.686 Y4.652 A0.04644 F300
G1 X-7.686 Y5.885 F7800
G1 X-3.362 Y5.885 A0.04828 F300
G1 X-3.362 Y7.118 F7800
G1 X-7.686 Y7.118 A0.05012 F300
G1 A0.05012 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.90 ---
;     bed region: (-5.52,2.35) -> (-2.18,5.64)
G1 A0.05012 F60
G1 Z2.400 F600
G0 X-5.518 Y2.352 F7800
G1 Z0.400 F600
G1 A0.05012 F60
G1 X-2.177 Y2.352 A0.05154 F300
G1 X-2.177 Y3.585 F7800
G1 X-5.518 Y3.585 A0.05296 F300
G1 X-5.518 Y4.818 F7800
G1 X-2.177 Y4.818 A0.05438 F300
G1 A0.05438 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
