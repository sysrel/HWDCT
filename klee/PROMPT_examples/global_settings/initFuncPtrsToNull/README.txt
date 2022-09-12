
Example about Global Settings, init funcptrs to null CHOICE

How to run:
$ ./run.sh foo.bc 2>&1 | tee o.txt

$ more run.sh
$PROMPT -prose-api-model=model.txt -write-kqueries $1

$ more model.txt
global settings:

array size 5;
null return on;
init funcptrs to null on;

data models:

function models:

lifecycle model:

entry-point foo


Code
======
#include <assert.h>

struct A {
 int (*bar)();
 int a;
};  


typedef struct A A_t;

void foo(A_t *a1) {
  if (a1->bar) 
     assert(0); // cannot reach as function pointers have been initialized to NULL
  int b = a1->a;
}
