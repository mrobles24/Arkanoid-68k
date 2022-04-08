; =============================================================================
; TITLE    : LIFE MANAGEMENT
; AUTHOR   : MIQUEL ROBLES
; COMMENTS :
; HISTORY  : 02-01-2021 - CREATION
; =============================================================================

; -----------------------------------------------------------------------------
LIFEINIT
; INITIALIZE LIFE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.B  #3,(LIVES)              ; START WITH 3 LIVES
            MOVE.W  #SCRWIDTH/2+250,(LIFEX) ; INITIAL LIFE INDICATOR X
            RTS

; -----------------------------------------------------------------------------
LIFEUPD
; UPDATE LIFE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            SUB.B   #1,(LIVES)              ; -1 LIFE
            RTS

; -----------------------------------------------------------------------------
LIFEPLOT
; PLOT LIFE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D6/A0-A1,-(A7)          ; STACK REGISTERS
            MOVE.L  #$000000FF,D1           ; TEXT COLOR
            MOVE.L  #$04080001,D2           ; TEXT PROPERTIES
            MOVE.B  #21,D0                  ; SET PROPERTIES
            TRAP    #15                     ; DO IT
            
            MOVE.W  #((133-6)/2)<<8|1,D1   ; FIRST TEXT COORDINATES
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR0,A1                ; STRING POINTER
            MOVE.B  #13,D0                  ; PRINT STRING TASK
            TRAP    #15                     ; DO IT

            MOVE.B  #80,D0                  ; SET PEN COLOR TASK
            MOVE.L  #LIFEPCOL,D1            ; PEN COLOR
            TRAP    #15                     ; SET PEN COLOR
            ADDQ.B  #1,D0                   ; SET FILL COLOR TASK
            MOVE.L  #LIFEFCOL,D1            ; FILL COLOR
            TRAP    #15                     ; SET FILL COLOR
                    
            MOVE.B  (LIVES),D5              ; LIFE COUNTER IN D5
            SUB.B   #1,D5
            LEA     .SPACES,A0            
.LOOP                                       ; LIFE REMAINING, CREATE INDICATOR
            MOVE.W  (LIFEX),D1              ; D1:=XCENTER
            MOVE.W  #LIFEY,D2               ; D2:=YCENTER
            MOVE.W  D1,D3                   ; D3:=XCENTER
            MOVE.W  D2,D4                   ; D4:=YCENTER           
            SUB.W   #LIFEWIDTH/2,D1         ; D1:=XLEFT
            SUB.W   #LIFEHEIGH/2,D2         ; D2:=YTOP
            ADD.W   #LIFEWIDTH/2,D3         ; D3:=XRIGTH
            ADD.W   #LIFEHEIGH/2,D4         ; D4:=YBOTTOM
            MOVE.B  #87,D0                  ; DRAW ELLIPSE/CIRCLE TASK
            TRAP    #15                     ; DO IT            
            
            MOVE.W  (A0),D6                 
            ADD.W   D6,(LIFEX)              ; SPACE LIFE INDICATORS
            DBRA    D5,.LOOP                ; IS THERE LIFES REMAINING TO DRAW?
.END                                        ; NO: END PLOT
            MOVE.W  #SCRWIDTH/2+250,(LIFEX) ; INITIAL LIFE INDICATOR X POSITION 
            MOVEM.L (A7)+,D0-D6/A0-A1          ; RECOVER STACKED REGISTERS
            
            RTS
            
.SPACES     DC.W    20
            
.STR0       DC.B    'LIVES:',0
            DS.W 0
            






*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~0~
*~Tab size~4~
