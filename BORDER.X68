; =============================================================================
; TITLE    : BORDER MANAGEMENT
; AUTHOR   : MIQUEL ROBLES
; COMMENTS :
; HISTORY  : 02-01-2021 - CREATION
; =============================================================================

; -----------------------------------------------------------------------------
BORDINIT
; INITIALIZE THE BORDER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            RTS

; -----------------------------------------------------------------------------
BORDUPD
; UPDATE THE BORDER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            RTS
            
; -----------------------------------------------------------------------------
BORDPLOT
; PLOT THE BORDER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D4,-(A7)             ; STACK REGISTER
            
            MOVE.B  #80,D0                  ; SET PEN COLOR TASK
            MOVE.L  #BORDPCOL,D1            ; PEN COLOR
            TRAP    #15                     ; SET PEN COLOR
            ADDQ.B  #1,D0                   ; SET FILL COLOR TASK
            MOVE.L  #BORDFCOL,D1            ; FILL COLOR
            TRAP    #15                     ; SET FILL COLOR
            MOVE.W  #BORDX1,D1              ; D1:=XCENTER
            MOVE.W  #BORDY1,D2              ; D2:=YCENTER
            MOVE.W  #BORDX2,D3              ; D3:=XCENTER
            MOVE.W  #BORDY2,D4              ; D4:=YCENTER
            MOVE.B  #87,D0
            TRAP    #15                     ; DRAW RECTANGLE
            
            MOVEM.L (A7)+,D0-D4             ; RESTORE REGISTERS
            RTS


*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~0~
*~Tab size~4~
