
/* Blank lines on purpose */

#ifndef XS_MODULE_CALLBACK_H_DML
#define XS_MODULE_CALLBACK_H_DML

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <string.h>

typedef void (*callback_t)(void *data);
typedef I32 (*register_callback_p_t)(callback_t);
typedef void (*enable_callback_p_t)(I32, void *);
typedef void (*disable_callback_p_t)(I32);
typedef void (*delete_callback_p_t)(I32);

extern register_callback_p_t register_callback_p;
extern enable_callback_p_t enable_callback_p;
extern disable_callback_p_t disable_callback_p;
extern delete_callback_p_t delete_callback_p;

#define CALLBACK_SETUP \
register_callback_p_t register_callback_p = NULL; \
enable_callback_p_t enable_callback_p = NULL; \
disable_callback_p_t disable_callback_p = NULL; \
delete_callback_p_t delete_callback_p = NULL;

#define CALLBACK_INIT \
{ \
    int num_returned; \
    unsigned int dummy; \
    dSP; \
    if (strcmp(SvPV(get_sv("Async::Callback::COMPAT_VERSION", 0), dummy), "1.000") != 0) { \
    	croak("ERROR: This module was compiled against an old version of Async::Callback that is not compatible with the installed version.  Please reinstall this module."); \
    } \
    ENTER; \
    SAVETMPS; \
    PUSHMARK(sp); \
    PUTBACK; \
    num_returned = perl_call_pv("Async::Callback::get_pointers", G_ARRAY); \
    SPAGAIN; \
    if (num_returned != 4) croak("ERROR: Async::Callback::get_pointers returned the wrong number of arguments.  Maybe version mismatch?"); \
    register_callback_p = (register_callback_p_t)POPi; \
    enable_callback_p = (enable_callback_p_t)POPi; \
    disable_callback_p = (disable_callback_p_t)POPi; \
    delete_callback_p = (disable_callback_p_t)POPi; \
    PUTBACK; \
    FREETMPS; \
    LEAVE; \
}

#define register_callback (*register_callback_p)
#define enable_callback (*enable_callback_p)
#define disable_callback (*disable_callback_p)
#define delete_callback (*delete_callback_p)

#endif
