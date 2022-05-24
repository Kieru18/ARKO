# 5g
# Write function remove which removes from the source string every character between the first occurrence of
# left square bracket ([) and the first following it occurrence of right square bracket (]). remove returns the
# length of the resulting string. 


.data
text_test:		.asciz	"Il ][ barbiere ][ di Siviglia"
text_test2:	.asciz	"aaaB[BBaK;'91)a"
text_test3:	.asciz	"askl]] ] "

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
	mv	t5,	zero

find_left:
	lbu	t2,	(a0)	
	beqz	t2,	len
	addi	a0,	a0,	1
	mv	t3,	a0
	bne	t2,	t0,	find_left

find_right:
	lbu	t4,	(t3)
	addi	t3,	t3,	1
	beqz	t4,	len
	beq	t4,	t1,	replace
	j	find_right

replace:
	sb	t4,	(a0)
	sb	t0,	(t3)
	
	beqz	t4,	len
	
	addi	a0,	a0,	1
	addi	t3,	t3,	1
	lbu	t4,	(t3)
	j	replace

len:
	lbu	t0,	(t6)
	addi	t5,	t5,	1
	beqz	t0,	exit
	addi	t6,	t6,	1
	j	len

exit:
	mv a0,	t5
	ret
	
