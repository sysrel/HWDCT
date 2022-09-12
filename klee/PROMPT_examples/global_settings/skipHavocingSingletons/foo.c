#include <assert.h>


struct A {
  int a;
};

struct B {
  int b;
};

void bar(struct A *, struct B *);

void foo(struct A *a1, struct B *b1) {
 a1->a = 5;
 b1->b = 10;
 bar(a1, b1); 
 if (a1->a != 5)
    assert(0);
 if (b1->b != 10)
    assert(0);
}
