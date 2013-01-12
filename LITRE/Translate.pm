use 5.006;
use strict;
use warnings;


package LITRE::Translate;

use LITRE::Statement;
use LITRE::Type qw/get_type/;
use Data::Dumper;

use base 'Exporter';
our(@EXPORT_OK) = qw/translate/;

sub translate
{
    my $expr = shift;

    if( ref $expr eq 'ARRAY' ) {
        return LITRE::Statement->bless($expr, \&translate);
    } else {
        die "Not implemented undef value!\n" unless defined $expr;
        return get_type($expr)
    }
}

1;
