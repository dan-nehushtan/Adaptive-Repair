; ============================================================
; ADAPTIVE REPAIR G-CODE
; Layer 0   Z=0.400 mm
; Defects: 6
; ============================================================

G21          ; millimetres
G90          ; absolute positioning
G58          ; work coordinate system
G92 A0

; 
; >>> PHASE 1: OVEREXTRUSION REPAIRS (1)
;     Remove excess material to re-establish layer plane
;     Travel optimised: 38.6 -> 38.6 mm (0% saved)
; 
; --- Overextrusion repair (skim)  conf=0.93 ---
;     bed region: (-29.11,-29.55) -> (-25.03,-25.49)
G1 Z1.400 F600
G0 X-29.113 Y-29.550 F7800
G1 Z0.400 F600
G0 X-29.113 Y-29.550 F7800
G1 X-25.033 Y-29.550 F300
G0 X-25.033 Y-28.317 F7800
G1 X-29.113 Y-28.317 F300
G0 X-29.113 Y-27.084 F7800
G1 X-25.033 Y-27.084 F300
G0 X-25.033 Y-25.851 F7800
G1 X-29.113 Y-25.851 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

G1 Z2.400 F600
; --- Phase 1 complete: layer plane re-established ---

; 
; >>> PHASE 2: UNDEREXTRUSION REPAIRS (5)
;     Re-deposit material into voids on levelled surface
;     Travel optimised: 100.0 -> 58.3 mm (42% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.90 ---
;     bed region: (-8.11,-10.58) -> (-5.94,-8.41)
G1 A0.00000 F60
G1 Z1.400 F600
G0 X-8.113 Y-10.580 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G0 X-8.113 Y-10.580 F7800
G1 X-5.940 Y-10.580 A0.00092 F300
G0 X-5.940 Y-9.347 F7800
G1 X-8.113 Y-9.347 A0.00185 F300
G1 A0.00185 F60
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.90 ---
;     bed region: (-6.03,-12.38) -> (-3.21,-9.72)
G1 A0.00185 F60
G1 Z1.400 F600
G0 X-6.030 Y-12.383 F7800
G1 Z0.400 F600
G1 A0.00185 F60
G0 X-6.030 Y-12.383 F7800
G1 X-3.210 Y-12.383 A0.00305 F300
G0 X-3.210 Y-11.149 F7800
G1 X-6.030 Y-11.149 A0.00425 F300
G0 X-6.030 Y-9.916 F7800
G1 X-3.210 Y-9.916 A0.00545 F300
G1 A0.00545 F60
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.86 ---
;     bed region: (-6.52,-5.70) -> (-4.58,-3.86)
G1 A0.00545 F60
G1 Z1.400 F600
G0 X-6.520 Y-5.698 F7800
G1 Z0.400 F600
G1 A0.00545 F60
G0 X-6.520 Y-5.698 F7800
G1 X-4.575 Y-5.698 A0.00627 F300
G0 X-4.575 Y-4.465 F7800
G1 X-6.520 Y-4.465 A0.00710 F300
G1 A0.00710 F60
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.91 ---
;     bed region: (5.03,-5.89) -> (7.08,-3.58)
G1 A0.00710 F60
G1 Z1.400 F600
G0 X5.030 Y-5.890 F7800
G1 Z0.400 F600
G1 A0.00710 F60
G0 X5.030 Y-5.890 F7800
G1 X7.080 Y-5.890 A0.00797 F300
G0 X7.080 Y-4.657 F7800
G1 X5.030 Y-4.657 A0.00885 F300
G1 A0.00885 F60
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.87 ---
;     bed region: (12.75,1.36) -> (14.76,3.51)
G1 A0.00885 F60
G1 Z1.400 F600
G0 X12.748 Y1.355 F7800
G1 Z0.400 F600
G1 A0.00885 F60
G0 X12.748 Y1.355 F7800
G1 X14.763 Y1.355 A0.00970 F300
G0 X14.763 Y2.588 F7800
G1 X12.748 Y2.588 A0.01056 F300
G1 A0.01056 F60
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
