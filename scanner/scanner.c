#include "regex.h"
#include "common.h"
#include <stdio.h>

enum tokens {
    TOK_ALL = 0,    //match for the whole expr
    TOK_WS = 1,     //white space
    TOK_NUM,        //number
    TOK_KEY,        //keywords
    TOK_ID,         //identifier
    TOK_PUN,        //punctuator
    TOK_COM,
    TOK_COUNT,      //token count
};

#define TOK_REGEXP  "^([ \t\n\r]+)|"                /*whitespace*/\
                    "^([0-9]+)|"                    /*number*/\
                    "^(fun|if|then|else)|"          /*keywords*/\
                    "^([_a-zA-Z][_a-zA-Z0-9]*)|"    /*identifier*/\
                    "^(->|=|<>|<=|<|>=|>)|"          /*punctuator*/\
                    "^(//[^\n]*\n)"

void init_regexps(regex_t *regTokens) {
    int res = regcomp(regTokens, TOK_REGEXP, REG_EXTENDED);
    if(res != 0) {
        char msg[256];
        regerror(res, regTokens, msg, sizeof(msg));
        ON_FALSE_EXIT(0, strmsg("error in regcomp: %d, %s", res, msg));
    }
}

static char* token_text(char *str, regmatch_t *match) {
    static char text[256];
    int i = 0, j = match->rm_so;
    while(j < match->rm_eo && i < sizeof(text) - 1)
        text[i++] = str[j++];
    text[i] = 0;
    return text;
}

void scan(regex_t *regTokens, char *str) {
    char text[256];
    regmatch_t matches[TOK_COUNT];
    char *s = str;
    while(*s) {
        int res = regexec(regTokens, s, TOK_COUNT, matches, 0);
        if(res == 0) {
            if(matches[TOK_WS].rm_so == 0)              //white space
                s += matches[TOK_WS].rm_eo;
            else if(matches[TOK_NUM].rm_so == 0) {      //number
                printf("%s:num ", token_text(s, &matches[TOK_NUM]));
                s += matches[TOK_NUM].rm_eo;
            }
            else if(matches[TOK_KEY].rm_so == 0) {      //keywords
                printf("%s:key ", token_text(s, &matches[TOK_KEY]));
                s += matches[TOK_KEY].rm_eo;
            }
            else if(matches[TOK_ID].rm_so == 0) {       //identifier
                printf("%s:id ", token_text(s, &matches[TOK_ID]));
                s += matches[TOK_ID].rm_eo;
            }
            else if(matches[TOK_PUN].rm_so == 0) {      //punctuator
                printf("%s:pun ", token_text(s, &matches[TOK_PUN]));
                s += matches[TOK_PUN].rm_eo;
            }
            else if(matches[TOK_COM].rm_so == 0){
                printf("%s:comment ", token_text(s, &matches[TOK_COM]));
                s += matches[TOK_COM].rm_eo;
            }
        }
        else if(res == REG_NOMATCH) {
            printf("%c ", *s);
            s++;
        }
        else {
            char msg[256];
            regerror(res, regTokens, msg, sizeof(msg));
            ON_FALSE_EXIT(0, strmsg("error in regexec: %d, %s", res, msg));
        }
    }
}

int main() {
    char *str = "fun x ->         \n"
                "    fun y ->     \n"
                "        if x > y \n"
                "        then x   \n"
                "        //else y"
            ;
    regex_t regTokens;
    init_regexps(&regTokens);

    printf("Lexical analysis:\n%s\n", str);
    scan(&regTokens, str);

    regfree(&regTokens);
}
