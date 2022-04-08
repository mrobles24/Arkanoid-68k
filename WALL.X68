; =============================================================================
; TITLE    : WALL MANAGEMENT (AGENT)
; AUTHOR   : MIQUEL ROBLES
; COMMENTS : WALL AGENT LOCAL VARIABLES:
;             (A0) : XCENTER - WORD
;            2(A0) : YCENTER - WORD
;            4(A0) : WALLFCOL- LONG
; HISTORY  : 20-12-2020 - CREATION
;            13-01-2021 - LAST MODIFICATION  
; =============================================================================

; -----------------------------------------------------------------------------
WALLINIT
; INITIALIZE THE PAD
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.W  (WALLX),(A0)            ; LOAD WALL X INTO AGENT MEMORY
            MOVE.W  (WALLY),2(A0)           ; LOAD WALL Y INTO AGENT MEMORY
            MOVE.L  (WALLFCOL),4(A0)        ; LOAD WALL FCOLOR INTO AGENT MEM.
            RTS

; -----------------------------------------------------------------------------
WALLUPD
; UPDATE THE PAD
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            RTS

; -----------------------------------------------------------------------------
WALLPLOT
; PLOT THE PAD
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D4,-(A7)             ; STACK REGISTER
            
            MOVE.B  #80,D0                  ; SET PEN COLOR TASK
            MOVE.L  #WALLPCOL,D1            ; PEN COLOR
            TRAP    #15                     ; SET PEN COLOR
            
            ADDQ.B  #1,D0                   ; SET FILL COLOR TASK
            MOVE.L  4(A0),D1                ; FILL COLOR
            TRAP    #15                     ; SET FILL COLOR
            
            MOVE.W  (A0),D1                 ; D1:=XCENTER
            MOVE.W  2(A0),D2                ; D2:=YCENTER
            MOVE.W  D1,D3                   ; D3:=XCENTER
            MOVE.W  D2,D4                   ; D4:=YCENTER
            SUB.W   #WALLWIDTH/2,D1         ; D1:=XLEFT
            SUB.W   #WALLHEIGH/2,D2         ; D2:=YTOP
            ADD.W   #WALLWIDTH/2,D3         ; D3:=XRIGHT
            ADD.W   #WALLHEIGH/2,D4         ; D4:=YBOTTOM
            MOVE.B  #87,D0
            
            TRAP    #15                     ; DRAW RECTANGLE
            
            MOVEM.L (A7)+,D0-D4             ; RECOVER STACKED REGISTERS
            
            RTS








*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~0~
*~Tab size~4~
