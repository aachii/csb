lhexdump1: hexdump1.o
	ld -o hexdump1 hexdump1.o
hexdump1.o: hexdump1.asm
	nasm -f elf64 -g -F stabs hexdump1.asm
