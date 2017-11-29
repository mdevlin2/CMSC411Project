all: cordic

cordic: cordic.c
	gcc -std=c99 -lm -c cordic.c
	gcc -lm cordic.o -o run.out

run:
	./run.out

clean:
	rm run.out
	rm cordic.o
