use 5.006;
use strict;
use warnings;

package LITRE::Test::Translate;

use Test::More;
use Data::Dumper;

use LITRE::Translate qw/translate/;

my $test_count = 0;

# Can have a If statement
{
    my $expr = ['?', ['=', 1, 1], 'a', 'b'];
    my $eval = translate($expr);

    isa_ok($eval, 'LITRE::Statement::If');
    isa_ok($eval, 'LITRE::Statement');
    isa_ok($eval->{condition}, 'LITRE::Statement::Test');

    $test_count += 3;
}

# Can have Test statements
{
    my %operators = (
            (map {$_ => 'LITRE::Statement::NumericTest'}
                qw(= =/ =/= < <= > >=)),
            (map {$_ => 'LITRE::Statement::BooleanTest'}
                qw(and && or ||)),
        );

    while( my($op,$expectedType) = each %operators ) {
        my $expr = [$op, 1, 1];
        my $eval = translate($expr);

        isa_ok($eval, $expectedType);
        isa_ok($eval, 'LITRE::Statement::Test');
        isa_ok($eval, 'LITRE::Statement');

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
            (map {$_ => 'LITRE::Type::NaN'}
                qw/NaN nan Nan NAN/),
            (map {$_ => 'LITRE::Type::Inf'}
                qw/Inf inf INF/),
            (map {$_ => 'LITRE::Type::String'}
                'abc', '{(}*!#)'),
        );

    while( my($v,$expectedType) = each %types ) {
        my $eval = translate($v);

        isa_ok($eval, $expectedType);
        isa_ok($eval, 'LITRE::Type');

        $test_count += 2;
    }
}

done_testing( $test_count );

1;
