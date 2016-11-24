/*
 * print_msg : print a given message to the screen on the current cursor
 *	position. 
 *	params : %si : memory location of the first character to write
 */
print_msg:
	pushw	%ax
	pushw 	%bx
print_msg_start:
	lodsb
	cmpb	$0, %al
	jz	print_msg_end
	movb	$0x0e, %ah
	movw	$0x07, %bx
	int	$0x10
	jmp 	print_msg_start
print_msg_end:
	popw 	%bx
	popw	%ax
	ret

	ret
