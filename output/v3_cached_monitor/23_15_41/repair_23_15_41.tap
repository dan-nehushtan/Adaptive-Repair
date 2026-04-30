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
;     Travel optimised: 70.6 -> 40.9 mm (42% saved)
; 
; --- Mill cavity: Underextrusion  conf=0.88 ---
;     bed region: (-1.27,-9.34) -> (1.06,-7.27)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X-1.270 Y-9.338 F7800
G1 Z0.000 F600
G1 X1.060 Y-9.338 F200
G1 X1.060 Y-8.104 F200
G1 X-1.270 Y-8.104 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill skim: Overextrusion  conf=0.92 ---
;     bed region: (-28.38,-28.90) -> (-24.86,-25.47)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-28.378 Y-28.903 F7800
G1 Z0.400 F600
G1 X-24.858 Y-28.903 F200
G1 X-24.858 Y-27.670 F200
G1 X-28.378 Y-27.670 F200
G1 X-28.378 Y-26.437 F200
G1 X-24.858 Y-26.437 F200
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
;     Travel optimised: 32.5 -> 32.5 mm (0% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.88 ---
;     bed region: (-1.27,-9.34) -> (1.06,-7.27)
G1 A0.00000 F60
G1 Z2.400 F600
G0 X-1.270 Y-9.338 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G1 X1.060 Y-9.338 A0.00099 F300
G1 X1.060 Y-8.104 F7800
G1 X-1.270 Y-8.104 A0.00198 F300
G1 A0.00198 F60
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
