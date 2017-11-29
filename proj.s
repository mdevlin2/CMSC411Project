cordic_ctab:
    .word 2097149
    .word 1048575
    .word 524287
    .word 262143
    .word 131071
    .word 65535
    .word 32767
    .word 16383
    .word 8191
    .word 4095
    .word 2047
    .word 1023
    .word 511
    .word 255
    .word 127
    .word 63
    .word 31
    .word 15
    .word 8
    .word 4
    .word 2
    .word 1
    .word 0

theta:
    .word 30

cordic_1k:
    .word 0x26DD3B6A

cordic_ntab:
    .word 23

MUL:
    .word 1073741824

PMUL:
    .word 0

.L3:
    .word cordic_ctab

.L4:
    .word 652032874

main:
    mov r0, #32
    mov r1, #1
    ldr r2, =cordic_1k
    ldr r2, [r2]
    mov r3, #0
    ldr r4, =theta
    ldr r4, [r4]
    mov r5, #1
    mov r7, #1
    b mul_loop

@ multiply theta by MUL
mul_loop:
    add r5, r5, #1
    ldr r6, =MUL
    ldr r6, [r6]
    add r4, r4, r6
    cmp r5, r7
    ble mul_loop
    b loop

loop:
    add r1, r1, #1
    mov r6, r4, LSR #31
    mov r7, r2, LSR r1
    eor r7, r7, r6
    sub r7, r7, r6
    sub r5, r2, r7

    mov r7, r3, LSR r1
    eor r7, r7, r6
    sub r7, r7, r6
    add r8, r3, r7

    ldr r7, =cordic_ctab
    sub r10, r1, #1
    mov r11, #4
    mov r12, r11, LSR r10
    ldr r7, [r7, r12]
    eor r7, r7, r6
    sub r7, r7, r6
    sub r9, r4, r7

    mov r2, r5
    mov r3, r8
    mov r4, r9

    cmp r1, r0
    ble loop