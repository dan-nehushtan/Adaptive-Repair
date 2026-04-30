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
;     Travel optimised: 80.9 -> 50.2 mm (38% saved)
; 
; --- Mill cavity: Underextrusion  conf=0.89 ---
;     bed region: (5.84,-4.75) -> (8.69,-2.23)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X5.835 Y-4.753 F7800
G1 Z0.000 F600
G1 X8.690 Y-4.753 F200
G1 X8.690 Y-3.520 F200
G1 X5.835 Y-3.520 F200
G1 X5.835 Y-2.287 F200
G1 X8.690 Y-2.287 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill skim: Overextrusion  conf=0.93 ---
;     bed region: (-29.17,-29.38) -> (-25.49,-25.63)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-29.165 Y-29.375 F7800
G1 Z0.400 F600
G1 X-25.488 Y-29.375 F200
G1 X-25.488 Y-28.142 F200
G1 X-29.165 Y-28.142 F200
G1 X-29.165 Y-26.909 F200
G1 X-25.488 Y-26.909 F200
G1 X-25.488 Y-25.676 F200
G1 X-29.165 Y-25.676 F200
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
;     Travel optimised: 42.1 -> 42.1 mm (0% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.89 ---
;     bed region: (5.84,-4.75) -> (8.69,-2.23)
G1 A0.00000 F60
G1 Z2.400 F600
G0 X5.835 Y-4.753 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G1 X8.690 Y-4.753 A0.00121 F300
G1 X8.690 Y-3.520 F7800
G1 X5.835 Y-3.520 A0.00243 F300
G1 X5.835 Y-2.287 F7800
G1 X8.690 Y-2.287 A0.00364 F300
G1 A0.00364 F60
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
