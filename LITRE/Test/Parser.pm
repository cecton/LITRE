use 5.006;
use strict;
use warnings;

package LITRE::Test::Parser;

use Test::More;
use Data::Dumper;

use LITRE;

my %samples = (
        '(a (bb "ccc \\"dddd\\"" (e\\(f" gg\\\\gg d (i))) j\\ k)'
        => ['a', ['bb', 'ccc "dddd"', ['e(f"', 'gg\\gg', 'd', ['i']]], 'j k'],
    );

done_testing( scalar(keys %samples) );

while( my($sample,$expected) = each %samples ) {

    my($expr,@rest) = LITRE::parse($sample);

    my($dump_sample, $dump_expected) = (Dumper($expr), Dumper($expected));

    ok( $dump_sample eq $dump_expected,
        $sample);

}

1;
