#include <assert.h>

struct A {
 int a;
};

int foo(struct A *b, int c) {
 if (c > 0) {
    if (b->a > 0)
       return -c;
    else return c;
 }
 else if (c == 0)
    return -1; 
 else return c;
}

int bar(struct A *c) {
  if (c->a > 0)
     assert(0);
  if (c->a == -1)
     assert(0);
  return 0;
}
