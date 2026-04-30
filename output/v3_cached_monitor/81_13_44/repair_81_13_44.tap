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
;     Travel optimised: 20.5 -> 20.1 mm (2% saved)
; 
; --- Mill cavity: Underextrusion  conf=0.85 ---
;     bed region: (-7.05,-5.07) -> (-4.86,-2.95)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X-7.045 Y-5.068 F7800
G1 Z0.000 F600
G1 X-4.855 Y-5.068 F200
G1 X-4.855 Y-3.835 F200
G1 X-7.045 Y-3.835 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.92 ---
;     bed region: (4.93,-5.17) -> (8.97,-0.66)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X4.925 Y-5.173 F7800
G1 Z0.000 F600
G1 X8.970 Y-5.173 F200
G1 X8.970 Y-3.940 F200
G1 X4.925 Y-3.940 F200
G1 X4.925 Y-2.707 F200
G1 X8.970 Y-2.707 F200
G1 X8.970 Y-1.474 F200
G1 X4.925 Y-1.474 F200
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
;     Travel optimised: 12.9 -> 12.9 mm (0% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.92 ---
;     bed region: (4.93,-5.17) -> (8.97,-0.66)
G1 A0.00000 F60
G1 Z2.400 F600
G0 X4.925 Y-5.173 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G1 X8.970 Y-5.173 A0.00172 F300
G1 X8.970 Y-3.940 F7800
G1 X4.925 Y-3.940 A0.00344 F300
G1 X4.925 Y-2.707 F7800
G1 X8.970 Y-2.707 A0.00516 F300
G1 X8.970 Y-1.474 F7800
G1 X4.925 Y-1.474 A0.00688 F300
G1 A0.00688 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.85 ---
;     bed region: (-7.05,-5.07) -> (-4.86,-2.95)
G1 A0.00688 F60
G1 Z2.400 F600
G0 X-7.045 Y-5.068 F7800
G1 Z0.400 F600
G1 A0.00688 F60
G1 X-4.855 Y-5.068 A0.00781 F300
G1 X-4.855 Y-3.835 F7800
G1 X-7.045 Y-3.835 A0.00875 F300
G1 A0.00875 F60
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
