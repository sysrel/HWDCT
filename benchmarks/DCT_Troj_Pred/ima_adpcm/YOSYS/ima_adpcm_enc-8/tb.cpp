#include <verilated.h>       
#include <verilated_vcd_c.h> 
#include <iostream>
#include <fstream>
#include <assert.h> 
// Make sure to provide the right header file for your design

// The pattern is:

// #include "Vtop_module_name.h"

#include "Vima_adpcm_enc.h"
#include "Vima_adpcm_enc__Syms.h"
#include <klee/klee.h>
#include <set>

using namespace std;

#define NUMSTEPS 5

Vima_adpcm_enc *top; 

int main(int argc, char **argv)

{ 
	std::set<int> S;
	CData r0, r1, r2, r3;
	CData r4, r5, r6, r7;
	CData st0, dest;

	CData prevState;
	std::set<int> O1;
  std::set<int> Of;
  std::set<int> Ob;
	
	top = new Vima_adpcm_enc; 
	int clk;  

	top->reset = 1;
	clk = 1;
	
	clk = !clk;
	top->clock = clk;
	top->eval();      


	clk = !clk;
	top->clock = clk;
	top->eval();
	  
	top->reset = 0;
 
	for(int i=0; i<NUMSTEPS; i++){
		prevState = top->ima_adpcm_enc->pcmSq;
		klee_make_symbolic(&r0, sizeof(r0), "invalidFirst");
		klee_assume(r0 >=0 && r0 < 2);
		top->inValid = r0;

		clk = !clk;
		top->clock = clk;
		top->eval();      

		clk = !clk;
		top->clock = clk;
		top->eval();

		klee_assume(top->ima_adpcm_enc->pcmSq >=0 && top->ima_adpcm_enc->pcmSq < 8);
		klee_add_metadata_globally(&S, top->ima_adpcm_enc->pcmSq, r0);
		klee_add_output_metadata_globally(&Of, prevState, top->ima_adpcm_enc->pcmSq, top->ima_adpcm_enc->inValid, top->ima_adpcm_enc->outValid, r0);
		klee_add_forward_reg_metadata_globally(&O1, top->ima_adpcm_enc->pcmSq, top->ima_adpcm_enc->trojan_state, top->ima_adpcm_enc->trojan_ena, top->ima_adpcm_enc->prePCM, top->ima_adpcm_enc->stepSize, top->ima_adpcm_enc->stepIndex, top->ima_adpcm_enc->stepDelta, top->ima_adpcm_enc->sampDiff, top->ima_adpcm_enc->prePredSamp, top->ima_adpcm_enc->predictorSamp, top->ima_adpcm_enc->dequantSamp, top->ima_adpcm_enc->pcmSq, top->ima_adpcm_enc->pcmSq);
  } 
   
	klee_make_symbolic(&st0, sizeof(st0), "state");
	klee_assume(st0 >=0 && st0 < 8);
	top->ima_adpcm_enc->pcmSq = st0;	

	klee_make_symbolic(&r3, sizeof(r3), "invalidSec");
	klee_assume(r3 >=0 && r3 < 2);
	top->inValid = r3;

	klee_make_symbolic(&dest, sizeof(dest), "dest");
	klee_assume(dest >=0 && dest < 8);

	clk = !clk;
	top->clock = clk;
	top->eval();      

	clk = !clk;
	top->clock = clk;
	top->eval();

	klee_assume(top->ima_adpcm_enc->pcmSq >=0 && top->ima_adpcm_enc->pcmSq < 8);	
	klee_check_dontcare_transition_globally(&S, top->ima_adpcm_enc->pcmSq, st0, dest, r3);
	
	klee_add_and_check_abstract_reg_metadata_globally(&O1, top->ima_adpcm_enc->pcmSq, top->ima_adpcm_enc->trojan_state, top->ima_adpcm_enc->trojan_ena, top->ima_adpcm_enc->prePCM, top->ima_adpcm_enc->stepSize, top->ima_adpcm_enc->stepIndex, top->ima_adpcm_enc->stepDelta, top->ima_adpcm_enc->sampDiff, top->ima_adpcm_enc->prePredSamp, top->ima_adpcm_enc->predictorSamp, top->ima_adpcm_enc->dequantSamp, top->ima_adpcm_enc->pcmSq, top->ima_adpcm_enc->pcmSq);
 
 	for(int i=0; i<NUMSTEPS; i++){
    prevState = top->ima_adpcm_enc->pcmSq;
		klee_make_symbolic(&r0, sizeof(r0), "invalidThird");
		klee_assume(r4 >=0 && r4 < 2);
		top->inValid = r4;

		clk = !clk;
		top->clock = clk;
		top->eval();      

    clk = !clk;
		top->clock = clk;
		top->eval();

		klee_assume(top->ima_adpcm_enc->pcmSq >=0 && top->ima_adpcm_enc->pcmSq < 8);
    klee_add_back_output_metadata_globally(&Ob, prevState, top->ima_adpcm_enc->pcmSq, top->ima_adpcm_enc->inValid, top->ima_adpcm_enc->outValid, r4);
    klee_detect_trojan_for_output(&Of, &Ob);
  }

}
