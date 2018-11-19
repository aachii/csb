#include <stdio.h>
#include <ctype.h>

char txt[256];

int main() {
	puts("Let's rewrite your text to UPPERCASE!");
	puts("Please enter your text:");
	scanf("%s", txt);

	int i = 0;
	while(txt[i]) {
		txt[i] = toupper(txt[i]);
		i++;
	}

	printf("%s\n", txt);
	return(0);
}
