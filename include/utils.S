.code16

.func writeString
	writeString:
		lodsb			# Load ds:si byte into al
		or	%al, %al	# Test if char is 0
		jz	writeString_end
		
		mov	$0xe, %ah
		mov	$9, %bx
		int 	$0x10
		
		jmp writeString

	writeString_end:
		retw
.endfunc

