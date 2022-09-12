#include <assert.h>

struct B {
  int b1;
  int b2;
  void (*f)(void);
};

struct A {
  int a;
  int c;
  struct B *b;
};

struct C {
  char c1;
  struct A c2;
};

void foo(int a, struct C *c) {
  struct A *a2 = &c[1].c2;
  if (a < 0)
     assert(0);
  if (a2->c != 3)
     assert(0);
  if (a2->a == a2->c)
     assert(0);
  a2->b[a2->a-1].b1=4;
}
