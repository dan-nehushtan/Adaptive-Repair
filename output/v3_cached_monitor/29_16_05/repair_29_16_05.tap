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
;     Travel optimised: 17.2 -> 17.2 mm (0% saved)
; 
; --- Mill cavity: Underextrusion  conf=0.96 ---
;     bed region: (9.27,-15.01) -> (15.15,-9.14)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X9.265 Y-15.008 F7800
G1 Z0.000 F600
G1 X15.148 Y-15.008 F200
G1 X15.148 Y-13.775 F200
G1 X9.265 Y-13.775 F200
G1 X9.265 Y-12.542 F200
G1 X15.148 Y-12.542 F200
G1 X15.148 Y-11.309 F200
G1 X9.265 Y-11.309 F200
G1 X9.265 Y-10.075 F200
G1 X15.148 Y-10.075 F200
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
; >>> PHASE 2: DEPOSIT INTO UNDEREXTRUSION CAVITIES (1)
;     Fill milled cavities with ceramic
; 
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.96 ---
;     bed region: (9.27,-15.01) -> (15.15,-9.14)
G1 A0.00000 F60
G1 Z2.400 F600
G0 X9.265 Y-15.008 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G1 X15.148 Y-15.008 A0.00250 F300
G1 X15.148 Y-13.775 F7800
G1 X9.265 Y-13.775 A0.00500 F300
G1 X9.265 Y-12.542 F7800
G1 X15.148 Y-12.542 A0.00751 F300
G1 X15.148 Y-11.309 F7800
G1 X9.265 Y-11.309 A0.01001 F300
G1 X9.265 Y-10.075 F7800
G1 X15.148 Y-10.075 A0.01251 F300
G1 A0.01251 F60
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
