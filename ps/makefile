all: ps

clean:
	rm -f *.o *~ ps *.out *.txt

ps: ps.c
	gcc ps.c -g -Wall -F dwarf -o ps
