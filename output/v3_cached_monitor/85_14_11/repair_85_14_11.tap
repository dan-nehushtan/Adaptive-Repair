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
;     Overextrusion  : 1 regions (skim excess)
;     Underextrusion : 1 regions (cut clean cavity)
;     Travel optimised: 81.2 -> 59.4 mm (27% saved)
; 
; --- Mill cavity: Underextrusion  conf=0.93 ---
;     bed region: (9.93,-14.27) -> (14.10,-10.28)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X9.930 Y-14.273 F7800
G1 Z0.000 F600
G1 X14.098 Y-14.273 F200
G1 X14.098 Y-13.040 F200
G1 X9.930 Y-13.040 F200
G1 X9.930 Y-11.806 F200
G1 X14.098 Y-11.806 F200
G1 X14.098 Y-10.573 F200
G1 X9.930 Y-10.573 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill skim: Overextrusion  conf=0.94 ---
;     bed region: (-29.08,-29.48) -> (-25.54,-25.96)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-29.078 Y-29.480 F7800
G1 Z0.400 F600
G1 X-25.540 Y-29.480 F200
G1 X-25.540 Y-28.247 F200
G1 X-29.078 Y-28.247 F200
G1 X-29.078 Y-27.014 F200
G1 X-25.540 Y-27.014 F200
G1 Z2.400 F600
; --- end mill skim ---

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
;     Travel optimised: 42.2 -> 42.2 mm (0% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.93 ---
;     bed region: (9.93,-14.27) -> (14.10,-10.28)
G1 A0.00000 F60
G1 Z2.400 F600
G0 X9.930 Y-14.273 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G1 X14.098 Y-14.273 A0.00177 F300
G1 X14.098 Y-13.040 F7800
G1 X9.930 Y-13.040 A0.00355 F300
G1 X9.930 Y-11.806 F7800
G1 X14.098 Y-11.806 A0.00532 F300
G1 X14.098 Y-10.573 F7800
G1 X9.930 Y-10.573 A0.00709 F300
G1 A0.00709 F60
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
