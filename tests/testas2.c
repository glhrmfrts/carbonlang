#include <stdio.h>

int* pointer_to_int;

static short some_data[32] = { 0, 1, 2, 3 };

int other_value = 5;

static int nice_value;

int main() {    
    other_value = 32;
    nice_value = 44;
    pointer_to_int = &other_value;
    puts("Hello");
    return 0;
}