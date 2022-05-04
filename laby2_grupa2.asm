# zdekoduj ostatnią liczbę w systemie dwunastkowym znajdującej się w stringu.
# liczba będzie zaczynac sie od cyfdry dziesietnej (z zero wlacznie) a potem moze miec wszystkie cyfry oraz 'a' o wartosci 10 i 'b' o wartosci 11
        .eqv    SysExit, 10
        .eqv    PrintInt, 1
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
        li      t1, 0           # result number
process_char:
        lbu     t2, (t0)
        beqz    t2, finish
        
        li      t3, '0'
        bltu    t2, t3, not_a_number
        li      t3, '9'
        bgtu    t2, t3, not_a_number
        
        addi    t1, t2, -48             # -'0'
        addi    t0, t0, 1
process_number:
        lbu     t2, (t0)
        beqz    t2, finish
        
        li      t3, 'a'
        beq     t2, t3, number_char
        li      t3, 'b'
        beq     t2, t3, number_char

        li      t3, '0'
        bltu    t2, t3, not_a_number
        li      t3, '9'
        bgtu    t2, t3, not_a_number
        
        j       add_number

number_char:
        addi    t2, t2, -39             # '0'-'a'+10
add_number:
        addi    t2, t2, -48             # -'0'
        
        li      t3, 1           # mulitply by 3
        sll     t4, t1, t3
        add     t1, t1, t4
        
        li      t3, 2           # multiply by 4
        sll     t1, t1, t3
        
        add     t1, t1, t2      # add current number 

        addi    t0, t0, 1
        j       process_number

not_a_number:
        addi    t0, t0, 1
        j       process_char

finish:
        mv      a0, t1
        li      a7, PrintInt
        ecall

        li      a7, SysExit
        ecall
