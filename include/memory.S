
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
.equ stage1_bootseg, 	0x0000
.equ stage1_bootoff, 	0x07c0

.equ stage1_stackseg, 	0x0000
.equ stage1_stackoff,	0x07e0
.equ stage1_stackp,	0xf7e0

#
# Stage 2 bootloader
#
.equ stage2_bootseg,	0x1100
.equ stage2_bootoff, 	0x0000

.equ stage2_stackseg,	0x1000
.equ stage2_stackoff,	0x0000
.equ stage2_stackp,	0x1000

#
# Kernel
#
.equ kernel_bootseg,	0x7100
.equ kernel_bootoff,	0x0000

.equ kernel_stackseg,	0x7000
.equ kernel_stackoff,	0x0000
.equ kernel_stackp,	0x1000
