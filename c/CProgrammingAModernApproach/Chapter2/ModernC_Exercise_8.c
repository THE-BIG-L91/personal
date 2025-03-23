#include <stdio.h>

int main()
{
	float amount_of_loan, interest_rate, monthly_payment;
	printf("Enter amount of loan: ");
	scanf("%f", &amount_of_loan);
	printf("Enter interest rate : ");
	scanf("%f", &interest_rate);
	printf("Enter monthly payment: ");
	scanf("%f", &monthly_payment);

	float monthly_interest_rate = ((interest_rate) / 100.0f) / 12.0f;
	amount_of_loan = (amount_of_loan - monthly_payment) + amount_of_loan * monthly_interest_rate;
	printf("Balance remaining after first payment: $%.2f \n", amount_of_loan);
	amount_of_loan = (amount_of_loan - monthly_payment) + amount_of_loan * monthly_interest_rate;
	printf("Balance remaining after second payment: $%.2f \n", amount_of_loan);
	amount_of_loan = (amount_of_loan - monthly_payment) + amount_of_loan * monthly_interest_rate;
	printf("Balance remaining after third payment: $%.2f \n", amount_of_loan);

	return 0;
}