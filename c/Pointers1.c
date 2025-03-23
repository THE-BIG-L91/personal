#include <stdio.h>
#include <stdlib.h>

void find_two_largest(int a[], int n, int *largest, int *second_largest);
void TEST_FIND_TWO_LARGEST();
void split_time(long total_sec, int *hr, int *min, int *sec);
void TEST_SPLIT_TIME();
void resize(int **ptr, int len, int addition);

void split_time(long total_sec,int *hr, int *min, int *sec){
    *hr = (total_sec/(60*60))%24;
    *min = ((total_sec - (60*60**hr))/60)%60;
    *sec = (total_sec - 60*60*(*hr) - 60*(*min))%60;
}

void find_two_largest(int a[], int n, int *largest, int *second_largest){
    int curr_largest = -(1);
    int curr_second_largest = -(1);

    for (int i=0; i<n; i++){
        if (a[i] > curr_largest){
            curr_second_largest = curr_largest;
            curr_largest = a[i];
        }
    }

    *largest = curr_largest;
    *second_largest = curr_second_largest;
}

void TEST_SPLIT_TIME(){
    printf("*** SPLIT_TIME ***\n\n");
    int HR,MIN,SEC = 0;
    int TOTAL_TIME;
    
    printf("ENTER SECONDS AFTER MIDNIGHT (UNSIGNED INT): ");
    scanf("%d", &TOTAL_TIME);

    if (TOTAL_TIME > 24*60*60){
        printf("WARNING: NUMBER OF SECONDS WILL BE TAKEN MODULO 24*24*60\n");
        TOTAL_TIME = TOTAL_TIME % (24*60*60);
    }

    

    fflush(stdin);
    split_time(TOTAL_TIME,&HR,&MIN,&SEC);

    printf("HR: %d | MIN: %d | SEC: %d\n\n", HR, MIN, SEC);    
    getchar();
}

void resize(int **ptr, int len, int addition){
    int* temp_ptr = realloc(*ptr, (len +addition)*sizeof(int));
    if (temp_ptr == NULL){
        return 1;
    }

    *ptr = temp_ptr;
}

void TEST_FIND_TWO_LARGEST(){
    printf("*** FIND_TWO_LARGEST ***\n\n");
    
    int min, max = 0;
    int *a = malloc(0);
    int len = 0;
    if (a == NULL){
        return -1;
    }
    
    int _T;
    while (1){
        printf("ENTER UNSIGNED INTEGER NUMBER (-1 TO FINISH ENTERING): ");
        scanf("%d", &(_T));
        fflush(stdin);
        if (_T < 0){
            printf("EXIT\n");
            break;
        }
    
        len++;        
        resize(&a, len, 1);
        a[len-1] = _T;
    }


    find_two_largest(a, len, &min,&max);
    printf("%d, %d\n", min, max);
    
    free(a);
    getchar();
}

int main(){
    TEST_FIND_TWO_LARGEST();
    TEST_SPLIT_TIME();    
    return 0;
    getchar();
}
