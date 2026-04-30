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
;     Travel optimised: 38.0 -> 38.0 mm (0% saved)
; 
; --- Overextrusion repair (skim)  conf=0.92 ---
;     bed region: (-28.38,-28.90) -> (-24.86,-25.47)
G1 Z1.400 F600
G0 X-28.378 Y-28.903 F7800
G1 Z0.400 F600
G0 X-28.378 Y-28.903 F7800
G1 X-24.858 Y-28.903 F300
G0 X-24.858 Y-27.670 F7800
G1 X-28.378 Y-27.670 F300
G0 X-28.378 Y-26.437 F7800
G1 X-24.858 Y-26.437 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

G1 Z2.400 F600
; --- Phase 1 complete: layer plane re-established ---

; 
; >>> PHASE 2: UNDEREXTRUSION REPAIRS (1)
;     Re-deposit material into voids on levelled surface
;     Travel optimised: 32.5 -> 32.5 mm (0% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.88 ---
;     bed region: (-1.27,-9.34) -> (1.06,-7.27)
G1 A0.00000 F60
G1 Z1.400 F600
G0 X-1.270 Y-9.338 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G0 X-1.270 Y-9.338 F7800
G1 X1.060 Y-9.338 A0.00099 F300
G0 X1.060 Y-8.104 F7800
G1 X-1.270 Y-8.104 A0.00198 F300
G1 A0.00198 F60
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
