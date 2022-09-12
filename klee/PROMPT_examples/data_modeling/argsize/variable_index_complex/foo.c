#include <assert.h>

void foo(int a, int b, int *a2) {
  a2[a+b-1]=4;
}
