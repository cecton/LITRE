use 5.006;
use strict;
use warnings;

package LITRE::Test::Parser;

use Test::More;
use Data::Dumper;

use LITRE;

my %samples = (
        '(a (bb "ccc \\"dddd\\"" (e\\(f" g d (i))) j\\ k)'
        => ['a', ['bb', 'ccc \\"dddd\\"', ['e\\(f"', 'g', 'd', ['i']]], 'j\\ k'],
    );

done_testing( scalar(keys %samples) );

while( my($sample,$expected) = each %samples ) {

    my($list, $rest) = LITRE::parse_list($sample);

    my($dump_sample, $dump_expected) = (Dumper($list), Dumper($expected));

    ok( $dump_sample eq $dump_expected,
        $sample);

}

1;
