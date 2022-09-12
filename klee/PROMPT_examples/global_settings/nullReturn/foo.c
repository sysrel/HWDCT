#include <assert.h>


int *bar();

void foo(int *a) {
  int *y = bar();
  int z = *y; 
}
