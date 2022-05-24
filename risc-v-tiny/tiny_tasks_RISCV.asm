# Tomasz Sroka ARKO 22L
# all tiny tasks

.data
text_1A: 	.asciz "Wind On The Hill"
text_1C:	.asciz "tel. 12-34-55"
text_3A:	.asciz "Flip, Flop & Fly"
arrow: 		.asciz "   =>   "
comma:		.ascii ", "
db:		.dword 0x33445566

.text
main:
# show the initial text
	li a7, 4
   	la a0, text_1A
    	ecall
    	
# show arrow
   	la a0, arrow
    	ecall
    	
# call desired function
	la a0, text_1A
	jal replace_1A

# show return value (from a0)
	li a7, 1
	ecall

# show comma
	li a7, 4
   	la a0, comma
    	ecall

# show modified text
   	la a0, text_1A
    	ecall
# exit
	li 	a7,10 # exit
	ecall
	
# ---functions---

# int replace_1A(char *text)
replace_1A:
	li t1,'a'
	li t2,'z'
	li t5, '*'
	mv a1, zero # counter
A_loop_start:
	lb t4, (a0) #load the char at pointer
	beqz t4,A_loop_exit
	blt t4,t1,A_loop_jump
	bgt t4,t2,A_loop_jump
# char is a-z, replace with *
	sb t5, (a0)
	addi a1, a1, 1
A_loop_jump:
	addi a0, a0, 1
	j A_loop_start
A_loop_exit:
# calculate length and store to a0
	mv a0,a1
	ret

# -------------------------- 1B
# int replace_1B(char *text)
replace_1B:
	li t1,'A'
	li t2,'Z'
	li t5, '*'
	mv a1, zero # counter
B_loop_start:
	lb t4, (a0) #load the char at pointer
	beqz t4,B_loop_exit
	blt t4,t1,B_loop_jump
	bgt t4,t2,B_loop_jump
# char is a-z, replace with *
	sb t5, (a0)
	addi a1, a1, 1
B_loop_jump:
	addi a0, a0, 1
	j B_loop_start
B_loop_exit:
# calculate length and store to a0
	mv a0,a1
	ret
	
# -------------------------- 1C
# int replace_1B(char *text)
replace_1C:
	li t1,'0'
	li t2,'9'
	li t5, '*'
	mv a1, zero # counter
C_loop_start:
	lb t4, (a0) #load the char at pointer
	beqz t4,C_loop_exit
	blt t4,t1,C_loop_jump
	bgt t4,t2,C_loop_jump
# char is a-z, replace with *
	sb t5, (a0)
	addi a1, a1, 1
C_loop_jump:
	addi a0, a0, 1
	j C_loop_start
C_loop_exit:
# calculate length and store to a0
	mv a0,a1
	ret
	
# -------------------------- 2A
# int reverse_2A(char *text)
reverse_2A:
# go to the \0 pointer
	mv t1,a0 # will be the second pointer
string_walk_loop:
	lb t2,(t1)
	beqz t2, found_end
	addi t1,t1,1
	j string_walk_loop
found_end:
# store string size
	sub a1, t1,a0
# move end pointer 1 char back (currently its at \0)
	addi t1,t1,-1
swap_pointers_loop:
# while pointers didn't cross, swap values
	bgt a0,t1, swap_pointers_end
	lb t2,(a0)
	lb t3,(t1)
	sb t3,(a0)
	sb t2, (t1)
	addi a0, a0, 1
	addi t1, t1, -1
	j swap_pointers_loop
swap_pointers_end:
	mv a0,a1
	ret 

# -------------------------- 3A
# int remove_lowercase(char *text)
# 1.  if \0 goto end, if not lowercase ignore (goto 4)
# 2. else, find next non-lowercase pointer (linear walk), \0 counts too
# 2a. if copied char was 0, goto end 
# 3. copy that value to current pointer
# 4. increase pointer
# 5. goto 1
remove_lowercase_3A:
	mv a1,a0
	li t1,'a'
	li t2,'z'
	
remove_loop:
	lb t0, (a0)
	beqz t0, remove_lowercase_end
# a-z check
	blt t0,t1,goto_next_char
	bgt t0,t2,goto_next_char
# lowercase char, now find something to replace it with
	addi t3, a0, 1 # skips 1 iteration
find_loop_start:
	lb t4,(t3)
# a-z check
	blt t4,t1,find_loop_break
	bgt t4,t2,find_loop_break
# this is still lowercase, increase t3 pointer and try again
	addi t3,t3,1
	j find_loop_start
find_loop_break:
# copy to a0, but also overwrite t3 with something not to copy it again
	sb t4, (a0)
	sb t1, (t3)
# was this end of string? end if yes
	beqz t4, remove_lowercase_end
goto_next_char:
	addi a0,a0,1
	j remove_loop
	
remove_lowercase_end:
# get length
	sub a0, a0,a1
	ret	
