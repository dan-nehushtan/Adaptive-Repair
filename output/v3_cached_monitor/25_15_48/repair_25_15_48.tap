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
;     Travel optimised: 12.7 -> 12.7 mm (0% saved)
; 
; --- Mill cavity: Underextrusion  conf=0.90 ---
;     bed region: (-6.49,-13.00) -> (-3.81,-10.18)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X-6.485 Y-12.995 F7800
G1 Z0.000 F600
G1 X-3.805 Y-12.995 F200
G1 X-3.805 Y-11.762 F200
G1 X-6.485 Y-11.762 F200
G1 X-6.485 Y-10.529 F200
G1 X-3.805 Y-10.529 F200
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

; --- Underextrusion repair  conf=0.90 ---
;     bed region: (-6.49,-13.00) -> (-3.81,-10.18)
G1 A0.00000 F60
G1 Z2.400 F600
G0 X-6.485 Y-12.995 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G1 X-3.805 Y-12.995 A0.00114 F300
G1 X-3.805 Y-11.762 F7800
G1 X-6.485 Y-11.762 A0.00228 F300
G1 X-6.485 Y-10.529 F7800
G1 X-3.805 Y-10.529 A0.00342 F300
G1 A0.00342 F60
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
