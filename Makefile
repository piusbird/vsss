CC=gcc
all:
	$(CC) -o pcg colorize-pipe.c -lm
clean:
	rm -f pcg
