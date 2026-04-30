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
;     Travel optimised: 96.5 -> 77.8 mm (19% saved)
; 
; --- Overextrusion repair (skim)  conf=0.87 ---
;     bed region: (16.56,8.30) -> (18.56,10.41)
G1 Z1.400 F600
G0 X16.562 Y8.303 F7800
G1 Z0.400 F600
G0 X16.562 Y8.303 F7800
G1 X18.560 Y8.303 F300
G0 X18.560 Y9.536 F7800
G1 X16.562 Y9.536 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

; --- Overextrusion repair (skim)  conf=0.94 ---
;     bed region: (-29.22,-29.53) -> (-25.07,-25.37)
G1 Z1.400 F600
G0 X-29.218 Y-29.533 F7800
G1 Z0.400 F600
G0 X-29.218 Y-29.533 F7800
G1 X-25.068 Y-29.533 F300
G0 X-25.068 Y-28.300 F7800
G1 X-29.218 Y-28.300 F300
G0 X-29.218 Y-27.067 F7800
G1 X-25.068 Y-27.067 F300
G0 X-25.068 Y-25.834 F7800
G1 X-29.218 Y-25.834 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

G1 Z2.400 F600
; --- Phase 1 complete: layer plane re-established ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
