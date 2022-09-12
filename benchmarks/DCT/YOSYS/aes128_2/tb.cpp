#include <verilated.h>       
#include <verilated_vcd_c.h> 
#include <iostream>
#include <fstream>
#include <assert.h> 
// Make sure to provide the right header file for your design

// The pattern is:

// #include "Vtop_module_name.h"

#include "Vmixcolum.h"
#include "Vmixcolum_mixcolum.h"
#include "Vmixcolum__Syms.h"
#include <klee/klee.h>
#include <set>
using namespace std;

#define NUMSTEPS 3

Vmixcolum *top; 
      
/*unsigned int main_time = 0;     // Current simulation time

double sc_time_stamp () {       // Called by $time in Verilog
    return main_time;
}
*/

int main(int argc, char **argv)

{ 

        std::set<int> S;
        CData c0, c1, c2;
	WData w0;

	CData c3, c4, c5;
	WData w1;

	CData st0, dest;

    	top = new Vmixcolum; 
	int clk;  

	top->reset = 0;
        clk = 1;
	
	clk = !clk;
	top->clk = clk;
	top->eval();      

	// posedge of the clock will be sensed now

        clk = !clk;
	top->clk = clk;
	top->eval();
	
	top->reset = 1;
	klee_make_symbolic(&c0, sizeof(c0), "start_iFirst");
	top->mixcolum->start_i = c0;
	klee_assume(c0 >=0 && c0 < 2);
	klee_assume(top->mixcolum->state >=0 && top->mixcolum->state < 8);
	//klee_add_metadata_locally(&S, top->mixcolum->state, c0);
  klee_add_metadata_globally(&S, top->mixcolum->state, c0);
	for(int i=0; i<NUMSTEPS; i++){
		klee_make_symbolic(&c0, sizeof(c0), "start_iFirst");
		top->start_i = c0;
		klee_assume(c0 >=0 && c0 < 2);

		clk = !clk;
		top->clk = clk;
		top->eval();      

       		clk = !clk;
		top->clk = clk;
		top->eval();

		//klee_add_metadata_locally(&S, top->mixcolum->state, c0);
    klee_add_metadata_globally(&S, top->mixcolum->state, c0);
	} 
	
	klee_make_symbolic(&st0, sizeof(st0), "state");
	top->mixcolum->state = st0;	
	klee_make_symbolic(&c3, sizeof(c3), "start_iSec");
	top->start_i = c3;

	klee_assume(st0 >=0 && st0 < 4);
	klee_make_symbolic(&dest, sizeof(dest), "dest");
	klee_assume(c3 >=0 && c3 < 2);
	klee_assume(top->mixcolum->state >=0 && top->mixcolum->state < 8);
	klee_assume(dest >=0 && dest < 8);

	clk = !clk;
	top->clk = clk;
	top->eval();      

       	clk = !clk;
	top->clk = clk;
	top->eval();
		
	//klee_check_dontcare_transition_locally(&S, top->mixcolum->state, st0, dest, c3);
  klee_check_dontcare_transition_globally(&S, top->mixcolum->state, st0, dest, c3);
}
