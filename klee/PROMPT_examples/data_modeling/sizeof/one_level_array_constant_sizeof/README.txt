
Example about Data models, bound constraint

How to run:
$ ./run.sh foo.bc 2>&1 | tee o.txt

$ more run.sh
$PROMPT -prose-api-model=model.txt -write-kqueries $1

$ more model.txt
global settings:

data models:

 (x > 24) where x is foo arg 0;

 (x = 24) where x is foo arg 1;

 (25 = w) where w is sizeof A field 2;    

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

void foo(int a, int b, struct A *a1) {
  struct A *a2 = &a1[1]; 
  if (a <= 24)
     assert(0); // not reached
  if (b != 24)
     assert(0); // not reached
  a2->b[b].b1=4; // no out of bound error
  a2->b[a].b1=7; // out of bound error !
}
