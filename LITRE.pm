use 5.006;
use strict;
use warnings;

package LITRE;

sub parse_atom()
{
    return unless $_;
    my $atom;
    if( s/^["']// ) {
        my $delimiter = $&;
        s/((?:[^$delimiter]+|\\$delimiter)*)(?:(?<!\\)$delimiter)//
            and $atom = $1
            or die "Cannot find end string delimiter $delimiter near `"
                   .substr($_,0,10)."'\n";
    } elsif( s/^(?:[^\s()\\]+|\\.)+// ) {
        $atom = $&;
    }
    $atom =~ s/\\(.)/$1/g;
    $atom
}

sub parse_list() { [&parse] if s/^\(// and not m/^\)/ }

sub parse
{
    @_ and local $_ = shift();
    my @expr;
    my $sub_expr;
    my $atom;
    while( $_ ) {
        s/^\s+//;
        return @expr if s/^\)//;
        ($sub_expr = &parse_list)
            and (push @expr, $sub_expr)
            or ($atom = &parse_atom)
                and (push @expr, $atom)
                or (die "Cannot parse: $_\n");
    }
    @expr
}

1;
