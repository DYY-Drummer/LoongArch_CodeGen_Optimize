int sum(int x1, int x2, int x3, int x4, int x5, int x6, int x7, int x8, int x9)
{
    int sum = x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8 + x9;
    return sum;
}

int sub(int x1, int x2)
{
    int sub=x1-x2;
    return sub;
}

int main()
{
    int a = sum(1, 2, 3, 4, 5, 6, 7, 8, 9);
    int b = sub (1, 2);
    return a + b;
}