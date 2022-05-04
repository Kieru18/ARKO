# 5g
# Write function remove which removes from the source string every character between the first occurrence of
# left square bracket ([) and the first following it occurrence of right square bracket (]). remove returns the
# length of the resulting string. 

# solutions requires correct string (not including both brackets results in wrong return value)

.data
text_test:		.asciz	"Il ][ barbiere ][ di Siviglia"
text_test2:	.asciz	"aaaB[BBaK;'91)a"
text_test3:	.asciz	"askdjnalsjndalksndl] ] ] ]] ] "

text_input:	.asciz	"\nSource			> "
text_return:	.asciz	"\nReturn value		> "
text_results:	.asciz	"\nResult			> "

.text
main:
	li	a7,	4
	la	a0,	text_input
	ecall
	la	a0,	text_test
	ecall
	
	# text_test already in a0
	jal	remove
	
	# return value in a0
	mv 	s0,	a0
	la	a0,	text_return	
	li	a7,	4
	ecall
	mv	a0,	s0
	li	a7,	1
	ecall
	mv	s0,	zero
	
	li	a7,	4
	la	a0,	text_results
	ecall
	la	a0,	text_test
	ecall
	
	li	a7,	10
	ecall
	
remove:
	li	t0,	'['
	li	t1,	']'
	mv	t6,	a0

find_left:
	lbu	t2,	(a0)	
	beqz	t2,	exit
	addi	a0,	a0,	1
	mv	t3,	a0
	beq	t2,	t0,	find_right
	j	find_left

find_right:
	lbu	t4,	(t3)
	addi	t3,	t3,	1
	beqz	t4,	exit
	beq	t4,	t1,	replace
	j	find_right

replace:
	sb	t4,	(a0)
	sb	t0,	(t3)
	
	beqz	t4,	exit
	
	addi	a0,	a0,	1
	addi	t3,	t3,	1
	lbu	t4,	(t3)
	j	replace


exit:
	sub	a0,	a0,	t6
	ret
	