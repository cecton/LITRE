use 5.006;
use strict;
use warnings;

package LITRE;

sub parse_value
{
    my $s = shift;
    $s =~ s/^\s+//;
    if( $s =~ s/^["']// ) {
        my $delimiter = $&;
        $s =~ s/((?:[^$delimiter]+|\\$delimiter)*)(?:(?<!\\)$delimiter)//
            or die "Cannot find end string delimiter $delimiter near `"
                   .substr($s,0,10)."'\n";
        my $v = $1;
        return $v, $s;
    } elsif( $s =~ s/^(?:[^\s()\\]+|\\.)+// ) {
        return $&, $s;
    }
    die "Cannot parse empty values!\n";
}

sub parse_list
{
    my $s = shift;
    my @list;
    if( $s =~ s/^\s*\(// ) {
        while( not $s =~ s/^\)// ) {
            die "Not terminated list!\n" unless $s;
            if( $s =~ m/^\s*\(/ ) {
                (my($sub_list), $s) = parse_list($s);
                push @list, $sub_list;
            } else {
                (my($v), $s) = parse_value($s);
                push @list, $v;
            }
        }
        return \@list, $s;
    }
    die "Cannot parse list near: ".substr($s,0,10)."\n";
}

1;
