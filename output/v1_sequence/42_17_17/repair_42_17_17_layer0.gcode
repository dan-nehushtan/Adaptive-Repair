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
;     Travel optimised: 38.4 -> 38.4 mm (0% saved)
; 
; --- Overextrusion repair (skim)  conf=0.94 ---
;     bed region: (-28.90,-29.43) -> (-24.82,-25.33)
G1 Z1.400 F600
G0 X-28.903 Y-29.428 F7800
G1 Z0.400 F600
G0 X-28.903 Y-29.428 F7800
G1 X-24.823 Y-29.428 F300
G0 X-24.823 Y-28.195 F7800
G1 X-28.903 Y-28.195 F300
G0 X-28.903 Y-26.962 F7800
G1 X-24.823 Y-26.962 F300
G0 X-24.823 Y-25.729 F7800
G1 X-28.903 Y-25.729 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

G1 Z2.400 F600
; --- Phase 1 complete: layer plane re-established ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
