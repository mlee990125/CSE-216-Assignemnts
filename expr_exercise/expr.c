//
// expr.c
//

#include "expr.h"
#include <stdio.h>

//number
//
static rat_t *eval_num(expr_t *self) {
    expr_num_t *expr = (expr_num_t*) self;
    ON_FALSE_EXIT(self->ref.tag == OBJ_EXPR_NUM, strmsg("tag (%d) is not OBJ_EXPR_NUM", self->ref.tag));
    //TODO: implement addref
    expr->n->ref.addref(&expr->n->ref);
    return expr->n;
}
static void print_num(expr_t *self) {
    expr_num_t *expr = (expr_num_t*) self;
    ON_FALSE_EXIT(self->ref.tag == OBJ_EXPR_NUM, strmsg("tag (%d) is not OBJ_EXPR_NUM", self->ref.tag));
    expr->n->print(expr->n);
}
static void release_num(refobj_t *ref) {
    expr_num_t *expr = (expr_num_t*) ref;
    //TODO: implement release
    refobj_decref(&expr->ref);
    if(expr->n->ref.cnt_ref == 0) {
        expr->n->ref.release(&expr->n->ref);
        refobj_free(&expr->ref)
    }
}
expr_t *expr_make_num(rat_t *n) {
    expr_num_t* expr = refobj_alloc(OBJ_EXPR_NUM, sizeof(expr_num_t));
    expr->ref.release = release_num;
    expr->eval = eval_num;
    expr->print = print_num;

    expr->n  = n;
    //TODO: implement addref

    return (expr_t*)expr;
}

//common functions for binary operators
//
static rat_t *eval_opr(expr_t *self, rat_t *(*opr)(rat_t *a, rat_t *b)) {
    expr_opr_t *expr = (expr_opr_t*) self;
    ON_FALSE_EXIT(self->ref.tag == OBJ_EXPR_OPR, strmsg("tag (%d) is not OBJ_EXPR_OPR", self->ref.tag));
    rat_t *a = expr->a->eval(expr->a);
    rat_t *b = expr->b->eval(expr->b);
    rat_t *c = opr(a, b);
    //TODO: implement release
    a->ref.release(&a->ref);
    b->ref.release(&b->ref);
    return c;
}
static void print_opr(expr_t *self, char *opr) {
    expr_opr_t *expr = (expr_opr_t*) self;
    ON_FALSE_EXIT(self->ref.tag == OBJ_EXPR_OPR, strmsg("tag (%d) is not OBJ_EXPR_OPR", self->ref.tag));
    expr->a->print(expr->a);
    printf(opr);
    expr->b->print(expr->b);
}
static void release_opr(refobj_t *ref) {
    expr_opr_t *expr = (expr_opr_t*)ref;
    //TODO: implement release
}
static expr_opr_t *make_opr(expr_t *a, expr_t *b) {
    expr_opr_t* expr = refobj_alloc(OBJ_EXPR_OPR, sizeof(expr_opr_t));
    expr->ref.release = release_opr;

    expr->a  = a;
    expr->b  = b;
    //TODO: implement addref

    return expr;
}

//add
//
static rat_t *eval_add(expr_t *self) {
    return eval_opr(self, rat_add);
}
static void print_add(expr_t *self) {
    print_opr(self, " + ");
}
expr_t *expr_make_add(expr_t *a, expr_t *b) {
    expr_opr_t* expr = make_opr(a, b);
    expr->eval = eval_add;
    expr->print = print_add;
    return (expr_t*)expr;
}

//sub
//
static rat_t *eval_sub(expr_t *self) {
    return eval_opr(self, rat_sub);
}
static void print_sub(expr_t *self) {
    print_opr(self, " - ");
}
expr_t *expr_make_sub(expr_t *a, expr_t *b) {
    expr_opr_t* expr = make_opr(a, b);
    expr->eval = eval_sub;
    expr->print = print_sub;
    return (expr_t*)expr;
}

//mul
//
static rat_t *eval_mul(expr_t *self) {
    return eval_opr(self, rat_mul);
}
static void print_mul(expr_t *self) {
    print_opr(self, " * ");
}
expr_t *expr_make_mul(expr_t *a, expr_t *b) {
    expr_opr_t* expr = make_opr(a, b);
    expr->eval = eval_mul;
    expr->print = print_mul;
    return (expr_t*)expr;
}

//div
//
static rat_t *eval_div(expr_t *self) {
    return eval_opr(self, rat_div);
}
static void print_div(expr_t *self) {
    print_opr(self, " / ");
}
expr_t *expr_make_div(expr_t *a, expr_t *b) {
    expr_opr_t* expr = make_opr(a, b);
    expr->eval = eval_div;
    expr->print = print_div;
    return (expr_t*)expr;
}
