
Example about Function models, returnonly f2

How to run:
$ ./run.sh foo.bc 2>&1 | tee o.txt

$ more run.sh
$PROMPT -prose-api-model=model.txt -write-kqueries $1

$ more model.txt
global settings:

data models:

function models:

 alloc bar sizearg 2 initzero false symbolize false;

lifecycle model:

entry-point foo


Code
======
#include <assert.h>
	
char *bar(int a, int b, int c); // acts as a malloc where argument 2 (c) denotes the size

void foo(int *a, int b, int c) {
  c = 10;
  char *n = bar(a,b,c);
  n[9] = 'A'; // no out of bounds
  n[10] = 'B'; // out of bound error !
}
