//
// rat.h
//
#ifndef __RAT__     //to avoid multiple inclusion
#define __RAT__
#include "refobj.h"

typedef struct rat {
    refobj_t ref;   //ref is at the beginning of rat (they have the same address)
    int  ( *get_num )(struct rat* a);
    int  ( *get_den )(struct rat* a);
    void ( *print   )(struct rat* a);
    int num;
    int den;
} rat_t;

//extern: make it visible to other files
extern rat_t *rat_make(int num, int den);    
extern rat_t *rat_add(rat_t* a, rat_t* b);
extern rat_t *rat_sub(rat_t* a, rat_t* b);
extern rat_t *rat_mul(rat_t* a, rat_t* b);
extern rat_t *rat_div(rat_t* a, rat_t* b);

#endif
