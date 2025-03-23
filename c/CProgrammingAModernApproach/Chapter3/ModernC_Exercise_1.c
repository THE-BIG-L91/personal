#include <stdio.h>

int main(){
	int months,days,years;
	printf("Enter a date (mm/dd/yyy): ");
	scanf("%d/%d/%d",&months,&days,&years);
	printf("You entered the date %4d%2.2d%2d",years,months,days);
	return 0;
}