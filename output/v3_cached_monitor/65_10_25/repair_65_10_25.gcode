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
;     bed region: (3.37,-1.24) -> (8.45,3.93)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X3.368 Y-1.235 F7800
G1 Z0.000 F600
G1 X8.445 Y-1.235 F200
G1 X8.445 Y-0.002 F200
G1 X3.368 Y-0.002 F200
G1 X3.368 Y1.231 F200
G1 X8.445 Y1.231 F200
G1 X8.445 Y2.464 F200
G1 X3.368 Y2.464 F200
G1 X3.368 Y3.697 F200
G1 X8.445 Y3.697 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.90 ---
;     bed region: (7.41,-1.99) -> (10.20,0.76)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X7.410 Y-1.988 F7800
G1 Z0.000 F600
G1 X10.195 Y-1.988 F200
G1 X10.195 Y-0.754 F200
G1 X7.410 Y-0.754 F200
G1 X7.410 Y0.479 F200
G1 X10.195 Y0.479 F200
G1 Z2.400 F600
; --- end mill cavity ---

G1 Z2.400 F600
M5  ; spindle off after milling
; --- DUST EXTRACTION (placeholder) ---
;     TODO: set DUST_EXTRACT_COMMAND in config.py
;     Ceramic chips must be cleared before deposition
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
;     Travel optimised: 7.0 -> 3.5 mm (50% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.90 ---
;     bed region: (7.41,-1.99) -> (10.20,0.76)
G1 A0.00000 F60
G1 Z2.400 F600
G0 X7.410 Y-1.988 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G1 X10.195 Y-1.988 A0.00118 F300
G1 X10.195 Y-0.754 F7800
G1 X7.410 Y-0.754 A0.00237 F300
G1 X7.410 Y0.479 F7800
G1 X10.195 Y0.479 A0.00355 F300
G1 A0.00355 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.94 ---
;     bed region: (3.37,-1.24) -> (8.45,3.93)
G1 A0.00355 F60
G1 Z2.400 F600
G0 X3.368 Y-1.235 F7800
G1 Z0.400 F600
G1 A0.00355 F60
G1 X8.445 Y-1.235 A0.00571 F300
G1 X8.445 Y-0.002 F7800
G1 X3.368 Y-0.002 A0.00787 F300
G1 X3.368 Y1.231 F7800
G1 X8.445 Y1.231 A0.01003 F300
G1 X8.445 Y2.464 F7800
G1 X3.368 Y2.464 A0.01219 F300
G1 X3.368 Y3.697 F7800
G1 X8.445 Y3.697 A0.01435 F300
G1 A0.01435 F60
G1 Z2.400 F600
; --- end underextrusion repair ---


; --- IR DRYING ---
M20 #620=60 #621=0.4  ; IR dry 60s at Z=0.4

; --- CAMERA SCAN (re-inspection) ---
M311  ; trigger camera scan

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
