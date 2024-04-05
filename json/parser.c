#include "common.h"
#include "scanner.h"

//forward definitions
static void match(int expected);
static void parse_json();
static void parse_opt_value_list();
static void parse_object();
static void parse_array();
static void parse_pair();
static void parse_pair_list();
static void parse_value();
static void parse_value_list();

static scan_t sc;

static void match(int expected) {
    ON_FALSE_EXIT( sc.token == expected,
                   strmsg("syntax error: in %d, expected %d, but has %d (%s)", sc.line, expected, sc.token, sc.text));
    read_token(&sc);
}
static void parse_json() {
    parse_value();
}
static void parse_opt_value_list() {
    if(sc.token == ']') //empty list
        return;
    parse_value_list();
}

//TODO: implement parse_object
static void parse_object() {
}
//TODO: implement parse_array
static void parse_array() {
}
//TODO: implement parse_pair
static void parse_pair() {
}
//TODO: implement parse_pair_list
static void parse_pair_list() {
}
//TODO: implement parse_value
static void parse_value() {

    //when nothing matches
        ON_FALSE_EXIT(0, strmsg("Syntax error: unexpected token %s in line %d",
            sc.text, sc.line));
}
//TODO: implement parse_value_list
static void parse_value_list() {
}

void parse(char *fname) {
    open_scan(&sc, fname);
    read_token(&sc);        //load the first token for the parser
    parse_json();
    close_scan(&sc);
    printf("Success.");
}
