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
; >>> PHASE 1: OVEREXTRUSION REPAIRS (2)
;     Remove excess material to re-establish layer plane
;     Travel optimised: 71.5 -> 57.6 mm (20% saved)
; 
; --- Overextrusion repair (skim)  conf=0.93 ---
;     bed region: (-28.57,-29.01) -> (-24.89,-25.45)
G1 Z1.400 F600
G0 X-28.570 Y-29.008 F7800
G1 Z0.400 F600
G0 X-28.570 Y-29.008 F7800
G1 X-24.893 Y-29.008 F300
G0 X-24.893 Y-27.775 F7800
G1 X-28.570 Y-27.775 F300
G0 X-28.570 Y-26.542 F7800
G1 X-24.893 Y-26.542 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

; --- Overextrusion repair (skim)  conf=0.93 ---
;     bed region: (-47.86,-26.42) -> (-44.07,-22.72)
G1 Z1.400 F600
G0 X-47.855 Y-26.418 F7800
G1 Z0.400 F600
G0 X-47.855 Y-26.418 F7800
G1 X-44.073 Y-26.418 F300
G0 X-44.073 Y-25.185 F7800
G1 X-47.855 Y-25.185 F300
G0 X-47.855 Y-23.952 F7800
G1 X-44.073 Y-23.952 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

G1 Z2.400 F600
; --- Phase 1 complete: layer plane re-established ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
