use Callback;
use Callback::Test;

print "1..5\n";

my $foo = 0;
my $h;

eval {

    $h = start_test1($foo);
};

if ($@) { warn "$@\n"; print "nok 1\n" } else { print "ok 1\n"; }

my $last;

eval {

    die '$foo not incrementing' unless ($foo > 1);
    
    $last=$foo;

};

if ($@) { warn "$@\n"; print "nok 2\n" } else { print "ok 2\n"; }

eval {

    die '$foo not incrementing' unless ($foo > $last);

};

if ($@) { warn "$@\n"; print "nok 3\n" } else { print "ok 3\n"; }

eval {

    finish_test1($h);
    $last=$foo;
}; 

if ($@) { warn "$@\n"; print "nok 4\n" } else { print "ok 4\n"; }

eval {

    die '$foo still incrementing' unless ($foo == $last);
    
};

if ($@) { warn "$@\n"; print "nok 5\n" } else { print "ok 5\n"; }
