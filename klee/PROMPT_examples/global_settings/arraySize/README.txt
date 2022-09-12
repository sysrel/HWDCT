
Example about Global Settings, array size NUMBER

How to run:
$ ./run.sh foo.bc 2>&1 | tee o.txt

$ more run.sh
$PROMPT -prose-api-model=model.txt -write-kqueries $1

$ more model.txt
global settings:

array size 5;

data models:

function models:

lifecycle model:

entry-point foo

Code
======

#include <assert.h>


void foo(int *a) {
  a[4] = 11; // no memory error
  a[5] = 10; // memory error
}

