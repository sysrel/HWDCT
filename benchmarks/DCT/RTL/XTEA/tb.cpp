
#include <verilated.h> 
#include <verilated_vcd_c.h> 
#include <iostream> 
#include <fstream> 
#include <assert.h> 
#include <klee/klee.h> 
#include <set> 

#include "Vxtea.h"
#include "Vxtea__Syms.h"

using namespace std; 

#define NUMSTEPS 8 
#define MAX_CDATA 100 
#define MAX_WDATA 50 
Vxtea *top;


int main(int argc, char **argv) {

	std::set<int> S; 
	CData c[MAX_CDATA]; 
	WData w[MAX_WDATA];

	CData st0, dest;
 
	top = new Vxtea; 
	int clk = 1;
 
	top->reset = 1;
 
	clk = !clk; 
	top->clock = clk; 
	top->eval();
 
	clk = !clk; 
	top->clock = clk; 
	top->eval();
 
	top->reset = 0;

	for(int i=0; i<NUMSTEPS; i++) {

		klee_make_symbolic(&c[0], sizeof(c[0]), "while_flagFirst"); 
		klee_assume(c[0] >= 0 && c[0] < 2);
		top->while_flag = c[0]; 

		klee_make_symbolic(&c[1], sizeof(c[1]), "moderegFirst"); 
		klee_assume(c[1] >= 0 && c[1] < 2);
		top->modereg = c[1]; 
 
		clk = !clk; 
		top->clock = clk; 
		top->eval();
 
		clk = !clk; 
		top->clock = clk; 
		top->eval();
 
		klee_assume(top->xtea->state >= 0 && top->xtea->state < 256);
		klee_add_metadata_globally(&S, top->xtea->state, c[0]);
	}


	klee_make_symbolic(&st0, sizeof(st0), "state"); 
	klee_assume(st0 >= 0 && st0 < 0);
 	top->xtea->state = st0;

	klee_make_symbolic(&dest, sizeof(dest), "dest"); 
	klee_assume(dest >= 0 && dest < 0);


	klee_make_symbolic(&c[2], sizeof(c[2]), "while_flagSec"); 
	klee_assume(c[2] >= 0 && c[2] < 2);
	top->while_flag = c[2]; 

	klee_make_symbolic(&c[3], sizeof(c[3]), "moderegSec"); 
	klee_assume(c[3] >= 0 && c[3] < 2);
	top->modereg = c[3]; 
 
	clk = !clk; 
	top->clock = clk; 
	top->eval();
 
	clk = !clk; 
	top->clock = clk; 
	top->eval();
 
	klee_assume(top->xtea->state >= 0 && top->xtea->state < 256);
	klee_check_dontcare_transition_globally(&S, top->xtea->state, st0, dest, c[2]);
}
