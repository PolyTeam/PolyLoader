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

/*
 * reset_screen : used to clear the screen content during the early boot,
 * 	then move the cursor to the first row / first column of the screen to
 *	write in this place.
 * 	params : None
 */
reset_screen:
	pushw	%ax
	pushw	%bx
	pushw	%cx
	pushw	%dx

	/* Scroll the screen */
	movb	$0x07, %ah	# Function 0x07
	movb	$0x00, %al	# Scroll the whole window
	movb	$0x07, %bh	# Char attr : white on black
	movw	$0x0000, %cx	# Starting from top left
	movw	$0x184f, %dx	# To bottom right
	int	$0x10

 	/* Move the cursor position */
	popw	%dx
	popw	%cx
	popw 	%bx
	popw	%ax

	ret
