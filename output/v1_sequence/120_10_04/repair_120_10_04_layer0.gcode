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
;     Travel optimised: 39.1 -> 39.1 mm (0% saved)
; 
; --- Overextrusion repair (skim)  conf=0.94 ---
;     bed region: (-29.67,-30.23) -> (-24.98,-25.59)
G1 Z1.400 F600
G0 X-29.673 Y-30.233 F7800
G1 Z0.400 F600
G0 X-29.673 Y-30.233 F7800
G1 X-24.980 Y-30.233 F300
G0 X-24.980 Y-29.000 F7800
G1 X-29.673 Y-29.000 F300
G0 X-29.673 Y-27.767 F7800
G1 X-24.980 Y-27.767 F300
G0 X-24.980 Y-26.534 F7800
G1 X-29.673 Y-26.534 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

G1 Z2.400 F600
; --- Phase 1 complete: layer plane re-established ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
