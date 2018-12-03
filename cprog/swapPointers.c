#include <stdio.h>

int a; // to read values from console
int b;

// input two addresses
// output swaps the value from a and b
void swap(int *pa, int *pb) {
	int temp = *pa;
	*pa = * pb;
	*pb = temp;
	return;
}

int main() {
	puts("Let's swap two integer values!");
	puts("Please enter two numbers with a space in between:");
	scanf("%d %d", &a, &b); // read two integers from console (space as delimiter)
	printf("a = %d   b = %d\n", a, b); // print a and b before swap call
	swap(&a, &b); // call swap method with addresses as arguments
	printf("a = %d   b = %d\n", a, b); // print a and b after swap
	return 0;
}
