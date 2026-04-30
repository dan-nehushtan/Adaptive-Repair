; ============================================================
; ADAPTIVE REPAIR G-CODE
; Layer 0   Z=0.400 mm
; Defects: 2
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
; >>> PHASE 1: MILL ALL BOUNDING BOXES (2)
;     Overextrusion  : 0 regions (skim excess)
;     Underextrusion : 2 regions (cut clean cavity)
;     Travel optimised: 9.6 -> 9.6 mm (0% saved)
; 
; --- Mill cavity: Underextrusion  conf=0.94 ---
;     bed region: (3.37,-1.17) -> (8.43,4.00)
G1 Z2.400 F600
G0 X3.368 Y-1.174 F7800
G1 Z0.400 F600
G1 X8.427 Y-1.174 F200
G1 X8.427 Y0.059 F200
G1 X3.368 Y0.059 F200
G1 X3.368 Y1.292 F200
G1 X8.427 Y1.292 F200
G1 X8.427 Y2.525 F200
G1 X3.368 Y2.525 F200
G1 X3.368 Y3.758 F200
G1 X8.427 Y3.758 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.91 ---
;     bed region: (7.43,-2.00) -> (10.18,0.79)
G1 Z2.400 F600
G0 X7.434 Y-1.997 F7800
G1 Z0.400 F600
G1 X10.182 Y-1.997 F200
G1 X10.182 Y-0.764 F200
G1 X7.434 Y-0.764 F200
G1 X7.434 Y0.469 F200
G1 X10.182 Y0.469 F200
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
; >>> PHASE 2: DEPOSIT INTO UNDEREXTRUSION CAVITIES (2)
;     Fill milled cavities with ceramic
;     Travel optimised: 7.1 -> 3.5 mm (50% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.91 ---
;     bed region: (7.43,-2.00) -> (10.18,0.79)
G1 A0.00000 F60
G1 Z2.400 F600
G0 X7.434 Y-1.997 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G1 X10.182 Y-1.997 A0.00117 F300
G1 X10.182 Y-0.764 F7800
G1 X7.434 Y-0.764 A0.00234 F300
G1 X7.434 Y0.469 F7800
G1 X10.182 Y0.469 A0.00351 F300
G1 A0.00351 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.94 ---
;     bed region: (3.37,-1.17) -> (8.43,4.00)
G1 A0.00351 F60
G1 Z2.400 F600
G0 X3.368 Y-1.174 F7800
G1 Z0.400 F600
G1 A0.00351 F60
G1 X8.427 Y-1.174 A0.00566 F300
G1 X8.427 Y0.059 F7800
G1 X3.368 Y0.059 A0.00781 F300
G1 X3.368 Y1.292 F7800
G1 X8.427 Y1.292 A0.00996 F300
G1 X8.427 Y2.525 F7800
G1 X3.368 Y2.525 A0.01212 F300
G1 X3.368 Y3.758 F7800
G1 X8.427 Y3.758 A0.01427 F300
G1 A0.01427 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
