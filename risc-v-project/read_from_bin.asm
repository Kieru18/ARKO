#-------------------------------------------------------------------------------
#author: Jakub Kieruczenko
#date : 2022.05.23
#description : turtle ver2 project 
#-------------------------------------------------------------------------------
#	struct {
#		char* filename;		// wskazanie na nazwe pliku
#		unsigned char* hdrData; // wskazanie na bufor naglowka pliku BMP
#		unsigned char* imgData; // wskazanie na pierwszy piksel obrazu w pamieci
#		int width, height;	// szerokosc i wysokosc obrazu w pikselach
#		int linebytes;		// rozmiar linii (wiersza) obrazu w bajtach
#	} imgInfo;

.eqv ImgInfo_fname	0
.eqv ImgInfo_hdrdat 4
.eqv ImgInfo_imdat	8
.eqv ImgInfo_width	12
.eqv ImgInfo_height	16
.eqv ImgInfo_lbytes	20

.eqv MAX_IMG_SIZE 	230400 # 320 x 240 x 3 (piksele) 
.eqv BMPHeader_Size   54
.eqv BMPHeader_width  18
.eqv BMPHeader_height 22

.eqv system_OpenFile	1024
.eqv system_ReadFile		63
.eqv system_WriteFile	64
.eqv system_CloseFile	57

.data
	imgInfo: .space	24	# deskryptor obrazu
	
	.align 2		# wyrownanie do granicy slowa
	dummy:		.space	2
	bmpHeader:	.space	BMPHeader_Size

	.align 2
	imgData: 	.space	MAX_IMG_SIZE

	ifname: 	.asciz	"D:/studia/sem2/arko/risc-v/turtle2.bin"
	ofname:	.asciz	"D:/studia/sem2/arko/risc-v/turtle2.bmp"
	base:		.asciz	"D:/studia/sem2/arko/risc-v/base.bmp"
	err_msg: 	.asciz	"Error reading the file."
	endl:		.asciz	"\n "
	x:		.asciz	"\nx = "
	y:		.asciz	"\ny = "
	distance:	.string	"\ndistance = "
	pen:		.asciz	"\npen state = "
	red:		.asciz	"\nred = "
	green:	.asciz	"\ngreen = "
	blue:		.asciz	"\nblue = "
	rotation:	.asciz	"\nrotation = "
	
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
  	
  	li	a7,	57		# system call for close file
  	mv	a0,	s6		# file descriptor to close
 	ecall
  	
check_for_error:
	beqz	s1,	error
	la	s2,	buffer
	addi	s1,	s1,	-1

read_loop:
  	beqz	s1,	exit
  	
read_instruction:	
  	lbu	t0,	1(s2)
  	andi	t3,	t0,	3	# get the command code

 	beqz	t3,	set_position_args	# command code == 0
 	
 	addi	t3,	t3,	-1
 	beqz	t3,	move_args		# command code == 1
 	
 	addi	t3,	t3,	-1
 	beqz	t3,	set_direction_args	# command code == 2
 	
 	addi	t3,	t3,	-1
 	beqz	t3,	set_pen_state_args	# command code == 3

set_position_args:
  	la	a0,	endl
  	li	a7,	4
  	ecall
  	li	a0,	0
  	li	a7,	1
  	ecall
  	
  	addi	s2,	s2,	2	# go to second word of set_position command
  	lbu	t0,	1(s2)
  	andi	t2,	t0,	63
  	srli	t0,	t0,	6
  	lbu	t1,	(s2)
  	slli	t1,	t1,	2
  	add	t1,	t1,	t0
  	addi	s2,	s2,	2
  	addi	s1,	s1,	-4
  	
  	la	a0,	x
  	li	a7,	4
  	ecall
  	mv	a0,	t1
  	li	a7,	1
  	ecall
  	la	a0,	y
  	li	a7,	4
  	ecall
  	mv	a0,	t2
  	li	a7,	1
  	ecall
  	j	read_loop

move_args:
	la	a0,	endl
  	li	a7,	4
  	ecall
	li	a0,	1
	li	a7,	1
  	ecall
  	
  	lbu	t0,	1(s2)
  	andi	t2,	t0,	63
  	srli	t0,	t0,	6
  	lbu	t1,	(s2)
  	slli	t1,	t1,	2
  	add	t1,	t1,	t0
  	
  	la	a0,	distance
  	li	a7,	4
  	ecall
  	mv	a0,	t1
  	li	a7,	1
  	ecall
  	
  	addi	s2,	s2,	2
  	addi	s1,	s1,	-2
  	j	read_loop
  	
set_direction_args:
	la	a0,	endl
  	li	a7,	4
  	ecall
	li	a0,	2
	li	a7,	1
  	ecall
  	
	lbu	t1,	(s2)
	srli	t1,	t1,	6
	
	la	a0,	rotation
  	li	a7,	4
  	ecall
  	mv	a0,	t1
  	li	a7,	1
  	ecall
  	
  	addi	s2,	s2,	2
  	addi	s1,	s1,	-2
  	j	read_loop

set_pen_state_args:
	la	a0,	endl
  	li	a7,	4
  	ecall
	li	a0,	3
	li	a7,	1
  	ecall
  	
  	lbu	t5,	(s2)
  	lbu	t4,	1(s2)
  	
  	andi	t1,	t4,	4
  	srli	t1,	t1,	2
  	andi	t4,	t4,	240
  	andi	t2,	t5,	240
  	andi	t3,	t5,	15
  	slli	t3,	t3,	4
  	
  	la	a0,	pen
  	li	a7,	4
  	ecall
  	mv	a0,	t1
  	li	a7,	1
  	ecall
  	la	a0,	red
  	li	a7,	4
  	ecall
  	mv	a0,	t2
  	li	a7,	1
  	ecall
  	la	a0,	green
  	li	a7,	4
  	ecall
  	mv	a0,	t3
  	li	a7,	1
  	ecall
  	la	a0,	blue
  	li	a7,	4
  	ecall
  	mv	a0,	t4
  	li	a7,	1
  	ecall
  	
  	addi	s2,	s2,	2
  	addi	s1,	s1,	-2
 	j	read_loop

error:
	li	a7,	4
	la	a0,	err_msg
	ecall

exit:
	li	a7,	10
	ecall

