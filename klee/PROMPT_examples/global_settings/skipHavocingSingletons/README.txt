
Example about Global Settings, skip havocing singletons CHOICE

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

lifecycle model:

entry-point foo


Code
======
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
    assert(0);   // not reached as type struct A is a singleton and not havoced
 if (b1->b != 10)
    assert(0);  // reached as type B is not a single and havoced (symbolized)
}
