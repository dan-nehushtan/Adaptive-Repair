; ============================================================
; ADAPTIVE REPAIR G-CODE
; Layer 0   Z=0.400 mm
; Defects: 6
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
; >>> PHASE 1: MILL ALL BOUNDING BOXES (6)
;     Overextrusion  : 1 regions (skim excess)
;     Underextrusion : 5 regions (cut clean cavity)
;     Travel optimised: 110.4 -> 77.1 mm (30% saved)
; 
; --- Mill cavity: Underextrusion  conf=0.92 ---
;     bed region: (-9.44,-0.03) -> (-5.71,3.65)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X-9.443 Y-0.027 F7800
G1 Z0.000 F600
G1 X-5.713 Y-0.027 F200
G1 X-5.713 Y1.206 F200
G1 X-9.443 Y1.206 F200
G1 X-9.443 Y2.439 F200
G1 X-5.713 Y2.439 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.95 ---
;     bed region: (-13.66,0.67) -> (-5.47,8.92)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X-13.660 Y0.673 F7800
G1 Z0.000 F600
G1 X-5.468 Y0.673 F200
G1 X-5.468 Y1.906 F200
G1 X-13.660 Y1.906 F200
G1 X-13.660 Y3.139 F200
G1 X-5.468 Y3.139 F200
G1 X-5.468 Y4.372 F200
G1 X-13.660 Y4.372 F200
G1 X-13.660 Y5.605 F200
G1 X-5.468 Y5.605 F200
G1 X-5.468 Y6.838 F200
G1 X-13.660 Y6.838 F200
G1 X-13.660 Y8.071 F200
G1 X-5.468 Y8.071 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.90 ---
;     bed region: (-13.19,4.33) -> (-7.92,9.71)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X-13.188 Y4.330 F7800
G1 Z0.000 F600
G1 X-7.918 Y4.330 F200
G1 X-7.918 Y5.563 F200
G1 X-13.188 Y5.563 F200
G1 X-13.188 Y6.796 F200
G1 X-7.918 Y6.796 F200
G1 X-7.918 Y8.029 F200
G1 X-13.188 Y8.029 F200
G1 X-13.188 Y9.262 F200
G1 X-7.918 Y9.262 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.93 ---
;     bed region: (-7.61,3.60) -> (-3.49,7.62)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X-7.605 Y3.595 F7800
G1 Z0.000 F600
G1 X-3.490 Y3.595 F200
G1 X-3.490 Y4.828 F200
G1 X-7.605 Y4.828 F200
G1 X-7.605 Y6.061 F200
G1 X-3.490 Y6.061 F200
G1 X-3.490 Y7.294 F200
G1 X-7.605 Y7.294 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.87 ---
;     bed region: (6.36,-4.12) -> (8.66,-2.09)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X6.360 Y-4.123 F7800
G1 Z0.000 F600
G1 X8.655 Y-4.123 F200
G1 X8.655 Y-2.890 F200
G1 X6.360 Y-2.890 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill skim: Overextrusion  conf=0.93 ---
;     bed region: (-28.97,-28.99) -> (-25.70,-25.63)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-28.973 Y-28.990 F7800
G1 Z0.400 F600
G1 X-25.698 Y-28.990 F200
G1 X-25.698 Y-27.757 F200
G1 X-28.973 Y-27.757 F200
G1 X-28.973 Y-26.524 F200
G1 X-25.698 Y-26.524 F200
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
; >>> PHASE 2: DEPOSIT INTO UNDEREXTRUSION CAVITIES (5)
;     Fill milled cavities with ceramic
;     Travel optimised: 71.8 -> 62.1 mm (14% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.92 ---
;     bed region: (-9.44,-0.03) -> (-5.71,3.65)
G1 A0.00000 F60
G1 Z2.400 F600
G0 X-9.443 Y-0.027 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G1 X-5.713 Y-0.027 A0.00159 F300
G1 X-5.713 Y1.206 F7800
G1 X-9.443 Y1.206 A0.00317 F300
G1 X-9.443 Y2.439 F7800
G1 X-5.713 Y2.439 A0.00476 F300
G1 A0.00476 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.95 ---
;     bed region: (-13.66,0.67) -> (-5.47,8.92)
G1 A0.00476 F60
G1 Z2.400 F600
G0 X-13.660 Y0.673 F7800
G1 Z0.400 F600
G1 A0.00476 F60
G1 X-5.468 Y0.673 A0.00824 F300
G1 X-5.468 Y1.906 F7800
G1 X-13.660 Y1.906 A0.01173 F300
G1 X-13.660 Y3.139 F7800
G1 X-5.468 Y3.139 A0.01521 F300
G1 X-5.468 Y4.372 F7800
G1 X-13.660 Y4.372 A0.01870 F300
G1 X-13.660 Y5.605 F7800
G1 X-5.468 Y5.605 A0.02218 F300
G1 X-5.468 Y6.838 F7800
G1 X-13.660 Y6.838 A0.02567 F300
G1 X-13.660 Y8.071 F7800
G1 X-5.468 Y8.071 A0.02915 F300
G1 A0.02915 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.90 ---
;     bed region: (-13.19,4.33) -> (-7.92,9.71)
G1 A0.02915 F60
G1 Z2.400 F600
G0 X-13.188 Y4.330 F7800
G1 Z0.400 F600
G1 A0.02915 F60
G1 X-7.918 Y4.330 A0.03140 F300
G1 X-7.918 Y5.563 F7800
G1 X-13.188 Y5.563 A0.03364 F300
G1 X-13.188 Y6.796 F7800
G1 X-7.918 Y6.796 A0.03588 F300
G1 X-7.918 Y8.029 F7800
G1 X-13.188 Y8.029 A0.03812 F300
G1 X-13.188 Y9.262 F7800
G1 X-7.918 Y9.262 A0.04036 F300
G1 A0.04036 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.93 ---
;     bed region: (-7.61,3.60) -> (-3.49,7.62)
G1 A0.04036 F60
G1 Z2.400 F600
G0 X-7.605 Y3.595 F7800
G1 Z0.400 F600
G1 A0.04036 F60
G1 X-3.490 Y3.595 A0.04211 F300
G1 X-3.490 Y4.828 F7800
G1 X-7.605 Y4.828 A0.04386 F300
G1 X-7.605 Y6.061 F7800
G1 X-3.490 Y6.061 A0.04561 F300
G1 X-3.490 Y7.294 F7800
G1 X-7.605 Y7.294 A0.04737 F300
G1 A0.04737 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.87 ---
;     bed region: (6.36,-4.12) -> (8.66,-2.09)
G1 A0.04737 F60
G1 Z2.400 F600
G0 X6.360 Y-4.123 F7800
G1 Z0.400 F600
G1 A0.04737 F60
G1 X8.655 Y-4.123 A0.04834 F300
G1 X8.655 Y-2.890 F7800
G1 X6.360 Y-2.890 A0.04932 F300
G1 A0.04932 F60
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
