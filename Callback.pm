package Async::Callback;

use 5.006;
use strict;
use warnings;

require Exporter;
require DynaLoader;

our @ISA = qw(Exporter DynaLoader);

our $VERSION = '1.00.01';
our $COMPAT_VERSION = '1.000';

=pod

=head1 NAME

Async::Callback - Perl extension for adding asynchronous C callbacks.

=head1 SYNOPSIS

  use Async::Callback;

=head1 DESCRIPTION

This module allows you to register a callback with Perl that will
be called between opcodes.  Your callback can be run once or continuously.

=head1 USAGE IN XS

To use L<Async::Callback> in your modules, you must:

1. Include the B<Callback.h> header file in your XS.

2. Call the B<CALLBACK_SETUP> macro from your C section.

3. Call the B<CALLBACK_INIT> macro from the B<BOOT:> section.

4. Use the B<register_callback>, B<enable_callback>, B<disable_callback>, and
B<delete_callback> functions to manage your callbacks.

Here's an example of B<CALLBACK_SETUP> and B<CALLBACK_INIT>:

  #include "EXTERN.h"
  #include "perl.h"
  #include "XSUB.h"

  #include "Callback.h"
  
  CALLBACK_SETUP;
  
  MODULE = MyModule     PACKAGE = MyModule
  
  BOOT:
      CALLBACK_INIT;

=head1 MANAGING CALLBACKS

There are four functions used to manage your callbacks: B<register_callback>,
B<enable_callback>, B<disable_callback>, and B<delete_callback>.

=head2 Function: I32 register_callback(callback_t callback)

Register a callback.  Set B<callback> to the function you want to have called.
This function returns a handle that can be used to enable, disable, or delete
the callback.  B<handle> is an B<I32>.  This function can be called from within
a callback.

=head2 Function: void enable_callback(I32 handle, void *data)

Enable a callback whose handle was returned from B<register_callback>.  The B<data>
parameter is a B<void> pointer that will be passed to the callback.  This function
is threadsafe if you have linked your Perl against B<libpthread>.  This function
can be called from within a callback.

=head2 Function: void disable_callback(I32 handle)

Disable a callback whose handle was returned from B<register_callback>.  If you are
inside a callback, you may only disable the callback that you are in.  This function
is threadsafe if you have linked your Perl against B<libpthread>.

=head2 Function: void delete_callback(I32 handle)

Delete a callback whose handle was returned from B<register_callback>.  Note
that B<handle> will be invalidated by this call and should not be used afterwards.
This function should B<not> be called from within a callback.

=head1 THE CALLBACK FUNCTION

The callback function should use this prototype:

  void callback(void *data);

The B<data> parameter will hold the same pointer that was passed in via B<enable_callback>.
Inside this callback, you can use any Perl API routine, including calling a Perl function.
Note that callbacks are always disabled during a callback function.

=head1 BUGS

This module will disable the Perl debugger.

This module is not re-entrant.  Using this module in a re-entrant fashion will
cause deadlocks or core dumps.

This module does not support Win32 or other non-Pthread mutexes, because I
don't know how to do that.  Let me know if you do.

=head1 AUTHOR

David M. Lloyd E<lt>dmlloyd@tds.netE<gt>

=head1 SEE ALSO

L<perlguts>.

=cut

bootstrap Async::Callback ($VERSION);

1;
__END__
