static int i = 3;

int f(int x) {
    return x*2;
}

int main() {
    return (i*7) + (50*f(1)) + (f(2)*70 + 23 + (f(3)*4));
}