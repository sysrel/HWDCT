#include <assert.h>

struct A {
 int (*bar)();
 int a;
};  


typedef struct A A_t;

void foo(A_t *a1) {
  if (a1->bar)
     assert(0); 
  int b = a1->a;
}
