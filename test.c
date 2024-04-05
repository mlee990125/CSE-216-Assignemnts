#include <stdio.h>

int inc (int n){
  return n + 1;;
}

int main() {
  int i = inc(5);
  printf("%d\n", i);
  return 0;
}