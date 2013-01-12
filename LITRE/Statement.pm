use 5.006;
use strict;
use warnings;


package LITRE::Statement;

sub bless($$$)
{
    my $class = shift;
    LITRE::Statement::BooleanTest->bless(@_) or
    LITRE::Statement::NumericTest->bless(@_) or
    LITRE::Statement::If->bless(@_) or
    shift
}

1;


package LITRE::Statement::Test;
use parent -norequire, qw/LITRE::Statement/;

1;


package LITRE::Statement::BooleanTest;
use parent -norequire, qw/LITRE::Statement::Test/;

sub bless($$$)
{
    my($class,$expr,$translator) = @_;
    if( $expr->[0] =~ m/^(?:and|&&|or|\|\|)$/ ) {
        my($op,@values) = @$expr;
        return bless {
                operator => $op,
                values => [map {$translator->($_)} @values],
            }, $class;
    }
}

1;


package LITRE::Statement::NumericTest;
use parent -norequire, qw/LITRE::Statement::Test/;

sub bless($$$)
{
    my($class,$expr,$translator) = @_;
    if( $expr->[0] =~ m/^(?:=|=\/=?|<=?|>=?)$/ ) {
        my($op,@values) = @$expr;
        return bless {
                operator => $op,
                values => [map {$translator->($_)} @values],
            }, $class
    }
}

1;


package LITRE::Statement::If;
use parent -norequire, qw/LITRE::Statement/;

sub bless($$$)
{
    my($class,$expr,$translator) = @_;
    if( $expr->[0] =~ m/^(?:\?|if)$/ ) {
        my($op,$expression,$success,$failure) = @$expr;
        return bless {
                condition => $translator->($expression),
                on_success => $translator->($success),
                on_failure => $translator->($failure),
            }, $class
    }
}

1;
