
#include <math.h> // for testing only!
#include <stdlib.h>
#include <stdio.h>

#define cordic_1K 0x26DD3B6A
#define half_pi 0x6487ED51
#define MUL 1073741824.000000
#define CORDIC_NTAB 32
int cordic_ctab [] = {0x3243F6A8, 0x1DAC6705, 0x0FADBAFC, 0x07F56EA6, 0x03FEAB76, 0x01FFD55B, 
0x00FFFAAA, 0x007FFF55, 0x003FFFEA, 0x001FFFFD, 0x000FFFFF, 0x0007FFFF, 0x0003FFFF, 
0x0001FFFF, 0x0000FFFF, 0x00007FFF, 0x00003FFF, 0x00001FFF, 0x00000FFF, 0x000007FF, 
0x000003FF, 0x000001FF, 0x000000FF, 0x0000007F, 0x0000003F, 0x0000001F, 0x0000000F, 
0x00000008, 0x00000004, 0x00000002, 0x00000001, 0x00000000, };

void cordic(int theta, int *s, int *c, int n)
{
    int k, d, tx, ty, tz;
    int x=cordic_1K,y=0,z=theta;
    n = (n>CORDIC_NTAB) ? CORDIC_NTAB : n;
    for (k=0; k<n; ++k)
    {
        d = z>>31;
        if (d >= 0) {
            tx = x - (y>>k);
            ty = y + (x>>k);
            tz = z - cordic_ctab[k];
        }
        else {
            tx = x - -1*(y>>k);
            ty = y + -1*(x>>k);
            tz = z - -1*(cordic_ctab[k]);
        }
        x = tx; y = ty; z = tz;
    }  
    *c = x; *s = y;
}

//Print out sin(x) vs fp CORDIC sin(x)
int main(int argc, char **argv)
{
    double p;
    int s,c;
    double rad = ((3.14159)/180) * 30;
    cordic((rad*MUL), &s, &c, 32);
    printf("%lf\n", s/MUL);
}
