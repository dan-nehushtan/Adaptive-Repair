; ============================================================
; ADAPTIVE REPAIR G-CODE
; Layer 0   Z=0.400 mm
; Defects: 7
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
; >>> PHASE 1: MILL ALL BOUNDING BOXES (7)
;     Overextrusion  : 7 regions (skim excess)
;     Underextrusion : 0 regions (cut clean cavity)
;     Travel optimised: 153.0 -> 109.8 mm (28% saved)
; 
; --- Mill skim: Overextrusion  conf=0.86 ---
;     bed region: (-9.30,11.97) -> (-4.72,17.00)
G1 Z2.400 F600
G0 X-9.300 Y11.969 F7800
G1 Z0.400 F600
G1 X-4.721 Y11.969 F200
G1 X-4.721 Y13.202 F200
G1 X-9.300 Y13.202 F200
G1 X-9.300 Y14.435 F200
G1 X-4.721 Y14.435 F200
G1 X-4.721 Y15.668 F200
G1 X-9.300 Y15.668 F200
G1 X-9.300 Y16.901 F200
G1 X-4.721 Y16.901 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.89 ---
;     bed region: (0.60,15.98) -> (3.34,18.69)
G1 Z2.400 F600
G0 X0.599 Y15.978 F7800
G1 Z0.400 F600
G1 X3.339 Y15.978 F200
G1 X3.339 Y17.211 F200
G1 X0.599 Y17.211 F200
G1 X0.599 Y18.444 F200
G1 X3.339 Y18.444 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.87 ---
;     bed region: (3.71,15.69) -> (6.08,18.31)
G1 Z2.400 F600
G0 X3.713 Y15.690 F7800
G1 Z0.400 F600
G1 X6.075 Y15.690 F200
G1 X6.075 Y16.923 F200
G1 X3.713 Y16.923 F200
G1 X3.713 Y18.156 F200
G1 X6.075 Y18.156 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.87 ---
;     bed region: (6.51,14.96) -> (8.51,17.51)
G1 Z2.400 F600
G0 X6.509 Y14.957 F7800
G1 Z0.400 F600
G1 X8.514 Y14.957 F200
G1 X8.514 Y16.190 F200
G1 X6.509 Y16.190 F200
G1 X6.509 Y17.423 F200
G1 X8.514 Y17.423 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.86 ---
;     bed region: (14.31,9.21) -> (16.10,11.71)
G1 Z2.400 F600
G0 X14.314 Y9.207 F7800
G1 Z0.400 F600
G1 X16.098 Y9.207 F200
G1 X16.098 Y10.440 F200
G1 X14.314 Y10.440 F200
G1 X14.314 Y11.673 F200
G1 X16.098 Y11.673 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.86 ---
;     bed region: (-16.66,7.81) -> (-13.90,10.28)
G1 Z2.400 F600
G0 X-16.661 Y7.809 F7800
G1 Z0.400 F600
G1 X-13.901 Y7.809 F200
G1 X-13.901 Y9.042 F200
G1 X-16.661 Y9.042 F200
G1 X-16.661 Y10.275 F200
G1 X-13.901 Y10.275 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.91 ---
;     bed region: (-28.89,-29.51) -> (-25.00,-25.71)
G1 Z2.400 F600
G0 X-28.892 Y-29.513 F7800
G1 Z0.400 F600
G1 X-24.999 Y-29.513 F200
G1 X-24.999 Y-28.280 F200
G1 X-28.892 Y-28.280 F200
G1 X-28.892 Y-27.047 F200
G1 X-24.999 Y-27.047 F200
G1 X-24.999 Y-25.814 F200
G1 X-28.892 Y-25.814 F200
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
