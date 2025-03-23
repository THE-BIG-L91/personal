#include <stdio.h>

int reduce_by_amount(int x, int amount){
	int quotient = x/amount;
	printf("$%d bills: %d\n", amount , quotient);	
	return x - (amount*quotient);
}

int main(){
	int cash_amount;
	printf("Enter a dollar amount: ");
	scanf("%d", &cash_amount);
	
	cash_amount = reduce_by_amount(cash_amount, 20);
	cash_amount = reduce_by_amount(cash_amount, 10);
	cash_amount = reduce_by_amount(cash_amount, 5);
	printf("$1 bills: %d\n",cash_amount);
	return 0;
}