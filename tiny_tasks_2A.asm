# 2A
# Proszê napisaæ funkcjê reverse odwracaj¹c¹ kolejnoœæ znaków w ci¹gu. 
# reverse zwraca d³ugoœæ ci¹gu znaków.

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
	jal	reverse
	
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
	
reverse:
	mv 	t0, 	zero
	mv	t1,	a0
	
set_pointer_loop:
	lbu	t2,	(t1)	
	beqz	t2,	set_pointer
	addi	t1,	t1,	1
	addi	t0,	t0,	1
	j	set_pointer_loop
	
set_pointer:
	addi	t1,	t1,	-1

loop:
	lbu	t3,	(a0)
	lbu	t4,	(t1)
	bgtu	a0,	t1,	loop_exit
	sb	t4,	(a0)
	sb	t3,	(t1)
	addi	a0,	a0,	1
	addi	t1,	t1,	-1
	j	loop
	
loop_exit:
	mv	a0,	t0
	ret
	
	
		


	
	
	
	
	
