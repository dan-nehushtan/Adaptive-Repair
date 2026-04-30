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
;     Overextrusion  : 0 regions (skim excess)
;     Underextrusion : 4 regions (cut clean cavity)
;     Travel optimised: 26.2 -> 18.3 mm (30% saved)
; 
; --- Mill cavity: Underextrusion  conf=0.93 ---
;     bed region: (0.64,-3.74) -> (6.26,1.76)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X0.638 Y-3.738 F7800
G1 Z0.000 F600
G1 X6.258 Y-3.738 F200
G1 X6.258 Y-2.505 F200
G1 X0.638 Y-2.505 F200
G1 X0.638 Y-1.272 F200
G1 X6.258 Y-1.272 F200
G1 X6.258 Y-0.038 F200
G1 X0.638 Y-0.038 F200
G1 X0.638 Y1.195 F200
G1 X6.258 Y1.195 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.93 ---
;     bed region: (2.39,-5.14) -> (8.50,0.87)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X2.388 Y-5.138 F7800
G1 Z0.000 F600
G1 X8.498 Y-5.138 F200
G1 X8.498 Y-3.905 F200
G1 X2.388 Y-3.905 F200
G1 X2.388 Y-2.671 F200
G1 X8.498 Y-2.671 F200
G1 X8.498 Y-1.438 F200
G1 X2.388 Y-1.438 F200
G1 X2.388 Y-0.205 F200
G1 X8.498 Y-0.205 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.87 ---
;     bed region: (1.97,-7.48) -> (5.49,-4.03)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X1.968 Y-7.483 F7800
G1 Z0.000 F600
G1 X5.488 Y-7.483 F200
G1 X5.488 Y-6.250 F200
G1 X1.968 Y-6.250 F200
G1 X1.968 Y-5.017 F200
G1 X5.488 Y-5.017 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.88 ---
;     bed region: (-5.05,-11.37) -> (-2.09,-8.53)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X-5.050 Y-11.368 F7800
G1 Z0.000 F600
G1 X-2.090 Y-11.368 F200
G1 X-2.090 Y-10.135 F200
G1 X-5.050 Y-10.135 F200
G1 X-5.050 Y-8.902 F200
G1 X-2.090 Y-8.902 F200
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
; >>> PHASE 2: DEPOSIT INTO UNDEREXTRUSION CAVITIES (4)
;     Fill milled cavities with ceramic
;     Travel optimised: 34.0 -> 14.7 mm (57% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.88 ---
;     bed region: (-5.05,-11.37) -> (-2.09,-8.53)
G1 A0.00000 F60
G1 Z2.400 F600
G0 X-5.050 Y-11.368 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G1 X-2.090 Y-11.368 A0.00126 F300
G1 X-2.090 Y-10.135 F7800
G1 X-5.050 Y-10.135 A0.00252 F300
G1 X-5.050 Y-8.902 F7800
G1 X-2.090 Y-8.902 A0.00378 F300
G1 A0.00378 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.87 ---
;     bed region: (1.97,-7.48) -> (5.49,-4.03)
G1 A0.00378 F60
G1 Z2.400 F600
G0 X1.968 Y-7.483 F7800
G1 Z0.400 F600
G1 A0.00378 F60
G1 X5.488 Y-7.483 A0.00527 F300
G1 X5.488 Y-6.250 F7800
G1 X1.968 Y-6.250 A0.00677 F300
G1 X1.968 Y-5.017 F7800
G1 X5.488 Y-5.017 A0.00827 F300
G1 A0.00827 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.93 ---
;     bed region: (2.39,-5.14) -> (8.50,0.87)
G1 A0.00827 F60
G1 Z2.400 F600
G0 X2.388 Y-5.138 F7800
G1 Z0.400 F600
G1 A0.00827 F60
G1 X8.498 Y-5.138 A0.01087 F300
G1 X8.498 Y-3.905 F7800
G1 X2.388 Y-3.905 A0.01347 F300
G1 X2.388 Y-2.671 F7800
G1 X8.498 Y-2.671 A0.01607 F300
G1 X8.498 Y-1.438 F7800
G1 X2.388 Y-1.438 A0.01867 F300
G1 X2.388 Y-0.205 F7800
G1 X8.498 Y-0.205 A0.02126 F300
G1 A0.02126 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.93 ---
;     bed region: (0.64,-3.74) -> (6.26,1.76)
G1 A0.02126 F60
G1 Z2.400 F600
G0 X0.638 Y-3.738 F7800
G1 Z0.400 F600
G1 A0.02126 F60
G1 X6.258 Y-3.738 A0.02366 F300
G1 X6.258 Y-2.505 F7800
G1 X0.638 Y-2.505 A0.02605 F300
G1 X0.638 Y-1.272 F7800
G1 X6.258 Y-1.272 A0.02844 F300
G1 X6.258 Y-0.038 F7800
G1 X0.638 Y-0.038 A0.03083 F300
G1 X0.638 Y1.195 F7800
G1 X6.258 Y1.195 A0.03322 F300
G1 A0.03322 F60
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
