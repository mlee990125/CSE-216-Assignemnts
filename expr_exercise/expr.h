//
// expr.h
//
#ifndef __EXPR__
#define __EXPR__

#include "refobj.h"
#include "rat.h"

typedef struct expr {
    refobj_t ref;   //ref is at the beginning of rat
    rat_t* ( *eval  )(struct expr *self);
    void   ( *print )(struct expr *self);
} expr_t;

typedef struct expr_num {
    refobj_t ref;   //first part is the same as expr_t
    rat_t* ( *eval  )(struct expr *self);
    void   ( *print )(struct expr *self);

    rat_t *n;           //number
} expr_num_t;

typedef struct expr_opr {
    refobj_t ref;   //first part is the same as expr_t
    rat_t* ( *eval  )(struct expr *self);
    void   ( *print )(struct expr *self);

    struct expr *a;     //operand 1
    struct expr *b;     //operand 2
} expr_opr_t;

extern expr_t *expr_make_num(rat_t *n);
extern expr_t *expr_make_add(expr_t *a, expr_t *b);
extern expr_t *expr_make_sub(expr_t *a, expr_t *b);
extern expr_t *expr_make_mul(expr_t *a, expr_t *b);
extern expr_t *expr_make_div(expr_t *a, expr_t *b);

#endif
