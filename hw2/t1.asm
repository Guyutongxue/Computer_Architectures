DATA SEGMENT
    UP_A     DB 'Alpha$'
    UP_B     DB 'Bravo$'
    UP_C     DB 'China$'
    UP_D     DB 'Delta$'
    UP_E     DB 'Echo$'
    UP_F     DB 'Foxtrot$'
    UP_G     DB 'Golf$'
    UP_H     DB 'Hotel$'
    UP_I     DB 'India$'
    UP_J     DB 'Juliet$'
    UP_K     DB 'Kilo$'
    UP_L     DB 'Lima$'
    UP_M     DB 'Mary$'
    UP_N     DB 'November$'
    UP_O     DB 'Oscar$'
    UP_P     DB 'Paper$'
    UP_Q     DB 'Quebec$'
    UP_R     DB 'Research$'
    UP_S     DB 'Sierra$'
    UP_T     DB 'Tango$'
    UP_U     DB 'Uniform$'
    UP_V     DB 'Victor$'
    UP_W     DB 'Whisky$'
    UP_X     DB 'X-ray$'
    UP_Y     DB 'Yankee$'
    UP_Z     DB 'Zulu$'
    UPS      DW UP_A, UP_B, UP_C, UP_D, UP_E, UP_F, UP_G, UP_H, UP_I, UP_J, UP_K, UP_L, UP_M, UP_N, UP_O, UP_P, UP_Q, UP_R, UP_S, UP_T, UP_U, UP_V, UP_W, UP_X, UP_Y, UP_Z

    LO_A     DB 'alpha$'
    LO_B     DB 'bravo$'
    LO_C     DB 'china$'
    LO_D     DB 'delta$'
    LO_E     DB 'echo$'
    LO_F     DB 'foxtrot$'
    LO_G     DB 'golf$'
    LO_H     DB 'hotel$'
    LO_I     DB 'india$'
    LO_J     DB 'juliet$'
    LO_K     DB 'kilo$'
    LO_L     DB 'lima$'
    LO_M     DB 'mary$'
    LO_N     DB 'november$'
    LO_O     DB 'oscar$'
    LO_P     DB 'paper$'
    LO_Q     DB 'quebec$'
    LO_R     DB 'research$'
    LO_S     DB 'sierra$'
    LO_T     DB 'tango$'
    LO_U     DB 'uniform$'
    LO_V     DB 'victor$'
    LO_W     DB 'whisky$'
    LO_X     DB 'x-ray$'
    LO_Y     DB 'yankee$'
    LO_Z     DB 'zulu$'
    LOWS     DW LO_A, LO_B, LO_C, LO_D, LO_E, LO_F, LO_G, LO_H, LO_I, LO_J, LO_K, LO_L, LO_M, LO_N, LO_O, LO_P, LO_Q, LO_R, LO_S, LO_T, LO_U, LO_V, LO_W, LO_X, LO_Y, LO_Z

    DIG0     DB 'Zero$'
    DIG1     DB 'First$'
    DIG2     DB 'Second$'
    DIG3     DB 'Third$'
    DIG4     DB 'Fourth$'
    DIG5     DB 'Fifth$'
    DIG6     DB 'Sixth$'
    DIG7     DB 'Seventh$'
    DIG8     DB 'Eighth$'
    DIG9     DB 'Ninth$'
    DIGS     DW DIG0, DIG1, DIG2, DIG3, DIG4, DIG5, DIG6, DIG7, DIG8, DIG9

    STU_INFO DB 0AH, 0DH, 'ID: 1900012983', 0AH, 0DH, 'NAME: Gu Yu', 0AH, 0DH, '$'
DATA ENDS

STACK SEGMENT STACK
    STA   DB  50 DUP(?)
    TOP   EQU LENGTH STA
STACK ENDS

CODE SEGMENT
                ASSUME CS:CODE, DS:DATA, SS:STACK
    BEGIN:      MOV    AX, DATA
                MOV    DS, AX
                MOV    AX, STACK
                MOV    SS, AX
                MOV    AX, TOP
                MOV    SP, AX

    INPUT:      MOV    CX, 2                         ; loop forever
                MOV    AH, 07H                       ; get an input
                INT    21H
                MOV    BL, AL                        ; BX = AX

                CMP    AL, '0'
                JL     PRINT_UNK
                CMP    AL, ':'
                JL     PRINT_DIGIT                   ; character is a number

                CMP    AL, 'A'
                JL     PRINT_UNK
                CMP    AL, '['
                JL     PRINT_UPPER                   ; character is uppercase
   
                CMP    AL, 'a'
                JL     PRINT_UNK
                CMP    AL, '{'
                JL     PRINT_LOWER                   ; character is a lowercase

                JMP    SHORT PRINT_UNK

    PRINT_DIGIT:SUB    BL, '0'                       ; - '0' = offset
                SHL    BL, 1
                MOV    SI, BX
                MOV    DX, DIGS[SI]
                JMP    SHORT PRINT

    PRINT_UPPER:SUB    BL, 'A'                       ; - 'A' = offset
                SHL    BL, 1
                MOV    SI, BX
                MOV    DX, UPS[SI]
                JMP    SHORT PRINT

    PRINT_LOWER:SUB    BL, 'a'                       ; - 'a' = offset
                SHL    BL, 1
                MOV    SI, BX
                MOV    DX, LOWS[SI]
                JMP    SHORT PRINT

    PRINT:      MOV    AH, 09H
                INT    21H
                JMP    SHORT TEST_ESC

    PRINT_UNK:  CMP    AL, 1BH
                JE     EXIT
                MOV    DL, '?'                       ; unknown input
                MOV    AH, 02H
                INT    21H

    TEST_ESC:   CMP    AL, 1BH                       ; if AL == \e
                LOOPNZ INPUT
    EXIT:       MOV    DX, OFFSET STU_INFO           ; print student info
                MOV    AH, 09H
                INT    21H
                MOV    AH, 4CH                       ; quit
                INT    21H
CODE ENDS
	END BEGIN
