//
// regexp_test.c
//
#include "regex.h"
#include <stdio.h>
#include <stdlib.h>

#define ON_REGEX_ERR_EXIT(ret, preg) {\
    int _ret = (ret);\
    if(_ret && _ret != REG_NOMATCH) {\
        char mbuf[256];\
        regerror(_ret, preg, mbuf, sizeof(mbuf));\
        fprintf(stderr, "%s in file: %s, function: %s, line: %d\n",\
                mbuf, __FILE__, __FUNCTION__, __LINE__);\
        exit(1);\
    }\
}

typedef struct regexps {
    regex_t number;
    regex_t identifier;
    regex_t whitespace;
} regexps_t;

void init_regexps(regexps_t *exps) {
    const char *szNumber     = "^[0-9]+";
    const char *szIdentifier = "^[_a-zA-Z][_a-zA-Z0-9]*";
    const char *szWhitespace = "^[ \t\n\r]+";
    int ret;
    ret = regcomp(&exps->number, szNumber, REG_EXTENDED);
    ON_REGEX_ERR_EXIT(ret, &exps->number);
    ret = regcomp(&exps->identifier, szIdentifier, REG_EXTENDED);
    ON_REGEX_ERR_EXIT(ret, &exps->identifier);
    ret = regcomp(&exps->whitespace, szWhitespace, REG_EXTENDED);
    ON_REGEX_ERR_EXIT(ret, &exps->whitespace);
}

void free_regexps(regexps_t *exps) {
    regfree(&exps->number);
    regfree(&exps->identifier);
    regfree(&exps->whitespace);
}

char* str_match(char *str, regmatch_t *match) {
    static char text[256];
    int i = 0, j = match->rm_so;
    while(j < match->rm_eo && i < sizeof(text) - 1)
        text[i++] = str[j++];
    text[i] = 0;
    return text;
}

void scan(regexps_t *exps, char *str) {
    char text[256];
    regmatch_t match[1];
    char *s = str;
    while(*s) {
        int ret;
        ret = regexec(&exps->whitespace, s, 1, match, 0);
        ON_REGEX_ERR_EXIT(ret, &exps->whitespace);
        if(ret == 0) {
            s += match->rm_eo - match->rm_so;
            continue;
        }
        ret = regexec(&exps->number, s, 1, match, 0);
        ON_REGEX_ERR_EXIT(ret, &exps->number);
        if(ret == 0) {
            printf("%s:num ", str_match(s, match));
            s += match->rm_eo - match->rm_so;
            continue;
        }
        ret = regexec(&exps->identifier, s, 1, match, 0);
        ON_REGEX_ERR_EXIT(ret, &exps->identifier);
        if(ret == 0) {
            printf("%s:id ", str_match(s, match));
            s += match->rm_eo - match->rm_so;
            continue;
        }

        {
            printf("%c ", *s);
            s++;
        }
    }
}

int main() {
    char *str = "( fun x -> x + 1 ) 20 ";
    regexps_t exps;
    init_regexps(&exps);

    printf("Lexical analysis:\n%s\n", str);
    scan(&exps, str);

    free_regexps(&exps);
}