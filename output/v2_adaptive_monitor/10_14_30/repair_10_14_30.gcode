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
;     Overextrusion  : 0 regions (skim excess)
;     Underextrusion : 2 regions (cut clean cavity)
;     Travel optimised: 16.2 -> 16.2 mm (0% saved)
; 
; --- Mill cavity: Underextrusion  conf=0.92 ---
;     bed region: (-12.94,-5.44) -> (-1.56,5.89)
G1 Z2.400 F600
G0 X-12.943 Y-5.438 F7800
G1 Z0.400 F600
G1 X-1.556 Y-5.438 F200
G1 X-1.556 Y-4.205 F200
G1 X-12.943 Y-4.205 F200
G1 X-12.943 Y-2.972 F200
G1 X-1.556 Y-2.972 F200
G1 X-1.556 Y-1.739 F200
G1 X-12.943 Y-1.739 F200
G1 X-12.943 Y-0.506 F200
G1 X-1.556 Y-0.506 F200
G1 X-1.556 Y0.727 F200
G1 X-12.943 Y0.727 F200
G1 X-12.943 Y1.960 F200
G1 X-1.556 Y1.960 F200
G1 X-1.556 Y3.193 F200
G1 X-12.943 Y3.193 F200
G1 X-12.943 Y4.426 F200
G1 X-1.556 Y4.426 F200
G1 X-1.556 Y5.659 F200
G1 X-12.943 Y5.659 F200
G1 Z2.400 F600
; --- end mill cavity ---

; --- Mill cavity: Underextrusion  conf=0.90 ---
;     bed region: (-15.19,-9.33) -> (-9.99,-4.52)
G1 Z2.400 F600
G0 X-15.194 Y-9.326 F7800
G1 Z0.400 F600
G1 X-9.986 Y-9.326 F200
G1 X-9.986 Y-8.093 F200
G1 X-15.194 Y-8.093 F200
G1 X-15.194 Y-6.860 F200
G1 X-9.986 Y-6.860 F200
G1 X-9.986 Y-5.627 F200
G1 X-15.194 Y-5.627 F200
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
; >>> PHASE 2: DEPOSIT INTO UNDEREXTRUSION CAVITIES (2)
;     Fill milled cavities with ceramic
;     Travel optimised: 17.8 -> 8.9 mm (50% saved)
; 
M14  ; purge nozzle

; --- Underextrusion repair  conf=0.90 ---
;     bed region: (-15.19,-9.33) -> (-9.99,-4.52)
G1 A0.00000 F60
G1 Z2.400 F600
G0 X-15.194 Y-9.326 F7800
G1 Z0.400 F600
G1 A0.00000 F60
G1 X-9.986 Y-9.326 A0.00222 F300
G1 X-9.986 Y-8.093 F7800
G1 X-15.194 Y-8.093 A0.00443 F300
G1 X-15.194 Y-6.860 F7800
G1 X-9.986 Y-6.860 A0.00665 F300
G1 X-9.986 Y-5.627 F7800
G1 X-15.194 Y-5.627 A0.00886 F300
G1 A0.00886 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Underextrusion repair  conf=0.92 ---
;     bed region: (-12.94,-5.44) -> (-1.56,5.89)
G1 A0.00886 F60
G1 Z2.400 F600
G0 X-12.943 Y-5.438 F7800
G1 Z0.400 F600
G1 A0.00886 F60
G1 X-1.556 Y-5.438 A0.01371 F300
G1 X-1.556 Y-4.205 F7800
G1 X-12.943 Y-4.205 A0.01855 F300
G1 X-12.943 Y-2.972 F7800
G1 X-1.556 Y-2.972 A0.02339 F300
G1 X-1.556 Y-1.739 F7800
G1 X-12.943 Y-1.739 A0.02824 F300
G1 X-12.943 Y-0.506 F7800
G1 X-1.556 Y-0.506 A0.03308 F300
G1 X-1.556 Y0.727 F7800
G1 X-12.943 Y0.727 A0.03793 F300
G1 X-12.943 Y1.960 F7800
G1 X-1.556 Y1.960 A0.04277 F300
G1 X-1.556 Y3.193 F7800
G1 X-12.943 Y3.193 A0.04761 F300
G1 X-12.943 Y4.426 F7800
G1 X-1.556 Y4.426 A0.05246 F300
G1 X-1.556 Y5.659 F7800
G1 X-12.943 Y5.659 A0.05730 F300
G1 A0.05730 F60
G1 Z2.400 F600
; --- end underextrusion repair ---

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
