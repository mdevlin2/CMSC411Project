.text
MOV r0, #14             @ Loop limit
MOV r1, #0              @ Loop counter
MOV r2, #1              @ x
MOV r3, #0              @ y
MOV r4, #35             @ z
MOV r5, #16             @ Shift constant
LDR r6, =A1

MOV r2, r2, LSL r5
MOV r3, r3, LSL r5
MOV r4, r4, LSL r5

B loop

@ Sign decision 

negative:   
    MOV r8, r3, LSR r1
    ADD r2, r2, r8
    MOV r8, r7, LSR r1
    SUB r3, r3, r8 
    LDR r8, [r6, #32]
    SUB r4, r4, r8

loop:   
    ADD r1, r1, #1
    MOV r7, r2
    MOV r8, r4
    MOV r9, r2, LSR r1
    SUB r2, r2, r9
    MOV r9, r7, LSR r1
    ADD r3, r3, r9
    LDR r8, [r6, #32]
    MOV r8, r8, LSL #1
    SUB r4, r4, r8
    CMP r4, #0
    BLE negative
    CMP r1, r0
    BLE loop

.data 
A1: .word 2949120, 1740967, 919789, 466945, 234379, 117304, 58666, 29335, 14668, 7334, 3667, 1833, 917, 458
FS: .word 65536

