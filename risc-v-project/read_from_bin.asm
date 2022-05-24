.data
	ifname: 	.asciz	"D:/studia/sem2/arko/risc-v/turtle2.bin"
	err_msg: 	.asciz	"Error reading the file."
	.align 3
	buffer:	.space	512
	
 
 .text
 main:
  	li	a7,	1024		# system call for open file
  	la 	a0,	ifname
  	li	a1,	0		# Open for writing (flags are 0: read, 1: write)
  	ecall				# open a file (file descriptor returned in a0)
 	mv	s6,	a0		# save the file descriptor
  	li	a7,	63		# Read from a file descriptor into a buffer
  	la	a1,	buffer	# address of buffer
  	li	a2,	512		# hardcoded buffer length
  	ecall
  	
  	mv	s1,	a0		# save the length
  	addi	s1,	s1,	1
  	
check_for_error:
	beqz	s1,	error
	la	s2,	buffer
  	
read_loop:
  	addi	s1,	s1,	-1
  	beqz	s1,	exit
  	
read_instruction:	
  	lbu	t0,	1(s2)
  	andi	t3,	t0,	3	# get the command code
 	
 	# beqz	t3,	set_position_args
  	

set_position_args:
  	addi	s2,	s2,	2	# goto second word of set_position command
  	lbu	t0,	1(s2)
  	andi	t2,	t0,	63
  	srli	t0,	t0,	6
  	lbu	t1,	(s2)
  	slli	t1,	t1,	2
  	add	t1,	t1,	t0
  	j	exit
  	
error:
	li	a7,	4
	la	a0,	err_msg
	ecall

exit:
	li	a7,	57		# system call for close file
  	mv	a0,	s6		# file descriptor to close
 	ecall
 	
	li	a7,	10
	ecall

