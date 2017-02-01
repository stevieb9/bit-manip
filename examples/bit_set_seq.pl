use warnings;
use strict;
use feature 'say';

use Bit::Manip qw(:all);

for (0..11){
    my $r = bit_set_seq(0x00, [0, 2, 1, 3], $_);
    printf("%b: %b\n", $_, $r);
}
