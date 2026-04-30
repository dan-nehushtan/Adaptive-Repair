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
;     Overextrusion  : 0 regions (skim excess)
;     Underextrusion : 4 regions (cut clean cavity)
;     Travel optimised: 57.0 -> 35.7 mm (37% saved)
; 
; --- Mill cavity: Underextrusion  conf=0.88 ---
;     bed region: (0.71,-14.53) -> (4.14,-10.85)
G1 Z2.400 F600
G0 X0.712 Y-14.526 F7800
G1 Z0.400 F600
G1 X4.143 Y-14.526 F200
G1 X4.143 Y-13.293 F200
G1 X0.712 Y-13.293 F200
G1 X0.712 Y-12.060 F200
G1 X4.143 Y-12.060 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.85 ---
;     bed region: (6.69,-17.94) -> (8.45,-16.41)
G1 Z2.400 F600
G0 X6.690 Y-17.943 F7800
G1 Z0.400 F600
G1 X8.452 Y-17.943 F200
G1 X8.452 Y-16.710 F200
G1 X6.690 Y-16.710 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.85 ---
;     bed region: (16.57,-10.00) -> (18.23,-8.17)
G1 Z2.400 F600
G0 X16.574 Y-9.999 F7800
G1 Z0.400 F600
G1 X18.225 Y-9.999 F200
G1 X18.225 Y-8.766 F200
G1 X16.574 Y-8.766 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.86 ---
;     bed region: (16.48,-6.79) -> (18.24,-4.91)
G1 Z2.400 F600
G0 X16.482 Y-6.791 F7800
G1 Z0.400 F600
G1 X18.243 Y-6.791 F200
G1 X18.243 Y-5.558 F200
G1 X16.482 Y-5.558 F200
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
; >>> PHASE 2: DEPOSIT INTO UNDEREXTRUSION CAVITIES (4)
;     Fill milled cavities with ceramic
;     Travel optimised: 60.5 -> 22.8 mm (62% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.86 ---
;     bed region: (16.48,-6.79) -> (18.24,-4.91)
G1 A0.00000 F60
G1 Z2.400 F600
G0 X16.482 Y-6.791 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G1 X18.243 Y-6.791 A0.00075 F300
G1 X18.243 Y-5.558 F7800
G1 X16.482 Y-5.558 A0.00150 F300
G1 A0.00150 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.85 ---
;     bed region: (16.57,-10.00) -> (18.23,-8.17)
G1 A0.00150 F60
G1 Z2.400 F600
G0 X16.574 Y-9.999 F7800
G1 Z0.400 F600
G1 A0.00150 F60
G1 X18.225 Y-9.999 A0.00220 F300
G1 X18.225 Y-8.766 F7800
G1 X16.574 Y-8.766 A0.00290 F300
G1 A0.00290 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.85 ---
;     bed region: (6.69,-17.94) -> (8.45,-16.41)
G1 A0.00290 F60
G1 Z2.400 F600
G0 X6.690 Y-17.943 F7800
G1 Z0.400 F600
G1 A0.00290 F60
G1 X8.452 Y-17.943 A0.00365 F300
G1 X8.452 Y-16.710 F7800
G1 X6.690 Y-16.710 A0.00440 F300
G1 A0.00440 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.88 ---
;     bed region: (0.71,-14.53) -> (4.14,-10.85)
G1 A0.00440 F60
G1 Z2.400 F600
G0 X0.712 Y-14.526 F7800
G1 Z0.400 F600
G1 A0.00440 F60
G1 X4.143 Y-14.526 A0.00586 F300
G1 X4.143 Y-13.293 F7800
G1 X0.712 Y-13.293 A0.00732 F300
G1 X0.712 Y-12.060 F7800
G1 X4.143 Y-12.060 A0.00878 F300
G1 A0.00878 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
