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
; >>> PHASE 1: OVEREXTRUSION REPAIRS (1)
;     Remove excess material to re-establish layer plane
;     Travel optimised: 38.6 -> 38.6 mm (0% saved)
; 
; --- Overextrusion repair (skim)  conf=0.93 ---
;     bed region: (-28.96,-29.38) -> (-25.28,-25.66)
G1 Z1.400 F600
G0 X-28.955 Y-29.375 F7800
G1 Z0.400 F600
G0 X-28.955 Y-29.375 F7800
G1 X-25.278 Y-29.375 F300
G0 X-25.278 Y-28.142 F7800
G1 X-28.955 Y-28.142 F300
G0 X-28.955 Y-26.909 F7800
G1 X-25.278 Y-26.909 F300
G0 X-25.278 Y-25.676 F7800
G1 X-28.955 Y-25.676 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

G1 Z2.400 F600
; --- Phase 1 complete: layer plane re-established ---

; 
; >>> PHASE 2: UNDEREXTRUSION REPAIRS (1)
;     Re-deposit material into voids on levelled surface
;     Travel optimised: 18.7 -> 18.7 mm (0% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.86 ---
;     bed region: (-12.68,-17.74) -> (-10.70,-16.06)
G1 A0.00000 F60
G1 Z1.400 F600
G0 X-12.680 Y-17.738 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G0 X-12.680 Y-17.738 F7800
G1 X-10.700 Y-17.738 A0.00084 F300
G0 X-10.700 Y-16.505 F7800
G1 X-12.680 Y-16.505 A0.00168 F300
G1 A0.00168 F60
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
