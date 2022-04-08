; =============================================================================
; TITLE    : ARKANOID 20.21 (MAIN PROGRAM)
; AUTHOR   : MIQUEL ROBLES
; HISTORY  : 20-12-2020 - CREATION
;            16-01-2021 - LAST MODIFICATION  
; =============================================================================

            ORG     $1000

; --- CODE INCLUDES -----------------------------------------------------------

            INCLUDE "SYSCONST.X68"          ; SYSTEM CONSTANTS
            INCLUDE "SYSTEM.X68"            ; SYSTEM CODE
            INCLUDE "CONST.X68"             ; GAME CONSTANTS
            INCLUDE "RANDOM.X68"            ; RANDOM NUMBER GENERATOR
            INCLUDE "STATES.X68"            ; STATE MANAGEMENT
            INCLUDE "PAD.X68"               ; PAD MANAGEMENT
            INCLUDE "AGENTLST.X68"          ; AGENT LIST MANAGEMENT
            INCLUDE "BALL.X68"              ; BALL MANAGEMENT
            INCLUDE "LIFE.X68"              ; LIFE MANAGEMENT
            INCLUDE "WALL.X68"              ; WALL MANAGEMENT
            INCLUDE "BORDER.X68"            ; BORDER MANAGEMENT
            INCLUDE "POINT.X68"             ; POINTS MANAGEMENT
            INCLUDE "FILE.X68"              ; FILE MANAGEMENT

; --- INITIALIZE --------------------------------------------------------------

START       JSR     SYSINIT                 ; INITIALIZE SYSTEM-RELATED STUFF
            JSR     STAINIT                 ; INITIALIZES STATES

; --- UPDATE ------------------------------------------------------------------

.LOOP       TRAP    #KBDTRAP                ; READ KEYBOARD
            TRAP    #MOUTRAP                ; READ MOUSE
            JSR     STAUPD                  ; UPDATE STATES

; --- WAIT SYNCH --------------------------------------------------------------

.WINT       TST.B   (SCRINTCT)              ; WAIT FOR INTERRUPT
            BEQ     .WINT
            CLR.B   (SCRINTCT)

; --- PLOT --------------------------------------------------------------------

            JSR     STAPLOT                 ; PLOT STATES
            TRAP    #SCRTRAP                ; SHOW GRAPHICS
            BRA     .LOOP                   ; MAIN LOOP
            SIMHALT

; --- VARIABLES ---------------------------------------------------------------

            INCLUDE "SYSVAR.X68"
            INCLUDE "VAR.X68"
            END    START












*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~0~
*~Tab size~4~
