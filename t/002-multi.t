use Callback;
use Callback::Test;

print "1..11\n";

my $foo = 0;
my ($h1, $h2, $h3);

eval {

    $h1 = start_test1($foo);
};

if ($@) { print "nok 1\n" } else { print "ok 1\n"; }

my $last;

eval {

    die '$foo not incrementing' unless ($foo > 1);
    
    $last=$foo;

};

if ($@) { print "nok 2\n" } else { print "ok 2\n"; }

eval {

    die '$foo not incrementing' unless ($foo > $last);

    $last=$foo;
};

if ($@) { print "nok 3\n" } else { print "ok 3\n"; }

my $bar = 0;

eval {

    $h2 = start_test1($bar);
};

if ($@) { print "nok 4\n" } else { print "ok 4\n"; }

eval {

    die '$foo not incrementing' unless ($foo > $last);
    die '$bar not incrementing' unless ($bar > 1);
    
    $last=$bar;

};

if ($@) { print "nok 5\n" } else { print "ok 5\n"; }

eval {

    die '$bar not incrementing' unless ($bar > $last);

};

if ($@) { print "nok 6\n" } else { print "ok 6\n"; }

eval {

    finish_test1($h1);
    $last=$foo;
}; 

if ($@) { print "nok 7\n" } else { print "ok 7\n"; }

eval {

    die '$foo still incrementing' unless ($foo == $last);
    $last=$bar;
};

if ($@) { print "nok 8\n" } else { print "ok 8\n"; }

eval {

    die '$bar not incrementing' unless ($bar > $last);

};

if ($@) { print "nok 9\n" } else { print "ok 9\n"; }

eval {

    finish_test1($h2);
    $last=$bar;
}; 

if ($@) { print "nok 10\n" } else { print "ok 10\n"; }

eval {

    die '$bar still incrementing' unless ($bar == $last);
};

if ($@) { print "nok 11\n" } else { print "ok 11\n"; }
