#include <stdio.h>
#include <stdbool.h>

/*
int* pointer_to_int;
static short some_data[32] = { 0, 1, 2, 3 };
int other_value = 5;
static int nice_value;
*/

int main() {    
    static int is_true;
    static int count;
    count += 1;

    is_true = count > 0;
    if (is_true) {
        puts("Hello");
    }

    printf("sizeof(bool) = %zu\n", sizeof(bool));
    return 0;
}