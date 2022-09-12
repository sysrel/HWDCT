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

void foo(int a, int b, struct A *a2) {
  if (a <= 24)
     assert(0);
  if (b != 24)
     assert(0); 
  a2->b[b].b1=4;
  a2->b[a].b1=7;
}
