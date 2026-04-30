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
;     Travel optimised: 37.0 -> 33.6 mm (9% saved)
; 
; --- Mill cavity: Underextrusion  conf=0.86 ---
;     bed region: (16.53,2.67) -> (18.26,4.60)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X16.527 Y2.668 F7800
G1 Z0.000 F600
G1 X18.263 Y2.668 F200
G1 X18.263 Y3.901 F200
G1 X16.527 Y3.901 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.86 ---
;     bed region: (16.44,-6.80) -> (18.23,-4.93)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X16.440 Y-6.800 F7800
G1 Z0.000 F600
G1 X18.228 Y-6.800 F200
G1 X18.228 Y-5.567 F200
G1 X16.440 Y-5.567 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.86 ---
;     bed region: (16.46,-13.15) -> (18.18,-11.26)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X16.458 Y-13.153 F7800
G1 Z0.000 F600
G1 X18.175 Y-13.153 F200
G1 X18.175 Y-11.920 F200
G1 X16.458 Y-11.920 F200
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
;     Travel optimised: 15.8 -> 15.8 mm (0% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.86 ---
;     bed region: (16.46,-13.15) -> (18.18,-11.26)
G1 A0.00000 F60
G1 Z2.400 F600
G0 X16.458 Y-13.153 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G1 X18.175 Y-13.153 A0.00073 F300
G1 X18.175 Y-11.920 F7800
G1 X16.458 Y-11.920 A0.00146 F300
G1 A0.00146 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.86 ---
;     bed region: (16.44,-6.80) -> (18.23,-4.93)
G1 A0.00146 F60
G1 Z2.400 F600
G0 X16.440 Y-6.800 F7800
G1 Z0.400 F600
G1 A0.00146 F60
G1 X18.228 Y-6.800 A0.00222 F300
G1 X18.228 Y-5.567 F7800
G1 X16.440 Y-5.567 A0.00298 F300
G1 A0.00298 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.86 ---
;     bed region: (16.53,2.67) -> (18.26,4.60)
G1 A0.00298 F60
G1 Z2.400 F600
G0 X16.527 Y2.668 F7800
G1 Z0.400 F600
G1 A0.00298 F60
G1 X18.263 Y2.668 A0.00372 F300
G1 X18.263 Y3.901 F7800
G1 X16.527 Y3.901 A0.00446 F300
G1 A0.00446 F60
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
