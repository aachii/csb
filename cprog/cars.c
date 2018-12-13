#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define my_new(t) (t*) malloc (sizeof (t))
#define MAXSIZE 12

struct Car {
	char     brand[10];
	char     type[10];
	long int id;
	double   price;
	struct   Car *next;
};

int main(){
  int res; 
  struct Car *first;
  first = NULL;

  do{
    struct Car *newfirst = my_new(struct Car);
    res = scanf("%s %s %ld %lf", newfirst->brand, newfirst->type, &newfirst->id, &newfirst->price);
    newfirst->next=first;
    first=newfirst;
  }while(res != EOF);
  
  do{
	first=first->next;
	printf("Brand: %s   Type: %49s   ID: %ld   Price: %f\n", first->brand, first->type, first->id, first->price);
  }while(first->next!=NULL);
  return 0;
}
