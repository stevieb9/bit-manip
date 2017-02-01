#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <stdio.h>
#include <stdint.h>

#define MULT 2

// declarations

int _bit_count (unsigned int value, int set);
int _bit_mask (unsigned int bits, int lsb);
int _bit_get (const unsigned int data, int msb, const int lsb);
int _bit_set (unsigned int data, int lsb, int bits, int value);
int _bit_set_seq (unsigned int data, unsigned char* seq, int lsb, int msb, int val);
int _bit_toggle (unsigned int data, int bit);
int _bit_on (unsigned int data, int bit);
int _bit_off (unsigned int data, int bit);

void __check_msb (int msb);
void __check_lsb (int msb, int lsb);
void __check_value (int value);

// definitions

int _bit_count (unsigned int value, int set){

    unsigned int bit_count;
    unsigned int c = 0;

    if (set){
        while (value != 0){
            c++;
            value &= value - 1;
        }
        bit_count = c;
    }
    else {
        int zeros = __builtin_clz(value);
        bit_count = (sizeof(int) * 8) - zeros;
    }

    return bit_count;
}

int _bit_mask (unsigned int bits, int lsb){
    return ((int)pow(MULT, bits) - 1) << lsb;
}

int _bit_get (const unsigned int data, int msb, const int lsb){

    __check_msb(msb);
    msb++; // we count from 1

    __check_lsb(msb, lsb);

    return (data & (int)pow(MULT, msb)-1) >> lsb;
}

int _bit_set (unsigned int data, int lsb, int bits, int value){

    __check_value(value);

    unsigned int value_bits = _bit_count(value, 0);

    if (value_bits != bits){
        value_bits = bits;
    }

    unsigned int mask = ((int)pow(MULT, value_bits) - 1) << lsb;
    
    data = (data & ~(mask)) | (value << lsb);

    return data;
}

int _bit_set_seq (unsigned int data, unsigned char* seq, int lsb, int msb, int val){

    unsigned char nbits = (msb - lsb);

    data = _bit_set(data, lsb, nbits, val);

    unsigned int sequenced = data;

    int i;

    for (i=0; i<nbits; i++){
        int o = _bit_get(data, i, i);
        int s = _bit_get(data, seq[i], seq[i]);

        if (o != s){
            sequenced = _bit_set(sequenced, i, 1, s);
        }
    }

    return sequenced;
}

/*
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
*/
int _bit_toggle(unsigned int data, int bit){
    return data ^= 1 << bit;
}

int _bit_on(unsigned int data, int bit){
    return data |= 1 << bit;
}

int _bit_off(unsigned int data, int bit){
    return data &= ~(1 << bit);
}

void __check_msb (int msb){
    if (msb < 0)
        croak("\nbit_get() $msb param must be greater than zero\n\n");
}

void __check_lsb (int msb, int lsb){
    if (lsb < 0)
        croak("\nbit_get() $lsb param can not be negative\n\n");

    if (lsb + 1 > (msb))
        croak("\nbit_get() $lsb param must be less than or equal to $msb\n\n");
}

void __check_value (int value){
    if (value < 0)
        croak("\nbit_set() $value param must be zero or greater\n\n");
}


MODULE = Bit::Manip  PACKAGE = Bit::Manip

PROTOTYPES: DISABLE

int
_bit_count (value, set)
    int value
    int set

int
_bit_mask (bits, lsb)
	int bits
	int	lsb

int
_bit_get (data, msb, lsb)
	int data
	int	msb
	int	lsb

int
_bit_set (data, lsb, bits, value)
    int data
    int lsb
    int bits
    int value

int
_bit_set_seq (data, seq, lsb, msb, val)
    int data
    char* seq
    int lsb
    int msb
    int val

int
_bit_toggle (data, bit)
    int data
    int bit

int
_bit_on (data, bit)
    int data
    int bit

int
_bit_off (data, bit)
    int data
    int bit
