all: hexdump1 io

io: io.o
	ld -o io io.o
io.o: io.asm
	nasm -f elf64 -g -F stabs io.asm

hexdump1: hexdump1.o
	ld -o hexdump1 io.o hexdump1.o
hexdump1.o: hexdump1.asm
	nasm -f elf64 -g -F stabs hexdump1.asm
