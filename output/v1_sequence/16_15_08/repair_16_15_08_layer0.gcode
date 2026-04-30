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
; >>> PHASE 1: OVEREXTRUSION REPAIRS (1)
;     Remove excess material to re-establish layer plane
;     Travel optimised: 38.7 -> 38.7 mm (0% saved)
; 
; --- Overextrusion repair (skim)  conf=0.94 ---
;     bed region: (-29.08,-29.57) -> (-25.23,-25.72)
G1 Z1.400 F600
G0 X-29.078 Y-29.568 F7800
G1 Z0.400 F600
G0 X-29.078 Y-29.568 F7800
G1 X-25.225 Y-29.568 F300
G0 X-25.225 Y-28.335 F7800
G1 X-29.078 Y-28.335 F300
G0 X-29.078 Y-27.102 F7800
G1 X-25.225 Y-27.102 F300
G0 X-25.225 Y-25.869 F7800
G1 X-29.078 Y-25.869 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

G1 Z2.400 F600
; --- Phase 1 complete: layer plane re-established ---

; 
; >>> PHASE 2: UNDEREXTRUSION REPAIRS (1)
;     Re-deposit material into voids on levelled surface
;     Travel optimised: 27.9 -> 27.9 mm (0% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.92 ---
;     bed region: (-6.01,-12.63) -> (-3.12,-9.98)
G1 A0.00000 F60
G1 Z1.400 F600
G0 X-6.013 Y-12.628 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G0 X-6.013 Y-12.628 F7800
G1 X-3.123 Y-12.628 A0.00123 F300
G0 X-3.123 Y-11.395 F7800
G1 X-6.013 Y-11.395 A0.00246 F300
G0 X-6.013 Y-10.162 F7800
G1 X-3.123 Y-10.162 A0.00369 F300
G1 A0.00369 F60
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
