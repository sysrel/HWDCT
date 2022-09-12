
Example about Function models, havoc args list of function

How to run:
$ ./run.sh foo.bc 2>&1 | tee o.txt

$ more run.sh
$PROMPT -prose-api-model=model.txt -write-kqueries $1

$ more model.txt
global settings:

 skip havocing singletons on;
    
data models:

 singleton A;

function models:
 
 returnonly bar;
 havoc args 0, 2 of bar;
 havoc args 0 of zot;

lifecycle model:

entry-point foo


Code
======
#include <assert.h>

struct A {
  int a;
};

int zot(struct A *a);

int bar(int *a, int *b, int *c);

void foo(int *a, int *b, int *c, struct A *d) {
  *a = *b = *c = d->a = 5;
  zot(d);
  bar(a, b, c);
  if (*a != 5)
    assert(0); // reached as a is havoced
  if (*b != 5)
     assert(0); // not reached as is skipped due to bar being returnonly and b not explicity specified to be havoced
  if (*c != 5)
     assert(0); // reached as c is havoced
  if (d->a != 5) 
     assert(0); // reached as d is havoced despite pointing to a singleton 
                // (overwriting the globals setting with the specific havocing rule)   
}
