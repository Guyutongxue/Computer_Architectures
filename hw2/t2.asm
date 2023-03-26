DATA SEGMENT
    BUF_CAP  DB 99
    BUF_LEN  DB 0
    BUF_DATA DB 99 DUP(0)
    STU_INFO DB 0AH, 0DH, 'ID: 1900012983', 0AH, 0DH, 'NAME: Gu Yu', 0AH, 0DH, '$'
    NEWLINE  DB 0AH, 0DH, '$'
    P_SUCC   DB 0AH, 0DH, 'Yes! Location: $'
    P_FAIL   DB 0AH, 0DH, 'No...', 0AH, 0DH, '$'
DATA ENDS

STACK SEGMENT STACK
    STA   DB  50 DUP(?)
    TOP   EQU LENGTH STA
STACK ENDS

CODE SEGMENT
              ASSUME CS:CODE, DS:DATA, SS:STACK

PRINT_LF PROC NEAR                                 ; print newline
              MOV    DX, OFFSET NEWLINE
              MOV    AH, 09H
              INT    21H
              RET
PRINT_LF ENDP

    BEGIN:    MOV    AX, DATA
              MOV    DS, AX
              MOV    ES, AX                        ; SCASB uses ES
              MOV    AX, STACK
              MOV    SS, AX
              MOV    AX, TOP
              MOV    SP, AX
             
              MOV    DX, OFFSET BUF_CAP            ; read haystack
              MOV    AH, 0AH
              INT    21H
              CALL   PRINT_LF
             
    INPUT_NDL:MOV    AH, 07H                       ; read needle
              INT    21H
              CMP    AL, 1BH                       ; if AL == \e
              JE     SHORT EXIT

              MOV    DL, AL                        ; putchar
              MOV    AH, 02H
              INT    21H

              MOV    DI, OFFSET BUF_DATA           ; DI = buffer
              MOV    BX, OFFSET BUF_LEN
              MOV    CL, [BX]                      ; CX = len(buffer)
              MOV    CH, 0
              CLD
              REPNE  SCASB
              JE     SUCC

    FAIL:     MOV    DX, OFFSET P_FAIL             ; print fail prompt
              MOV    AH, 09H
              INT    21H
              JMP    SHORT INPUT_NDL

    SUCC:     MOV    DX, OFFSET P_SUCC             ; print success prompt
              MOV    AH, 09H
              INT    21H
              MOV    AL, [BX]                      ; AX = len(buffer)
              MOV    AH, 0
              SUB    AX, CX                        ; AX -= CX
              MOV    DL, 10
              DIV    DL                            ; DL = AX / 10, DH = AX % 10
              MOV    DL, AL
              MOV    DH, AH
              ADD    DL, '0'                       ; DL += '0'; putchar
              MOV    AH, 02H
              INT    21H
              MOV    DL, DH                        ; DH += '0'; putchar
              ADD    DL, '0'
              MOV    AH, 02H
              INT    21H
              CALL   PRINT_LF
              JMP    SHORT INPUT_NDL

    EXIT:     MOV    DX, OFFSET STU_INFO           ; print student info
              MOV    AH, 09H
              INT    21H
              MOV    AH, 4CH                       ; quit
              INT    21H
CODE ENDS
            END BEGIN