
Example about Life-cycle, sequence

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

  foo[1] ; bar

Code
======
#include <assert.h>

struct A {
 int a;
};

int foo(struct A *b) {
  if (b->a > 0)
     return 0;
  else return 1;
}

int bar(struct A *c) { // bar gets to executed when foo returns the custom success value 1
  if (c->a > 0)
     assert(0); // not reached as this corresponds to foo returning 0
  if (c->a == -1)
     assert(0); // reached as this corresponds to foo returning 1
  return 0;
}
