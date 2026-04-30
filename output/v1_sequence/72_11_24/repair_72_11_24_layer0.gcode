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
;     bed region: (-29.55,-29.95) -> (-25.12,-25.66)
G1 Z1.400 F600
G0 X-29.550 Y-29.953 F7800
G1 Z0.400 F600
G0 X-29.550 Y-29.953 F7800
G1 X-25.120 Y-29.953 F300
G0 X-25.120 Y-28.720 F7800
G1 X-29.550 Y-28.720 F300
G0 X-29.550 Y-27.487 F7800
G1 X-25.120 Y-27.487 F300
G0 X-25.120 Y-26.254 F7800
G1 X-29.550 Y-26.254 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

G1 Z2.400 F600
; --- Phase 1 complete: layer plane re-established ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
