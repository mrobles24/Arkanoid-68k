; =============================================================================
; TITLE    : POINT MANAGEMENT
; AUTHOR   : MIQUEL ROBLES
; COMMENTS :
; HISTORY  : 11-01-2021 - CREATION
;            15-01-2021 - LAST MODIFICATION  
; =============================================================================

; -----------------------------------------------------------------------------
POINTINIT
; INITIALIZE POINTS
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.L  #0,(POINTS)             ; INITIALIZE POINT COUNTER
            RTS

; -----------------------------------------------------------------------------
POINTUPD
; UPDATE LIFE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D1,-(A7)             ; STACK REGISTERS
            MOVE.B  (SCRCYCCT),D0
            AND.B   #%0011111,D0
            BNE     .END
            MOVE.W  (POINTS),D1             
            ADD.W   #10,D1                  ; ADD 10 POINTS EVERY SECOND
            MOVE.W  D1,(POINTS)            
.END        MOVEM.L (A7)+,D0-D1             ; UNSTACK REGISTERS
            RTS            

; -----------------------------------------------------------------------------
POINTPLOT
; PLOT LIFE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D6/A0-A1,-(A7)       ; STACK REGISTERS
            
            MOVE.L  #$000000FF,D1           ; TEXT COLOR
            MOVE.L  #$04080001,D2           ; TEXT PROPERTIES
            MOVE.B  #21,D0                  ; SET PROPERTIES
            TRAP    #15                     ; DO IT           
            MOVE.W  #((12-7)/2)<<8|1,D1     ; POINTS TEXT COORDINATES
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR0,A1                ; STRING POINTER
            MOVE.B  #13,D0                  ; PRINT STRING TASK
            TRAP    #15                     ; DO IT
            
            MOVE.L  #$00FFFFFF,D1           ; TEXT COLOR
            MOVE.L  #$04080001,D2           ; TEXT PROPERTIES
            MOVE.B  #21,D0                  ; SET PROPERTIES
            TRAP    #15                     ; DO IT            
            MOVE.W  #((27-7)/2)<<8|1,D1     ; POINTS COORDINATES
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE POINTS CURSOR
            CLR.L   D1                      ; CLEAR POINTS REGISTER
            MOVE.W  (POINTS),D1             ; MOVE POINTS TO REGISTER
            MOVE.B  #10,D2                  ; DISPLAY IN DECIMAL BASE
            MOVE.B  #15,D0                  ; PRINT UNSIGNED NMBR TASK
            TRAP    #15                     ; DO IT           
                             
            MOVEM.L (A7)+,D0-D6/A0-A1       ; RECOVER STACKED REGISTERS
            
            RTS
                        
.STR0       DC.W    'POINTS:',0
            DS.W    0



*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~0~
*~Tab size~4~
