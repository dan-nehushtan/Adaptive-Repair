; ============================================================
; ADAPTIVE REPAIR G-CODE
; Layer 0   Z=0.400 mm
; Defects: 1
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
; >>> PHASE 1: MILL ALL BOUNDING BOXES (1)
;     Overextrusion  : 0 regions (skim excess)
;     Underextrusion : 1 regions (cut clean cavity)
;     Travel optimised: 14.2 -> 14.2 mm (0% saved)
; 
; --- Mill cavity: Underextrusion  conf=0.85 ---
;     bed region: (11.72,5.20) -> (13.60,7.51)
G1 Z2.400 F600
G0 X11.720 Y5.199 F7800
G1 Z0.400 F600
G1 X13.596 Y5.199 F200
G1 X13.596 Y6.432 F200
G1 X11.720 Y6.432 F200
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
; >>> PHASE 2: DEPOSIT INTO UNDEREXTRUSION CAVITIES (1)
;     Fill milled cavities with ceramic
; 
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.85 ---
;     bed region: (11.72,5.20) -> (13.60,7.51)
G1 A0.00000 F60
G1 Z2.400 F600
G0 X11.720 Y5.199 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G1 X13.596 Y5.199 A0.00080 F300
G1 X13.596 Y6.432 F7800
G1 X11.720 Y6.432 A0.00160 F300
G1 A0.00160 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
