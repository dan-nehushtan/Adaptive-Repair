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
;     Travel optimised: 44.4 -> 44.4 mm (0% saved)
; 
; --- Mill cavity: Underextrusion  conf=0.96 ---
;     bed region: (9.09,-15.17) -> (15.43,-8.88)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X9.090 Y-15.165 F7800
G1 Z0.000 F600
G1 X15.428 Y-15.165 F200
G1 X15.428 Y-13.932 F200
G1 X9.090 Y-13.932 F200
G1 X9.090 Y-12.699 F200
G1 X15.428 Y-12.699 F200
G1 X15.428 Y-11.466 F200
G1 X9.090 Y-11.466 F200
G1 X9.090 Y-10.233 F200
G1 X15.428 Y-10.233 F200
G1 X15.428 Y-9.000 F200
G1 X9.090 Y-9.000 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.86 ---
;     bed region: (3.86,-17.44) -> (5.94,-15.60)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X3.858 Y-17.440 F7800
G1 Z0.000 F600
G1 X5.943 Y-17.440 F200
G1 X5.943 Y-16.207 F200
G1 X3.858 Y-16.207 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.86 ---
;     bed region: (16.35,-3.55) -> (18.16,-1.58)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X16.353 Y-3.545 F7800
G1 Z0.000 F600
G1 X18.158 Y-3.545 F200
G1 X18.158 Y-2.312 F200
G1 X16.353 Y-2.312 F200
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
; >>> PHASE 2: DEPOSIT INTO UNDEREXTRUSION CAVITIES (3)
;     Fill milled cavities with ceramic
;     Travel optimised: 38.0 -> 19.3 mm (49% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.86 ---
;     bed region: (16.35,-3.55) -> (18.16,-1.58)
G1 A0.00000 F60
G1 Z2.400 F600
G0 X16.353 Y-3.545 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G1 X18.158 Y-3.545 A0.00077 F300
G1 X18.158 Y-2.312 F7800
G1 X16.353 Y-2.312 A0.00154 F300
G1 A0.00154 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.96 ---
;     bed region: (9.09,-15.17) -> (15.43,-8.88)
G1 A0.00154 F60
G1 Z2.400 F600
G0 X9.090 Y-15.165 F7800
G1 Z0.400 F600
G1 A0.00154 F60
G1 X15.428 Y-15.165 A0.00423 F300
G1 X15.428 Y-13.932 F7800
G1 X9.090 Y-13.932 A0.00693 F300
G1 X9.090 Y-12.699 F7800
G1 X15.428 Y-12.699 A0.00962 F300
G1 X15.428 Y-11.466 F7800
G1 X9.090 Y-11.466 A0.01232 F300
G1 X9.090 Y-10.233 F7800
G1 X15.428 Y-10.233 A0.01501 F300
G1 X15.428 Y-9.000 F7800
G1 X9.090 Y-9.000 A0.01771 F300
G1 A0.01771 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.86 ---
;     bed region: (3.86,-17.44) -> (5.94,-15.60)
G1 A0.01771 F60
G1 Z2.400 F600
G0 X3.858 Y-17.440 F7800
G1 Z0.400 F600
G1 A0.01771 F60
G1 X5.943 Y-17.440 A0.01860 F300
G1 X5.943 Y-16.207 F7800
G1 X3.858 Y-16.207 A0.01948 F300
G1 A0.01948 F60
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
