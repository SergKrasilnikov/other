#include <stdio.h>

int main()
{
    char* er = "error";
    char* zero = "Absolute zero";
    int fahr;
    int cels;
    fahr = -480;

    if (fahr <= -460)
        printf("%s\n", er);
    else if (fahr == -459)
        printf("%s\n", zero);
    else
    {
        cels = 5 * (fahr-32) / 9;
        printf("%i\n", cels);
    }
    return(0);
}
