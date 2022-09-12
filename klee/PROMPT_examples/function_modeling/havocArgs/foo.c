#include <assert.h>

struct A {
  int a;
};

int zot(struct A *a);

int bar(int *a, int *b, int *c);

void foo(int *a, int *b, int *c, struct A *d) {
  *a = *b = *c = d->a = 5;
  zot(d);
  bar(a, b, c);
  if (*a != 5)
    assert(0);
  if (*b != 5)
     assert(0);
  if (*c != 5)
     assert(0);
  if (d->a != 5)
     assert(0);  
}
