#include "make_words.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//whether c is an alphabet
static int is_alpha(char c) {
    return 'a' <= c && c <= 'z' || 'A' <= c && c <= 'Z';
}

//TODO: return the number of words in str
int word_count(char* str) {
}
//sizeof(char*)*wc
//TODO: return the array of words in str and the number of words
void make_words(char *str, char ***pwords, int *pwc) {
    int wc = word_count(str);
    char **words; /*hint: using malloc, allocate char* array
                          of wc elements*/    

    /*hint: for each word in str, allocate memory using malloc
            and copy the word to the memory*/

    *pwords  = words;
    *pwc = wc;
}

//print words
void print_words(char **words, int wc) {
    int i;
    printf("--print words----------\n");
    for(i = 0; i < wc; i++)
        printf("%s\n", words[i]);
}

