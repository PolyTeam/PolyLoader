#
# PolyLoader bootloader stage2
#
# Simple bootloader use to start the PolyHeart kernel.
#
# This second stage should enabled protected mode (%cr0 & $0x1), then copy the
# kernel to a fixed memory location through unreal mode. Finally, we can jump
# to the kernel code.
#

.code16
.org 0x0
.global _start

	jmp	_start

.include "memory.S"
.include "utils.S"

_start:
	/* Initializing segments */
	mov 	$stage2_bootseg, %ax
	mov	%ax, %ds
	mov 	%ax, %es
	mov 	$stage2_stackseg, %ax
	mov	%ax, %ss
	mov	$stage2_stackp, %sp

	mov 	$(stage2_hello_msg), %si
	call	print_msg

	/* Load kernel */
	mov	$(stage2_loading_msg), %si
	call 	print_msg

	# Bypass bootdisk retieving, do this later
	# Get info from Princeton bootblock project	

	push	%es
	# Where to load the data
	mov	$kernel_bootseg, %ax
	mov	%ax, %es
	mov 	$stage2_bootoff, %bx

	mov	$2, %ah		# Instruction read
	mov	$1, %al		# Number of sectors to read ?
	mov	$0, %ch		# NOPE
	mov	$4, %cl		# Num. of 1st sector to read
	mov	$0, %dl		# Data we dont have
	int	$0x13
	pop	%es

	mov	$(stage2_loaded_msg), %si
	call	print_msg

	/* Kernel setup */
	mov	$kernel_bootseg, %ax
	mov	%ax, %ds
	mov	%ax, %es
	mov	$kernel_stackseg, %ax
	mov	%ax, %ss
	mov	$kernel_stackp, %sp

	ljmp	$kernel_bootseg, $kernel_bootoff

end:
	jmp 	end

stage2_hello_msg:
	.asciz "Stage 2 available...\r\n"
stage2_loading_msg:
	.asciz "Loading the kernel...\r\n"
stage2_loaded_msg:
	.asciz "Kernel loaded, jumping into it...\r\n"
bootdisk:
	.byte 0

.org 1023
padding:
	.byte	0x00
	
