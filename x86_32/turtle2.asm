;-------------------------------------------------------------------------------
; author: Jakub Kieruczenko
; date : 2022.06.11
; description : Turtle graphics version 2.
;-------------------------------------------------------------------------------
;	memory usage:
;	because of shortage of registers, I decided to allocate memory for:
;	ebp-4 - red (byte)
;	epb-6 - green (byte)
;	ebp-5 - blue (byte)
;	ebp-7 - direction (byte)
;	ebp-8 - pen state (byte)
;	ebp-9 - x coordinate (word)
;	ebp-11 - y coordinate (byte)


section	.text
global turtle2

turtle2:
;prologue
	push ebp
	mov	ebp, esp
	sub esp, 8 

;procedure
	mov	esi, [ebp+8]		;instructions pointer
	mov eax, [ebp+12]		;imgInfo pointer
	mov edi, [ebp+16]		;length of instructions in bytes
	
	add edi, esi
	
read_loop:
	cmp	esi, edi			
	je	load_args			;all commands have been read
	mov bx, [esi]
	mov cx, bx
	shr bx, 14				;get the command code

	test bx, bx 
	jmp set_position		
	
	dec bx
	test bx, bx
	jmp set_direction
	
	dec bx
	jmp move_args
	test bx, bx
	

set_pen_state:
	mov bx, cx
	sar bx, 13
	and	bx, 1
	mov BYTE[ebp-8], bl		;save pen state
	
	mov bx, cx
	sar bx, 8
	and	bx, 15
	shl bx, 4
	mov BYTE[ebp-5], bl		;save processed blue value
	
	mov bx, cx
	sar bx, 4
	and	bx, 15
	shl bx, 4
	mov BYTE[ebp-6], bl		;save processed green value
	
	and	cx, 15
	shl cx, 4
	mov BYTE[ebp-4], cl		;save processed red value
	
	add esi, 2
	jmp read_loop

set_position:
	add	esi, 2
	mov cx, [esi]
	mov bx, cx
	and bx, 1023
	mov WORD[ebp-9], bx		;save x value
	sar cx, 10
	and cx, 63
	mov BYTE[ebp-11], cl	;save y value
	
	add esi, 2
	jmp read_loop
	
	
set_direction:
	and cx, 3
	mov BYTE[ebp-7], cl		;save direction value
	add esi, 2
	jmp read_loop

move_args:
	and cx, 1023
	add esi, 2
	
	inc cx
	
move:
	dec cx
	test cx, cx
	jz read_loop
	mov bl, BYTE[ebp-8] 
	test bl, bl
	jz move_skip

set_pixel:
	mov eax, DWORD[ebp+12] 
	mov eax, DWORD[eax+8]		;linebytes
	mov bl, BYTE[ebp-11]
	and ebx, 255
	mul ebx			;eax -> t1
	mov bx, WORD[ebp-9]
	and ebx, 0xFFFF
	lea ebx, [2*ebx+ebx] ;ebx*=3 ebx -> t0
	add ebx, eax		 ;ebx - offset of pixel
	mov eax, DWORD[ebp+12]
	mov eax, DWORD[eax+12]		;image data
	add ebx, eax				;address of pixel
	
	mov cl, BYTE[ebp-5]
	mov BYTE[ebx], cl
	mov cl, BYTE[ebp-6]
	mov BYTE[ebx+1], cl
	mov cl, BYTE[ebp-4]
	mov BYTE[ebx+2], cl

move_skip:
	mov bl, BYTE[ebp-7]
	test bl, bl
	jz go_right
	
	dec bl
	test bl, bl
	jz go_up
	
	dec bl
	test bl, bl
	jz go_left
	
go_down:
	mov bl, BYTE[ebp-11]
	dec bl
	cmp bl, 0
	mov BYTE[ebp-11], bl
	jg move
	mov BYTE[ebp-11], 0
	jmp read_loop
	
go_up:
	mov bl, BYTE[ebp-11]
	inc bl
	cmp bl, 64
	mov BYTE[ebp-11], bl
	jl move
	mov BYTE[ebp-11], 63
	jmp read_loop
	
go_right:
	mov bx, WORD[ebp-9]
	inc bx
	cmp bx, 768
	mov WORD[ebp-9], bx
	jl move
	mov WORD[ebp-9], 767
	jmp read_loop
	
go_left:
	mov bx, WORD[ebp-9]
	dec bx
	cmp bx, 0
	mov WORD[ebp-9], bx
	jg move
	mov WORD[ebp-9], 0
	jmp read_loop
	
load_args:
	mov eax, [ebp+12]
exit:
;epilogue
	mov esp, ebp
	pop ebp
	ret

