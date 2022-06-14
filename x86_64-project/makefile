CC=gcc
ASMBIN=nasm

all : asm cc link clean
asm : 
	$(ASMBIN) -o turtle2.o -f elf64 -g turtle2.asm
cc :
	$(CC) -c -g -std=c99 -O0 main.c &> errors.txt
link :
	$(CC) -g -o turtle2 main.o turtle2.o
clean :
	rm *.o
