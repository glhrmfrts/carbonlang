#include <stdio.h>

int main() {
    char buf[3];
    for (int i = 0; i < sizeof(buf); i++) {
        buf[i] = 0;
    }
    puts(buf);
    return 0;
}