//
// vector3.c
//
#include "common.h"
#include "vector3.h"

//wirte [x, y, z] to buf
static int tostr(char *buf, vec3_t *self) {
    int i = 0;
    i += sprintf(buf + i, "[ ");
    i += self->x->tostr(buf + i, self->x);  i += sprintf(buf + i, ", ");
    i += self->y->tostr(buf + i, self->y);  i += sprintf(buf + i, ", ");
    i += self->z->tostr(buf + i, self->z);  i += sprintf(buf + i, " ]");
    return i;
}

//TODO: implement vec3_release
static void vec3_release(refobj_t *self) {
    vec3_t *v = (vec3_t *) self;
    refobj_decref(&v->ref);
    if (v->ref.cnt_ref == 0) {
        v->x->ref.release(&v->x->ref);
        v->y->ref.release(&v->y->ref);
        v->z->ref.release(&v->z->ref);
        refobj_free(&v->ref);
    }
}

//TODO: implement vec3_make
vec3_t *vec3_make(complex_t *x, complex_t *y, complex_t *z) {
    vec3_t *v = (vec3_t *) refobj_alloc(OBJ_VEC3, sizeof(vec3_t));
    v->ref.release = vec3_release;
    v->tostr = tostr;
    v->x = x;
    v->y = y;
    v->z = z;
    v->x->ref.addref(&v->x->ref);
    v->y->ref.addref(&v->y->ref);
    v->z->ref.addref(&v->z->ref);
    return v;
}

//TODO: implement vec3_add
//e.g. add([1, 2, 3], [4, 5, 6]) = [1+4, 2+5, 3+6]
vec3_t *vec3_add(vec3_t *a, vec3_t *b) {
    complex_t *q = complex_add(a->x, b->x);
    complex_t *w = complex_add(a->y, b->y);
    complex_t *e = complex_add(a->z, b->z);
    vec3_t *v = vec3_make(q, w, e);
    q->ref.release(&q->ref);
    w->ref.release(&w->ref);
    e->ref.release(&e->ref);
    return v;
}

//TODO: implement vec3_sub
//e.g. sub([1, 2, 3], [4, 5, 6]) = [1-4, 2-5, 3-6]
vec3_t *vec3_sub(vec3_t *a, vec3_t *b) {
    complex_t *q = complex_sub(a->x, b->x);
    complex_t *w = complex_sub(a->y, b->y);
    complex_t *e = complex_sub(a->z, b->z);
    vec3_t *v = vec3_make(q, w, e);
    q->ref.release(&q->ref);
    w->ref.release(&w->ref);
    e->ref.release(&e->ref);
    return v;
}

//TODO: implement vec3_smul
//scalar multiplication, e.g. smul(2, [1, 2, 3]) = [2, 4, 6]
vec3_t *vec3_smul(complex_t *s, vec3_t *a) {
    complex_t *q = complex_mul(a->x, s);
    complex_t *w = complex_mul(a->y, s);
    complex_t *e = complex_mul(a->z, s);
    vec3_t *v = vec3_make(q, w, e);
    q->ref.release(&q->ref);
    w->ref.release(&w->ref);
    e->ref.release(&e->ref);
    return v;
}

//TODO: implement vec3_prod
//inner product, e.g. prod([1, 2, 3], [4, 5, 6]) = 1*4 + 2*5 + 3*6 = 32
complex_t *vec3_prod(vec3_t *a, vec3_t *b) {
    complex_t *q_v = complex_mul(a->x, b->x);
    complex_t *w = complex_mul(a->y, b->y);
    complex_t *w_v = complex_add(q_v, w);
    complex_t *e = complex_mul(a->z, b->z);
    complex_t *e_v = complex_add(w_v, e);
    q_v->ref.release(&q_v->ref);
    w->ref.release(&w->ref);
    w_v->ref.release(&w_v->ref);
    e->ref.release(&e->ref);
    return e_v;
}
