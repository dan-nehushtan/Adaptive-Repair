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
;     Travel optimised: 80.4 -> 68.9 mm (14% saved)
; 
; --- Overextrusion repair (skim)  conf=0.91 ---
;     bed region: (13.06,-23.97) -> (16.64,-20.57)
G1 Z1.400 F600
G0 X13.063 Y-23.968 F7800
G1 Z0.400 F600
G0 X13.063 Y-23.968 F7800
G1 X16.635 Y-23.968 F300
G0 X16.635 Y-22.735 F7800
G1 X13.063 Y-22.735 F300
G0 X13.063 Y-21.502 F7800
G1 X16.635 Y-21.502 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

; --- Overextrusion repair (skim)  conf=0.94 ---
;     bed region: (-28.87,-28.89) -> (-25.23,-25.19)
G1 Z1.400 F600
G0 X-28.868 Y-28.885 F7800
G1 Z0.400 F600
G0 X-28.868 Y-28.885 F7800
G1 X-25.225 Y-28.885 F300
G0 X-25.225 Y-27.652 F7800
G1 X-28.868 Y-27.652 F300
G0 X-28.868 Y-26.419 F7800
G1 X-25.225 Y-26.419 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

G1 Z2.400 F600
; --- Phase 1 complete: layer plane re-established ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
