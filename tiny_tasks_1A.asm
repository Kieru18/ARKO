# 1A
# napisaæ funkcjê replace zastêpuj¹c¹ ma³e litery znakiem '*'. 
# replace zwraca liczbê wykonanych zamian znaków.

.data
text_test:		.asciz	"Wind On The Hill"
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
	jal	replace
	
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
	
replace:
	li	t0,	'a'
	li	t1,	'z'
	li	t2,	'*'
	mv	t3,	zero

loop:
	lbu	t4,	(a0)
	beqz	t4,	loop_exit
	bltu	t4,	t0,	next_char
	bgtu	t4,	t1,	next_char
	sb	t2,	(a0)
	addi	t3,	t3,	1
	
next_char:
	addi	a0,	a0,	1
	j	loop
	
loop_exit:
	mv	a0,	t3
	ret
	
	
		


	
	
	
	
	
