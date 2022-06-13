;-------------------------------------------------------------------------------
; author: Jakub Kieruczenko
; date : 2022.06.11
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
	push ebp
	mov	ebp, esp
	push esi
	push edi
 
	mov esi, [ebp + 8]		;colors
	mov edi, [ebp + 12]		;bmp

	cld
	mov ecx, 3
	repnz movsb

	pop edi
	pop esi
	mov esp, ebp
	pop ebp
	ret

read_command:
	push ebp
	mov	ebp, esp

	mov eax, [ebp+8]	;command address
	mov ax, WORD[eax]	;command	
	shr ax, 14			;get the command code
	and eax, 3

	mov esp, ebp
	pop ebp
	ret

get_x:
	push ebp
	mov	ebp, esp
	
	mov eax, [ebp+8]	;command address
	mov ax, WORD[eax]	;command
	and eax, 1023		;x is in 10 least significant bits
	
	mov esp, ebp
	pop ebp
	ret
get_y:
	push ebp
	mov	ebp, esp
	
	mov eax, [ebp+8]	;command address
	mov ax, WORD[eax]	;command
	sar ax, 10
	and eax, 63			;y is now in 6 LSbits
	
	mov esp, ebp
	pop ebp
	ret
	
get_pen_state:
	push ebp
	mov	ebp, esp
	
	mov eax, [ebp+8]	;command address
	mov ax, WORD[eax]	;command
	sar ax, 13
	and eax, 1			;pen state (ud) is now the LSB	
	
	mov esp, ebp
	pop ebp
	ret
	
get_distance:
	push ebp
	mov	ebp, esp
	
	mov eax, [ebp+8]	;command address
	mov ax, WORD[eax]	;command
	and eax, 1023		;distance is in 10 LSbits
	
	mov esp, ebp
	pop ebp
	ret
	
get_direction:
	push ebp
	mov	ebp, esp
	
	mov eax, [ebp+8]	;command address
	mov ax, WORD[eax]	;command
	and eax, 3			;direction is in 3 LSbits
	
	mov esp, ebp
	pop ebp
	ret
	
get_red:
	push ebp
	mov	ebp, esp
	
	mov eax, [ebp+8]	;command address
	mov ax, WORD[eax]	;command
	and eax, 15
	shl eax, 4
	
	mov esp, ebp
	pop ebp
	ret
	
get_green:
	push ebp
	mov	ebp, esp
	
	mov eax, [ebp+8]	;command address
	mov ax, WORD[eax]	;command
	sar ax, 4
	and eax, 15
	shl eax, 4
	
	mov esp, ebp
	pop ebp
	ret
	
get_blue:
	push ebp
	mov	ebp, esp
	
	mov eax, [ebp+8]	;command address
	mov ax, WORD[eax]	;command
	sar ax, 8
	and eax, 15
	shl eax, 4
	
	mov esp, ebp
	pop ebp
	ret
