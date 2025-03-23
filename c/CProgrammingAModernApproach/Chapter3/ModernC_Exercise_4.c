#include <stdio.h>

int main(){
	int area_code, ph_1, ph_2;
	printf("Enter phone number [(xxx) xxx-xxxx]: ");
	scanf("(%d) %d-%d",&area_code,&ph_1,&ph_2);
	printf("You entered %d.%d.%d",area_code,ph_1,ph_2);

	return 0;
}