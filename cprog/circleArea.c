#include <stdio.h>

#define PI 3.141593
double r;
double area;

int main() {
	puts("Let's calculate the area of a circle!");
	puts("Please enter the radius (r):");
	scanf("%lf", &r);
	area = r*r*PI;
	printf("Calculated Area = r^2*PI = %lf\n", area);
	return 0;
}
