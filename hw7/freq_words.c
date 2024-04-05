#include "freq_words.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//TODO: return the number of unique words in sorted_words
int unique_word_count(char **sorted_words, int wc) {
    /*hint: because the words are sorted, duplicated words are grouped together
            skip counting the duplicated words*/
}

//TODO: return the array of word frequencies (the number of occurrences)
//      and the number of unique words in sorted_words
void make_word_freqs(char **sorted_words, int wc, word_freq_t **pword_freqs, int *puwc) {
    int uwc = unique_word_count(sorted_words, wc);
    word_freq_t *word_freqs; /*hint: using malloc, allocate word_freq_t
                                     array of uwc elements*/
    //uwc*sizeof(word_freq_t)
    /*hint: if wc > 0, initialize word_freqs[0]
            for i = 1 .. wc-1,
            update the current word_freqs if sorted_words[i] is equal to
                                             sorted_words[i-1]
            initialize a new word_freqs   otherwise
    */

    *pword_freqs = word_freqs;
    *puwc = uwc;
}

//print the frequency of words
void print_word_freqs(word_freq_t *word_freqs, int uwc) {
    int i;
    printf("--print freqs----------\n");
    for(i = 0; i < uwc; i++)
        printf("%s: %d\n", word_freqs[i].word, word_freqs[i].freq);
}
