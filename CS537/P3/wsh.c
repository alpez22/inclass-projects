#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>
#include <stdbool.h>
#include <errno.h>
#include <ctype.h>

char *get_shell_var_names[100];
char *get_shell_var_values[100];
int get_shell_var_count = 0;
char **history = NULL;
int history_capacity = 5;
int history_count = 0;
int history_start = 0;

char *read_input(FILE * input_stream) {
    char *line = NULL;
    size_t buffer = 0; //getline will allocate buffer size to handle large args
    if (getline(&line, &buffer, input_stream) == -1) { //return -1 at eof or ctrl-d
        free(line);
        return NULL; //EOF reached
    }
    return line;
}

char **parse_input(char *line) {
    int buffer = 256; //max 256 tokens
    int curr = 0; //curr position or curr token at in line
    char **tokens = malloc(buffer * sizeof(char*));
    char *token;
    char delimiters[4] = " \t\n";

    token = strtok(line, delimiters);
    while (token != NULL) {
        tokens[curr] = token;
        curr++;
        if (curr >= buffer) { //if there are more than 256 words in a line, resize tokens
            buffer += 256;
            tokens = realloc(tokens, buffer * sizeof(char*));
        }
        token = strtok(NULL, delimiters); //NULL to continue tokenizing the curr line
    }
    tokens[curr] = NULL; //last element in tokens will be NULL
    
    return tokens;
}

void set_shell_var(char *name, char *value) {
    //if var already exists, update it
    for (int i = 0; i < get_shell_var_count; i++) {
        if (strcmp(get_shell_var_names[i], name) == 0) {
            free(get_shell_var_values[i]);
            get_shell_var_values[i] = strdup(value);//update val
            return;
        }
    }
    //if var doesn't exist
    get_shell_var_names[get_shell_var_count] = strdup(name);
    get_shell_var_values[get_shell_var_count] = strdup(value);
    get_shell_var_count++;
}

char *get_shell_var_value(char *name) {
    for (int i = 0; i < get_shell_var_count; i++) {
        if (strcmp(get_shell_var_names[i], name) == 0) {
            return get_shell_var_values[i];
        }
    }
    return ""; //not found
}

void update_history(const char *command) {
    if (history_count > 0) {
        int last_index = (history_start + history_count - 1) % history_capacity;
        if (strcmp(history[last_index], command) == 0) { //duplicate
            return;
        }
    }

    if (history_count == history_capacity) {//free oldest command
        free(history[history_start]);
        history_start = (history_start + 1) % history_capacity;
    } else {
        history_count++;
    }

    int index = (history_start + history_count - 1) % history_capacity;
    history[index] = strdup(command);//add command
}

void resize_history(int new_size) {
    char **new_history = calloc(new_size, sizeof(char*));
    int start = (history_count - history_capacity) < 0 ? 0 : history_count - history_capacity;

    for (int i = start; i < history_count; i++) {
        int j = i - start;
        if (j < new_size) {
            new_history[j] = history[i % history_capacity];
        } else {
            free(history[i % history_capacity]); // if new size is smaller, drop old cmds
        }
    }

    free(history);
    history = new_history;
    history_capacity = new_size;
    if (history_count > new_size) {
        history_count = new_size;
    }
}

int cd_input(char **args) {
    if (args[1] == NULL || args[2] != NULL) {
        fprintf(stderr, "cd: wrong number of arguments\n");
        return 1;
    }

    if (chdir(args[1]) != 0) {
        perror("cd error"); //error if chdir fails
        return 1;
    }

    return 0;//success
}

int execute(char **args) { 
    
    if(strcmp(args[0], "local") == 0) {
        char *leftPart = strtok(args[1], "=");
        char *rightPart = strtok(NULL, "");
        set_shell_var(leftPart, rightPart);
        return 1;
    } else if(strcmp(args[0], "export") == 0) {
        char *leftPart = strtok(args[1], "=");
        char *rightPart = strtok(NULL, "");
        setenv(leftPart, rightPart, 1);
        return 1;
    } else if(strcmp(args[0], "vars") == 0) {
        for (int i = 0; i < get_shell_var_count; i++) {
            printf("%s=%s\n", get_shell_var_names[i], get_shell_var_values[i]);
        }
        return 1;
    } else if (strcmp(args[0], "cd") == 0) {
        return cd_input(args);
    }else if(strcmp(args[0], "history") == 0){
        if(args[1] != NULL && strcmp(args[1],"set") == 0){
            resize_history(atoi(args[2]));
            return 1;
        }else if(args[1] == NULL){
            //just history
            for (int i = 0; i < history_count; i++) { //print history
                int index = (history_start + i) % history_capacity;
                printf("%d) %s", i + 1, history[index]);
            }
            return 1;
        }
    }
    //execute with or without piping... if no piping it will skip all strcmp with |

    for (int i = 0; args[i] != NULL; i++) {//substitute variable references with their values
        if (args[i][0] == '$') {//check for $ symbol

            char *varName = args[i] + 1; //get var nam without $
            
            char *value = get_shell_var_value(varName);//attempt shell vars
            
            if (value[0] == '\0') {// If not found, try environment variables
                value = getenv(varName);
            }
            
            if (value == NULL) {
                value = "";//still not found
            }
            
            args[i] = value; //substitute val
        }
    }

    if(strcmp(args[0], "history") == 0){//execute a command from the history
    
        if(atoi(args[1]) > history_capacity || atoi(args[1]) > history_count){//If history is called with an integer greater than the capacity of the history, or if history is called with a number that does not have a corresponding command yet, it will do nothing, and the shell should print the next prompt.
            return 1;
        }
        //grab history of args[1] index
        //set this command to args
        char **command_from_history = parse_input(history[atoi(args[1]) - 1]); //parse input on history at this index
        args = command_from_history;
    }

    int N = 0;
    for (int i = 0; args[i] != NULL; i++) {
        if (strcmp(args[i], "|") == 0) {
            N++; //count how many pipes
        }
    }

    int pipefds[2 * N]; //pipe file descriptor for read and write end of data 2 * N
    for (int i = 0; i < N; i++) {
        if (pipe(pipefds + i*2) < 0) { //fill array with fd's using pipe as a data channel & account for read/write will be next to each other ie times 2
            exit(1);
        }
    }

    int j = 0;
    int curr = 0;
    while (args[j] != NULL) {
        char *cmd[256] = {NULL}; //char pointer to all the args
        int k = 0;

        while (args[j] != NULL && strcmp(args[j], "|") != 0) {
            cmd[k++] = args[j++]; //get all the commands that aren't a pipe, place all the first cmds to cmd[0], second to cmd[1], etc
        }
        cmd[k] = NULL;
        j++; //need to move to next cmd or next iteration of while loop it will still point to the pipe

        pid_t pid = fork();
        if (pid == 0) {

            if (curr < N) { //redirect stdout to the next pipe except for the last command
                if (dup2(pipefds[curr * 2 + 1], STDOUT_FILENO) < 0) {
                    exit(1);
                }
            }

            if (curr != 0) {//get input from prev pipe except for first
                if (dup2(pipefds[(curr - 1) * 2], STDIN_FILENO) < 0) {
                    perror("wsh: dup2");
                    exit(1);
                }
            }

            for (int i = 0; i < 2 * N; i++) {
                close(pipefds[i]);//close fds
            }

            //take name of program and an array of args, execvp will find the systems PATH env vars
            if (execvp(cmd[0], cmd) == -1) {
                exit(1);
            }
        } else if (pid < 0) {
            exit(1);
        }

        curr++;
    }

    for (int i = 0; i < 2 * N; i++) {
        close(pipefds[i]); //parent close fds
    }

    for (int i = 0; i <= N; i++) {
        wait(NULL); //parent wait for child
    }

    return 0;
}

int main(int argc, char **argv) {
    char *line;
    char **args;
    FILE *input_stream = stdin; //abstract the source, stdin, as a FILE pointer

    // Check for correct invocation
    if (argc > 2) {
        fprintf(stderr, "Usage: %s [script]\n", argv[0]);
        exit(1);
    } else if (argc == 2) {
        input_stream = fopen(argv[1], "r"); //stdin redirected to read a batch file
    }

    history = calloc(5, sizeof(char*));
    while (true) {
 
        if (input_stream == stdin) { //wont need stdin with bash file
            printf("wsh> ");
        }
        line = read_input(input_stream);
        if (line == NULL) { // reached EOF
            exit(0);
        }
        if(!strstr(line, "history")){
            update_history(line);
        }
        args = parse_input(line);
        if (strcmp(args[0], "exit") == 0) {
            break;
        }else{
            execute(args);
        }

        free(line);
        free(args);
    }

    if (input_stream != stdin) { //input stream was from batch
        fclose(input_stream); //close file
    }

    //free history
    for (int i = 0; i < history_count; i++) {
        int index = (history_start + i) % history_capacity;
        free(history[index]);
    }
    free(history);

    return 0;//success
}
