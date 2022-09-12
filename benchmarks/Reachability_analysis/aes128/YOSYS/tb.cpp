#include <verilated.h>       
#include <verilated_vcd_c.h> 
#include <iostream>
#include <fstream>
#include <assert.h> 

#include "Vkeysched.h"
#include "Vkeysched_keysched.h"
#include "Vkeysched__Syms.h"
#include <klee/klee.h>
#include <set>
using namespace std;

#define NUMSTEPS 1

Vkeysched *top; 

///////////////////////test driver for finding path violation start from reachable state///////////////////////
int main(int argc, char **argv)

{ 

  std::set<int> S;
  CData c0, c1, c2;
	WData w0;
	CData c3, c4, c5;
	WData w1;
	CData srcState, protectState;

  top = new Vkeysched; 
	int clk;  
	
	top->reset = 1;
 
  protectState = 4;
  top->keysched->state = 4;


	for(int i=0; i<NUMSTEPS; i++){
		klee_make_symbolic(&c0, sizeof(c0), "start_iFirst");
		top->start_i = c0;
    klee_make_symbolic(&c1, sizeof(c1), "round_iFirst");
		top->round_i = c1;
    klee_make_symbolic(&c2, sizeof(c2), "sbox_data_iFirst");
		top->sbox_data_i = c2;
    klee_assume(c0 >=0 && c0 < 2);
   
    srcState = top->keysched->state;

		clk = !clk;
		top->clk = clk;
		top->eval();      

    clk = !clk;
		top->clk = clk;
		top->eval();

		klee_assume(top->keysched->state >=0 && top->keysched->state < 8);
    klee_find_all_transitions_from_given_src_globally(&S, i, srcState, top->keysched->state, protectState);
	} 
}


///////////////////////test driver for finding path violation start from NOT reachable state///////////////////////
/*
int main(int argc, char **argv)

{ 

  std::set<int> S;
  std::set<int> S1;
  CData c0, c1, c2;
	WData w0;
	CData c3, c4, c5;
	WData w1;
	CData st0, dest;
  CData srcState, protectState;

  top = new Vkeysched; 
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
 
	for(int i=0; i<NUMSTEPS; i++){
		klee_make_symbolic(&c0, sizeof(c0), "start_iFirst");
		top->start_i = c0;

		clk = !clk;
		top->clk = clk;
		top->eval();      

    clk = !clk;
		top->clk = clk;
		top->eval();

		klee_assume(top->keysched->state >=0 && top->keysched->state < 8);
    klee_add_metadata_globally(&S, top->keysched->state, c0);
	} 
	
	klee_make_symbolic(&st0, sizeof(st0), "state");
	top->keysched->state = st0;	

	klee_make_symbolic(&c1, sizeof(c1), "start_iSec");
	top->start_i = c1;

	klee_assume(st0 >=0 && st0 < 8);
	klee_make_symbolic(&dest, sizeof(dest), "dest");

	klee_assume(c1 >=0 && c1 < 2);
	klee_assume(top->keysched->state >=0 && top->keysched->state < 8);
	klee_assume(dest >=0 && dest < 8);

	clk = !clk;
	top->clk = clk;
	top->eval();      

  clk = !clk;
	top->clk = clk;
	top->eval();
		
    int i = 0;
		
    klee_find_all_transitions_from_given_unreachable_src_one_step_globally(&S, top->keysched->state, st0, dest, c1, &S1, i);
    i++;
  
  protectState = 4;
  //top->keysched->state = 5;

	for(; i<NUMSTEPS+1; i++){
		klee_make_symbolic(&c2, sizeof(c2), "start_iThird");
		top->start_i = c2;
   
    srcState = top->keysched->state;

		clk = !clk;
		top->clk = clk;
		top->eval();      

    clk = !clk;
		top->clk = clk;
		top->eval();

		klee_assume(top->keysched->state >=0 && top->keysched->state < 8);
    klee_find_all_transitions_from_given_src_globally(&S1, i, srcState, top->keysched->state, protectState);
	}
}
*/