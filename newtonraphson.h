#include <stdio.h>
#include <stdbool.h>

// enabling C99 gives us modern functionality like efficient float to int cast
#define _ISOC9X_SOURCE 1
#define _ISOC99_SOURCE 1
#include <math.h>

int initializer();
bool isEven(int n);
int int_sq(int n);
int int_2x(int n);
bool isInteger(double n);
double nr_sqrt(double *n, double *x0, int *iterations, bool *printIts);