#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <stdlib.h>
#include <ctype.h>

typedef struct word{
  char * contents;
  long numChars;
  long frequency;
  long orderAppeared;
  struct word * nextWord;
  struct word * prevWord;
} WORD;

typedef struct line{
  char * contents;
  long numWords;
  long frequency;
  long orderAppeared;
  struct line * nextLine;
  struct line * prevLine;
} LINE;

typedef struct LongestWord {
    char * contents;
    struct LongestWord * nextLW;
    struct LongestWord * prevLW;
} LONGESTWORD;

typedef struct LongestLine {
    char * contents;
    struct LongestLine * nextLL;
    struct LongestLine * prevLL;
} LONGESTLINE;

int countChars(const char * inputFileName){
    FILE * file = fopen(inputFileName, "r");
    if(file == NULL){
        printf("ERROR: Can't open input file\n");
        exit(1);
    }

    fseek(file, 0, SEEK_END);
    long checkEmpty = ftell(file);
    fseek(file, 0, SEEK_SET); //move pointer back to beginning
    if(checkEmpty == 0){
        fclose(file);
        printf("ERROR: Input File Empty\n");
        exit(1);
    }

    return checkEmpty;
}
int charAnalysis(const char * inputFileName, const char * outputFileName, bool last_flag, bool o_flag_specified){
    long totalCount = countChars(inputFileName);

    FILE * file = fopen(inputFileName, "r");
    long position = 0;
    long uniqueCount = 0;
    long array[128][2] = {0}; // [ascii chars][0=frequency][1=initial position]
    if(file == NULL){
        printf("ERROR: Can't open input file\n");
        exit(1);
    }

    while(true){
        char ch = fgetc(file);
        if(feof(file)){
            break;
        }
        if(ch >= 0 && ch <= 127){ //check if valid ascii char
            if(array[(unsigned char)ch][0] == 0){//this is the initial position
                array[(unsigned char)ch][1] = position;
                uniqueCount++;
            }
            array[(unsigned char)ch][0]++; //increase frequency
        }else{
            printf("ERROR: Detecting Ascii Character <ascii number detected> at postion <zero based character position>\n");
            exit(1);
        }
        position++;
    }
    fclose(file);
    
    //write to file
    if(o_flag_specified){
        FILE * file2 = fopen(outputFileName, "a");
        if (file2 == NULL) {
            exit(1);
        }
        fprintf(file2, "Total Number of Chars = %ld\n", totalCount);
        fprintf(file2, "Total Unique Chars = %ld\n", uniqueCount);
        fputs("\n", file2);
        for(int i = 0; i < 128; i++){
            if(array[i][0] > 0){//if frequency is greater than 0
                fprintf(file2,  "Ascii Value: %d, Char: %c, Count: %ld, Initial Position: %ld\n", i, i, array[i][0], array[i][1]);
            }
        }
        if(!last_flag){
            fputs("\n", file2);
        }
        fclose(file2);
    }else{//print to stdout

        FILE * file2 = fopen("tempOutputFile.txt", "a");
        if (file2 == NULL) {
            exit(1);
        }
        fprintf(file2, "Total Number of Chars = %ld\n", totalCount);
        fprintf(file2, "Total Unique Chars = %ld\n", uniqueCount);
        fputs("\n", file2);
        for(int i = 0; i < 128; i++){
            if(array[i][0] > 0){//if frequency is greater than 0
                fprintf(file2,  "Ascii Value: %d, Char: %c, Count: %ld, Initial Position: %ld\n", i, i, array[i][0], array[i][1]);
            }
        }
        if(!last_flag){
            fputs("\n", file2);
        }
        fclose(file2);
    }
    

    return 0;//success
}

int calculateUniqueFreqWord(WORD * root){
    WORD * curr = root;
    long uniqueFreqTotal = 0;
    while(curr != NULL){
        if(curr->frequency >= 1){
            uniqueFreqTotal++;
        }
        curr = curr->nextWord;
    }
    return uniqueFreqTotal;
}
int countWords(const char * inputFileName){
    FILE * file = fopen(inputFileName, "r");
    long count = 0;
    bool isWord = false;
    if(file == NULL){
        printf("ERROR: Can't open input file\n");
        exit(1);
    }

    fseek(file, 0, SEEK_END);
    long checkEmpty = ftell(file);
    fseek(file, 0, SEEK_SET); //move pointer back to beginning
    if(checkEmpty == 0){
        fclose(file);
        printf("ERROR: Input File Empty\n");
        exit(1);
    }

    while(true){
        char ch = fgetc(file);
        if(feof(file)){
            break;
        }
        if(isspace(ch)){
            isWord = false;
        }else if(isWord == false){ //so it only counts the words and not each letter
            isWord = true;
            count++;
        }
    }
    fclose(file);
    return count;
}
void orderWords(WORD **root, WORD *thisWord){
    if(*root == NULL || strcmp((*root)->contents, thisWord->contents) > 0){ //if first insertion OR root should be after this word, make this word the root
        thisWord->nextWord = *root;
        if (*root != NULL) {
            (*root)->prevWord = thisWord;
        }
        *root = thisWord;
    }else{//if not first, then find where
        WORD * currWord = *root;
        while(currWord->nextWord != NULL && strcmp(currWord->nextWord->contents, thisWord->contents) < 0){ //while there are more words in the list OR word after currWord should be sooner than thisWord
            currWord = currWord->nextWord; //move to next word
        }
        //now thisWord after currWord
        thisWord->nextWord = currWord->nextWord;
        if (currWord->nextWord != NULL) {
            currWord->nextWord->prevWord = thisWord;
        }
        currWord->nextWord = thisWord;
        thisWord->prevWord = currWord;
    }
}
WORD * wordProcess(WORD **root, const char * Buffer, long orderAppeared){
    WORD * curr = *root;
    while(curr != NULL){
        if (strcmp(curr->contents, Buffer) == 0) {
            //word found
            curr->frequency++;
            return curr;
        }
        curr = curr->nextWord;
    }
    //word not found
    WORD * currWord = (WORD *)malloc(sizeof(WORD));
    if (currWord == NULL) {
        perror("Failed to allocate memory for new word");
        exit(1);
    }

    //set up word
    currWord->contents = strdup(Buffer);
    currWord->numChars = strlen(Buffer);
    currWord->frequency = 1;
    currWord->orderAppeared = orderAppeared;
    currWord->nextWord = NULL;
    currWord->prevWord = NULL;

    orderWords(root, currWord);

    return currWord;
}
int wordAnalysis(const char * inputFileName, const char * outputFileName, bool last_flag, bool o_flag_specified){
    long totalWords = countWords(inputFileName);

    FILE * file = fopen(inputFileName, "r");
    if(file == NULL){
        printf("ERROR: Can't open input file\n");
        exit(1);
    }

    char buffer[256];
    WORD * root = NULL;
    long orderAppeared = 0;

    while(fscanf(file, "%255s", buffer) == 1){//while it reads just 1 word
        wordProcess(&root, buffer, orderAppeared);
        orderAppeared++;
    }

    fclose(file);
    long totalUnique = calculateUniqueFreqWord(root);

    //write to file
    FILE * file2;
    if(o_flag_specified){
        file2 = fopen(outputFileName, "a");
    }else{
        file2 = fopen("tempOutputFile.txt", "a");
    }
    if (file2 == NULL) {
        exit(1);
    }
    fprintf(file2, "Total Number of Words: %ld\n", totalWords);
    fprintf(file2, "Total Unique Words: %ld\n", totalUnique);
    fputs("\n", file2);
    WORD *current = root;
    while(current != NULL){
        fprintf(file2, "Word: %s, Freq: %ld, Initial Position: %ld\n", current->contents, current->frequency, current->orderAppeared);
        current = current->nextWord;
    }
    if(!last_flag){
        fputs("\n", file2);
    }
    fclose(file2);

    while (root != NULL) {
        WORD * freeRoot = root;
        root = root->nextWord;
        free(freeRoot->contents);
        free(freeRoot);
    }
    
    return 0;
}

int calculateUniqueFreqLine(LINE * root){
    LINE * curr = root;
    long uniqueFreqTotal = 0;
    while(curr != NULL){
        if(curr->frequency >= 1){
            uniqueFreqTotal++;
        }
        curr = curr->nextLine;
    }
    return uniqueFreqTotal;
}
int countLines(const char * inputFileName){
    FILE * file = fopen(inputFileName, "r");
    long count = 0;
    char buffer[256];
    if(file == NULL){
        printf("ERROR: Can't open input file\n");
        exit(1);
    }

    fseek(file, 0, SEEK_END);
    long checkEmpty = ftell(file);
    fseek(file, 0, SEEK_SET); //move pointer back to beginning
    if(checkEmpty == 0){
        fclose(file);
        printf("ERROR: Input File Empty\n");
        exit(1);
    }

    while(fgets(buffer, sizeof(buffer), file)){
        count++;
    }
    fclose(file);
    return count;
}
void orderLines(LINE **root, LINE *thisLine){
    if(*root == NULL || strcmp((*root)->contents, thisLine->contents) > 0){ //if first insertion OR root should be after this line, make this line the root
        thisLine->nextLine = *root;
        if (*root != NULL) {
            (*root)->prevLine = thisLine;
        }
        *root = thisLine;
    }else{//if not first, then find where
        LINE * currLine = *root;
        while(currLine->nextLine != NULL && strcmp(currLine->nextLine->contents, thisLine->contents) < 0){ //while there are more lines in the list OR line after currLine should be sooner than thisLine
            currLine = currLine->nextLine; //move to next word
        }
        //now thisLine after currLine
        thisLine->nextLine = currLine->nextLine;
        if (currLine->nextLine != NULL) {
            currLine->nextLine->prevLine = thisLine;
        }
        currLine->nextLine = thisLine;
        thisLine->prevLine = currLine;
    }
}
LINE * lineProcess(LINE **root, const char * Buffer, long orderAppeared){
    LINE * curr = *root;
    while(curr != NULL){
        if (strcmp(curr->contents, Buffer) == 0) {
            //line found
            curr->frequency++;
            return curr;
        }
        curr = curr->nextLine;
    }
    //line not found
    LINE * currLine = (LINE *)malloc(sizeof(LINE));
    if (currLine == NULL) {
        perror("Failed to allocate memory for new line");
        exit(1);
    }

    //set up line
    currLine->contents = strdup(Buffer);
    currLine->numWords = strlen(Buffer);
    currLine->frequency = 1;
    currLine->orderAppeared = orderAppeared;
    currLine->nextLine = NULL;
    currLine->prevLine = NULL;

    orderLines(root, currLine);

    return currLine;
}
int lineAnalysis(const char * inputFileName, const char * outputFileName, bool last_flag, bool o_flag_specified){
    long totalLines = countLines(inputFileName);

    FILE * file = fopen(inputFileName, "r");
    if(file == NULL){
        printf("ERROR: Can't open input file\n");
        exit(1);
    }

    char buffer[256];
    LINE *root = NULL;
    long orderAppeared = 0;

    while (fgets(buffer, sizeof(buffer), file)) {
        buffer[strcspn(buffer, "\n")] = 0; // Remove newline
        lineProcess(&root, buffer, orderAppeared);
        orderAppeared++;
    }
    fclose(file);
    long totalUnique = calculateUniqueFreqLine(root);

    //write to file
    FILE * file2;
    if(o_flag_specified){
        file2 = fopen(outputFileName, "a");
    }else{
        file2 = fopen("tempOutputFile.txt", "a");
    }
    if (file2 == NULL) {
        exit(1);
    }
    fprintf(file2, "Total Number of Lines: %ld\n", totalLines);
    fprintf(file2, "Total Unique Lines: %ld\n", totalUnique);
    fputs("\n", file2);
    LINE *current = root;
    while(current != NULL){
        fprintf(file2, "Line: %s, Freq: %ld, Initial Position: %ld\n", current->contents, current->frequency, current->orderAppeared);
        current = current->nextLine;
    }
    if(!last_flag){
        fputs("\n", file2);
    }
    fclose(file2);
    
    while (root != NULL) {
        LINE * freeRoot = root;
        root = root->nextLine;
        free(freeRoot->contents);
        free(freeRoot);
    }
    
    return 0;
}

void deleteLW(LONGESTWORD *root) {
    while (root) {
        LONGESTWORD *freeRoot = root;
        root = root->nextLW;
        free(freeRoot->contents);
        free(freeRoot);
    }
}
void orderLW(LONGESTWORD **root, LONGESTWORD *thisWord){
    if(*root == NULL || strcmp((*root)->contents, thisWord->contents) > 0){ //if first insertion OR root should be after this word, make this word the root
        thisWord->nextLW = *root;
        if (*root != NULL) {
            (*root)->prevLW = thisWord;
        }
        *root = thisWord;
    }else{//if not first, then find where
        LONGESTWORD * currWord = *root;
        while(currWord->nextLW != NULL && strcmp(currWord->nextLW->contents, thisWord->contents) < 0){ //while there are more words in the list OR word after currWord should be sooner than thisWord
            currWord = currWord->nextLW; //move to next word
        }
        //now thisWord after currWord
        thisWord->nextLW = currWord->nextLW;
        if (currWord->nextLW != NULL) {
            currWord->nextLW->prevLW = thisWord;
        }
        currWord->nextLW = thisWord;
        thisWord->prevLW = currWord;
    }
}
void lwProcess(LONGESTWORD **root, const char *Buffer, long *orderAppeared) {
    long currWordLength = strlen(Buffer);

    if(currWordLength > *orderAppeared) {// if this word is longer than standing longest word
        deleteLW(*root);//delete curr list 
        *root = NULL;
        *orderAppeared = currWordLength;//now max length changed

        //set up new longest word
        LONGESTWORD *newLongestWord = malloc(sizeof(LONGESTWORD));
        if (newLongestWord == NULL) {
            perror("Failed to allocate memory for new node");
            exit(1);
        }
        newLongestWord->nextLW = NULL;
        newLongestWord->contents = strdup(Buffer); //duplicate string
        *root = newLongestWord;

    } else if(currWordLength == *orderAppeared) {//if this word matches the length of standing longest word

        //if already exists
        bool exists = false;
        LONGESTWORD * curr = *root;
        while(curr != NULL){
            if (strcmp(curr->contents, Buffer) == 0) {
                //line found
                exists = true;
            }
            curr = curr->nextLW;
        }
        //else
        if(!exists){
            LONGESTWORD *newWord = malloc(sizeof(LONGESTWORD));
            if (newWord == NULL) {
                perror("Failed to allocate memory for new node");
                exit(EXIT_FAILURE);
            }
            newWord->contents = strdup(Buffer);//duplicate the string

            orderLW(root, newWord);
        }
    }
}
int lwAnalysis(const char * inputFileName, const char * outputFileName, bool last_flag, bool o_flag_specified){

    FILE * file = fopen(inputFileName, "r");
    if(file == NULL){
        printf("ERROR: Can't open input file\n");
        exit(1);
    }

    fseek(file, 0, SEEK_END);
    long checkEmpty = ftell(file);
    fseek(file, 0, SEEK_SET); //move pointer back to beginning
    if(checkEmpty == 0){
        fclose(file);
        printf("ERROR: Input File Empty\n");
        exit(1);
    }

    char buffer[256];
    LONGESTWORD *root = NULL;
    long orderAppeared = 0;

    while (fscanf(file, "%255s", buffer) == 1) {
        lwProcess(&root, buffer, &orderAppeared);
    }
    fclose(file);

    //write to file
    FILE * file2;
    if(o_flag_specified){
        file2 = fopen(outputFileName, "a");
    }else{
        file2 = fopen("tempOutputFile.txt", "a");
    }
    if (file2 == NULL) {
        exit(1);
    }
    fprintf(file2, "Longest Word is %ld characters long:\n", orderAppeared);
    LONGESTWORD *current = root;
    while(current != NULL){
        fprintf(file2, "\t%s\n", current->contents);
        current = current->nextLW;
    }
    if(!last_flag){
        fputs("\n", file2);
    }
    fclose(file2);

    while (root != NULL) {
        LONGESTWORD * freeRoot = root;
        root = root->nextLW;
        free(freeRoot->contents);
        free(freeRoot);
    }
    
    return 0;
}

void deleteLL(LONGESTLINE *root) {
    while (root) {
        LONGESTLINE *freeRoot = root;
        root = root->nextLL;
        free(freeRoot->contents);
        free(freeRoot);
    }
}
void orderLL(LONGESTLINE **root, LONGESTLINE *thisLine){
    if(*root == NULL || strcmp((*root)->contents, thisLine->contents) > 0){ //if first insertion OR root should be after this line, make this line the root
        thisLine->nextLL = *root;
        if (*root != NULL) {
            (*root)->prevLL = thisLine;
        }
        *root = thisLine;
    }else{//if not first, then find where
        LONGESTLINE * currLine = *root;
        while(currLine->nextLL != NULL && strcmp(currLine->nextLL->contents, thisLine->contents) < 0){ //while there are more lines in the list OR line after currLine should be sooner than thisLine
            currLine = currLine->nextLL; //move to next word
        }
        //now thisLine after currLine
        thisLine->nextLL = currLine->nextLL;
        if (currLine->nextLL != NULL) {
            currLine->nextLL->prevLL = thisLine;
        }
        currLine->nextLL = thisLine;
        thisLine->prevLL = currLine;
    }
}
void llProcess(LONGESTLINE **root, const char *Buffer, long *orderAppeared){
    long currLineLength = strlen(Buffer);

    if(currLineLength > *orderAppeared) {// if this line is longer than standing longest line
        deleteLL(*root);//delete curr list
        *root = NULL;
        *orderAppeared = currLineLength;//now max length changed

        //set up new longest line
        LONGESTLINE *newLongestLine = malloc(sizeof(LONGESTLINE));
        if (newLongestLine == NULL) {
            perror("Failed to allocate memory for new node");
            exit(1);
        }
        newLongestLine->nextLL = NULL;
        newLongestLine->contents = strdup(Buffer); //duplicate string
        *root = newLongestLine;

    } else if(currLineLength == *orderAppeared) {//if this line matches the length of standing longest line
    
        //if already exists
        bool exists = false;
        LONGESTLINE * curr = *root;
        while(curr != NULL){
            if (strcmp(curr->contents, Buffer) == 0) {
                //line found
                exists = true;
            }
            curr = curr->nextLL;
        }
        //else
        if(!exists){
            LONGESTLINE *newLine = malloc(sizeof(LONGESTLINE));
            if (newLine == NULL) {
                perror("Failed to allocate memory for new node");
                exit(EXIT_FAILURE);
            }
            newLine->contents = strdup(Buffer);//duplicate the string

            orderLL(root, newLine);
        }
    }
}
int llAnalysis(const char * inputFileName, const char * outputFileName, bool last_flag, bool o_flag_specified){
    
    FILE * file = fopen(inputFileName, "r");
    if(file == NULL){
        printf("ERROR: Can't open input file\n");
        exit(1);
    }

    fseek(file, 0, SEEK_END);
    long checkEmpty = ftell(file);
    fseek(file, 0, SEEK_SET); //move pointer back to beginning
    if(checkEmpty == 0){
        fclose(file);
        printf("ERROR: Input File Empty\n");
        exit(1);
    }

    char buffer[256];
    LONGESTLINE *root = NULL;
    long orderAppeared = 0;

    while (fgets(buffer, sizeof(buffer), file)) {
        buffer[strcspn(buffer, "\n")] = 0; // Remove newline
        llProcess(&root, buffer, &orderAppeared);
    }
    fclose(file);

    //write to file
    FILE * file2;
    if(o_flag_specified){
        file2 = fopen(outputFileName, "a");
    }else{
        file2 = fopen("tempOutputFile.txt", "a");
    }
    if (file2 == NULL) {
        exit(1);
    }
    fprintf(file2, "Longest Line is %ld characters long:\n", orderAppeared);
    LONGESTLINE *current = root;
    while(current != NULL){
        fprintf(file2, "\t%s\n", current->contents);
        current = current->nextLL;
    }
    if(!last_flag){
        fputs("\n", file2);
    }
    fclose(file2);

    while (root != NULL) {
        LONGESTLINE * freeRoot = root;
        root = root->nextLL;
        free(freeRoot->contents);
        free(freeRoot);
    }
    
    return 0;
}

void batchProcess(const char *Buffer){
    char *words[10];
    char dest[256];
    long w = 0;
    long length = 0;

    strncpy(dest, Buffer, 256);
    dest[256 - 1] = '\0'; //null-termination check

    char *word = strtok(dest, " ");
    while (word != NULL && w < 10) {
        words[w++] = strdup(word);
        word = strtok(NULL, " ");
        length++;
    }

    bool f_flag_specified = false;
    bool o_flag_specified = false;
    bool last_flag = true;
    char * inputFile = NULL;
    char * outputFile = NULL;

    for(long i = 0; i < length; i++){
        if(strcmp(words[i], "-f") == 0){
            f_flag_specified = true;
            if(i + 1 < length){
                if(words[i + 1][0] == '-'){
                    printf("ERROR: No Input File Provided\n");
                    return;
                }else{
                    inputFile = words[++i];
                }
            }
        }
    }
    //if -f flag wasn't specified, through error
    if(!f_flag_specified){
        printf("ERROR: No Input File Provided\n");
        return;
    }

    //check if inputfile is empty
    FILE * file = fopen(inputFile, "r");
    if(file == NULL){
        printf("ERROR: Can't open input file\n");
        exit(1);
    }

    fseek(file, 0, SEEK_END);
    long checkEmpty = ftell(file);
    fseek(file, 0, SEEK_SET); //move pointer back to beginning
    if(checkEmpty == 0){
        printf("ERROR: Input File Empty\n");
        return;
    }
    fclose(file);

    //process
    for(long i = 0; i < length; i++){
        if(strcmp(words[i], "-f") == 0 && i + 1 < length){
            if(words[i + 1][0] != '-'){ //if f followed by another flag
                inputFile = words[++i];
            }else{
                printf("ERROR: No Input File Provided\n");
                return;
            }
        } else if(strcmp(words[i], "-o") == 0 && i + 1 < length){
            if(words[i + 1][0] != '-'){
                o_flag_specified = true;
                outputFile = words[++i];
            }else{
                printf("ERROR: No Output File Provided\n");
            }
        }
        else if(strcmp(words[i], "-c") == 0){
            if(i == (length - 1)){ //if last flag
                charAnalysis(inputFile, outputFile, last_flag, o_flag_specified);
            }else{
                charAnalysis(inputFile, outputFile, !last_flag, o_flag_specified);
            }
        } else if(strcmp(words[i], "-w") == 0){
            if(i == (length - 1)){ //if last flag
                wordAnalysis(inputFile, outputFile, last_flag, o_flag_specified);
            }else{
                wordAnalysis(inputFile, outputFile, !last_flag, o_flag_specified);
            }
        } else if(strcmp(words[i], "-l") == 0){
            if(i == (length - 1)){ //if last flag
                lineAnalysis(inputFile, outputFile, last_flag, o_flag_specified);
            }else{
                lineAnalysis(inputFile, outputFile, !last_flag, o_flag_specified);
            }
        } else if(strcmp(words[i], "-Lw") == 0){
            if(i == (length - 1)){ //if last flag
                lwAnalysis(inputFile, outputFile, last_flag, o_flag_specified);
            }else{
                lwAnalysis(inputFile, outputFile, !last_flag, o_flag_specified);
            }
        } else if(strcmp(words[i], "-Ll") == 0){
            if(i == (length - 1)){ //if last flag
                llAnalysis(inputFile, outputFile, last_flag, o_flag_specified);
            }else{
                llAnalysis(inputFile, outputFile, !last_flag, o_flag_specified);
            }
        }
    }

    if(!o_flag_specified){
        FILE * tempFile = fopen("tempOutputFile.txt", "r");
        if (tempFile == NULL) {
            exit(1);
        }
        while(true){
            char ch = fgetc(tempFile);
            if(feof(tempFile)){
                break;
            }
            putchar(ch);
        }
        fclose(tempFile);
        remove("tempOutputFile.txt");
    }
}
int batchAnalysis(const char * batchFileName){
    FILE * file = fopen(batchFileName, "r");
    if (file == NULL) {
        printf("ERROR: Can't open batch file\n");
        exit(1);
    }
    fseek(file, 0, SEEK_END);
    if (ftell(file) == 0) {//if the pointer is at 0 meaning nothin in file
        fclose(file);
        printf("ERROR: Batch File Empty\n");
        exit(1);
    } else {//there are contents in file
        fseek(file, 0, SEEK_SET);
        char buffer[256];

        while (fgets(buffer, sizeof(buffer), file)) {
            buffer[strcspn(buffer, "\n")] = 0; //remove return and whitespace
            batchProcess(buffer);//input is a line
        }

        fclose(file);
        return 0;
    }
}

int main(int argc, char *argv[]){

    bool f_flag_specified = false;
    bool b_flag_specified = false;
    bool o_flag_specified = false;
    char * inputFile = NULL;
    char * outputFile = NULL;
    bool last_flag = true;

    //Usage Error
    if(argc < 3) {
        printf("USAGE:\n");
        printf("\t./MADCounter -f <input file> -o <output file> -c -w -l -Lw -Ll\n");
        printf("\t\tOR\n");
        printf("\t./MADCounter -B <batch file>\n");
        exit(1);
    }

    for(long i = 1; i < argc; i++){
        if(strcmp(argv[i], "-f") == 0){
            f_flag_specified = true;
            if(i + 1 < argc){
                if(argv[i + 1][0] == '-'){
                    printf("ERROR: No Input File Provided\n");
                    exit(1);
                }else{
                    inputFile = argv[++i];
                }
            }
        }else if(strcmp(argv[i], "-B") == 0){
            b_flag_specified = true;
        }else if(strcmp(argv[i], "-o") == 0){
            o_flag_specified = true;
            if(argv[i + 1][0] != '-'){
                outputFile = argv[++i];
            }else{
                printf("ERROR: No Output File Provided\n");
                exit(1);
            }
        }
    }
    //if -f flag wasn't specified, through error
    if(!f_flag_specified && !b_flag_specified){
        printf("ERROR: No Input File Provided\n");
        exit(1);
    }

    for(long i = 1; i < argc; i++){
        if(strcmp(argv[i], "-f") == 0 && i + 1 < argc){
            if(argv[i + 1][0] != '-'){
                inputFile = argv[++i];
            }else{
                printf("ERROR: No Input File Provided\n");
                exit(1);
            }
        } else if(strcmp(argv[i], "-o") == 0 && i + 1 < argc){
            if(argv[i + 1][0] != '-'){
                outputFile = argv[++i];
            }else{
                printf("ERROR: No Output File Provided\n");
                exit(1);
            }
        } else if(strcmp(argv[i], "-B") == 0 && i + 1 < argc){
            batchAnalysis(argv[++i]);
        }
        else if(strcmp(argv[i], "-c") == 0){
            if(i == (argc - 1) || (argv[i + 1][0] == '-' && argv[i + 1][1] == 'f') || (argv[i + 1][0] == '-' && argv[i + 1][1] == 'o')){ //if last flag
                charAnalysis(inputFile, outputFile, last_flag, o_flag_specified);
            }else{
                charAnalysis(inputFile, outputFile, !last_flag, o_flag_specified);
            }
        } else if(strcmp(argv[i], "-w") == 0){
            if(i == (argc - 1) || (argv[i + 1][0] == '-' && argv[i + 1][1] == 'f') || (argv[i + 1][0] == '-' && argv[i + 1][1] == 'o')){ //if last flag
                wordAnalysis(inputFile, outputFile, last_flag, o_flag_specified);
            }else{
                wordAnalysis(inputFile, outputFile, !last_flag, o_flag_specified);
            }
        } else if(strcmp(argv[i], "-l") == 0){
            if(i == (argc - 1) || (argv[i + 1][0] == '-' && argv[i + 1][1] == 'f') || (argv[i + 1][0] == '-' && argv[i + 1][1] == 'o')){ //if last flag
                lineAnalysis(inputFile, outputFile, last_flag, o_flag_specified);
            }else{
                lineAnalysis(inputFile, outputFile, !last_flag, o_flag_specified);
            }
        } else if(strcmp(argv[i], "-Lw") == 0){
            if(i == (argc - 1) || (argv[i + 1][0] == '-' && argv[i + 1][1] == 'f') || (argv[i + 1][0] == '-' && argv[i + 1][1] == 'o')){ //if last flag
                lwAnalysis(inputFile, outputFile, last_flag, o_flag_specified);
            }else{
                lwAnalysis(inputFile, outputFile, !last_flag, o_flag_specified);
            }
        } else if(strcmp(argv[i], "-Ll") == 0){
            if(i == (argc - 1) || (argv[i + 1][0] == '-' && argv[i + 1][1] == 'f') || (argv[i + 1][0] == '-' && argv[i + 1][1] == 'o')){ //if last flag
                llAnalysis(inputFile, outputFile, last_flag, o_flag_specified);
            }else{
                llAnalysis(inputFile, outputFile, !last_flag, o_flag_specified);
            }
        }else{
            printf("ERROR: Invalid Flag Types\n");
            exit(1);
        }
    }

    if(!o_flag_specified && !b_flag_specified){
        FILE * tempFile = fopen("tempOutputFile.txt", "r");
        if (tempFile == NULL) {
            exit(1);
        }
        while(true){
            char ch = fgetc(tempFile);
            if(feof(tempFile)){
                break;
            }
            putchar(ch);
        }
        fclose(tempFile);
        remove("tempOutputFile.txt");
    }

    return 0; //success
}