
#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>



#include <stddef.h>
#ifdef __cplusplus
#include <complex>
#define __GFORTRAN_FLOAT_COMPLEX std::complex<float>
#define __GFORTRAN_DOUBLE_COMPLEX std::complex<double>
#define __GFORTRAN_LONG_DOUBLE_COMPLEX std::complex<long double>
extern "C" {
#else
#define __GFORTRAN_FLOAT_COMPLEX float _Complex
#define __GFORTRAN_DOUBLE_COMPLEX double _Complex
#define __GFORTRAN_LONG_DOUBLE_COMPLEX long double _Complex
#endif

typedef struct array2d_container_c {
    void *array;
    int array_len /* WARNING: Converting 'INTEGER(4)' to interoperable type */;
} array2d_container_c;
typedef struct array_container_c {
    void *array;
    int array_len /* WARNING: Converting 'INTEGER(4)' to interoperable type */;
} array_container_c;
void array_passing (const array_container_c *input_data, array_container_c *output_data, const char *string);
void array_passing2d (const array2d_container_c *input_data, array2d_container_c *output_data);
int int_2x (int n);
int int_sq (int n);
double nr_sqrt (const double *n, const double *x0, const int *iterations, const _Bool *printits);

#ifdef __cplusplus
}
#endif

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