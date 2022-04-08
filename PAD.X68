; =============================================================================
; TITLE    : PAD MANAGEMENT
; AUTHOR   : MIQUEL ROBLES
; COMMENTS : 
; HISTORY  : 20-12-2020 - CREATION
; =============================================================================

; -----------------------------------------------------------------------------
PADINIT
; INITIALIZE THE PAD
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.W  #SCRWIDTH/2,(PADX)
            RTS

; -----------------------------------------------------------------------------
PADUPD
; UPDATE THE PAD
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            BTST.B  #KBDBITLF,(KBDVAL)      ; LEFT KEY PRESSED?
            BNE     .MOVEL                  ; YES: MOVE LEFT
            BTST.B  #KBDBITRT,(KBDVAL)      ; RIGHT KEY PRESSED?
            BNE     .MOVER                  ; YES: MOVE LEFT
            RTS
.MOVEL      CMP.W   #PADWIDTH/2,(PADX)      ; BELOW LEFT BOUNDARY?
            BGT     .DOL                    ; NO: MOVE
            RTS                             ; YES: END
.DOL        SUB.W   #PADSPEED,(PADX)        ; MOVE LEFT
            RTS
.MOVER      CMP.W   #SCRWIDTH-1-PADWIDTH/2,(PADX) ; HIGHER THAN RIGHT BOUNDARY?
            BLT     .DOR                    ; NO: MOVE
            RTS                             ; YES: END
.DOR        ADD.W   #PADSPEED,(PADX)        ; MOVE RIGHT
            RTS

; -----------------------------------------------------------------------------
PADPLOT
; PLOT THE PAD
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D4,-(A7)             ; STACK REGISTER
            
            MOVE.B  #80,D0                  ; SET PEN COLOR TASK
            MOVE.L  #PADPCOL,D1             ; PEN COLOR
            TRAP    #15                     ; SET PEN COLOR
            ADDQ.B  #1,D0                   ; SET FILL COLOR TASK
            MOVE.L  #PADFCOL,D1             ; FILL COLOR
            TRAP    #15                     ; SET FILL COLOR
            MOVE.W  (PADX),D1               ; D1:=XCENTER
            MOVE.W  #PADY,D2                ; D2:=YCENTER
            MOVE.W  D1,D3                   ; D3:=XCENTER
            MOVE.W  D2,D4                   ; D4:=YCENTER
            SUB.W   #PADWIDTH/2,D1          ; D1:=XLEFT
            SUB.W   #PADHEIGH/2,D2          ; D2:=YTOP
            ADD.W   #PADWIDTH/2,D3          ; D3:=XRIGHT
            ADD.W   #PADHEIGH/2,D4          ; D4:=YBOTTOM
            MOVE.B  #88,D0
            TRAP    #15                     ; DRAW ELIPSE
            
            MOVEM.L (A7)+,D0-D4             ; RESTORE REGISTERS
            RTS
            





*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~0~
*~Tab size~4~
