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
; >>> PICKING UP MILLING TOOL
; --- TOOL CHANGE: milling tool ---
G1 Z50.000 F600
G0 X0.000 Y0.000 F7800
M6 T1  ; pick up milling tool
; Tool T1 loaded
M3 S1000  ; spindle on

; 
; >>> PHASE 1: MILL ALL BOUNDING BOXES (2)
;     Overextrusion  : 1 regions (skim excess)
;     Underextrusion : 1 regions (cut clean cavity)
;     Travel optimised: 81.1 -> 59.3 mm (27% saved)
; 
; --- Mill cavity: Underextrusion  conf=0.91 ---
;     bed region: (9.07,-15.26) -> (14.79,-9.64)
G1 Z2.400 F600
G0 X9.070 Y-15.263 F7800
G1 Z0.400 F600
G1 X14.794 Y-15.263 F200
G1 X14.794 Y-14.030 F200
G1 X9.070 Y-14.030 F200
G1 X9.070 Y-12.797 F200
G1 X14.794 Y-12.797 F200
G1 X14.794 Y-11.564 F200
G1 X9.070 Y-11.564 F200
G1 X9.070 Y-10.331 F200
G1 X14.794 Y-10.331 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill skim: Overextrusion  conf=0.88 ---
;     bed region: (-28.77,-29.44) -> (-25.67,-26.34)
G1 Z2.400 F600
G0 X-28.767 Y-29.441 F7800
G1 Z0.400 F600
G1 X-25.671 Y-29.441 F200
G1 X-25.671 Y-28.208 F200
G1 X-28.767 Y-28.208 F200
G1 X-28.767 Y-26.975 F200
G1 X-25.671 Y-26.975 F200
G1 Z2.400 F600
; --- end mill skim ---

G1 Z2.400 F600
M5  ; spindle off after milling
; --- Phase 1 complete: all regions milled ---

; >>> RETURNING MILL, PICKING UP NOZZLE FOR DEPOSITION
M5  ; spindle off
; --- TOOL CHANGE: ceramic nozzle ---
G1 Z50.000 F600
G0 X0.000 Y0.000 F7800
M6 T0  ; pick up ceramic nozzle
; Tool T0 loaded
G92 A0

; 
; >>> PHASE 2: DEPOSIT INTO UNDEREXTRUSION CAVITIES (1)
;     Fill milled cavities with ceramic
;     Travel optimised: 42.1 -> 42.1 mm (0% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.91 ---
;     bed region: (9.07,-15.26) -> (14.79,-9.64)
G1 A0.00000 F60
G1 Z2.400 F600
G0 X9.070 Y-15.263 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G1 X14.794 Y-15.263 A0.00243 F300
G1 X14.794 Y-14.030 F7800
G1 X9.070 Y-14.030 A0.00487 F300
G1 X9.070 Y-12.797 F7800
G1 X14.794 Y-12.797 A0.00730 F300
G1 X14.794 Y-11.564 F7800
G1 X9.070 Y-11.564 A0.00974 F300
G1 X9.070 Y-10.331 F7800
G1 X14.794 Y-10.331 A0.01217 F300
G1 A0.01217 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
