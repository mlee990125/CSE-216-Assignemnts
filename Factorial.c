#include <stdio.h>

int factorial(int n){
  if(n <= 1)
    return 1;
  return n * factorial(n - 1);
}

int main() {
  printf("factorial %d = %d\n", 4, factorial(4));
  return 0;
}