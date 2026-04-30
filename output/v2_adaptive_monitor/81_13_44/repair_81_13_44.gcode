; ============================================================
; ADAPTIVE REPAIR G-CODE
; Layer 0   Z=0.400 mm
; Defects: 3
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
; >>> PHASE 1: MILL ALL BOUNDING BOXES (3)
;     Overextrusion  : 0 regions (skim excess)
;     Underextrusion : 3 regions (cut clean cavity)
;     Travel optimised: 15.8 -> 11.1 mm (30% saved)
; 
; --- Mill cavity: Underextrusion  conf=0.86 ---
;     bed region: (-3.95,-5.49) -> (1.66,0.11)
G1 Z2.400 F600
G0 X-3.952 Y-5.492 F7800
G1 Z0.400 F600
G1 X1.659 Y-5.492 F200
G1 X1.659 Y-4.259 F200
G1 X-3.952 Y-4.259 F200
G1 X-3.952 Y-3.026 F200
G1 X1.659 Y-3.026 F200
G1 X1.659 Y-1.793 F200
G1 X-3.952 Y-1.793 F200
G1 X-3.952 Y-0.560 F200
G1 X1.659 Y-0.560 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.91 ---
;     bed region: (-2.62,-7.30) -> (4.90,1.51)
G1 Z2.400 F600
G0 X-2.619 Y-7.305 F7800
G1 Z0.400 F600
G1 X4.904 Y-7.305 F200
G1 X4.904 Y-6.072 F200
G1 X-2.619 Y-6.072 F200
G1 X-2.619 Y-4.839 F200
G1 X4.904 Y-4.839 F200
G1 X4.904 Y-3.606 F200
G1 X-2.619 Y-3.606 F200
G1 X-2.619 Y-2.373 F200
G1 X4.904 Y-2.373 F200
G1 X4.904 Y-1.140 F200
G1 X-2.619 Y-1.140 F200
G1 X-2.619 Y0.093 F200
G1 X4.904 Y0.093 F200
G1 X4.904 Y1.326 F200
G1 X-2.619 Y1.326 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.93 ---
;     bed region: (4.98,-5.10) -> (9.14,-0.66)
G1 Z2.400 F600
G0 X4.976 Y-5.102 F7800
G1 Z0.400 F600
G1 X9.139 Y-5.102 F200
G1 X9.139 Y-3.869 F200
G1 X4.976 Y-3.869 F200
G1 X4.976 Y-2.636 F200
G1 X9.139 Y-2.636 F200
G1 X9.139 Y-1.403 F200
G1 X4.976 Y-1.403 F200
G1 Z2.400 F600
; --- end mill cavity ---

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
;     Travel optimised: 8.2 -> 8.2 mm (0% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.93 ---
;     bed region: (4.98,-5.10) -> (9.14,-0.66)
G1 A0.00000 F60
G1 Z2.400 F600
G0 X4.976 Y-5.102 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G1 X9.139 Y-5.102 A0.00177 F300
G1 X9.139 Y-3.869 F7800
G1 X4.976 Y-3.869 A0.00354 F300
G1 X4.976 Y-2.636 F7800
G1 X9.139 Y-2.636 A0.00531 F300
G1 X9.139 Y-1.403 F7800
G1 X4.976 Y-1.403 A0.00708 F300
G1 A0.00708 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.91 ---
;     bed region: (-2.62,-7.30) -> (4.90,1.51)
G1 A0.00708 F60
G1 Z2.400 F600
G0 X-2.619 Y-7.305 F7800
G1 Z0.400 F600
G1 A0.00708 F60
G1 X4.904 Y-7.305 A0.01028 F300
G1 X4.904 Y-6.072 F7800
G1 X-2.619 Y-6.072 A0.01348 F300
G1 X-2.619 Y-4.839 F7800
G1 X4.904 Y-4.839 A0.01668 F300
G1 X4.904 Y-3.606 F7800
G1 X-2.619 Y-3.606 A0.01988 F300
G1 X-2.619 Y-2.373 F7800
G1 X4.904 Y-2.373 A0.02308 F300
G1 X4.904 Y-1.140 F7800
G1 X-2.619 Y-1.140 A0.02629 F300
G1 X-2.619 Y0.093 F7800
G1 X4.904 Y0.093 A0.02949 F300
G1 X4.904 Y1.326 F7800
G1 X-2.619 Y1.326 A0.03269 F300
G1 A0.03269 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.86 ---
;     bed region: (-3.95,-5.49) -> (1.66,0.11)
G1 A0.03269 F60
G1 Z2.400 F600
G0 X-3.952 Y-5.492 F7800
G1 Z0.400 F600
G1 A0.03269 F60
G1 X1.659 Y-5.492 A0.03507 F300
G1 X1.659 Y-4.259 F7800
G1 X-3.952 Y-4.259 A0.03746 F300
G1 X-3.952 Y-3.026 F7800
G1 X1.659 Y-3.026 A0.03985 F300
G1 X1.659 Y-1.793 F7800
G1 X-3.952 Y-1.793 A0.04223 F300
G1 X-3.952 Y-0.560 F7800
G1 X1.659 Y-0.560 A0.04462 F300
G1 A0.04462 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
