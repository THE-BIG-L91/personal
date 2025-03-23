#include <stdio.h>

int main(){
	float price;
	int item_number, purchase_month, purchase_day, purchase_year;
	printf("Enter item number: ");
	scanf("%d",&item_number);
	printf("Enter unit price: ");
	scanf("%f",&price);
	printf("Enter purchase date: (mm/dd/yyyy) : ");
	scanf("%d/%d/%d",&purchase_month,&purchase_day,&purchase_year);
	
	printf("Item\t\tUnit\t\tPurchase\n");
	printf("\t\tPrice\t\tDate\n");
	printf("%-d\t\t$%8.2f\t%d/%d/%d",item_number,price,purchase_day,purchase_month,purchase_year);
	return 0;
}