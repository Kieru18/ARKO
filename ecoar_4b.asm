#4b
#The first and the second character in the string represent the (begin and the end) markers, which define a
#substring. Your task is to replace all characters before the first occurrence of begin marker and first occurcence
#of the end marker with * character. If there is no begin or end marker in the input string (the string after the :
#character), then nothing should be changed. Replace the first three characters of the string with spaces. 


.data
text_test:		.asciz	"oi:wind on the hill"
text_test2:	.asciz	"ac:aB[BBaK;'91)a"
text_test3:	.asciz	"lc:abwgdjcejoze"

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
	
	la	a0,	text_results
	ecall
	la	a0,	text_test
	ecall
	
	li	a7,	10
	ecall
	
remove:
	li	t5,	' '
	mv	t6,	a0
	lbu	t0,	(t6)		# t0 - begin char
	sb	t5,	(t6)
	addi	t6,	t6,	1
	
	lbu	t1,	(t6)		# t1 - end char
	sb	t5,	(t6)
	addi	t6,	t6,	1
	
	sb	t5,	(t6)
	

find_begin:
	addi	t6,	t6,	1
	lbu	t2,	(t6)
	beqz t2,	exit
	bne	t2,	t0,	find_begin
	mv	t3,	t6		# t3 = begin pointer
	
find_end:
	addi	t6,	t6,	1
	lbu	t2,	(t6)
	beqz	t2,	exit
	bne	t2,	t1,	find_end
	mv	t4,	t6		# t4 = end pointer
	
	addi	a0,	a0,	2
	li	t5,	'*'
	
replace_loop:
	addi	a0,	a0,	1
	lbu	t2,	(a0)
	beqz	t2,	exit
	bltu	a0,	t3,	replace
	bgtu	a0,	t4,	replace
	j	replace_loop
	

replace:
	sb	t5,	(a0)
	j	replace_loop
	
exit:
	ret
