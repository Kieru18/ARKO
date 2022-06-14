;-------------------------------------------------------------------------------
; author: Jakub Kieruczenko
; date : 2022.06.14
; description : Turtle graphics version 2.
;-------------------------------------------------------------------------------

section	.text
global set_pixel
global read_command
global get_x
global get_y
global get_pen_state
global get_distance
global get_direction
global get_red
global get_green
global get_blue

set_pixel:
	push rbx
	mov rbx, rdi
	mov rdi, rsi	;bmp
	mov rsi, rbx	;colors

	push rcx
	cld
	mov rcx, 3
	repnz movsb
	pop rcx

	pop rbx
	ret

read_command:
	mov ax, [rdi]		;command
	shr ax, 14			;get the command code
	and rax, 3

	ret

get_x:
	mov rax, [rdi]		;command
	and rax, 1023		;x is in 10 least significant bits
	
	ret
get_y:
	mov rax, [rdi]		;command
	sar ax, 10
	and rax, 63			;y is now in 6 LSbits

	ret
	
get_pen_state:
	mov rax, [rdi]		;command
	sar ax, 13
	and rax, 1			;pen state (ud) is now the LSB	

	ret
	
get_distance:
	mov rax, [rdi]		;command
	and rax, 1023		;distance is in 10 LSbits
	
	ret
	
get_direction:
	mov rax, [rdi]		;command
	and rax, 3			;direction is in 3 LSbits
	
	ret
	
get_red:
	mov rax, [rdi]		;command 
	and rax, 15
	shl rax, 4
	
	ret
	
get_green:
	mov rax, [rdi]		;command
	sar ax, 4
	and rax, 15
	shl rax, 4
	
	ret
	
get_blue:
	mov rax, [rdi]		;command
	sar ax, 8
	and rax, 15
	shl rax, 4

	ret