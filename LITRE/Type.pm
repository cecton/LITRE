use 5.006;
use strict;
use warnings;


package LITRE::Type;

use Scalar::Util::Numeric qw/isint isfloat isinf isnan/;

use base 'Exporter';
our @EXPORT_OK = qw/get_type/;

our @knownTypes = qw/NaN Inf Float Int/;
our %testType = (
        Int => \&isint,
        Float => \&isfloat,
        Inf => \&isinf,
        NaN => \&isnan,
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

1;


package LITRE::Type::Inf;
use parent -norequire, qw/LITRE::Type/;

1;


package LITRE::Type::NaN;
use parent -norequire, qw/LITRE::Type/;

1;
