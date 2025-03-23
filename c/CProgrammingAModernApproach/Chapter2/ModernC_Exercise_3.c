#include <stdio.h>
#define PI 3.14159f
#define FOURTHIRDS 4.0f/3.0f

int main(){
	int Radius;
	float answer;	
	printf("Enter radius: ");
	scanf("%d",&Radius);
	
	answer = FOURTHIRDS * PI * (Radius*Radius);
	printf("%f\n",answer);
	return 0;
}