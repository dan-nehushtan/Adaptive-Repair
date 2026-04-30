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
;     Travel optimised: 80.4 -> 50.1 mm (38% saved)
; 
; --- Mill cavity: Underextrusion  conf=0.89 ---
;     bed region: (6.15,-4.46) -> (8.73,-2.18)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X6.150 Y-4.455 F7800
G1 Z0.000 F600
G1 X8.725 Y-4.455 F200
G1 X8.725 Y-3.222 F200
G1 X6.150 Y-3.222 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill skim: Overextrusion  conf=0.93 ---
;     bed region: (-28.75,-28.99) -> (-25.33,-25.56)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-28.745 Y-28.990 F7800
G1 Z0.400 F600
G1 X-25.330 Y-28.990 F200
G1 X-25.330 Y-27.757 F200
G1 X-28.745 Y-27.757 F200
G1 X-28.745 Y-26.524 F200
G1 X-25.330 Y-26.524 F200
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
;     Travel optimised: 42.0 -> 42.0 mm (0% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.89 ---
;     bed region: (6.15,-4.46) -> (8.73,-2.18)
G1 A0.00000 F60
G1 Z2.400 F600
G0 X6.150 Y-4.455 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G1 X8.725 Y-4.455 A0.00110 F300
G1 X8.725 Y-3.222 F7800
G1 X6.150 Y-3.222 A0.00219 F300
G1 A0.00219 F60
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
