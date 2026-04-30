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
;     Travel optimised: 93.7 -> 44.1 mm (53% saved)
; 
; --- Mill cavity: Underextrusion  conf=0.94 ---
;     bed region: (-5.49,-2.00) -> (2.43,5.52)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X-5.488 Y-2.005 F7800
G1 Z0.000 F600
G1 X2.425 Y-2.005 F200
G1 X2.425 Y-0.772 F200
G1 X-5.488 Y-0.772 F200
G1 X-5.488 Y0.461 F200
G1 X2.425 Y0.461 F200
G1 X2.425 Y1.694 F200
G1 X-5.488 Y1.694 F200
G1 X-5.488 Y2.927 F200
G1 X2.425 Y2.927 F200
G1 X2.425 Y4.160 F200
G1 X-5.488 Y4.160 F200
G1 X-5.488 Y5.393 F200
G1 X2.425 Y5.393 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.93 ---
;     bed region: (-9.90,-1.31) -> (-5.71,2.93)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X-9.898 Y-1.305 F7800
G1 Z0.000 F600
G1 X-5.713 Y-1.305 F200
G1 X-5.713 Y-0.072 F200
G1 X-9.898 Y-0.072 F200
G1 X-9.898 Y1.161 F200
G1 X-5.713 Y1.161 F200
G1 X-5.713 Y2.394 F200
G1 X-9.898 Y2.394 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.92 ---
;     bed region: (-11.96,-10.28) -> (-7.85,-6.13)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X-11.963 Y-10.283 F7800
G1 Z0.000 F600
G1 X-7.848 Y-10.283 F200
G1 X-7.848 Y-9.050 F200
G1 X-11.963 Y-9.050 F200
G1 X-11.963 Y-7.816 F200
G1 X-7.848 Y-7.816 F200
G1 X-7.848 Y-6.583 F200
G1 X-11.963 Y-6.583 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill skim: Overextrusion  conf=0.94 ---
;     bed region: (-29.29,-29.46) -> (-25.56,-25.73)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-29.288 Y-29.463 F7800
G1 Z0.400 F600
G1 X-25.558 Y-29.463 F200
G1 X-25.558 Y-28.230 F200
G1 X-29.288 Y-28.230 F200
G1 X-29.288 Y-26.997 F200
G1 X-25.558 Y-26.997 F200
G1 X-25.558 Y-25.764 F200
G1 X-29.288 Y-25.764 F200
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
;     Travel optimised: 54.7 -> 41.7 mm (24% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.92 ---
;     bed region: (-11.96,-10.28) -> (-7.85,-6.13)
G1 A0.00000 F60
G1 Z2.400 F600
G0 X-11.963 Y-10.283 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G1 X-7.848 Y-10.283 A0.00175 F300
G1 X-7.848 Y-9.050 F7800
G1 X-11.963 Y-9.050 A0.00350 F300
G1 X-11.963 Y-7.816 F7800
G1 X-7.848 Y-7.816 A0.00525 F300
G1 X-7.848 Y-6.583 F7800
G1 X-11.963 Y-6.583 A0.00700 F300
G1 A0.00700 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.93 ---
;     bed region: (-9.90,-1.31) -> (-5.71,2.93)
G1 A0.00700 F60
G1 Z2.400 F600
G0 X-9.898 Y-1.305 F7800
G1 Z0.400 F600
G1 A0.00700 F60
G1 X-5.713 Y-1.305 A0.00878 F300
G1 X-5.713 Y-0.072 F7800
G1 X-9.898 Y-0.072 A0.01056 F300
G1 X-9.898 Y1.161 F7800
G1 X-5.713 Y1.161 A0.01234 F300
G1 X-5.713 Y2.394 F7800
G1 X-9.898 Y2.394 A0.01412 F300
G1 A0.01412 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.94 ---
;     bed region: (-5.49,-2.00) -> (2.43,5.52)
G1 A0.01412 F60
G1 Z2.400 F600
G0 X-5.488 Y-2.005 F7800
G1 Z0.400 F600
G1 A0.01412 F60
G1 X2.425 Y-2.005 A0.01749 F300
G1 X2.425 Y-0.772 F7800
G1 X-5.488 Y-0.772 A0.02085 F300
G1 X-5.488 Y0.461 F7800
G1 X2.425 Y0.461 A0.02422 F300
G1 X2.425 Y1.694 F7800
G1 X-5.488 Y1.694 A0.02759 F300
G1 X-5.488 Y2.927 F7800
G1 X2.425 Y2.927 A0.03095 F300
G1 X2.425 Y4.160 F7800
G1 X-5.488 Y4.160 A0.03432 F300
G1 X-5.488 Y5.393 F7800
G1 X2.425 Y5.393 A0.03768 F300
G1 A0.03768 F60
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
