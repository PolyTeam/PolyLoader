print_msg:
	push	%ax
	push 	%bx
print_msg_start:
	lodsb
	cmp	$0, %al
	jz	print_msg_end
	mov	$0x0e, %ah
	mov	$0x07, %bx
	int	$0x10
	jmp 	print_msg_start
print_msg_end:
	pop 	%bx
	pop	%ax
	ret
