#include <stdio.h>

//TODO: implement my_strlen
static int my_strlen(char *str) {
  int i;
  for(i = 0; str[i]; i++)
  ;
  return i;
}

//TODO: implement my_strcpy
static void my_strcpy(char *dst, char *src) {
  for(; *src; src++, dst++)
    *dst = *src;
  *dst = 0;

}

//TODO: implement my_strcat
//use my_strlen and my_strcpy
static void my_strcat(char *dst, char *src) {
  int i = my_strlen(dst);
  my_strcpy(dst + i, src);
}

//TODO: implement my_strcmp
static int my_strcmp(char *s1, char *s2) {
  for(; *s1, *s2; s1++, s2++){
    if(*s1 > *s2){
      return 1;
    }else if(*s1 < *s2){
      return -1;
    }else{
      ;
    }
  }
  return 0;
}

//TODO: implement my_strncmp
static int my_strncmp(char *s1, char *s2, int n) {
  for(int i = 0; i < n; i++){
    return my_strcmp(s1 + i, s2 + i);
  }
}

//TODO: implement my_strchr
static char *my_strchr(char *str, char chr) {
}

//TODO: implement my_strstr
//use my_strncmp
static char *my_strstr(char *str, char *substr) {
}

int main() {
    char *str = "Hello World";
    char buf[256];
    int cmp;

    printf("my_strlen(str): %d\n", my_strlen(str));

    my_strcpy(buf, str);
    printf("my_strcpy(buf, str): %s\n", buf);

    my_strcat(buf, "!!!");
    printf("my_strcat(buf, \"!!!\"): %s\n", buf);

    str = my_strchr(buf, 'W');
    printf("my_strchr(buf, 'W'): %s\n", str);

    cmp = my_strcmp(buf, "Hello");
    printf("my_strcmp(buf, \"Hello\"): %d\n", cmp);

    cmp = my_strncmp(buf, "Hello", 5);
    printf("my_strncmp(buf, \"Hello\", 5): %d\n", cmp);

    str = my_strstr(buf, "ello");
    printf("my_strstr(buf, \"ello\"): %s\n", str);

    return 0;
}