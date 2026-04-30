; ============================================================
; ADAPTIVE REPAIR G-CODE
; Layer 0   Z=0.400 mm
; Defects: 8
; ============================================================

G21          ; millimetres
G90          ; absolute positioning
G58          ; work coordinate system
G92 A0

; 
; >>> PHASE 1: OVEREXTRUSION REPAIRS (8)
;     Remove excess material to re-establish layer plane
;     Travel optimised: 133.6 -> 106.8 mm (20% saved)
; 
; --- Overextrusion repair (skim)  conf=0.90 ---
;     bed region: (-9.41,11.87) -> (-5.54,15.60)
G1 Z1.400 F600
G0 X-9.408 Y11.873 F7800
G1 Z0.400 F600
G0 X-9.408 Y11.873 F7800
G1 X-5.538 Y11.873 F300
G0 X-5.538 Y13.106 F7800
G1 X-9.408 Y13.106 F300
G0 X-9.408 Y14.339 F7800
G1 X-5.538 Y14.339 F300
G0 X-5.538 Y15.572 F7800
G1 X-9.408 Y15.572 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

; --- Overextrusion repair (skim)  conf=0.85 ---
;     bed region: (-3.14,15.62) -> (-0.18,18.82)
G1 Z1.400 F600
G0 X-3.143 Y15.618 F7800
G1 Z0.400 F600
G0 X-3.143 Y15.618 F7800
G1 X-0.183 Y15.618 F300
G0 X-0.183 Y16.851 F7800
G1 X-3.143 Y16.851 F300
G0 X-3.143 Y18.084 F7800
G1 X-0.183 Y18.084 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

; --- Overextrusion repair (skim)  conf=0.88 ---
;     bed region: (3.75,15.64) -> (6.10,18.40)
G1 Z1.400 F600
G0 X3.753 Y15.635 F7800
G1 Z0.400 F600
G0 X3.753 Y15.635 F7800
G1 X6.100 Y15.635 F300
G0 X6.100 Y16.868 F7800
G1 X3.753 Y16.868 F300
G0 X3.753 Y18.101 F7800
G1 X6.100 Y18.101 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

; --- Overextrusion repair (skim)  conf=0.89 ---
;     bed region: (6.41,14.81) -> (8.66,17.65)
G1 Z1.400 F600
G0 X6.413 Y14.813 F7800
G1 Z0.400 F600
G0 X6.413 Y14.813 F7800
G1 X8.655 Y14.813 F300
G0 X8.655 Y16.046 F7800
G1 X6.413 Y16.046 F300
G0 X6.413 Y17.279 F7800
G1 X8.655 Y17.279 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

; --- Overextrusion repair (skim)  conf=0.87 ---
;     bed region: (12.57,11.03) -> (14.61,13.59)
G1 Z1.400 F600
G0 X12.573 Y11.033 F7800
G1 Z0.400 F600
G0 X12.573 Y11.033 F7800
G1 X14.605 Y11.033 F300
G0 X14.605 Y12.266 F7800
G1 X12.573 Y12.266 F300
G0 X12.573 Y13.499 F7800
G1 X14.605 Y13.499 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

; --- Overextrusion repair (skim)  conf=0.87 ---
;     bed region: (14.24,9.16) -> (16.11,11.74)
G1 Z1.400 F600
G0 X14.235 Y9.160 F7800
G1 Z0.400 F600
G0 X14.235 Y9.160 F7800
G1 X16.110 Y9.160 F300
G0 X16.110 Y10.393 F7800
G1 X14.235 Y10.393 F300
G0 X14.235 Y11.626 F7800
G1 X16.110 Y11.626 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

; --- Overextrusion repair (skim)  conf=0.90 ---
;     bed region: (-17.74,2.62) -> (-14.97,4.91)
G1 Z1.400 F600
G0 X-17.738 Y2.615 F7800
G1 Z0.400 F600
G0 X-17.738 Y2.615 F7800
G1 X-14.970 Y2.615 F300
G0 X-14.970 Y3.848 F7800
G1 X-17.738 Y3.848 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

; --- Overextrusion repair (skim)  conf=0.93 ---
;     bed region: (-29.11,-29.76) -> (-24.91,-25.59)
G1 Z1.400 F600
G0 X-29.113 Y-29.760 F7800
G1 Z0.400 F600
G0 X-29.113 Y-29.760 F7800
G1 X-24.910 Y-29.760 F300
G0 X-24.910 Y-28.527 F7800
G1 X-29.113 Y-28.527 F300
G0 X-29.113 Y-27.294 F7800
G1 X-24.910 Y-27.294 F300
G0 X-24.910 Y-26.061 F7800
G1 X-29.113 Y-26.061 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

G1 Z2.400 F600
; --- Phase 1 complete: layer plane re-established ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
