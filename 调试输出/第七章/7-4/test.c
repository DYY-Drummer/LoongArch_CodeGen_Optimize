int test_select()
{
    int a = 1;
    int b = 0;
    b = !a ? 1:2;
    return b;
}


int g1 = 1;
int g2 = 2;
int g3 = 100;
int g4 = 50;
int test_select_global()
{
    if (g1 < g2)
        return g3;
    else
        return g4;
}
