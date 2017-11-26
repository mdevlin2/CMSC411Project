all: cordic

cordic: cordic.c
	gcc -std=c99 cordic.c

cordic.o: cordic.o
	gcc cordic.o

run:
	./a.out

clean:
	rm a.out
