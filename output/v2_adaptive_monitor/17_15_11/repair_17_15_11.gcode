; ============================================================
; ADAPTIVE REPAIR G-CODE
; Layer 0   Z=0.400 mm
; Defects: 3
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
; >>> PHASE 1: MILL ALL BOUNDING BOXES (3)
;     Overextrusion  : 0 regions (skim excess)
;     Underextrusion : 3 regions (cut clean cavity)
;     Travel optimised: 9.7 -> 9.7 mm (0% saved)
; 
; --- Mill cavity: Underextrusion  conf=0.93 ---
;     bed region: (0.20,-3.94) -> (6.16,1.59)
G1 Z2.400 F600
G0 X0.195 Y-3.943 F7800
G1 Z0.400 F600
G1 X6.160 Y-3.943 F200
G1 X6.160 Y-2.710 F200
G1 X0.195 Y-2.710 F200
G1 X0.195 Y-1.477 F200
G1 X6.160 Y-1.477 F200
G1 X6.160 Y-0.244 F200
G1 X0.195 Y-0.244 F200
G1 X0.195 Y0.989 F200
G1 X6.160 Y0.989 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.90 ---
;     bed region: (2.17,-5.28) -> (8.61,0.82)
G1 Z2.400 F600
G0 X2.166 Y-5.283 F7800
G1 Z0.400 F600
G1 X8.606 Y-5.283 F200
G1 X8.606 Y-4.050 F200
G1 X2.166 Y-4.050 F200
G1 X2.166 Y-2.817 F200
G1 X8.606 Y-2.817 F200
G1 X8.606 Y-1.584 F200
G1 X2.166 Y-1.584 F200
G1 X2.166 Y-0.351 F200
G1 X8.606 Y-0.351 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.88 ---
;     bed region: (1.92,-7.40) -> (5.49,-4.08)
G1 Z2.400 F600
G0 X1.918 Y-7.396 F7800
G1 Z0.400 F600
G1 X5.493 Y-7.396 F200
G1 X5.493 Y-6.163 F200
G1 X1.918 Y-6.163 F200
G1 X1.918 Y-4.930 F200
G1 X5.493 Y-4.930 F200
G1 Z2.400 F600
; --- end mill cavity ---

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
; >>> PHASE 2: DEPOSIT INTO UNDEREXTRUSION CAVITIES (3)
;     Fill milled cavities with ceramic
;     Travel optimised: 10.9 -> 6.3 mm (42% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.88 ---
;     bed region: (1.92,-7.40) -> (5.49,-4.08)
G1 A0.00000 F60
G1 Z2.400 F600
G0 X1.918 Y-7.396 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G1 X5.493 Y-7.396 A0.00152 F300
G1 X5.493 Y-6.163 F7800
G1 X1.918 Y-6.163 A0.00304 F300
G1 X1.918 Y-4.930 F7800
G1 X5.493 Y-4.930 A0.00456 F300
G1 A0.00456 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.90 ---
;     bed region: (2.17,-5.28) -> (8.61,0.82)
G1 A0.00456 F60
G1 Z2.400 F600
G0 X2.166 Y-5.283 F7800
G1 Z0.400 F600
G1 A0.00456 F60
G1 X8.606 Y-5.283 A0.00730 F300
G1 X8.606 Y-4.050 F7800
G1 X2.166 Y-4.050 A0.01004 F300
G1 X2.166 Y-2.817 F7800
G1 X8.606 Y-2.817 A0.01278 F300
G1 X8.606 Y-1.584 F7800
G1 X2.166 Y-1.584 A0.01552 F300
G1 X2.166 Y-0.351 F7800
G1 X8.606 Y-0.351 A0.01826 F300
G1 A0.01826 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.93 ---
;     bed region: (0.20,-3.94) -> (6.16,1.59)
G1 A0.01826 F60
G1 Z2.400 F600
G0 X0.195 Y-3.943 F7800
G1 Z0.400 F600
G1 A0.01826 F60
G1 X6.160 Y-3.943 A0.02080 F300
G1 X6.160 Y-2.710 F7800
G1 X0.195 Y-2.710 A0.02333 F300
G1 X0.195 Y-1.477 F7800
G1 X6.160 Y-1.477 A0.02587 F300
G1 X6.160 Y-0.244 F7800
G1 X0.195 Y-0.244 A0.02841 F300
G1 X0.195 Y0.989 F7800
G1 X6.160 Y0.989 A0.03095 F300
G1 A0.03095 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
