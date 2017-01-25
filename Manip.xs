#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <string.h>
#include <stdio.h>
#include <stdint.h>

#define MULT 2

// declarations

int _bit_count (unsigned int value, int set);
int _bit_get (const unsigned int data, int first, const int last);
int _bit_set (unsigned int data, int lsb, int value);
int _bit_toggle (unsigned int data, int bit);
int _bit_on (unsigned int data, int bit);
int _bit_off (unsigned int data, int bit);

void __check_first(int first);
void __check_last(int first, int last);
void __check_value(int value);

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

int _bit_get (const unsigned int data, int first, const int last){

    __check_first(first);
    first++; // we count from 1

    __check_last(first, last);

    return (data & (int)pow(MULT, first)-1) >> last;
}

int _bit_set (unsigned int data, int lsb, int value){

    __check_value(value);

    unsigned int shift_bits = _bit_count(value, 0);
    unsigned int mask = ((int)pow(MULT, shift_bits) - 1) << lsb;
    
    data = (data & (~mask)) | (value << lsb);

    return data;
}

int _bit_toggle(unsigned int data, int bit){
    return data ^= 1 << bit;
}

int _bit_on(unsigned int data, int bit){
    return data |= 1 << bit;
}

int _bit_off(unsigned int data, int bit){
    return data &= ~(1 << bit);
}

void __check_first (int first){
    if (first < 0)
        croak("\nbit_get() $first param must be greater than zero\n\n");
}

void __check_last (int first, int last){
    if (last < 0)
        croak("\nbit_get() $last param can not be negative\n\n");

    if (last + 1 >= (first))
        croak("\nbit_get() $last param must be less than $first\n\n");
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
_bit_get (data, first, last)
	int data
	int	first
	int	last

int
_bit_set (data, first, value)
    int data
    int first
    int value

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
