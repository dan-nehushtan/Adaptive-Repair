; ============================================================
; ADAPTIVE REPAIR G-CODE
; Layer 0   Z=0.400 mm
; Defects: 4
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
; >>> PHASE 1: MILL ALL BOUNDING BOXES (4)
;     Overextrusion  : 4 regions (skim excess)
;     Underextrusion : 0 regions (cut clean cavity)
;     Travel optimised: 106.8 -> 86.3 mm (19% saved)
; 
; --- Mill skim: Overextrusion  conf=0.88 ---
;     bed region: (16.50,8.31) -> (18.56,10.45)
G1 Z2.400 F600
G0 X16.496 Y8.307 F7800
G1 Z0.400 F600
G1 X18.563 Y8.307 F200
G1 X18.563 Y9.540 F200
G1 X16.496 Y9.540 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.87 ---
;     bed region: (15.21,12.42) -> (16.85,14.13)
G1 Z2.400 F600
G0 X15.209 Y12.417 F7800
G1 Z0.400 F600
G1 X16.852 Y12.417 F200
G1 X16.852 Y13.650 F200
G1 X15.209 Y13.650 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.87 ---
;     bed region: (12.71,14.36) -> (14.33,16.42)
G1 Z2.400 F600
G0 X12.708 Y14.360 F7800
G1 Z0.400 F600
G1 X14.331 Y14.360 F200
G1 X14.331 Y15.593 F200
G1 X12.708 Y15.593 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.91 ---
;     bed region: (-28.97,-29.27) -> (-25.22,-25.48)
G1 Z2.400 F600
G0 X-28.968 Y-29.270 F7800
G1 Z0.400 F600
G1 X-25.222 Y-29.270 F200
G1 X-25.222 Y-28.037 F200
G1 X-28.968 Y-28.037 F200
G1 X-28.968 Y-26.804 F200
G1 X-25.222 Y-26.804 F200
G1 X-25.222 Y-25.571 F200
G1 X-28.968 Y-25.571 F200
G1 Z2.400 F600
; --- end mill skim ---

G1 Z2.400 F600
M5  ; spindle off after milling
; --- Phase 1 complete: all regions milled ---

; >>> RETURNING MILL (no underextrusion to fill)
M5  ; spindle off
; --- TOOL CHANGE: ceramic nozzle ---
G1 Z50.000 F600
G0 X0.000 Y0.000 F7800
M6 T0  ; pick up ceramic nozzle
; Tool T0 loaded
G92 A0

; --- Repair complete ---
G0 Z5.400 F7800
G0 X0.000 Y0.000 F7800
M2  ; program end
