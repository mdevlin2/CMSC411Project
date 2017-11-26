all: cordic

cordic: cordic.c
	gcc -std=c99 -g cordic.c

cordic.o: cordic.o
	gcc -g cordic.o

run:
	./a.out

clean:
	rm a.out
