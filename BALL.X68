; =============================================================================
; TITLE    : BALL MANAGEMENT (AGENT)
; AUTHOR   : MIQUEL ROBLES
; COMMENTS : BALL AGENT LOCAL VARIABLES:
;             (A0) : XCENTER - WORD
;            2(A0) : YCENTER - WORD
;            4(A0) : XSPEED  - WORD
;            6(A0) : YSPEED  - WORD
; HISTORY  : 20-12-2020 - CREATION
; =============================================================================

; -----------------------------------------------------------------------------
BALINIT
; INITIALIZE A BALL
; INPUT    - NONE
; OUTPUT   - NONE 
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A1,-(A7)             ; STACK REGISTERS
            JSR     RNDGET                  ; D0.L=RND(0,255)
            ADD.W   #SCRWIDTH/2-127,D0      ; D0.W=RND(XC-127,XC+128)
            MOVE.W  D0,(A0)                 ; XBALL=D0
            JSR     RNDGET                  ; D0.L=RND(0,255)
            ADD.W   #SCRHEIGH/2-127,D0      ; D0.W=RND(YC-127,YC+128)
            MOVE.W  D0,2(A0)                ; YBALL=D0
            
            JSR     RNDGET                  ; DO.L=RND(0,255)
            AND.L   #%00001100,D0           ; MASK D0
            LEA     .SPEEDS,A1              ; GET VECTOR ADDRESS
            MOVE.L  (A1,D0),4(A0)           ; INIT SPEEDS
            MOVEM.L (A7)+,D0/A1
            RTS
            
.SPEEDS     DC.W    BALSPEED,BALSPEED
            DC.W    BALSPEED,-BALSPEED
            DC.W    -BALSPEED,BALSPEED
            DC.W    -BALSPEED,-BALSPEED

; -----------------------------------------------------------------------------
BALUPD
; UPDATE A BALL
; INPUT    - NONE
; OUTPUT   - NONE 
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.W  D0-D2,-(A7)            ; STACK REGISTERS
            MOVE.W  (A0),D0
            ADD.W   4(A0),D0
            MOVE.W  D0,(A0)                 ; X:=X+VX
            MOVE.W  2(A0),D0
            ADD.W   6(A0),D0
            MOVE.W  D0,2(A0)                ; Y:=Y+VY
            
            CMP.W   #BALRAD,(A0)            ; CHECK LEFT BOUNDARY
            BLT     .BOUNCEL                ; IF COLLISION -> BOUNCE
            CMP.W   #SCRWIDTH-1-BALRAD,(A0) ; CHECK RIGHT BOUNDARY
            BGT     .BOUNCER                ; IF COLLISION -> BOUNCE            
.CHKV       CMP.W   #BORDY1+BALRAD,2(A0)    ; CHECK TOP BOUNDARY
            BLT     .BOUNCET                ; IF COLLISION -> BOUNCE
            
            ; CHECK COLLISIONS WITH PAD

.COMPPAD    CMP.W   #PADY-PADHEIGH/2-BALRAD,2(A0) ; YBALL = YPAD?
            BLE     .COMPWALL               ; NO : CHECK COLLISION WITH WALL
            MOVE.W  (PADX),D0
            SUB.W   #PADWIDTH/2+BALRAD,D0
            CMP.W   (A0),D0                 ; XBALL >= XPAD (LEFT)?
            BGE     .CHKKILL                ; NO : CHECK COLLISION WITH BOTTOM            
            MOVE.W  (PADX),D0
            ADD.W   #PADWIDTH/2+BALRAD,D0   
            CMP.W   (A0),D0                 ; XBALL <= XPAD (RIGHT)?
            BLE     .CHKKILL                ; NO : CHECK COLLISION WITH BOTTOM          

            MOVE.W  #PADY-PADHEIGH/2-BALRAD,2(A0) ; ADJUST POSITION
            MOVE.W  #-BALSPEED,6(A0)         ; BOUNCE OF PAD

            MOVE.B  #1,D1                   ; LOAD PAD SOUND
            MOVE.B  #PLAYSOUND,D0
            TRAP    #15                     ; PLAY SOUND

            BRA     .END
            
            ; COLLISIONS WITH PAD CHECKED  
            
            ; CHECK COLLISIONS WITH WALL

.COMPWALL   MOVE.W  (WALLTOTAL),D2           
            SUB.W   #1,D2                   
            LEA     XLIST,A2                ; LOAD WALL X COORDINATE LIST
            LEA     YLIST,A3                ; LOAD WALL Y COORDINATE LIST
           
.LOOPW      MOVE.W  (A2)+,(WALLX)           ; LOAD WALL X
            MOVE.W  (A3)+,(WALLY)           ; LOAD WALL Y        
           
            ; WALL BOTTOM COLLISION
            MOVE.W  (WALLY),D0
            ADD.W   #WALLHEIGH/2+BALRAD,D0
            MOVE.W  #0,D1                   ; BOTTOM BOUNCE CODE
            CMP.W   2(A0),D0                ; BALL HIGHER THAN BOTTOM OF WALL?
            BGE     .CHECKTOP               ; YES : CHECK X COORDINATES
            BRA     .CHKWALL                ; NO  : CHECK IF ANY WALLS LEFT
            
.CHECKTOP      
            ; WALL TOP COLLISION
            MOVE.W  (WALLY),D0              
            SUB.W   #WALLHEIGH/2+BALRAD,D0
            CMP.W   2(A0),D0                ; BALL LOWER THAN TOP OF WALL?
            BGE     .TOPCOL                 ; YES : PUT TOP CODE
.CHECKX 
            ; WALL X LEFT BOUNDARY
            MOVE.W  (WALLX),D0              
            SUB.W   #WALLWIDTH/2+BALRAD,D0
            CMP.W   (A0),D0                 ; BALL HIGHER THAN LEFT OF WALL?
            BGE     .CHKWALL                ; NO : CHECK IF ANY WALLS LEFT
            ; WALL X RIGHT BOUNDARY
            MOVE.W  (WALLX),D0
            ADD.W   #WALLWIDTH/2+BALRAD,D0
            CMP.W   (A0),D0                 ; BALL LOWER THAN RIGHT OF WALL?
            BLE     .CHKWALL                ; NO : CHECK IF ANY WALLS LEFT 
            BRA     .BOUNCEW                ; YES : BOUNCE OF WALL

.TOPCOL     MOVE.W  #1,D1                   ; TOP BOUNCE CODE
            BRA     .CHECKX
            
.BOUNCEW    CMP.W   #0,D1
            BEQ     .BOUNCEDOWN
            CMP.W   #1,D1
            BEQ     .BOUNCEUP

.BOUNCEDOWN MOVE.W  #BALSPEED,6(A0)         ; BOUNCE DOWNWARDS 
            MOVE.B  #2,D1                   ; LOAD WALL SOUND
            MOVE.B  #PLAYSOUND,D0
            TRAP    #15                     ; PLAY SOUND
            BRA     .END                    
            
.BOUNCEUP   MOVE.W  #-BALSPEED,6(A0)        ; BOUNCE UPWARDS
            MOVE.B  #2,D1                   ; LOAD WALL SOUND
            MOVE.B  #PLAYSOUND,D0           
            TRAP    #15                     ; PLAY SOUND
            BRA     .END 
            
.CHKWALL    DBRA    D2,.LOOPW               ; IF WALLS LEFT, REPEAT WALL CHECK
            MOVE.W  #0,(WALLX)              ; RESET WALL X
            MOVE.W  #0,(WALLY)              ; RESET WALL Y
            BRA     .CHKKILL            
           
            ; WALL COLLISIONS CHECKED

            
.CHKKILL    CMP.W   #SCRHEIGH-1-BALRAD,2(A0) ; CHECK BOTTOM BOUNDARY
            BGT     .BOUNCEB                ; IF COLLISION -> BOUNCE

.END        SUB.W   #2,A2                   
            SUB.W   #2,A3
            MOVE.W  #0,(A2)                 ; ERASE WALL X FROM LIST
            MOVE.W  #0,(A3)                 ; ERASE WALL Y FROM LIST
            MOVEM.W  (A7)+,D0-D2
            RTS
            
.BOUNCEL    MOVE.W  #BALRAD,(A0)            ; ADJUST X
            MOVE.W  #BALSPEED,4(A0)         ; BOUNCE
            BRA     .CHKV   

.BOUNCER    MOVE.W  #SCRWIDTH-1-BALRAD,(A0) ; ADJUST X
            MOVE.   #-BALSPEED,4(A0)        ; BOUNCE
            BRA     .CHKV

.BOUNCET    MOVE.W  #SCRHEIGH/2-200-BALRAD,2(A0) ; ADJUST Y
            MOVE.W  #BALSPEED,6(A0)         ; BOUNCE
            BRA     .END

.BOUNCEB   
            MOVE.B  #3,D1                   ; LOAD CRASH SOUND
            MOVE.B  #PLAYSOUND,D0
            TRAP    #15                     ; PLAY SOUND
            JSR     LIFEUPD
            JSR     AGLKILL
            BRA     .END
            
; -----------------------------------------------------------------------------
BALPLOT
; PLOT A BALL
; INPUT    - NONE
; OUTPUT   - NONE 
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D4,-(A7)             ; STACK REGISTERS
            MOVE.B  #80,D0                  ; SET PEN COLOR TASK
            MOVE.L  #BALPCOL,D1             ; PEN COLOR
            TRAP    #15                     ; SET PEN COLOR
            ADDQ.B  #1,D0                   ; SET FILL COLOR TASK
            MOVE.L  #BALFCOL,D1             ; FILL COLOR
            TRAP    #15                     ; SET FILL COLOR
            
            MOVE.W  (A0),D1                 ; D1:=XCENTER
            MOVE.W  2(A0),D2                ; D2:=YCENTER
            MOVE.W  D1,D3                   ; D3:=XCENTER
            MOVE.W  D2,D4                   ; D4:=YCENTER
            
            SUB.W   #BALRAD,D1              ; D1:=XLEFT
            SUB.W   #BALRAD,D2              ; D2:=YTOP
            ADD.W   #BALRAD,D3              ; D3:=XRIGTH
            ADD.W   #BALRAD,D4              ; D4:=YBOTTOM
            MOVE.B  #88,D0                  ; DRAW ELLIPSE/CIRCLE TASK
            TRAP    #15                     ; DO IT
            MOVEM.L (A7)+,D0-D4
            RTS
            





*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~0~
*~Tab size~4~
