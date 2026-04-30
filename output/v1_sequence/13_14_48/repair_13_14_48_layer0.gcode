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
;     Travel optimised: 41.4 -> 41.4 mm (0% saved)
; 
; --- Overextrusion repair (skim)  conf=0.94 ---
;     bed region: (-29.03,-29.59) -> (-25.02,-25.72)
G1 Z1.400 F600
G0 X-29.025 Y-29.585 F7800
G1 Z0.400 F600
G0 X-29.025 Y-29.585 F7800
G1 X-25.015 Y-29.585 F300
G0 X-25.015 Y-28.352 F7800
G1 X-29.025 Y-28.352 F300
G0 X-29.025 Y-27.119 F7800
G1 X-25.015 Y-27.119 F300
G0 X-25.015 Y-25.886 F7800
G1 X-29.025 Y-25.886 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

; --- Overextrusion repair (skim)  conf=0.92 ---
;     bed region: (-28.26,-31.98) -> (-25.00,-28.67)
G1 Z1.400 F600
G0 X-28.255 Y-31.983 F7800
G1 Z0.400 F600
G0 X-28.255 Y-31.983 F7800
G1 X-24.998 Y-31.983 F300
G0 X-24.998 Y-30.750 F7800
G1 X-28.255 Y-30.750 F300
G0 X-28.255 Y-29.517 F7800
G1 X-24.998 Y-29.517 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

G1 Z2.400 F600
; --- Phase 1 complete: layer plane re-established ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
