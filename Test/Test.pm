package Async::Callback::Test;

use 5.006;
use strict;
use warnings;

use Callback;

require Exporter;
require DynaLoader;

our @ISA = qw(Exporter DynaLoader);

our $VERSION = '1.00.00';

our @EXPORT = qw(start_test1 finish_test1);

=pod

=head1 NAME

Async::Callback::Test - Test Module for Async::Callback

=head1 SYNOPSIS

  use Async::Callback::Test;

=head1 DESCRIPTION

This module's sole purpose is to provide a test environment for Async::Callback.
It should not be used for any other purpose.

=head1 AUTHOR

David M. Lloyd E<lt>dmlloyd@tds.netE<gt>

=head1 SEE ALSO

L<Async::Callback>.

=cut

bootstrap Async::Callback::Test ($VERSION);

1;
__END__
