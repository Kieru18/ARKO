# 3A
# Proszê napisaæ funkcjê remove usuwaj¹c¹ z ci¹gu znaków ma³e litery. 
# remove zwraca d³ugoœæ wynikowego ci¹gu znaków.

.data
text_test:		.asciz	"Flip, Flop & Fly"
text_test2:	.asciz	"aaaBBBaK;'91)a"

text_input:	.asciz	"\nInput string		> "
text_return:	.asciz	"\nReturn value		> "
text_results:	.asciz	"\nConversion results	> "

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
	li	t0,	'a'
	li	t1,	'z'
	mv	t6,	a0

find_wrong:
	lbu	t2,	(a0)	
	beqz	t2,	loop_exit
	bltu	t2,	t0,	next_char		# < 'a'
	bgtu	t2,	t1,	next_char		# > 'z'
	addi	t3,	a0,	1

find_good:
	lbu	t4,	(t3)
	bltu	t4,	t0,	siup			# < 'a'
	bgtu	t4,	t1,	siup			# > 'z'
	addi	t3,	t3,	1
	j	find_good
	

siup: 		# swap
	sb	t4,	(a0)
	sb	t0,	(t3)
	beqz	t4,	loop_exit
	
next_char:
	addi	a0,	a0,	1
	j	find_wrong
	
loop_exit:
	sub	a0,	a0,	t6
	ret
	