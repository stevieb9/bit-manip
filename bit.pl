use warnings;
use strict;
use feature 'say';

use Bit::Manip qw(:all);
use Test::More;

is bin(bit_set(8, 0, 0b1)), '1001', "8, 0, 1 ok";
is bin(bit_set(8, 1, 0b1)), '1010', "8, 1, 1 ok";
is bin(bit_set(8, 2, 0b1)), '1100', "8, 2, 1 ok";

is bin(bit_set(8, 0, 0b111)), '1111', "8, 0, 0b111 ok";
is bin(bit_set(8, 1, 0b011)), '1110', "8, 1, 0b11 ok";
is bin(bit_set(8, 2, 0b1)), '1100', "8, 2, 0b01 ok";

sub bin {
    return sprintf "%b", $_[0];
}

done_testing();

__END__
$x = bit_set(128, 0, 1);
printf("%d: %b\n", $x, $x);

$x = bit_set(128, 1, 1);
printf("%d: %b\n", $x, $x);

$x = bit_set(128, 2, 1);
printf("%d: %b\n", $x, $x);

$x = bit_set(128, 3, 1);
printf("%d: %b\n", $x, $x);

$x = bit_set(128, 4, 1);
printf("%d: %b\n", $x, $x);

$x = bit_set(128, 5, 1);
printf("%d: %b\n", $x, $x);


say "bit 2";

$x = bit_set(128, 2, 0);
printf("%d: %b\n", $x, $x);

$x = bit_set(128, 2, 1);
printf("%d: %b\n", $x, $x);

$x = bit_set(128, 2, 2);
printf("%d: %b\n", $x, $x);

$x = bit_set(128, 2, 3);
printf("%d: %b\n", $x, $x);

say "bit 3";

$x = bit_set(128, 3, 0b11);
printf("%d: %b\n", $x, $x);

$x = bit_set(128, 3, 0b111);
printf("%d: %b\n", $x, $x);

$x = bit_set(255, 0, 0b0);
printf("%d: %b\n", $x, $x);

__END__

is bit_set(128, 0, 1), 129, "128, 0, 1 ok";
is bit_set(2, 0, 1), 3, "2, 0, 1 ok";

is bit_set(0, 5, 0b10), 256, "255, 0, 1 ok";

done_testing();
