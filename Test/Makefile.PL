use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'		=> 'Async::Callback::Test',
    'VERSION_FROM'	=> '../Callback.pm',
    'PREREQ_PM'		=> {},
    'LIBS'		=> [''],
    'DEFINE'		=> '',
    'INC'		=> '-I..',
);
