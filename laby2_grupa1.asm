# przefiltruj string tak, aby z każdej grupy cyfr została tylko pierwsza z nich, k29jasi12j2kls90 -> k2jasi1j2kls9
        .eqv    SysExit, 10
        .eqv    PrintString, 4
        .eqv    ReadString, 8
        .eqv    BUFSIZE, 100
        
        .data
buf:    .space  BUFSIZE

        .text
main:
        la      a0, buf
        li      a1, BUFSIZE
        li      a7, ReadString
        ecall
        
        la      t0, buf         # current read pointer
        la      t1, buf         # current write pointer
        li      t6, 1           # 0 if the last char was a number
process_char:
        lbu     t2, (t0)
        beqz    t2, finish
        
        addi    t0, t0, 1
        
        li      t3, '0'
        bltu    t2, t3, not_a_number
        li      t3, '9'
        bgtu    t2, t3, not_a_number
        
        beqz    t6, process_char
        
        li      t6, 0
        j       next_char
not_a_number:
        li      t6, 1
next_char:
        sb      t2, (t1)
        addi    t1, t1, 1
        j       process_char
        
finish:
        sb      zero, (t1)

        la      a0, buf
        li      a7, PrintString
        ecall

        li      a7, SysExit
        ecall
