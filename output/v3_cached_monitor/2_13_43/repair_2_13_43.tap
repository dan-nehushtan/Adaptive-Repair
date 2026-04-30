; ============================================================
; ADAPTIVE REPAIR G-CODE
; Layer 0   Z=0.400 mm
; Defects: 5
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
; >>> PHASE 1: MILL ALL BOUNDING BOXES (5)
;     Overextrusion  : 0 regions (skim excess)
;     Underextrusion : 5 regions (cut clean cavity)
;     Travel optimised: 84.2 -> 49.0 mm (42% saved)
; 
; --- Mill cavity: Underextrusion  conf=0.86 ---
;     bed region: (-18.00,1.65) -> (-16.28,3.51)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X-18.000 Y1.653 F7800
G1 Z0.000 F600
G1 X-16.283 Y1.653 F200
G1 X-16.283 Y2.886 F200
G1 X-18.000 Y2.886 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.89 ---
;     bed region: (-1.85,16.44) -> (0.45,18.37)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X-1.848 Y16.440 F7800
G1 Z0.000 F600
G1 X0.448 Y16.440 F200
G1 X0.448 Y17.673 F200
G1 X-1.848 Y17.673 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.90 ---
;     bed region: (1.18,16.49) -> (3.51,18.40)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X1.180 Y16.493 F7800
G1 Z0.000 F600
G1 X3.510 Y16.493 F200
G1 X3.510 Y17.726 F200
G1 X1.180 Y17.726 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.86 ---
;     bed region: (4.61,16.77) -> (6.61,18.39)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X4.610 Y16.773 F7800
G1 Z0.000 F600
G1 X6.608 Y16.773 F200
G1 X6.608 Y18.006 F200
G1 X4.610 Y18.006 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.86 ---
;     bed region: (7.87,16.93) -> (9.79,18.42)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X7.865 Y16.930 F7800
G1 Z0.000 F600
G1 X9.793 Y16.930 F200
G1 X9.793 Y18.163 F200
G1 X7.865 Y18.163 F200
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
; >>> PHASE 2: DEPOSIT INTO UNDEREXTRUSION CAVITIES (5)
;     Fill milled cavities with ceramic
;     Travel optimised: 73.1 -> 31.7 mm (57% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.86 ---
;     bed region: (7.87,16.93) -> (9.79,18.42)
G1 A0.00000 F60
G1 Z2.400 F600
G0 X7.865 Y16.930 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G1 X9.793 Y16.930 A0.00082 F300
G1 X9.793 Y18.163 F7800
G1 X7.865 Y18.163 A0.00164 F300
G1 A0.00164 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.86 ---
;     bed region: (4.61,16.77) -> (6.61,18.39)
G1 A0.00164 F60
G1 Z2.400 F600
G0 X4.610 Y16.773 F7800
G1 Z0.400 F600
G1 A0.00164 F60
G1 X6.608 Y16.773 A0.00249 F300
G1 X6.608 Y18.006 F7800
G1 X4.610 Y18.006 A0.00334 F300
G1 A0.00334 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.90 ---
;     bed region: (1.18,16.49) -> (3.51,18.40)
G1 A0.00334 F60
G1 Z2.400 F600
G0 X1.180 Y16.493 F7800
G1 Z0.400 F600
G1 A0.00334 F60
G1 X3.510 Y16.493 A0.00433 F300
G1 X3.510 Y17.726 F7800
G1 X1.180 Y17.726 A0.00532 F300
G1 A0.00532 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.89 ---
;     bed region: (-1.85,16.44) -> (0.45,18.37)
G1 A0.00532 F60
G1 Z2.400 F600
G0 X-1.848 Y16.440 F7800
G1 Z0.400 F600
G1 A0.00532 F60
G1 X0.448 Y16.440 A0.00630 F300
G1 X0.448 Y17.673 F7800
G1 X-1.848 Y17.673 A0.00727 F300
G1 A0.00727 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.86 ---
;     bed region: (-18.00,1.65) -> (-16.28,3.51)
G1 A0.00727 F60
G1 Z2.400 F600
G0 X-18.000 Y1.653 F7800
G1 Z0.400 F600
G1 A0.00727 F60
G1 X-16.283 Y1.653 A0.00800 F300
G1 X-16.283 Y2.886 F7800
G1 X-18.000 Y2.886 A0.00874 F300
G1 A0.00874 F60
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
