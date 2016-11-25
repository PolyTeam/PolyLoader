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

#
# Strings and data
#
loadk_msg:
	.asciz	"STAGE 2 : Loading kernel...\r\n"
rst_disks_msg:
	.asciz	"STAGE 2 : Reset disks...\r\n"
kcopy_msg:
	.asciz	"STAGE 2 : Copy kernel...\r\n"
a20_msg:
	.asciz	"STAGE 2 : Enable A20 Gate...\r\n"
load_gdt_msg:
	.asciz	"STAGE 2 : Load GDT...\r\n"
go_protected_msg:
	.asciz	"STAGE 2 : Enable protected mode...\r\n"

.align 8
gdt:
	.byte 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte	0xff, 0xff, 0x00, 0x00, 0x00, 0x9b, 0xdf, 0x00
	.byte	0xff, 0xff, 0x00, 0x00, 0x00, 0x93, 0xdf, 0x00
.align 8
gdtptr:
	.short	0x18
	.long	(gdt + STAGE2_BOOTSEG * 0x10 + STAGE2_BOOTOFF)	

.include "memory.S"
.include "utils.S"

#
# Stage 2 bootloader
#
_start:
	/* Initializing segments */
	movw 	$STAGE2_BOOTSEG, %ax
	movw	%ax, %ds
	movw 	%ax, %es
	movw 	$STAGE2_STACKSEG, %ax
	movw	%ax, %ss
	movw	$STAGE2_STACKP, %sp

	/* Reset disks */
	movw	$rst_disks_msg, %si
	call	print_msg
	movb	$0x0, %ah
	int	$0x13

	/* Load the kernel */
	movw	$kcopy_msg, %si
	call	print_msg
	
	pushw	%es
	movw	$0x0f00, %ax
	movw	%ax, %es
	movw	$0x0000, %bx

	movb	$0x02, %ah
	movb	$0x01, %al
	movb	$0x00, %ch
	movb	$0x03, %cl
	movb	$0x00, %dh
	movb	$0x00, %dl
	int 	$0x13	
	popw	%es

	/* A20 Gate */
	movw	$a20_msg, %si
	call	print_msg	

	in	$0x92, %al
	test	$2, %al
	jnz	after
	or	$0x02, %al
	and	$0xfe, %al
	out	%al, $0x92
	after:

	/* Setup GDT and enable protected mode */
	movw	$load_gdt_msg, %si
	call	print_msg
	cli
	lgdt	gdtptr

	movw	$go_protected_msg, %si
	call	print_msg
	movl	%cr0, %eax
	orl	$0x00000001, %eax
	movl	%eax, %cr0

	/* Setup kernel segments */
	movw	$16, %ax
	movw	%ax, %ds
	movw 	%ax, %es
	movw	%ax, %fs
	movw 	%ax, %gs

	movw	$16, %ax
	movw 	%ax, %ss
	movl	$0x7e00, %esp

	/* Jump to kernel */
	ljmp	$0x08, $0xf000
	//ljmp	$0x08, $0x8368

.code32
test:
	movb	$0x41, 0xb8000
	movb	$0x57, 0xb8001
	movb	$0x41, 0xb8002
	movb	$0x57, 0xb8003
	movb	$0x41, 0xb8004
	movb	$0x57, 0xb8005
	movb	$0x41, 0xb8006
	movb	$0x57, 0xb8007
	jmp	.

.org 511
padding:
	.byte	0x00	
