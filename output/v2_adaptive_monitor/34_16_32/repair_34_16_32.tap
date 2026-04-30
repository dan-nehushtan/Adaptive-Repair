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
;     Overextrusion  : 3 regions (skim excess)
;     Underextrusion : 0 regions (cut clean cavity)
;     Travel optimised: 84.5 -> 58.5 mm (31% saved)
; 
; --- Mill skim: Overextrusion  conf=0.85 ---
;     bed region: (-6.99,9.78) -> (-4.54,12.34)
G1 Z2.400 F600
G0 X-6.988 Y9.780 F7800
G1 Z0.400 F600
G1 X-4.540 Y9.780 F200
G1 X-4.540 Y11.013 F200
G1 X-6.988 Y11.013 F200
G1 X-6.988 Y12.246 F200
G1 X-4.540 Y12.246 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.88 ---
;     bed region: (-14.54,-17.69) -> (-11.87,-15.33)
G1 Z2.400 F600
G0 X-14.539 Y-17.690 F7800
G1 Z0.400 F600
G1 X-11.866 Y-17.690 F200
G1 X-11.866 Y-16.457 F200
G1 X-14.539 Y-16.457 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.90 ---
;     bed region: (-28.91,-29.29) -> (-25.01,-25.38)
G1 Z2.400 F600
G0 X-28.907 Y-29.289 F7800
G1 Z0.400 F600
G1 X-25.013 Y-29.289 F200
G1 X-25.013 Y-28.056 F200
G1 X-28.907 Y-28.056 F200
G1 X-28.907 Y-26.823 F200
G1 X-25.013 Y-26.823 F200
G1 X-25.013 Y-25.590 F200
G1 X-28.907 Y-25.590 F200
G1 Z2.400 F600
; --- end mill skim ---

G1 Z2.400 F600
M5  ; spindle off after milling
; --- Phase 1 complete: all regions milled ---

; >>> RETURNING MILL (no underextrusion to fill)
M5  ; spindle off
; --- TOOL CHANGE: ceramic nozzle ---
G1 Z50.000 F600
G0 X0.000 Y0.000 F7800
M6 T0  ; pick up ceramic nozzle
; Tool T0 loaded
G92 A0

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
