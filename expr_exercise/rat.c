//
// rat.c
//
#include "rat.h"        //include the declarations of rat.h
#include <stdio.h>

static int sign(int a) {
    return a < 0 ? -1 : 1;
}
static int iabs(int a) {
    return a < 0 ? -a : a;
}
static int gcd(int a, int b) {
    if(a == b)
        return a;
    else if (a > b)
        return gcd(a - b, b);
    else
        return gcd(b - a, a);
}

static int get_num(rat_t* a) {
    return a->num;
}
static int get_den(rat_t* a) {
    return a->den;
}
static void print(rat_t* a) {
    printf("[%d / %d]", a->num, a->den);
}

rat_t* rat_make(int num, int den) {
    rat_t* ret = refobj_alloc(OBJ_RAT, sizeof(rat_t));

    ret->get_num = get_num;  //copy the function pointers
    ret->get_den = get_den;
    ret->print = print;

    int s = sign(num) * sign(den);
    int g = gcd(iabs(num), iabs(den)); //reduce the fraction 
    ret->num = num / g * s;
    ret->den = den / g;

    return ret;             //copied the struct as a value
}

rat_t* rat_add(rat_t* a, rat_t* b) {
    int num = a->num * b->den + b->num * a->den;
    int den = a->den * b->den;
    return rat_make(num, den);
}

rat_t* rat_sub(rat_t* a, rat_t* b) {
    int num = a->num * b->den - b->num * a->den;
    int den = a->den * b->den;
    return rat_make(num, den);
}

rat_t* rat_mul(rat_t* a, rat_t* b) {
    int num = a->num * b->num;
    int den = a->den * b->den;
    return rat_make(num, den);
}

rat_t* rat_div(rat_t* a, rat_t* b) {
    int num = a->num * b->den;
    int den = a->den * b->num;
    return rat_make(num, den);
}

