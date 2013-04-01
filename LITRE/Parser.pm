use 5.006;
use strict;
use warnings;

package LITRE::Parser;

sub parse_atom
{
    @_ and local $_ = shift();
    return unless m/^[^)]/;
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

sub parse_list
{
    @_ and local $_ = shift();
    return unless s/^\(//;
    my @list;
    my $parsed;
    push @list, $parsed while $_ and ($parsed = &parse) or not s/^\)//;
    \@list
}

sub parse
{
    @_ and local $_ = shift();
    return unless $_;
    my $list;
    my $atom;
    s/^\s+//;

    &parse_list or &parse_atom
}

1;
