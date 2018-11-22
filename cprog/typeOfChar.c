#include <stdio.h>
#define TYPE unsigned char

int main() {
	int ret = getchar();
	fprintf(stdout, "%d\n", (EOF == ret));
	TYPE c = (TYPE) ret;
	fprintf(stdout, "%d\n", (EOF == c));
	return 0;
}
