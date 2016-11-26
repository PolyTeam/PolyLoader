
/*
Memory map (physical addresses)

| 0x00000
|	BIOS Stuff
| 0x007c0
|	Stage 1 bootloader
| 0x007e0
|	Stage 1 bootloader stack
| 0x0f7e0
|	EMPTY
| 0x10000
|	Stage 2 bootloader stack
| 0x11000
|	Stage 2 bootloader
| 0xfffff
*/

#
# Stage 1 bootloader
#
.equ STAGE1_BOOTSEG, 	0x07c0
.equ STAGE1_BOOTOFF, 	0x0000

.equ STAGE1_STACKSEG, 	0x07e0
.equ STAGE1_STACKOFF,	0x0000
.equ STAGE1_STACKP,	0x0400

#
# Stage 2 bootloader
#
.equ STAGE2_BOOTSEG,	0x0820
.equ STAGE2_BOOTOFF, 	0x0000

.equ STAGE2_STACKSEG,	0x0860
.equ STAGE2_STACKOFF,	0x0000
.equ STAGE2_STACKP,	0x0400

#
# Kernel
#
.equ KERNEL_BOOTSEG,	0x0010
.equ KERNEL_BOOTOFF,	0x0000

.equ KERNEL_STACKSEG,	0x0008
.equ KERNEL_STACKOFF,	0x0000
.equ KERNEL_STACKP,	0x00100000
