
Example about Function models, f1 modeled by f2

How to run:
$ ./run.sh foo.bc 2>&1 | tee o.txt

$ more run.sh
$PROMPT -prose-api-model=model.txt -write-kqueries $1

$ more model.txt
global settings:

data models:

function models:

 bar modeled by zot;

lifecycle model:

entry-point foo


Code
======
#include <assert.h>


void bar(int *a);

void zot(int *a) {
  *a = 5;
}

void foo(int *a) {
  bar(a); // actually calls zot
  if (*a != 5)
     assert(0); // not reached
}

