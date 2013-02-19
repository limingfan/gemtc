#include <stdlib.h>
#include <stdio.h>
int fib (int n)
{
  if (n<2) return (n);
  else
    {
      int x, y;
      x = fib (n-1);
      y = fib (n-2);
      return (x+y);
    }
}
int main (int argc, char *argv[])
{
  int n, result;
  n = atoi(argv[1]);
  result = fib (n);
  printf ("Result: %d\n", result);
  return 0;
}
