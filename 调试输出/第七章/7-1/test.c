
int test_JumpTable()
{
    unsigned char flag[3] = {0x21, 0x22, 0x23};
    int Result = 0;
    switch (flag[0])
    {
        case 0x21:
            Result = 1;
            break;
        case 0x22:
            Result = 2;
            break;
        case 0x23:
            Result = 3;
            break;
        default:
            Result = -1;
    }
    return Result;
}

int test_BlockAddress()
{
    int a = 26;

    if (a > 0) {
        goto Label;
    }
    return 1;

    Label:
    return 0;
}

int test_if_while_for_continue_break()
{
    unsigned int a = 0;
    int b = 26;
    int i = 3;

    for (i = 0; i <= 3; i++) {
        a = a + i;
    }
    if (b == 0) {
        b--;
    }else if (b > 0) {
        b++;
    }

    while (i < 100) {
        a++;
        i++;
        if (a < 10)
            continue;
        else
            break;
    }

    return (a+b);
}
