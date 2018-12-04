all: base32enc base32dec

clean:
	rm *.o *.out *.want *.delta b32*

base32enc.o: base32enc.asm
	nasm -f elf64 -g -F dwarf base32enc.asm

base32enc: base32enc.o
	ld -o base32enc base32enc.o

base32dec.o: base32dec.asm
	nasm -f elf64 -g -F dwarf base32dec.asm

base32dec: base32dec.o
	ld -o base32dec base32dec.o
