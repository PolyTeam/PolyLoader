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

#
# Strings and data
#
dev_nb_msg:
	.asciz	"STAGE 1 : Get boot device number...\r\n"
rst_disk_msg:
	.asciz	"STAGE 1 : Reset disks...\r\n"
load_stage2_msg:
	.asciz	"STAGE 1 : Loading Stage 2...\r\n"
jmp_stage2_msg:
	.asciz	"STAGE 1 : Jumping to Stage 2...\r\n"
bootdisk:
	.byte 	0

#
# Stage 1 bootloader
#
_start:
	/* Initializing segments */
	movw 	$STAGE1_BOOTSEG, %ax
	movw	%ax, %ds
	movw 	%ax, %es
	movw 	$STAGE1_STACKSEG, %ax
	movw	%ax, %ss
	movw	$STAGE1_STACKP, %sp

	/* Backing up device number this block was loaded from */
	movw	$dev_nb_msg, %si
	call	print_msg
	movb	%dl, bootdisk	

	/* Reset disk */
	movw	$rst_disk_msg, %si
	call	print_msg	
	xorw 	%ax, %ax
	int	$0x13

	/* Reset screen */
	call 	reset_screen
	
	/* Copy stage 2 from the disk to the memory */
	movw	$load_stage2_msg, %si
	call	print_msg
	
	pushw 	%es
	movw	$STAGE2_BOOTSEG, %ax	# Destination segment
	movw	%ax, %es
	movw	$STAGE2_BOOTOFF, %bx 	# Destination offset

	movb 	$0x2, %ah
	movb	$0x1, %al		# Total of sectors to read
	movb	$0x0, %ch		# Cylinder
	movb 	$0x2, %cl		# Sector
	movb	$0x0, %dh		# Head
	movb	bootdisk, %dl		# Drive
	int	$0x13
	popw 	%es

	movw	$jmp_stage2_msg, %si
	call	print_msg
	ljmp	$STAGE2_BOOTSEG, $STAGE2_BOOTOFF


.org 510
magic:
	.word	0xaa55
	
