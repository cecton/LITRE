use 5.006;
use strict;
use warnings;

package LITRE;

sub parse_atom
{
    @_ and local $_ = shift();
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

sub parse_list
{
    @_ and local $_ = shift();
    return unless s/^\(// and not m/^\)/;
    my @list;
    my $parsed;
    push @list, $parsed while $_ and $parsed = &parse;
    \@list
}

sub parse
{
    @_ and local $_ = shift();
    return unless $_;
    my $list;
    my $atom;
    s/^\s+//;
    return if s/^\)//;
    ($list = &parse_list)
        and return $list
        or ($atom = &parse_atom)
            and return $atom
            or die "Cannot parse: ".substr($_,0,10)."\n"
}

1;
