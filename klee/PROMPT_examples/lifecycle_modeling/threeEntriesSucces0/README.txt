
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

  foo ; bar ; zot

Code
======
#include <assert.h>

struct A {
 int a;
};

int foo(struct A *b) {
  if (b->a > 0)
     return 1;
  else return 0;
}

int bar(struct A *c) { // bar gets to executed when foo returns the default success value 0
  if (c->a > 0)
     assert(0); // not reached as this corresponds to foo returning 1 
  if (c->a == -1)
     assert(0); // reached as this corresponds to foo returning 0
  return 0;
}

void zot(struct A *d) { // zot gets executed when bar returns the default success value 0
  if (d->a > 0) 
     assert(0); // not reached as this corresponds to bar returning 1
  if (d->a == -5)
     assert(0); // reached as this corresponds to bar returning 0
}
