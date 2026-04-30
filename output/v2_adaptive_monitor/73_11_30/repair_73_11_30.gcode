; ============================================================
; ADAPTIVE REPAIR G-CODE
; Layer 0   Z=0.400 mm
; Defects: 1
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
; >>> PHASE 1: MILL ALL BOUNDING BOXES (1)
;     Overextrusion  : 0 regions (skim excess)
;     Underextrusion : 1 regions (cut clean cavity)
;     Travel optimised: 17.0 -> 17.0 mm (0% saved)
; 
; --- Mill cavity: Underextrusion  conf=0.89 ---
;     bed region: (9.10,-14.88) -> (15.03,-8.97)
G1 Z2.400 F600
G0 X9.102 Y-14.882 F7800
G1 Z0.400 F600
G1 X15.028 Y-14.882 F200
G1 X15.028 Y-13.649 F200
G1 X9.102 Y-13.649 F200
G1 X9.102 Y-12.416 F200
G1 X15.028 Y-12.416 F200
G1 X15.028 Y-11.183 F200
G1 X9.102 Y-11.183 F200
G1 X9.102 Y-9.950 F200
G1 X15.028 Y-9.950 F200
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
; >>> PHASE 2: DEPOSIT INTO UNDEREXTRUSION CAVITIES (1)
;     Fill milled cavities with ceramic
; 
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.89 ---
;     bed region: (9.10,-14.88) -> (15.03,-8.97)
G1 A0.00000 F60
G1 Z2.400 F600
G0 X9.102 Y-14.882 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G1 X15.028 Y-14.882 A0.00252 F300
G1 X15.028 Y-13.649 F7800
G1 X9.102 Y-13.649 A0.00504 F300
G1 X9.102 Y-12.416 F7800
G1 X15.028 Y-12.416 A0.00756 F300
G1 X15.028 Y-11.183 F7800
G1 X9.102 Y-11.183 A0.01008 F300
G1 X9.102 Y-9.950 F7800
G1 X15.028 Y-9.950 A0.01260 F300
G1 A0.01260 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
