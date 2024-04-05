#include <stdio.h>

int main() {
  FILE *fp = fopen("hello.txt", "r");
  fscanf(fp, "Hello world!\n");
  fclose(fp);

  return 0;
}