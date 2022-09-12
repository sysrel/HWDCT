#include <verilated.h>       
#include <verilated_vcd_c.h> 
#include <iostream>
#include <fstream>
#include <assert.h> 

#include "Vu_xmit.h"
#include "Vu_xmit__Syms.h"
#include <klee/klee.h>
#include <set>
using namespace std;

#define NUMSTEPS 5

Vu_xmit *top; 

int main(int argc, char **argv)

{ 

  std::set<int> S;
  CData c0, c1, c2;
	CData c3, c4, c5;
	CData c6, c7, c8;
  CData dest, st0;

	std::set<int> O1;
  std::set<int> Of;
  std::set<int> Ob;

  top = new Vu_xmit; 
	int clk; 

	top->rst = 0;

	klee_make_symbolic(&c0, sizeof(c0), "xmitHFirst");//xmitH 1-bit
	klee_assume(c0 >= 0 && c0 < 2);
	top->xmitH = c0;
	klee_make_symbolic(&c1, sizeof(c1), "xmit_dataHFirst");//xmit_dataH 8-bit
	klee_assume(c1 >= 0 && c1 < 2566);
	top->xmit_dataH = c1;
   
  clk = 1;
	
	clk = !clk;
	top->clk = clk;
	top->eval();      

	// posedge of the clock will be sensed now

  clk = !clk;
	top->clk = clk;
	top->eval();
	
 	klee_add_metadata_globally_ThreeInput(&S, top->u_xmit->state, c0, c1, c2);
    
	top->rst = 1;

	for(int i=0; i<NUMSTEPS; i++){
    prevState = top->u_xmit->state;
    
		klee_make_symbolic(&c0, sizeof(c0), "xmitHFirst");//xmitH 1-bit
		klee_assume(c0 >= 0 && c0 < 2);
		top->xmitH = c0;
   
		klee_make_symbolic(&c1, sizeof(c1), "xmit_dataHFirst");//xmit_dataH 8-bit
	  klee_assume(c1 >= 0 && c1 < 2566);
	  top->xmit_dataH = c1;

		clk = !clk;
		top->clk = clk;
		top->eval();      

    clk = !clk;
		top->clk = clk;
		top->eval();

		klee_assume(top->u_xmit->state >=0 && top->u_xmit->state < 8);
		klee_add_metadata_globally(&S, top->u_xmit->state, c0);
    klee_add_output_metadata_globally(&Of, prevState, top->u_xmit->state, top->xmitH, top->xmit_doneH, c0);
		klee_add_forward_reg_metadata_globally(&O1, top->u_xmit->state, top->u_xmit->trojan_state, top->u_xmit->Trojan_ena, top->u_xmit->DataSend_ena, top->u_xmit->state_DataSend, top->u_xmit->xmit_ShiftRegH, top->u_xmit->bitCell_cntrH, top->u_xmit->bitCountH, top->u_xmit->xmit_doneH, top->u_xmit->state, top->u_xmit->state, top->u_xmit->state, top->u_xmit->state);
	} 
	
	top->rst = 1;

	klee_make_symbolic(&st0, sizeof(st0), "state");
	klee_assume(st0 >=0 && st0 < 8);
	top->u_xmit->state = st0;	

	klee_make_symbolic(&c3, sizeof(c3), "xmitHSec");//xmitH 1-bit
	klee_assume(c3 >= 0 && c3 < 2);
	top->xmitH = c3;
	klee_make_symbolic(&c4, sizeof(c4), "xmit_dataHSec");//xmit_dataH 8-bit
	klee_assume(c4 >= 0 && c4 < 256);
	top->xmit_dataH = c4;

	klee_make_symbolic(&dest, sizeof(dest), "dest");
	klee_assume(dest >=0 && dest < 8);
 
  clk = !clk;
	top->clk = clk;
	top->eval();  

  clk = !clk;
	top->clk = clk;
	top->eval();

	klee_assume(top->u_xmit->state >=0 && top->u_xmit->state < 8);		
	klee_check_dontcare_transition_globally(&S, top->u_xmit->state, st0, dest, c3);

  klee_add_and_check_abstract_reg_metadata_globally(&O1, top->u_xmit->state, top->u_xmit->trojan_state, top->u_xmit->Trojan_ena, top->u_xmit->DataSend_ena, top->u_xmit->state_DataSend, top->u_xmit->xmit_ShiftRegH, top->u_xmit->bitCell_cntrH, top->u_xmit->bitCountH, top->u_xmit->xmit_doneH, top->u_xmit->state, top->u_xmit->state, top->u_xmit->state, top->u_xmit->state);

	for(int i=0; i<NUMSTEPS; i++){
		prevState = top->u_xmit->state;
		klee_make_symbolic(&c6, sizeof(c6), "xmitHThird");//xmitH 1-bit
		klee_assume(c6 >= 0 && c6 < 2);
		top->xmitH = c6;
		klee_make_symbolic(&c7, sizeof(c7), "xmit_dataHThird");//xmit_dataH 8-bit
		klee_assume(c7 >= 0 && c7 < 256);
		top-xmit_dataH = c7;

		clk = !clk;
		top->clk = clk;
		top->eval();      

    clk = !clk;
		top->clk = clk;
		top->eval();

		klee_assume(top->u_xmit->state >=0 && top->u_xmit->state < 8);
		klee_add_back_output_metadata_globally(&Ob, prevState, top->u_xmit->state, top->xmitH, top->xmit_doneH, c6);
		klee_detect_trojan_for_output(&Of, &Ob);
	}
}
