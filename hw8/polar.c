//
// polar.c
//
#include "complex.h"
#include "polar.h"
#include <math.h>

//TODO: implement re, re( m\a ) = m * cos a
static double re(complex_t *self) {
    return ((polar_t *) self)->m * cos(((polar_t *) self)->a);
}

//TODO: implement im, im( m\a ) = m * sin a
static double im(complex_t *self) {
    return ((polar_t *) self)->m * sin(((polar_t *) self)->a);
}

//TODO: implement mag, mag( m\a ) = m
static double mag(complex_t *self) {
    return ((polar_t *) self)->m;
}

//TODO: implement ang, ang( m\a ) = a
static double ang(complex_t *self) {
    return ((polar_t *) self)->a;
}

//write m\a to buf
static int tostr(char *buf, complex_t *self) {
    polar_t *pol = (polar_t*)self;
    ON_FALSE_EXIT(self->ref.tag == OBJ_POLAR, strmsg("not polar type"));
    return sprintf(buf, "%g \\ %g", pol->m, pol->a);
}

//TODO: implement polar_make
complex_t* polar_make(double m, double a) {
    polar_t *p = (polar_t *) refobj_alloc(OBJ_POLAR, sizeof(polar_t));
    p->m = m;
    p->a = a;
    p->mag = mag;
    p->ang = ang;
    p->re = re;
    p->im = im;
    p->tostr = tostr;
    return (complex_t *) p;
}

//deg to radian
double deg2rad(double deg) {
    double pi = acos(-1);
    return pi / 180 * deg;
}

//radian to deg
double rad2deg(double rad) {
    double pi = acos(-1);
    return 180 / pi * rad;
}
