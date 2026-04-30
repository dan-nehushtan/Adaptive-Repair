; ============================================================
; ADAPTIVE REPAIR G-CODE
; Layer 0   Z=0.400 mm
; Defects: 2
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
; >>> PHASE 1: MILL ALL BOUNDING BOXES (2)
;     Overextrusion  : 1 regions (skim excess)
;     Underextrusion : 1 regions (cut clean cavity)
;     Travel optimised: 78.2 -> 47.3 mm (39% saved)
; 
; --- Mill cavity: Underextrusion  conf=0.93 ---
;     bed region: (-4.79,-15.76) -> (15.74,4.21)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X-4.788 Y-15.760 F7800
G1 Z0.000 F600
G1 X15.743 Y-15.760 F200
G1 X15.743 Y-14.527 F200
G1 X-4.788 Y-14.527 F200
G1 X-4.788 Y-13.294 F200
G1 X15.743 Y-13.294 F200
G1 X15.743 Y-12.061 F200
G1 X-4.788 Y-12.061 F200
G1 X-4.788 Y-10.828 F200
G1 X15.743 Y-10.828 F200
G1 X15.743 Y-9.595 F200
G1 X-4.788 Y-9.595 F200
G1 X-4.788 Y-8.362 F200
G1 X15.743 Y-8.362 F200
G1 X15.743 Y-7.129 F200
G1 X-4.788 Y-7.129 F200
G1 X-4.788 Y-5.896 F200
G1 X15.743 Y-5.896 F200
G1 X15.743 Y-4.663 F200
G1 X-4.788 Y-4.663 F200
G1 X-4.788 Y-3.430 F200
G1 X15.743 Y-3.430 F200
G1 X15.743 Y-2.197 F200
G1 X-4.788 Y-2.197 F200
G1 X-4.788 Y-0.964 F200
G1 X15.743 Y-0.964 F200
G1 X15.743 Y0.269 F200
G1 X-4.788 Y0.269 F200
G1 X-4.788 Y1.502 F200
G1 X15.743 Y1.502 F200
G1 X15.743 Y2.735 F200
G1 X-4.788 Y2.735 F200
G1 X-4.788 Y3.968 F200
G1 X15.743 Y3.968 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill skim: Overextrusion  conf=0.93 ---
;     bed region: (-28.89,-29.20) -> (-25.70,-26.03)
;     mill Z=0.400 mm (layer surface)
G1 Z2.400 F600
G0 X-28.885 Y-29.200 F7800
G1 Z0.400 F600
G1 X-25.698 Y-29.200 F200
G1 X-25.698 Y-27.967 F200
G1 X-28.885 Y-27.967 F200
G1 X-28.885 Y-26.734 F200
G1 X-25.698 Y-26.734 F200
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
; >>> PHASE 2: DEPOSIT INTO UNDEREXTRUSION CAVITIES (1)
;     Fill milled cavities with ceramic
;     Travel optimised: 39.4 -> 39.4 mm (0% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.93 ---
;     bed region: (-4.79,-15.76) -> (15.74,4.21)
G1 A0.00000 F60
G1 Z2.400 F600
G0 X-4.788 Y-15.760 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G1 X15.743 Y-15.760 A0.00873 F300
G1 X15.743 Y-14.527 F7800
G1 X-4.788 Y-14.527 A0.01747 F300
G1 X-4.788 Y-13.294 F7800
G1 X15.743 Y-13.294 A0.02620 F300
G1 X15.743 Y-12.061 F7800
G1 X-4.788 Y-12.061 A0.03493 F300
G1 X-4.788 Y-10.828 F7800
G1 X15.743 Y-10.828 A0.04367 F300
G1 X15.743 Y-9.595 F7800
G1 X-4.788 Y-9.595 A0.05240 F300
G1 X-4.788 Y-8.362 F7800
G1 X15.743 Y-8.362 A0.06113 F300
G1 X15.743 Y-7.129 F7800
G1 X-4.788 Y-7.129 A0.06986 F300
G1 X-4.788 Y-5.896 F7800
G1 X15.743 Y-5.896 A0.07860 F300
G1 X15.743 Y-4.663 F7800
G1 X-4.788 Y-4.663 A0.08733 F300
G1 X-4.788 Y-3.430 F7800
G1 X15.743 Y-3.430 A0.09606 F300
G1 X15.743 Y-2.197 F7800
G1 X-4.788 Y-2.197 A0.10480 F300
G1 X-4.788 Y-0.964 F7800
G1 X15.743 Y-0.964 A0.11353 F300
G1 X15.743 Y0.269 F7800
G1 X-4.788 Y0.269 A0.12226 F300
G1 X-4.788 Y1.502 F7800
G1 X15.743 Y1.502 A0.13100 F300
G1 X15.743 Y2.735 F7800
G1 X-4.788 Y2.735 A0.13973 F300
G1 X-4.788 Y3.968 F7800
G1 X15.743 Y3.968 A0.14846 F300
G1 A0.14846 F60
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
