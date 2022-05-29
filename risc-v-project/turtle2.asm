#-------------------------------------------------------------------------------
# author: Jakub Kieruczenko
# date : 2022.05.23
# description : Turtle graphics version 2.
#-------------------------------------------------------------------------------
#	struct {
#		char* filename;			// pointer to name of the file
#		unsigned char* hdrData; 	// pointer to buffer of header of BMP file
#		unsigned char* imgData; 	// pointer to first pixel of the image in memory
#		int width, height;		// width and height of the image in pixels
#		int linebytes;			// size of a line of the image in bytes
#	} imgInfo;

.eqv ImgInfo_fname	0
.eqv ImgInfo_hdrdat 4
.eqv ImgInfo_imdat	8
.eqv ImgInfo_width	12
.eqv ImgInfo_height	16
.eqv ImgInfo_lbytes	20

.eqv MAX_IMG_SIZE 147456	 # 768 x 64 x 3 (piksele) 
.eqv BMPHeader_Size   54
.eqv BMPHeader_width  18
.eqv BMPHeader_height 22

.eqv system_OpenFile	1024
.eqv system_ReadFile		63
.eqv system_WriteFile	64
.eqv system_CloseFile	57

.data
	imgInfo: .space	24	# image descriptor
	
	.align 2			# align to word
	dummy:		.space	2
	bmpHeader:	.space	BMPHeader_Size 

	.align 2
	imgData: 	.space	MAX_IMG_SIZE

	ifname: 	.asciz	"D:/studia/sem2/arko/risc-v/turtle2.bin"		# input file with instructions
	ofname:	.asciz	"D:/studia/sem2/arko/risc-v/turtle2.bmp"		# output file
	base:		.asciz	"D:/studia/sem2/arko/risc-v/base.bmp"		# white 768x64 base.
	err_msg: 	.asciz	"Error reading the file."
	
	.align 3
	buffer:	.space	512
	
 
 .text
 main:
  	li	a7,	system_OpenFile	# system call for open file
  	la 	a0,	ifname
  	li	a1,	0				# Open for writing (flags are 0: read, 1: write)
  	ecall						# open a file (file descriptor returned in a0)
 	mv	s6,	a0				# save the file descriptor
  	li	a7,	system_ReadFile	# Read from a file descriptor into a buffer
  	la	a1,	buffer			# address of buffer
  	li	a2,	512				# hardcoded buffer length
  	ecall
  	
  	mv	s1,	a0				# save the length
  	
  	li	a7,	system_CloseFile	# system call for close file
  	mv	a0,	s6				# file descriptor to close
 	ecall
  	
check_for_error:
	addi	s1,	s1,	1
	beqz	s1,	error	# if returned length = -1, error has ocurred
	la	s2,	buffer	# load adress of the instruction data into s2
	addi	s1,	s1,	-1
	add	s1,	s1,	s2
	
open_base:
# read the base to modify it later
	la	a0,	imgInfo 
	la	t0,	base
	sw	t0,	ImgInfo_fname(a0)
	la	t0,	bmpHeader
	sw	t0,	ImgInfo_hdrdat(a0)
	la	t0,	imgData
	sw	t0,	ImgInfo_imdat(a0)
	jal	read_bmp
	bnez	a0,	error
	
	la	s3,	imgInfo

read_loop:
	beq	s1,	s2,	create_bmp	# all instructions were read
  	lbu	t0,	(s2)
  	srai	t3,	t0,	6			# get the command code

 	beqz	t3,	set_position		# command code == 0

 	addi	t3,	t3,	-1
 	beqz	t3,	set_direction		# command code == 1
 	
 	addi	t3,	t3,	-1
 	beqz	t3,	move_args		# command code == 2
 	
 	addi	t3,	t3,	-1
 	beqz	t3,	set_pen_state		# command code == 3

set_position:
  	addi	s2,	s2,	2	# go to second word of set_position command
  	lbu	t0,	(s2)
  	srai	t2,	t0,	2	# get y value
  	andi	t0,	t0,	3
  	slli	t0,	t0,	8
  	lbu	t1,	1(s2)
  	add	t1,	t1,	t0	# get x value

  	addi	s2,	s2,	2
  	
  	mv	s9,	t1
  	mv	s10,	t2
  	j	read_loop

set_direction:  	
	lbu	t1,	1(s2)
	andi	t1,	t1,	3	# get direction value
	
  	mv	s7,	t1
  	
  	addi	s2,	s2,	2
  	j	read_loop

move_args:
  	lbu	t0,	(s2)
  	andi	t0,	t0,	3
  	slli	t0,	t0,	8
  	lbu	t1,	1(s2)
  	add	t1,	t1,	t0	# get distance value
  	
  	addi	s2,	s2,	2
  	
  	mv	s11,	t1
  	addi	s11,	s11,	1
 
 move:
 	addi	s11,	s11,	-1
 	beqz	s11,	read_loop
 	beqz	s8,	move_skip
 	jal	set_pixel
 move_skip:
 	mv	t0,	s7
 	beqz	t0,	go_right
 	addi	t0,	t0,	-1
 	beqz	t0,	go_up
 	addi	t0,	t0,	-1
 	beqz	t0,	go_left
 	addi	t0,	t0,	-1
 	beqz	t0,	go_down
 	
 go_right:
 	addi	s9,	s9,	1
 	li	t1,	768
 	bltu	s9,	t1,	move
 	addi	s9,	s9,	-1
 	j	read_loop
 	
 go_up:
 	addi	s10,	s10,	1
 	li	t1,	64
 	bltu	s10,	t1,	move
 	addi	s10,	s10,	-1
 	j	read_loop
 	
 go_left:
 	addi	s9,	s9,	-1
 	bgtu	s9,	zero,	move
 	mv	s9,	zero
 	j	read_loop
 	
 go_down:
 	addi	s10,	s10,	-1
 	bgtu	s10,	zero,	move
	mv	s10,	zero
 	j	read_loop

set_pen_state:
  	lbu	t1,	(s2)
  	slli	t4,	t1,	4		
  	andi	t4,	t4,	240		# get the b value
  	srli	t1,	t1,	5
  	andi	t1,	t1,	1		# get the ud value
  	lbu	t2,	1(s2)
  	andi	t3,	t2,	240		# get the g value
  	andi	t2,	t2,	15
  	slli	t2,	t2,	4		# get the r value
  	
  	mv	s4,	t2
  	mv	s5,	t3
  	mv	s6,	t4
  	mv	s8,	t1
  	
  	addi	s2,	s2,	2
 	j	read_loop

read_bmp:
	mv	t0,	a0				# preserve imgInfo structure pointer
	# open file
	li	a7,	system_OpenFile
	lw	a0,	ImgInfo_fname(t0)	# file name 
	li	a1,	0				# flags: 0 - read file
	ecall
	
	blt	a0,	zero,		rb_error
	mv	t1,	a0				# save file descriptor
	
	# read header
	li	a7,	system_ReadFile
	lw	a1,	ImgInfo_hdrdat(t0)
	li	a2,	BMPHeader_Size
	ecall
	
	# extract image information from header
	lw	a0,	BMPHeader_width(a1)
	sw	a0,	ImgInfo_width(t0)
	
	# compute line size in bytes - bmp line has to be multiple of 4
	add	a2,	a0,	a0
	add	a0,	a2,	a0	# pixelbytes = width * 3 
	addi	a0,	a0,	3
	srai	a0,	a0,	2
	slli	a0,	a0,	2	# linebytes = ((pixelbytes + 3) / 4 ) * 4
	sw	a0,	ImgInfo_lbytes(t0)
	
	lw	a0,	BMPHeader_height(a1)
	sw	a0,	ImgInfo_height(t0)

	# read image data
	li	a7,	system_ReadFile
	mv	a0,	t1
	lw	a1,	ImgInfo_imdat(t0)
	li	a2,	MAX_IMG_SIZE
	ecall

	# close file
	li	a7,	system_CloseFile
	mv	a0,	t1
   	ecall
	
	mv	a0,	zero
	jr	ra
	
rb_error:
	li	a0,	1	# error opening file	
	jr	ra

save_bmp:
	mv	t0,	a0	# preserve imgInfo structure pointer
	
	# open file
	li	a7,	system_OpenFile
	lw	a0,	ImgInfo_fname(t0)		# file name 
	li	a1,	1					# flags: 1-write file
	ecall
	
	blt	a0,	zero,		error
	mv	t1,	a0					# save file handle for the future
	
	# write header
	li	a7,	system_WriteFile
	lw	a1,	ImgInfo_hdrdat(t0)
	li	a2,	BMPHeader_Size
	ecall
	
	# write image data
	li	a7,	system_WriteFile
	mv	a0,	t1
	# compute image size (linebytes * height)
	lw	a2,	ImgInfo_lbytes(t0)
	lw	a1,	ImgInfo_height(t0)
	mul	a2,	a2,	a1
	lw	a1,	ImgInfo_imdat(t0)
	ecall

	# close file
	li	a7,	system_CloseFile
	mv	a0,	t1
	ecall
	
	mv	a0,	zero
	jr	ra


set_pixel:
	lw	t1,	ImgInfo_lbytes(s3)
	mul	t1,	t1,	s10 	# t1 = y * linebytes
	add	t0,	s9,	s9
	add	t0,	t0,	s9 	# t0 = x * 3
	add	t0,	t0,	t1 	# t0 is offset of the pixel

	lw	t1,	ImgInfo_imdat(s3)	# address of image data
	add	t0,	t0,	t1 			# t0 is address of the pixel
	
	# set new color
	sb	s6,	(t0)	
	sb	s5,	1(t0)	
	sb	s4,	2(t0)	
	jr	ra

error:
 	li	a7,	4
 	la	a0,	err_msg
	ecall 

create_bmp:
	la	a0,	imgInfo
	la	t0,	ofname
	sw	t0,	ImgInfo_fname(a0)
	jal	save_bmp

exit:
	li	a7,	10
	ecall
