use strict;
use warnings;

use Bit::Manip qw(:all);
use Test::More;

{ # 0xFF

    my $d = 0xFFFF; # 65535
    my $s = 16;
    my $c = 16;

    for (0..15){
        my $exp = (2 ** $c) - 1;
        $c--;

        my $r = bit_get($d, $s, $_);
        is $r, $exp, "d: $d, s: $s, e: $_, == $r ok";
    }
}

{ # bad params

    my $d = 0xFF;
    my $ok;

    # first == -1

    $ok = eval { bit_get($d, -1); 1; };
    is $ok, undef, "first param -1 dies ok";
    like $@, qr/\$first param/, "...with ok error";

    # last == -1

    $ok = eval { bit_get($d, 16, -1); 1; };
    is $ok, undef, "last param -1 dies ok";
    like $@, qr/\$last param/, "...with ok error";

    # last < first

    $ok = eval { bit_get($d, 8, 9); 1; };
    is $ok, undef, "last < first dies ok";
    like $@, qr/\$last param/, "...with ok error";

     # last == first

    $ok = eval { bit_get($d, 8, 8); 1; };
    is $ok, undef, "last == first dies ok";
    like $@, qr/\$last param/, "...with ok error";
}
done_testing();
