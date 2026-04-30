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
;     Overextrusion  : 0 regions (skim excess)
;     Underextrusion : 2 regions (cut clean cavity)
;     Travel optimised: 20.6 -> 20.4 mm (1% saved)
; 
; --- Mill cavity: Underextrusion  conf=0.86 ---
;     bed region: (-1.82,16.47) -> (0.42,18.35)
G1 Z2.400 F600
G0 X-1.819 Y16.467 F7800
G1 Z0.400 F600
G1 X0.417 Y16.467 F200
G1 X0.417 Y17.700 F200
G1 X-1.819 Y17.700 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.87 ---
;     bed region: (1.21,16.51) -> (3.44,18.38)
G1 Z2.400 F600
G0 X1.206 Y16.511 F7800
G1 Z0.400 F600
G1 X3.442 Y16.511 F200
G1 X3.442 Y17.744 F200
G1 X1.206 Y17.744 F200
G1 Z2.400 F600
; --- end mill cavity ---

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
; >>> PHASE 2: DEPOSIT INTO UNDEREXTRUSION CAVITIES (2)
;     Fill milled cavities with ceramic
;     Travel optimised: 3.0 -> 3.0 mm (0% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.87 ---
;     bed region: (1.21,16.51) -> (3.44,18.38)
G1 A0.00000 F60
G1 Z2.400 F600
G0 X1.206 Y16.511 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G1 X3.442 Y16.511 A0.00095 F300
G1 X3.442 Y17.744 F7800
G1 X1.206 Y17.744 A0.00190 F300
G1 A0.00190 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.86 ---
;     bed region: (-1.82,16.47) -> (0.42,18.35)
G1 A0.00190 F60
G1 Z2.400 F600
G0 X-1.819 Y16.467 F7800
G1 Z0.400 F600
G1 A0.00190 F60
G1 X0.417 Y16.467 A0.00285 F300
G1 X0.417 Y17.700 F7800
G1 X-1.819 Y17.700 A0.00380 F300
G1 A0.00380 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
