; ============================================================
; ADAPTIVE REPAIR G-CODE
; Layer 0   Z=0.400 mm
; Defects: 7
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
; >>> PHASE 1: MILL ALL BOUNDING BOXES (7)
;     Overextrusion  : 4 regions (skim excess)
;     Underextrusion : 3 regions (cut clean cavity)
;     Travel optimised: 152.4 -> 127.9 mm (16% saved)
; 
; --- Mill skim: Overextrusion  conf=0.88 ---
;     bed region: (-3.07,-17.20) -> (-0.41,-15.29)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-3.073 Y-17.195 F7800
G1 Z0.400 F600
G1 X-0.410 Y-17.195 F200
G1 X-0.410 Y-15.962 F200
G1 X-3.073 Y-15.962 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill cavity: Underextrusion  conf=0.90 ---
;     bed region: (-9.93,-17.18) -> (-7.22,-15.39)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X-9.933 Y-17.178 F7800
G1 Z0.000 F600
G1 X-7.218 Y-17.178 F200
G1 X-7.218 Y-15.945 F200
G1 X-9.933 Y-15.945 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.89 ---
;     bed region: (-13.24,-17.21) -> (-10.63,-15.29)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X-13.240 Y-17.213 F7800
G1 Z0.000 F600
G1 X-10.630 Y-17.213 F200
G1 X-10.630 Y-15.980 F200
G1 X-13.240 Y-15.980 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill skim: Overextrusion  conf=0.94 ---
;     bed region: (-29.66,-29.64) -> (-25.00,-25.00)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-29.655 Y-29.638 F7800
G1 Z0.400 F600
G1 X-24.998 Y-29.638 F200
G1 X-24.998 Y-28.405 F200
G1 X-29.655 Y-28.405 F200
G1 X-29.655 Y-27.172 F200
G1 X-24.998 Y-27.172 F200
G1 X-24.998 Y-25.939 F200
G1 X-29.655 Y-25.939 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.88 ---
;     bed region: (6.90,-17.28) -> (10.42,-14.52)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X6.903 Y-17.283 F7800
G1 Z0.400 F600
G1 X10.423 Y-17.283 F200
G1 X10.423 Y-16.050 F200
G1 X6.903 Y-16.050 F200
G1 X6.903 Y-14.817 F200
G1 X10.423 Y-14.817 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill cavity: Underextrusion  conf=0.88 ---
;     bed region: (15.81,-14.36) -> (17.51,-12.36)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X15.810 Y-14.360 F7800
G1 Z0.000 F600
G1 X17.510 Y-14.360 F200
G1 X17.510 Y-13.127 F200
G1 X15.810 Y-13.127 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill skim: Overextrusion  conf=0.94 ---
;     bed region: (-6.75,14.17) -> (-3.65,17.09)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-6.748 Y14.165 F7800
G1 Z0.400 F600
G1 X-3.647 Y14.165 F200
G1 X-3.647 Y15.398 F200
G1 X-6.748 Y15.398 F200
G1 X-6.748 Y16.631 F200
G1 X-3.647 Y16.631 F200
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
;     Travel optimised: 64.2 -> 64.2 mm (0% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.90 ---
;     bed region: (-9.93,-17.18) -> (-7.22,-15.39)
G1 A0.00000 F60
G1 Z2.400 F600
G0 X-9.933 Y-17.178 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G1 X-7.218 Y-17.178 A0.00115 F300
G1 X-7.218 Y-15.945 F7800
G1 X-9.933 Y-15.945 A0.00231 F300
G1 A0.00231 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.89 ---
;     bed region: (-13.24,-17.21) -> (-10.63,-15.29)
G1 A0.00231 F60
G1 Z2.400 F600
G0 X-13.240 Y-17.213 F7800
G1 Z0.400 F600
G1 A0.00231 F60
G1 X-10.630 Y-17.213 A0.00342 F300
G1 X-10.630 Y-15.980 F7800
G1 X-13.240 Y-15.980 A0.00453 F300
G1 A0.00453 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.88 ---
;     bed region: (15.81,-14.36) -> (17.51,-12.36)
G1 A0.00453 F60
G1 Z2.400 F600
G0 X15.810 Y-14.360 F7800
G1 Z0.400 F600
G1 A0.00453 F60
G1 X17.510 Y-14.360 A0.00525 F300
G1 X17.510 Y-13.127 F7800
G1 X15.810 Y-13.127 A0.00598 F300
G1 A0.00598 F60
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
