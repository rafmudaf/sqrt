
#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>

extern "C"
{
    double nr_sqrt(double *, double *, int *, bool *);
}

int main(int argc, char *argv[])
{
    double input;
    double x0 = 10;
    int iterations = 10;
    bool printIts = true;
    double result = -1.0;

    if (argc != 2)
    {
        printf("invalid arguments. usage: sqrt 10\n");
        return 1;
    }
    else
    {
        input = atoi(argv[1]);
    }

    // get the square root from newton raphson method
    result = nr_sqrt(&input, &x0, &iterations, &printIts);

    // print results
    printf("The square root of %f is %f\n", input, result);

    return 0;
}