#include <assert.h>


void bar(int *a);

void zot(int *a) {
  *a = 5;
}

void foo(int *a) {
  bar(a);
  if (*a != 5)
     assert(0);
}
