CC=gcc
ASMBIN=nasm

all : asm cc link clean
asm : 
	$(ASMBIN) -o turtle2.o -f elf32 -g -l turtle2.lst turtle2.asm
cc :
	$(CC) -m32 -c -g -std=c99 -O0 main.c &> errors.txt
link :
	$(CC) -m32 -g -o turtle2 main.o turtle2.o
clean :
	rm *.o
	rm turtle2.lst
