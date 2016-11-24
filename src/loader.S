#
# PolyLoader bootloader
#
# Simple bootloader use to start the PolyHeart kernel.
#
# At boot, the BIOS will store different values :
# * %dl		: will store the device number this block was loaded from
# * %es:%si	: will store the partition table entry we were loaded from
#
# .org 0x0 is used, so the memory locations in the released binary are starting
# from 0x0. To access to the corresponding physical address, use 0x7c00 + offset


.code16
.org 0x0
.global _start

	jmp	_start

.include "memory.S"
.include "utils.S"

_start:
	/* Initializing segments */
	mov 	$stage1_bootoff, %ax
	mov	%ax, %ds
	mov 	%ax, %es
	mov 	$stage1_stackseg, %ax
	mov	%ax, %ss
	mov	$stage1_stackp, %sp

	/* Backing up device number this block was loaded from */
	mov	%dl, (bootdisk)	

	/* Reset disk */
	mov 	$(reset_msg), %si
	call 	print_msg
	xor 	%ax, %ax
	int	$0x13
	
	/* Copy stage 2 from the disk to the memory */
	mov	$(loading_msg), %si
	call	print_msg
	
	push 	%es
	mov	$stage2_bootseg, %ax
	mov	%ax, %es
	mov	$stage2_bootoff, %bx

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
	ljmp	$stage2_bootseg, $stage2_bootoff

end:
	jmp 	end

reset_msg:
	.asciz "Reseting disks...\r\n"
loading_msg:
	.asciz "Loading stage 2...\r\n"
loaded_msg:
	.asciz "Stage 2 loaded, jumping...\r\n"
bootdisk:
	.byte 0

.org 510
magic:
	.word	0xaa55
	
