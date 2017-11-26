.text
MOV r0, #14             @ Loop limit
MOV r1, #0              @ Loop counter
MOV r2, #1              @ x
MOV r3, #0              @ y
MOV r4, #35             @ z
MOV r5, #16             @ Shift constant
LDR r10, =A1

MOV r2, r2, LSL r5
MOV r3, r3, LSL r5
MOV r4, r4, LSL r5
B loop

negative:   
    MOV r8, r3, LSR r1
    ADD r2, r2, r8
    MOV r9, r7, LSR r1
    SUB r3, r3, r9 
    LDR r14, [r10], #4
    SUB r4, r4, r14

loop:   
    MOV r7, r2
    MOV r11, r4
    MOV r12, r2, LSR r1
    SUB r2, r2, r12
    MOV r13, r7, LSR r1
    ADD r3, r3, r13
    LDR r15, [r10], #4
    SUB r4, r4, r15
    CMP r11, #0
    BLE negative
    ADD r1, r1, #1
    CMP r1, r0
    BLE loop

.data 
A1: .word 2949120
A2: .word 1740967
A3: .word 919789
A4: .word 466945
A5: .word 234379
A6: .word 117304
A7: .word 58666
A8: .word 29335
A9: .word 14668
A10: .word 7334
A11: .word 3667
A12: .word 1833
A13: .word 917
A14: .word 458

