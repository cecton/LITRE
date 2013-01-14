use 5.006;
use strict;
use warnings;


package LITRE::Translate;

use LITRE::Expression;
use LITRE::Type qw/get_type/;
use Data::Dumper;

use base 'Exporter';
our(@EXPORT_OK) = qw/translate/;

sub translate
{
    my $expr = shift;

    if( ref $expr eq 'ARRAY' ) {

        if( $expr->[0] =~ m/^(?:and|&&|or|\|\|)$/ ) {
            my($op,@values) = @$expr;
            bless {
                    operator => $op,
                    values => [map {translate($_)} @values],
                }, "LITRE::Expression::Boolean::Boolean";
        }

        elsif( $expr->[0] =~ m/^(?:=|=\/=?|<=?|>=?)$/ ) {
            my($op,@values) = @$expr;
            bless {
                    operator => $op,
                    values => [map {translate($_)} @values],
                }, "LITRE::Expression::Boolean::Numeric"
        }

        elsif( $expr->[0] =~ m/^(?:\?|if)$/ ) {
            my($op,$expression,$success,$failure) = @$expr;
            bless {
                    condition => translate($expression),
                    on_success => translate($success),
                    on_failure => translate($failure),
                }, "LITRE::Expression::If"
        }

    } else {

        die "Not implemented undef value!\n" unless defined $expr;
        get_type($expr)

    }
}

1;
