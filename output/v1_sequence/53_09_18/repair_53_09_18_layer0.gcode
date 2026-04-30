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
;     Travel optimised: 38.8 -> 38.8 mm (0% saved)
; 
; --- Overextrusion repair (skim)  conf=0.93 ---
;     bed region: (-28.89,-29.20) -> (-25.70,-26.03)
G1 Z1.400 F600
G0 X-28.885 Y-29.200 F7800
G1 Z0.400 F600
G0 X-28.885 Y-29.200 F7800
G1 X-25.698 Y-29.200 F300
G0 X-25.698 Y-27.967 F7800
G1 X-28.885 Y-27.967 F300
G0 X-28.885 Y-26.734 F7800
G1 X-25.698 Y-26.734 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

G1 Z2.400 F600
; --- Phase 1 complete: layer plane re-established ---

; 
; >>> PHASE 2: UNDEREXTRUSION REPAIRS (1)
;     Re-deposit material into voids on levelled surface
;     Travel optimised: 39.4 -> 39.4 mm (0% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.93 ---
;     bed region: (-4.79,-15.76) -> (15.74,4.21)
G1 A0.00000 F60
G1 Z1.400 F600
G0 X-4.788 Y-15.760 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G0 X-4.788 Y-15.760 F7800
G1 X15.743 Y-15.760 A0.00873 F300
G0 X15.743 Y-14.527 F7800
G1 X-4.788 Y-14.527 A0.01747 F300
G0 X-4.788 Y-13.294 F7800
G1 X15.743 Y-13.294 A0.02620 F300
G0 X15.743 Y-12.061 F7800
G1 X-4.788 Y-12.061 A0.03493 F300
G0 X-4.788 Y-10.828 F7800
G1 X15.743 Y-10.828 A0.04367 F300
G0 X15.743 Y-9.595 F7800
G1 X-4.788 Y-9.595 A0.05240 F300
G0 X-4.788 Y-8.362 F7800
G1 X15.743 Y-8.362 A0.06113 F300
G0 X15.743 Y-7.129 F7800
G1 X-4.788 Y-7.129 A0.06986 F300
G0 X-4.788 Y-5.896 F7800
G1 X15.743 Y-5.896 A0.07860 F300
G0 X15.743 Y-4.663 F7800
G1 X-4.788 Y-4.663 A0.08733 F300
G0 X-4.788 Y-3.430 F7800
G1 X15.743 Y-3.430 A0.09606 F300
G0 X15.743 Y-2.197 F7800
G1 X-4.788 Y-2.197 A0.10480 F300
G0 X-4.788 Y-0.964 F7800
G1 X15.743 Y-0.964 A0.11353 F300
G0 X15.743 Y0.269 F7800
G1 X-4.788 Y0.269 A0.12226 F300
G0 X-4.788 Y1.502 F7800
G1 X15.743 Y1.502 A0.13100 F300
G0 X15.743 Y2.735 F7800
G1 X-4.788 Y2.735 A0.13973 F300
G0 X-4.788 Y3.968 F7800
G1 X15.743 Y3.968 A0.14846 F300
G1 A0.14846 F60
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
