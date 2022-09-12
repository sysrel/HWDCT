#include <assert.h>
	
char *bar(int a, int b, int c);

void foo(int *a, int b, int c) {
  c = 10;
  char *n = bar(a,b,c);
  n[9] = 'A';
  n[10] = 'B';
}
