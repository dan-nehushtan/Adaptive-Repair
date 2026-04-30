; ============================================================
; ADAPTIVE REPAIR G-CODE
; Layer 0   Z=0.400 mm
; Defects: 8
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
; >>> PHASE 1: MILL ALL BOUNDING BOXES (8)
;     Overextrusion  : 0 regions (skim excess)
;     Underextrusion : 8 regions (cut clean cavity)
;     Travel optimised: 64.8 -> 42.0 mm (35% saved)
; 
; --- Mill cavity: Underextrusion  conf=0.93 ---
;     bed region: (-3.27,-1.39) -> (1.80,3.69)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X-3.265 Y-1.393 F7800
G1 Z0.000 F600
G1 X1.795 Y-1.393 F200
G1 X1.795 Y-0.159 F200
G1 X-3.265 Y-0.159 F200
G1 X-3.265 Y1.074 F200
G1 X1.795 Y1.074 F200
G1 X1.795 Y2.307 F200
G1 X-3.265 Y2.307 F200
G1 X-3.265 Y3.540 F200
G1 X1.795 Y3.540 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.95 ---
;     bed region: (-7.05,-8.32) -> (1.29,-0.06)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X-7.045 Y-8.323 F7800
G1 Z0.000 F600
G1 X1.288 Y-8.323 F200
G1 X1.288 Y-7.090 F200
G1 X-7.045 Y-7.090 F200
G1 X-7.045 Y-5.857 F200
G1 X1.288 Y-5.857 F200
G1 X1.288 Y-4.623 F200
G1 X-7.045 Y-4.623 F200
G1 X-7.045 Y-3.390 F200
G1 X1.288 Y-3.390 F200
G1 X1.288 Y-2.157 F200
G1 X-7.045 Y-2.157 F200
G1 X-7.045 Y-0.924 F200
G1 X1.288 Y-0.924 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.93 ---
;     bed region: (-10.13,-5.05) -> (-5.42,-0.41)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X-10.125 Y-5.050 F7800
G1 Z0.000 F600
G1 X-5.415 Y-5.050 F200
G1 X-5.415 Y-3.817 F200
G1 X-10.125 Y-3.817 F200
G1 X-10.125 Y-2.584 F200
G1 X-5.415 Y-2.584 F200
G1 X-5.415 Y-1.351 F200
G1 X-10.125 Y-1.351 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.96 ---
;     bed region: (-11.32,-3.02) -> (-4.38,3.84)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X-11.315 Y-3.020 F7800
G1 Z0.000 F600
G1 X-4.383 Y-3.020 F200
G1 X-4.383 Y-1.787 F200
G1 X-11.315 Y-1.787 F200
G1 X-11.315 Y-0.554 F200
G1 X-4.383 Y-0.554 F200
G1 X-4.383 Y0.679 F200
G1 X-11.315 Y0.679 F200
G1 X-11.315 Y1.912 F200
G1 X-4.383 Y1.912 F200
G1 X-4.383 Y3.145 F200
G1 X-11.315 Y3.145 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.91 ---
;     bed region: (-13.22,-1.81) -> (-8.46,3.06)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X-13.223 Y-1.813 F7800
G1 Z0.000 F600
G1 X-8.460 Y-1.813 F200
G1 X-8.460 Y-0.580 F200
G1 X-13.223 Y-0.580 F200
G1 X-13.223 Y0.653 F200
G1 X-8.460 Y0.653 F200
G1 X-8.460 Y1.887 F200
G1 X-13.223 Y1.887 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.90 ---
;     bed region: (-12.09,-8.67) -> (-8.97,-5.45)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X-12.085 Y-8.673 F7800
G1 Z0.000 F600
G1 X-8.968 Y-8.673 F200
G1 X-8.968 Y-7.440 F200
G1 X-12.085 Y-7.440 F200
G1 X-12.085 Y-6.207 F200
G1 X-8.968 Y-6.207 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.90 ---
;     bed region: (-4.84,-11.12) -> (-2.23,-8.60)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X-4.840 Y-11.123 F7800
G1 Z0.000 F600
G1 X-2.230 Y-11.123 F200
G1 X-2.230 Y-9.889 F200
G1 X-4.840 Y-9.889 F200
G1 X-4.840 Y-8.656 F200
G1 X-2.230 Y-8.656 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.91 ---
;     bed region: (2.11,-7.34) -> (5.40,-4.12)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X2.108 Y-7.343 F7800
G1 Z0.000 F600
G1 X5.400 Y-7.343 F200
G1 X5.400 Y-6.110 F200
G1 X2.108 Y-6.110 F200
G1 X2.108 Y-4.877 F200
G1 X5.400 Y-4.877 F200
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
; >>> PHASE 2: DEPOSIT INTO UNDEREXTRUSION CAVITIES (8)
;     Fill milled cavities with ceramic
;     Travel optimised: 70.1 -> 44.6 mm (36% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.91 ---
;     bed region: (2.11,-7.34) -> (5.40,-4.12)
G1 A0.00000 F60
G1 Z2.400 F600
G0 X2.108 Y-7.343 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G1 X5.400 Y-7.343 A0.00140 F300
G1 X5.400 Y-6.110 F7800
G1 X2.108 Y-6.110 A0.00280 F300
G1 X2.108 Y-4.877 F7800
G1 X5.400 Y-4.877 A0.00420 F300
G1 A0.00420 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.95 ---
;     bed region: (-7.05,-8.32) -> (1.29,-0.06)
G1 A0.00420 F60
G1 Z2.400 F600
G0 X-7.045 Y-8.323 F7800
G1 Z0.400 F600
G1 A0.00420 F60
G1 X1.288 Y-8.323 A0.00775 F300
G1 X1.288 Y-7.090 F7800
G1 X-7.045 Y-7.090 A0.01129 F300
G1 X-7.045 Y-5.857 F7800
G1 X1.288 Y-5.857 A0.01484 F300
G1 X1.288 Y-4.623 F7800
G1 X-7.045 Y-4.623 A0.01838 F300
G1 X-7.045 Y-3.390 F7800
G1 X1.288 Y-3.390 A0.02192 F300
G1 X1.288 Y-2.157 F7800
G1 X-7.045 Y-2.157 A0.02547 F300
G1 X-7.045 Y-0.924 F7800
G1 X1.288 Y-0.924 A0.02901 F300
G1 A0.02901 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.93 ---
;     bed region: (-10.13,-5.05) -> (-5.42,-0.41)
G1 A0.02901 F60
G1 Z2.400 F600
G0 X-10.125 Y-5.050 F7800
G1 Z0.400 F600
G1 A0.02901 F60
G1 X-5.415 Y-5.050 A0.03102 F300
G1 X-5.415 Y-3.817 F7800
G1 X-10.125 Y-3.817 A0.03302 F300
G1 X-10.125 Y-2.584 F7800
G1 X-5.415 Y-2.584 A0.03502 F300
G1 X-5.415 Y-1.351 F7800
G1 X-10.125 Y-1.351 A0.03703 F300
G1 A0.03703 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.96 ---
;     bed region: (-11.32,-3.02) -> (-4.38,3.84)
G1 A0.03703 F60
G1 Z2.400 F600
G0 X-11.315 Y-3.020 F7800
G1 Z0.400 F600
G1 A0.03703 F60
G1 X-4.383 Y-3.020 A0.03998 F300
G1 X-4.383 Y-1.787 F7800
G1 X-11.315 Y-1.787 A0.04293 F300
G1 X-11.315 Y-0.554 F7800
G1 X-4.383 Y-0.554 A0.04587 F300
G1 X-4.383 Y0.679 F7800
G1 X-11.315 Y0.679 A0.04882 F300
G1 X-11.315 Y1.912 F7800
G1 X-4.383 Y1.912 A0.05177 F300
G1 X-4.383 Y3.145 F7800
G1 X-11.315 Y3.145 A0.05472 F300
G1 A0.05472 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.91 ---
;     bed region: (-13.22,-1.81) -> (-8.46,3.06)
G1 A0.05472 F60
G1 Z2.400 F600
G0 X-13.223 Y-1.813 F7800
G1 Z0.400 F600
G1 A0.05472 F60
G1 X-8.460 Y-1.813 A0.05675 F300
G1 X-8.460 Y-0.580 F7800
G1 X-13.223 Y-0.580 A0.05877 F300
G1 X-13.223 Y0.653 F7800
G1 X-8.460 Y0.653 A0.06080 F300
G1 X-8.460 Y1.887 F7800
G1 X-13.223 Y1.887 A0.06282 F300
G1 A0.06282 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.90 ---
;     bed region: (-12.09,-8.67) -> (-8.97,-5.45)
G1 A0.06282 F60
G1 Z2.400 F600
G0 X-12.085 Y-8.673 F7800
G1 Z0.400 F600
G1 A0.06282 F60
G1 X-8.968 Y-8.673 A0.06415 F300
G1 X-8.968 Y-7.440 F7800
G1 X-12.085 Y-7.440 A0.06548 F300
G1 X-12.085 Y-6.207 F7800
G1 X-8.968 Y-6.207 A0.06680 F300
G1 A0.06680 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.90 ---
;     bed region: (-4.84,-11.12) -> (-2.23,-8.60)
G1 A0.06680 F60
G1 Z2.400 F600
G0 X-4.840 Y-11.123 F7800
G1 Z0.400 F600
G1 A0.06680 F60
G1 X-2.230 Y-11.123 A0.06791 F300
G1 X-2.230 Y-9.889 F7800
G1 X-4.840 Y-9.889 A0.06902 F300
G1 X-4.840 Y-8.656 F7800
G1 X-2.230 Y-8.656 A0.07013 F300
G1 A0.07013 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.93 ---
;     bed region: (-3.27,-1.39) -> (1.80,3.69)
G1 A0.07013 F60
G1 Z2.400 F600
G0 X-3.265 Y-1.393 F7800
G1 Z0.400 F600
G1 A0.07013 F60
G1 X1.795 Y-1.393 A0.07229 F300
G1 X1.795 Y-0.159 F7800
G1 X-3.265 Y-0.159 A0.07444 F300
G1 X-3.265 Y1.074 F7800
G1 X1.795 Y1.074 A0.07659 F300
G1 X1.795 Y2.307 F7800
G1 X-3.265 Y2.307 A0.07874 F300
G1 X-3.265 Y3.540 F7800
G1 X1.795 Y3.540 A0.08090 F300
G1 A0.08090 F60
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
