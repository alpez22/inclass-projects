///////////////////////////////////////////////////////////////////////////////
// Copyright 2020 Jim Skrentny
// Posting or sharing this file is prohibited, including any changes/additions.
// Used by permission, CS 354 Spring 2022, Deb Deppeler
////////////////////////////////////////////////////////////////////////////////
// Main File:        myMagicSquare.c
// This File:        myMagicSquare
// Other Files:      none
// Semester:         CS 354 Spring 2023
// Instructor:       Deppler
//
// Author:           Ava Pezza
// Email:            apezza@wisc.edu
// CS Login:         pezza
// GG#:              GG2
//
/////////////////////////// OTHER SOURCES OF HELP //////////////////////////////
// Persons:          n/a
//
// Online sources:   n/a
////////////////////////////////////////////////////////////////////////////////   

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Structure that represents a magic square
typedef struct {
	int size;           // dimension of the square
	int **magic_square; // pointer to heap allocated magic square
} MagicSquare;

/* TODO:
 * Prompts the user for the magic square's size, reads it,
 * checks if it's an odd number >= 3 (if not display the required
 * error message and exit), and returns the valid number.
 */
int getSize() {
	//ask user to type a number
	printf("Enter magic square's size (odd integer >=3) \n");
	//get and save the number in size
	int s;
	scanf("%i", &s);
	//check if input size has correct parameters
	if(s < 2){//check if input size is less than 2
		printf("Magic square size must be >= 3.\n");
		exit(1);
	}else if(s % 2 == 0){//check if input size is even
		printf("Magic square size must be odd.\n");
		exit(1);
	}else{//input is >=3 and is odd
		return s;
	}
} 

/* TODO:
 * Makes a magic square of size n using the 
 * Siamese magic square algorithm or alternate from assignment 
 * or another valid alorithm that produces a magic square.
 *
 * n is the number of rows and columns
 *
 * returns a pointer to the completed MagicSquare struct.
 */
MagicSquare *generateMagicSquare(int n) {

	MagicSquare * square = malloc(sizeof(MagicSquare));
	if(square == 0){
		printf("Return value for malloc allocation was false");
		exit(1);
	}
	square -> size = n;
	square -> magic_square = malloc(n*sizeof(int*));
	if(square->magic_square == 0){
		printf("Return value for malloc allocation was false");
		exit(1);
	}
	for(int i = 0; i < n; i++){
		*(square -> magic_square + i) = malloc(sizeof(int)*n);
		if(*(square -> magic_square + i) == 0){
			printf("Return value for malloc allocation was false");
			exit(1);
		}	
		for(int j = 0; j < n; j++){
			*(*(square -> magic_square + i) + j) = 0;
		}
	}
	
	int sizeSqrd = n*n;
	int row=n/2;
	int col= n-1;
	int **s = square -> magic_square;
	for(int i = 1; i <sizeSqrd + 1; i++){
		//assign i to current loc
		*(*(s + row) + col) = i;
		//row and column update
		row++;
		col++;
		row %= n;
		col %= n;
		//values cannot overlap
		if(*(*(s + row) + col) != 0){
			row += n-1;
			col += n-2;
			col %= n;
			row %= n;
		}
	}
	return square;    
} 

/* TODO:  
 * Opens a new file (or overwrites the existing file)
 * and writes the square in the specified format.
 *
 * magic_square the magic square to write to a file
 * filename the name of the output file
 */
void fileOutputMagicSquare(MagicSquare *magic_square, char *filename) {
	FILE * ofp = fopen(filename, "w");
	if(ofp == NULL){
		fprintf(stderr, "Can;t open output file %s!\n", filename);
		exit(1);
	}
	fprintf(ofp, "%i\n", magic_square->size);
	for(int i = 0; i < magic_square->size ; i++){
		for(int j = 0; j < magic_square->size; j++){
			if(j >= magic_square->size-1){
				fprintf(ofp, "%i\n", *(*(magic_square->magic_square + i)+j));
			}else{
				fprintf(ofp, "%i,", *(*(magic_square->magic_square + i)+ j));
			}
		}
	}
	fclose(ofp);
}


/* TODO:
 * Generates a magic square of the user specified size and
 * outputs the square to the output filename.
 * 
 * Add description of required CLAs here
 */
int main(int argc, char **argv) {
	// TODO: Check input arguments to get output filename
	if(argc != 2){
		printf("Incorrect number of args");
		exit(1);
	}
	// TODO: Get magic square's size from user
	int s = getSize();
	// TODO: Generate the magic square by correctly interpreting 
	//       the algorithm(s) in the write-up or by writing or your own.  
	//       You must confirm that your program produces a 
	//       Magic Sqare as described in the linked Wikipedia page.
	MagicSquare * magic = generateMagicSquare(s);
	// TODO: Output the magic square
	fileOutputMagicSquare(magic, *(argv+1));
	
	//free mem
	free(magic->magic_square);
	free(magic);
	return 0;
} 

// S23

