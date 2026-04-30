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
;     Travel optimised: 38.0 -> 38.0 mm (0% saved)
; 
; --- Overextrusion repair (skim)  conf=0.93 ---
;     bed region: (-28.69,-29.04) -> (-24.74,-25.05)
G1 Z1.400 F600
G0 X-28.693 Y-29.043 F7800
G1 Z0.400 F600
G0 X-28.693 Y-29.043 F7800
G1 X-24.735 Y-29.043 F300
G0 X-24.735 Y-27.810 F7800
G1 X-28.693 Y-27.810 F300
G0 X-28.693 Y-26.577 F7800
G1 X-24.735 Y-26.577 F300
G0 X-24.735 Y-25.344 F7800
G1 X-28.693 Y-25.344 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

G1 Z2.400 F600
; --- Phase 1 complete: layer plane re-established ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
