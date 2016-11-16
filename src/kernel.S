#
# PolyLoader bootloader
#
# Basic kernel used to test the PolyLoader bootloader 
#

.code16
.org 0x0
.global _start

	jmp 	_start

.include "utils.S"

_start:
	/* Initializing segments and stack */
	mov 	$0x0100, %ax
	mov	%ax, %ds
	mov 	%ax, %es
	mov 	$0x8000, %ax
	mov	%ax, %ss
	mov	$0xf000, %sp

	/* Show a simple victory message */
	mov	$(victory_msg), %si
	call	print_msg

end:
	jmp 	end

victory_msg:
	.asciz "Here is kernel speaking...\r\n"

