#include <stdio.h>

int gcd(int a, int b){
  if(a == b)
    return a;
  else if(a > b)
    return gcd(a - b, b);
  else 
    return gcd(b - a, a);
}

int main(){
  int a = 12, b = 15;
  printf("gcd %d %d = %d \n", a, b, gcd(a, b));
  return 0;
}