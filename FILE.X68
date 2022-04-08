; =============================================================================
; TITLE    : FILE MANAGEMENT
; AUTHOR   : MIQUEL ROBLES
; HISTORY  : 16-12-2020 - CREATION
;            17-01-2021 - LAST MODIFICATION  
; =============================================================================

; -----------------------------------------------------------------------------
READFILE
; READS A FILE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.W D0-D2/A0-A1,-(A7)
            
            ; CLOSE ALL FILES JUST IN CASE (RECOMMENDED BY EASY68K)
            MOVE.B  #50,D0
            TRAP    #15

            ; OPEN FILE
            LEA     .FILENAME,A1
            MOVE.B  #51,D0
            TRAP    #15

            ; READ THE FILE
            LEA     FILEDATA,A1
            MOVE.L  #READSIZE,D2
.READLOOP   MOVE.B  #53,D0
            TRAP    #15                     ; READ "READSIZE" BYTES
            ADD.L   #READSIZE,A1            ; INCREASE POINTER FOR FURTHER READS
            ADD.W   D2,(SIZE)
            TST.W   D0                      ; IS IT EOF?
            BEQ     .READLOOP               ; NO: READ MORE

            ; CLOSE THE FILE
            MOVE.B  #56,D0
            TRAP    #15
            
            MOVEM.W (A7)+,D0-D2/A0-A1
            RTS

.FILENAME   DC.B    'PUNTUACIO.TXT',0
            DS.W    0
            
; -----------------------------------------------------------------------------
WRITEFILE
; WRITES A FILE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------           
            MOVEM.W D0-D2/A0-A1,-(A7)
            
            ; OPEN FILE
            LEA     .FILENAME,A1
            MOVE.B  #51,D0
            TRAP    #15
            
            ; POSITION FILE
            MOVE.W  (SIZE),D2
            MOVE.B  #55,D0
            TRAP    #15
            
            ; WRITE FILE
            LEA     POINTS,A1
            MOVE.L  #2,D2
            MOVE.B  #54,D0
            TRAP    #15
            
            ; CLOSE THE FILE
            MOVE.B  #56,D0
            TRAP    #15
            
            MOVEM.W (A7)+,D0-D2/A0-A1
            RTS

.FILENAME   DC.B    'PUNTUACIO.TXT',0
            DS.W    0 


*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~0~
*~Tab size~4~
