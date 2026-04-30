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
; >>> PHASE 1: OVEREXTRUSION REPAIRS (1)
;     Remove excess material to re-establish layer plane
;     Travel optimised: 38.7 -> 38.7 mm (0% saved)
; 
; --- Overextrusion repair (skim)  conf=0.93 ---
;     bed region: (-29.15,-29.57) -> (-25.21,-25.58)
G1 Z1.400 F600
G0 X-29.148 Y-29.568 F7800
G1 Z0.400 F600
G0 X-29.148 Y-29.568 F7800
G1 X-25.208 Y-29.568 F300
G0 X-25.208 Y-28.335 F7800
G1 X-29.148 Y-28.335 F300
G0 X-29.148 Y-27.102 F7800
G1 X-25.208 Y-27.102 F300
G0 X-25.208 Y-25.869 F7800
G1 X-29.148 Y-25.869 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

G1 Z2.400 F600
; --- Phase 1 complete: layer plane re-established ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
