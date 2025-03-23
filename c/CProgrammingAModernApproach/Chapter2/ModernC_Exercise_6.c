#include <stdio.h>

int P(int x){
	return ((((((((3*x + 2)*x)-5)*x) - 1)*x) + 7)*x) - 6;
}

int main(){
	int x;
	printf("Enter an integer value for x: ");
	scanf("%d",&x);
	printf("P(x) = %d",P(x));
	return 0;
}