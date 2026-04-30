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
;     Travel optimised: 24.9 -> 24.9 mm (0% saved)
; 
; --- Mill cavity: Underextrusion  conf=0.96 ---
;     bed region: (-12.94,-5.45) -> (-1.55,5.79)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X-12.943 Y-5.453 F7800
G1 Z0.000 F600
G1 X-1.548 Y-5.453 F200
G1 X-1.548 Y-4.220 F200
G1 X-12.943 Y-4.220 F200
G1 X-12.943 Y-2.986 F200
G1 X-1.548 Y-2.986 F200
G1 X-1.548 Y-1.753 F200
G1 X-12.943 Y-1.753 F200
G1 X-12.943 Y-0.520 F200
G1 X-1.548 Y-0.520 F200
G1 X-1.548 Y0.713 F200
G1 X-12.943 Y0.713 F200
G1 X-12.943 Y1.946 F200
G1 X-1.548 Y1.946 F200
G1 X-1.548 Y3.179 F200
G1 X-12.943 Y3.179 F200
G1 X-12.943 Y4.412 F200
G1 X-1.548 Y4.412 F200
G1 X-1.548 Y5.645 F200
G1 X-12.943 Y5.645 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.91 ---
;     bed region: (-15.20,-9.44) -> (-9.97,-4.28)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X-15.200 Y-9.443 F7800
G1 Z0.000 F600
G1 X-9.965 Y-9.443 F200
G1 X-9.965 Y-8.210 F200
G1 X-15.200 Y-8.210 F200
G1 X-15.200 Y-6.976 F200
G1 X-9.965 Y-6.976 F200
G1 X-9.965 Y-5.743 F200
G1 X-15.200 Y-5.743 F200
G1 X-15.200 Y-4.510 F200
G1 X-9.965 Y-4.510 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.86 ---
;     bed region: (-15.25,-6.12) -> (-13.47,-4.19)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X-15.253 Y-6.118 F7800
G1 Z0.000 F600
G1 X-13.465 Y-6.118 F200
G1 X-13.465 Y-4.885 F200
G1 X-15.253 Y-4.885 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.85 ---
;     bed region: (-15.15,-12.56) -> (-13.27,-10.53)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X-15.148 Y-12.558 F7800
G1 Z0.000 F600
G1 X-13.273 Y-12.558 F200
G1 X-13.273 Y-11.325 F200
G1 X-15.148 Y-11.325 F200
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
;     Travel optimised: 31.3 -> 16.3 mm (48% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.85 ---
;     bed region: (-15.15,-12.56) -> (-13.27,-10.53)
G1 A0.00000 F60
G1 Z2.400 F600
G0 X-15.148 Y-12.558 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G1 X-13.273 Y-12.558 A0.00080 F300
G1 X-13.273 Y-11.325 F7800
G1 X-15.148 Y-11.325 A0.00160 F300
G1 A0.00160 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.91 ---
;     bed region: (-15.20,-9.44) -> (-9.97,-4.28)
G1 A0.00160 F60
G1 Z2.400 F600
G0 X-15.200 Y-9.443 F7800
G1 Z0.400 F600
G1 A0.00160 F60
G1 X-9.965 Y-9.443 A0.00382 F300
G1 X-9.965 Y-8.210 F7800
G1 X-15.200 Y-8.210 A0.00605 F300
G1 X-15.200 Y-6.976 F7800
G1 X-9.965 Y-6.976 A0.00828 F300
G1 X-9.965 Y-5.743 F7800
G1 X-15.200 Y-5.743 A0.01050 F300
G1 X-15.200 Y-4.510 F7800
G1 X-9.965 Y-4.510 A0.01273 F300
G1 A0.01273 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.86 ---
;     bed region: (-15.25,-6.12) -> (-13.47,-4.19)
G1 A0.01273 F60
G1 Z2.400 F600
G0 X-15.253 Y-6.118 F7800
G1 Z0.400 F600
G1 A0.01273 F60
G1 X-13.465 Y-6.118 A0.01349 F300
G1 X-13.465 Y-4.885 F7800
G1 X-15.253 Y-4.885 A0.01425 F300
G1 A0.01425 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.96 ---
;     bed region: (-12.94,-5.45) -> (-1.55,5.79)
G1 A0.01425 F60
G1 Z2.400 F600
G0 X-12.943 Y-5.453 F7800
G1 Z0.400 F600
G1 A0.01425 F60
G1 X-1.548 Y-5.453 A0.01910 F300
G1 X-1.548 Y-4.220 F7800
G1 X-12.943 Y-4.220 A0.02394 F300
G1 X-12.943 Y-2.986 F7800
G1 X-1.548 Y-2.986 A0.02879 F300
G1 X-1.548 Y-1.753 F7800
G1 X-12.943 Y-1.753 A0.03364 F300
G1 X-12.943 Y-0.520 F7800
G1 X-1.548 Y-0.520 A0.03849 F300
G1 X-1.548 Y0.713 F7800
G1 X-12.943 Y0.713 A0.04333 F300
G1 X-12.943 Y1.946 F7800
G1 X-1.548 Y1.946 A0.04818 F300
G1 X-1.548 Y3.179 F7800
G1 X-12.943 Y3.179 A0.05303 F300
G1 X-12.943 Y4.412 F7800
G1 X-1.548 Y4.412 A0.05788 F300
G1 X-1.548 Y5.645 F7800
G1 X-12.943 Y5.645 A0.06272 F300
G1 A0.06272 F60
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
