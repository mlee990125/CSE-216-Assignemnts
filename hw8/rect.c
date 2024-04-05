//
// rect.c
//
#include "complex.h"
#include "rect.h"
#include <math.h>

//TODO: implement re, re( a + bi ) = a
static double re(complex_t *self) {
    return ((rect_t *) self)->r;
}

//TODO: implement im, im( a + bi ) = b
static double im(complex_t *self) {
    return ((rect_t *) self)->i;
}

//TODO: implement mag, mag( a + bi ) = sqrt(a*a + b*b)
static double mag(complex_t *self) {
    return sqrt(((rect_t *) self)->r * ((rect_t *) self)->r + ((rect_t *) self)->i * ((rect_t *) self)->i);
}

//TODO: implement ang, ang( a + bi ) = atan2(b, a)
static double ang(complex_t *self) {
    return atan2(((rect_t *) self)->i, ((rect_t *) self)->r);
}

//write a + bi to buf
static int tostr(char *buf, complex_t *self) {
    rect_t *rec = (rect_t*)self;
    ON_FALSE_EXIT(self->ref.tag == OBJ_RECT, strmsg("not rect type"));
    return sprintf(buf, "%g + %g i", rec->r, rec->i);
}

//TODO: implement rect_make
complex_t* rect_make(double r, double i) {
    rect_t *s = (rect_t *) refobj_alloc(OBJ_RECT, sizeof(rect_t));
    s->r = r;
    s->i = i;
    s->re = re;
    s->im = im;
    s->mag = mag;
    s->ang = ang;
    s->tostr = tostr;
    return (complex_t *) s;
}
