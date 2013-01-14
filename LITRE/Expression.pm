use 5.006;
use strict;
use warnings;


package LITRE::Expression;

1;


package LITRE::Expression::Boolean;
use parent -norequire, qw/LITRE::Expression/;

1;


package LITRE::Expression::Boolean::Boolean;
use parent -norequire, qw/LITRE::Expression::Boolean/;

1;


package LITRE::Expression::Boolean::Numeric;
use parent -norequire, qw/LITRE::Expression::Boolean/;

1;


package LITRE::Expression::If;
use parent -norequire, qw/LITRE::Expression/;

1;
