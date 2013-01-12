use 5.006;
use strict;
use warnings;

package LITRE::Test::Parser;

use Test::More;
use Data::Dumper;

use LITRE::Parser;

my %samples = (
        '(a (bb "ccc \\"dddd\\"" (e\\(f" gg\\\\gg d (i))) j\\ k)'
        => ['a', ['bb', 'ccc "dddd"', ['e(f"', 'gg\\gg', 'd', ['i']]], 'j k'],

        '(a () () b (()) (((()))))'
        => ['a', [], [], 'b', [[]], [[[[]]]]],
    );

done_testing( scalar(keys %samples) + 4 );

while( my($sample,$expected) = each %samples ) {

    my($expr,@rest) = LITRE::Parser::parse($sample);

    my($dump_sample, $dump_expected) = (Dumper($expr), Dumper($expected));

    ok( $dump_sample eq $dump_expected,
        $sample);

}

$_ = "a b";
my $expr = LITRE::Parser::parse;
ok($expr eq 'a', "'a' is parsed from 'a b'");
ok($_ eq ' b', "' b' rest from 'a b'");

$expr = LITRE::Parser::parse($_ = "a b");
ok($expr eq 'a', "'a' is parsed from 'a b'");
ok($_ eq 'a b', "\$_ is untouched");

1;
