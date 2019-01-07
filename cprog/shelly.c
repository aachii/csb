#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/wait.h>

int main() {
	char input[100];
	while (1) {
		printf("$ ");
		char* res = fgets(input, sizeof(input)-1, stdin);
		if (NULL==res || 0 == strcmp("quit\n", res)) {
			break;
		}
		pid_t pid = fork();
		if (0 == pid) {
			printf("child process => %s", input);
			char *array[10];
			char s[]=" ";
			char * token = strtok(input, s);
			char *command = token;
			int length = 0;
			while (NULL != token) {
				token = strtok(NULL, s);
				array[length++] = token;
				printf("token: %s\n", token);	
			}
			array[length]=NULL;

			execv(command, array);
			break;
		} else {
			int status;
			waitpid(pid, &status, 0);
			printf("parent process");
		}
	}
	printf("\n");
	return 0;
}
