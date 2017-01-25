use warnings;
use strict;
use feature 'say';

use Bit::Manip::PP qw(:all);

my $data = bit_on(0, 15);

$data = bit_set($data, 13, 0b11);
say bit_bin($data);

$data = bit_set($data, 11, 0b01);
say bit_bin($data);

$data = bit_set($data, 0, 186);
say bit_bin($data);

$data = bit_set($data, 13, 0b01);
say bit_bin($data);

$data = bit_off($data, 14);
say bit_bin($data);

say "break";

say bit_bin(bit_get($data, 10, 8));


