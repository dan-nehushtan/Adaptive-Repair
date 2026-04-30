; ============================================================
; ADAPTIVE REPAIR G-CODE
; Layer 0   Z=0.400 mm
; Defects: 3
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
; >>> PHASE 1: MILL ALL BOUNDING BOXES (3)
;     Overextrusion  : 2 regions (skim excess)
;     Underextrusion : 1 regions (cut clean cavity)
;     Travel optimised: 56.4 -> 56.4 mm (0% saved)
; 
; --- Mill skim: Overextrusion  conf=0.86 ---
;     bed region: (-12.27,2.22) -> (-10.52,3.88)
G1 Z2.400 F600
G0 X-12.270 Y2.218 F7800
G1 Z0.400 F600
G1 X-10.517 Y2.218 F200
G1 X-10.517 Y3.451 F200
G1 X-12.270 Y3.451 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.85 ---
;     bed region: (-8.12,13.86) -> (-6.30,15.90)
G1 Z2.400 F600
G0 X-8.117 Y13.859 F7800
G1 Z0.400 F600
G1 X-6.296 Y13.859 F200
G1 X-6.296 Y15.092 F200
G1 X-8.117 Y15.092 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill cavity: Underextrusion  conf=0.86 ---
;     bed region: (-13.27,-17.67) -> (-11.09,-15.85)
G1 Z2.400 F600
G0 X-13.268 Y-17.667 F7800
G1 Z0.400 F600
G1 X-11.088 Y-17.667 F200
G1 X-11.088 Y-16.434 F200
G1 X-13.268 Y-16.434 F200
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

; --- Underextrusion repair  conf=0.86 ---
;     bed region: (-13.27,-17.67) -> (-11.09,-15.85)
G1 A0.00000 F60
G1 Z2.400 F600
G0 X-13.268 Y-17.667 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G1 X-11.088 Y-17.667 A0.00093 F300
G1 X-11.088 Y-16.434 F7800
G1 X-13.268 Y-16.434 A0.00185 F300
G1 A0.00185 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
