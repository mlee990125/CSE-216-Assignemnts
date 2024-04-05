#include <stdio.h>

void inc(int *i){
  int j = *i;
  *i = j + 1;
}

int main(){
  int i = 10;
  int *p = &i;
  printf("before: %d\n", *p);
  inc(p);
  printf("after: %d\n", i);
  return 0;
}