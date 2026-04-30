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
;     Travel optimised: 138.6 -> 88.7 mm (36% saved)
; 
; --- Mill cavity: Underextrusion  conf=0.86 ---
;     bed region: (-6.52,-5.70) -> (-4.58,-3.86)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X-6.520 Y-5.698 F7800
G1 Z0.000 F600
G1 X-4.575 Y-5.698 F200
G1 X-4.575 Y-4.465 F200
G1 X-6.520 Y-4.465 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.90 ---
;     bed region: (-8.11,-10.58) -> (-5.94,-8.41)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X-8.113 Y-10.580 F7800
G1 Z0.000 F600
G1 X-5.940 Y-10.580 F200
G1 X-5.940 Y-9.347 F200
G1 X-8.113 Y-9.347 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.90 ---
;     bed region: (-6.03,-12.38) -> (-3.21,-9.72)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X-6.030 Y-12.383 F7800
G1 Z0.000 F600
G1 X-3.210 Y-12.383 F200
G1 X-3.210 Y-11.149 F200
G1 X-6.030 Y-11.149 F200
G1 X-6.030 Y-9.916 F200
G1 X-3.210 Y-9.916 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.91 ---
;     bed region: (5.03,-5.89) -> (7.08,-3.58)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X5.030 Y-5.890 F7800
G1 Z0.000 F600
G1 X7.080 Y-5.890 F200
G1 X7.080 Y-4.657 F200
G1 X5.030 Y-4.657 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.87 ---
;     bed region: (12.75,1.36) -> (14.76,3.51)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X12.748 Y1.355 F7800
G1 Z0.000 F600
G1 X14.763 Y1.355 F200
G1 X14.763 Y2.588 F200
G1 X12.748 Y2.588 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill skim: Overextrusion  conf=0.93 ---
;     bed region: (-29.11,-29.55) -> (-25.03,-25.49)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-29.113 Y-29.550 F7800
G1 Z0.400 F600
G1 X-25.033 Y-29.550 F200
G1 X-25.033 Y-28.317 F200
G1 X-29.113 Y-28.317 F200
G1 X-29.113 Y-27.084 F200
G1 X-25.033 Y-27.084 F200
G1 X-25.033 Y-25.851 F200
G1 X-29.113 Y-25.851 F200
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
;     Travel optimised: 100.0 -> 58.3 mm (42% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.90 ---
;     bed region: (-8.11,-10.58) -> (-5.94,-8.41)
G1 A0.00000 F60
G1 Z2.400 F600
G0 X-8.113 Y-10.580 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G1 X-5.940 Y-10.580 A0.00092 F300
G1 X-5.940 Y-9.347 F7800
G1 X-8.113 Y-9.347 A0.00185 F300
G1 A0.00185 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.90 ---
;     bed region: (-6.03,-12.38) -> (-3.21,-9.72)
G1 A0.00185 F60
G1 Z2.400 F600
G0 X-6.030 Y-12.383 F7800
G1 Z0.400 F600
G1 A0.00185 F60
G1 X-3.210 Y-12.383 A0.00305 F300
G1 X-3.210 Y-11.149 F7800
G1 X-6.030 Y-11.149 A0.00425 F300
G1 X-6.030 Y-9.916 F7800
G1 X-3.210 Y-9.916 A0.00545 F300
G1 A0.00545 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.86 ---
;     bed region: (-6.52,-5.70) -> (-4.58,-3.86)
G1 A0.00545 F60
G1 Z2.400 F600
G0 X-6.520 Y-5.698 F7800
G1 Z0.400 F600
G1 A0.00545 F60
G1 X-4.575 Y-5.698 A0.00627 F300
G1 X-4.575 Y-4.465 F7800
G1 X-6.520 Y-4.465 A0.00710 F300
G1 A0.00710 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.91 ---
;     bed region: (5.03,-5.89) -> (7.08,-3.58)
G1 A0.00710 F60
G1 Z2.400 F600
G0 X5.030 Y-5.890 F7800
G1 Z0.400 F600
G1 A0.00710 F60
G1 X7.080 Y-5.890 A0.00797 F300
G1 X7.080 Y-4.657 F7800
G1 X5.030 Y-4.657 A0.00885 F300
G1 A0.00885 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.87 ---
;     bed region: (12.75,1.36) -> (14.76,3.51)
G1 A0.00885 F60
G1 Z2.400 F600
G0 X12.748 Y1.355 F7800
G1 Z0.400 F600
G1 A0.00885 F60
G1 X14.763 Y1.355 A0.00970 F300
G1 X14.763 Y2.588 F7800
G1 X12.748 Y2.588 A0.01056 F300
G1 A0.01056 F60
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
