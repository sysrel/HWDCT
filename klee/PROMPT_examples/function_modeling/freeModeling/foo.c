#include <assert.h>
	
char *bar(int *a, int *b, int c);

void zot(char *d, char *e);

void foo(int *a, int *b, int c) {
  char *m,*n; 
  c = 10;
  n = bar(a,b,c);
  zot(m,n);
  zot(m,n); 
}
