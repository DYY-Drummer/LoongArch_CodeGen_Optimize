int test_Float() {
    float a=2.6, b=1.0, c;
    c = a + b;
    return (int)c;
}

double test_Double() {
    double a=2.6, b=1.0, c;
    c = a + b;
    return c;
}

int test_sqrt() {
    int base;
    base = __builtin_sqrt(36);
    return base;
}
