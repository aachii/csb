#include <stdio.h>

int minimum(int *a, int size);
void minimax(int *array, int size, int *min, int *max);
int main() {
	int array[]={34,54,2,43,78};
	int mini = minimum(array,5);
	printf("mini = %d\n", mini);
	int min;
	int max;
	minimax(array,5,&min,&max);
	printf("min = %d  max = %d\n", min, max);
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

