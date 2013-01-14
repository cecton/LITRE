use 5.006;
use strict;
use warnings;

package LITRE::Boolean::Translate;

use Test::More;
use Data::Dumper;

use LITRE::Translate qw/translate/;

my $test_count = 0;

# Can have a If statement
{
    my $expr = ['?', ['=', 1, 1], 'a', 'b'];
    my $eval = translate($expr);

    isa_ok($eval, 'LITRE::Expression::If');
    isa_ok($eval, 'LITRE::Expression');
    isa_ok($eval->{condition}, 'LITRE::Expression::Boolean');

    $test_count += 3;
}

# Can have Boolean statements
{
    my %operators = (
            (map {$_ => 'LITRE::Expression::Boolean::Numeric'}
                qw(= =/ =/= < <= > >=)),
            (map {$_ => 'LITRE::Expression::Boolean::Boolean'}
                qw(and && or ||)),
        );

    while( my($op,$expectedType) = each %operators ) {
        my $expr = [$op, 1, 1];
        my $eval = translate($expr);

        isa_ok($eval, $expectedType);
        isa_ok($eval, 'LITRE::Expression::Boolean');
        isa_ok($eval, 'LITRE::Expression');

        $test_count += 3;
    }
}

# Check types
{
    my %types = (
            (map {$_ => 'LITRE::Type::Int'}
                qw/-2000000 -2 0 2 2000000/),
            (map {$_ => 'LITRE::Type::Float'}
                qw/-2000000.2 -2.0 0.0 2.2 2000000.0/),
            (map {$_ => 'LITRE::Type::String'}
                'abc', '{(}*!#)'),
        );

    while( my($v,$expectedType) = each %types ) {
        my $eval = translate($v);

        isa_ok($eval, $expectedType);
        isa_ok($eval, 'LITRE::Type');

        $test_count += 2;
    }

    for my $v (qw/NaN nan Nan NAN/) {
        my $eval = translate($v);

        isa_ok($eval, 'LITRE::Type::Float');
        isa_ok($eval, 'LITRE::Type');
        ok($eval->isnan, "Number is NaN");

        $test_count += 3;
    }

    for my $v (qw/Inf inf INF/) {
        my $eval = translate($v);

        isa_ok($eval, 'LITRE::Type::Float');
        isa_ok($eval, 'LITRE::Type');
        ok($eval->isinf, "Number is Inf");

        $test_count += 3;
    }
}

done_testing( $test_count );

1;
