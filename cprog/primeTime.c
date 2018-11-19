#include <stdio.h>
#include <stdbool.h>

int main() {
	unsigned int n;
	int count = 0;

	if (1 != scanf("%u", &n)) {
		return 1;
	}
	count = 0;
	for (unsigned int i=2; count < n ;i++) {
		bool i_is_prime = true;
		int a = 2;
		
		while(a < i) {
			if (i % a == 0) {
				i_is_prime = false;
			}
			a++;
		}
		if (i_is_prime) {
			printf("%u\n", i);
			count++;
		}
		i_is_prime = true;

	}
	return 0;
}
