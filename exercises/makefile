all: eatsyscall64 test uppercase upp2 exponent

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

uppercase: uppercase.o
	ld -o uppercase uppercase.o
uppercase.o: uppercase.asm
	nasm -f elf64 -g -F dwarf uppercase.asm

upp2: upp2.o
	ld -o upp2 upp2.o
upp2.o: upp2.asm
	nasm -f elf64 -g -F dwarf upp2.asm

exponent: exponent.o
	ld -o exponent exponent.o
exponent.o: exponent.asm
	nasm -f elf64 -g -F dwarf exponent.asm

