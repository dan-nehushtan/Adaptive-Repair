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
;     Travel optimised: 39.0 -> 39.0 mm (0% saved)
; 
; --- Overextrusion repair (skim)  conf=0.94 ---
;     bed region: (-29.27,-29.62) -> (-25.49,-25.80)
G1 Z1.400 F600
G0 X-29.270 Y-29.620 F7800
G1 Z0.400 F600
G0 X-29.270 Y-29.620 F7800
G1 X-25.488 Y-29.620 F300
G0 X-25.488 Y-28.387 F7800
G1 X-29.270 Y-28.387 F300
G0 X-29.270 Y-27.154 F7800
G1 X-25.488 Y-27.154 F300
G0 X-25.488 Y-25.921 F7800
G1 X-29.270 Y-25.921 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

G1 Z2.400 F600
; --- Phase 1 complete: layer plane re-established ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
