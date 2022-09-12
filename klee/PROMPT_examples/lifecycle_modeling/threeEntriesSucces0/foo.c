#include <assert.h>

struct A {
 int a;
};

int foo(struct A *b) {
  if (b->a > 0)
     return 1;
  else return 0;
}

int bar(struct A *c) {
  if (c->a > 0)
     assert(0);
  if (c->a == -1)
     assert(0);
  return 0;
}

void zot(struct A *d) {
  if (d->a > 0)
     assert(0);
  if (d->a == -5)
     assert(0);
}
