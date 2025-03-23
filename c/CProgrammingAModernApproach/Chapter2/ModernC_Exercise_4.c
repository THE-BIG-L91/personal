#include <stdio.h>

int main(){
	float amount;

	printf("Enter amount in dollars-and-cents: ");
	scanf("%f",&amount);
	printf("With tax added: %f", (amount + (amount * 0.05)));

	return 0;
}s