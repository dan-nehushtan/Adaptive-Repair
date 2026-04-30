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
; --- Overextrusion repair (skim)  conf=0.92 ---
;     bed region: (-28.87,-28.94) -> (-24.82,-24.81)
G1 Z1.400 F600
G0 X-28.868 Y-28.938 F7800
G1 Z0.400 F600
G0 X-28.868 Y-28.938 F7800
G1 X-24.823 Y-28.938 F300
G0 X-24.823 Y-27.705 F7800
G1 X-28.868 Y-27.705 F300
G0 X-28.868 Y-26.472 F7800
G1 X-24.823 Y-26.472 F300
G0 X-24.823 Y-25.239 F7800
G1 X-28.868 Y-25.239 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

G1 Z2.400 F600
; --- Phase 1 complete: layer plane re-established ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
