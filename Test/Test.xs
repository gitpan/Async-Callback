#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "Callback.h"

CALLBACK_SETUP;

void callback_test1(void *data) {

    sv_setiv((SV *)data, SvIV((SV *)data) + 1);
}

MODULE = Async::Callback::Test		PACKAGE = Async::Callback::Test		

BOOT:
    CALLBACK_INIT;

I32
start_test1(var)
    SV *var
    CODE:
    	RETVAL = register_callback(callback_test1);
	SvREFCNT_inc(var);
	enable_callback(RETVAL, var);
    OUTPUT:
    	RETVAL

void
finish_test1(handle)
    I32 handle
    CODE:
    	delete_callback(handle);
