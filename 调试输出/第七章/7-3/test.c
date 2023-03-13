int test_DelUselessJMP()
{
    int a = 1, b = -2;
    if (b == 0) {
        a = a + 3;
        b++;
    } else if (b < 0) {
        a = a + b;
        b--;
    }
    return a;
}