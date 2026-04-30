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
;     Travel optimised: 18.9 -> 18.9 mm (0% saved)
; 
; --- Overextrusion repair (skim)  conf=0.91 ---
;     bed region: (12.96,10.82) -> (15.41,14.13)
G1 Z1.400 F600
G0 X12.958 Y10.823 F7800
G1 Z0.400 F600
G0 X12.958 Y10.823 F7800
G1 X15.410 Y10.823 F300
G0 X15.410 Y12.056 F7800
G1 X12.958 Y12.056 F300
G0 X12.958 Y13.289 F7800
G1 X15.410 Y13.289 F300
G1 Z1.400 F600
; --- end overextrusion repair ---

G1 Z2.400 F600
; --- Phase 1 complete: layer plane re-established ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
