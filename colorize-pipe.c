/*
* Color example #2 marnold
*/
#include <stdio.h>
#include <signal.h>
#include <unistd.h>
#include <stdlib.h>

#define BUFFSIZE 64
void sigproc();
void sigcnt();
int
main(int argc, char *argv[])
{

        char buf[BUFFSIZE];
	char* pbuf;
	pbuf = getenv("PIPE_COLOR");
	if (pbuf != NULL) {
		
		printf("%s%s\n", "\x1b[", pbuf);
	}
	else {
		fprintf(stderr, "%s\n", 
			"Must set ansi code in PIPE_COLOR");
		exit(1);
	}

        char c;
	signal(SIGINT, sigproc);
	signal(SIGQUIT, sigproc);
	signal(SIGCONT, sigcnt);
        while ((c = getchar()) != EOF) {
                putchar(c);
        }
        puts("\x1b[0m");
}


void 
sigproc()
{
	puts("\x1b[0m");
	exit(0);
}
void 
sigcnt()
{
	 char *pbuf = getenv("PIPE_COLOR");
	 if (pbuf != NULL) {
                printf("%s%s\n" "\x1b[", pbuf);
         }
         else {
                fprintf(stderr, "%s\n", 
                        "Must set ansi code in PIPE_COLOR");
                exit(1);
         }

	 return;
}
