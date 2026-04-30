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
;     Travel optimised: 38.1 -> 38.1 mm (0% saved)
; 
; --- Overextrusion repair (skim)  conf=0.93 ---
;     bed region: (-28.62,-28.75) -> (-25.17,-25.24)
G1 Z1.400 F600
G0 X-28.623 Y-28.745 F7800
G1 Z0.400 F600
G0 X-28.623 Y-28.745 F7800
G1 X-25.173 Y-28.745 F300
G0 X-25.173 Y-27.512 F7800
G1 X-28.623 Y-27.512 F300
G0 X-28.623 Y-26.279 F7800
G1 X-25.173 Y-26.279 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

G1 Z2.400 F600
; --- Phase 1 complete: layer plane re-established ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
