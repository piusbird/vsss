/*
* This Was Oringanlly called colorize-pipe
* Now it's called the BCUOF
* Big Clucking Ugly Output Filter
* This formats the on screen display 
* for my speech synthizer 
* Which is a piece of code that has evolved by natural selection
* Over the past 15 years
* I should modernize this crud but i proably won't
* So if you want to use this i accept pull requests 
*
*/

#include <stdio.h>
#include <signal.h>
#include <unistd.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include <stdbool.h>
#define BUFFSIZE 256
void sigproc();
void sigcnt();
void sigstop();
char *easc = "\x1b[";

int main(int argc, char *argv[])
{

	bool tsn = true;
	int lc = 1;
	char *timefmt = "[%H:%M:%S]";
	char timebuf[BUFFSIZE];
	char *pbuf;
	pbuf = getenv("PIPE_COLOR");
	if (pbuf != NULL) {
		printf("%s%s\n", easc, pbuf);
	} else {
		fprintf(stderr, "%s\n", "Must set ansi code in PIPE_COLOR");
		exit(1);
	}

	signal(SIGINT, sigproc);
	signal(SIGQUIT, sigproc);
	signal(SIGCONT, sigcnt);
	signal(SIGSTOP, sigstop);

	char c;
	time_t start = time(NULL);
	while ((c = getchar()) != EOF) {
		if (tsn) {
			time_t ts = time(NULL);
			strftime(timebuf, sizeof timebuf, timefmt,
				 localtime(&ts));
			printf("%s: ", timebuf);
			tsn = false;
		} 
		putchar(c);
		if (c == '\n') {
			lc++;
		}
		tsn = (c == '\n' && lc % 2 == 0) ? true : false;
	}
	time_t end = time(NULL);
	double secelp = difftime(end, start);
	double minselp = secelp / 60.0;
	double roundlp = fmod(secelp, 60.0);
	int mins = (int) minselp;
	int secs = (int) roundlp;
	printf("Elasped Time %d:%02d \n", mins, secs);
	puts("\x1b[0m");
	return 0;
}

void sigproc()
{
	puts("\x1b[0m");
	exit(0);
}

void sigstop()
{
	puts("\x1b[0m");
}

void sigcnt()
{
	char *pbuf = getenv("PIPE_COLOR");
	if (pbuf != NULL) {
		printf("%s%s\n", easc, pbuf);
	} else {
		fprintf(stderr, "%s\n", "Must set ansi code in PIPE_COLOR");
		exit(1);
	}

	return;
}
