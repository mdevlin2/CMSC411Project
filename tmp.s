.text
main:
	mov r0, #30
	mov r9, #0
	ldr r1, =Z
	ldr r2, =MUL

loop:
	add r9, r9, #1
	ldr r3, [r2, #4]
	ldr r4, [r2]
	ldr r5, [r1, #4]
	ldr r6, [r1]
	adds r7, r3, r5
	adcs r8, r4, r6
	str r7, [r1, #4]
	str r8, [r1]
	cmp r9, r0
	ble loop

.data
MUL: .word 0x00000000, 1073741824
Z: .word 0x00000000, 0x00000000