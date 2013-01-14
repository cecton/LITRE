use 5.006;
use strict;
use warnings;


package LITRE::Type;

use Scalar::Util::Numeric qw/isint isfloat/;

use base 'Exporter';
our @EXPORT_OK = qw/get_type/;

our @knownTypes = qw/Float Int/;
our %testType = (
        Int => \&isint,
        Float => \&isfloat,
    );

sub get_type
{
    my $value = shift;
    for my $t ( @knownTypes ) {
        return "LITRE::Type::$t"->new($value) if $testType{$t}->($value)
    }
    LITRE::Type::String->new($value)
}

sub new
{
    my($class,$self) = ($_[0],\ $_[1]);
    bless $self, $class;
}

1;


package LITRE::Type::String;
use parent -norequire, qw/LITRE::Type/;

1;


package LITRE::Type::Int;
use parent -norequire, qw/LITRE::Type/;

1;


package LITRE::Type::Float;
use parent -norequire, qw/LITRE::Type/;

use Scalar::Util::Numeric;

sub isinf() { Scalar::Util::Numeric::isinf(${$_[0]}) }

sub isnan() { Scalar::Util::Numeric::isnan(${$_[0]}) }

1;
