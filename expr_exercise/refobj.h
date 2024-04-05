// refobj.h
//
#ifndef __REFOBJ__
#define __REFOBJ__
#include "common.h"

typedef enum {
    OBJ_RAT,
    OBJ_EXPR_NUM,
    OBJ_EXPR_OPR,
    OBJ_COUNT,
} tag_t;

typedef struct refobj {
    tag_t tag;
    int cnt_ref;    //reference count
    void ( *addref  )(struct refobj *self);
    void ( *release )(struct refobj *self);    
} refobj_t;

typedef struct refstat {    //to track which object is not released
    //total ref count
    int cnt_ref[OBJ_COUNT];

    //live object count
    int cnt_obj[OBJ_COUNT];
} refstat_t;

extern refstat_t stat;

//allocate container of type tag and initialize ref obj
extern void *refobj_alloc(tag_t tag, size_t size);

//free the container object of ref
extern void refobj_free(refobj_t *ref);

//increase cnt_ref of ref
extern void refobj_incref(refobj_t *ref);

//decrease cnt_ref of ref
extern void refobj_decref(refobj_t *ref);

//check whether all refobjs are deallocated correctly
extern void refobj_check_dealloc();

#endif
