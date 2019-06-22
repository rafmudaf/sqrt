#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <math.h>

// enabling C99 gives us modern functionality like efficient float to int cast
#define _ISOC9X_SOURCE 1
#define _ISOC99_SOURCE 1

bool isEven(int n);
int int_sq(int n);
int int_2x(int n);
bool isInteger(double n);

extern "C"
{
  int initializer();
  double nr_sqrt(double n, double x0, int iterations, bool printIts);
  int passarrays(double in[4], double out[4]);
};

int initializer()
{
  // open a file for logging
  FILE *fp;
  fp = fopen("newtonraphson.log", "w");
  fprintf(fp, "Testing...\n");
  return 1;
}

int passarrays(double in[4], double out[4])
{
  memcpy(out, in, 4 * sizeof(double));
  return 0;
}

bool isEven(int n)
{
  return n % 2 == 0;
}

int int_sq(int n)
{
  int x, sq;
  if (n == 0)
  {
    return 0;
  }
  else
  {
    x = n >> 1;
    if (isEven(n))
    {
      return int_sq(x) << 2;
    }
    else
    {
      return (int_sq(x) << 2) + (x << 2) + 1;
    }
  }
}

int int_2x(int n)
{
  return n << 1;
}

bool isInteger(double n)
{
  return fmod(n, 1.0) == 0;
}

double nr_sqrt(double n, double x0, int iterations, bool printIts)
{
  double xm1, root;

  for (int i = 0; i < iterations; ++i)
  {
    if (i == 0)
    {
      xm1 = x0;
    }

    // if integer, use integer algorithm
    if (isInteger(xm1))
    {
      root = xm1 - (int_sq(lrint(xm1)) - n) / (int_2x(lrint(xm1)));
    }
    else
    {
      root = xm1 - (pow(xm1, 2) - n) / (2 * xm1);
    }

    if (printIts)
    {
      printf("at iteration %i - %f\n", i, xm1);
    }

    xm1 = root;
  }

  return root;
}
