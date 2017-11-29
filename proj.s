.data
cordic_ctab: .word 2097149, 1048575, 524287, 262143, 131071, 65535, 32767, 16383, 8191, 4095, 2047, 1023, 511, 255, 127, 63, 31, 15, 8, 4, 2, 1, 0
cordic_1k: .word 0x26DD3B6A
MUL: .word 0x4E800000
MULINV: .word 0x307FFFFF
.L3: .word cordic_ctab
.L4: .word 652032874
X: .word 0x00000000
Y: .word 0x00000000
Z: .word 0x00000000
D: .word 0x00000000
ANS: .word 0x00000000
theta: .word 0x41F00000             @ 30 degs to rad in ieee754
deg_convert_const: .word 0x3C8EFA35

.text
.global main
main:
    ldr r0, =theta
    ldr r1, [r0]                    @ r1=30° in ieee754
    ldr r0, =deg_convert_const
    ldr r2, [r0]                    @ r2=(PI/180)
    bl multiply_754                  @ Find 30° in rad
    ldr r1, =theta                      
    str r0, [r1]                    @ Store Z value

    ldr r0, =MUL
    ldr r1, [r0]                    @ r1=MUL constant for cordic
    ldr r0, =Z
    ldr r2, [r0]                    @ r2=updated theta
    bl multiply_754                  @ Find final theta value
    ldr r1, =Z
    str r0, [r1]                    @ Store updated Z value

    ldr r0, =cordic_1k
    ldr r0, [r0]
    ldr r1, =X
    str r0, [r1]                    @ Store X value

    ldr r0, =Y
    mov r1, #0x00000000
    str r1, [r0]                    @ Store Y value

    mov r0, #0                      @ Loop counter
    mov r1, #22                     @ Loop limit

    b loop

loop:
    ldr r6, =Z
    ldr r4, [r6]
    mov r5, r4, lsr #23
    sub r4, r5, #22
    mov r5, r5, lsl #23
    orr r4, r5, r4
    ldr r6, =D
    str r7, [r6]

    ldr r6, =X
    ldr r2, [r6]
    mov r5, r2, lsr #23
    sub r2, r5, r0
    mov r5, r5, lsl #23
    orr r2, r5, r2
    eor r2, r2, r7
    sub r2, r2, r7
    ldr r8, [r6]
    sub r8, r8, r2
    str r8, [r6]

    ldr r6, =Y
    ldr r3, [r6]
    mov r5, r3, lsr #23
    sub r5, r5, r0
    mov r5, r5, lsl #23
    orr r3, r5, r3
    eor r3, r3, r7
    sub r3, r3, r7
    ldr r8, [r6]
    add r8, r8, r3
    str r8, [r6]

    ldr r6, =cordic_ctab
    ldr r3, =Z
    mov r8, #4
    mul r9, r8, r0
    ldr r4, [r6, r9]
    eor r4, r4, r7
    sub r4, r4, r7
    ldr r8, [r3]
    sub r8, r8, r4
    str r8, [r3]

    cmp r0, r1
    add r0, r0, #1
    ble loop

finished:
    ldr r3, =Y
    ldr r1, [r3]
    ldr r3, =MULINV
    ldr r2, [r3]
    bl multiply_754 
    ldr r3, =ANS
    str r0, [r3]


@ Multiplicands stored in r1 and r2
multiply_754:
    and r3, r1, #0x80000000         @ Extract sign
    and r4, r1, #0x80000000

    eor r0, r3, r4                  @ Find new sign
    ldr r9, =0x7F800000
    and r3, r1, r8                  @ Extract exponents
    and r4, r2, r9

    mov r3, r3, lsr #23             @ Move to other side of decimal point
    mov r4, r4, lsr #23
    sub r3, r3, #127                @ Remove the bias
    sub r4, r4, #127
    add r5, r3, r4                  @ r5 holds exponent

    ldr r9, =0x007FFFFF
    and r3, r1, r9                  @ Extract fractions
    and r4, r2, r9
    orr r3, r3, #0x00800000         @ Add implied 1
    orr r4, r4, #0x00800000
    stmfd sp!, {r3-r4, r8-r9}       @ Save r6 & r7
    mov r6, #0                      @ Zero out r6-r9
    mov r7, #0
    mov r9, #0

mul:
    ands r8, r3, #1                 @ Check for 1 in LSB
    beq no_add

    adds r7, r7, r4
    adc r6, r6, r9

no_add:
    mov r9, r9, lsl #1              
    movs r4, r4, lsl #1
    adc r9, r9, #0                  @ Shift to left, move carry bit and add overflow

    movs r3, r3, lsr #1             @ Shift r3 and set flags
    bne mul                         @ Branch if r3 is not 0 yet
    ldmfd sp!, {r3-r4, r8-r9}       @ Pop r3-r4, r8-r9

creatfraction:
    ands r8, r6, #0x00008000         
    
    addne r5, r5, #1                @ If 16th bit is a 1
    movne r6, r6, lsl #16           @ Making room
    movne r7, r7, lsr #16
    
    moveq r6, r6, lsl #17           @ If 16th bit is not a 1
    moveq r7, r7, lsr #15           @ Making room
    
    orr r6, r6, r7                  @ Merging fractions together 
    mov r6, r6, lsr #8              @ Can only use 24 bits
    bic r6, r6, #0x00800000         @ Clear the 1 

done_mul:
    add r5, r5, #127                @ Re-add bias to the exponent
    mov r5, r5, lsl #23             @ Put exponent into position
    orr r0, r0, r5                  @ Place exponent
    orr r0, r0, r6                  @ Place fraction
    mov pc, lr


@ r0 = r1 - r2
subfloat:
    ldr r10, =0x80000000
    eor r2, r2, r10                 @ Exclusive or r2 with 0x80000000 to toggle the sign bit
    bl addfloat
    swi 0x11

@ r0 = r1 + r2
addfloat:
    ldr r10, =0x7f800000
    and r4, r1, r10                 @ use a bitmask to capture the first number's exponent
    and r5, r2, r10                 @ use a bitmask to capture the second number's exponent
    cmp r4, r5

    movcc r3, r1
    movcc r1, r2
    movcc r2, r3                    @ swap r1 with r2 if r2 has the higher exponent
    andcc r4, r1, r10 
    andcc r5, r2, r10               @ update exponents if swapped

    mov r4, r4, lsr #23
    mov r5, r5, lsr #23             @ move exponents to least significant position

    sub r3, r4, r5                  @ subtract exponents to get shift amount
    ldr r10, =0x007fffff     
    and r5, r1, r10                 @ grab first number's fractional part
    and r6, r2, r10                 @ grab second number's fractional part
    ldr r10, =0x00800000
    orr r5, r5, r10                 @ add implied 1 to first fractional part
    orr r6, r6, r10                 @ add implied 1 to second fractional part
    mov r6, r6, lsr r3              @ shift r6 to the right by the difference in exponents

    ldr r10, =0x80000000
    ands r0, r1, r10                @ check msb for negative bit
    movne r0, r5                    @ this "not equal" works because the "ands" will set the zero flag if the result is zero
    stmnefd sp!, {lr}
    blne twos_complement            @ two's complement fractional first number if it's supposed to be negative
    ldmnefd sp!, {lr}
    movne r5, r0

    ands r0, r2, r10                @ check msb for negative bit
    movne r0, r6
    stmnefd sp!, {lr}
    blne twos_complement            @ two's complement fractional second number if it's supposed to be negative
    ldmnefd sp!, {lr}
    movne r6, r0

    add r5, r5, r6                  @ add the fractional portions. r5 contains the result.

    ands r0, r5, r10                @ check msb to see if the result is negative
    movne r0, r5
    stmnefd sp!, {lr}
    blne twos_complement            @ two's complement result if negative
    ldmnefd sp!, {lr}
    movne r5, r0
    ldrne r0, =0x80000000           @ put a 1 as result's msb if the result was negative
    moveq r0, #0                    @ put a 0 as result's msb if the result was positive

    mov r3, #0
    ldr r10, =0x80000000

count_sigbit_loop:
    cmp r10, r5
    addhi r3, r3, #1
    movhi r10, r10, lsr #1
    bhi count_sigbit_loop           @ count how many times you have to shift before hitting a 1 in the result

    cmp r3, #8                      @ if it's shifted 8 times it's already in the right place
    subhi r3, r3, #8                @ if it needs shifting left, determine how many times
    movhi r5, r5, lsl r3            @ shift as needed
    subhi r4, r4, r3                @ subtract shift amount from exponent to reflect shift
    movcc r10, #8
    subcc r3, r10, r3               @ if it needs shifting right, determine how many times
    movcc r5, r5, lsr r3            @ shift as needed
    addcc r4, r4, r3                @ add shift amount to exponent to relfect shift

    mov r4, r4, lsl #23             @ shift exponent into place
    orr r0, r0, r4                  @ or exponent into number
    ldr r10, =0x007fffff
    and r5, r5, r10                 @ get rid of implied 1 in fraction
    orr r0, r0, r5                  @ attach fractional part

    mov pc, lr

@ r0 = -r0
twos_complement:
    mvn r0, r0                      @ negate r0
    add r0, r0, #1                  @ add 1
    mov pc, lr                      @ Return to caller