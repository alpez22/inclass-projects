////////////////////////////////////////////////////////////////////////////////
// Main File:        mySigHandler.c
// This File:        mySigHandler.c
// Other Files:      sendsig.c, division.c
// Semester:         CS 354 Lecture 02 Spring 2023
// Instructor:       deppeler
// 
// Author:           Ava Pezza
// Email:            apezza@wisc.edu
// CS Login:         pezza
//
/////////////////////////// OTHER SOURCES OF HELP //////////////////////////////
//
// Persons: N/A
//
// Online sources: N/A
//
//////////////////////////// 80 columns wide ///////////////////////////////////
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <time.h>
#include <signal.h>
//GLOBAL VARS
int seconds = 4;//number of seconds to wait for alarm
int count = 0;//count of USR ALARM 1
/*
 * The kernel triggers a SIGALARM after the alarm goes off in the main function.
 * This alarm handler function, handler_SIGALRM, gets and prints the pid 
 * (process id) of the program and the current time (in the same format as 
 * the Linux date command). This function also re-arms or restarts a new alarm
 * to go off again 4 seconds later, and then return back to the main 
 * function, which continues its infinite loop.
*/
void handler_SIGALRM(){
	//code to execute when alarm occurs
	time_t curr_time;
	char* tstr;
	time(&curr_time);
	tstr = ctime(&curr_time);
	
	printf("PID: %ld CURRENT TIME: %s",(long)getpid(),tstr);	
	alarm(seconds);
}
/*
 * Whenever the SIGUSR1 signal is triggered, this function handles
 * the trigger and prints that it was handled and the global variable
 * of the count of SIGUSR1 variable increases with each trigger.
*/
void handler_SIGUSR1(){
	printf("SIGUSR1 handled and counted!\n");
	count++;
}
/*
 * This handler function of the SIGINT signal changes the default 
 * behavior of when Cntr-C is typed (interrupt signal sent). 
 * After the SIGINT is handled the count of USR1 is printed and
 * the function exits.
*/
void handler_SIGINT(){
	printf("\nSIGINT handled.");
	printf("\nSIGUSR1 was handled %i times. Exiting now.\n", count);
	exit(0);
}
/*
 * This main function sets an alarm and registers signal handlers
 * to handle the different signal triggers. 
*/
int main(void){
	//set an alarm that will go off 4 seconds later
	//should cause kernel to trigger a SIGALRM
	alarm(seconds);

	//registers a signal handler to handle the SIGALRM
	//do something other than default behavior
	struct sigaction sa;
	memset (&sa, 0, sizeof(sa));
	sa.sa_flags =  0;
	sa.sa_handler = handler_SIGALRM;
	if(sigaction(SIGALRM, &sa, NULL) != 0){
		printf("failed to bind handler.\n");
		exit(1);
	}

	printf("PID and time print every 4 seconds\n");
	printf("Type Ctrl-C to end the program\n");	

	//USER defined signals
	struct sigaction sa2;
	memset (&sa2, 0, sizeof(sa2));
	sa2.sa_flags = 0;
	sa2.sa_handler = handler_SIGUSR1;
	if(sigaction(SIGUSR1, &sa2, NULL) != 0){
		printf("failed to bind handler.\n");
		exit(1);
	}

	//Handling Ctrl-C and interrupt signal
	struct sigaction sa3;
	memset (&sa3, 0, sizeof(sa3));
	sa3.sa_flags = 0;
	sa3.sa_handler = handler_SIGINT;
	if(sigaction(SIGINT, &sa3, NULL) != 0){
		printf("failed to bind handler.\n");
		exit(1);
	}

	//infinite while loop
	while(1);
}

