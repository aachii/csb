#include <stdio.h>

int num;

int main() {
	puts("Let's calculate the prime factors of a given number");
	puts("Please enter a number:");	

	while (1) {	// read numbers
		scanf("%d", &num);
	
		if (num == 0) {	// until number is 0
			break;	// then exit
		}
		// start with 2
		// divide num with i as long as rest is 0
		for (int i = 2; i <= num; i++ ) {
			while (num % i == 0) {
				num = num / i;	// if rest 0 calc it
				printf("%d ", i);	// and print i
			}
		}
		puts("");	// make new line
	}

	return 0;
}
