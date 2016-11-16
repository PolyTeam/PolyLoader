#
# PolyLoader bootloader
#
# Simple bootloader use to start the PolyHeart kernel.
#
# At boot, the BIOS will store different values :
# * %dl		: will store the device number this block was loaded from
# * %es:%si	: will store the partition table entry we were loaded from
#

.code16
.org 0x0
.global _start

	jmp	_start

.include "utils.S"

_start:
	/* Initializing segments */
	mov 	$0x07c0, %ax
	mov	%ax, %ds
	mov 	%ax, %es
	mov 	$0x8000, %ax
	mov	%ax, %ss
	mov	$0xf000, %sp

	/* Backing up device number this block was loaded from */
	mov	%dl, (bootdisk)	

	/* Reset disk */
	mov 	$(reset_msg), %si
	call 	print_msg
	xor 	%ax, %ax
	int	$0x13
	
	/* Copy kernel from the disk to the memory */
	mov	$(loading_msg), %si
	call	print_msg
	
	push 	%es
	mov	$0x0100, %ax
	mov	%ax, %es
	mov	$0, %bx

	mov 	$2, %ah
	mov	$1, %al
	mov	$0, %ch
	mov 	$2, %cl
	mov	$0, %dh
	mov	(bootdisk), %dl
	int	$0x13
	pop 	%es

	mov	$(loaded_msg), %si
	call	print_msg

	/* Finish, we can jump to the kernel code */
	ljmp	$0x0100, $0x0000

end:
	jmp 	end

reset_msg:
	.asciz "Reseting disks...\r\n"
loading_msg:
	.asciz "Loading kernel...\r\n"
loaded_msg:
	.asciz "Kernel loaded, jumping...\r\n"
bootdisk:
	.byte 0

.org 510
magic:
	.word	0xaa55
	
