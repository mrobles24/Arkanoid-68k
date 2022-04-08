; =============================================================================
; TITLE    : GAME STATE MANAGEMENT
; AUTHOR   : MIQUEL ROBLES
; HISTORY  : 20-12-2020 - CREATION
;            16-01-2021 - LAST MODIFICATION
; =============================================================================

; -----------------------------------------------------------------------------
STAINIT
; INITALIZES THE STATE MANAGER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.W  #-1,(STACUR)            ; INVALID STATE, JUST TO FORCE INIT
            MOVE.W  #0,(STANEXT)            ; INITIAL STATE
            RTS

; -----------------------------------------------------------------------------
STAUPD
; PERFORMS STATE UPDATE AND INIT IF NECESSARY
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            CLR.L   D0
            MOVE.W  (STANEXT),D0
            CMP.W   (STACUR),D0
            BEQ     .DOUPD
            MOVE.W  D0,(STACUR)             ; IF STATE CHANGED, DO INIT
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .INITBL(A0),A0
            JSR     (A0)
.DOUPD      CLR.L   D0                      ; IN ANY CASE, DO UPDATE
            MOVE.W  (STACUR),D0
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .UPDTBL(A0),A0
            JSR     (A0)
            MOVEM.L (A7)+,D0/A0
            RTS
.INITBL     DC.L    STAINTRI,STAPLAYI,STAGOVRI,STAVICI,STAFINI
.UPDTBL     DC.L    STAINTRU,STAPLAYU,STAGOVRU,STAVICU,STAFINU

; -----------------------------------------------------------------------------
STAPLOT
; PERFORMS STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            CLR.L   D0
            MOVE.W  (STACUR),D0
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .PLTTBL(A0),A0
            JSR     (A0)
            MOVEM.L (A7)+,D0/A0
            RTS
.PLTTBL     DC.L    STAINTRP,STAPLAYP,STAGOVRP,STAVICP,STAFINP

; -----------------------------------------------------------------------------
STAEMPTY
; EMPTY SUBROUTINE FOR CASES WITH NOTHING TO DO
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - JUST A PLACEHOLDER. NOTHING TO DO.
; -----------------------------------------------------------------------------
            RTS

; -----------------------------------------------------------------------------
STAINTRI    
; GAME INTRO INITIALIZATION
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.W D0-D1/A0,-(A7)
            
            MOVE.B  #6,D1                   
            MOVE.L  #3,D2
            MOVE.B  #CTRLSOUND,D0           ; STOP ALL SOUNDS
            TRAP    #15
            
            LEA     .PADSND,A1              ; LOAD PAD SOUND INTO MEMORY
            MOVE.B  #1,D1
            MOVE.B  #LOADSOUND,D0
            TRAP    #15
            
            LEA     .WALSND,A1              ; LOAD WALL SOUND INTO MEMORY
            MOVE.B  #2,D1
            MOVE.B  #LOADSOUND,D0
            TRAP    #15
            
            LEA     .CRSHSND,A1             ; LOAD CRASH SOUND INTO MEMORY
            MOVE.B  #3,D1
            MOVE.B  #LOADSOUND,D0
            TRAP    #15
            
            LEA     .GVRSND,A1              ; LOAD GAME OVER SOUND INTO MEMORY
            MOVE.B  #4,D1
            MOVE.B  #LOADSOUND,D0
            TRAP    #15
            
            LEA     .VICSND,A1              ; LOAD VICTORY SOUND INTO MEMORY
            MOVE.B  #5,D1
            MOVE.B  #LOADSOUND,D0
            TRAP    #15
            
            LEA     .INTRSND,A1             ; LOAD VICTORY SOUND INTO MEMORY
            MOVE.B  #6,D1
            MOVE.B  #LOADSOUND,D0
            TRAP    #15            
            
            MOVE.B  #6,D1                   ; LOAD INTRO SOUND FROM MEMORY
            MOVE.L  #1,D2
            MOVE.B  #CTRLSOUND,D0           
            TRAP    #15                     ; PLAY SOUND ON LOOP
            
            MOVE.W  #WALLID,D0              
            MOVE.W  #35,D1
.LOOP       JSR     DMMFRSTO                ; GET FIRST AGENT WITH ID=WALLID
            JSR     AGLKILL                 ; KILL THE WALL
            JSR     DMMNEXTO                ; GET NEXT BALL
            DBRA    D1,.LOOP
            
            MOVE.W #BALID,D0
            JSR     DMMFRSTO                ; GET FIRST AGENT WITH ID=BALID
.LOOP2      CMP.L   #0,A0                   ; DOES IT EXIST?
            BEQ     .EXIT                   ; NO: EXIT
            JSR     AGLKILL                 ; YES : KILL THE BALL
            JSR     DMMNEXTO                ; GET NEXT BALL
            BRA     .LOOP2                  ; LOOP

.EXIT       MOVEM.W (A7)+,D0-D1/A0
            RTS
            
.PADSND     DC.B    'PAD.wav',0
.WALSND     DC.B    'WALL.wav',0   
.CRSHSND    DC.B    'DEAD.wav',0     
.GVRSND     DC.B    'GOVER.wav',0
.VICSND     DC.B    'VICTORY.wav',0
.INTRSND    DC.B    'INTRO.wav',0
            DS.W    0                        

; -----------------------------------------------------------------------------
STAINTRU
; GAME INTRO UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            BTST.B  #KBDBITF1,(KBDEDGE)
            BEQ     .END
            MOVE.W  #STAGAME,(STANEXT)
.END        RTS

; -----------------------------------------------------------------------------
STAINTRP
; GAME INTRO PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D2/A1,-(A7)          ; STACK REGISTERS
            MOVE.L  #$00FFFF99,D1           ; TEXT COLOR
            MOVE.L  #$01240001,D2           ; TEXT PROPERTIES
            MOVE.B  #21,D0                  ; PROPERTIES TASK
            TRAP    #15                     ; DO IT                       
            MOVE.W  #((20-15)/2)<<8|2,D1    ; FIRST TEXT COORDINATES
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR0,A1                ; STRING POINTER
            MOVE.B  #13,D0                  ; PRINT STRING TASK
            TRAP    #15                     ; DO IT
          
            MOVE.L  #$00FFCF00,D1           ; TEXT COLOR
            MOVE.L  #$01160001,D2           ; TEXT PROPERTIES
            MOVE.B  #21,D0                  ; PROPERTIES TASK
            TRAP    #15                     ; DO IT   
            MOVE.W  #((37-9)/2)<<8|8,D1     ; FIRST TEXT COORDINATES
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR1,A1                ; STRING POINTER
            MOVE.B  #13,D0                  ; PRINT STRING TASK
            TRAP    #15                     ; DO IT
            
            BTST.B  #3,(SCRCYCCT)
            BEQ     .END
            
            MOVE.L  #$00FFFFFF,D1           ; TEXT COLOR
            MOVE.L  #$040C0001,D2           ; TEXT PROPERTIES
            MOVE.B  #21,D0                  ; PROPERTIES TASK
            TRAP    #15                     ; DO IT
            MOVE.W  #((58-14)/2)<<8|25,D1   ; FIRST TEXT COORDINATES
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR2,A1                ; STRING POINTER
            MOVE.B  #13,D0                  ; PRINT STRING TASK
            TRAP    #15                     ; DO IT
            
.END        MOVEM.L (A7)+,D0-D2/A1
            RTS
.STR0       DC.B    'A R K A N O I D',0
.STR1       DC.B    '2 0 . 2 1',0
.STR2       DC.B    'PUSH SPACE KEY',0
            DS.W    0

; -----------------------------------------------------------------------------
STAPLAYI
; GAME INITIALIZATION
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D7/A1-A3,-(A7)
            
            JSR     RNDINIT                 ; RANDOM INIT
            JSR     PADINIT                 ; PAD INIT
            JSR     LIFEINIT                ; LIFE INIT
            JSR     POINTINIT               ; POINT INIT
            
            ; BALL INIT
            MOVE.W  #BALID,D0               ; AGENT ID
            MOVE.W  #BALNUM-1,D1            ; AGENT INIT PARAMETER 1
            LEA     BALINIT,A1              ; POINTER TO AGENT INIT FUNCTION
            LEA     BALUPD,A2               ; POINTER TO AGENT UPDATE FUNCTION
            LEA     BALPLOT,A3              ; POINTER TO AGENT PLOT FUNCTION
.LOOPA      JSR     AGLADD                  ; ADD A BALL
            DBRA.W  D1,.LOOPA               ; FOR BALL NUM, ADD BALL
            
            ; WALL INIT
            MOVE.L  #$00FF0000,(WALLFCOL)   ; SET FIRST WALL LINE FILL COLOR
            MOVE.W  #SCRHEIGH/2-180,(WALLY) ; SET FIRST WALL LINE Y
            MOVE.W  #40,(WALLX)             ; SET FIRST WALL X IN A LINE
            MOVE.W  #36,(WALLTOTAL)
            MOVE.W  #WALLLNNUM-1,D5         
            MOVE.W  #WALLNUM-1,D4                        
            MOVE.W  #WALLID,D0              ; AGENT ID
            MOVE.W  (WALLX),D1              ; AGENT INIT PARAMETER 1
            MOVE.W  (WALLY),D2              ; AGENT INIT PARAMETER 2
            LEA     WALLINIT,A1             ; POINTER TO AGENT INIT FUNCTION
            LEA     WALLUPD,A2              ; POINTER TO AGENT UPDATE FUNCTION
            LEA     WALLPLOT,A3             ; POINTER TO AGENT PLOT FUNCTION
            BRA     .ADDFRTWALL                       
.LOOPBX     ADD.W   #50,(WALLX)             ; ADD SPACING BETWEEN WALLS
            MOVE.W  (WALLX),D1              ; SAVE X COORDINATE OF WALL
            MOVE.W  (WALLY),D2              ; SAVE Y COORDINATE OF WALL
.ADDFRTWALL JSR     AGLADD                  ; ADD A WALL
            DBRA.W  D4,.LOOPBX              ; LINE EVERY 12 WALLS IN X
            MOVE.W  #40,(WALLX)             ; INITIALIZE WALL X IN A LINE
            MOVE.W  #WALLNUM-1,D4           ; INITIALIZE WALL NUM IN A LINE
            
            ADD.W   #30,(WALLY)             ; SPACING BETWEEN WALL LINES
            ADD.L   #$00007700,(WALLFCOL)   ; SET NEW WALL LINE FILL COLOR
            DBRA.W  D5,.ADDFRTWALL          ; REPEAT FOR NUMBER OF LINES  
            MOVE.W  #40,(WALLX)             
            MOVE.W  #SCRHEIGH/2-180,(WALLY) 
            
            MOVE.B  #6,D1                   
            MOVE.L  #3,D2
            MOVE.B  #CTRLSOUND,D0           ; STOP ALL SOUNDS
            TRAP    #15

            MOVEM.L (A7)+,D0-D7/A1-A3
            RTS

; -----------------------------------------------------------------------------
STAPLAYU
; GAME UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D7/A0-A2,-(A7)
            JSR     PADUPD
            JSR     POINTUPD
            
            ; LOAD WALL LIST
            LEA     XLIST,A1
            LEA     YLIST,A2
            MOVE.W  #WALLID,D0              ; ID TO SEARCH
            JSR     DMMFRSTO                ; GET FIRST AGENT WITH ID=WALLID
.LOOPCOUNT0 CMP.L   #0,A0                   ; DOES IT EXIST?
            BEQ     .AGUP                   ; NO: AGENT UPDATE
            MOVE.W  8(A0),(A1)+             ; ADD AGENT X COORDINATE TO X LIST
            MOVE.W  10(A0),(A2)+            ; ADD AGENT Y COORDINATE TO Y LIST
            JSR     DMMNEXTO                ; GET NEXT WALL
            BRA     .LOOPCOUNT0             ; LOOP
            
            ; UPDATE AGENT LIST
.AGUP       JSR     AGLUPD                  ; UPDATE AGENT LIST     
            
            ; UPDATE WALL KILL         
            LEA     WALLX,A1
            LEA     WALLY,A2
            MOVE.W  #WALLID,D0              ; ID TO SEARCH
            JSR     DMMFRSTO                ; GET FIRST AGENT WITH ID=WALLID
.LOOPCOUNT1 CMP.L   #0,A0                   ; DOES IT EXIST?
            BEQ     .VICTORY                ; NO: VICTORY?
            MOVE.W  (A1),D2
            MOVE.W  (A2),D3
            CMP.W    8(A0),D2               ; WALLX = AGENT X?
            BNE     .NOTEQUAL               ; NO : NEXT AGENT
            CMP.W    10(A0),D3              ; WALLY = AGENT Y?
            BNE     .NOTEQUAL               ; NO : NEXT AGENT
            JSR     AGLKILL                 ; YES : AGENT KILL
            MOVE.W  (WALLTOTAL),D4
            SUB.W   #1,D4                   ; WALLTOTAL = WALLTOTAL - 1
            MOVE.W  D4,(WALLTOTAL)
            BRA     .VICTORY                ; VICTORY?

.NOTEQUAL   JSR     DMMNEXTO                ; GET NEXT WALL
            BRA     .LOOPCOUNT1  
            
.VICTORY    ; VICTORY?
            MOVE.W  (WALLTOTAL),D5
            CMP.W   #0,D5                   ; IS THERE ANY WALLS?
            BNE     .LIFEUP                 ; YES : CHECK LIVES
            MOVE.W  #STAVIC,(STANEXT)       ; NO : VICTORY!
            BRA     .END
      
            ; UPDATE LIVES
.LIFEUP     CLR.W   D1                      ; INIT BALL COUNTER
            MOVE.W  #BALID,D0               ; ID TO SEARCH
            JSR     DMMFRSTO                ; GET FIRST AGENT WITH ID=BALID
.LOOPCOUNT2 CMP.L   #0,A0                   ; DOES IT EXIST?
            BEQ     .EXIT                   ; NO: EXIT
            ADDQ.W   #1,D1                  ; YES: INC COUNTER
            JSR     DMMNEXTO                ; GET NEXT BALL
            BRA     .LOOPCOUNT2             ; LOOP
            
.EXIT       TST.W   D1                      ; ANY BALLS?
            BNE     .TEST                   ; YES: TEST LIVES
            CLR.W   D7                      ; NO: ADD BALL IF ANY LIFE LEFT
            MOVE.B  (LIVES),D7              
            CMP     #0,D7                   ; IS THERE LESS THAN 3 LIVES? 
            BGT     .ADDBALL                ; YES: ADD A BALL
            BRA     .OVER                   ; NO: GAME OVER!
            BRA     .END
            
.ADDBALL    MOVE.W  #BALID,D0               ; AGENT ID
            LEA     BALINIT,A1              ; POINTER TO AGENT INIT FUNCTION
            LEA     BALUPD,A2               ; POINTER TO AGENT UPDATE FUNCTION
            LEA     BALPLOT,A3              ; POINTER TO AGENT PLOT FUNCTION
            JSR     AGLADD                  ; ADD AGENT (BALL)
            
.TEST       MOVE.B  (LIVES),D7
            CMP     #0,D7                   ; IS THERE ANY LIVES? 
            BNE     .END                    ; YES: END UPDATE
            
.OVER       MOVE.W  #STAGOVER,(STANEXT)     ; GAME OVER     
.END        MOVEM.L (A7)+,D0-D7/A0-A2
            RTS
            
; -----------------------------------------------------------------------------
STAPLAYP
; GAME PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            JSR     AGLPLOT  
            JSR     BORDPLOT           
            JSR     POINTPLOT
            JSR     LIFEPLOT 
            JSR     PADPLOT   
            RTS                                
; -----------------------------------------------------------------------------
STAGOVRI   
; GAME OVER INITIALIZATION
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.B  #4,D1                   ; LOAD GAME OVER SOUND
            MOVE.B  #PLAYSOUND,D0           
            TRAP    #15                     ; PLAY SOUND
            RTS
; -----------------------------------------------------------------------------
STAGOVRU
; GAME OVER UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            BTST.B  #KBDBITF1,(KBDEDGE)
            BNE     .START

            MOVE.W  (SYSMOUDW),D1
            CMP.W   #0,D1
            BEQ     .END
            MOVE.W  (SYSMOUPX),D2
            MOVE.W  (SYSMOUPY),D3
            
            CMP.W   #$0169,D3
            BLT     .END
            CMP.W   #$0187,D3
            BGT     .END
            
            CMP.W   #$00D2,D2
            BLT     .END
            CMP.W   #$01C0,D2
            BGT     .END
            
            MOVE.W  #STAFIN,(STANEXT)
            BRA     .END
            
.START      MOVE.W  #STAINTRO,(STANEXT)
                        
.END        RTS

; -----------------------------------------------------------------------------
STAGOVRP
; GAME PLOT PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D1/A1,-(A7)          ; STACK REGISTERS
            
            MOVE.L  #$000000FF,D1           ; TEXT COLOR
            MOVE.L  #$012D0001,D2           ; TEXT PROPERTIES
            MOVE.B  #21,D0                  ; PROPERTIES TASK
            TRAP    #15                     ; DO IT           
            MOVE.W  #((16-9)/2)<<8|2,D1     ; FIRST TEXT COORDINATES
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR0,A1                ; STRING POINTER
            MOVE.B  #13,D0                  ; PRINT STRING TASK
            TRAP    #15                     ; DO IT
            
            MOVE.L  #$00FFCF00,D1           ; TEXT COLOR
            MOVE.L  #$01160001,D2           ; TEXT PROPERTIES
            MOVE.B  #21,D0                  ; PROPERTIES TASK
            TRAP    #15                     ; DO IT   
            MOVE.W  #((38-10)/2)<<8|8,D1     ; FIRST TEXT COORDINATES
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR1,A1                ; STRING POINTER
            MOVE.B  #13,D0                  ; PRINT STRING TASK
            TRAP    #15                     ; DO IT
           
            BTST.B  #3,(SCRCYCCT)
            BEQ     .END
                       
            MOVE.L  #$00FFFFFF,D1           ; TEXT COLOR
            MOVE.L  #$040C0001,D2           ; TEXT PROPERTIES
            MOVE.B  #21,D0                  ; PROPERTIES TASK
            TRAP    #15                     ; DO IT            
            MOVE.W  #((60-25)/2)<<8|20,D1   ; FIRST TEXT COORDINATES
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR2,A1                ; STRING POINTER
            MOVE.B  #13,D0                  ; PRINT STRING TASK
            TRAP    #15                     ; DO IT
            
            MOVE.L  #$00FFFFFF,D1           ; TEXT COLOR
            MOVE.L  #$040C0001,D2           ; TEXT PROPERTIES
            MOVE.B  #21,D0                  ; PROPERTIES TASK
            TRAP    #15                     ; DO IT            
            MOVE.W  #((60-20)/2)<<8|23,D1   ; FIRST TEXT COORDINATES
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR3,A1                ; STRING POINTER
            MOVE.B  #13,D0                  ; PRINT STRING TASK
            TRAP    #15                     ; DO IT
            
            MOVE.B  #80,D0                  ; SET PEN COLOR TASK
            MOVE.L  #$00FFFFFF,D1           ; PEN COLOR
            TRAP    #15                     ; SET PEN COLOR
            
            MOVE.W   #$00D2,D1               ; D1:=XLEFT
            MOVE.W   #$0169,D2               ; D2:=YTOP
            MOVE.W   #$01C0,D3               ; D3:=XRIGHT
            MOVE.W   #$0187,D4               ; D4:=YBOTTOM
            MOVE.B  #90,D0           
            TRAP    #15                     ; DRAW RECTANGLE


.END        MOVEM.L (A7)+,D0-D1/A1
            RTS
.STR0       DC.B    'GAME  OVER',0
.STR1       DC.B    'TRY AGAIN?',0
.STR2       DC.B    'PUSH SPACE KEY TO RESTART',0
.STR3       DC.B    'CLICK HERE TO FINISH',0
            DS.W    0



; -----------------------------------------------------------------------------
STAVICI    
; VICTORY INITIALIZATION
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.B  #5,D1                   ; LOAD VICTORY SOUND
            MOVE.B  #PLAYSOUND,D0
            TRAP    #15                     ; PLAY SOUND
            JSR     READFILE
            JSR     WRITEFILE
            
            RTS
; -----------------------------------------------------------------------------
STAVICU
; VICTORY UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            BTST.B  #KBDBITF1,(KBDEDGE)
            BNE     .START

            MOVE.W  (SYSMOUDW),D1
            CMP.W   #0,D1
            BEQ     .END
            MOVE.W  (SYSMOUPX),D2
            MOVE.W  (SYSMOUPY),D3
            
            CMP.W   #$0169,D3
            BLT     .END
            CMP.W   #$0187,D3
            BGT     .END
            
            CMP.W   #$00D2,D2
            BLT     .END
            CMP.W   #$01C0,D2
            BGT     .END
            
            MOVE.W  #STAFIN,(STANEXT)
            BRA     .END
            
.START      MOVE.W  #STAINTRO,(STANEXT)
                        
.END        RTS
; -----------------------------------------------------------------------------
STAVICP
; VICTORY PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D1/A1,-(A7)          ; STACK REGISTERS
            
            MOVE.L  #$00FFFFFF,D1           ; TEXT COLOR
            MOVE.L  #$012D0001,D2           ; TEXT PROPERTIES
            MOVE.B  #21,D0                  ; PROPERTIES TASK
            TRAP    #15                     ; DO IT           
            MOVE.W  #((16-8)/2)<<8|2,D1     ; FIRST TEXT COORDINATES
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR0,A1                ; STRING POINTER
            MOVE.B  #13,D0                  ; PRINT STRING TASK
            TRAP    #15                     ; DO IT
            
            MOVE.L  #$00FFCF00,D1           ; TEXT COLOR
            MOVE.L  #$01160001,D2           ; TEXT PROPERTIES
            MOVE.B  #21,D0                  ; PROPERTIES TASK
            TRAP    #15                     ; DO IT   
            MOVE.W  #((33-10)/2)<<8|8,D1    ; FIRST TEXT COORDINATES
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR1,A1                ; STRING POINTER
            MOVE.B  #13,D0                  ; PRINT STRING TASK
            TRAP    #15                     ; DO IT
            
            MOVE.L  #$00FFFF00,D1           ; POINTS COLOR
            MOVE.L  #$01160001,D2           ; POINTS PROPERTIES
            MOVE.B  #21,D0                  ; PROPERTIES TASK
            TRAP    #15                     ; DO IT   
            MOVE.W  #((52-3)/2)<<8|8,D1     ; POINTS COORDINATES
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE POINTS CURSOR
            CLR.L   D1                      ; CLEAR POINTS REGISTER
            MOVE.W  (POINTS),D1             ; MOVE POINTS TO REGISTER
            MOVE.B  #10,D2                  ; DISPLAY IN DECIMAL BASE
            MOVE.B  #15,D0                  ; PRINT UNSIGNED NMBR TASK
            TRAP    #15                     ; DO IT

            BTST.B  #3,(SCRCYCCT)
            BEQ     .END
            
            MOVE.L  #$00FFFFFF,D1           ; TEXT COLOR
            MOVE.L  #$040C0001,D2           ; TEXT PROPERTIES
            MOVE.B  #21,D0                  ; PROPERTIES TASK
            TRAP    #15                     ; DO IT            
            MOVE.W  #((60-25)/2)<<8|20,D1   ; FIRST TEXT COORDINATES
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR2,A1                ; STRING POINTER
            MOVE.B  #13,D0                  ; PRINT STRING TASK
            TRAP    #15                     ; DO IT
            
            MOVE.L  #$00FFFFFF,D1           ; TEXT COLOR
            MOVE.L  #$040C0001,D2           ; TEXT PROPERTIES
            MOVE.B  #21,D0                  ; PROPERTIES TASK
            TRAP    #15                     ; DO IT            
            MOVE.W  #((60-20)/2)<<8|23,D1   ; FIRST TEXT COORDINATES
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR3,A1                ; STRING POINTER
            MOVE.B  #13,D0                  ; PRINT STRING TASK
            TRAP    #15                     ; DO IT
            
            MOVE.B  #80,D0                  ; SET PEN COLOR TASK
            MOVE.L  #$00FFFFFF,D1           ; PEN COLOR
            TRAP    #15                     ; SET PEN COLOR
            
            MOVE.W   #$00D2,D1               ; D1:=XLEFT
            MOVE.W   #$0169,D2               ; D2:=YTOP
            MOVE.W   #$01C0,D3               ; D3:=XRIGHT
            MOVE.W   #$0187,D4               ; D4:=YBOTTOM
            MOVE.B  #90,D0           
            TRAP    #15                     ; DRAW RECTANGLE

        

.END        MOVEM.L (A7)+,D0-D1/A1
            RTS
.STR0       DC.B    'VICTORY!',0
.STR1       DC.B    'YOUR POINTS:',0
.STR2       DC.B    'PUSH SPACE KEY TO RESTART',0
.STR3       DC.B    'CLICK HERE TO FINISH',0
            DS.W    0
            DS.W    0


; -----------------------------------------------------------------------------
STAFINI    
; FINISH INITIALIZATION
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            RTS
; -----------------------------------------------------------------------------
STAFINU
; FINISH UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            RTS
; -----------------------------------------------------------------------------
STAFINP
; FINISH PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.W D0-D2/A0-A1,-(A7)
            MOVE.L  #$00FFFFFF,D1           ; TEXT COLOR
            MOVE.L  #$011B0001,D2           ; TEXT PROPERTIES
            MOVE.B  #21,D0                  ; PROPERTIES TASK
            TRAP    #15                     ; DO IT           
            MOVE.W  #((32-20)/2)<<8|4,D1     ; FIRST TEXT COORDINATES
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR0,A1                ; STRING POINTER
            MOVE.B  #13,D0                  ; PRINT STRING TASK
            TRAP    #15                     ; DO IT
            
            MOVE.L  #$00FFCF00,D1           ; TEXT COLOR
            MOVE.L  #$01160001,D2           ; TEXT PROPERTIES
            MOVE.B  #21,D0                  ; PROPERTIES TASK
            TRAP    #15                     ; DO IT   
            MOVE.W  #((38-10)/2)<<8|8,D1     ; FIRST TEXT COORDINATES
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR1,A1                ; STRING POINTER
            MOVE.B  #13,D0                  ; PRINT STRING TASK
            TRAP    #15                     ; DO IT
            

            
            MOVEM.W (A7)+,D0-D2/A0-A1
            RTS
            
.STR0       DC.B    'THANKS FOR PLAYING!!',0
.STR1       DC.B    'UIB - 2021',0
            DS.W    0

            








*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~0~
*~Tab size~4~
