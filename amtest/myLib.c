#include "myLib.h"

/* Compute the factorial of a value 
Input : val a long integer
Return : val! (i.e. 1*2*3* ...* val)
*/
long factorial(long val){
  long res= 1;
  long i;
  for(i=1; i <= val;i++){
    res *= i;
  }
  return res;
}


/* Compute the factorial of a value 
Input : val a long integer
Return : e^val (i.e. e*e*e* ...* e)
*/
double exponential(long val){
  double res= 1;
  long i;
  for(i=1; i <= val;i++){
    res *= EULER;
  }
  return res;
}

/* Compute the square of a value
Input : val a long integer
Return : value^2
*/
long square(long val){
  return val*val;
}

/* Compute the gcd of two values
Input : val, val two long integer
Return : gcd
*/
long gcd(long val, long val2){
  long sum;
  for(int i; i <= val && i <= val2; ++i) {
    if (val % i == 0 && val2 % i == 0) {
      sum = i;
    }
  }
  return sum;
}

/* Compute the protected integer binary logarithm of val
Input: val a long integer
Return : an integer for binary logarithm of val 
or 0 if val is 0 
*/
long logarithm(long val){
  long res=0;
  if(val<=1){
    return 0;
  }
  while(val>1){
    val /=2;
    res++;
  }
  return res;
}
