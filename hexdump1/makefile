all: hexdump1

clean:
	rm *.o

io.o: io.asm
	nasm -f elf64 -g -F dwarf io.asm

hexdump1: hexdump1.o io.o
	ld -o hexdump1 io.o hexdump1.o
hexdump1.o: hexdump1.asm
	nasm -f elf64 -g -F dwarf hexdump1.asm
