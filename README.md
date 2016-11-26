# PolyLoader

## Requirements

* `as`
* `ls`

## Memory map
```
| 0x00000000 ---------------
|
|       BIOS Stuff
|
| 0x00007c00 ---------------
|
|       Stage 1 Bootloader 520 bytes
|
| 0x00007e00 ---------------
|
|       Stage 1 Stack 1Kib
|
| 0x00008200 ---------------
|
|       Stage 2 Bootloader 1Kib
|
| 0x00008600 ---------------
|
|       Stage 2 Stack 1Kib
|
| 0x00008a00 ---------------
|
|       Empty space
|
| 0x00080000 ---------------
|
|       Kernel Stack
|
| 0x00100000 ---------------
|
|       Kernel
|
| 0xffffffff
```

0x8321
* Create simple bootsector

* [x86 calling conventions - wikipedia.org](https://en.wikipedia.org/wiki/X86_calling_conventions#System_V_AMD64_ABI)
* [To Boot a Computer - danf.wordpress.com](https://danf.wordpress.com/2011/01/04/to-boot-a-computer/)
* [COS 318: Project #1 - cs.princeton.edu](http://www.cs.princeton.edu/courses/archive/fall04/cos318/projects/1.html)

rom code seg : 0x08
rom data seg : 0x10
