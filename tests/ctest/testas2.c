#include <stdio.h>
#include <stdbool.h>
#include <unistd.h>

/*
int* pointer_to_int;
static char some_data[32] = { 0, 1, 2, 3 };
int other_value = 5;
static int nice_value;
*/

static char alone_char = 3;

static char some_data[] = { 4,5,6,7,8,9,4,5,6,7,8,9,4,5,6,7,8,9,4,5,6,7,8,9,4,5,6,7,8,9,0,1 };

int main() {    
    static int is_true;
    static int count;
    count += 1;

    is_true = count > 0;
    if (is_true) {
        puts("Hello");
    }

    printf("sizeof(bool) = %zu\n", sizeof(bool));
    printf("pagesize = %ld\n", sysconf(_SC_PAGESIZE));
    return 0;
}