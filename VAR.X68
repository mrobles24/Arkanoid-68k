; =============================================================================
; TITLE    : GAME VARIABLES
; AUTHOR   : MIQUEL ROBLES
; HISTORY  : 12-20-2021 - CREATION
;            11-01-2021 - LAST MODIFICATION  
; =============================================================================

; --- PAD RELATED VARIABLES ---------------------------------------------------

PADX        DS.W    1                       ; PAD X COORDINATE (XCENTER)

; --- RANDOM NUMBER GENERATOR VARIABLES ---------------------------------------

RNDINDEX    DS.B    1                       ; RANDOM INDEX
            DS.W    0
            
; --- STATE MANAGEMENT VARIABLES ----------------------------------------------

STACUR      DS.W    1                       ; CURRENT STATE
STANEXT     DS.W    1                       ; NEXT STATE

; --- LIVES VARIABLES ---------------------------------------------------------

LIVES       DS.B    1                       ; NUMBER OF LIVES
            DS.W    0
LIFEX       DS.W    1                       ; LIFE BAR X LOCATION

; --- WALL VARIABLES ----------------------------------------------------------

WALLTOTAL   DS.W    1                       ; NUMBER OF WALLS
WALLX       DS.W    1                       ; INITIAL WALL X
WALLY       DS.W    1                       ; INITIAL WALL Y
WALLFCOL    DS.L    1                       ; WALL FIL COLOR
XLIST       DS.W    36                      ; WALL X COORDINATES LIST
YLIST       DS.W    36                      ; WALL Y COORDINATES LIST

; --- POINT VARIABLES ---------------------------------------------------------

POINTS      DS.W    1                       ; NUMBER OF POINTS

; --- FILE VARIABLES ----------------------------------------------------------

SIZE        DS.W    1                       ; SIZE OF READ FILE
FILEDATA    DS.B    2000                    ; FILE BUFFER
            DS.W    0













*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~0~
*~Tab size~4~
