#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <ctype.h>

// Probably shouldn't be using usleep.. oh well

#if defined(__unix__) || defined(__APPLE__)
#include <unistd.h>
#define SLEEP(time) usleep(time * 1000)
#elif defined(_WIN32) || defined(_WIN64)
#include <windows.h>
#define SLEEP(time) Sleep(time)
#endif

#define RND_CHAR_DELAY 25
#define CHAR_DELAY 50

void FancyPrint(char *String)
{
    srand(time(NULL));
    char *ptr = String;
    // Hide terminal cursor
    printf("\e[?25l");

    while (*ptr != '\0')
    {
        for (int j = 1; j < (rand() % (6)) + 2; j++)
        {
            if (*ptr == '\n')
            {
                break;
            }

            const short unsigned int COLOR = (rand() % 6) + 31;
            const short unsigned int IS_UPPER = rand() % 2;
            char RAND_LETTER = (char)(rand() % ('z' - 'a' + 1) + 'a');

            if (IS_UPPER == 0)
            {
                RAND_LETTER = toupper(RAND_LETTER);
            }

            printf("\033[0;%dm%c\033[0m", COLOR, RAND_LETTER);
            fflush(stdout);
            SLEEP(RND_CHAR_DELAY);
            printf("\b \b");
            fflush(stdout);
        }
        printf("%c", *ptr);
        ptr++;
        SLEEP(CHAR_DELAY);
    }
    printf("\e[?25h");
}

int main()
{
    char Buffer[50];
    printf("Enter string: ");
    if (fgets(Buffer, sizeof(Buffer), stdin) == NULL)
    {
        printf("Failed to read from stdin!");
    }
    FancyPrint(&Buffer);
    return 0;
}
