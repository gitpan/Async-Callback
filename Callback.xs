#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifdef CALLBACK_USE_PTHREADS

#include <pthread.h>
pthread_mutex_t list_mutex;
int initted = 0;

#define CB_INIT { if (!initted) { pthread_mutex_init(&list_mutex, NULL); initted = 1; }}
#define CB_LOCK pthread_mutex_lock(&list_mutex)
#define CB_UNLOCK pthread_mutex_unlock(&list_mutex)

#else /* ! CALLBACK_USE_PTHREADS */

#define CB_INIT
#define CB_LOCK
#define CB_UNLOCK

#endif /* CALLBACK_USE_PTHREADS */

typedef void (*callback_t)(void *data);

typedef struct callback_list_t {
    struct callback_list_t *next;
    struct callback_list_t *prev;
    callback_t callback;
    void *data;
} callback_list_t;

callback_list_t *callbacks = NULL;

#define NEW_CB(cbptr,callback) \
{ \
    New(0,((callback_list_t *)cbptr),1,callback_list_t); \
    ((callback_list_t *)cbptr)->next = NULL; \
    ((callback_list_t *)cbptr)->prev = NULL; \
    ((callback_list_t *)cbptr)->callback = callback; \
}

#define INSERT_CB(cbptr) \
{ \
    if (callbacks != NULL) { \
	callbacks->prev = ((callback_list_t *)cbptr); \
    } \
    ((callback_list_t *)cbptr)->next = callbacks; \
    ((callback_list_t *)cbptr)->prev = NULL; \
    callbacks = ((callback_list_t *)cbptr); \
}

#define REMOVE_CB(cbptr) \
{ \
    if (callbacks == ((callback_list_t *)cbptr)) { \
    	callbacks = ((callback_list_t *)cbptr)->next; \
    } \
    if (((callback_list_t *)cbptr)->prev != NULL) { \
    	((callback_list_t *)cbptr)->prev->next = ((callback_list_t *)cbptr)->next; \
    } \
    if (((callback_list_t *)cbptr)->next != NULL) { \
    	((callback_list_t *)cbptr)->next->prev = ((callback_list_t *)cbptr)->prev; \
    } \
    ((callback_list_t *)cbptr)->next = ((callback_list_t *)cbptr)->prev = NULL; \
}    

#define FREE_CB(cbptr) \
{ \
    Safefree((callback_list_t *)cbptr); \
}

#define SET_DATA(cbptr,newdata) \
{ \
    ((callback_list_t *)cbptr)->data = newdata; \
}

I32 register_callback(callback_t callback) {

    callback_list_t *cbobj;
    CB_LOCK;
    NEW_CB(cbobj,callback);
    CB_UNLOCK;
    return (I32)cbobj;
}

void enable_callback(I32 handle, void *data) {
    
    CB_LOCK;
    SET_DATA(handle,data);
    INSERT_CB(handle);
    CB_UNLOCK;
}

void disable_callback(I32 handle) {
    
    CB_LOCK;
    REMOVE_CB(handle);
    CB_UNLOCK;
}

void delete_callback(I32 handle) {

    CB_LOCK;
    REMOVE_CB(handle);
    CB_UNLOCK;
    FREE_CB(handle);
}

int callback_runops(pTHX) {

    callback_list_t *cur;
    callback_list_t *next;

    CB_INIT;
    
    while ((PL_op = CALL_FPTR(PL_op->op_ppaddr)(aTHX))) {
	for (cur = callbacks; cur != NULL; cur = next) {
	    next = cur->next;
	    PL_runops = Perl_runops_standard;
    	    (*cur->callback)(cur->data);
	    PL_runops = callback_runops;
	}
	PERL_ASYNC_CHECK();
    }
    
    TAINT_NOT;
    return 0;
}

MODULE = Async::Callback		PACKAGE = Async::Callback		

BOOT:
    PL_runops = callback_runops;

void
get_pointers()
    PPCODE:
    	EXTEND(SP, 4);
	PUSHs(sv_2mortal(newSViv((I32)delete_callback)));
	PUSHs(sv_2mortal(newSViv((I32)disable_callback)));
	PUSHs(sv_2mortal(newSViv((I32)enable_callback)));
	PUSHs(sv_2mortal(newSViv((I32)register_callback)));
