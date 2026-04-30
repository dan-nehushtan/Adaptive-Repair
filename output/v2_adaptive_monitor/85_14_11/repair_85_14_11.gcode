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
;     Travel optimised: 81.1 -> 59.4 mm (27% saved)
; 
; --- Mill cavity: Underextrusion  conf=0.90 ---
;     bed region: (10.02,-14.29) -> (14.06,-10.26)
G1 Z2.400 F600
G0 X10.018 Y-14.293 F7800
G1 Z0.400 F600
G1 X14.061 Y-14.293 F200
G1 X14.061 Y-13.060 F200
G1 X10.018 Y-13.060 F200
G1 X10.018 Y-11.827 F200
G1 X14.061 Y-11.827 F200
G1 X14.061 Y-10.594 F200
G1 X10.018 Y-10.594 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill skim: Overextrusion  conf=0.90 ---
;     bed region: (-28.89,-29.27) -> (-25.64,-26.09)
G1 Z2.400 F600
G0 X-28.892 Y-29.273 F7800
G1 Z0.400 F600
G1 X-25.644 Y-29.273 F200
G1 X-25.644 Y-28.040 F200
G1 X-28.892 Y-28.040 F200
G1 X-28.892 Y-26.807 F200
G1 X-25.644 Y-26.807 F200
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
; >>> PHASE 2: DEPOSIT INTO UNDEREXTRUSION CAVITIES (1)
;     Fill milled cavities with ceramic
;     Travel optimised: 42.2 -> 42.2 mm (0% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.90 ---
;     bed region: (10.02,-14.29) -> (14.06,-10.26)
G1 A0.00000 F60
G1 Z2.400 F600
G0 X10.018 Y-14.293 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G1 X14.061 Y-14.293 A0.00172 F300
G1 X14.061 Y-13.060 F7800
G1 X10.018 Y-13.060 A0.00344 F300
G1 X10.018 Y-11.827 F7800
G1 X14.061 Y-11.827 A0.00516 F300
G1 X14.061 Y-10.594 F7800
G1 X10.018 Y-10.594 A0.00688 F300
G1 A0.00688 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
