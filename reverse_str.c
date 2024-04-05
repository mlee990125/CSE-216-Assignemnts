#include <stdio.h>
#include <string.h>

void swap(char *a, char *b){
  char tmp = *a;
  *a = *b;
  *b = tmp;
}

void reverse_str(char *str){
  int  i = 0;
  int j = strlen(str) - 1;
  while(i < j){
    swap(str + i, str + j);
    i++;
    j--;
  }

  int main(){
    char str[] = "hello";
    printf("before: ")
  }
}