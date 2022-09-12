
Example about Global Settings, null return CHOICE

How to run:
$ ./run.sh foo.bc 2>&1 | tee o.txt

$ more run.sh
$PROMPT -prose-api-model=model.txt -write-kqueries $1

$ more model.txt
global settings:

array size 5;
null return on;

data models:

function models:

lifecycle model:

entry-point foo


Code
======
#include <assert.h>


int *bar(); // external function

void foo(int *a) {
  int *y = bar(); // both NULL and not NULL (symbolic) return value
  int z = *y; // error when y is NULL
}
