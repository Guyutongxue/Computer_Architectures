DATA SEGMENT
    NUM     DW 0011101000000111B
    PRELUDE DB 'NAME: Gu Yu', 0AH, 0DH
            DB 'ID: 1900012983', 0AH, 0DH
            DB 'The result: ', '$'
DATA ENDS

STACK SEGMENT STACK
    STA   DB  50 DUP(?)
    TOP   EQU LENGTH STA
STACK ENDS

CODE SEGMENT
            ASSUME CS:CODE, DS:DATA, SS:STACK
    BEGIN:  MOV    AX, DATA
            MOV    DS, AX
            MOV    SS, AX
            MOV    AX, TOP
            MOV    SP, AX
            MOV    DX, OFFSET PRELUDE
            MOV    AH, 09H
            INT    21H
    ; MOV DX, OFFSET NOTES
    ; INT 21H
            MOV    BX, NUM
            MOV    CH, 4
    ROTATE: MOV    CL, 4
            ROL    BX, CL
            MOV    AL, BL
            AND    AL, 0FH
            ADD    AL, 30H
            CMP    AL, '9'
            JL     DISPLAY
            ADD    AL, 07H
    DISPLAY:MOV    DL, AL
            MOV    AH, 2
            INT    21H
            DEC    CH
            JNZ    ROTATE
            MOV    AX, 4C00H
            INT    21H
CODE ENDS
    END BEGIN
