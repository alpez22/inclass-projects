////////////////////////////////////////////////////////////////////////////////
// Main File:        division.c
// This File:        division.c
// Other Files:      sendsig.c, mySigHandler.c
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

//GLOBAL VARS
int BUFFER_SIZE = 100;//buffer size
int cnt = 0;//count of operations completed
/*
 * If the user attempts to divide any number by 0 a SIGFPE signal
 * will be triggered and this function handles this signal call.
 * The count of the successful operations will be print and the 
 * program will exit savely with exit(0)
*/
void handler_SIGFPE(){
	printf("Error: a division by 0 operation was attempted.\n");
	printf("Total number of operations completed successfully: %i\n", cnt);
	printf("The program will be terminated.\n");
	exit(0);
}
/*
 * If a SIGINT signal goes off by sending a Cntrl-C interrupt, this function
 * handles that signal call. The count of successful operations will print
 * and the program will safely exit, exit(0)
*/
void handler_SIGINT(){
    printf("\nTotal number of operations completed successfully: %i\n", cnt);
	printf("The program will be terminated.\n"); 
	exit(0);
}
/*
 * this main function promps the user to enter 2 integers to divide by.
 * if a divide by zero is attempted a sig handler is created to handle
 * the trigger. the quotient and remainder will be printed.
*/
int main(){
	char buffer[BUFFER_SIZE];
	int int1;
	int int2;
	int quotient;
	int remainder;
	
	//sig handler for divide by zero
	struct sigaction zero;
    memset (&zero, 0, sizeof(zero));
    zero.sa_flags = 0;
    zero.sa_handler = handler_SIGFPE;
    if(sigaction(SIGFPE, &zero, NULL) != 0){
		printf("failed to bind handler.\n");
        exit(1);
     }
	
	//sig handler for cntr c
	struct sigaction sa4;
    memset (&sa4, 0, sizeof(sa4));
    sa4.sa_flags = 0;
    sa4.sa_handler = handler_SIGINT;
    if(sigaction(SIGINT, &sa4, NULL) != 0){
        printf("failed to bind handler.\n");
        exit(1);
    }	

	while(1){
		printf("Enter first integer: ");
		fgets(buffer, BUFFER_SIZE, stdin);
		int1 = atoi(buffer);

		printf("Enter second integer: ");
		fgets(buffer, BUFFER_SIZE, stdin);
		int2 = atoi(buffer);

		quotient = int1 / int2;
		remainder = int1 % int2;
		printf("%i / %i is %i with a remainder of %i\n", int1, int2, quotient, remainder);
		cnt++;
	}
}
