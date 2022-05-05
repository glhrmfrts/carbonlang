#include <stdio.h>

int arr[32];
int otherarr[64];

static const char* msg = "Hello World\n";
static int global_first;
static int global_second = 3;

static short global_short = 12;

static void testf(int a, int b, const char* msg) {
    struct { long long a; long long b; } localarr[64];
    if (a == 1 && b == 2) {
        arr[0] = a;
        arr[1] = b;
        localarr[a].a = 10;
        localarr[b].b = 20;
        puts(msg);
    }
}

int main() {
    testf(1, 2, msg);
    return 0;
}