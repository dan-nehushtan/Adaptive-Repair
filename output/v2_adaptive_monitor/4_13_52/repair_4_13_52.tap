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
;     Overextrusion  : 0 regions (skim excess)
;     Underextrusion : 3 regions (cut clean cavity)
;     Travel optimised: 28.8 -> 28.8 mm (0% saved)
; 
; --- Mill cavity: Underextrusion  conf=0.94 ---
;     bed region: (7.80,-15.54) -> (18.19,-4.85)
G1 Z2.400 F600
G0 X7.796 Y-15.538 F7800
G1 Z0.400 F600
G1 X18.190 Y-15.538 F200
G1 X18.190 Y-14.305 F200
G1 X7.796 Y-14.305 F200
G1 X7.796 Y-13.072 F200
G1 X18.190 Y-13.072 F200
G1 X18.190 Y-11.839 F200
G1 X7.796 Y-11.839 F200
G1 X7.796 Y-10.606 F200
G1 X18.190 Y-10.606 F200
G1 X18.190 Y-9.373 F200
G1 X7.796 Y-9.373 F200
G1 X7.796 Y-8.140 F200
G1 X18.190 Y-8.140 F200
G1 X18.190 Y-6.907 F200
G1 X7.796 Y-6.907 F200
G1 X7.796 Y-5.674 F200
G1 X18.190 Y-5.674 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.92 ---
;     bed region: (10.57,-15.78) -> (16.37,-10.12)
G1 Z2.400 F600
G0 X10.573 Y-15.782 F7800
G1 Z0.400 F600
G1 X16.365 Y-15.782 F200
G1 X16.365 Y-14.549 F200
G1 X10.573 Y-14.549 F200
G1 X10.573 Y-13.316 F200
G1 X16.365 Y-13.316 F200
G1 X16.365 Y-12.083 F200
G1 X10.573 Y-12.083 F200
G1 X10.573 Y-10.850 F200
G1 X16.365 Y-10.850 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.85 ---
;     bed region: (3.88,-17.77) -> (5.68,-15.87)
G1 Z2.400 F600
G0 X3.879 Y-17.769 F7800
G1 Z0.400 F600
G1 X5.683 Y-17.769 F200
G1 X5.683 Y-16.536 F200
G1 X3.879 Y-16.536 F200
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
; >>> PHASE 2: DEPOSIT INTO UNDEREXTRUSION CAVITIES (3)
;     Fill milled cavities with ceramic
;     Travel optimised: 22.9 -> 12.3 mm (46% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.85 ---
;     bed region: (3.88,-17.77) -> (5.68,-15.87)
G1 A0.00000 F60
G1 Z2.400 F600
G0 X3.879 Y-17.769 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G1 X5.683 Y-17.769 A0.00077 F300
G1 X5.683 Y-16.536 F7800
G1 X3.879 Y-16.536 A0.00154 F300
G1 A0.00154 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.92 ---
;     bed region: (10.57,-15.78) -> (16.37,-10.12)
G1 A0.00154 F60
G1 Z2.400 F600
G0 X10.573 Y-15.782 F7800
G1 Z0.400 F600
G1 A0.00154 F60
G1 X16.365 Y-15.782 A0.00400 F300
G1 X16.365 Y-14.549 F7800
G1 X10.573 Y-14.549 A0.00646 F300
G1 X10.573 Y-13.316 F7800
G1 X16.365 Y-13.316 A0.00893 F300
G1 X16.365 Y-12.083 F7800
G1 X10.573 Y-12.083 A0.01139 F300
G1 X10.573 Y-10.850 F7800
G1 X16.365 Y-10.850 A0.01386 F300
G1 A0.01386 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.94 ---
;     bed region: (7.80,-15.54) -> (18.19,-4.85)
G1 A0.01386 F60
G1 Z2.400 F600
G0 X7.796 Y-15.538 F7800
G1 Z0.400 F600
G1 A0.01386 F60
G1 X18.190 Y-15.538 A0.01828 F300
G1 X18.190 Y-14.305 F7800
G1 X7.796 Y-14.305 A0.02270 F300
G1 X7.796 Y-13.072 F7800
G1 X18.190 Y-13.072 A0.02712 F300
G1 X18.190 Y-11.839 F7800
G1 X7.796 Y-11.839 A0.03154 F300
G1 X7.796 Y-10.606 F7800
G1 X18.190 Y-10.606 A0.03596 F300
G1 X18.190 Y-9.373 F7800
G1 X7.796 Y-9.373 A0.04039 F300
G1 X7.796 Y-8.140 F7800
G1 X18.190 Y-8.140 A0.04481 F300
G1 X18.190 Y-6.907 F7800
G1 X7.796 Y-6.907 A0.04923 F300
G1 X7.796 Y-5.674 F7800
G1 X18.190 Y-5.674 A0.05365 F300
G1 A0.05365 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
