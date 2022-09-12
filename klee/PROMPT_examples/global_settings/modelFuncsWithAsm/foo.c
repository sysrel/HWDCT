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
     assert(0);
  int z = bar();
  if (z)
     assert(0);
  int w = bar1();
  if (w != 1)
     assert(0);
}
