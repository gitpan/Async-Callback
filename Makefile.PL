use ExtUtils::MakeMaker;
use Config;

$| = 1;
$dflgs = '';
$libs = '';

print "\nConfiguring Async::Callback\n\n";

if ($Config{libs} =~ /-lpthread/) {
    print "Pthreads detected, adding mutex support\n";
    $dflgs = "-DCALLBACK_USE_PTHREADS";
    $libs = "-lpthread";
} else {
    print "No supported threading library found (mutex support disabled)\n";
}

my ($incpath) = split(/\s+/, $Config{locincpth});

print "\nEnter path to install Callback.h in: [$incpath] ";

my $newinc = <>;

chomp $newinc;

if (length($newinc)) {
    $incpath = $newinc;
}

print "\nWill install Callback.h in $incpath/Callback.h\n";

# Hijack INSTALLSCRIPT to cheat and install our header file... :-(

WriteMakefile(
    'NAME'		=> 'Async::Callback',
    'VERSION_FROM'	=> 'Callback.pm',
    'PREREQ_PM'		=> {},
    ($] >= 5.005 ?
      (ABSTRACT_FROM => 'Callback.pm',
       AUTHOR     => 'David M. Lloyd <dmlloyd@tds.net>') : ()),
    'LIBS'		=> [$libs],
    'H'     	    	=> 'Callback.h',
    'OPTIMIZE'		=> ' ',
    'CCFLAGS'		=> '-g',
    'DEFINE'		=> $dflgs,
    'INC'		=> '',
    'INST_SCRIPT'   	=> 'blib/inc',
    'INSTALLSCRIPT' 	=> $incpath,
    'EXE_FILES'     	=> ['Callback.h'],
);
