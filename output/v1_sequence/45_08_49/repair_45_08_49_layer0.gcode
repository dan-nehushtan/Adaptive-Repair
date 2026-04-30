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
;     Travel optimised: 39.3 -> 39.3 mm (0% saved)
; 
; --- Overextrusion repair (skim)  conf=0.94 ---
;     bed region: (-30.32,-30.51) -> (-25.14,-25.23)
G1 Z1.400 F600
G0 X-30.320 Y-30.513 F7800
G1 Z0.400 F600
G0 X-30.320 Y-30.513 F7800
G1 X-25.138 Y-30.513 F300
G0 X-25.138 Y-29.280 F7800
G1 X-30.320 Y-29.280 F300
G0 X-30.320 Y-28.047 F7800
G1 X-25.138 Y-28.047 F300
G0 X-25.138 Y-26.814 F7800
G1 X-30.320 Y-26.814 F300
G0 X-30.320 Y-25.581 F7800
G1 X-25.138 Y-25.581 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

G1 Z2.400 F600
; --- Phase 1 complete: layer plane re-established ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
