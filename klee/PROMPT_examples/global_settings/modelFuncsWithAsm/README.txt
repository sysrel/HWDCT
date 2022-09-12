
Example about Global Settings, null return CHOICE

How to run:
$ ./run.sh foo.bc 2>&1 | tee o.txt

$ more run.sh
$PROMPT -prose-api-model=model.txt -write-kqueries $1

$ more model.txt
global settings:
// models functions that has inline assembly 
// other than those that include bar in their names with the exception for bar1
model funcs with asm on but_use_original_with_pattern bar except bar1;
// this one avoids the execution error when an assembly instruction is encountered inside bar
symbolize inline asm on;

data models:

function models:

lifecycle model:

entry-point foo


Code
======
#include <assert.h>


int foo1() {

    /* Add 10 and 20 and store result into register %eax */
    __asm__ ( "movl $10, %eax;"
                "movl $20, %ebx;"
                "addl %ebx, %eax;"
    );
    return 0;
}

int bar() {

    /* Add 10 and 20 and store result into register %eax */
    __asm__ ( "movl $10, %eax;"
                "movl $20, %ebx;"
                "addl %ebx, %eax;"
    );
    return 0;
}

int bar1()  {
   /* Add 10 and 20 and store result into register %eax */
    __asm__ ( "movl $10, %eax;"
                "movl $20, %ebx;"
                "addl %ebx, %eax;"
    );
    return 1;
}

void foo(int *a) {
  int y = foo1();
  if (y)
     assert(0); // reached as foo1 is modeled
  int z = bar();
  if (z)
     assert(0); // not reached uses the original
  int w = bar1();
  if (w != 1)
     assert(0); // reached as bar1 is modeled
}
