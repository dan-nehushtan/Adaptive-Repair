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
;     Overextrusion  : 1 regions (skim excess)
;     Underextrusion : 3 regions (cut clean cavity)
;     Travel optimised: 81.6 -> 51.4 mm (37% saved)
; 
; --- Mill cavity: Underextrusion  conf=0.92 ---
;     bed region: (-5.41,-2.12) -> (-0.80,2.56)
G1 Z2.400 F600
G0 X-5.410 Y-2.116 F7800
G1 Z0.400 F600
G1 X-0.801 Y-2.116 F200
G1 X-0.801 Y-0.883 F200
G1 X-5.410 Y-0.883 F200
G1 X-5.410 Y0.350 F200
G1 X-0.801 Y0.350 F200
G1 X-0.801 Y1.583 F200
G1 X-5.410 Y1.583 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.89 ---
;     bed region: (-1.26,2.12) -> (3.03,6.32)
G1 Z2.400 F600
G0 X-1.256 Y2.118 F7800
G1 Z0.400 F600
G1 X3.030 Y2.118 F200
G1 X3.030 Y3.351 F200
G1 X-1.256 Y3.351 F200
G1 X-1.256 Y4.584 F200
G1 X3.030 Y4.584 F200
G1 X3.030 Y5.817 F200
G1 X-1.256 Y5.817 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.93 ---
;     bed region: (-12.09,-8.71) -> (-5.06,-1.77)
G1 Z2.400 F600
G0 X-12.093 Y-8.712 F7800
G1 Z0.400 F600
G1 X-5.061 Y-8.712 F200
G1 X-5.061 Y-7.479 F200
G1 X-12.093 Y-7.479 F200
G1 X-12.093 Y-6.246 F200
G1 X-5.061 Y-6.246 F200
G1 X-5.061 Y-5.013 F200
G1 X-12.093 Y-5.013 F200
G1 X-12.093 Y-3.780 F200
G1 X-5.061 Y-3.780 F200
G1 X-5.061 Y-2.547 F200
G1 X-12.093 Y-2.547 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill skim: Overextrusion  conf=0.90 ---
;     bed region: (-29.37,-29.52) -> (-25.57,-25.72)
G1 Z2.400 F600
G0 X-29.371 Y-29.520 F7800
G1 Z0.400 F600
G1 X-25.572 Y-29.520 F200
G1 X-25.572 Y-28.287 F200
G1 X-29.371 Y-28.287 F200
G1 X-29.371 Y-27.054 F200
G1 X-25.572 Y-27.054 F200
G1 X-25.572 Y-25.821 F200
G1 X-29.371 Y-25.821 F200
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
; >>> PHASE 2: DEPOSIT INTO UNDEREXTRUSION CAVITIES (3)
;     Fill milled cavities with ceramic
;     Travel optimised: 42.7 -> 42.7 mm (0% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.93 ---
;     bed region: (-12.09,-8.71) -> (-5.06,-1.77)
G1 A0.00000 F60
G1 Z2.400 F600
G0 X-12.093 Y-8.712 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G1 X-5.061 Y-8.712 A0.00299 F300
G1 X-5.061 Y-7.479 F7800
G1 X-12.093 Y-7.479 A0.00598 F300
G1 X-12.093 Y-6.246 F7800
G1 X-5.061 Y-6.246 A0.00897 F300
G1 X-5.061 Y-5.013 F7800
G1 X-12.093 Y-5.013 A0.01196 F300
G1 X-12.093 Y-3.780 F7800
G1 X-5.061 Y-3.780 A0.01496 F300
G1 X-5.061 Y-2.547 F7800
G1 X-12.093 Y-2.547 A0.01795 F300
G1 A0.01795 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.92 ---
;     bed region: (-5.41,-2.12) -> (-0.80,2.56)
G1 A0.01795 F60
G1 Z2.400 F600
G0 X-5.410 Y-2.116 F7800
G1 Z0.400 F600
G1 A0.01795 F60
G1 X-0.801 Y-2.116 A0.01991 F300
G1 X-0.801 Y-0.883 F7800
G1 X-5.410 Y-0.883 A0.02187 F300
G1 X-5.410 Y0.350 F7800
G1 X-0.801 Y0.350 A0.02383 F300
G1 X-0.801 Y1.583 F7800
G1 X-5.410 Y1.583 A0.02579 F300
G1 A0.02579 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.89 ---
;     bed region: (-1.26,2.12) -> (3.03,6.32)
G1 A0.02579 F60
G1 Z2.400 F600
G0 X-1.256 Y2.118 F7800
G1 Z0.400 F600
G1 A0.02579 F60
G1 X3.030 Y2.118 A0.02761 F300
G1 X3.030 Y3.351 F7800
G1 X-1.256 Y3.351 A0.02944 F300
G1 X-1.256 Y4.584 F7800
G1 X3.030 Y4.584 A0.03126 F300
G1 X3.030 Y5.817 F7800
G1 X-1.256 Y5.817 A0.03308 F300
G1 A0.03308 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
