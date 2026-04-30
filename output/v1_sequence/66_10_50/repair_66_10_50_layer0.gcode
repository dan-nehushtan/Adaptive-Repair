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
;     Travel optimised: 18.7 -> 18.7 mm (0% saved)
; 
; --- Overextrusion repair (skim)  conf=0.90 ---
;     bed region: (-3.49,17.39) -> (-0.10,19.75)
G1 Z1.400 F600
G0 X-3.493 Y17.385 F7800
G1 Z0.400 F600
G0 X-3.493 Y17.385 F7800
G1 X-0.095 Y17.385 F300
G0 X-0.095 Y18.618 F7800
G1 X-3.493 Y18.618 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

G1 Z2.400 F600
; --- Phase 1 complete: layer plane re-established ---

; 
; >>> PHASE 2: UNDEREXTRUSION REPAIRS (1)
;     Re-deposit material into voids on levelled surface
;     Travel optimised: 21.7 -> 21.7 mm (0% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.88 ---
;     bed region: (15.74,6.08) -> (17.42,8.11)
G1 A0.00000 F60
G1 Z1.400 F600
G0 X15.740 Y6.080 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G0 X15.740 Y6.080 F7800
G1 X17.423 Y6.080 A0.00072 F300
G0 X17.423 Y7.313 F7800
G1 X15.740 Y7.313 A0.00143 F300
G1 A0.00143 F60
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
