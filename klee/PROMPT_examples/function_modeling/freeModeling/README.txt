
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
 free zot memarg 1;

lifecycle model:

entry-point foo


Code
======
#include <assert.h>
	
char *bar(int *a, int *b, int c); // a function that returns an allocated memory of size c

void zot(char *d, char *e); // a function that frees the 2nd argument (e)

void foo(int *a, int *b, int c) {
  char *m,*n; 
  c = 10;
  n = bar(a,b,c);
  zot(m,n); // memory pointed by n gets freed
  zot(m,n); // memory error due to double-free!
}
