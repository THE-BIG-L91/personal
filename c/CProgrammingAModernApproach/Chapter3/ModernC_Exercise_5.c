#include <stdio.h>

int main()
{
	int a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p;
	printf("Enter the numbers from 1 to 16 in any order (in any order, space seperated) \n");
	scanf("%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d", &a, &b, &c, &d, &e, &f, &g, &h, &i, &j, &k, &l, &m, &n, &o, &p);
	printf("%d %d %d %d\n", a, b, c, d);
	printf("%d %d %d %d\n", e, f, g, h);
	printf("%d %d %d %d\n", i, j, k, l);
	printf("%d %d %d %d\n", m, n, o, p);
	printf("Row sums: %d %d %d %d\n", a + b + c + d, e + f + g + h, i + j + k + l, m + n + o + p);
	printf("Column sums: %d %d %d %d\n", a + e + i + m, b + f + j + n, c + g + k + o, d + h + l + p);
	printf("Diagonal sums: %d %d\n", a + f + k + p, d + g + j + m);
	return 0;
}