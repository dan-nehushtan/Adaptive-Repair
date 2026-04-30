; ============================================================
; ADAPTIVE REPAIR G-CODE
; Layer 0   Z=0.400 mm
; Defects: 13
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
; >>> PHASE 1: MILL ALL BOUNDING BOXES (13)
;     Overextrusion  : 1 regions (skim excess)
;     Underextrusion : 12 regions (cut clean cavity)
;     Travel optimised: 238.2 -> 88.8 mm (63% saved)
; 
; --- Mill cavity: Underextrusion  conf=0.91 ---
;     bed region: (-4.20,0.45) -> (-0.48,4.14)
G1 Z2.400 F600
G0 X-4.202 Y0.452 F7800
G1 Z0.400 F600
G1 X-0.484 Y0.452 F200
G1 X-0.484 Y1.685 F200
G1 X-4.202 Y1.685 F200
G1 X-4.202 Y2.918 F200
G1 X-0.484 Y2.918 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.87 ---
;     bed region: (-3.55,2.84) -> (-0.95,5.43)
G1 Z2.400 F600
G0 X-3.551 Y2.836 F7800
G1 Z0.400 F600
G1 X-0.950 Y2.836 F200
G1 X-0.950 Y4.069 F200
G1 X-3.551 Y4.069 F200
G1 X-3.551 Y5.302 F200
G1 X-0.950 Y5.302 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.87 ---
;     bed region: (-5.73,0.64) -> (-3.62,2.71)
G1 Z2.400 F600
G0 X-5.732 Y0.639 F7800
G1 Z0.400 F600
G1 X-3.621 Y0.639 F200
G1 X-3.621 Y1.872 F200
G1 X-5.732 Y1.872 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.91 ---
;     bed region: (-8.40,-2.02) -> (-4.85,1.53)
G1 Z2.400 F600
G0 X-8.399 Y-2.019 F7800
G1 Z0.400 F600
G1 X-4.846 Y-2.019 F200
G1 X-4.846 Y-0.786 F200
G1 X-8.399 Y-0.786 F200
G1 X-8.399 Y0.447 F200
G1 X-4.846 Y0.447 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.92 ---
;     bed region: (-0.78,3.93) -> (2.96,7.63)
G1 Z2.400 F600
G0 X-0.781 Y3.928 F7800
G1 Z0.400 F600
G1 X2.959 Y3.928 F200
G1 X2.959 Y5.161 F200
G1 X-0.781 Y5.161 F200
G1 X-0.781 Y6.394 F200
G1 X2.959 Y6.394 F200
G1 X2.959 Y7.627 F200
G1 X-0.781 Y7.627 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.86 ---
;     bed region: (-0.64,5.77) -> (1.86,8.23)
G1 Z2.400 F600
G0 X-0.636 Y5.768 F7800
G1 Z0.400 F600
G1 X1.861 Y5.768 F200
G1 X1.861 Y7.001 F200
G1 X-0.636 Y7.001 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.87 ---
;     bed region: (2.48,8.91) -> (4.44,10.84)
G1 Z2.400 F600
G0 X2.476 Y8.907 F7800
G1 Z0.400 F600
G1 X4.438 Y8.907 F200
G1 X4.438 Y10.140 F200
G1 X2.476 Y10.140 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.89 ---
;     bed region: (3.35,8.06) -> (6.06,10.77)
G1 Z2.400 F600
G0 X3.354 Y8.060 F7800
G1 Z0.400 F600
G1 X6.060 Y8.060 F200
G1 X6.060 Y9.293 F200
G1 X3.354 Y9.293 F200
G1 X3.354 Y10.526 F200
G1 X6.060 Y10.526 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.86 ---
;     bed region: (5.47,8.70) -> (7.61,10.77)
G1 Z2.400 F600
G0 X5.469 Y8.700 F7800
G1 Z0.400 F600
G1 X7.607 Y8.700 F200
G1 X7.607 Y9.933 F200
G1 X5.469 Y9.933 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.90 ---
;     bed region: (6.98,10.08) -> (9.91,13.06)
G1 Z2.400 F600
G0 X6.977 Y10.077 F7800
G1 Z0.400 F600
G1 X9.911 Y10.077 F200
G1 X9.911 Y11.310 F200
G1 X6.977 Y11.310 F200
G1 X6.977 Y12.543 F200
G1 X9.911 Y12.543 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.85 ---
;     bed region: (-12.89,-17.74) -> (-10.70,-16.05)
G1 Z2.400 F600
G0 X-12.889 Y-17.737 F7800
G1 Z0.400 F600
G1 X-10.704 Y-17.737 F200
G1 X-10.704 Y-16.504 F200
G1 X-12.889 Y-16.504 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.87 ---
;     bed region: (-17.50,-16.05) -> (-15.46,-13.75)
G1 Z2.400 F600
G0 X-17.502 Y-16.046 F7800
G1 Z0.400 F600
G1 X-15.458 Y-16.046 F200
G1 X-15.458 Y-14.813 F200
G1 X-17.502 Y-14.813 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill skim: Overextrusion  conf=0.90 ---
;     bed region: (-28.86,-29.19) -> (-25.43,-25.73)
G1 Z2.400 F600
G0 X-28.856 Y-29.185 F7800
G1 Z0.400 F600
G1 X-25.430 Y-29.185 F200
G1 X-25.430 Y-27.952 F200
G1 X-28.856 Y-27.952 F200
G1 X-28.856 Y-26.719 F200
G1 X-25.430 Y-26.719 F200
G1 Z2.400 F600
; --- end mill skim ---

G1 Z2.400 F600
M5  ; spindle off after milling
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
; >>> PHASE 2: DEPOSIT INTO UNDEREXTRUSION CAVITIES (12)
;     Fill milled cavities with ceramic
;     Travel optimised: 199.6 -> 60.9 mm (69% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.87 ---
;     bed region: (-17.50,-16.05) -> (-15.46,-13.75)
G1 A0.00000 F60
G1 Z2.400 F600
G0 X-17.502 Y-16.046 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G1 X-15.458 Y-16.046 A0.00087 F300
G1 X-15.458 Y-14.813 F7800
G1 X-17.502 Y-14.813 A0.00174 F300
G1 A0.00174 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.85 ---
;     bed region: (-12.89,-17.74) -> (-10.70,-16.05)
G1 A0.00174 F60
G1 Z2.400 F600
G0 X-12.889 Y-17.737 F7800
G1 Z0.400 F600
G1 A0.00174 F60
G1 X-10.704 Y-17.737 A0.00267 F300
G1 X-10.704 Y-16.504 F7800
G1 X-12.889 Y-16.504 A0.00360 F300
G1 A0.00360 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.91 ---
;     bed region: (-8.40,-2.02) -> (-4.85,1.53)
G1 A0.00360 F60
G1 Z2.400 F600
G0 X-8.399 Y-2.019 F7800
G1 Z0.400 F600
G1 A0.00360 F60
G1 X-4.846 Y-2.019 A0.00511 F300
G1 X-4.846 Y-0.786 F7800
G1 X-8.399 Y-0.786 A0.00662 F300
G1 X-8.399 Y0.447 F7800
G1 X-4.846 Y0.447 A0.00813 F300
G1 A0.00813 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.87 ---
;     bed region: (-5.73,0.64) -> (-3.62,2.71)
G1 A0.00813 F60
G1 Z2.400 F600
G0 X-5.732 Y0.639 F7800
G1 Z0.400 F600
G1 A0.00813 F60
G1 X-3.621 Y0.639 A0.00903 F300
G1 X-3.621 Y1.872 F7800
G1 X-5.732 Y1.872 A0.00993 F300
G1 A0.00993 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.91 ---
;     bed region: (-4.20,0.45) -> (-0.48,4.14)
G1 A0.00993 F60
G1 Z2.400 F600
G0 X-4.202 Y0.452 F7800
G1 Z0.400 F600
G1 A0.00993 F60
G1 X-0.484 Y0.452 A0.01151 F300
G1 X-0.484 Y1.685 F7800
G1 X-4.202 Y1.685 A0.01309 F300
G1 X-4.202 Y2.918 F7800
G1 X-0.484 Y2.918 A0.01467 F300
G1 A0.01467 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.87 ---
;     bed region: (-3.55,2.84) -> (-0.95,5.43)
G1 A0.01467 F60
G1 Z2.400 F600
G0 X-3.551 Y2.836 F7800
G1 Z0.400 F600
G1 A0.01467 F60
G1 X-0.950 Y2.836 A0.01578 F300
G1 X-0.950 Y4.069 F7800
G1 X-3.551 Y4.069 A0.01689 F300
G1 X-3.551 Y5.302 F7800
G1 X-0.950 Y5.302 A0.01799 F300
G1 A0.01799 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.92 ---
;     bed region: (-0.78,3.93) -> (2.96,7.63)
G1 A0.01799 F60
G1 Z2.400 F600
G0 X-0.781 Y3.928 F7800
G1 Z0.400 F600
G1 A0.01799 F60
G1 X2.959 Y3.928 A0.01958 F300
G1 X2.959 Y5.161 F7800
G1 X-0.781 Y5.161 A0.02117 F300
G1 X-0.781 Y6.394 F7800
G1 X2.959 Y6.394 A0.02276 F300
G1 X2.959 Y7.627 F7800
G1 X-0.781 Y7.627 A0.02436 F300
G1 A0.02436 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.86 ---
;     bed region: (-0.64,5.77) -> (1.86,8.23)
G1 A0.02436 F60
G1 Z2.400 F600
G0 X-0.636 Y5.768 F7800
G1 Z0.400 F600
G1 A0.02436 F60
G1 X1.861 Y5.768 A0.02542 F300
G1 X1.861 Y7.001 F7800
G1 X-0.636 Y7.001 A0.02648 F300
G1 A0.02648 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.87 ---
;     bed region: (2.48,8.91) -> (4.44,10.84)
G1 A0.02648 F60
G1 Z2.400 F600
G0 X2.476 Y8.907 F7800
G1 Z0.400 F600
G1 A0.02648 F60
G1 X4.438 Y8.907 A0.02732 F300
G1 X4.438 Y10.140 F7800
G1 X2.476 Y10.140 A0.02815 F300
G1 A0.02815 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.89 ---
;     bed region: (3.35,8.06) -> (6.06,10.77)
G1 A0.02815 F60
G1 Z2.400 F600
G0 X3.354 Y8.060 F7800
G1 Z0.400 F600
G1 A0.02815 F60
G1 X6.060 Y8.060 A0.02930 F300
G1 X6.060 Y9.293 F7800
G1 X3.354 Y9.293 A0.03045 F300
G1 X3.354 Y10.526 F7800
G1 X6.060 Y10.526 A0.03160 F300
G1 A0.03160 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.86 ---
;     bed region: (5.47,8.70) -> (7.61,10.77)
G1 A0.03160 F60
G1 Z2.400 F600
G0 X5.469 Y8.700 F7800
G1 Z0.400 F600
G1 A0.03160 F60
G1 X7.607 Y8.700 A0.03251 F300
G1 X7.607 Y9.933 F7800
G1 X5.469 Y9.933 A0.03342 F300
G1 A0.03342 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.90 ---
;     bed region: (6.98,10.08) -> (9.91,13.06)
G1 A0.03342 F60
G1 Z2.400 F600
G0 X6.977 Y10.077 F7800
G1 Z0.400 F600
G1 A0.03342 F60
G1 X9.911 Y10.077 A0.03467 F300
G1 X9.911 Y11.310 F7800
G1 X6.977 Y11.310 A0.03592 F300
G1 X6.977 Y12.543 F7800
G1 X9.911 Y12.543 A0.03717 F300
G1 A0.03717 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
