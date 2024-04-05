//
// complex.c
//
#include "complex.h"
#include "rect.h"
#include "polar.h"
#include <stdio.h>

//TODO: implement add using re and im; return rect_t
complex_t* complex_add(complex_t *a, complex_t *b) {
  complex_t *comp = rect_make(
    ((rect_t *) a)->re(a) + ((rect_t *) b)->re(b),
    ((rect_t *) a)->im(a) + ((rect_t *) b)->im(b)
  );
  return comp;
}

//TODO: implement sub using re and im; return rect_t
complex_t* complex_sub(complex_t *a, complex_t *b) {
  complex_t *comp = rect_make(
    ((rect_t *) a)->re(a) - ((rect_t *) b)->re(b),
    ((rect_t *) a)->im(a) - ((rect_t *) b)->im(b)
  );
  return comp;
}

//TODO: implement mul using mag and ang; return polar_t
complex_t* complex_mul(complex_t *a, complex_t *b) {
  complex_t *comp = rect_make(
    ((polar_t *) a)->mag(a) * ((polar_t *) b)->mag(b),
    ((polar_t *) a)->ang(a) + ((polar_t *) b)->ang(b)
  );
  return comp;
}

//TODO: implement div using mag and ang; return polar_t
complex_t* complex_div(complex_t *a, complex_t *b) {
  complex_t *comp = rect_make(
    ((polar_t *) a)->mag(a) / ((polar_t *) b)->mag(b),
    ((polar_t *) a)->ang(a) - ((polar_t *) b)->ang(b)
  );
  return comp;
}
