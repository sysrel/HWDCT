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

void foo(int a, struct A *a1) {
  struct A *a2 = &a1[1]; 
  if (a < 0)
     assert(0);
  if (a2->c != 3)
     assert(0);
  if (a2->a == a2->c)
     assert(0);
  a2->b[a2->a-1].b1=4;
}
