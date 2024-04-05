#ifndef __SCANNER__
#define __SCANNER__

#ifdef WIN
#include "regex.h"
#else
#include <regex.h>
#endif
#include <stdio.h>

enum tokens {
    TOK_ALL = 256,  //match for the whole expr
    TOK_WS,         //white space
    TOK_STR,        //string
    TOK_NUM,        //num
    TOK_TRUE,       //true
    TOK_FALSE,      //false
    TOK_NULL,       //null
    TOK_EOF,        //end of file
    TOK_COUNT = (TOK_EOF - TOK_ALL + 1) //token count
};

#define TOK_REGEXP  "^([ \t\n\r]+)|"                /*whitespace*/\
                    /*TODO: add a regular expression for string*/\
                    /*TODO: add a regular expression for number*/\
                    "^(true)|"                      /*true*/\
                    "^(false)|"                     /*false*/\
                    "^(null)"                      /*null*/

typedef struct scan {
    regex_t regexp;     //regular expression
    int token;          //current token
    char buff[1024];    //current line
    char *pos;          //current position in the buffer
    char text[256];     //text for the current token
    int line;
    FILE *fp;           //file pointer
} scan_t;

//open a scanner
extern void open_scan(scan_t *sc, char *fname);

//close a scanner
extern void close_scan(scan_t *sc);

//read token and return 0 if it is EOF
extern int read_token(scan_t *sc);

#endif
