#include <stdio.h>
#include <stdlib.h>

int minimum(int *a, int size);
void minimax(int *array, int size, int *min, int *max);

struct Foo {
	struct Foo *n; int val;
};

void add_four(int *a) {
	*a += 4;
}

int main() {
	int array[]={34,54,2,43,78};
	int mini = minimum(array,5);
	printf("mini = %d\n", mini);
	int min;
	int max;
	minimax(array,5,&min,&max);
	printf("min = %d  max = %d\n\n", min, max);
	
	struct Foo *p = malloc(sizeof (struct Foo));
	struct Foo f = {
		.n = p,
		.val = 1
	};
	p->val = 5;
	for (p=&f;NULL != p;p=p->n) {
		printf ("%d\n", p->val);
	}
	
	char c = -1;
	printf("Char as int: %u\n", (int) c);
	
	union{unsigned int i; float f;} u;
	u.f = -0.1;
	printf("Int: %d\n", u.i);
	printf("Hex: %X\n", u.i);

	int b = 5;
	add_four(&b);
	printf("b: %d\n", b);

	return 0;
}

int minimum(int *a, int size) {
	int ret = *a; // start with first number
	for(int i = 1; i < size; i++) { // loop and see if there are smaller numbers
		if (*(a+i) < ret) {
			ret = *(a+i);
		}
	}
	return ret;
}

void minimax(int *array, int size, int *min, int *max) {
	*min = *array;
	*max = *array;
	for(int i = 1; i < size; i++) { // loop and see if there are smaller numbers
		if (*(array+i) < *min) {
			*min = *(array+i);
		}
		if (*(array+i) > *max) {
			*max = *(array+i);
		}
	}
}

