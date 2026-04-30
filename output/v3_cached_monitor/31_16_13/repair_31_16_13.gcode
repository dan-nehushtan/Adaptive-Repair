; ============================================================
; ADAPTIVE REPAIR G-CODE
; Layer 0   Z=0.400 mm
; Defects: 11
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
; >>> PHASE 1: MILL ALL BOUNDING BOXES (11)
;     Overextrusion  : 0 regions (skim excess)
;     Underextrusion : 11 regions (cut clean cavity)
;     Travel optimised: 113.5 -> 59.7 mm (47% saved)
; 
; --- Mill cavity: Underextrusion  conf=0.94 ---
;     bed region: (-4.81,-5.89) -> (3.25,2.00)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X-4.805 Y-5.890 F7800
G1 Z0.000 F600
G1 X3.248 Y-5.890 F200
G1 X3.248 Y-4.657 F200
G1 X-4.805 Y-4.657 F200
G1 X-4.805 Y-3.424 F200
G1 X3.248 Y-3.424 F200
G1 X3.248 Y-2.191 F200
G1 X-4.805 Y-2.191 F200
G1 X-4.805 Y-0.958 F200
G1 X3.248 Y-0.958 F200
G1 X3.248 Y0.275 F200
G1 X-4.805 Y0.275 F200
G1 X-4.805 Y1.508 F200
G1 X3.248 Y1.508 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.94 ---
;     bed region: (-0.69,-5.07) -> (5.61,1.17)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X-0.693 Y-5.068 F7800
G1 Z0.000 F600
G1 X5.610 Y-5.068 F200
G1 X5.610 Y-3.835 F200
G1 X-0.693 Y-3.835 F200
G1 X-0.693 Y-2.602 F200
G1 X5.610 Y-2.602 F200
G1 X5.610 Y-1.369 F200
G1 X-0.693 Y-1.369 F200
G1 X-0.693 Y-0.136 F200
G1 X5.610 Y-0.136 F200
G1 X5.610 Y1.097 F200
G1 X-0.693 Y1.097 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.95 ---
;     bed region: (0.90,-6.68) -> (8.81,1.32)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X0.900 Y-6.678 F7800
G1 Z0.000 F600
G1 X8.812 Y-6.678 F200
G1 X8.812 Y-5.444 F200
G1 X0.900 Y-5.444 F200
G1 X0.900 Y-4.211 F200
G1 X8.812 Y-4.211 F200
G1 X8.812 Y-2.978 F200
G1 X0.900 Y-2.978 F200
G1 X0.900 Y-1.745 F200
G1 X8.812 Y-1.745 F200
G1 X8.812 Y-0.512 F200
G1 X0.900 Y-0.512 F200
G1 X0.900 Y0.721 F200
G1 X8.812 Y0.721 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.93 ---
;     bed region: (2.84,-7.85) -> (7.64,-2.95)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X2.843 Y-7.850 F7800
G1 Z0.000 F600
G1 X7.640 Y-7.850 F200
G1 X7.640 Y-6.617 F200
G1 X2.843 Y-6.617 F200
G1 X2.843 Y-5.384 F200
G1 X7.640 Y-5.384 F200
G1 X7.640 Y-4.151 F200
G1 X2.843 Y-4.151 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.89 ---
;     bed region: (6.12,-7.99) -> (7.90,-6.06)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X6.115 Y-7.990 F7800
G1 Z0.000 F600
G1 X7.903 Y-7.990 F200
G1 X7.903 Y-6.757 F200
G1 X6.115 Y-6.757 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.87 ---
;     bed region: (6.82,-10.34) -> (8.59,-8.51)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X6.815 Y-10.335 F7800
G1 Z0.000 F600
G1 X8.585 Y-10.335 F200
G1 X8.585 Y-9.102 F200
G1 X6.815 Y-9.102 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.93 ---
;     bed region: (8.06,-2.55) -> (11.54,0.89)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X8.058 Y-2.548 F7800
G1 Z0.000 F600
G1 X11.543 Y-2.548 F200
G1 X11.543 Y-1.315 F200
G1 X8.058 Y-1.315 F200
G1 X8.058 Y-0.082 F200
G1 X11.543 Y-0.082 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.89 ---
;     bed region: (8.85,1.65) -> (11.19,3.81)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X8.845 Y1.653 F7800
G1 Z0.000 F600
G1 X11.193 Y1.653 F200
G1 X11.193 Y2.886 F200
G1 X8.845 Y2.886 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.87 ---
;     bed region: (5.78,1.72) -> (8.10,3.81)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X5.783 Y1.723 F7800
G1 Z0.000 F600
G1 X8.095 Y1.723 F200
G1 X8.095 Y2.956 F200
G1 X5.783 Y2.956 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.87 ---
;     bed region: (-8.43,1.83) -> (-6.33,3.76)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X-8.428 Y1.828 F7800
G1 Z0.000 F600
G1 X-6.325 Y1.828 F200
G1 X-6.325 Y3.061 F200
G1 X-8.428 Y3.061 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.89 ---
;     bed region: (-6.54,-12.80) -> (-3.81,-10.09)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X-6.538 Y-12.803 F7800
G1 Z0.000 F600
G1 X-3.805 Y-12.803 F200
G1 X-3.805 Y-11.570 F200
G1 X-6.538 Y-11.570 F200
G1 X-6.538 Y-10.337 F200
G1 X-3.805 Y-10.337 F200
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
; >>> PHASE 2: DEPOSIT INTO UNDEREXTRUSION CAVITIES (11)
;     Fill milled cavities with ceramic
;     Travel optimised: 121.3 -> 53.7 mm (56% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.89 ---
;     bed region: (-6.54,-12.80) -> (-3.81,-10.09)
G1 A0.00000 F60
G1 Z2.400 F600
G0 X-6.538 Y-12.803 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G1 X-3.805 Y-12.803 A0.00116 F300
G1 X-3.805 Y-11.570 F7800
G1 X-6.538 Y-11.570 A0.00232 F300
G1 X-6.538 Y-10.337 F7800
G1 X-3.805 Y-10.337 A0.00349 F300
G1 A0.00349 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.94 ---
;     bed region: (-4.81,-5.89) -> (3.25,2.00)
G1 A0.00349 F60
G1 Z2.400 F600
G0 X-4.805 Y-5.890 F7800
G1 Z0.400 F600
G1 A0.00349 F60
G1 X3.248 Y-5.890 A0.00691 F300
G1 X3.248 Y-4.657 F7800
G1 X-4.805 Y-4.657 A0.01034 F300
G1 X-4.805 Y-3.424 F7800
G1 X3.248 Y-3.424 A0.01376 F300
G1 X3.248 Y-2.191 F7800
G1 X-4.805 Y-2.191 A0.01719 F300
G1 X-4.805 Y-0.958 F7800
G1 X3.248 Y-0.958 A0.02061 F300
G1 X3.248 Y0.275 F7800
G1 X-4.805 Y0.275 A0.02404 F300
G1 X-4.805 Y1.508 F7800
G1 X3.248 Y1.508 A0.02746 F300
G1 A0.02746 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.94 ---
;     bed region: (-0.69,-5.07) -> (5.61,1.17)
G1 A0.02746 F60
G1 Z2.400 F600
G0 X-0.693 Y-5.068 F7800
G1 Z0.400 F600
G1 A0.02746 F60
G1 X5.610 Y-5.068 A0.03015 F300
G1 X5.610 Y-3.835 F7800
G1 X-0.693 Y-3.835 A0.03283 F300
G1 X-0.693 Y-2.602 F7800
G1 X5.610 Y-2.602 A0.03551 F300
G1 X5.610 Y-1.369 F7800
G1 X-0.693 Y-1.369 A0.03819 F300
G1 X-0.693 Y-0.136 F7800
G1 X5.610 Y-0.136 A0.04087 F300
G1 X5.610 Y1.097 F7800
G1 X-0.693 Y1.097 A0.04355 F300
G1 A0.04355 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.95 ---
;     bed region: (0.90,-6.68) -> (8.81,1.32)
G1 A0.04355 F60
G1 Z2.400 F600
G0 X0.900 Y-6.678 F7800
G1 Z0.400 F600
G1 A0.04355 F60
G1 X8.812 Y-6.678 A0.04692 F300
G1 X8.812 Y-5.444 F7800
G1 X0.900 Y-5.444 A0.05028 F300
G1 X0.900 Y-4.211 F7800
G1 X8.812 Y-4.211 A0.05365 F300
G1 X8.812 Y-2.978 F7800
G1 X0.900 Y-2.978 A0.05701 F300
G1 X0.900 Y-1.745 F7800
G1 X8.812 Y-1.745 A0.06038 F300
G1 X8.812 Y-0.512 F7800
G1 X0.900 Y-0.512 A0.06375 F300
G1 X0.900 Y0.721 F7800
G1 X8.812 Y0.721 A0.06711 F300
G1 A0.06711 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.93 ---
;     bed region: (2.84,-7.85) -> (7.64,-2.95)
G1 A0.06711 F60
G1 Z2.400 F600
G0 X2.843 Y-7.850 F7800
G1 Z0.400 F600
G1 A0.06711 F60
G1 X7.640 Y-7.850 A0.06915 F300
G1 X7.640 Y-6.617 F7800
G1 X2.843 Y-6.617 A0.07119 F300
G1 X2.843 Y-5.384 F7800
G1 X7.640 Y-5.384 A0.07323 F300
G1 X7.640 Y-4.151 F7800
G1 X2.843 Y-4.151 A0.07527 F300
G1 A0.07527 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.89 ---
;     bed region: (6.12,-7.99) -> (7.90,-6.06)
G1 A0.07527 F60
G1 Z2.400 F600
G0 X6.115 Y-7.990 F7800
G1 Z0.400 F600
G1 A0.07527 F60
G1 X7.903 Y-7.990 A0.07604 F300
G1 X7.903 Y-6.757 F7800
G1 X6.115 Y-6.757 A0.07680 F300
G1 A0.07680 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.87 ---
;     bed region: (6.82,-10.34) -> (8.59,-8.51)
G1 A0.07680 F60
G1 Z2.400 F600
G0 X6.815 Y-10.335 F7800
G1 Z0.400 F600
G1 A0.07680 F60
G1 X8.585 Y-10.335 A0.07755 F300
G1 X8.585 Y-9.102 F7800
G1 X6.815 Y-9.102 A0.07830 F300
G1 A0.07830 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.93 ---
;     bed region: (8.06,-2.55) -> (11.54,0.89)
G1 A0.07830 F60
G1 Z2.400 F600
G0 X8.058 Y-2.548 F7800
G1 Z0.400 F600
G1 A0.07830 F60
G1 X11.543 Y-2.548 A0.07978 F300
G1 X11.543 Y-1.315 F7800
G1 X8.058 Y-1.315 A0.08127 F300
G1 X8.058 Y-0.082 F7800
G1 X11.543 Y-0.082 A0.08275 F300
G1 A0.08275 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.89 ---
;     bed region: (8.85,1.65) -> (11.19,3.81)
G1 A0.08275 F60
G1 Z2.400 F600
G0 X8.845 Y1.653 F7800
G1 Z0.400 F600
G1 A0.08275 F60
G1 X11.193 Y1.653 A0.08375 F300
G1 X11.193 Y2.886 F7800
G1 X8.845 Y2.886 A0.08475 F300
G1 A0.08475 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.87 ---
;     bed region: (5.78,1.72) -> (8.10,3.81)
G1 A0.08475 F60
G1 Z2.400 F600
G0 X5.783 Y1.723 F7800
G1 Z0.400 F600
G1 A0.08475 F60
G1 X8.095 Y1.723 A0.08573 F300
G1 X8.095 Y2.956 F7800
G1 X5.783 Y2.956 A0.08671 F300
G1 A0.08671 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.87 ---
;     bed region: (-8.43,1.83) -> (-6.33,3.76)
G1 A0.08671 F60
G1 Z2.400 F600
G0 X-8.428 Y1.828 F7800
G1 Z0.400 F600
G1 A0.08671 F60
G1 X-6.325 Y1.828 A0.08761 F300
G1 X-6.325 Y3.061 F7800
G1 X-8.428 Y3.061 A0.08850 F300
G1 A0.08850 F60
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
