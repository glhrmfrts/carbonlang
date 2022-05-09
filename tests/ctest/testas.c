#include <stdio.h>

extern int some_begin;
extern int some_end;

int main() {
    int* addr_begin = &some_begin;
    int* addr_end = &some_end;

    printf("some_begin: %d, some_end: %d\n", *addr_begin, *addr_end);

    return *addr_begin + *addr_end;
}