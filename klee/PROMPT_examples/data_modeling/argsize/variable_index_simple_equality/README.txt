
Example about Data models, bound constraint

How to run:
$ ./run.sh foo.bc 2>&1 | tee o.txt

$ more run.sh
$PROMPT -prose-api-model=model.txt -write-kqueries $1

$ more model.txt
global settings:

data models:

 (x = w) where x is foo arg 0, w is argsize foo arg 1;    

function models:

lifecycle model:

entry-point foo


Code
======
#include <assert.h>

void foo(int a, int *a2) {
  a2[a-1]=4; // no out of bound error
}
