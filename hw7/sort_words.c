#include "sort_words.h"
#include <string.h>

//swap word[i] and word[j]
static void swap(char **words, int i, int j) {
    char *tmp = words[i];
    words[i] = words[j];
    words[j] = tmp;
}

//TODO: sort words using the selection sort
void sort_words(char **words, int wc) {
    /*hint: for i = 0 .. wc-1,
            find the minimum string from i+1 using strcmp
            swap it with words[i]*/
}
