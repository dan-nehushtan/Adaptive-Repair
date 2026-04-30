; ============================================================
; ADAPTIVE REPAIR G-CODE
; Layer 0   Z=0.400 mm
; Defects: 16
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
; >>> PHASE 1: MILL ALL BOUNDING BOXES (16)
;     Overextrusion  : 16 regions (skim excess)
;     Underextrusion : 0 regions (cut clean cavity)
;     Travel optimised: 337.6 -> 179.4 mm (47% saved)
; 
; --- Mill skim: Overextrusion  conf=0.86 ---
;     bed region: (-10.19,-0.97) -> (-8.16,0.86)
G1 Z2.400 F600
G0 X-10.192 Y-0.966 F7800
G1 Z0.400 F600
G1 X-8.161 Y-0.966 F200
G1 X-8.161 Y0.267 F200
G1 X-10.192 Y0.267 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.87 ---
;     bed region: (-8.93,4.53) -> (-6.50,7.65)
G1 Z2.400 F600
G0 X-8.927 Y4.529 F7800
G1 Z0.400 F600
G1 X-6.500 Y4.529 F200
G1 X-6.500 Y5.762 F200
G1 X-8.927 Y5.762 F200
G1 X-8.927 Y6.995 F200
G1 X-6.500 Y6.995 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.87 ---
;     bed region: (-10.75,6.65) -> (-8.66,8.97)
G1 Z2.400 F600
G0 X-10.746 Y6.651 F7800
G1 Z0.400 F600
G1 X-8.665 Y6.651 F200
G1 X-8.665 Y7.884 F200
G1 X-10.746 Y7.884 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.89 ---
;     bed region: (-18.59,6.13) -> (-14.93,8.92)
G1 Z2.400 F600
G0 X-18.586 Y6.127 F7800
G1 Z0.400 F600
G1 X-14.927 Y6.127 F200
G1 X-14.927 Y7.360 F200
G1 X-18.586 Y7.360 F200
G1 X-18.586 Y8.593 F200
G1 X-14.927 Y8.593 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.86 ---
;     bed region: (-18.68,2.56) -> (-17.00,4.41)
G1 Z2.400 F600
G0 X-18.680 Y2.560 F7800
G1 Z0.400 F600
G1 X-17.001 Y2.560 F200
G1 X-17.001 Y3.793 F200
G1 X-18.680 Y3.793 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.87 ---
;     bed region: (-17.84,-5.50) -> (-15.39,-3.21)
G1 Z2.400 F600
G0 X-17.841 Y-5.495 F7800
G1 Z0.400 F600
G1 X-15.393 Y-5.495 F200
G1 X-15.393 Y-4.262 F200
G1 X-17.841 Y-4.262 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.90 ---
;     bed region: (-2.58,9.21) -> (0.12,11.90)
G1 Z2.400 F600
G0 X-2.582 Y9.208 F7800
G1 Z0.400 F600
G1 X0.116 Y9.208 F200
G1 X0.116 Y10.441 F200
G1 X-2.582 Y10.441 F200
G1 X-2.582 Y11.674 F200
G1 X0.116 Y11.674 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.89 ---
;     bed region: (-3.87,11.19) -> (-1.95,13.68)
G1 Z2.400 F600
G0 X-3.870 Y11.189 F7800
G1 Z0.400 F600
G1 X-1.946 Y11.189 F200
G1 X-1.946 Y12.422 F200
G1 X-3.870 Y12.422 F200
G1 X-3.870 Y13.655 F200
G1 X-1.946 Y13.655 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.89 ---
;     bed region: (1.73,12.67) -> (4.02,15.01)
G1 Z2.400 F600
G0 X1.732 Y12.675 F7800
G1 Z0.400 F600
G1 X4.023 Y12.675 F200
G1 X4.023 Y13.908 F200
G1 X1.732 Y13.908 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.86 ---
;     bed region: (2.35,10.01) -> (4.21,11.83)
G1 Z2.400 F600
G0 X2.352 Y10.006 F7800
G1 Z0.400 F600
G1 X4.209 Y10.006 F200
G1 X4.209 Y11.239 F200
G1 X2.352 Y11.239 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.91 ---
;     bed region: (6.75,11.18) -> (9.89,14.16)
G1 Z2.400 F600
G0 X6.748 Y11.179 F7800
G1 Z0.400 F600
G1 X9.891 Y11.179 F200
G1 X9.891 Y12.412 F200
G1 X6.748 Y12.412 F200
G1 X6.748 Y13.645 F200
G1 X9.891 Y13.645 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.90 ---
;     bed region: (11.98,9.28) -> (14.27,11.74)
G1 Z2.400 F600
G0 X11.977 Y9.276 F7800
G1 Z0.400 F600
G1 X14.266 Y9.276 F200
G1 X14.266 Y10.509 F200
G1 X11.977 Y10.509 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.87 ---
;     bed region: (13.99,14.67) -> (16.01,16.59)
G1 Z2.400 F600
G0 X13.992 Y14.666 F7800
G1 Z0.400 F600
G1 X16.008 Y14.666 F200
G1 X16.008 Y15.899 F200
G1 X13.992 Y15.899 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.89 ---
;     bed region: (16.02,-0.65) -> (19.82,3.67)
G1 Z2.400 F600
G0 X16.022 Y-0.651 F7800
G1 Z0.400 F600
G1 X19.816 Y-0.651 F200
G1 X19.816 Y0.582 F200
G1 X16.022 Y0.582 F200
G1 X16.022 Y1.815 F200
G1 X19.816 Y1.815 F200
G1 X19.816 Y3.048 F200
G1 X16.022 Y3.048 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.86 ---
;     bed region: (-7.72,16.49) -> (-4.14,18.99)
G1 Z2.400 F600
G0 X-7.722 Y16.488 F7800
G1 Z0.400 F600
G1 X-4.145 Y16.488 F200
G1 X-4.145 Y17.721 F200
G1 X-7.722 Y17.721 F200
G1 X-7.722 Y18.954 F200
G1 X-4.145 Y18.954 F200
G1 Z2.400 F600
; --- end mill skim ---

; --- Mill skim: Overextrusion  conf=0.90 ---
;     bed region: (-28.86,-29.18) -> (-25.42,-25.78)
G1 Z2.400 F600
G0 X-28.861 Y-29.179 F7800
G1 Z0.400 F600
G1 X-25.418 Y-29.179 F200
G1 X-25.418 Y-27.946 F200
G1 X-28.861 Y-27.946 F200
G1 X-28.861 Y-26.713 F200
G1 X-25.418 Y-26.713 F200
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
