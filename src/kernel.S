#
# PolyLoader bootloader
#
# Basic kernel used to test the PolyLoader bootloader 
#

.code16
.org 0x0
.global _start

	jmp 	_start

.include "memory.S"
.include "utils.S"

_start:
	/*
	 * Here we do kernel stuff, like pushing victory message and shits
	 */
	mov	$(victory_msg), %si
	call	print_msg

end:
	jmp 	end

victory_msg:
	.asciz "Here is kernel speaking...\r\n"

.org 511
padding:
	.byte 0x00
