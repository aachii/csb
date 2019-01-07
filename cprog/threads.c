#include <pthread.h>
#include <stdio.h>
/* Source 
http://timmurphy.org/2010/05/04/pthreads-in-c-a-minimal-working-example/ 
*/

void *fac_x(void *fac_void_ptr){
  int *fac_ptr = (int *)fac_void_ptr;
  int result = 1;
  for (int i = *fac_ptr; i>1; i--) {
  	result *= i;
  }
  *fac_ptr = result;
  return NULL;
}

void *exp_x(void *exp_void_ptr){
  int *exp_ptr = (int *)exp_void_ptr;
  int result = 1;
  for (int i = 0; i<*exp_ptr; i++) {
  	result *= 2;
  }
  *exp_ptr = result;
  return NULL;
}

int main(){
  int x = 0;
  scanf("%d", &x); // read a number
  int fac = x; // one number for each thread
  int exp = x; // because result will be different

  pthread_t thread_fac; // factorial
  pthread_t thread_exp; // exponential

  // thread for factorial
  if(pthread_create(&thread_fac, NULL, fac_x, &fac)) {
    fprintf(stderr, "Error creating thread\n");
    return 1;
  } 
  // thread for exponential
  if(pthread_create(&thread_exp, NULL, exp_x, &exp)) {
    fprintf(stderr, "Error creating thread\n");
    return 1;
  }
  
  if(pthread_join(thread_fac, NULL)) {
    fprintf(stderr, "Error joining thread\n");
    return 2;
  }
  if(pthread_join(thread_exp, NULL)) {
    fprintf(stderr, "Error joining thread\n");
    return 2;
  }

  printf("factorial: %d\nexponential: %d\n", fac, exp);
  return 0;
}
