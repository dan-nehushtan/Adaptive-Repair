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
;     Travel optimised: 61.2 -> 56.4 mm (8% saved)
; 
; --- Mill cavity: Underextrusion  conf=0.94 ---
;     bed region: (3.49,-6.38) -> (11.47,1.80)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X3.490 Y-6.380 F7800
G1 Z0.000 F600
G1 X11.473 Y-6.380 F200
G1 X11.473 Y-5.147 F200
G1 X3.490 Y-5.147 F200
G1 X3.490 Y-3.914 F200
G1 X11.473 Y-3.914 F200
G1 X11.473 Y-2.681 F200
G1 X3.490 Y-2.681 F200
G1 X3.490 Y-1.448 F200
G1 X11.473 Y-1.448 F200
G1 X11.473 Y-0.215 F200
G1 X3.490 Y-0.215 F200
G1 X3.490 Y1.018 F200
G1 X11.473 Y1.018 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.95 ---
;     bed region: (-5.84,-14.06) -> (2.16,-6.01)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X-5.838 Y-14.063 F7800
G1 Z0.000 F600
G1 X2.163 Y-14.063 F200
G1 X2.163 Y-12.830 F200
G1 X-5.838 Y-12.830 F200
G1 X-5.838 Y-11.597 F200
G1 X2.163 Y-11.597 F200
G1 X2.163 Y-10.364 F200
G1 X-5.838 Y-10.364 F200
G1 X-5.838 Y-9.130 F200
G1 X2.163 Y-9.130 F200
G1 X2.163 Y-7.897 F200
G1 X-5.838 Y-7.897 F200
G1 X-5.838 Y-6.664 F200
G1 X2.163 Y-6.664 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.86 ---
;     bed region: (-17.56,2.93) -> (-15.92,4.79)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X-17.562 Y2.930 F7800
G1 Z0.000 F600
G1 X-15.915 Y2.930 F200
G1 X-15.915 Y4.163 F200
G1 X-17.562 Y4.163 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.88 ---
;     bed region: (-7.33,15.02) -> (-5.19,16.97)
;     mill Z=0.000 mm (pocket floor)
G1 Z2.400 F600
G0 X-7.325 Y15.023 F7800
G1 Z0.000 F600
G1 X-5.188 Y15.023 F200
G1 X-5.188 Y16.256 F200
G1 X-7.325 Y16.256 F200
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
;     Travel optimised: 77.4 -> 48.5 mm (37% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.88 ---
;     bed region: (-7.33,15.02) -> (-5.19,16.97)
G1 A0.00000 F60
G1 Z2.400 F600
G0 X-7.325 Y15.023 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G1 X-5.188 Y15.023 A0.00091 F300
G1 X-5.188 Y16.256 F7800
G1 X-7.325 Y16.256 A0.00182 F300
G1 A0.00182 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.86 ---
;     bed region: (-17.56,2.93) -> (-15.92,4.79)
G1 A0.00182 F60
G1 Z2.400 F600
G0 X-17.562 Y2.930 F7800
G1 Z0.400 F600
G1 A0.00182 F60
G1 X-15.915 Y2.930 A0.00252 F300
G1 X-15.915 Y4.163 F7800
G1 X-17.562 Y4.163 A0.00322 F300
G1 A0.00322 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.95 ---
;     bed region: (-5.84,-14.06) -> (2.16,-6.01)
G1 A0.00322 F60
G1 Z2.400 F600
G0 X-5.838 Y-14.063 F7800
G1 Z0.400 F600
G1 A0.00322 F60
G1 X2.163 Y-14.063 A0.00662 F300
G1 X2.163 Y-12.830 F7800
G1 X-5.838 Y-12.830 A0.01003 F300
G1 X-5.838 Y-11.597 F7800
G1 X2.163 Y-11.597 A0.01343 F300
G1 X2.163 Y-10.364 F7800
G1 X-5.838 Y-10.364 A0.01683 F300
G1 X-5.838 Y-9.130 F7800
G1 X2.163 Y-9.130 A0.02024 F300
G1 X2.163 Y-7.897 F7800
G1 X-5.838 Y-7.897 A0.02364 F300
G1 X-5.838 Y-6.664 F7800
G1 X2.163 Y-6.664 A0.02704 F300
G1 A0.02704 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.94 ---
;     bed region: (3.49,-6.38) -> (11.47,1.80)
G1 A0.02704 F60
G1 Z2.400 F600
G0 X3.490 Y-6.380 F7800
G1 Z0.400 F600
G1 A0.02704 F60
G1 X11.473 Y-6.380 A0.03044 F300
G1 X11.473 Y-5.147 F7800
G1 X3.490 Y-5.147 A0.03383 F300
G1 X3.490 Y-3.914 F7800
G1 X11.473 Y-3.914 A0.03723 F300
G1 X11.473 Y-2.681 F7800
G1 X3.490 Y-2.681 A0.04062 F300
G1 X3.490 Y-1.448 F7800
G1 X11.473 Y-1.448 A0.04402 F300
G1 X11.473 Y-0.215 F7800
G1 X3.490 Y-0.215 A0.04742 F300
G1 X3.490 Y1.018 F7800
G1 X11.473 Y1.018 A0.05081 F300
G1 A0.05081 F60
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
