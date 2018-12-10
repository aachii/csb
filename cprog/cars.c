#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAXSIZE 12

struct Car {
	char     brand[10];
	char     type[10];
	long int id;
	double   price;
};

int main(){
  int res;
  struct Car car[10];
  int i = 0;

  do{
    res = scanf("%s %s %ld %lf", car[i].brand, car[i].type, &car[i].id, &car[i].price);
    i++;
  }while(res != EOF);
  i--;
  
  for(int n=0;n<i;n++){
	printf("Brand: %s   Type: %49s   ID: %ld   Price: %f\n", car[n].brand, car[n].type, car[n].id, car[n].price);
  }
  
}
