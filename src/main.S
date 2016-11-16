/*
 * PolyLoader
 *
 * Simple bootloader used in Poly project
 */

.code16
.text
.org 0x0

LOAD_SEGMENT = 0x1000

.global _start

_start:
	cli			# Disable interrupts

	mov %dl, bootUnit 	# Backup boot unit

	mov %cs, %ax		# Code segment to 0x0
	mov %ax, %ds		# DS = CS = 0x0
	mov %ax, %es		# ES = CS = 0x0
	mov %ax, %ss		# SS = CS = 0x0
	mov $0x7c00, %sp	# Stack goes down from current segment, offset 0x7c00
	sti

	# Show greeting message
	lea helloMsg, %si
	call writeString

finish:
	jmp finish

.include "utils.S"

helloMsg:	.asciz "Hello, world ! !"
bootUnit: 	.byte 0

.fill (510-(.-_start)), 1, 0
BootMagic:	.int 0xaa55
