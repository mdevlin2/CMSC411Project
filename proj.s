

.text
LDR R10, =w1
MOV R0, #2949120
STR R0, [R10],#4
MOV R0, #1740967
STR R0, [R10],#4
MOV R0, #919789
STR R0, [R10],#4
MOV R0, #466945
STR R0, [R10],#4
MOV R0, #234379
STR R0, [R10],#4
MOV R0, #117304
STR R0, [R10],#4
MOV R0, #58666
STR R0, [R10],#4
MOV R0, #29335
STR R0, [R10],#4
MOV R0, #14668
STR R0, [R10],#4
MOV R0, #7334
STR R0, [R10],#4
MOV R0, #3667
STR R0, [R10],#4
MOV R0, #1833
STR R0, [R10],#4
MOV R0, #917
STR R0, [R10],#4
MOV R0, #458
STR R0, [R10],#4
    
MOV R0, #14             @ Loop limit
MOV R1, #0              @ Loop counter
MOV R2, #1              @ x
MOV R3, #0              @ y
MOV R4, #35             @ z
MOV R5, #16             @ Shift constant

LSL R2, R2, R5
LSL R3, R3, R5
LSL R4, R4, R5

loop:
    MOV R7, R2
    MOV R11, R4
    LSR R12, R2, R1
    SUB R2, R2, R12
    LSR R13, R7, R1
    ADD R3, R3, R13
    SUB R4, R4, [R10], #4
    CMP R11, 0
    BLE negative
    ADD R1, R1, 1
    CMP R1, R0
    BLE Loop

negative:
    LSR R8, R3, R1
    ADD R2, R2, R8
    LSR R9, R7, R1
    SUB R3, R3, R9 
    SUB R4, R4, [R10], #4

.data 
w1=.word
