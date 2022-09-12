
Example about Life-cycle, sequence, return value constraint

How to run:
$ ./run.sh foo.bc 2>&1 | tee o.txt

$ more run.sh
$PROMPT -prose-api-model=model.txt -write-kqueries $1

$ more model.txt
global settings:

data models:

  singleton A;

function models:

lifecycle model:

  foo continue if (x >= 0) where x is returnof foo ; bar

Code
======
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

int bar(struct A *c) { // bar gets to executed when foo returns something >= 0
  if (c->a > 0)
     assert(0); // not reached as this corresponds to foo returning a negative value
  if (c->a == -1)
     assert(0); // reached as this corresponds to foo returning >= 0
  return 0;
}
