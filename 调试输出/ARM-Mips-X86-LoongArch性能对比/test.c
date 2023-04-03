const int MOD = 100005;
const int SUM = 777777;

int recur(int n){
    if(n <= 0){
        return 1;
    }
    return recur(n-1)+recur(n-2);
}

int precur(int n){
    if(n <= 0){
        return 1;
    }
    int x;
    x = precur(n-1)+precur(n-2);
    return x;
}

void mfunc(){
    int x;
    x = recur(25);

    precur(15);
}

const int N = 10;
int d[10] = {0,1,2,3,4,5,6,7,8,9};
int fib(int i) {
    if (i == 1) {
        return 1;
    }
    if (i == 2) {
        return 2;
    }
    return fib(i - 1) + fib(i - 2);
}
int main()
{
    int i = 2,j = 5;
    const int a1 = 1, a2 = 2;
    i = 4;
    j = 5;
    i = (-(i * j) * fib(4) + 0 + d[1] * 1 - 1/2) * 5;
    j = 7*5923%56*57 - fib(fib(5)+2) + (a1+a2-(89/2*36-53) /1*6-2*(45*56/85-56+35*56/4-9));
    int k = +-+6;
    i = 0;
    while (i <= 100) {
		d[0] = d[0] + k * k;
		d[1] = d[1] + k * k;
		d[2] = d[2] + k * k;
		d[3] = d[3] + k * k;
		d[4] = d[4] + k * k;
		d[5] = d[5] + k * k;
		d[6] = d[6] + k * k;
		d[7] = d[7] + k * k;
		d[8] = d[8] + k * k;
		d[9] = d[9] + k * k;
		i = i + 1;
	}
	i = 0;
	while (i < 10) {
		i = i + 1;
	}
    return 0;
}


int a[34];
int f(int a0, int a1, int a2, int a3, int a4, int a5, int a6, int a7, int a8,
      int a9, int a10, int a11, int a12, int a13, int a14, int a15, int a16,
      int a17, int a18, int a19, int a20, int a21, int a22, int a23, int a24,
      int a25, int a26, int a27, int a28, int a29, int a30, int a31, int a32) {
    a[0] = a0;
    a[1] = a1;
    a[2] = a2;
    a[3] = a3;
    a[4] = a4;
    a[5] = a5;
    a[6] = a6;
    a[7] = a7;
    a[8] = a8;
    a[9] = a9;
    a[10] = a10;
    a[11] = a11;
    a[12] = a12;
    a[13] = a13;
    a[14] = a14;
    a[15] = a15;
    a[16] = a16;
    a[17] = a17;
    a[18] = a18;
    a[19] = a19;
    a[20] = a20;
    a[21] = a21;
    a[22] = a22;
    a[23] = a23;
    a[24] = a24;
    a[25] = a25;
    a[26] = a26;
    a[27] = a27;
    a[28] = a28;
    a[29] = a29;
    a[30] = a30;
    a[31] = a31;
    a[32] = a32;
    a[33] = 1 + a1 - a1 + a2 - a2 + a3 - a3 + a4 - a4 + a5 - a5 + a6 - a6
              + a7 - a7 + a8 - a8 + a9 - a9 + a10 - a10 + a11 - a11 + a12 - a12 + a13 - a13
              + a14 - a14 + a15 - a15 + a16 - a16 + a17 - a17 + a18 - a18 + a19 - a19
              + a20 * a20 * a20  - a20 + a21 * a21 * a21 - a21 + a22 * a22 * a22 - a22
              + a23 * a23 / a23 - a23 + a24 * a24 / a24 - a24 + a25 * a25 / a25 - a25
              + a26 / a26 * a26 - a26 + a27 / a27 * a27 - a27 + a28 / a28 * a28 - a28
              + a29 / a29 / a29 - a29 + a30 / a30 / a30 - a30 + a31 / a31 / a31 - a31;
    int i = 0;
    int ans = 1;
    while(i < 12){
        a[33] = a[33] + i - i;
        i = i + 1;
    }
    a[33] = ans / a[33];
    return a[33];
}
int test() {
    int i = 0;
    while(i < 34) {
        a[i] = 1;
        i = i + 1;
    }
    int sum = 0;
    int n = 0;
    n = 1000;
    i = 4;
    while(i < n) {
        sum = sum + f(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12], a[13], a[14], a[15], a[16], a[17], a[18], a[19], a[20], a[21], a[22], a[23], a[24], a[25], a[26], a[27], a[28], a[29], a[30], a[31], a[32]);
        i = i + 1;
    }
    sum = 0;
    i = 35;
    while(i < n) {
        sum = sum + f(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12], a[13], a[14], a[15], a[16], a[17], a[18], a[19], a[20], a[21], a[22], a[23], a[24], a[25], a[26], a[27], a[28], a[29], a[30], a[31], a[32]);
        i = i + 1;
    }
    return 0;

}