; ============================================================
; ADAPTIVE REPAIR G-CODE
; Layer 0   Z=0.400 mm
; Defects: 4
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
; >>> PHASE 1: MILL ALL BOUNDING BOXES (4)
;     Overextrusion  : 1 regions (skim excess)
;     Underextrusion : 3 regions (cut clean cavity)
;     Travel optimised: 90.6 -> 40.6 mm (55% saved)
; 
; --- Mill cavity: Underextrusion  conf=0.93 ---
;     bed region: (-5.45,-2.11) -> (-0.71,2.67)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X-5.453 Y-2.110 F7800
G1 Z0.000 F600
G1 X-0.708 Y-2.110 F200
G1 X-0.708 Y-0.877 F200
G1 X-5.453 Y-0.877 F200
G1 X-5.453 Y0.356 F200
G1 X-0.708 Y0.356 F200
G1 X-0.708 Y1.589 F200
G1 X-5.453 Y1.589 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.95 ---
;     bed region: (-12.03,-8.79) -> (-5.10,-1.88)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X-12.033 Y-8.795 F7800
G1 Z0.000 F600
G1 X-5.100 Y-8.795 F200
G1 X-5.100 Y-7.562 F200
G1 X-12.033 Y-7.562 F200
G1 X-12.033 Y-6.329 F200
G1 X-5.100 Y-6.329 F200
G1 X-5.100 Y-5.096 F200
G1 X-12.033 Y-5.096 F200
G1 X-12.033 Y-3.863 F200
G1 X-5.100 Y-3.863 F200
G1 X-5.100 Y-2.630 F200
G1 X-12.033 Y-2.630 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.91 ---
;     bed region: (-15.45,-10.28) -> (-12.61,-7.67)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X-15.445 Y-10.283 F7800
G1 Z0.000 F600
G1 X-12.608 Y-10.283 F200
G1 X-12.608 Y-9.050 F200
G1 X-15.445 Y-9.050 F200
G1 X-15.445 Y-7.816 F200
G1 X-12.608 Y-7.816 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill skim: Overextrusion  conf=0.94 ---
;     bed region: (-29.60,-29.74) -> (-25.51,-25.66)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-29.603 Y-29.743 F7800
G1 Z0.400 F600
G1 X-25.505 Y-29.743 F200
G1 X-25.505 Y-28.510 F200
G1 X-29.603 Y-28.510 F200
G1 X-29.603 Y-27.277 F200
G1 X-25.505 Y-27.277 F200
G1 X-25.505 Y-26.044 F200
G1 X-29.603 Y-26.044 F200
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
; >>> PHASE 2: DEPOSIT INTO UNDEREXTRUSION CAVITIES (3)
;     Fill milled cavities with ceramic
;     Travel optimised: 51.5 -> 37.5 mm (27% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.91 ---
;     bed region: (-15.45,-10.28) -> (-12.61,-7.67)
G1 A0.00000 F60
G1 Z2.400 F600
G0 X-15.445 Y-10.283 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G1 X-12.608 Y-10.283 A0.00121 F300
G1 X-12.608 Y-9.050 F7800
G1 X-15.445 Y-9.050 A0.00241 F300
G1 X-15.445 Y-7.816 F7800
G1 X-12.608 Y-7.816 A0.00362 F300
G1 A0.00362 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.95 ---
;     bed region: (-12.03,-8.79) -> (-5.10,-1.88)
G1 A0.00362 F60
G1 Z2.400 F600
G0 X-12.033 Y-8.795 F7800
G1 Z0.400 F600
G1 A0.00362 F60
G1 X-5.100 Y-8.795 A0.00657 F300
G1 X-5.100 Y-7.562 F7800
G1 X-12.033 Y-7.562 A0.00952 F300
G1 X-12.033 Y-6.329 F7800
G1 X-5.100 Y-6.329 A0.01247 F300
G1 X-5.100 Y-5.096 F7800
G1 X-12.033 Y-5.096 A0.01542 F300
G1 X-12.033 Y-3.863 F7800
G1 X-5.100 Y-3.863 A0.01837 F300
G1 X-5.100 Y-2.630 F7800
G1 X-12.033 Y-2.630 A0.02131 F300
G1 A0.02131 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.93 ---
;     bed region: (-5.45,-2.11) -> (-0.71,2.67)
G1 A0.02131 F60
G1 Z2.400 F600
G0 X-5.453 Y-2.110 F7800
G1 Z0.400 F600
G1 A0.02131 F60
G1 X-0.708 Y-2.110 A0.02333 F300
G1 X-0.708 Y-0.877 F7800
G1 X-5.453 Y-0.877 A0.02535 F300
G1 X-5.453 Y0.356 F7800
G1 X-0.708 Y0.356 A0.02737 F300
G1 X-0.708 Y1.589 F7800
G1 X-5.453 Y1.589 A0.02939 F300
G1 A0.02939 F60
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
