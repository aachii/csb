#include <stdio.h>
#include "myLib.h"

int main(){
  long i;
  puts("Please type a number:");
  if(1!=scanf(" %ld",&i)){
    puts("Error");
    return 1;
  }
  long logi = logarithm(i);
  long factoriali = factorial(i);
  double exponentiali = exponential(i);
  long gcdi = gcd(i,5);
  long squarei = square(i);
  printf("log(%ld)=%ld and %ld! = %ld;\n e^%ld is %lf\n",i,logi,i,factoriali,i,exponentiali);
  printf("square of %ld = %ld\n",i,squarei);
  printf("gcd(%ld,%ld) = %ld\n",i,i,gcdi);

  return 0;
}
