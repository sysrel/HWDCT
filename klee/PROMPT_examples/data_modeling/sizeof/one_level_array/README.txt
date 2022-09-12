
Example about Data models, bound constraint

How to run:
$ ./run.sh foo.bc 2>&1 | tee o.txt

$ more run.sh
$PROMPT -prose-api-model=model.txt -write-kqueries $1

$ more model.txt
global settings:

data models:

 (x > 0) where x is foo arg 0;

 (y = 3) where y is A field 1;

 (x != y) where x is A field 0, y is A field 1;

 (z = w) where z is A field 0, w is sizeof A field 2;    

function models:

lifecycle model:

entry-point foo


Code
======
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
     assert(0); // not reached
  if (a2->c != 3)
     assert(0); // not reached
  if (a2->a == a2->c)
     assert(0); // not reached
  a2->b[a2->a-1].b1=4; // no out of bound errors
}
