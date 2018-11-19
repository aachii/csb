#include <stdio.h>
#include <ctype.h>

char in[256];

bubbleSort(char s[256]) {
	return(s);
}

int main() {
	puts("Let's sort your input with bubbleSort!");
	puts("Please enter your text:");
	scanf("%s", in);
	
	bubbleSort(in);

	printf("%s\n", in);
	return(0);
}
