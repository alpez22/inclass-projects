////////////////////////////////////////////////////////////////////////////////
// Main File:        mySigHandler.c
// This File:        sendsig.c
// Other Files:      mySigHandler.c, division.c
// Semester:         CS 354 Lecture 02 Spring 2023
// Instructor:       deppeler
// 
// Author:           Ava Pezza
// Email:            apezza@wisc.edu
// CS Login:         pezza
//
/////////////////////////// OTHER SOURCES OF HELP //////////////////////////////
//
// Persons:          N/A
//
// Online sources:   N/A
//
//////////////////////////// 80 columns wide ///////////////////////////////////
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>
/*
 * this main function is used to send signals (SIGINT and SIGUSR1) to other programs.
 * You can send signals to other programs by using their pid. For this program,
 *  the system call kill() is used. It accepts 2 command line args.
*/
int main(int argc, char *argv[]){
	if(argc != 3){
		printf("Usage: sendsig <signal type> <pid>\n");
		exit(1);	
	}

	int pid = atoi(argv[2]);
	if(strcmp(argv[1], "-u") == 0){
		if(kill(pid, SIGUSR1) == 0){
			//should kill
		}else{
			printf("Error kill -u did not work");
			exit(1);
		}
	}else if(strcmp(argv[1], "-i") == 0){
		if(kill(pid, SIGINT) == 0){
			//should kill
		}else{
			printf("Error kill -i did not work");
			exit(1);
		}
	}else{
		printf("invalid sig type OR invalid pid");
	}
}
