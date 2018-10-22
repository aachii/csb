all: eatsyscall64 test

clean:
	rm *.o

eatsyscall64: eatsyscall64.o
	ld -o eatsyscall64 eatsyscall64.o
eatsyscall64.o: eatsyscall64.asm
	nasm -f elf64 -g -F dwarf eatsyscall64.asm

test: test.o
	ld -o test test.o
test.o: test.asm
	nasm -f elf64 -g -F dwarf test.asm

