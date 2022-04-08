; =============================================================================
; TITLE    : GAME CONSTANTS
; AUTHOR   : MIQUEL ROBLES
; HISTORY  : 20-12-2020 - CREATION
;            16-01-2021 - LAST MODIFICATION  
; =============================================================================

; --- STATE RELATED VARIABLES -------------------------------------------------

STAINTRO    EQU     0                       ; GAME INTRO SCREEN STATE
STAGAME     EQU     1                       ; GAME STATE
STAGOVER    EQU     2                       ; GAME OVER STATE
STAVIC      EQU     3                       ; GAME VICTORY STATE
STAFIN      EQU     4                       ; FINISH STATE

; --- PAD RELATED CONSTANTS ---------------------------------------------------

PADWIDTH    EQU     50                      ; PAD WIDTH
PADHEIGH    EQU     10                      ; PAD HEIGHT
PADPCOL     EQU     $00FFFFFF               ; PEN COLOR
PADFCOL     EQU     $00000000               ; FILL COLOR
PADY        EQU     SCRHEIGH-PADHEIGH-PADHEIGH/2-10 ; PAD Y COORDINATE
PADSPEED    EQU     8                       ; PAD SPEED

; --- BALL RELATED CONSTANTS --------------------------------------------------

BALNUM      EQU     1                       ; INITIAL NUMBER OF BALL AGENTS
BALID       EQU     1                       ; BALL IDENTIFIER
BALRAD      EQU     5                       ; BALL RADIUS
BALPCOL     EQU     $000000FF               ; PEN COLOR
BALFCOL     EQU     $00003300               ; FILL COLOR
BALSPEED    EQU     5                       ; BALL REFERENCE SPEED

; --- LIFE RELATED CONSTANTS --------------------------------------------------

LIFEWIDTH   EQU     10                      ; LIFE BAR WIDHT
LIFEHEIGH   EQU     10                      ; LIFE BAR HEIGHT
LIFEY       EQU     SCRHEIGH/2-225          ; LIFE BAR Y COORDINATE
LIFEPCOL    EQU     $00FFFFFF               ; PEN COLOR
LIFEFCOL    EQU     $000000FF               ; FILL COLOR

; --- LIFE RELATED CONSTANTS --------------------------------------------------

POINTX      EQU     30                      ; POINT X COORDINATE
POINTY      EQU     SCRHEIGH/2-225          ; POINT Y COORDINATE
POINTCOL    EQU     $000000FF               ; POINT COLOR


; --- WALL RELATED CONSTANTS --------------------------------------------------

WALLNUM     EQU     12                      ; NUMBER OF WALLS IN A LINE
WALLLNNUM   EQU     3                       ; NUMBER OF WALL LINES
WALLID      EQU     2                       ; WALL IDENTIFIER
WALLWIDTH   EQU     40                      ; WALL WIDTH
WALLHEIGH   EQU     15                      ; WALL HEIGHT
WALLPCOL    EQU     $00000000               ; WALL PEN COLOR

; --- BORDERS RELATED CONSTANTS -----------------------------------------------

BORDX1      EQU     SCRWIDTH-645            ; BORDER X1 COORDINATE
BORDX2      EQU     640                     ; BORDER X2 COORDINATE
BORDY1      EQU     SCRHEIGH/2-210          ; BORDER Y1 COORDINATE
BORDY2      EQU     SCRHEIGH/2-213          ; BORDER Y2 COORDINATE
BORDPCOL    EQU     $00FFFFFF               ; BORDER PEN COLOR
BORDFCOL    EQU     $0000000                ; BORDER FILL COLOR

; --- SOUND RELATED CONSTANTS -------------------------------------------------
;
; COMMENTS: IF YOUR COMPUTER DOES NOT HAVE DIRECT X INSTALLED, CHANGE THESE
;           CONSTANTS FOR:
;           LOADSOUND -> 71
;           PLAYSOUND -> 72
;           CTRLSOUND -> 76                                            
; ----------------------------------------------------------------------------

LOADSOUND   EQU     74                      ; LOAD SOUND INTO MEMORY (DIRECTX)
PLAYSOUND   EQU     75                      ; PLAY SOUND FROM MEMORY (DIRECTX)
CTRLSOUND   EQU     77                      ; CTRL SOUND FROM MEMORY (DIRECTX)          

; --- FILE RELATED CONSTANTS -------------------------------------------------

READSIZE    EQU     2                       ; NMBR OF BYTES TO READ    
 













*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~0~
*~Tab size~4~
