use warnings;
use strict;
use feature 'say';

use Bit::Manip qw(:all);
use Test::More;

# out of order sequence

for (0..11){
    bit_set_seq(0x00, [3, 1, 2, 0], $_);
}

# skip over

for (0..11){
    my $b = $_;
    $b = bit_on($b, 1);
    $b = bit_on($b, 2);
    bit_set_skip($b, [0, 3], $_);
}

sub bit_set_seq {
    my ($b, $seq, $val) = @_;

    my $lsb = (sort @$seq)[0];
    my $msb = (sort @$seq)[-1];

    my $nbits = ($msb - $lsb);

    $b = bit_set($b, $lsb, $nbits, $val);

    my $x = $b;

    for (0..$nbits){
        my $o = bit_get($b, $_, $_);
        my $s = bit_get($b, $seq->[$_], $seq->[$_]);
        
        if ($o != $s){
            $x = bit_set($x, $_, 1, $s);
        }     
    }
}
sub bit_set_skip {
    my ($b, $seq, $val) = @_;

    my $lsb = (sort @$seq)[0];
    my $msb = (sort @$seq)[-1];

    my @leave_bits 
      = map $seq->[$_-1]+1..$seq->[$_]-1, 1..@$seq-1;

    my %leave_vals 
      = map {$_ => bit_get($b, $_, $_)} @leave_bits;

    my $nbits = ($msb - $lsb) + 1;

    $b = bit_set($b, $lsb, $nbits, $val);

    say "** $val";

    printf("skip before: %b\n", $b);

    for (keys %leave_vals){
        $b = bit_set($b, $_, 1, $leave_vals{$_});
    }

    printf("skip after:  %b\n\n", $b);
}
