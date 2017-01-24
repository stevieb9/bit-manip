package Bit::Manip;

use warnings;
use strict;

our $VERSION = '0.01';

require XSLoader;
XSLoader::load('Bit::Manip', $VERSION);

use Exporter qw(import);

our @EXPORT_OK = qw(bit_count bit_get bit_set bit_clear bit_toggle);
our %EXPORT_TAGS;
$EXPORT_TAGS{all} = [@EXPORT_OK];

sub bit_count {
    my ($n, $set) = @_;

    if (! defined $n || $n !~ /^\d+/){
        die "bit_count() requires an integer param\n";
    }

    $set = 0 if ! defined $set;

    return _bit_count($n, $set);
}
sub bit_get {
    my ($data, $first, $last) = @_;

    $last = 0 if ! defined $last;

    _bit_get($data, $first, $last);
}
sub bit_set {
    my ($data, $first, $value) = @_;
    _bit_set($data, $first, $value);
}

1;
__END__

=head1 NAME

Bit::Manip - Routines to aid in bit manipulation

=head1 SYNOPSIS

=head1 DESCRIPTION

Provides functions to aid in bit manipulation (set, unset, toggle, shifting)
etc. Particularly useful for embedded programming and writing device
communication software.

=head1 EXPORT_OK

=head1 FUNCTIONS

=head2 bit_count

Returns either the total count of bits in a number, or just the number of set
bits (if the C<$set>, parameter is sent in and is true).

Parameters:

    $num

Mandatory: Unsigned integer, the number to retrieve the total number of bits
for. For example, if you send in C<15>, the total number of bits would be C<4>,
likewise, for C<255>, the number of bits would be C<16>.

    $set

Optional: Integer. If this is sent and is a true value, we'll return the number
of *set* bits only. For example, for C<255>, the set bits will be C<8> (ie. all
of them), and for C<8>, the return will be C<1> (as only the MSB is set out of
all four of the total).

=head2 bit_get

Retrieves the value of specified bits within a bit string.

Parameters:

    $data

Mandatory: Integer, the bit string you want to send in. Eg: C<255> for
C<11111111> (or C<0xFF>).

    $first

Mandatory: Integer, the Most Significant Bit (leftmost) of the group of bits to
collect the value for (starting from 0 from the right, so with C<1000>, so you'd
send in C<3> as the start parameter for the bit set to C<1>). Must be C<1>

    $last

Optional: Integer, the Least Significant Bit (rightmost) of the group of bits to
collect the value for (starting at 0 from the right). A value of C<0> means
return the value from C<$first> through to the very end of the bit string. A
value of C<1> will capture from C<$first> through to bit C<1> (second from
right). This value must be lower than C<$first>.

=head1 AUTHOR

Steve Bertrand, C<< <steveb at cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2017 Steve Bertrand.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See L<http://dev.perl.org/licenses/> for more information.
