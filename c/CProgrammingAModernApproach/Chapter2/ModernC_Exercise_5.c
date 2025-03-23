#include <stdio.h>

int int_exp(float x, int base){
	int answer = x;
	for (int i=1; i<base; i++){
		answer *= x;
	}
	return answer;
}

int P(int x){
	return (3*int_exp(x,5)) + 2*(int_exp(x,4)) - 5*(int_exp(x,3)) -(int_exp(x,2)) + 7*(x) - 6;
}

int main(){
	int x;
	printf("Enter an integer value for x: ");
	scanf("%d",&x);
	printf("P(x) = %d",P(x));

	return 0;
}