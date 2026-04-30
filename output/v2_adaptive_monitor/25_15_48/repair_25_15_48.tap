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
;     Travel optimised: 5.1 -> 5.1 mm (0% saved)
; 
; --- Mill cavity: Underextrusion  conf=0.86 ---
;     bed region: (-4.87,2.40) -> (-2.10,5.03)
G1 Z2.400 F600
G0 X-4.869 Y2.403 F7800
G1 Z0.400 F600
G1 X-2.101 Y2.403 F200
G1 X-2.101 Y3.636 F200
G1 X-4.869 Y3.636 F200
G1 X-4.869 Y4.869 F200
G1 X-2.101 Y4.869 F200
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
;     bed region: (-4.87,2.40) -> (-2.10,5.03)
G1 A0.00000 F60
G1 Z2.400 F600
G0 X-4.869 Y2.403 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G1 X-2.101 Y2.403 A0.00118 F300
G1 X-2.101 Y3.636 F7800
G1 X-4.869 Y3.636 A0.00235 F300
G1 X-4.869 Y4.869 F7800
G1 X-2.101 Y4.869 A0.00353 F300
G1 A0.00353 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
