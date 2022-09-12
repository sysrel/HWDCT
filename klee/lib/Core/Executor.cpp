//===-- Executor.cpp ------------------------------------------------------===//
//
//                     The KLEE Symbolic Virtual Machine
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "Executor.h"
#include "Context.h"
#include "CoreStats.h"
#include "ExternalDispatcher.h"
#include "ImpliedValue.h"
#include "Memory.h"
#include "MemoryManager.h"
#include "PTree.h"
#include "Searcher.h"
#include "SeedInfo.h"
#include "SpecialFunctionHandler.h"
#include "StatsTracker.h"
#include "TimingSolver.h"
#include "UserSearcher.h"
#include "ExecutorTimerInfo.h"
#include "../Prose/Prose.h"

#include "klee/ExecutionState.h"
#include "klee/Expr.h"
#include "klee/Interpreter.h"
#include "klee/TimerStatIncrementer.h"
#include "klee/CommandLine.h"
#include "klee/Common.h"
#include "klee/util/Assignment.h"
#include "klee/util/ExprPPrinter.h"
#include "klee/util/ExprSMTLIBPrinter.h"
#include "klee/util/ExprUtil.h"
#include "klee/util/GetElementPtrTypeIterator.h"
#include "klee/Config/Version.h"
#include "klee/Internal/ADT/KTest.h"
#include "klee/Internal/ADT/RNG.h"
#include "klee/Internal/Module/Cell.h"
#include "klee/Internal/Module/InstructionInfoTable.h"
#include "klee/Internal/Module/KInstruction.h"
#include "klee/Internal/Module/KModule.h"
#include "klee/Internal/Support/ErrorHandling.h"
#include "klee/Internal/Support/FloatEvaluation.h"
#include "klee/Internal/Support/ModuleUtil.h"
#include "klee/Internal/System/Time.h"
#include "klee/Internal/System/MemoryUsage.h"
#include "klee/SolverStats.h"

#include "llvm/IR/Function.h"
#include "llvm/IR/Attributes.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/TypeBuilder.h"
#include "llvm/IR/TypeFinder.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/Process.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/IR/InlineAsm.h"
#if LLVM_VERSION_CODE < LLVM_VERSION(3, 5)
#include "llvm/Support/CallSite.h"
#else
#include "llvm/IR/CallSite.h"
#endif

#ifdef HAVE_ZLIB_H
#include "klee/Internal/Support/CompressionStream.h"
#endif

#include <cassert>
#include <algorithm>
#include <iomanip>
#include <iosfwd>
#include <fstream>
#include <sstream>
#include <vector>
#include <string>

#include <sys/mman.h>

#include <errno.h>
#include <cxxabi.h>

using namespace llvm;
using namespace klee;

/* SYSREL extension */
#define ASYNC_STR "async_initiate"
#define ENABLE_STR "enable_entry"
#define STRUCT_LAZY_INIT_INS 10

extern std::fstream *dontcareStats;

extern Interpreter *theInterpreter;

std::set<klee::ExecutionState*> * successorsPaths = new std::set<klee::ExecutionState*>();

extern std::set<std::string> voidTypeCasts;
size_t maxVoidTypeCastSize = 8;

bool symbolizeInlineAssembly = false;
bool nullReturnValue = false;
std::map<long, std::map<std::string, unsigned> > forkFreqMapTrue;
std::map<long, std::map<std::string, unsigned> > forkFreqMapFalse;
std::set<std::string> loopBoundExceptions;
std::set<std::string> loopBoundExceptionFunctions;
unsigned loopBound = 0;
std::map<std::string, std::map<unsigned, 
         std::pair<unsigned, unsigned> > > dataConstraintMap;

std::map<std::string, std::vector<BoundAST> > fieldConstraintMap;

std::map<std::string, std::vector<BoundAST> > funcArgConstraintMap;



extern std::set<std::pair<long,long> > globalMetadataSetsToBeChecked;
extern std::map<ref<Expr>, std::pair<ref<Expr>,ref<Expr> > > globalRecordMetadataMap;
extern std::map<ref<Expr>, std::set<ref<Expr> > > globalMetadataSetMap;
extern std::map<std::pair<long,long>, std::string > globalMetadataMessage;
extern std::map<ref<Expr>, std::string> globalMetadataConditionMessage;

std::map<std::string, std::string> functionModeledBy;
std::map<std::string, std::set<unsigned> > havocArgs;


extern cl::opt<bool> DontCareTransitionMode;
extern cl::opt<std::string> ReachableStatesStepFunction;
extern cl::opt<std::string> ApproximateReachableStatesStepFunction;
double dontCareStartTime;

cl::opt<bool> 
TurnOffSymbAddressLI("turn-off-symaddr", 
                     cl::desc("Turn off the lazy init for symbolic addresses"), 
                     cl::init(false));  

cl::opt<std::string>
EntryPoint("entry-point",
               cl::desc("Consider the function with the given name as the entrypoint"),
               cl::init("main"));

cl::opt<bool> 
SkipSingletonHavocing("skip-singleton-havocing", cl::desc("Skip havocing singletons\n"), 
             cl::init(true));

cl::opt<bool> 
InitFuncPtrs("init-funcptr-fields" , cl::desc("Set function pointer fields to null when lazy initializing struct type objects"), 
             cl::init(false));

cl::opt<bool>
PreferredResolution("use-one-for-resol", cl::desc("Use the candidate memory object stored for the relevant symbolic address expression for symbolic address resolution!\n"), 
             cl::init(false));

cl::opt<bool>
InferDataConstraints("infer-data-const", cl::desc("Infers data constraints from memory out of bounds errors\n"));

cl::opt<bool>
RecordValueFlow("record-value-flow", cl::desc("Enables recording of the value flow with context\n"), 
                                                                          cl::init(false));

cl::opt<bool>
BreakSelectStmt("fork-for-select", cl::desc("Fork states to simulate the select statement\n"),
           cl::init(false));

cl::opt<bool>
ModelFuncWithInlineASM("model-func-with-asm", cl::desc("Models functions with inline asm"),
           cl::init(true));

cl::opt<bool>
ForwardTypeInference("infer-embedding-type", cl::desc("Perform forward analysis to infer enclosingtype\n"), 
           cl::init(true));


std::map<long, std::map<ref<Expr>, const MemoryObject *> > addressToMemObj;
std::map<long, std::map<ref<Expr>, ref<Expr> > > symIndexToMemBase;
extern std::set<std::string> assemblyFunctions;

KModule *kmoduleExt; 
llvm::Function *entryFunc;
extern const Module * moduleHandle;
extern bool asyncMode;
extern std::vector<std::string> asyncFunc;
extern std::vector<std::string> enabledFunc;
extern APIHandler *apiHandler;
extern bool progModel;
extern std::map<std::string, std::map<unsigned int, int> > lazyInitInitializersWValues;
extern std::map<std::string, std::map<unsigned int, int> > lazyInitInitializersWValuesUsingFields;
extern std::map<std::string, std::vector<unsigned int> > lazyInitInitializers;
extern std::map<std::string, std::map<unsigned int, std::string> > lazyFuncPtrInitializers;
extern std::map<std::string, std::map<unsigned int, std::string> > lazyFuncPtrInitializersUsingFields;
extern std::map<std::string, std::map<int, ConstrainValue_t> > argConstrainMap;
bool staticAllocStatTracking = true;
extern long staticAlloc;
std::map<std::string, std::set<std::string> > enforceOrigPatternWExceptions;
std::set<std::string> enforceOrig;
#define SIZE_FOR_UNTYPED 8 
std::map<long, std::map<int, std::set<std::string> > > stackTraceMap;
bool recordStackTraces = false;
int stackTraceCount = 3;

std::map<std::string, std::map<unsigned, unsigned> > initArgArray;
std::map<std::string, std::map<unsigned, unsigned> > initFieldArray;

// state to MemoryObject* (pointed by embedded pointer) to embedding type name and offset
std::map<long, std::map<long, std::pair<std::string, unsigned> > > lazyInitEmbeddedPointers;
std::map<long, std::map<long, std::map<std::pair<std::string, unsigned>, unsigned> > > concreteInference;
std::map<long, std::map<long, std::map<std::pair<std::string, unsigned>, 
                    std::set<std::pair<std::string, unsigned> > > > > symbolicInference;

// ExecutionState * to MemoryObject* to the negated symbolic expression
std::map<long, std::map<long, ref<Expr> > > mallocRelevantInferences;

extern void recordMemObj(ExecutionState &state, const MemoryObject *mo);
// keeps track of bitcast from some primitive type to some struct type vice versa
// computed on demand and for load instructions
std::map<Function*,std::map<Instruction*, Type*> > reachableBitcast;

// keeps track of ptrcast from int to some pointer type
// computed on demand and for load instructions
std::map<Function*,std::map<Instruction*, Type*> > reachableInttoPtrcast;

// keeps track of cast from a negative offset to an embedding type
// computed on demand and for load instructions
std::map<Function*,std::map<Instruction*, Type*> > reachableCastToEmbedding;

// mapping from ExecutionState addresses to MemoryObject addresses 
// to the allocatin size that are determined as part of lazy init 
std::map<long, std::map<long, unsigned int> > lazyInitConcreteAssumptions;

typedef std::vector<std::pair<Value*,ref<Expr> > > ValuedInst;

// a pair of context and valued instruction
typedef std::pair<std::string,ValuedInst> ValuedContext;

// a map from the destination to the source
typedef std::map<ValuedContext, std::set<ValuedContext> > ValueFlowGraph;

std::map<long, ValueFlowGraph> reverseVFG;

// ExecutionState * to ValuedContext* to symbolic branch condition
std::map<long, std::map<ValuedContext, ref<Expr> > > branchCondMap;

// ExecutionState * to MemoryObject* to a pair of Instruction * that allocates it and Value * for th$
std::map<long, std::map<long, ValuedContext> > memAllocMap;

std::map<std::string, std::map<unsigned, unsigned> > typeSpecificArrayFieldSize;
std::map<std::string, std::map<unsigned, unsigned> > funcSpecificArrayFieldSize;

std::string getTypeName(Type *t);

std::string getSourceWithContext(ExecutionState &state, KInstruction *ki);
void getEnclosingAndOffset(KInstruction *ki, std::pair<std::string, unsigned> &p, bool source);
int getTypeBaseInArray(const MemoryObject *mo, Type *qt, 
             unsigned addressClue);

void printContext(ValuedContext &vc) {
   llvm::errs() << "context=" << vc.first << " ops&values=\n";
   for(unsigned int i=0; i<vc.second.size(); i++)
      llvm::errs() << "op=" << (*vc.second[i].first) << " value=" << vc.second[i].second << "\n";
}

void recordMallocRelevantInference(ExecutionState &state, const MemoryObject *mo, ref<Expr> expr) {
     std::map<long, ref<Expr> > me;
     if (mallocRelevantInferences.find((long)&state) != mallocRelevantInferences.end())
        me = mallocRelevantInferences[(long)&state];
     me[(long)mo] = expr;
     mallocRelevantInferences[(long)&state] = me;
}

void recordMemAllocContext(ExecutionState &state, const MemoryObject *mo, ValuedContext vc) {
    std::map<long, ValuedContext> ma;
    if (memAllocMap.find((long)&state) != memAllocMap.end())
       ma = memAllocMap[(long)&state];
    ma[(long)mo] = vc;
    memAllocMap[(long)&state] = ma;
    llvm::errs() << "Recording mem alloc context for " << mo << "\n";
}

void getMemAllocContext(ExecutionState &state, const MemoryObject *mo, ValuedContext &vc) {
    std::map<long, ValuedContext> ma;
    if (memAllocMap.find((long)&state) != memAllocMap.end())
       ma = memAllocMap[(long)&state];
    if (ma.find((long)mo) != ma.end())
       vc = ma[(long)mo];  
}

void recordValueContextForBranch(ExecutionState &state, ValuedContext &vc, ref<Expr> cond) {
    std::map<ValuedContext, ref<Expr> > mb;    
    if (branchCondMap.find((long)&state) != branchCondMap.end())
       mb = branchCondMap[(long)&state];
    mb[vc] = cond;
    branchCondMap[(long)&state] = mb;
    llvm::errs() << "Branch condition " << cond << " to be recorded with valued context ";
    printContext(vc);
}


ref<Expr> getBranchCond(ExecutionState &state, ValuedContext &vc) {
    std::map<ValuedContext, ref<Expr> > mb;    
    if (branchCondMap.find((long)&state) == branchCondMap.end())
       return NULL;
    mb = branchCondMap[(long)&state];
    if (mb.find(vc) != mb.end())
       return mb[vc];
    else return NULL;
}


void printInferences() {
   std::fstream mc("mallocRelevantInferences.txt", std::fstream::out);
   if (mc.is_open()) {
      for(auto sme : mallocRelevantInferences) {
         for(auto me : sme.second) {
            std::string iss; 
            llvm::raw_string_ostream os(iss);
            ExprPPrinter::printSingleExpr(os, me.second);
            mc << "Negation of malloc size dependent condition:\n";
            mc << os.str() << "\n";
         }
      }
      mc.close();
   }

   std::fstream rc("concreteInferences.txt", std::fstream::out);
   if (rc.is_open()) {
      for(auto se : concreteInference) {
         for(auto me : se.second) {
            for(auto te : me.second) {
               rc << "Size of array in type " << te.first.first << " at offset " << te.first.second 
                  << " should be at least " << te.second << "\n";
            }
         }
      }
      rc.close();
   }

   std::fstream sc("symbolicInferences.txt", std::fstream::out);
   if (sc.is_open()) {
      for(auto se: symbolicInference) {
         for(auto me: se.second) {
            for(auto te : me.second) {
               sc << "Size of the array in type " 
                  << te.first.first << " at offset " << te.first.second 
                  << " restricts the following symbolic values \n";
               for(auto c : te.second) {
                 sc << c.first << "\n";
               }
            }
         }
      }
      sc.close();
   }
}

int getInitArgArraySize(std::string fname, unsigned argno) {
    std::map<unsigned, unsigned> m;
    if (initArgArray.find(fname) != initArgArray.end())
       m = initArgArray[fname];
    if (m.find(argno) != m.end())
       return m[argno];
    return 0;
}

int getInitFieldArray(std::string fname, unsigned offset) {
    std::map<unsigned, unsigned> m;
    if (initFieldArray.find(fname) != initFieldArray.end())
       m = initFieldArray[fname];
    if (m.find(offset) != m.end())
       return m[offset];
    return 0;
    
}


bool isMalloc(Instruction *inst, Function *f) {
  std::string iss; 
  llvm::raw_string_ostream os(iss);
  inst->print(os);
  std::string is = os.str(); 
  llvm::errs() << "instr str = " << is << "\n";
  std::string fs = f->getName();
  return (is.find("@malloc") != std::string::npos ||
          is.find("@realloc") != std::string::npos || 
          is.find("@kmalloc") != std::string::npos || 
          is.find("@kzalloc") != std::string::npos || 
          is.find("@krealloc") != std::string::npos || 
          fs.find("@malloc") != std::string::npos ||
          fs.find("@realloc") != std::string::npos || 
          fs.find("@kmalloc") != std::string::npos || 
          fs.find("@kzalloc") != std::string::npos || 
          fs.find("@krealloc") != std::string::npos); 

}

// the instruction ki->inst has just been executed
// the operands and the result, if any, have values
// operand 0, ..., n-1, and result, if any
// adds the data-flow edge in a reverse fashion
void Executor::generateValuedInstruction(ExecutionState &state, KInstruction *ki) {
   if (!ki) return;
   if (!ki->inst) return;
   // executing a return instruction may pop the stack frame so handled immediately after executing it
   if (ki->inst->getOpcode() == Instruction::Ret) return;
   ValuedInst old = state.lastValuedInst;
   std::string oldc = state.lastContext;
   llvm::errs() << "successors=" << successorsPaths->size() << "\n";
   for(auto succ : *successorsPaths) {
      int sf = succ->stackFrameBeforeExecInst;
      // this avoids null pointer issues related to ref<Expr>
      succ->dumpStack(llvm::errs()); 
      //for(unsigned int index = 0; index < succ->stack.back().kf->numRegisters; index++) {
        // llvm::errs() << succ->stack.back().locals[index].value << "\n";
      //}      
      llvm::errs() << "Stack frame for function " << succ->stack[sf].kf->function->getName() 
                   << " with " << succ->stack[sf].kf->numRegisters << " locals:\n";
      //for(unsigned int index = 0; index < succ->stackFrameBeforeExecInst->kf->numRegisters; index++) {
        // llvm::errs() << succ->stackFrameBeforeExecInst->locals[index].value << "\n";
      //}
      while (succ->lastValuedInst.size() > 0) {
            llvm::errs() << "size= " << succ->lastValuedInst.size()  << "\n";
            std::pair<Value*,ref<Expr> > le = succ->lastValuedInst.back();
            succ->lastValuedInst.pop_back();
      }
      llvm::errs() << "inst=" << (*ki->inst) << "\n";
      //if (ki->inst->getOpcode() == Instruction::Call) {
      if (isa<CallInst>(ki->inst) || isa<InvokeInst>(ki->inst)) {
         CallSite cs(ki->inst);
         Value *fp = cs.getCalledValue();
         Function *f = getTargetFunction(fp, state);
         if (!isa<InlineAsm>(fp) && f) {
            unsigned numArgs = cs.arg_size();
            for(unsigned int i=0; i < numArgs; i++) {
               std::pair<Value*,ref<Expr> > vp;
               vp.first = ((llvm::CallInst*)ki->inst)->getArgOperand(i);
               vp.second = NULL;
               llvm::errs() << " arg operand " << i << (*vp.first) << "\n";
               vp.second = eval(ki, i+1, *succ, &succ->stack[sf]).value;
               if (!vp.second.isNull()) {
                  llvm::errs() << "arg value " << vp.second << "\n";
                  succ->lastValuedInst.push_back(vp);
               }
            }
         }
      }
      else {
            for(unsigned int i=0; i<ki->inst->getNumOperands(); i++) {
               std::pair<Value*,ref<Expr> > vp;
               vp.first = ki->inst->getOperand(i);
               vp.second = NULL;
               llvm::Constant *c = dyn_cast<llvm::Constant>(vp.first);
               llvm::Instruction *ins = dyn_cast<llvm::Instruction>(vp.first);
               //llvm::Argument *arg = dyn_cast<llvm::Argument>(vp.first);
               if (c || ins) {
                  llvm::errs() << " operand " << i << (*vp.first) << "\n";
                  vp.second = eval(ki, i, *succ, &succ->stack[sf]).value;
                  if (!vp.second.isNull()) {
                     succ->lastValuedInst.push_back(vp);
                  }
               }
               else llvm::errs() << "skipping\n";
            }
      }
      succ->lastContext = getSourceWithContext(*succ,ki);
      ValuedContext vc = std::make_pair(succ->lastContext,succ->lastValuedInst);
      ValuedContext vcold = std::make_pair(oldc, old);
      ValueFlowGraph vfg;
      if (reverseVFG.find((long)succ) != reverseVFG.end())
         vfg = reverseVFG[(long)succ];
      std::set<ValuedContext> vs;
      if (vfg.find(vc) != vfg.end())
         vs = vfg[vc];
      vs.insert(vcold);
      vfg[vc] = vs;
      reverseVFG[(long)succ] = vfg;
      Function *func = (Function*)ki->inst->getParent()->getParent();
      if (isMalloc(ki->inst, func) && succ->lastMallocedMem)
         recordMemAllocContext(*succ, succ->lastMallocedMem, vc);
      if (ki->inst->getOpcode() == Instruction::Br && !succ->lastBranchInstConstraint.isNull())
         recordValueContextForBranch(*succ, vc, succ->lastBranchInstConstraint);
   }
}

bool isValid(TimingSolver *solver, ref<Expr> formula) {
   ref<Expr> t = klee::ConstantExpr::create(true, 1);
   std::vector<ref<Expr> > v;
   v.push_back(t);
   const std::vector<ref<Expr> > & vr = v;
   ExecutionState * solverState = new ExecutionState(vr);
   bool res = false;
   bool success = solver->mustBeTrue(*solverState, formula, res); 
   if (success)
      return res;
   else return false;
}

void collectDependentConds(ExecutionState &state, ValueFlowGraph vfg, ValuedContext &vc, 
           std::set<ValuedContext> &seen, std::vector<ref<Expr> > &mcond, TimingSolver *solver) {
   if (seen.find(vc) != seen.end()) {
      llvm::errs() << "context seen before:\n";
      printContext(vc);
      return; 
   }
   seen.insert(vc);
   ref<Expr> cond = getBranchCond(state, vc);
   if (!cond.isNull()) {
      bool found = false;
      for(unsigned int i=0; i<mcond.size() && !found; i++) {
          ref<Expr> f1 = AndExpr::create(mcond[i], cond);
          ref<Expr> nc = Expr::createIsZero(cond);
          ref<Expr> nmc = Expr::createIsZero(mcond[i]);
          ref<Expr> f2 = AndExpr::create(nc, nmc);
          ref<Expr> eqv = OrExpr::create(f1, f2);
          if (isValid(solver, eqv)) {
             llvm::errs() << "Are " << mcond[i] << " and " << cond << " equivalent? ";  
             found = true;
             llvm::errs() << "yes!\n";
          }
          else llvm::errs() << "no!\n";
      } 
      if (!found)
         mcond.push_back(cond);
   }
   else {
      llvm::errs() << "No branch condition for context:\n";
      printContext(vc);
   }
   std::set<ValuedContext> vs;
   if (vfg.find(vc) != vfg.end())
      vs = vfg[vc];
   llvm::errs() << "predecessors of context=" << vs.size() << "\n";
   printContext(vc);
   for(auto vci : vs) {
      llvm::errs() << "predecessor context:\n";
      printContext(vci);
      collectDependentConds(state, vfg, vci, seen, mcond, solver);
   }
}




ref<Expr> getMallocDependentBranchCondition(ExecutionState &state, const MemoryObject *mo, 
         TimingSolver *solver) {
   // find the ContextValue for the relevant malloc
   ValuedContext vc;
   vc.first = "none";
   getMemAllocContext(state, mo, vc);
   if (vc.first == "none") {
      llvm::errs() << "No memory alloc context for " << mo << "\n";
      return NULL;
   }
   // vc stored the valued context of the malloc instruction, now follow the path backward
   std::vector<ref<Expr> > conds;
   ValueFlowGraph vfg;
   if (reverseVFG.find((long)&state) != reverseVFG.end())
      vfg = reverseVFG[(long)&state];
   std::set<ValuedContext> seen;
   ref<Expr> mcond = NULL;
   collectDependentConds(state,vfg,vc,seen,conds,solver);
   if (conds.size() > 0) {
      printContext(vc);
      ref<Expr> temp = conds[0];
      for(unsigned int i=1; i<conds.size(); i++) {
         ref<Expr> temp2 = AndExpr::create(conds[i], temp);
         temp = temp2;
      }
      mcond = Expr::createIsZero(temp);
      llvm::errs() << "Collected malloc dependent condition " << mcond << "\n";
   }
   return mcond;   
}

void recordLazyInitEmbeddedPointers(ExecutionState &state, const MemoryObject *mo, 
                                                         Type *t, unsigned offset) {
         
     std::map<long, std::pair<std::string, unsigned> > m;
     if (lazyInitEmbeddedPointers.find((long)&state) != lazyInitEmbeddedPointers.end())
        m = lazyInitEmbeddedPointers[(long)&state];
     std::pair<std::string, unsigned> p;
     p.first = getTypeName(t);
     p.second = offset;
     m[(long)mo] = p;
     lazyInitEmbeddedPointers[(long)&state] = m;
     llvm::errs() << "recording for state " << &state 
                  << " memoryobject " << mo << " with base address " << mo->getBaseExpr() 
                  << " embedding type " << p.first << " and offset=" << p.second << "\n";
}

void recordConcreteInference(ExecutionState &state, const MemoryObject *mo, 
                std::pair<std::string, unsigned> p, unsigned size) {
   
    std::map<long, std::map<std::pair<std::string, unsigned>, unsigned> > m1;
    std::map<std::pair<std::string, unsigned>, unsigned> m2;
    if (concreteInference.find((long)&state) != concreteInference.end())
       m1 = concreteInference[(long)&state];
    if (m1.find((long)mo) != m1.end())
       m2 = m1[(long)mo];
    unsigned max = 0;
    if (m2.find(p) != m2.end())
       max = m2[p];
    if (size > max)
       m2[p] = size;
    m1[(long)mo] = m2;
    concreteInference[(long)&state] = m1;
}

void recordSymbolicInference(ExecutionState &state, const MemoryObject *mo, 
                                          std::pair<std::string, unsigned> p, 
                                               std::pair<std::string, unsigned> pv) {

     std::map<long, std::map<std::pair<std::string, unsigned>, 
                    std::set<std::pair<std::string, unsigned> > > > m1;
     std::map<std::pair<std::string, unsigned>, 
                    std::set<std::pair<std::string, unsigned> > > m2;

     if (symbolicInference.find((long)&state) != symbolicInference.end())
        m1 = symbolicInference[(long)&state];
     if (m1.find((long)mo) != m1.end())
        m2 = m1[(long)mo];
     std::set<std::pair<std::string, unsigned> > s;
     if (m2.find(p) != m2.end())
        s = m2[p];
     s.insert(pv);
     m2[p] = s;
     m1[(long)mo] = m2;
     symbolicInference[(long)&state] = m1;
}

void inferConstraintFromMemoryError(ExecutionState &state, const MemoryObject *mo, 
      ref<Expr> address, KInstruction *target, TimingSolver *solver) {

   ref<Expr> mdexp = getMallocDependentBranchCondition(state, mo, solver);
   if (!mdexp.isNull()) {
      llvm::errs() << "Malloc relevant inference: " << mdexp << "\n";
      recordMallocRelevantInference(state, mo, mdexp);
   }

   std::map<long, std::pair<std::string, unsigned> > m;
   if (lazyInitEmbeddedPointers.find((long)&state) == lazyInitEmbeddedPointers.end()) {
      llvm::errs() << "could not find the state " << &state << " in lazyInitEmbeddedPointers!\n";
      return;
  }
   m = lazyInitEmbeddedPointers[(long)&state];
   if (m.find((long)mo) == m.end()) {
      llvm::errs() << "could not find the memory object  " << mo 
                   << " with base address " << mo->getBaseExpr() << " in lazyInitEmbeddedPointers!\n";
      return;
   }
   std::pair<std::string,unsigned> p = m[(long)mo];
   ref<Expr> offset = mo->getOffsetExpr(address);
   llvm::errs() << "Inferring constraint for memory out of bound type="
                << p.first << " offset=" << p.second << "\n";
   if (klee::ConstantExpr *CE = dyn_cast<klee::ConstantExpr>(offset)) {
      Expr::Width type = ((Executor*)(theInterpreter))->getWidthForLLVMType(target->inst->getType());
      unsigned bytes = Expr::getMinBytesForWidth(type);
      unsigned index = CE->getZExtValue() / bytes;
      recordConcreteInference(state, mo, p, index);   
      llvm::errs() << "Suggested concrete new size=" << index << "\n";
   }
   else {
     std::pair<std::string, unsigned> ps, pv;
     ps.first = pv.first = "";
     ps.second = pv.second = 0;
     getEnclosingAndOffset(target,ps,true); // get base info
     getEnclosingAndOffset(target,pv,false); // get index info
     if (ps.first != "" && pv.first != "") {
        recordSymbolicInference(state, mo, ps, pv);
        llvm::errs() << "Variable offset to be constrained: " 
                     << "type=" << pv.first << " offset=" << pv.second
                     << "for base pointer " << ps.first << "offset=" << ps.second << "\n";
     }
   }
}

void recordLazyInitMemoryObject(ExecutionState &state, const MemoryObject *mo) {
   long sa = (long)&state;
   long moa = (long)mo;
   std::map<long, unsigned int> m;
   if (lazyInitConcreteAssumptions.find(sa) != lazyInitConcreteAssumptions.end()) 
      m = lazyInitConcreteAssumptions[sa];
   m[moa] = mo->size;
   lazyInitConcreteAssumptions[sa] = m;
}




void Executor::checkMetadataOnCondition(ExecutionState &state) {
    llvm::errs() << "CHECK METADATA COND on STATE " << &state << "\n";
    for(auto e : globalRecordMetadataMap) {
       bool resF, resT;
       bool successF __attribute__ ((unused)) = solver->mustBeFalse(state, e.first, resF);
       bool successT __attribute__ ((unused)) = solver->mustBeTrue(state, e.first, resT);


      ref<Expr> setT = e.second.first;
      ref<Expr> setF = e.second.second; 

      llvm::errs() << "checking metadata condition " << e.first << " " << resT << " " << resF << "\n";
      llvm::errs() << "keys: " << setT << " " << setF << "\n";
      ExprPPrinter::printConstraints(llvm::errs(), state.constraints);

      assert(successF && successT && "FIXME: Unhandled solver failure");
      if (resT) {
         std::set<ref<Expr> > ms;
         if (globalMetadataSetMap.find(setT) != globalMetadataSetMap.end()) 
            ms = globalMetadataSetMap[setT]; 
         ms.insert(klee::ConstantExpr::create((long)&state,64));
         globalMetadataSetMap[setT] = ms;
         llvm::errs() << "Adding metadata " << ((long)&state) << " to the set of " << setT << "\n";
      }
     else if (resF) {
        std::set<ref<Expr> > ms;
        if (globalMetadataSetMap.find(setF) != globalMetadataSetMap.end()) 
           ms = globalMetadataSetMap[setF]; 
        ms.insert(klee::ConstantExpr::create((long)&state,64));
        globalMetadataSetMap[setF] = ms;
        llvm::errs() << "Adding metadata " << ((long)&state) << " to the set of " << setF << "\n";
     } else { // both are feasible so add the state pointer to both sets
       std::set<ref<Expr> > ms1;
       if (globalMetadataSetMap.find(setT) != globalMetadataSetMap.end()) 
          ms1 = globalMetadataSetMap[setT]; 
       ms1.insert(klee::ConstantExpr::create((long)&state,64));
       globalMetadataSetMap[setT] = ms1;
       llvm::errs() << "Adding metadata " << ((long)&state) << " to the set of " << setT << "\n";
 
       std::set<ref<Expr> > ms;
       if (globalMetadataSetMap.find(setF) != globalMetadataSetMap.end()) 
          ms = globalMetadataSetMap[setF]; 
       ms.insert(klee::ConstantExpr::create((long)&state,64));
       globalMetadataSetMap[setF] = ms;
       llvm::errs() << "Adding metadata " << ((long)&state) << " to the set of " << setF << "\n";
     }

      std::pair<long,long> dp;
      if (globalMetadataSetMap.find(setT) != globalMetadataSetMap.end()) 
         dp.first = (long)&globalMetadataSetMap[setT];
      if (globalMetadataSetMap.find(setF) != globalMetadataSetMap.end()) 
         dp.second = (long)&globalMetadataSetMap[setF];
      llvm::errs() << "metadata set addresses: " << dp.first << " " << dp.second << "\n";
      globalMetadataSetsToBeChecked.insert(dp);

      globalMetadataMessage[dp] = globalMetadataConditionMessage[e.first];

  }

}

void performMetadataChecks() {
     llvm::errs() << "Performing metadata checks pairs=" << globalMetadataSetsToBeChecked.size() << "\n";
     for(auto mp : globalMetadataSetsToBeChecked) {
        std::set<ref<Expr> > *s1 = (std::set<ref<Expr> > *)mp.first;
        std::set<ref<Expr> > *s2 = (std::set<ref<Expr> > *)mp.second;
        llvm::errs() << "Metadata check results\n";
        llvm::errs() << "Set 1: \n";
        for(auto m1 : *s1) 
           llvm::errs() << m1 << "\n";
        llvm::errs() << "Set 2: \n";
        for(auto m2 : *s2) 
           llvm::errs() << m2 << "\n";
        for(auto m1 : *s1) {
           if (s2->find(m1) == s2->end()) {
              llvm::errs() << globalMetadataMessage[mp] << "\n";
              llvm::errs() << m1 << " not found in the 2nd set!\n";
           }
        }
     }
}

bool getDataConstraint(std::string tname, unsigned offset, 
                                  std::pair<unsigned, unsigned> &fieldinfo) {
     for(auto mi : dataConstraintMap) {
        if (mi.first.find(tname) != std::string::npos || 
               tname.find(mi.first) != std::string::npos) {
           std::map<unsigned, std::pair<unsigned, unsigned> > map = mi.second;
           if (map.find(offset) != map.end()) {
              fieldinfo = map[offset];
              return true;
           }
           else return false;
        }
     }  
     return false;
}

void getEnclosingAndOffset(KInstruction *ki, std::pair<std::string, unsigned> &p, bool base) {
   llvm::errs() << "finding source gep for moo instruction : " << (*ki->inst) << "\n"; 
   std::vector<Value *>  wl;
   LoadInst *li = dyn_cast<LoadInst>(ki->inst);
   std::set<Value*> seen;
   wl.push_back(li->getOperand(0));
   bool gepseen = false;
   while (wl.size() > 0) {
      Value *val = wl.back();
      seen.insert(val);
      wl.pop_back();
      Instruction *ti = dyn_cast<Instruction>(val);
      if (!ti) continue;
      switch (ti->getOpcode()) {
        case Instruction::GetElementPtr: { 
           GetElementPtrInst *gep = dyn_cast<GetElementPtrInst>(ti);
           if (gepseen) {
              llvm::errs() << "second gep: " << (*gep) << "\n";
              Type *etype = gep->getPointerOperand()->getType();
              if (etype->isPointerTy())
                 etype = etype->getPointerElementType();
              std::string str;
              llvm::raw_string_ostream os(str);
              os << (*gep) ;
              p.first = getTypeName(etype) + " " + os.str();
              p.second = 0;              
              //gep->print(llvm::errs()); 
           }
           else {
              llvm::errs() << "first gep: " << (*gep) << "\n";
              gepseen = true; 
              if (base) 
                 wl.push_back(gep->getPointerOperand());
              else {
                 for(llvm::User::op_iterator it = gep->idx_begin(); it != gep->idx_end(); it++)
                    wl.push_back(*it);
              }
           }
           break;
        }
        default: {
          for(unsigned int i=0; i<ti->getNumOperands(); i++) {
             if (seen.find(ti->getOperand(i)) == seen.end())
                wl.push_back(ti->getOperand(i));
          }
        }
      }      
   }
}

Type *getEnclosingObjectType(Instruction *inst) {
   std::vector<Value *>  wl;
   LoadInst *li = dyn_cast<LoadInst>(inst);
   if (!li) assert(0 && "bitcast info must be computed for load instructions!");
   Type *result = NULL;
   std::set<Value*> seen;
   wl.push_back(li);
   std::set<Type*> candidates;
   while (wl.size() > 0) {
      Value *val = wl.back();
      seen.insert(val);
      wl.pop_back();
      Instruction *ti = dyn_cast<Instruction>(val);
      if (!ti) { 
         Type *ct = val->getType();
         if (ct->isPointerTy()) {
            ct = ct->getPointerElementType();
            if (ct->isPointerTy()) {
               ct = ct->getPointerElementType(); 
            }
         }
         StructType *st = dyn_cast<StructType>(ct);
         if (st) 
            candidates.insert(st);
         continue;
      }
      //llvm::errs() << "traversing " << (*ti) << "\n";
      switch (ti->getOpcode()) {
        case Instruction::Load: {
           if (ti != li) {
              result = ti->getType();
              if (result->isPointerTy()) {
                 result = result->getPointerElementType();
                 if (result->isPointerTy()) {
                    result = result->getPointerElementType(); 
                 }
              }
              StructType *st = dyn_cast<StructType>(result);
              if (st) 
                 return result; 
              else return NULL;
           }
        }
        default: {
          for(unsigned int i=0; i<ti->getNumOperands(); i++) {
             if (seen.find(ti->getOperand(i)) == seen.end())
                wl.push_back(ti->getOperand(i));
          }
        }
      }      
   }
   if (result == NULL) {
      if (candidates.size() == 1) {
         for(auto t: candidates)
            return t; 
      }
   }
   return result;
}

Type *inferEnclosingTypeDueToPointerArithmetic(Instruction *inst) {
  Function *f = inst->getParent()->getParent(); 
  std::map<Instruction*, Type*> info; 
  if (reachableCastToEmbedding.find(f) != reachableCastToEmbedding.end()) {
     info = reachableCastToEmbedding[f];
     if (info.find(inst) != info.end()) {
         return info[inst];
     }
  }
  // no record; go ahead and compute, if any
   std::set<GetElementPtrInst*> candidateGeps;
   std::vector<Value *>  wl;
   LoadInst *li = dyn_cast<LoadInst>(inst);
   if (!li) assert(0 && "bitcast info must be computed for load instructions!");
   //std::string i8("i8");
   std::set<Value*> seen;
   wl.push_back(li);
   while (wl.size() > 0) {
      Value *val = wl.back();
      seen.insert(val);
      wl.pop_back();
      Instruction *ti = dyn_cast<Instruction>(val);
      if (!ti) continue;
      for(llvm::Value::user_iterator it = ti->user_begin(); it != ti->user_end(); it++) {
         Instruction *uit = dyn_cast<Instruction>(*it);
         if (!uit) continue;
         if (uit->getOpcode() == Instruction::GetElementPtr) {
            GetElementPtrInst *gep = dyn_cast<GetElementPtrInst>(uit); 
            for(User::const_op_iterator oi = gep->idx_begin(), 
                               oe = gep->idx_end(); oi != oe; oi++) {
                     Value *v = oi->get();
                     if (ConstantInt* CI = dyn_cast<ConstantInt>(v)) {
                        if (CI->getSExtValue() < 0) {
                           candidateGeps.insert(gep);
                           break;
                        }
                     }           
            } 
         }
         if (uit->getOpcode() != Instruction::Load && seen.find(uit) == seen.end())             
            wl.push_back(uit);
      }
  }

  if (candidateGeps.size() == 0)
     return NULL;
  
  std::set<Type*> candidates;

  for(auto cgep : candidateGeps) {
     for(llvm::Value::user_iterator it = cgep->user_begin(); it != cgep->user_end(); it++) {
        llvm::Instruction *user = dyn_cast<Instruction>(*it);
        if (user && user->getOpcode() == Instruction::BitCast) {
           Type *t = user->getType();
           if (t->isPointerTy()) {
              Type *et = t->getPointerElementType();
              StructType *st = dyn_cast<StructType>(et);
              if (st) {
                 candidates.insert(st);
                 llvm::errs() << "Inferring embedding type " << getTypeName(st) 
                              << " for " << (*inst) << "\n";
              }
           }
        }
     }
  }

  if (candidates.size() > 1)
     return NULL;
  for(auto c : candidates)
     return c;
  return NULL;
}


Type *checkPossiblePtrCast(Instruction *inst) {
  Function *f = inst->getParent()->getParent();
  std::map<Instruction*, Type*> info; 
  if (reachableInttoPtrcast.find(f) != reachableInttoPtrcast.end()) {
     info = reachableInttoPtrcast[f];
     if (info.find(inst) != info.end()) {
         return info[inst];
     }
  }
   // no record; go ahead and compute (may end up producing no intoptr so NULL value)
   DataLayout *targetData = kmoduleExt->targetData;
   std::set<Type*> candidatePtrs;
   LoadInst *li = dyn_cast<LoadInst>(inst);
   if (!li) assert(0 && "intoptr info must be computed for load instructions!");
   for(llvm::Value::user_iterator it = li->user_begin(); it != li->user_end(); it++) {
      llvm::Instruction *user = dyn_cast<Instruction>(*it);
      if (user) {
         if (user->getOpcode() == Instruction::IntToPtr) {
            Type *pt = user->getType();
            candidatePtrs.insert(pt);
         } 
      } 
   }
   if (candidatePtrs.size() > 0) {
      // choose the one with the largest size!
      Type *chosen = NULL;
      uint64_t max = 0; 
      for(auto cpt : candidatePtrs) {
         Type *ct = cpt->getPointerElementType();
         uint64_t value = targetData->getTypeAllocSize(ct);
         if (value > max) {
            chosen = cpt;
            max = value;
         }
      }
      if (chosen)
         llvm::errs() << "Chosen type " << getTypeName(chosen) << " with max size " << max << "\n"; 
      info[inst] = chosen;
      reachableInttoPtrcast[f] = info;
      return chosen;
   }
   else {
      llvm::errs() << "Couldn't find any relevant bitcast to/from for " << (*inst) << "\n";
      info[inst] = NULL;
      reachableInttoPtrcast[f] = info;
      return NULL;
   }
}


// find bitcasts from i8 to some struct type vice versa
Type *checkAndComputeBitcastInfo(Instruction *inst, std::string ctype) {
   Function *f = inst->getParent()->getParent();
   std::map<Instruction*, Type*> info;
   if (reachableBitcast.find(f) != reachableBitcast.end()) {
      info = reachableBitcast[f];
      if (info.find(inst) != info.end()) {
         return info[inst];
      }
   }
   // no record; go ahead and compute (may end up producing no bitcast so NULL value)
   DataLayout *targetData = kmoduleExt->targetData;
   std::set<Type*> candidates;
   std::vector<Value *>  wl;
   LoadInst *li = dyn_cast<LoadInst>(inst);
   if (!li) assert(0 && "bitcast info must be computed for load instructions!");
   //std::string i8("i8");
   std::set<Value*> seen;
   wl.push_back(li);
   while (wl.size() > 0) {
      Value *val = wl.back();
      seen.insert(val);
      wl.pop_back();
      Instruction *ti = dyn_cast<Instruction>(val);
      if (!ti) continue;
      //llvm::errs() << "work list element: " << (*ti) << "\n";
      switch (ti->getOpcode()) {
         case Instruction::PHI: {
              PHINode *phi = (PHINode*)(ti);
              for(unsigned int i=0; i < phi->getNumIncomingValues(); i++) {
                 if (seen.find(phi->getIncomingValue(i)) == seen.end()) 
                    wl.push_back(phi->getIncomingValue(i));
              }
              break;
         }
         case Instruction::BitCast: {
              Type *t = ti->getType();
              if (t->isPointerTy())
                 t = t->getPointerElementType();
              StructType *tstruct = dyn_cast<StructType>(t);  
              Type *frt = ti->getOperand(0)->getType();
              if (frt->isPointerTy())
                 frt = frt->getPointerElementType();
              StructType *frtstruct = dyn_cast<StructType>(frt); 
              std::string st = getTypeName(t);
              std::string sfrt = getTypeName(frt);
              //llvm::errs() << "checking cast bw " << st << " and " << sfrt << " in " << (*ti) << " for " << (*inst) << "\n";
              if ((st.find(ctype) != std::string::npos || sfrt.find(ctype) != std::string::npos) 
                               && (tstruct || frtstruct)) {
                 if (tstruct)  {
                    candidates.insert(tstruct);
                 }
                 if (frtstruct) {
                    candidates.insert(frtstruct);
                 }
              }
         } // will also analyze bitcast operands!
         default: {
             for(unsigned int i=0; i<ti->getNumOperands(); i++) {
                if (seen.find(ti->getOperand(i)) == seen.end())
                   wl.push_back(ti->getOperand(i));
             }
         }
      }
   }
   if (candidates.size() > 0) {
      // choose the one with the largest size!
      Type *chosen = NULL;
      uint64_t max = 0; 
      for(auto ct : candidates) {
         uint64_t value = targetData->getTypeAllocSize(ct);
         if (value > max) {
            chosen = ct;
            max = value;
         }
      }
      if (chosen)
         llvm::errs() << "Chosen type " << getTypeName(chosen) << " with max size " << max << "\n"; 
      info[inst] = chosen;
      reachableBitcast[f] = info;
      return chosen;
   }
   else {
      llvm::errs() << "Couldn't find any relevant bitcast to/from " << ctype << " for " << (*inst) << "\n";
      info[inst] = NULL;
      reachableBitcast[f] = info;
      return NULL;
   }
}


bool isLoopBoundExcluded(std::string s, std::string fname) {

  for(auto se : loopBoundExceptionFunctions) {
     if (fname.find(se) != std::string::npos) return true; 
  }  
  for(auto se : loopBoundExceptions) {
     if (s.find(se) != std::string::npos) return true; 
  }
  return false;
}

void addForkFreq(ExecutionState &state, std::string inst, bool isTrue) {
  long s = (long)&state;
  std::map<std::string, unsigned> m;
  if (isTrue) {
     if (forkFreqMapTrue.find(s) != forkFreqMapTrue.end()) 
        m = forkFreqMapTrue[s];
     if (m.find(inst) != m.end()) 
        m[inst] = m[inst] + 1;
     else 
        m[inst] = 1;
     forkFreqMapTrue[s] = m;
  }
  else {
     if (forkFreqMapFalse.find(s) != forkFreqMapFalse.end()) 
        m = forkFreqMapFalse[s];
     if (m.find(inst) != m.end()) 
        m[inst] = m[inst] + 1;
     else 
        m[inst] = 1;
     forkFreqMapFalse[s] = m;  
  }
}

unsigned getForkFreq(ExecutionState &state, std::string inst, bool isTrue) {
  long s = (long)&state;
  std::map<std::string, unsigned> m;
  //llvm::errs() << "fork freq for " << inst << "\n";
  if (isTrue) {
     if (forkFreqMapTrue.find(s) != forkFreqMapTrue.end()) 
        m = forkFreqMapTrue[s];
     if (m.find(inst) != m.end()) 
        return m[inst];
     else return 0;
  }
  else {
     if (forkFreqMapFalse.find(s) != forkFreqMapFalse.end()) 
        m = forkFreqMapFalse[s];
     if (m.find(inst) != m.end()) 
        return m[inst];
     else return 0; 
  }
}


std::string getAsyncFunction(std::string fn) {
  
  return fn.substr(fn.find(ASYNC_STR) + strlen(ASYNC_STR) + 1, fn.size());
}

std::string getEnableFunction(std::string fn) {
  
  return fn.substr(fn.find(ENABLE_STR) + strlen(ENABLE_STR) + 1, fn.size());
}

bool isAssemblyFunc(std::string name) {
  for(auto af : assemblyFunctions)
     if (af == name)
        return true;
  return false;
}



extern bool lazyInit;
extern bool lazySpec;
extern int numLazyInst;
extern std::vector<std::string> lazyInits;
extern std::set<std::string> lazyInitSingles;
extern std::map<std::string, int> lazyInitNumInstances;
std::map<long, std::set<uint64_t> > singlesAndDerivatives;
//std::set<std::string> embeddedTypes;
std::set<Type*> embeddedTypes;
//std::map<std::string, std::set<std::string> >  embeddings;
std::map<Type*, std::set<Type*> >  embeddingTypes;
bool singleSuccessor = true;
std::map<std::string, int> uniqueSym;
int primArraySize = 32;

bool isSingleOrDerivative(ExecutionState &state, ref<Expr> address) {
   if (klee::ConstantExpr *CE = dyn_cast<klee::ConstantExpr>(address)) {
      long st = (long)&state;
      if (singlesAndDerivatives.find(st) != singlesAndDerivatives.end()) {
         std::set<uint64_t> sdset = singlesAndDerivatives[st];
         return sdset.find(CE->getZExtValue()) != sdset.end();
      }
      return false;
   }
   return false;
}

void addSingleOrDerivative(ExecutionState &state, ref<Expr> address) {
  if (klee::ConstantExpr *CE = dyn_cast<klee::ConstantExpr>(address)) {  
     std::set<uint64_t> sdset; 
     long st = (long)&state;
     if (singlesAndDerivatives.find(st) != singlesAndDerivatives.end())
        sdset = singlesAndDerivatives[st];
     sdset.insert(CE->getZExtValue());
     singlesAndDerivatives[st] = sdset;
  }
}

void copySingleOrDerivative(ExecutionState &to, const ExecutionState &from) {
  std::set<uint64_t> sdset; 
  long frst = (long)&from;
  long tost = (long)&to;
  if (singlesAndDerivatives.find(frst) != singlesAndDerivatives.end()) {
     sdset = singlesAndDerivatives[frst];
     singlesAndDerivatives[tost] = sdset;
  }
}

std::string getUniqueSymRegion(std::string name) {
  unsigned id;
  std::string result;
  if (uniqueSym.find(name) == uniqueSym.end()) 
     id = 0;
  else id = uniqueSym[name];
  result = name + "_" + llvm::utostr(id++);
  uniqueSym[name] = id;
  return result;   
}


std::string removeDotSuffix(std::string name) {
  size_t pos = name.find(".");
  if (pos != std::string::npos)  {
     if (name.length() > pos) {
        // we want to get the original name when functions copies are made based on numbering
        // and keep other suffixes, e.g., those used in intrinsics
        if (isdigit(name[pos+1]))
           return name.substr(0,name.find("."));
     }
     // unlikely but better to get rid of the single dot!
     else return name.substr(0,name.find("."));
  }
  return name;
}


// trim from left
inline std::string& ltrim(std::string& s, const char* t = " \t\n\r\f\v")
{
    s.erase(0, s.find_first_not_of(t));
    return s;
}

// trim from right
inline std::string& rtrim(std::string& s, const char* t = " \t\n\r\f\v")
{
    s.erase(s.find_last_not_of(t) + 1);
    return s;
}

std::string getTypeName(Type *t) {
   std::string type_str;
   llvm::raw_string_ostream rso(type_str);
   t->print(rso);
   std::istringstream iss(rso.str());
   std::string typestr;
   getline(iss, typestr, ' ');
   return typestr;
}

void computeMaxVoidTypeCastSize() {
   maxVoidTypeCastSize = 8;
   DataLayout *targetData = kmoduleExt->targetData;
   llvm::TypeFinder StructTypes;
 
   StructTypes.run(*(kmoduleExt->module), true);
   for(auto vct : voidTypeCasts) {
      for (auto *STy : StructTypes) {
         std::string tname = getTypeName(STy);
         if (tname.find(vct) != std::string::npos) 
            if (targetData->getTypeStoreSize(STy) > maxVoidTypeCastSize) {
               llvm::errs() << "Storing size of " << tname << " for max void cast size: " << targetData->getTypeStoreSize(STy) << " \n";
               maxVoidTypeCastSize = targetData->getTypeStoreSize(STy);   
            } 
      }
   } 
}

std::string simplifyName(std::string n) {
  std::string stok = "struct.";
  std::string::size_type pos = n.find(stok);
  if (pos != std::string::npos)
     n = n.substr(pos+7);
  pos = n.find(".");
  if (pos != std::string::npos)
     n = n.substr(0,pos);
  return n;
}

// Applies data constraints (except size_of constraints) for type t as specified 
// also does the same for embedded types by calling itself recursively
void applyDataConstraint(ExecutionState &state, TimingSolver *solver, const MemoryObject *mo, 
      Type *t, ObjectState *obj, unsigned baseOffset, bool equality) {
  DataLayout *targetData = kmoduleExt->targetData;
  StructType *st = dyn_cast<StructType>(t);
  if (st) {
     const StructLayout *sl = targetData->getStructLayout(st);
     std::string tname = getTypeName(t);
     std::string type_str;
     llvm::raw_string_ostream rso(type_str);
     t->print(rso);
     std::string::size_type pos = tname.find("struct");
     if (pos == std::string::npos) {
        return;
     }
    tname = tname.substr(pos);    
     llvm::errs() << "checking initializers for type " << tname 
                  << " with offset to mo " << baseOffset << "!\n";
     std::string sname = simplifyName(tname);
     llvm::errs() << "Simplified type name " << sname << "\n";
     if (fieldConstraintMap.find(sname) != fieldConstraintMap.end()) {
        std::vector<BoundAST> bv = fieldConstraintMap[sname];
        for(unsigned bi = 0; bi<bv.size(); bi++) {
           llvm::errs() << "checking compound type for:\n";
           bv[bi].ast->print();
           bool compound = false;
           for(auto bm : bv[bi].bindings) {
              if (bm.second.comptype != "none") { 
                 compound = true; 
                 break;
              }
           }
           if (!compound) {
              llvm::errs() << "handling bound constraint:\n";
              bv[bi].ast->print();
              if (equality && isSimpleEquality(bv[bi])) {
                 //ObjectState *wobj = state.addressSpace.getWriteable(mo, obj); 
                 applyEquality(bv[bi], mo, obj, baseOffset, st, sl);
              }
              if (!equality && !isSimpleEquality(bv[bi])) {                  
                 ref<Expr> cexp = generateExp(bv[bi], mo, obj, baseOffset, st, sl);
                 if (!cexp.isNull()) {
                    bool result;
                    bool success = solver->mayBeTrue(state, cexp, result);
                    assert(success && "Solver failure during consistency checking!");
                    if (result) {
                       llvm::errs() << "constraint spec:\n";
                       bv[bi].ast->print();
                       llvm::errs() << "generated exp " << cexp << "\n";
                       ((Executor*)theInterpreter)->addConstraint(state, cexp);
                    }
                    else 
                        state.terminated = true;
                 }
              }
           }
        }
     }
     // check and handle embedded types..
     for(unsigned i=0; i<st->getNumElements(); ++i) {
        Type *et = st->getElementType(i);
        StructType *est = dyn_cast<StructType>(et);
        if (est) {
           unsigned eo = sl->getElementOffset(i);
           applyDataConstraint(state, solver, mo, et, obj, baseOffset + eo, equality);
        }
     }
  }
}

void applyDataConstraintToArray(ExecutionState &state, TimingSolver *solver, 
      const MemoryObject *mo, ObjectState *obj, unsigned baseOffset, 
                    unsigned count, bool equality) {
    DataLayout *targetData = kmoduleExt->targetData;
    for(unsigned i = 0; i<count; i++) {
       unsigned newbaseOffset = i * targetData->getTypeAllocSize(mo->baseType);
       llvm::errs() << "Applying data constraint to array cell " << i 
                    << " for type " << getTypeName(mo->baseType) << "\n";
       applyDataConstraint(state, solver, mo, mo->baseType, obj, newbaseOffset, equality);
    }
}

unsigned getSizeofSpecObject(const MemoryObject *mo, Type *et, Type *t, ref<Expr> address, 
                                   unsigned offset, unsigned baseaddress) {
    StructType *est = dyn_cast<StructType>(et);
    if (!est) return 0;
    Type *pt = t->getPointerTo();

    DataLayout *targetData = kmoduleExt->targetData;
    const StructLayout *sl = targetData->getStructLayout(est);
    assert(dyn_cast<klee::ConstantExpr>(address) && "expected constant value for address!\n");
    unsigned av = dyn_cast<klee::ConstantExpr>(address)->getZExtValue();
    unsigned oint = av - baseaddress;
    std::string etname = getTypeName(et);
    std::string setname = simplifyName(etname);
    if (typeSpecificArrayFieldSize.find(setname) != typeSpecificArrayFieldSize.end()) {
 
       llvm::errs() << "\n enclosing type: " << setname 
                    << "\n mo base: " << mo->getBaseExpr()
                    << "\n address: " << address
                    << "\n offset: " << offset 
                    << "\n computed offset: " << oint
                    << "\n";

       std::map<unsigned, unsigned> m;
       m = typeSpecificArrayFieldSize[setname];
       bool found = false;
       for(unsigned i=0; i<est->getNumElements(); i++) {
          if (est->getElementType(i) == pt && sl->getElementOffset(i) == oint) {
             if (m.find(i) != m.end()) 
                return m[i];
             else return 0;
          }   
       }
    }    
    // check for embedded types
    for(unsigned i=0; i<est->getNumElements(); i++) {
       unsigned newbaseaddress = baseaddress + sl->getElementOffset(i);
       unsigned s = getSizeofSpecObject(mo, est->getElementType(i), t, address, 
                                   offset, newbaseaddress);
       if (s > 0)
          return s; 
    }
    return 0;
}


unsigned getSizeofSpecArray(const MemoryObject *mo, Type *et, Type *t, ref<Expr> address, 
                                   unsigned offset) {

    StructType *est = dyn_cast<StructType>(et);
    if (!est) return 0;
    Type *pt = t->getPointerTo();

    DataLayout *targetData = kmoduleExt->targetData;
    const StructLayout *sl = targetData->getStructLayout(est);
    assert(dyn_cast<klee::ConstantExpr>(address) && "expected constant value for address!\n");
    unsigned av = dyn_cast<klee::ConstantExpr>(address)->getZExtValue();
    unsigned baseaddress = getTypeBaseInArray(mo, et, av);

    return getSizeofSpecObject(mo, et, t, address, offset, baseaddress);
   
}

void applySizeOfConstraint(ExecutionState &state, TimingSolver *solver, 
      const MemoryObject *mo, Type *t, unsigned count, ref<Expr> address, Type *et, 
      const MemoryObject *emo, const ObjectState *eobj, unsigned eoffset) {
  if (address.isNull()) return;
  klee::ConstantExpr *CE = dyn_cast<klee::ConstantExpr>(address);
  assert(CE && "Concrete address is needed for lazy init!\n");
  DataLayout *targetData = kmoduleExt->targetData;
  if (et) {
     bool found = false;
     unsigned baseoffset = getTypeBaseInArray(emo, et, CE->getZExtValue());
     assert(dyn_cast<klee::ConstantExpr>(emo->getBaseExpr()) && 
                   "Expected base expression of memobject to be  aconstant!\n");
     unsigned emobase = dyn_cast<klee::ConstantExpr>(emo->getBaseExpr())->getZExtValue();
     assert(baseoffset != -1 && "Could not find the embedded type inside the memory object!\n");
     StructType *est = dyn_cast<StructType>(et);        
     if (est) {
        const StructLayout *esl = targetData->getStructLayout(est);
        std::string etname = getTypeName(et);
        std::string setname = simplifyName(etname);
        llvm::errs() << "Simplified enclosing type name " << setname << "\n";
        if (fieldConstraintMap.find(setname) != fieldConstraintMap.end()) {
           std::vector<BoundAST> bv = fieldConstraintMap[setname];
           for(unsigned bi = 0; bi<bv.size(); bi++) {
              bool compound = false;
              for(auto bm : bv[bi].bindings) {
                 if (bm.second.comptype != "none") { 
                    compound = true; 
                    break;
                 }
              }
              if (compound) {
                 llvm::errs() << "processing compound entity\n";
                 unsigned normalizedoffset = eoffset - (baseoffset - emobase);
                 llvm::errs() << "\nbase addr of the embedded type " << baseoffset 
                              << "\nbase addr of the embedding type " << emobase 
                              << "\noffset of the dynamic array " << eoffset 
                              << "\naddress of the dynamic array " << address << "\n";
        
                 llvm::errs() << "handling bound constraint:\n";
                 bv[bi].ast->print(); 
 
                    ref<Expr> cexp = generateExp(bv[bi], emo, eobj, (baseoffset - emobase), est, 
                                            esl, count, normalizedoffset, mo->size);
                    if (!cexp.isNull()) {
                       // Check if consistent with the path constraint
                       found = true;
                       bool result;
                       bool success = solver->mayBeTrue(state, cexp, result);
                       assert(success && "Solver failure during consistency checking!");
                       llvm::errs() << "constraint spec:\n";
                       bv[bi].ast->print();
                       llvm::errs() << "generated exp " << cexp << "\n";
                       if (result) {
                          ((Executor*)theInterpreter)->addConstraint(state, cexp);
                       }
                       else {
                          llvm::errs() << "not consistent with the path constraint!\n"; 
                          state.terminated = true;
                       }
                    }
                 //}
              }
           }
        }

        if (!found) {
           // check for embedded types
           for(unsigned i=0; i<est->getNumElements(); ++i) {
              Type *esti = est->getElementType(i);
              StructType *essti = dyn_cast<StructType>(esti);
              if (essti) {
                 unsigned eo = esl->getElementOffset(i);
                 applySizeOfConstraint(state, solver, mo, t, count, address, essti, 
                                    emo, eobj, eoffset);
              }
           }
        }
     }
  }
}


void applyCommandlineSpecInitializations(ExecutionState &state, TimingSolver *solver, 
   const MemoryObject *mo, ObjectState *obj, Type *t, unsigned baseOffset) {

   std::string tname = getTypeName(t);
   StructType *st = dyn_cast<StructType>(t);        
   if (!st) return; 
   DataLayout *targetData = kmoduleExt->targetData;
   const StructLayout *sl = targetData->getStructLayout(st);

   if (lazyInitInitializersWValues.find(tname) != lazyInitInitializersWValues.end()) {
       //llvm::errs() << "initializer found!\n"; 
        std::map<unsigned int, int> offsets = lazyInitInitializersWValues[tname];
        for(auto offset : offsets) {
           ref<Expr> ve = klee::ConstantExpr::alloc(offset.second, Expr::Int32); 
           llvm::errs() << "Initializing object of lazy init type " << tname 
           << " at offset " << offset.first << " to value " << ve << 
           " at base address " << mo->getBaseExpr() << "\n";
           obj->write(baseOffset + offset.first, ve); 
        }
   }  
   if (lazyInitInitializersWValuesUsingFields.find(tname) != 
                lazyInitInitializersWValuesUsingFields.end()) {
       //llvm::errs() << "initializer found!\n"; 
        std::map<unsigned int, int> fields = lazyInitInitializersWValuesUsingFields[tname];
        for(auto field : fields) {
           unsigned offset = sl->getElementOffset(field.first);
           Type *et = st->getStructElementType(field.first);
           unsigned width = et->getPrimitiveSizeInBits();
           llvm::errs() << "Initializing object of lazy init type " << tname 
           << "at field " << field.first << " of type " << getTypeName(et) 
           << " (at offset " << offset << " of width " << width << ") to value " ;
           if (et->isPointerTy()) {
              if (field.second != 0)
                 assert(0 && "Pointer fields cannot be initialized to anything other than 0\n");
              obj->write(baseOffset + offset, Expr::createPointer(0));
              llvm::errs() << "NULL " ; 
           }
           else {    
              ref<Expr> ve = klee::ConstantExpr::alloc(field.second, width);
              obj->write(baseOffset + offset, ve); 
              llvm::errs() << ve ; 
           } 
           llvm::errs() << " at base address " << mo->getBaseExpr() << " width " << width << "\n";
        }
   }     
   if (lazyInitInitializers.find(tname) != lazyInitInitializers.end()) {
      //llvm::errs() << "initializer found!\n"; 
      std::vector<unsigned int> offsets = lazyInitInitializers[tname];
      for(auto offset : offsets) {
         obj->write(baseOffset + offset, Expr::createPointer(0));
      }
   }
   // initialize function pointers, if any specified
   if (lazyFuncPtrInitializers.find(tname) != lazyFuncPtrInitializers.end()) {
      std::map<unsigned int, std::string> fmap = lazyFuncPtrInitializers[tname];
      for(auto e : fmap) {
         // lookup the function 
         Function *f = moduleHandle->getFunction(e.second);
         if (!f) {
            llvm::errs() << "Unable to find function " << e.second << 
              " in the module to init func pointer!!!\n";
              exit(1);
         }
         // assign the function address to the offset
         obj->write(baseOffset + e.first, Expr::createPointer((uint64_t)f));
         llvm::errs() << "assigning function " << f->getName() << "to offset " 
         << e.first << " of base address " << mo->getBaseExpr() << "\n";
      }
   }
   if (lazyFuncPtrInitializersUsingFields.find(tname) != 
                    lazyFuncPtrInitializersUsingFields.end()) {
      std::map<unsigned int, std::string> fmap = lazyFuncPtrInitializersUsingFields[tname];
      for(auto e : fmap) {
         // lookup the function 
         Function *f = moduleHandle->getFunction(e.second);
         if (!f) {
            llvm::errs() << "Unable to find function " << e.second << 
              " in the module to init func pointer!!!\n";
              exit(1);
         }
         unsigned offset = sl->getElementOffset(e.first);
         // assign the function address to the offset
         obj->write(baseOffset + offset, Expr::createPointer((uint64_t)f));
         llvm::errs() << "assigning function " << f->getName() << " to field " << e.first 
                      << " (to offset) " << offset << " of base address " << mo->getBaseExpr() 
                      << "\n";
      }
   }

   // now handle the embedded types
   for(unsigned i=0; i<st->getNumElements(); ++i) {
      Type *et = st->getElementType(i);
      StructType *est = dyn_cast<StructType>(et);
      if (est) {
         unsigned eo = sl->getElementOffset(i);
         applyCommandlineSpecInitializations(state, solver, mo, obj, et, baseOffset + eo);
      }
   }
}

void applyCommandlineSpecInitializationsToArray(ExecutionState &state, TimingSolver *solver, 
   const MemoryObject *mo, ObjectState *obj, llvm::Type *t, unsigned count) {
   DataLayout *targetData = kmoduleExt->targetData;
   for(unsigned i = 0; i<count; i++) {
       unsigned newbaseOffset = i * targetData->getTypeAllocSize(mo->baseType);
       applyCommandlineSpecInitializations(state, solver, mo, obj, t, newbaseOffset);
   }  
}


bool isEmbeddedType(Type *t) {
  if (!dyn_cast<StructType>(t))
      return false; 
  return embeddedTypes.find(t) != embeddedTypes.end();
}

std::string getLongestStackTraces(ExecutionState &state, unsigned num) {
    std::string result = "";
    long sid = (long)&state;
    std::map<int, std::set<std::string > > smap;
    if (stackTraceMap.find(sid) != stackTraceMap.end()) 
       smap = stackTraceMap[sid];
    if (smap.size() > 0) {
       for(auto iter = smap.rbegin(); iter != smap.rend() && num > 0; iter++) {
          if (smap[iter->first].size() <= num) {
             for(auto el : smap[iter->first])
                result += el + "\n"; 
             num -= smap[iter->first].size();
          } 
          else {
             for(auto el : smap[iter->first]) {
                result += el + "\n"; 
                num--;
                if (num == 0)
                   break;
             }       
          }
       }
       return result;
    }    
    else return "\nNo stack traces\n";
}

std::string getStackTrace(ExecutionState &state) {
    std::string MsgString;
    llvm::raw_string_ostream msg(MsgString);
    state.dumpStack(msg);
    return msg.str();
}

std::string getSourceWithContext(ExecutionState &state, KInstruction *ki) {
   std::string swctx = getStackTrace(state);
   llvm::errs() << "stack trace=" << swctx << "\n";
   swctx = swctx + ki->getSourceLocation();
   return swctx;
}

void Executor::recordStackTrace(ExecutionState &state) {
    long sid = (long)&state;
    std::map<int, std::set<std::string > > map;
    if (stackTraceMap.find(sid) != stackTraceMap.end()) 
       map = stackTraceMap[sid];
     
    std::string MsgString;
    llvm::raw_string_ostream msg(MsgString);
    msg << "Stack: \n";
    state.dumpStack(msg);
    std::string strace = msg.str();
    int len = strace.size();
    std::set<std::string> stset;
    if (map.find(len) != map.end())
       stset = map[len];
    stset.insert(strace);
    map[len] = stset;
    stackTraceMap[sid] = map;
}

bool isLazySingle(Type *t, std::string pointertype="**") {
  std::string type_str;
  llvm::raw_string_ostream rso(type_str);
  t->print(rso); 
  std::istringstream iss(rso.str());
  std::string typestr;
  getline(iss, typestr, ' ');
  for(auto el : lazyInitSingles)
    if (typestr.find(el) != std::string::npos) {
       return true;
    }
  return false;
}

bool isLazySingle(std::string typestr, std::string pointertype="**") {
  for(auto el : lazyInitSingles) 
    if (typestr.find(el) != std::string::npos) {
       return true;
    }
  return false;
}


bool isLazyInit(Type *t, bool &single, int &count) {
  int origvalue = count;
  std::string pointertype = "**"; 
  count = 0;
  std::string type_str;
  llvm::raw_string_ostream rso(type_str);
  t->print(rso); 
  std::istringstream iss(rso.str());
  std::string typestr;
  getline(iss, typestr, ' ');
  for(unsigned i=0; i<lazyInits.size(); i++) 
     if (typestr.find(lazyInits[i]+pointertype) != std::string::npos) {
        count = lazyInitNumInstances[lazyInits[i]];
        single = isLazySingle(typestr);
        return true;
     }
  // Support lazy init for double pointer to a primitive type
  if (t->isPointerTy()) {
     Type *el = t->getPointerElementType();
     if (el->isPointerTy()) {
        el = el->getPointerElementType();             
        StructType *st = dyn_cast<StructType>(el);
        if (st) {
           count = STRUCT_LAZY_INIT_INS;
           single = false;
           return true;
        }
        else { // if (el->getPrimitiveSizeInBits()) {
           count = primArraySize; 
           single = false;
           return true;
        }
     }
  }
  count = origvalue;
  single = false;
  return false;
}

bool isAllocTypeLazyInit(Type *t, bool &single, int &count) {
  //std::string pointertype = "*"; 
  int origvalue = count;
  count = 0;
  std::string type_str;
  llvm::raw_string_ostream rso(type_str);
  t->print(rso);   
  std::istringstream iss(rso.str());
  std::string typestr;
  getline(iss, typestr, ' ');
  for(unsigned i=0; i<lazyInits.size(); i++) {
     if (typestr.find(lazyInits[i]) != std::string::npos) {
        count = lazyInitNumInstances[lazyInits[i]];
        single = isLazySingle(typestr); 
        return true;
     }
  }
  if (t->getPrimitiveSizeInBits()) {
      count = primArraySize; 
      single = false;
      return true;
  }
  else {
     count = origvalue;
     single = false;
  }
  return false;
}

void collectEmbeddedPointerTypes(Type *t, std::vector<std::string> &lazyTypes, std::set<std::string> &visited) {

     bool pointerType = false;
     if (t->isPointerTy()) {
        pointerType = true;
        while (t->isPointerTy()) {
           t = t->getPointerElementType();
        }
     }
     std::string type_str;
     llvm::raw_string_ostream rso(type_str);
     t->print(rso); 
     StructType *st = dyn_cast<StructType>(t);
     if (st) {
        std::istringstream ist(rso.str());
        std::string temp;
        getline(ist, temp, '=');
        std::string ltypename = ltrim(rtrim(temp)); 
        if (visited.find(ltypename) == visited.end()) {
           visited.insert(ltypename);
           if (pointerType) {
              lazyTypes.push_back(ltypename);
              lazyInitNumInstances[ltypename] = numLazyInst;
           }
           for(unsigned i=0; i < st->getNumElements(); i++) {
              collectEmbeddedPointerTypes(st->getElementType(i), lazyTypes, visited);
           }
        }
     }
     else if (t->getPrimitiveSizeInBits()) {
        if (pointerType) {
           lazyTypes.push_back(rso.str());
           lazyInitNumInstances[rso.str()] = primArraySize;
        }
     }

}

/* end SYSREL extension */


/* SYSREL extension */
//namespace {
/* SYSREL extension */

  cl::opt<bool>
  ReportMetadataChecksOnExit("check-metadata", cl::init(false), cl::desc("Check metadata queries before exit (default=off)\n"));

  cl::opt<bool>
  DumpStatesOnHalt("dump-states-on-halt",
                   cl::init(true),
		   cl::desc("Dump test cases for all active states on exit (default=on)"));
  
  cl::opt<bool>
  AllowExternalSymCalls("allow-external-sym-calls",
                        cl::init(false),
			cl::desc("Allow calls with symbolic arguments to external functions.  This concretizes the symbolic arguments.  (default=off)"));

  /// The different query logging solvers that can switched on/off
  enum PrintDebugInstructionsType {
    STDERR_ALL, ///
    STDERR_SRC,
    STDERR_COMPACT,
    FILE_ALL,    ///
    FILE_SRC,    ///
    FILE_COMPACT ///
  };

  llvm::cl::bits<PrintDebugInstructionsType> DebugPrintInstructions(
      "debug-print-instructions",
      llvm::cl::desc("Log instructions during execution."),
      llvm::cl::values(
          clEnumValN(STDERR_ALL, "all:stderr", "Log all instructions to stderr "
                                               "in format [src, inst_id, "
                                               "llvm_inst]"),
          clEnumValN(STDERR_SRC, "src:stderr",
                     "Log all instructions to stderr in format [src, inst_id]"),
          clEnumValN(STDERR_COMPACT, "compact:stderr",
                     "Log all instructions to stderr in format [inst_id]"),
          clEnumValN(FILE_ALL, "all:file", "Log all instructions to file "
                                           "instructions.txt in format [src, "
                                           "inst_id, llvm_inst]"),
          clEnumValN(FILE_SRC, "src:file", "Log all instructions to file "
                                           "instructions.txt in format [src, "
                                           "inst_id]"),
          clEnumValN(FILE_COMPACT, "compact:file",
                     "Log all instructions to file instructions.txt in format "
                     "[inst_id]")
          KLEE_LLVM_CL_VAL_END),
      llvm::cl::CommaSeparated);
#ifdef HAVE_ZLIB_H
  cl::opt<bool> DebugCompressInstructions(
      "debug-compress-instructions", cl::init(false),
      cl::desc("Compress the logged instructions in gzip format."));
#endif

  cl::opt<bool>
  DebugCheckForImpliedValues("debug-check-for-implied-values");


  cl::opt<bool>
  SimplifySymIndices("simplify-sym-indices",
                     cl::init(false),
		     cl::desc("Simplify symbolic accesses using equalities from other constraints (default=off)"));

  cl::opt<bool>
  EqualitySubstitution("equality-substitution",
		       cl::init(true),
		       cl::desc("Simplify equality expressions before querying the solver (default=on)."));

  cl::opt<unsigned>
  MaxSymArraySize("max-sym-array-size",
                  cl::init(0));

  cl::opt<bool>
  SuppressExternalWarnings("suppress-external-warnings",
			   cl::init(false),
			   cl::desc("Supress warnings about calling external functions."));

  cl::opt<bool>
  AllExternalWarnings("all-external-warnings",
		      cl::init(false),
		      cl::desc("Issue an warning everytime an external call is made," 
			       "as opposed to once per function (default=off)"));

  cl::opt<bool>
  OnlyOutputStatesCoveringNew("only-output-states-covering-new",
                              cl::init(false),
			      cl::desc("Only output test cases covering new code (default=off)."));

  cl::opt<bool>
  EmitAllErrors("emit-all-errors",
                cl::init(false),
                cl::desc("Generate tests cases for all errors "
                         "(default=off, i.e. one per (error,instruction) pair)"));
  
  cl::opt<bool>
  NoExternals("no-externals", 
           cl::desc("Do not allow external function calls (default=off)"));

  cl::opt<bool>
  AlwaysOutputSeeds("always-output-seeds",
		    cl::init(true));

  cl::opt<bool>
  OnlyReplaySeeds("only-replay-seeds",
		  cl::init(false),
                  cl::desc("Discard states that do not have a seed (default=off)."));
 
  cl::opt<bool>
  OnlySeed("only-seed",
	   cl::init(false),
           cl::desc("Stop execution after seeding is done without doing regular search (default=off)."));
 
  cl::opt<bool>
  AllowSeedExtension("allow-seed-extension",
		     cl::init(false),
                     cl::desc("Allow extra (unbound) values to become symbolic during seeding (default=false)."));
 
  cl::opt<bool>
  ZeroSeedExtension("zero-seed-extension",
		    cl::init(false),
		    cl::desc("(default=off)"));
 
  cl::opt<bool>
  AllowSeedTruncation("allow-seed-truncation",
		      cl::init(false),
                      cl::desc("Allow smaller buffers than in seeds (default=off)."));
 
  cl::opt<bool>
  NamedSeedMatching("named-seed-matching",
		    cl::init(false),
                    cl::desc("Use names to match symbolic objects to inputs (default=off)."));

  cl::opt<double>
  MaxStaticForkPct("max-static-fork-pct", 
		   cl::init(1.),
		   cl::desc("(default=1.0)"));

  cl::opt<double>
  MaxStaticSolvePct("max-static-solve-pct",
		    cl::init(1.),
		    cl::desc("(default=1.0)"));

  cl::opt<double>
  MaxStaticCPForkPct("max-static-cpfork-pct", 
		     cl::init(1.),
		     cl::desc("(default=1.0)"));

  cl::opt<double>
  MaxStaticCPSolvePct("max-static-cpsolve-pct",
		      cl::init(1.),
		      cl::desc("(default=1.0)"));

  cl::opt<double>
  MaxInstructionTime("max-instruction-time",
                     cl::desc("Only allow a single instruction to take this much time (default=0s (off)). Enables --use-forked-solver"),
                     cl::init(0));
  
  cl::opt<double>
  SeedTime("seed-time",
           cl::desc("Amount of time to dedicate to seeds, before normal search (default=0 (off))"),
           cl::init(0));
  
  cl::list<Executor::TerminateReason>
  ExitOnErrorType("exit-on-error-type",
		  cl::desc("Stop execution after reaching a specified condition.  (default=off)"),
		  cl::values(
		    clEnumValN(Executor::Abort, "Abort", "The program crashed"),
		    clEnumValN(Executor::Assert, "Assert", "An assertion was hit"),
		    clEnumValN(Executor::BadVectorAccess, "BadVectorAccess", "Vector accessed out of bounds"),
		    clEnumValN(Executor::Exec, "Exec", "Trying to execute an unexpected instruction"),
		    clEnumValN(Executor::External, "External", "External objects referenced"),
		    clEnumValN(Executor::Free, "Free", "Freeing invalid memory"),
		    clEnumValN(Executor::Model, "Model", "Memory model limit hit"),
		    clEnumValN(Executor::Overflow, "Overflow", "An overflow occurred"),
		    clEnumValN(Executor::Ptr, "Ptr", "Pointer error"),
		    clEnumValN(Executor::ReadOnly, "ReadOnly", "Write to read-only memory"),
		    clEnumValN(Executor::ReportError, "ReportError", "klee_report_error called"),
		    clEnumValN(Executor::User, "User", "Wrong klee_* functions invocation"),
		    clEnumValN(Executor::Unhandled, "Unhandled", "Unhandled instruction hit")
		    KLEE_LLVM_CL_VAL_END),
		  cl::ZeroOrMore);

  cl::opt<unsigned long long>
  StopAfterNInstructions("stop-after-n-instructions",
                         cl::desc("Stop execution after specified number of instructions (default=0 (off))"),
                         cl::init(0));
  
  cl::opt<unsigned>
  MaxForks("max-forks",
           cl::desc("Only fork this many times (default=-1 (off))"),
           cl::init(~0u));
  
  cl::opt<unsigned>
  MaxDepth("max-depth",
           cl::desc("Only allow this many symbolic branches (default=0 (off))"),
           cl::init(0));
  
  cl::opt<unsigned>
  MaxMemory("max-memory",
            cl::desc("Refuse to fork when above this amount of memory (in MB, default=2000)"),
            cl::init(2000));

  cl::opt<bool>
  MaxMemoryInhibit("max-memory-inhibit",
            cl::desc("Inhibit forking at memory cap (vs. random terminate) (default=on)"),
            cl::init(true));
/* SYSREL extension */
//}
/* SYSREL extension */

namespace klee {
  RNG theRNG;
}

const char *Executor::TerminateReasonNames[] = {
  [ Abort ] = "abort",
  [ Assert ] = "assert",
  [ BadVectorAccess ] = "bad_vector_access",
  [ Exec ] = "exec",
  [ External ] = "external",
  [ Free ] = "free",
  [ Model ] = "model",
  [ Overflow ] = "overflow",
  [ Ptr ] = "ptr",
  [ ReadOnly ] = "readonly",
  [ ReportError ] = "reporterror",
  [ User ] = "user",
  [ Unhandled ] = "xxx",
  [ NegativeRefcount ] = "negrefcount",
};

/* SYSREL extension */
bool isAsyncInitiate(std::string name) {
  return name.find(ASYNC_STR) == 0; 
}

bool isEnableEntry(std::string name) {
  return name.find(ENABLE_STR) == 0;
}

bool isAsync(std::string name) {
  for(unsigned int i=0; i < asyncFunc.size(); i++)
    if (asyncFunc[i] == name)
      return true;
  return false;  
}

bool isEnabled(std::string name) {
  for(unsigned int i=0; i < enabledFunc.size(); i++)
    if (enabledFunc[i] == name)
      return true;
  return false;  
}
/* SYSREL extension */


Executor::Executor(LLVMContext &ctx, const InterpreterOptions &opts,
    InterpreterHandler *ih)
    : Interpreter(opts), kmodule(0), interpreterHandler(ih), searcher(0),
      externalDispatcher(new ExternalDispatcher(ctx)), statsTracker(0),
      pathWriter(0), symPathWriter(0), specialFunctionHandler(0),
      processTree(0), replayKTest(0), replayPath(0), usingSeeds(0),
      atMemoryLimit(false), inhibitForking(false), haltExecution(false),
      ivcEnabled(false),
      coreSolverTimeout(MaxCoreSolverTime != 0 && MaxInstructionTime != 0
                            ? std::min(MaxCoreSolverTime, MaxInstructionTime)
                            : std::max(MaxCoreSolverTime, MaxInstructionTime)),
      debugInstFile(0), debugLogBuffer(debugBufferString) {

  if (coreSolverTimeout) UseForkedCoreSolver = true;
  Solver *coreSolver = klee::createCoreSolver(CoreSolverToUse);
  if (!coreSolver) {
    klee_error("Failed to create core solver\n");
  }

  Solver *solver = constructSolverChain(
      coreSolver,
      interpreterHandler->getOutputFilename(ALL_QUERIES_SMT2_FILE_NAME),
      interpreterHandler->getOutputFilename(SOLVER_QUERIES_SMT2_FILE_NAME),
      interpreterHandler->getOutputFilename(ALL_QUERIES_KQUERY_FILE_NAME),
      interpreterHandler->getOutputFilename(SOLVER_QUERIES_KQUERY_FILE_NAME));

  this->solver = new TimingSolver(solver, EqualitySubstitution);
  memory = new MemoryManager(&arrayCache);

  initializeSearchOptions();

  if (OnlyOutputStatesCoveringNew && !StatsTracker::useIStats())
    klee_error("To use --only-output-states-covering-new, you need to enable --output-istats.");

  if (DebugPrintInstructions.isSet(FILE_ALL) ||
      DebugPrintInstructions.isSet(FILE_COMPACT) ||
      DebugPrintInstructions.isSet(FILE_SRC)) {
    std::string debug_file_name =
        interpreterHandler->getOutputFilename("instructions.txt");
    std::string ErrorInfo;
#ifdef HAVE_ZLIB_H
    if (!DebugCompressInstructions) {
#endif

#if LLVM_VERSION_CODE >= LLVM_VERSION(3, 6)
    std::error_code ec;
    debugInstFile = new llvm::raw_fd_ostream(debug_file_name.c_str(), ec,
                                             llvm::sys::fs::OpenFlags::F_Text);
    if (ec)
	    ErrorInfo = ec.message();
#elif LLVM_VERSION_CODE >= LLVM_VERSION(3, 5)
    debugInstFile = new llvm::raw_fd_ostream(debug_file_name.c_str(), ErrorInfo,
                                             llvm::sys::fs::OpenFlags::F_Text);
#else
    debugInstFile =
        new llvm::raw_fd_ostream(debug_file_name.c_str(), ErrorInfo);
#endif
#ifdef HAVE_ZLIB_H
    } else {
      debugInstFile = new compressed_fd_ostream(
          (debug_file_name + ".gz").c_str(), ErrorInfo);
    }
#endif
    if (ErrorInfo != "") {
      klee_error("Could not open file %s : %s", debug_file_name.c_str(),
                 ErrorInfo.c_str());
    }
  }
}

const Function *Executor::getFunctionFromAddress(ref<Expr> addr) {
   if (ConstantExpr *CE = dyn_cast<ConstantExpr>(addr)) {
      if (globalAddressesRev.find(CE) != globalAddressesRev.end()) {
         const Function *f = dyn_cast<Function>(globalAddressesRev.find(CE)->second);
         return f;
      }
   }
   return NULL;
}

const Module *Executor::setModule(llvm::Module *module, 
                                  const ModuleOptions &opts) {
  assert(!kmodule && module && "can only register one module"); // XXX gross
  
  kmodule = new KModule(module);
  /* SYSREL EXTENSION */
  kmoduleExt = kmodule;
  /* SYSREL EXTENSION */
  

  // Initialize the context.
  DataLayout *TD = kmodule->targetData;
  Context::initialize(TD->isLittleEndian(),
                      (Expr::Width) TD->getPointerSizeInBits());

  specialFunctionHandler = new SpecialFunctionHandler(*this);

  specialFunctionHandler->prepare();
  kmodule->prepare(opts, interpreterHandler);
  specialFunctionHandler->bind();

  if (StatsTracker::useStatistics() || userSearcherRequiresMD2U()) {
    statsTracker = 
      new StatsTracker(*this,
                       interpreterHandler->getOutputFilename("assembly.ll"),
                       userSearcherRequiresMD2U());
  }
  
  return module;
}

Executor::~Executor() {
  delete memory;
  delete externalDispatcher;
  delete processTree;
  delete specialFunctionHandler;
  delete statsTracker;
  delete solver;
  delete kmodule;
  while(!timers.empty()) {
    delete timers.back();
    timers.pop_back();
  }
  delete debugInstFile;
}

/***/

void Executor::initializeGlobalObject(ExecutionState &state, ObjectState *os,
                                      const Constant *c, 
                                      unsigned offset) {
  DataLayout *targetData = kmodule->targetData;
  if (const ConstantVector *cp = dyn_cast<ConstantVector>(c)) {
    unsigned elementSize =
      targetData->getTypeStoreSize(cp->getType()->getElementType());
    for (unsigned i=0, e=cp->getNumOperands(); i != e; ++i)
      initializeGlobalObject(state, os, cp->getOperand(i), 
			     offset + i*elementSize);
  } else if (isa<ConstantAggregateZero>(c)) {
    unsigned i, size = targetData->getTypeStoreSize(c->getType());
    for (i=0; i<size; i++)
      os->write8(offset+i, (uint8_t) 0);
  } else if (const ConstantArray *ca = dyn_cast<ConstantArray>(c)) {
    unsigned elementSize =
      targetData->getTypeStoreSize(ca->getType()->getElementType());
    for (unsigned i=0, e=ca->getNumOperands(); i != e; ++i)
      initializeGlobalObject(state, os, ca->getOperand(i), 
			     offset + i*elementSize);
  } else if (const ConstantStruct *cs = dyn_cast<ConstantStruct>(c)) {
    const StructLayout *sl =
      targetData->getStructLayout(cast<StructType>(cs->getType()));
    for (unsigned i=0, e=cs->getNumOperands(); i != e; ++i)
      initializeGlobalObject(state, os, cs->getOperand(i), 
			     offset + sl->getElementOffset(i));
  } else if (const ConstantDataSequential *cds =
               dyn_cast<ConstantDataSequential>(c)) {
    unsigned elementSize =
      targetData->getTypeStoreSize(cds->getElementType());
    for (unsigned i=0, e=cds->getNumElements(); i != e; ++i)
      initializeGlobalObject(state, os, cds->getElementAsConstant(i),
                             offset + i*elementSize);
  } else if (!isa<UndefValue>(c)) {
    unsigned StoreBits = targetData->getTypeStoreSizeInBits(c->getType());
    ref<ConstantExpr> C = evalConstant(c);

    // Extend the constant if necessary;
    assert(StoreBits >= C->getWidth() && "Invalid store size!");
    if (StoreBits > C->getWidth())
      C = C->ZExt(StoreBits);

    os->write(offset, C);
  }
}

MemoryObject * Executor::addExternalObject(ExecutionState &state, 
                                           void *addr, unsigned size, 
                                           bool isReadOnly) {
  auto mo = memory->allocateFixed(reinterpret_cast<std::uint64_t>(addr),
                                  size, nullptr);
  ObjectState *os = bindObjectInState(state, mo, false);
  for(unsigned i = 0; i < size; i++)
    os->write8(i, ((uint8_t*)addr)[i]);
  if(isReadOnly)
    os->setReadOnly(true);  
  return mo;
}


extern void *__dso_handle __attribute__ ((__weak__));

void Executor::initializeGlobals(ExecutionState &state) {
  Module *m = kmodule->module;

  if (m->getModuleInlineAsm() != "")
    klee_warning("executable has module level assembly (ignoring)");
  // represent function globals using the address of the actual llvm function
  // object. given that we use malloc to allocate memory in states this also
  // ensures that we won't conflict. we don't need to allocate a memory object
  // since reading/writing via a function pointer is unsupported anyway.
  for (Module::iterator i = m->begin(), ie = m->end(); i != ie; ++i) {
    Function *f = &*i;
    ref<ConstantExpr> addr(0);

    // If the symbol has external weak linkage then it is implicitly
    // not defined in this module; if it isn't resolvable then it
    // should be null.
    if (f->hasExternalWeakLinkage() && 
        !externalDispatcher->resolveSymbol(f->getName())) {
      addr = Expr::createPointer(0);
    } else {
      addr = Expr::createPointer(reinterpret_cast<std::uint64_t>(f));
      legalFunctions.insert(reinterpret_cast<std::uint64_t>(f));
    }
    
    globalAddresses.insert(std::make_pair(f, addr));

    /* SYSREL extension */ 
    globalAddressesRev.insert(std::make_pair(addr,f));
    /* SYSREL extension */ 
  }

#ifndef WINDOWS
  int *errno_addr = getErrnoLocation(state);
  MemoryObject *errnoObj =
      addExternalObject(state, (void *)errno_addr, sizeof *errno_addr, false);
  // Copy values from and to program space explicitly
  errnoObj->isUserSpecified = true;
#endif

  // Disabled, we don't want to promote use of live externals.
#ifdef HAVE_CTYPE_EXTERNALS
#ifndef WINDOWS
#ifndef DARWIN
  /* from /usr/include/ctype.h:
       These point into arrays of 384, so they can be indexed by any `unsigned
       char' value [0,255]; by EOF (-1); or by any `signed char' value
       [-128,-1).  ISO C requires that the ctype functions work for `unsigned */
  const uint16_t **addr = __ctype_b_loc();
  addExternalObject(state, const_cast<uint16_t*>(*addr-128),
                    384 * sizeof **addr, true);
  addExternalObject(state, addr, sizeof(*addr), true);
    
  const int32_t **lower_addr = __ctype_tolower_loc();
  addExternalObject(state, const_cast<int32_t*>(*lower_addr-128),
                    384 * sizeof **lower_addr, true);
  addExternalObject(state, lower_addr, sizeof(*lower_addr), true);
  
  const int32_t **upper_addr = __ctype_toupper_loc();
  addExternalObject(state, const_cast<int32_t*>(*upper_addr-128),
                    384 * sizeof **upper_addr, true);
  addExternalObject(state, upper_addr, sizeof(*upper_addr), true);
#endif
#endif
#endif

  // allocate and initialize globals, done in two passes since we may
  // need address of a global in order to initialize some other one.

  // allocate memory objects for all globals
  for (Module::const_global_iterator i = m->global_begin(),
         e = m->global_end();
       i != e; ++i) {
    const GlobalVariable *v = &*i;
    size_t globalObjectAlignment = getAllocationAlignment(v);
    if (i->isDeclaration()) {
      // FIXME: We have no general way of handling unknown external
      // symbols. If we really cared about making external stuff work
      // better we could support user definition, or use the EXE style
      // hack where we check the object file information.

      Type *ty = i->getType()->getElementType();
      uint64_t size = 0;
      if (ty->isSized()) {
	size = kmodule->targetData->getTypeStoreSize(ty);
      } else {
        klee_warning("Type for %.*s is not sized", (int)i->getName().size(),
			i->getName().data());
      }

      // XXX - DWD - hardcode some things until we decide how to fix.
#ifndef WINDOWS
      if (i->getName() == "_ZTVN10__cxxabiv117__class_type_infoE") {
        size = 0x2C;
      } else if (i->getName() == "_ZTVN10__cxxabiv120__si_class_type_infoE") {
        size = 0x2C;
      } else if (i->getName() == "_ZTVN10__cxxabiv121__vmi_class_type_infoE") {
        size = 0x2C;
      }
#endif

      if (size == 0) {
        klee_warning("Unable to find size for global variable: %.*s (use will result in out of bounds access)",
			(int)i->getName().size(), i->getName().data());
      }
      LLVMContext &ctx = moduleHandle->getContext();
      MemoryObject *mo = memory->allocate(size, /*isLocal=*/false,
                                          /*isGlobal=*/true, /*allocSite=*/v,
                                          /*alignment=*/globalObjectAlignment,
                                          size, Type::getInt8Ty(ctx));
      recordMemObj(state, mo);
      ObjectState *os = bindObjectInState(state, mo, false);
      globalObjects.insert(std::make_pair(v, mo));
      globalAddresses.insert(std::make_pair(v, mo->getBaseExpr()));

      /* SYSREL extension */ 
      globalAddressesRev.insert(std::make_pair(mo->getBaseExpr(), v));
      /* SYSREL extension */ 

      // Program already running = object already initialized.  Read
      // concrete value and write it to our copy.
      if (size) {
        void *addr;
        if (i->getName() == "__dso_handle") {
          addr = &__dso_handle; // wtf ?
        } else {
          addr = externalDispatcher->resolveSymbol(i->getName());
        }
        if (!addr) {
          /* SYSREL EXTENSION */
          if (!lazyInit)
             klee_error("unable to load symbol(%s) while initializing globals.", 
                     i->getName().data());
          else {
             ObjectState *los = executeMakeSymbolic(state, mo, i->getName(), true, ty);
             // first simple equalities get applied..
             applyDataConstraintToArray(state, solver, mo, los, 0, 1, true);
             // then other constraints 
             applyDataConstraintToArray(state, solver, mo, los, 0, 1, false);
          }
        }
        else {
           /* SYSREL EXTENSION */
        for (unsigned offset=0; offset<mo->size; offset++)
          os->write8(offset, ((unsigned char*)addr)[offset]);
        }
      }
    } else {
      Type *ty = i->getType()->getElementType();
      uint64_t size = kmodule->targetData->getTypeStoreSize(ty);
      MemoryObject *mo = memory->allocate(size, /*isLocal=*/false,
                                          /*isGlobal=*/true, /*allocSite=*/v,
                                          /*alignment=*/globalObjectAlignment,
                                          1, ty);
      if (!mo)
        llvm::report_fatal_error("out of memory");
      recordMemObj(state, mo);
      ObjectState *os = bindObjectInState(state, mo, false);
      globalObjects.insert(std::make_pair(v, mo));
      globalAddresses.insert(std::make_pair(v, mo->getBaseExpr()));

      /* SYSREL extnesion */ 
      globalAddressesRev.insert(std::make_pair(mo->getBaseExpr(), v));
      /* SYSREL extnesion */ 


      if (!i->hasInitializer())
          os->initializeToRandom();
    }
  }
  
  // link aliases to their definitions (if bound)
  for (Module::alias_iterator i = m->alias_begin(), ie = m->alias_end(); 
       i != ie; ++i) {
    // Map the alias to its aliasee's address. This works because we have
    // addresses for everything, even undefined functions. 
    globalAddresses.insert(std::make_pair(&*i, evalConstant(i->getAliasee())));
    /* SYSREL extension */ 
    globalAddressesRev.insert(std::make_pair(evalConstant(i->getAliasee()), &*i));
    /* SYSREL extension */ 

  }

  // once all objects are allocated, do the actual initialization
  for (Module::const_global_iterator i = m->global_begin(),
         e = m->global_end();
       i != e; ++i) {
    if (i->hasInitializer()) {
      const GlobalVariable *v = &*i;
      MemoryObject *mo = globalObjects.find(v)->second;
      const ObjectState *os = state.addressSpace.findObject(mo);
      assert(os);
      ObjectState *wos = state.addressSpace.getWriteable(mo, os);
      
      initializeGlobalObject(state, wos, i->getInitializer(), 0);
      // if(i->isConstant()) os->setReadOnly(true);
    }
  }
}

void Executor::branch(ExecutionState &state, 
                      const std::vector< ref<Expr> > &conditions,
                      std::vector<ExecutionState*> &result) {
  TimerStatIncrementer timer(stats::forkTime);
  unsigned N = conditions.size();
  assert(N);

  if (MaxForks!=~0u && stats::forks >= MaxForks) {
    unsigned next = theRNG.getInt32() % N;
    for (unsigned i=0; i<N; ++i) {
      if (i == next) {
        result.push_back(&state);
      } else {
        result.push_back(NULL);
      }
    }
  } else {
    stats::forks += N-1;

    // XXX do proper balance or keep random?
    result.push_back(&state);
    for (unsigned i=1; i<N; ++i) {
      ExecutionState *es = result[theRNG.getInt32() % i];
      ExecutionState *ns = es->branch();
      addedStates.push_back(ns);
      result.push_back(ns);
      es->ptreeNode->data = 0;
      std::pair<PTree::Node*,PTree::Node*> res = 
        processTree->split(es->ptreeNode, ns, es);
      ns->ptreeNode = res.first;
      es->ptreeNode = res.second;
    }
  }

  // If necessary redistribute seeds to match conditions, killing
  // states if necessary due to OnlyReplaySeeds (inefficient but
  // simple).
  
  std::map< ExecutionState*, std::vector<SeedInfo> >::iterator it = 
    seedMap.find(&state);
  if (it != seedMap.end()) {
    std::vector<SeedInfo> seeds = it->second;
    seedMap.erase(it);

    // Assume each seed only satisfies one condition (necessarily true
    // when conditions are mutually exclusive and their conjunction is
    // a tautology).
    for (std::vector<SeedInfo>::iterator siit = seeds.begin(), 
           siie = seeds.end(); siit != siie; ++siit) {
      unsigned i;
      for (i=0; i<N; ++i) {
        ref<ConstantExpr> res;
        bool success = 
          solver->getValue(state, siit->assignment.evaluate(conditions[i]), 
                           res);
        assert(success && "FIXME: Unhandled solver failure");
        (void) success;
        if (res->isTrue())
          break;
      }
      
      // If we didn't find a satisfying condition randomly pick one
      // (the seed will be patched).
      if (i==N)
        i = theRNG.getInt32() % N;

      // Extra check in case we're replaying seeds with a max-fork
      if (result[i])
        seedMap[result[i]].push_back(*siit);
    }

    if (OnlyReplaySeeds) {
      for (unsigned i=0; i<N; ++i) {
        if (result[i] && !seedMap.count(result[i])) {
          terminateState(*result[i]);
          result[i] = NULL;
        }
      } 
    }
  }

  for (unsigned i=0; i<N; ++i)
    if (result[i])
      addConstraint(*result[i], conditions[i]);
}

Executor::StatePair 
Executor::fork(ExecutionState &current, ref<Expr> condition, bool isInternal) {


  Solver::Validity res;
  std::map< ExecutionState*, std::vector<SeedInfo> >::iterator it = 
    seedMap.find(&current);
  bool isSeeding = it != seedMap.end();

  if (!isSeeding && !isa<ConstantExpr>(condition) && 
      (MaxStaticForkPct!=1. || MaxStaticSolvePct != 1. ||
       MaxStaticCPForkPct!=1. || MaxStaticCPSolvePct != 1.) &&
      statsTracker->elapsed() > 60.) {
    StatisticManager &sm = *theStatisticManager;
    CallPathNode *cpn = current.stack.back().callPathNode;
    if ((MaxStaticForkPct<1. &&
         sm.getIndexedValue(stats::forks, sm.getIndex()) > 
         stats::forks*MaxStaticForkPct) ||
        (MaxStaticCPForkPct<1. &&
         cpn && (cpn->statistics.getValue(stats::forks) > 
                 stats::forks*MaxStaticCPForkPct)) ||
        (MaxStaticSolvePct<1 &&
         sm.getIndexedValue(stats::solverTime, sm.getIndex()) > 
         stats::solverTime*MaxStaticSolvePct) ||
        (MaxStaticCPForkPct<1. &&
         cpn && (cpn->statistics.getValue(stats::solverTime) > 
                 stats::solverTime*MaxStaticCPSolvePct))) {
      ref<ConstantExpr> value; 
      bool success = solver->getValue(current, condition, value);
      assert(success && "FIXME: Unhandled solver failure");
      (void) success;
      addConstraint(current, EqExpr::create(value, condition));
      current.lastConstraint = EqExpr::create(value, condition);
      condition = value;
    }
  }

  double timeout = coreSolverTimeout;
  if (isSeeding)
    timeout *= it->second.size();
  solver->setTimeout(timeout);
  bool success = solver->evaluate(current, condition, res);
  solver->setTimeout(0);
  if (!success) {
    current.pc = current.prevPC;
    terminateStateEarly(current, "Query timed out (fork).");
    return StatePair(0, 0);
  }

  if (!isSeeding) {
    if (replayPath && !isInternal) {
      assert(replayPosition<replayPath->size() &&
             "ran out of branches in replay path mode");
      bool branch = (*replayPath)[replayPosition++];
      
      if (res==Solver::True) {
        assert(branch && "hit invalid branch in replay path mode");
      } else if (res==Solver::False) {
        assert(!branch && "hit invalid branch in replay path mode");
      } else {
        // add constraints
        if(branch) {
          res = Solver::True;
          addConstraint(current, condition);
          current.lastConstraint = condition;
        } else  {
          res = Solver::False;
          addConstraint(current, Expr::createIsZero(condition));
          current.lastConstraint = Expr::createIsZero(condition);
        }
      }
    } else if (res==Solver::Unknown) {
      assert(!replayKTest && "in replay mode, only one branch can be true.");
      
      if ((MaxMemoryInhibit && atMemoryLimit) || 
          current.forkDisabled ||
          inhibitForking || 
          (MaxForks!=~0u && stats::forks >= MaxForks)) {

	if (MaxMemoryInhibit && atMemoryLimit)
	  klee_warning_once(0, "skipping fork (memory cap exceeded)");
	else if (current.forkDisabled)
	  klee_warning_once(0, "skipping fork (fork disabled on current path)");
	else if (inhibitForking)
	  klee_warning_once(0, "skipping fork (fork disabled globally)");
	else 
	  klee_warning_once(0, "skipping fork (max-forks reached)");

        TimerStatIncrementer timer(stats::forkTime);
        if (theRNG.getBool()) {
          addConstraint(current, condition);
          res = Solver::True;        
          current.lastConstraint = condition;
        } else {
          addConstraint(current, Expr::createIsZero(condition));
          res = Solver::False;
          current.lastConstraint = Expr::createIsZero(condition);
        }
      }
    }
  }

  // Fix branch in only-replay-seed mode, if we don't have both true
  // and false seeds.
  if (isSeeding && 
      (current.forkDisabled || OnlyReplaySeeds) && 
      res == Solver::Unknown) {
    bool trueSeed=false, falseSeed=false;
    // Is seed extension still ok here?
    for (std::vector<SeedInfo>::iterator siit = it->second.begin(), 
           siie = it->second.end(); siit != siie; ++siit) {
      ref<ConstantExpr> res;
      bool success = 
        solver->getValue(current, siit->assignment.evaluate(condition), res);
      assert(success && "FIXME: Unhandled solver failure");
      (void) success;
      if (res->isTrue()) {
        trueSeed = true;
      } else {
        falseSeed = true;
      }
      if (trueSeed && falseSeed)
        break;
    }
    if (!(trueSeed && falseSeed)) {
      assert(trueSeed || falseSeed);
      
      res = trueSeed ? Solver::True : Solver::False;
      addConstraint(current, trueSeed ? condition : Expr::createIsZero(condition));
      if (trueSeed)
         current.lastConstraint = condition;
      else
          current.lastConstraint = Expr::createIsZero(condition);
    }
  }


  // XXX - even if the constraint is provable one way or the other we
  // can probably benefit by adding this constraint and allowing it to
  // reduce the other constraints. For example, if we do a binary
  // search on a particular value, and then see a comparison against
  // the value it has been fixed at, we should take this as a nice
  // hint to just use the single constraint instead of all the binary
  // search ones. If that makes sense.
  if (res==Solver::True) {
    if (!isInternal) {
      if (pathWriter) {
        current.pathOS << "1";
      }
    }

    return StatePair(&current, 0);
  } else if (res==Solver::False) {
    if (!isInternal) {
      if (pathWriter) {
        current.pathOS << "0";
      }
    }

    return StatePair(0, &current);
  } else {
    TimerStatIncrementer timer(stats::forkTime);
    ExecutionState *falseState, *trueState = &current;

    ++stats::forks;

    falseState = trueState->branch();
    addedStates.push_back(falseState);

    if (it != seedMap.end()) {
      std::vector<SeedInfo> seeds = it->second;
      it->second.clear();
      std::vector<SeedInfo> &trueSeeds = seedMap[trueState];
      std::vector<SeedInfo> &falseSeeds = seedMap[falseState];
      for (std::vector<SeedInfo>::iterator siit = seeds.begin(), 
             siie = seeds.end(); siit != siie; ++siit) {
        ref<ConstantExpr> res;
        bool success = 
          solver->getValue(current, siit->assignment.evaluate(condition), res);
        assert(success && "FIXME: Unhandled solver failure");
        (void) success;
        if (res->isTrue()) {
          trueSeeds.push_back(*siit);
        } else {
          falseSeeds.push_back(*siit);
        }
      }
      
      bool swapInfo = false;
      if (trueSeeds.empty()) {
        if (&current == trueState) swapInfo = true;
        seedMap.erase(trueState);
      }
      if (falseSeeds.empty()) {
        if (&current == falseState) swapInfo = true;
        seedMap.erase(falseState);
      }
      if (swapInfo) {
        std::swap(trueState->coveredNew, falseState->coveredNew);
        std::swap(trueState->coveredLines, falseState->coveredLines);
      }
    }

    current.ptreeNode->data = 0;
    std::pair<PTree::Node*, PTree::Node*> res =
      processTree->split(current.ptreeNode, falseState, trueState);
    falseState->ptreeNode = res.first;
    trueState->ptreeNode = res.second;

    if (pathWriter) {
      // Need to update the pathOS.id field of falseState, otherwise the same id
      // is used for both falseState and trueState.
      falseState->pathOS = pathWriter->open(current.pathOS);
      if (!isInternal) {
        trueState->pathOS << "1";
        falseState->pathOS << "0";
      }
    }
    if (symPathWriter) {
      falseState->symPathOS = symPathWriter->open(current.symPathOS);
      if (!isInternal) {
        trueState->symPathOS << "1";
        falseState->symPathOS << "0";
      }
    }

    addConstraint(*trueState, condition);
    trueState->lastConstraint = condition;
    addConstraint(*falseState, Expr::createIsZero(condition));
    falseState->lastConstraint = Expr::createIsZero(condition);
    // Kinda gross, do we even really still want this option?
    if (MaxDepth && MaxDepth<=trueState->depth) {
      terminateStateEarly(*trueState, "max-depth exceeded.");
      terminateStateEarly(*falseState, "max-depth exceeded.");
      return StatePair(0, 0);
    }

    llvm::errs() << "forking for both cases!!! on state " << &current << " : " << trueState << " " << falseState << "\n";
    return StatePair(trueState, falseState);
  }
}

void Executor::addConstraint(ExecutionState &state, ref<Expr> condition) {
  if (ConstantExpr *CE = dyn_cast<ConstantExpr>(condition)) {
    if (!CE->isTrue())
      llvm::report_fatal_error("attempt to add invalid constraint");
    return;
  }

  // Check to see if this constraint violates seeds.
  std::map< ExecutionState*, std::vector<SeedInfo> >::iterator it = 
    seedMap.find(&state);
  if (it != seedMap.end()) {
    bool warn = false;
    for (std::vector<SeedInfo>::iterator siit = it->second.begin(), 
           siie = it->second.end(); siit != siie; ++siit) {
      bool res;
      bool success = 
        solver->mustBeFalse(state, siit->assignment.evaluate(condition), res);
      assert(success && "FIXME: Unhandled solver failure");
      (void) success;
      if (res) {
        siit->patchSeed(state, condition, solver);
        warn = true;
      }
    }
    if (warn)
      klee_warning("seeds patched for violating constraint"); 
  }

  state.addConstraint(condition);
  if (ivcEnabled)
    doImpliedValueConcretization(state, condition, 
                                 ConstantExpr::alloc(1, Expr::Bool));
}

const Cell& Executor::eval(KInstruction *ki, unsigned index, 
                           ExecutionState &state, StackFrame *sf) const {
  assert(index < ki->inst->getNumOperands());
  int vnumber = ki->operands[index];

  assert(vnumber != -1 &&
         "Invalid operand to eval(), not a value or constant!");

  // Determine if this is a constant or not.
  if (vnumber < 0) {
    unsigned index = -vnumber - 2;
    return kmodule->constantTable[index];
  } else {
    unsigned index = vnumber;
    llvm::errs() << "local variable index " << index << "\n";
    llvm::errs() << "local array " << sf->locals << "\n";
    return sf->locals[index];
  }

}

const Cell& Executor::eval(KInstruction *ki, unsigned index, 
                           ExecutionState &state) const {
  assert(index < ki->inst->getNumOperands());
  int vnumber = ki->operands[index];

  assert(vnumber != -1 &&
         "Invalid operand to eval(), not a value or constant!");

  // Determine if this is a constant or not.
  if (vnumber < 0) {
    unsigned index = -vnumber - 2;
    return kmodule->constantTable[index];
  } else {
    unsigned index = vnumber;
    StackFrame &sf = state.stack.back();
    return sf.locals[index];
  }
}

void Executor::bindLocal(KInstruction *target, ExecutionState &state, 
                         ref<Expr> value) {

  getDestCell(state, target).value = value;
  llvm::errs() << "local variable gets " << value << "\n"; 
}

void Executor::bindArgument(KFunction *kf, unsigned index, 
                            ExecutionState &state, ref<Expr> value) {
  getArgumentCell(state, kf, index).value = value;
  llvm::errs() << " function " << kf->function->getName() << " bindArgument " << index 
               << getArgumentCell(state, kf, index).value << "\n";
}

ref<Expr> Executor::toUnique(const ExecutionState &state, 
                             ref<Expr> &e) {
  ref<Expr> result = e;

  if (!isa<ConstantExpr>(e)) {
    ref<ConstantExpr> value;
    bool isTrue = false;

    solver->setTimeout(coreSolverTimeout);      
    if (solver->getValue(state, e, value) &&
        solver->mustBeTrue(state, EqExpr::create(e, value), isTrue) &&
        isTrue)
      result = value;
    solver->setTimeout(0);
  }
  
  return result;
}


/* Concretize the given expression, and return a possible constant value. 
   'reason' is just a documentation string stating the reason for concretization. */
ref<klee::ConstantExpr> 
Executor::toConstant(ExecutionState &state, 
                     ref<Expr> e,
                     const char *reason) {
  e = state.constraints.simplifyExpr(e);
  if (ConstantExpr *CE = dyn_cast<ConstantExpr>(e))
    return CE;

  ref<ConstantExpr> value;
  bool success = solver->getValue(state, e, value);
  assert(success && "FIXME: Unhandled solver failure");
  (void) success;

  std::string str;
  llvm::raw_string_ostream os(str);
  os << "silently concretizing (reason: " << reason << ") expression " << e
     << " to value " << value << " (" << (*(state.pc)).info->file << ":"
     << (*(state.pc)).info->line << ")";

  if (AllExternalWarnings)
    klee_warning(reason, os.str().c_str());
  else
    klee_warning_once(reason, "%s", os.str().c_str());

  addConstraint(state, EqExpr::create(e, value));
    
  return value;
}

void Executor::executeGetValue(ExecutionState &state,
                               ref<Expr> e,
                               KInstruction *target) {
  e = state.constraints.simplifyExpr(e);
  std::map< ExecutionState*, std::vector<SeedInfo> >::iterator it = 
    seedMap.find(&state);
  if (it==seedMap.end() || isa<ConstantExpr>(e)) {
    ref<ConstantExpr> value;
    bool success = solver->getValue(state, e, value);
    assert(success && "FIXME: Unhandled solver failure");
    (void) success;
    bindLocal(target, state, value);
  } else {
    std::set< ref<Expr> > values;
    for (std::vector<SeedInfo>::iterator siit = it->second.begin(), 
           siie = it->second.end(); siit != siie; ++siit) {
      ref<ConstantExpr> value;
      bool success = 
        solver->getValue(state, siit->assignment.evaluate(e), value);
      assert(success && "FIXME: Unhandled solver failure");
      (void) success;
      values.insert(value);
    }
    
    std::vector< ref<Expr> > conditions;
    for (std::set< ref<Expr> >::iterator vit = values.begin(), 
           vie = values.end(); vit != vie; ++vit)
      conditions.push_back(EqExpr::create(e, *vit));

    std::vector<ExecutionState*> branches;
    branch(state, conditions, branches);
    
    std::vector<ExecutionState*>::iterator bit = branches.begin();
    for (std::set< ref<Expr> >::iterator vit = values.begin(), 
           vie = values.end(); vit != vie; ++vit) {
      ExecutionState *es = *bit;
      if (es)
        bindLocal(target, *es, *vit);
      ++bit;
    }
  }
}

void Executor::printDebugInstructions(ExecutionState &state) {
  // check do not print
  if (DebugPrintInstructions.getBits() == 0)
	  return;

  llvm::raw_ostream *stream = 0;
  if (DebugPrintInstructions.isSet(STDERR_ALL) ||
      DebugPrintInstructions.isSet(STDERR_SRC) ||
      DebugPrintInstructions.isSet(STDERR_COMPACT))
    stream = &llvm::errs();
  else
    stream = &debugLogBuffer;

  if (!DebugPrintInstructions.isSet(STDERR_COMPACT) &&
      !DebugPrintInstructions.isSet(FILE_COMPACT)) {
    (*stream) << "     " << state.pc->getSourceLocation() << ":";
  }

  (*stream) << state.pc->info->assemblyLine;

  if (DebugPrintInstructions.isSet(STDERR_ALL) ||
      DebugPrintInstructions.isSet(FILE_ALL))
    (*stream) << ":" << *(state.pc->inst);
  (*stream) << "\n";

  if (DebugPrintInstructions.isSet(FILE_ALL) ||
      DebugPrintInstructions.isSet(FILE_COMPACT) ||
      DebugPrintInstructions.isSet(FILE_SRC)) {
    debugLogBuffer.flush();
    (*debugInstFile) << debugLogBuffer.str();
    debugBufferString = "";
  }
}

void Executor::stepInstruction(ExecutionState &state) {
  printDebugInstructions(state);
  if (statsTracker)
    statsTracker->stepInstruction(state);

  ++stats::instructions;
  ++state.steppedInstructions;
  state.prevPC = state.pc;
  ++state.pc;

  if (stats::instructions==StopAfterNInstructions)
    haltExecution = true;
}

void Executor::executeCall(ExecutionState &state, 
                           KInstruction *ki,
                           Function *f,
                           std::vector< ref<Expr> > &arguments) {
  Instruction *i = ki->inst;
  if (f && f->isDeclaration()) {
    switch(f->getIntrinsicID()) {
    case Intrinsic::not_intrinsic:
      // state may be destroyed by this call, cannot touch
      callExternalFunction(state, ki, f, arguments);
      break;
        
      // va_arg is handled by caller and intrinsic lowering, see comment for
      // ExecutionState::varargs
    case Intrinsic::vastart:  {
      StackFrame &sf = state.stack.back();

      // varargs can be zero if no varargs were provided
      if (!sf.varargs)
        return;

      // FIXME: This is really specific to the architecture, not the pointer
      // size. This happens to work for x86-32 and x86-64, however.
      Expr::Width WordSize = Context::get().getPointerWidth();
      if (WordSize == Expr::Int32) {
        executeMemoryOperation(state, true, arguments[0], 
                               sf.varargs->getBaseExpr(), 0);
      } else {
        assert(WordSize == Expr::Int64 && "Unknown word size!");

        // x86-64 has quite complicated calling convention. However,
        // instead of implementing it, we can do a simple hack: just
        // make a function believe that all varargs are on stack.
        executeMemoryOperation(state, true, arguments[0],
                               ConstantExpr::create(48, 32), 0); // gp_offset
        executeMemoryOperation(state, true,
                               AddExpr::create(arguments[0], 
                                               ConstantExpr::create(4, 64)),
                               ConstantExpr::create(304, 32), 0); // fp_offset
        executeMemoryOperation(state, true,
                               AddExpr::create(arguments[0], 
                                               ConstantExpr::create(8, 64)),
                               sf.varargs->getBaseExpr(), 0); // overflow_arg_area
        executeMemoryOperation(state, true,
                               AddExpr::create(arguments[0], 
                                               ConstantExpr::create(16, 64)),
                               ConstantExpr::create(0, 64), 0); // reg_save_area
      }
      break;
    }
    case Intrinsic::vaend:
      // va_end is a noop for the interpreter.
      //
      // FIXME: We should validate that the target didn't do something bad
      // with va_end, however (like call it twice).
      break;
        
    case Intrinsic::vacopy:
      // va_copy should have been lowered.
      //
      // FIXME: It would be nice to check for errors in the usage of this as
      // well.
    default:
      klee_error("unknown intrinsic: %s", f->getName().data());
    }

    if (InvokeInst *ii = dyn_cast<InvokeInst>(i))
      transferToBasicBlock(ii->getNormalDest(), i->getParent(), state);
      successorsPaths->insert(&state);
  } else {

       /* SYSREL extension */

     // check if the function is modeled by another function
     if (functionModeledBy.find(f->getName()) != functionModeledBy.end()) {
        llvm::errs() << "WARNING: Using " << functionModeledBy[f->getName()] 
                        << " for " << f->getName() << "\n";
        Function *modelFn = moduleHandle->getFunction(functionModeledBy[f->getName()]);
        if (modelFn) {  
           ((CallInst*)ki->inst)->setCalledFunction(modelFn);
            executeCall(state, ki, modelFn, arguments);
        } 
        else {
           llvm::errs() << "Model function: " << functionModeledBy[f->getName()] << "\n";
           assert(0 && "Model function not defined!");
        }
        return;
     }

      // check if PROSE version of the function exists, if so use that one
      std::string prosename = f->getName().str() + "_PROSE"; 
      Function *proseFn = moduleHandle->getFunction(prosename);
      if (proseFn) {
         llvm::errs() << "WARNING: Using " << prosename << " for " << f->getName() << "\n";
         ((CallInst*)ki->inst)->setCalledFunction(proseFn);
         executeCall(state, ki, proseFn, arguments);
         return;
      }
       // Handle certain functions in a special way, e.g., those that have inline assembly
       if (lazyInit && APIHandler::handles(removeDotSuffix(f->getName()))) {          
          callExternalFunction(state, ki, f, arguments);
          return;
       }
       /* SYSREL extension */



    // FIXME: I'm not really happy about this reliance on prevPC but it is ok, I
    // guess. This just done to avoid having to pass KInstIterator everywhere
    // instead of the actual instruction, since we can't make a KInstIterator
    // from just an instruction (unlike LLVM).
    KFunction *kf = kmodule->functionMap[f];
    state.pushFrame(state.prevPC, kf);
    state.pc = kf->instructions;

    if (recordStackTraces)
       recordStackTrace(state);

    if (statsTracker)
      statsTracker->framePushed(state, &state.stack[state.stack.size()-2]);

     // TODO: support "byval" parameter attribute
     // TODO: support zeroext, signext, sret attributes

    unsigned callingArgs = arguments.size();
    unsigned funcArgs = f->arg_size();
    if (!f->isVarArg()) {
      if (callingArgs > funcArgs) {
        klee_warning_once(f, "calling %s with extra arguments.", 
                          f->getName().data());
      } else if (callingArgs < funcArgs) {
        terminateStateOnError(state, "calling function with too few arguments",
                              User);
        return;
      }
    } else {
      Expr::Width WordSize = Context::get().getPointerWidth();

      if (callingArgs < funcArgs) {
        terminateStateOnError(state, "calling function with too few arguments",
                              User);
        return;
      }

      StackFrame &sf = state.stack.back();
      unsigned size = 0;
      bool requires16ByteAlignment = false;
      for (unsigned i = funcArgs; i < callingArgs; i++) {
        // FIXME: This is really specific to the architecture, not the pointer
        // size. This happens to work for x86-32 and x86-64, however.
        if (WordSize == Expr::Int32) {
          size += Expr::getMinBytesForWidth(arguments[i]->getWidth());
        } else {
          Expr::Width argWidth = arguments[i]->getWidth();
          // AMD64-ABI 3.5.7p5: Step 7. Align l->overflow_arg_area upwards to a
          // 16 byte boundary if alignment needed by type exceeds 8 byte
          // boundary.
          //
          // Alignment requirements for scalar types is the same as their size
          if (argWidth > Expr::Int64) {
#if LLVM_VERSION_CODE >= LLVM_VERSION(3, 9)
             size = llvm::alignTo(size, 16);
#else
             size = llvm::RoundUpToAlignment(size, 16);
#endif
             requires16ByteAlignment = true;
          }
#if LLVM_VERSION_CODE >= LLVM_VERSION(3, 9)
          size += llvm::alignTo(argWidth, WordSize) / 8;
#else
          size += llvm::RoundUpToAlignment(argWidth, WordSize) / 8;
#endif
        }
      }
      LLVMContext &ctx = moduleHandle->getContext();
      MemoryObject *mo = sf.varargs =
          memory->allocate(size, true, false, state.prevPC->inst,
                           (requires16ByteAlignment ? 16 : 8),
                           size, Type::getInt8Ty(ctx));
      if (!mo && size) {
        terminateStateOnExecError(state, "out of memory (varargs)");
        return;
      }

      if (mo) {
        recordMemObj(state, mo); 
        if ((WordSize == Expr::Int64) && (mo->address & 15) &&
            requires16ByteAlignment) {
          // Both 64bit Linux/Glibc and 64bit MacOSX should align to 16 bytes.
          klee_warning_once(
              0, "While allocating varargs: malloc did not align to 16 bytes.");
        }

        ObjectState *os = bindObjectInState(state, mo, true);
        unsigned offset = 0;
        for (unsigned i = funcArgs; i < callingArgs; i++) {
          // FIXME: This is really specific to the architecture, not the pointer
          // size. This happens to work for x86-32 and x86-64, however.
          if (WordSize == Expr::Int32) {
            os->write(offset, arguments[i]);
            offset += Expr::getMinBytesForWidth(arguments[i]->getWidth());
          } else {
            assert(WordSize == Expr::Int64 && "Unknown word size!");

            Expr::Width argWidth = arguments[i]->getWidth();
            if (argWidth > Expr::Int64) {
#if LLVM_VERSION_CODE >= LLVM_VERSION(3, 9)
              offset = llvm::alignTo(offset, 16);
#else
              offset = llvm::RoundUpToAlignment(offset, 16);
#endif
            }
            os->write(offset, arguments[i]);
#if LLVM_VERSION_CODE >= LLVM_VERSION(3, 9)
            offset += llvm::alignTo(argWidth, WordSize) / 8;
#else
            offset += llvm::RoundUpToAlignment(argWidth, WordSize) / 8;
#endif
          }
        }
      }
    }

    unsigned numFormals = f->arg_size();
    for (unsigned i=0; i<numFormals; ++i) 
      bindArgument(kf, i, state, arguments[i]);
  }
}

void Executor::transferToBasicBlock(BasicBlock *dst, BasicBlock *src, 
                                    ExecutionState &state) {
  // Note that in general phi nodes can reuse phi values from the same
  // block but the incoming value is the eval() result *before* the
  // execution of any phi nodes. this is pathological and doesn't
  // really seem to occur, but just in case we run the PhiCleanerPass
  // which makes sure this cannot happen and so it is safe to just
  // eval things in order. The PhiCleanerPass also makes sure that all
  // incoming blocks have the same order for each PHINode so we only
  // have to compute the index once.
  //
  // With that done we simply set an index in the state so that PHI
  // instructions know which argument to eval, set the pc, and continue.
  
  // XXX this lookup has to go ?
  KFunction *kf = state.stack.back().kf;
  unsigned entry = kf->basicBlockEntry[dst];
  state.pc = &kf->instructions[entry];
  if (state.pc->inst->getOpcode() == Instruction::PHI) {
    PHINode *first = static_cast<PHINode*>(state.pc->inst);
    state.incomingBBIndex = first->getBasicBlockIndex(src);
  }


  /* SYSREL */
  state.setPreemptable(-1, true);
  /* SYSREL */

}

/// Compute the true target of a function call, resolving LLVM and KLEE aliases
/// and bitcasts.
Function* Executor::getTargetFunction(Value *calledVal, ExecutionState &state) {
  SmallPtrSet<const GlobalValue*, 3> Visited;

  Constant *c = dyn_cast<Constant>(calledVal);
  if (!c)
    return 0;

  while (true) {
    if (GlobalValue *gv = dyn_cast<GlobalValue>(c)) {
#if LLVM_VERSION_CODE >= LLVM_VERSION(3, 6)
      if (!Visited.insert(gv).second)
        return 0;
#else
      if (!Visited.insert(gv))
        return 0;
#endif
      std::string alias = state.getFnAlias(gv->getName());
      if (alias != "") {
        llvm::Module* currModule = kmodule->module;
        GlobalValue *old_gv = gv;
        gv = currModule->getNamedValue(alias);
        if (!gv) {
          klee_error("Function %s(), alias for %s not found!\n", alias.c_str(),
                     old_gv->getName().str().c_str());
        }
      }
     
      if (Function *f = dyn_cast<Function>(gv))
        return f;
      else if (GlobalAlias *ga = dyn_cast<GlobalAlias>(gv))
        c = ga->getAliasee();
      else
        return 0;
    } else if (llvm::ConstantExpr *ce = dyn_cast<llvm::ConstantExpr>(c)) {
      if (ce->getOpcode()==Instruction::BitCast)
        c = ce->getOperand(0);
      else
        return 0;
    } else
      return 0;
  }
}

/// TODO remove?
/*static*/ bool isDebugIntrinsic(const Function *f, KModule *KM) {
  return false;
}

static inline const llvm::fltSemantics * fpWidthToSemantics(unsigned width) {
  switch(width) {
  case Expr::Int32:
    return &llvm::APFloat::IEEEsingle;
  case Expr::Int64:
    return &llvm::APFloat::IEEEdouble;
  case Expr::Fl80:
    return &llvm::APFloat::x87DoubleExtended;
  default:
    return 0;
  }
}

void Executor::executeInstruction(ExecutionState &state, KInstruction *ki) {

  state.stackFrameBeforeExecInst = state.stack.size() - 1; 

  Instruction *i = ki->inst;
  switch (i->getOpcode()) {
    // Control flow
  case Instruction::Ret: {
    ReturnInst *ri = cast<ReturnInst>(i);
    KInstIterator kcaller = state.stack.back().caller;
    Instruction *caller = kcaller ? kcaller->inst : 0;
    bool isVoidReturn = (ri->getNumOperands() == 0);
    ref<Expr> result = NULL;
    ref<Expr> retval = NULL;

    /* SYSREL EXTENSION */
    state.checkAndSetPMCallbackCompleted(ri->getParent()->getParent()->getName());
    /* SYSREL EXTENSION */

    llvm::outs() << "handling return for function " << ri->getParent()->getParent()->getName()  << "\n";
    if (!isVoidReturn) {
      result = eval(ki, 0, state).value;
      retval = result;
      /* SYSREL EXTENSION */
      if (state.hasLCM()) {
         llvm::outs() << "function " << ri->getParent()->getParent()->getName() << " return expression " << result << "\n"; 
         ConstantExpr *re = dyn_cast<ConstantExpr>(result);
         if (re) {
            llvm::outs() << "Recording return value " << re->getZExtValue() << " for " << ri->getParent()->getParent()->getName() << "\n";
            state.returnValueModel[ri->getParent()->getParent()->getName()] = re->getZExtValue();
         }
      }
      llvm::outs() << "return value " << result << " for " << ri->getParent()->getParent()->getName() << "\n";

      /* SYSREL EXTENSION */
    }
    if (RecordValueFlow)
       generateValuedInstruction(state, ki);

    if (state.stack.size() <= 1) {
      assert(!caller && "caller set on initial stack frame");
      /* SYSREL extension */

      Function *rf = ri->getParent()->getParent();

      if (state.hasLCM()) {
         llvm::outs() << "returning from function " << rf->getName() << "\n";
         llvm::outs() << "lcm completed? " <<  state.lcmCompleted() << "\n";
         llvm::outs() << "return instruction:\n";
         ri->print(llvm::outs());
         llvm::outs() << "state id: " << state.getID() << "\n";
         ExprPPrinter::printConstraints(llvm::outs(), state.constraints);
      }

      if (!state.activeThreads() && (!state.hasLCM() || state.lcmCompletesWith(removeDotSuffix(rf->getName())))) {
         llvm::outs() << "terminating state with " << rf->getName() << "\n";
         terminateStateOnExit(state);
      }
      else {
        if (state.activeThreads())
           state.setWaitingForThreadsToTerminate(true);
        if (state.hasLCM()) {
           if (!retval.isNull() && state.lcmStepMovesWhenReturns(removeDotSuffix(rf->getName()))) {
              BoundAST *bast = state.getCurrentSuccessConstraint();
              bool continues = false;
              ref<Expr> rs = NULL;
              bool always = false;
              bool never = false;
              if (bast) {
                 std::map<unsigned, std::pair<MemoryObject*,ObjectState*> > argObjs;
                 std::map<unsigned, unsigned> argSizes;
                 rs = generateExp(*bast, rf, argObjs, argSizes, retval);
                 if (ConstantExpr *CE=dyn_cast<ConstantExpr>(rs)) {
                    if (CE->getZExtValue() == 1)
                       always = true;
                    else if (CE->getZExtValue() == 0)
                       never = true;
                 } 
              }
              else {
                 ref<Expr> temp = ConstantExpr::alloc(state.getCurrentSuccessReturnValue(), 
                                                  result->getWidth());
                 rs = EqExpr::create(result,temp);
              }
              assert(!rs.isNull()); 
              if (bast && !rs.isNull() && never) {
                 llvm::errs() << "lcm forced to terminated as specified\n";
                 terminateStateOnExit(state);
                 return;
              }
              else if (bast && !rs.isNull() && always) {
                 llvm::errs() << "lcm continues with the next sequential step in an unconditional way\n";
                 state.updateLCMState();
                 return;
              }
              bool solversuccess = solver->mayBeTrue(state, rs, continues);
              assert(solversuccess && "FIXME: Unhandled solver failure");
              if (!continues) {
                 llvm::errs() << "terminating state and life cycle early due to error return value!\n";
                 terminateStateOnExit(state);
              }
              llvm::errs() << "lcm continues with the next sequential step\n";
              state.updateLCMState();
           }
           else { 
               llvm::outs() << "no, step not moving at..\n";
               llvm::outs() << state.prevPC->inst << "\n";
           }
        }
      }
      /* SYSREL extension */
    } else {
      state.stackFrameBeforeExecInst = state.stack.size() - 1; 
      state.popFrame();

      if (statsTracker)
        statsTracker->framePopped(state);

      if (InvokeInst *ii = dyn_cast<InvokeInst>(caller)) {
        llvm::outs() << "returning to basic block of " << (*caller) << "\n";
        transferToBasicBlock(ii->getNormalDest(), caller->getParent(), state);
      } else {
        state.pc = kcaller;
        ++state.pc;
        llvm::outs() << "returning to " <<  (*state.pc->inst) << "\n"; 
      }

      if (!isVoidReturn) {
        Type *t = caller->getType();
        if (t != Type::getVoidTy(i->getContext())) {
          // may need to do coercion due to bitcasts
          Expr::Width from = result->getWidth();
          Expr::Width to = getWidthForLLVMType(t);
            
          if (from != to) {
            CallSite cs = (isa<InvokeInst>(caller) ? CallSite(cast<InvokeInst>(caller)) : 
                           CallSite(cast<CallInst>(caller)));

            // XXX need to check other param attrs ?
      bool isSExt = cs.paramHasAttr(0, llvm::Attribute::SExt);
            if (isSExt) {
              result = SExtExpr::create(result, to);
            } else {
              result = ZExtExpr::create(result, to);
            }
          }

          bindLocal(kcaller, state, result);
        }
      } else {
        // We check that the return value has no users instead of
        // checking the type, since C defaults to returning int for
        // undeclared functions.
        /* SYSREL extension */        
        llvm::errs() << "Warning: return void when caller expected a result\n";
        /* SYSREL extension */
      }
    }      
    break;
  }
  case Instruction::Br: {
    BranchInst *bi = cast<BranchInst>(i);
    if (bi->isUnconditional()) {
      transferToBasicBlock(bi->getSuccessor(0), bi->getParent(), state);
      successorsPaths->insert(&state);
    } else {
      // FIXME: Find a way that we don't have this hidden dependency.
      assert(bi->getCondition() == bi->getOperand(0) &&
             "Wrong operand index!");
      ref<Expr> cond = eval(ki, 0, state).value;
      Executor::StatePair branches = fork(state, cond, false);

      if (branches.first)
         branches.first->lastBranchInstConstraint = branches.first->lastConstraint;

      if (branches.second)
         branches.second->lastBranchInstConstraint = branches.second->lastConstraint;

      // NOTE: There is a hidden dependency here, markBranchVisited
      // requires that we still be in the context of the branch
      // instruction (it reuses its statistic id). Should be cleaned
      // up with convenient instruction specific data.
      if (statsTracker && state.stack.back().kf->trackCoverage)
        statsTracker->markBranchVisited(branches.first, branches.second);

      /* SYSREL extension */
      Function *func = i->getParent()->getParent(); 
      unsigned tc, fc;
      bool lbe = isLoopBoundExcluded(state.prevPC->getSourceLocation(), func->getName());
      //llvm::errs() << "loop bound= " << loopBound  << " excl? " << lbe << "\n";
      if (loopBound && !lbe) {
         if (branches.first) {
            addForkFreq(state,getSourceWithContext(state, state.prevPC), true);
         }

         if (branches.second) {
            addForkFreq(state,getSourceWithContext(state, state.prevPC), false);
         }
         tc = getForkFreq(state, getSourceWithContext(state, state.prevPC), true);
         fc = getForkFreq(state, getSourceWithContext(state, state.prevPC), false);
         llvm::errs() << "forked at " << state.prevPC->getSourceLocation() << " true branch " << tc << " times\n";
         llvm::errs() << "forked at " << state.prevPC->getSourceLocation() << " false branch " << fc << " times\n";
         
         if (branches.first && branches.second) {
            if (fc > loopBound && tc > loopBound) {
               // terminate state
               llvm::errs() << "path terminated early due to reaching bound for both branches\n";
               terminateStateEarly(state, "Loop Bound for both successors reached\n");
            }
            else if (tc > loopBound) {
               llvm::errs() << "path terminated for the true branch\n";
               terminateStateEarly(*branches.first, "Loop Bound for true successor reached\n");
               transferToBasicBlock(bi->getSuccessor(1), bi->getParent(), *branches.second); 
               successorsPaths->insert(branches.second);
            }
            else if (fc > loopBound) {
               llvm::errs() << "path terminated for the false branch\n";
               terminateStateEarly(*branches.second, "Loop Bound for false successor reached\n");
               transferToBasicBlock(bi->getSuccessor(0), bi->getParent(), *branches.first);
               successorsPaths->insert(branches.first);
            }
            else {
               transferToBasicBlock(bi->getSuccessor(0), bi->getParent(), *branches.first);
               successorsPaths->insert(branches.first);
               transferToBasicBlock(bi->getSuccessor(1), bi->getParent(), *branches.second);
               successorsPaths->insert(branches.second);
               singleSuccessor = false;
               bool abort = false;
               ref<Expr> offendingAddress = Expr::createPointer(0);
               branches.first->executePM(abort, offendingAddress);
               if (abort) {
                  terminateStateOnError(state, "Memory error", Ptr, NULL, 
                             getAddressInfo(*branches.first, offendingAddress));
               }
               llvm::errs() << "executingPM on successor second\n";
               branches.second->executePM(abort, offendingAddress);
               if (abort) {
                  terminateStateOnError(state, "Memory error", Ptr, NULL, 
                             getAddressInfo(*branches.second, offendingAddress));
               }  
            }               
         }         
         else {
            if (branches.first) {
               if (tc > loopBound) {
                  llvm::errs() << "branching to the false successor due to reaching loop bound for the true branch\n";
                  transferToBasicBlock(bi->getSuccessor(1), bi->getParent(), *branches.first);
                  successorsPaths->insert(branches.first);
               }
               else {
                  transferToBasicBlock(bi->getSuccessor(0), bi->getParent(), *branches.first);
                  successorsPaths->insert(branches.first);  
               }
            }
            if (branches.second) {
               if (fc > loopBound) {
                  //llvm::errs() << "path terminated for the false branch\n";
                  //terminateStateEarly(*branches.second, "Loop Bound for false successor reached\n");                  
                  transferToBasicBlock(bi->getSuccessor(0), bi->getParent(), *branches.second);
                  successorsPaths->insert(branches.second);
               }
               else {               
                  transferToBasicBlock(bi->getSuccessor(1), bi->getParent(), *branches.second);
                  successorsPaths->insert(branches.second);
               }
            }
         }
      }
      else {
         if (branches.first) {
            transferToBasicBlock(bi->getSuccessor(0), bi->getParent(), *branches.first);
            successorsPaths->insert(branches.first);
         }
         if (branches.second) {
            transferToBasicBlock(bi->getSuccessor(1), bi->getParent(), *branches.second);
            successorsPaths->insert(branches.second);
         }

         if (branches.first && branches.second) {
            singleSuccessor = false;
            bool abort = false;
            ref<Expr> offendingAddress = Expr::createPointer(0);
            branches.first->executePM(abort, offendingAddress);
            if (abort) {
	       terminateStateOnError(state, "Memory error", Ptr, NULL, 
                             getAddressInfo(*branches.first, offendingAddress));
            }
            llvm::errs() << "executingPM on successor second\n";
            branches.second->executePM(abort, offendingAddress);
            if (abort) {
	       terminateStateOnError(state, "Memory error", Ptr, NULL, 
                             getAddressInfo(*branches.second, offendingAddress));
            }  
         } 
      }
      /* SYSREL extension */

    }
    break;
  }
  case Instruction::IndirectBr: {
    // implements indirect branch to a label within the current function
    const auto bi = cast<IndirectBrInst>(i);
    auto address = eval(ki, 0, state).value;
    address = toUnique(state, address);

    // concrete address
    if (const auto CE = dyn_cast<ConstantExpr>(address.get())) {
      const auto bb_address = (BasicBlock *) CE->getZExtValue(Context::get().getPointerWidth());
      transferToBasicBlock(bb_address, bi->getParent(), state);
      successorsPaths->insert(&state);
      break;
    }

    // symbolic address
    const auto numDestinations = bi->getNumDestinations();
    std::vector<BasicBlock *> targets;
    targets.reserve(numDestinations);
    std::vector<ref<Expr>> expressions;
    expressions.reserve(numDestinations);

    ref<Expr> errorCase = ConstantExpr::alloc(1, Expr::Bool);
    SmallPtrSet<BasicBlock *, 5> destinations;
    // collect and check destinations from label list
    for (unsigned k = 0; k < numDestinations; ++k) {
      // filter duplicates
      const auto d = bi->getDestination(k);
      if (destinations.count(d)) continue;
      destinations.insert(d);

      // create address expression
      const auto PE = Expr::createPointer(reinterpret_cast<std::uint64_t>(d));
      ref<Expr> e = EqExpr::create(address, PE);

      // exclude address from errorCase
      errorCase = AndExpr::create(errorCase, Expr::createIsZero(e));

      // check feasibility
      bool result;
      bool success __attribute__ ((unused)) = solver->mayBeTrue(state, e, result);
      assert(success && "FIXME: Unhandled solver failure");
      if (result) {
        targets.push_back(d);
        expressions.push_back(e);
      }
    }
    // check errorCase feasibility
    bool result;
    bool success __attribute__ ((unused)) = solver->mayBeTrue(state, errorCase, result);
    assert(success && "FIXME: Unhandled solver failure");
    if (result) {
      expressions.push_back(errorCase);
    }

    // fork states
    std::vector<ExecutionState *> branches;
    branch(state, expressions, branches);

    // terminate error state
    if (result) {
      terminateStateOnExecError(*branches.back(), "indirectbr: illegal label address");
      branches.pop_back();
    }

    // branch states to resp. target blocks
    assert(targets.size() == branches.size());
    for (std::vector<ExecutionState *>::size_type k = 0; k < branches.size(); ++k) {
      if (branches[k]) {
        transferToBasicBlock(targets[k], bi->getParent(), *branches[k]);
        successorsPaths->insert(branches[k]);
      }
    }

    break;
  }
  case Instruction::Switch: {
    SwitchInst *si = cast<SwitchInst>(i);
    ref<Expr> cond = eval(ki, 0, state).value;
    BasicBlock *bb = si->getParent();

    cond = toUnique(state, cond);
    if (ConstantExpr *CE = dyn_cast<ConstantExpr>(cond)) {
      // Somewhat gross to create these all the time, but fine till we
      // switch to an internal rep.
      llvm::IntegerType *Ty = cast<IntegerType>(si->getCondition()->getType());
      ConstantInt *ci = ConstantInt::get(Ty, CE->getZExtValue());
      unsigned index = si->findCaseValue(ci).getSuccessorIndex();
      transferToBasicBlock(si->getSuccessor(index), si->getParent(), state);
      successorsPaths->insert(&state);
    } else {
      // Handle possible different branch targets

      // We have the following assumptions:
      // - each case value is mutual exclusive to all other values including the
      //   default value
      // - order of case branches is based on the order of the expressions of
      //   the scase values, still default is handled last
      std::vector<BasicBlock *> bbOrder;
      std::map<BasicBlock *, ref<Expr> > branchTargets;

      std::map<ref<Expr>, BasicBlock *> expressionOrder;

      // Iterate through all non-default cases and order them by expressions
#if LLVM_VERSION_CODE > LLVM_VERSION(3, 4)
      for (auto i : si->cases()) {
#else
      for (SwitchInst::CaseIt i = si->case_begin(), e = si->case_end(); i != e;
           ++i) {
#endif
        ref<Expr> value = evalConstant(i.getCaseValue());

        BasicBlock *caseSuccessor = i.getCaseSuccessor();
        expressionOrder.insert(std::make_pair(value, caseSuccessor));
      }

      // Track default branch values
      ref<Expr> defaultValue = ConstantExpr::alloc(1, Expr::Bool);

      // iterate through all non-default cases but in order of the expressions
      for (std::map<ref<Expr>, BasicBlock *>::iterator
               it = expressionOrder.begin(),
               itE = expressionOrder.end();
           it != itE; ++it) {
        ref<Expr> match = EqExpr::create(cond, it->first);

        // Make sure that the default value does not contain this target's value
        defaultValue = AndExpr::create(defaultValue, Expr::createIsZero(match));

        // Check if control flow could take this case
        bool result;
        bool success = solver->mayBeTrue(state, match, result);
        assert(success && "FIXME: Unhandled solver failure");
        (void) success;
        if (result) {
          BasicBlock *caseSuccessor = it->second;

          // Handle the case that a basic block might be the target of multiple
          // switch cases.
          // Currently we generate an expression containing all switch-case
          // values for the same target basic block. We spare us forking too
          // many times but we generate more complex condition expressions
          // TODO Add option to allow to choose between those behaviors
          std::pair<std::map<BasicBlock *, ref<Expr> >::iterator, bool> res =
              branchTargets.insert(std::make_pair(
                  caseSuccessor, ConstantExpr::alloc(0, Expr::Bool)));

          res.first->second = OrExpr::create(match, res.first->second);

          // Only add basic blocks which have not been target of a branch yet
          if (res.second) {
            bbOrder.push_back(caseSuccessor);
          }
        }
      }

      // Check if control could take the default case
      bool res;
      bool success = solver->mayBeTrue(state, defaultValue, res);
      assert(success && "FIXME: Unhandled solver failure");
      (void) success;
      if (res) {
        std::pair<std::map<BasicBlock *, ref<Expr> >::iterator, bool> ret =
            branchTargets.insert(
                std::make_pair(si->getDefaultDest(), defaultValue));
        if (ret.second) {
          bbOrder.push_back(si->getDefaultDest());
        }
      }

      // Fork the current state with each state having one of the possible
      // successors of this switch
      std::vector< ref<Expr> > conditions;
      for (std::vector<BasicBlock *>::iterator it = bbOrder.begin(),
                                               ie = bbOrder.end();
           it != ie; ++it) {
        conditions.push_back(branchTargets[*it]);
      }
      std::vector<ExecutionState*> branches;
      branch(state, conditions, branches);

      std::vector<ExecutionState*>::iterator bit = branches.begin();
      for (std::vector<BasicBlock *>::iterator it = bbOrder.begin(),
                                               ie = bbOrder.end();
           it != ie; ++it) {
        ExecutionState *es = *bit;
        if (es) {
          transferToBasicBlock(*it, bb, *es);
          successorsPaths->insert(es); 
        }
        ++bit;
      }
    }
    break;
  }
  case Instruction::Unreachable:
    // Note that this is not necessarily an internal bug, llvm will
    // generate unreachable instructions in cases where it knows the
    // program will crash. So it is effectively a SEGV or internal
    // error.
    terminateStateOnExecError(state, "reached \"unreachable\" instruction");
    break;

  case Instruction::Invoke:
  case Instruction::Call: {
    CallSite cs(i);

    unsigned numArgs = cs.arg_size();
    Value *fp = cs.getCalledValue();
    Function *f = getTargetFunction(fp, state);

    /* begin SYSREL extension */
    if (asyncMode) { 
      if (isAsyncInitiate(removeDotSuffix(f->getName()))) {
         std::string asyncName = getAsyncFunction(removeDotSuffix(f->getName()));
         llvm::outs() << "checking for async function name " << asyncName << "\n";
         if (isAsync(asyncName)) {
            Function *asyncF =  moduleHandle->getFunction(asyncName);
            int c = state.initiateAsync(asyncF);
            llvm::outs() << "async function " << asyncName << " initiated, count=" << c << "\n"; 
            break;
         }
      }
      else if (isEnableEntry(removeDotSuffix(f->getName()))) {
         std::string asyncName = getEnableFunction(removeDotSuffix(f->getName()));
         llvm::outs() << "checking for enabled function name " << asyncName << "\n";
         if (isEnabled(asyncName)) {
            Function *asyncF =  moduleHandle->getFunction(asyncName);
            int c = state.initiateAsync(asyncF);
            llvm::outs() << "enabled function " << asyncName << " initiated, count=" << c << "\n"; 
            break;     
         }
      }
    }
    else if (!asyncMode && f && isAsyncInitiate(removeDotSuffix(f->getName()))) {
      llvm::outs() << "Ignoring async_initiate in single threaded mode\n";
      break;
    }
    /* end SYSREL extension */

    // Skip debug intrinsics, we can't evaluate their metadata arguments.
    if (f && isDebugIntrinsic(f, kmodule))
      break;

    if (isa<InlineAsm>(fp)) {
       llvm::InlineAsm *iasm = dyn_cast<llvm::InlineAsm>(fp);
       if (symbolizeInlineAssembly) {
          llvm::errs() << "handling inline assembly by symbolizing the return value " << iasm->getAsmString() << "\n";
          bool abort = false;
          symbolizeReturnValueForAsmInstruction(state, ki, iasm, abort);
          if (abort)
             terminateStateOnExecError(state, "failure to symbolize return value of inline assembly");
          break;
       }
       else {
          llvm::errs() << "inline assembly is unsupported: " << iasm->getAsmString() << "\n";
          terminateStateOnExecError(state, "inline assembly is unsupported");
          break;
       }
    }
    // evaluate arguments
    std::vector< ref<Expr> > arguments;
    arguments.reserve(numArgs);

    for (unsigned j=0; j<numArgs; ++j)
      arguments.push_back(eval(ki, j+1, state).value);

    if (f) {

       /* SYSREL extension */
       llvm::outs() << "calling function " << f->getName() << "\n";
       if (isAssemblyFunc(removeDotSuffix(f->getName()))) {
          llvm::outs() << "handling assembly function " << f->getName() << "\n";
          callExternalFunction(state, ki, f, arguments);
          return;
       }
       /* SYSREL extension */

      const FunctionType *fType = 
        dyn_cast<FunctionType>(cast<PointerType>(f->getType())->getElementType());
      const FunctionType *fpType =
        dyn_cast<FunctionType>(cast<PointerType>(fp->getType())->getElementType());

      // special case the call with a bitcast case
      if (fType != fpType) {
        assert(fType && fpType && "unable to get function type");

        // XXX check result coercion

        // XXX this really needs thought and validation
        unsigned i=0;
        for (std::vector< ref<Expr> >::iterator
               ai = arguments.begin(), ie = arguments.end();
             ai != ie; ++ai) {
          Expr::Width to, from = (*ai)->getWidth();
            
          if (i<fType->getNumParams()) {
            to = getWidthForLLVMType(fType->getParamType(i));

            if (from != to) {
              // XXX need to check other param attrs ?
              bool isSExt = cs.paramHasAttr(i+1, llvm::Attribute::SExt);
              if (isSExt) {
                arguments[i] = SExtExpr::create(arguments[i], to);
              } else {
                arguments[i] = ZExtExpr::create(arguments[i], to);
              }
            }
          }
            
          i++;
        }
      }

      executeCall(state, ki, f, arguments);
    } else {
      ref<Expr> v = eval(ki, 0, state).value;

      ExecutionState *free = &state;
      bool hasInvalid = false, first = true;

      /* XXX This is wasteful, no need to do a full evaluate since we
         have already got a value. But in the end the caches should
         handle it for us, albeit with some overhead. */
      do {
        ref<ConstantExpr> value;
        bool success = solver->getValue(*free, v, value);
        assert(success && "FIXME: Unhandled solver failure");
        (void) success;
        StatePair res = fork(*free, EqExpr::create(v, value), true);
        if (res.first) {
          uint64_t addr = value->getZExtValue();
          if (legalFunctions.count(addr)) {
            f = (Function*) addr;

            // Don't give warning on unique resolution
            if (res.second || !first)
              klee_warning_once(reinterpret_cast<void*>(addr),
                                "resolved symbolic function pointer to: %s",
                                f->getName().data());

            executeCall(*res.first, ki, f, arguments);
          } else {
            if (!hasInvalid) {
              terminateStateOnExecError(state, "invalid function pointer");
              hasInvalid = true;
            }
          }
        }

        first = false;
        free = res.second;
      } while (free);
    }
    break;
  }
  case Instruction::PHI: {
    ref<Expr> result = eval(ki, state.incomingBBIndex, state).value;
    bindLocal(ki, state, result);
    break;
  }

    // Special instructions
  case Instruction::Select: {
     if (BreakSelectStmt) {
       ref<Expr> cond = eval(ki, 0, state).value;
       Executor::StatePair branches = fork(state, cond, false);
       if (branches.first) {
          ref<Expr> tExpr = eval(ki, 1, state).value;
          bindLocal(ki, *branches.first, tExpr);
          successorsPaths->insert(branches.first);
          llvm::errs() << "True branch of select: " << (*ki->inst) << " condition " << cond << "\n";
       }
       if (branches.second) {
          ref<Expr> fExpr = eval(ki, 2, state).value;
          bindLocal(ki, *branches.second, fExpr);
          successorsPaths->insert(branches.second); 
          llvm::errs() << "False branch of select: " << (*ki->inst) << " condition !" << cond << "\n";
       }
    }
    else {
       // NOTE: It is not required that operands 1 and 2 be of scalar type.
       ref<Expr> cond = eval(ki, 0, state).value;
       ref<Expr> tExpr = eval(ki, 1, state).value;
       ref<Expr> fExpr = eval(ki, 2, state).value;
       ref<Expr> result = SelectExpr::create(cond, tExpr, fExpr);
       bindLocal(ki, state, result);
    }
    break;
  }

  case Instruction::VAArg:
    terminateStateOnExecError(state, "unexpected VAArg instruction");
    break;

    // Arithmetic / logical

  case Instruction::Add: {
    ref<Expr> left = eval(ki, 0, state).value;
    ref<Expr> right = eval(ki, 1, state).value;
    bindLocal(ki, state, AddExpr::create(left, right));
    break;
  }

  case Instruction::Sub: {
    ref<Expr> left = eval(ki, 0, state).value;
    ref<Expr> right = eval(ki, 1, state).value;
    bindLocal(ki, state, SubExpr::create(left, right));
    break;
  }
 
  case Instruction::Mul: {
    ref<Expr> left = eval(ki, 0, state).value;
    ref<Expr> right = eval(ki, 1, state).value;
    bindLocal(ki, state, MulExpr::create(left, right));
    break;
  }

  case Instruction::UDiv: {
    ref<Expr> left = eval(ki, 0, state).value;
    ref<Expr> right = eval(ki, 1, state).value;
    ref<Expr> result = UDivExpr::create(left, right);
    bindLocal(ki, state, result);
    break;
  }

  case Instruction::SDiv: {
    ref<Expr> left = eval(ki, 0, state).value;
    ref<Expr> right = eval(ki, 1, state).value;
    ref<Expr> result = SDivExpr::create(left, right);
    bindLocal(ki, state, result);
    break;
  }

  case Instruction::URem: {
    ref<Expr> left = eval(ki, 0, state).value;
    ref<Expr> right = eval(ki, 1, state).value;
    ref<Expr> result = URemExpr::create(left, right);
    bindLocal(ki, state, result);
    break;
  }

  case Instruction::SRem: {
    ref<Expr> left = eval(ki, 0, state).value;
    ref<Expr> right = eval(ki, 1, state).value;
    ref<Expr> result = SRemExpr::create(left, right);
    bindLocal(ki, state, result);
    break;
  }

  case Instruction::And: {
    ref<Expr> left = eval(ki, 0, state).value;
    ref<Expr> right = eval(ki, 1, state).value;
    ref<Expr> result = AndExpr::create(left, right);
    bindLocal(ki, state, result);
    break;
  }

  case Instruction::Or: {
    ref<Expr> left = eval(ki, 0, state).value;
    ref<Expr> right = eval(ki, 1, state).value;
    ref<Expr> result = OrExpr::create(left, right);
    bindLocal(ki, state, result);
    break;
  }

  case Instruction::Xor: {
    ref<Expr> left = eval(ki, 0, state).value;
    ref<Expr> right = eval(ki, 1, state).value;
    ref<Expr> result = XorExpr::create(left, right);
    bindLocal(ki, state, result);
    break;
  }

  case Instruction::Shl: {
    ref<Expr> left = eval(ki, 0, state).value;
    ref<Expr> right = eval(ki, 1, state).value;
    ref<Expr> result = ShlExpr::create(left, right);
    bindLocal(ki, state, result);
    break;
  }

  case Instruction::LShr: {
    ref<Expr> left = eval(ki, 0, state).value;
    ref<Expr> right = eval(ki, 1, state).value;
    ref<Expr> result = LShrExpr::create(left, right);
    bindLocal(ki, state, result);
    break;
  }

  case Instruction::AShr: {
    ref<Expr> left = eval(ki, 0, state).value;
    ref<Expr> right = eval(ki, 1, state).value;
    ref<Expr> result = AShrExpr::create(left, right);
    bindLocal(ki, state, result);
    break;
  }

    // Compare

  case Instruction::ICmp: {
    CmpInst *ci = cast<CmpInst>(i);
    ICmpInst *ii = cast<ICmpInst>(ci);

    switch(ii->getPredicate()) {
    case ICmpInst::ICMP_EQ: {
      ref<Expr> left = eval(ki, 0, state).value;
      ref<Expr> right = eval(ki, 1, state).value;
      ref<Expr> result = EqExpr::create(left, right);
      bindLocal(ki, state, result);
      break;
    }

    case ICmpInst::ICMP_NE: {
      ref<Expr> left = eval(ki, 0, state).value;
      ref<Expr> right = eval(ki, 1, state).value;
      ref<Expr> result = NeExpr::create(left, right);
      bindLocal(ki, state, result);
      break;
    }

    case ICmpInst::ICMP_UGT: {
      ref<Expr> left = eval(ki, 0, state).value;
      ref<Expr> right = eval(ki, 1, state).value;
      ref<Expr> result = UgtExpr::create(left, right);
      bindLocal(ki, state,result);
      break;
    }

    case ICmpInst::ICMP_UGE: {
      ref<Expr> left = eval(ki, 0, state).value;
      ref<Expr> right = eval(ki, 1, state).value;
      ref<Expr> result = UgeExpr::create(left, right);
      bindLocal(ki, state, result);
      break;
    }

    case ICmpInst::ICMP_ULT: {
      ref<Expr> left = eval(ki, 0, state).value;
      ref<Expr> right = eval(ki, 1, state).value;
      ref<Expr> result = UltExpr::create(left, right);
      bindLocal(ki, state, result);
      break;
    }

    case ICmpInst::ICMP_ULE: {
      ref<Expr> left = eval(ki, 0, state).value;
      ref<Expr> right = eval(ki, 1, state).value;
      ref<Expr> result = UleExpr::create(left, right);
      bindLocal(ki, state, result);
      break;
    }

    case ICmpInst::ICMP_SGT: {
      ref<Expr> left = eval(ki, 0, state).value;
      ref<Expr> right = eval(ki, 1, state).value;
      ref<Expr> result = SgtExpr::create(left, right);
      bindLocal(ki, state, result);
      break;
    }

    case ICmpInst::ICMP_SGE: {
      ref<Expr> left = eval(ki, 0, state).value;
      ref<Expr> right = eval(ki, 1, state).value;
      ref<Expr> result = SgeExpr::create(left, right);
      bindLocal(ki, state, result);
      break;
    }

    case ICmpInst::ICMP_SLT: {
      ref<Expr> left = eval(ki, 0, state).value;
      ref<Expr> right = eval(ki, 1, state).value;
      ref<Expr> result = SltExpr::create(left, right);
      bindLocal(ki, state, result);
      break;
    }

    case ICmpInst::ICMP_SLE: {
      ref<Expr> left = eval(ki, 0, state).value;
      ref<Expr> right = eval(ki, 1, state).value;
      ref<Expr> result = SleExpr::create(left, right);
      bindLocal(ki, state, result);
      break;
    }

    default:
      terminateStateOnExecError(state, "invalid ICmp predicate");
    }
    break;
  }
 
    // Memory instructions...
  case Instruction::Alloca: {
    AllocaInst *ai = cast<AllocaInst>(i);
    unsigned elementSize = 
      kmodule->targetData->getTypeStoreSize(ai->getAllocatedType());
    ref<Expr> size = Expr::createPointer(elementSize);
    if (ai->isArrayAllocation()) {
      ref<Expr> count = eval(ki, 0, state).value;
      count = Expr::createZExtToPointerWidth(count);
      size = MulExpr::create(size, count);
    }
    executeAlloc(state, size, true, ki);
    break;
  }

  case Instruction::Load: {
    ref<Expr> base = eval(ki, 0, state).value;
    executeMemoryOperation(state, false, base, 0, ki);
    break;
  }
  case Instruction::Store: {
    ref<Expr> base = eval(ki, 1, state).value;
    ref<Expr> value = eval(ki, 0, state).value;
    executeMemoryOperation(state, true, base, value, 0);
    break;
  }

  case Instruction::GetElementPtr: {
    KGEPInstruction *kgepi = static_cast<KGEPInstruction*>(ki);
    ref<Expr> base = eval(ki, 0, state).value;
    ref<Expr> origbase = base;
    llvm::errs() << "GetElementPtr info:\n";
    ki->inst->print(llvm::outs());
    llvm::errs() << "\n initial base: " << base << "\n";
    for (std::vector< std::pair<unsigned, uint64_t> >::iterator 
           it = kgepi->indices.begin(), ie = kgepi->indices.end(); 
         it != ie; ++it) {
      uint64_t elementSize = it->second;
      ref<Expr> index = eval(ki, it->first, state).value;
 
      llvm::errs() << "index: " << index << "\n";
      llvm::errs() << "pointer: " << Expr::createPointer(elementSize) << "\n";
      base = AddExpr::create(base,
                             MulExpr::create(Expr::createSExtToPointerWidth(index),
                                             Expr::createPointer(elementSize)));
      llvm::errs() << "base: " << base << "\n";
    }
    if (kgepi->offset) {
      base = AddExpr::create(base,
                             Expr::createPointer(kgepi->offset));
      llvm::errs() << "geptr offset: " << Expr::createPointer(kgepi->offset) << "\n";
      llvm::errs() << "geptr base: " << base << "\n";
    }
    llvm::errs() << "geptr final base: " << base << "\n";
    bindLocal(ki, state, base);

    if (PreferredResolution) {
       if (symIndexToMemBase.find((long)&state) != symIndexToMemBase.end()) {
             std::map<ref<Expr>, ref<Expr> > m = symIndexToMemBase[(long)&state];
           if (base != origbase || m.find(base) == m.end()) { 
              m[base] = origbase;
              symIndexToMemBase[(long)&state] = m;
              llvm::errs() << "recording mapping from geptr index " << base << " to " << origbase << " in state " << &state << "\n";
          }
       }
    }

    break;
  }

    // Conversion
  case Instruction::Trunc: {
    CastInst *ci = cast<CastInst>(i);
    ref<Expr> result = ExtractExpr::create(eval(ki, 0, state).value,
                                           0,
                                           getWidthForLLVMType(ci->getType()));
    bindLocal(ki, state, result);
    break;
  }
  case Instruction::ZExt: {
    CastInst *ci = cast<CastInst>(i);
    ref<Expr> result = ZExtExpr::create(eval(ki, 0, state).value,
                                        getWidthForLLVMType(ci->getType()));
    bindLocal(ki, state, result);
    break;
  }
  case Instruction::SExt: {
    CastInst *ci = cast<CastInst>(i);
    ref<Expr> result = SExtExpr::create(eval(ki, 0, state).value,
                                        getWidthForLLVMType(ci->getType()));
    bindLocal(ki, state, result);
    break;
  }

  case Instruction::IntToPtr: {
    CastInst *ci = cast<CastInst>(i);
    Expr::Width pType = getWidthForLLVMType(ci->getType());
    ref<Expr> arg = eval(ki, 0, state).value;
    bindLocal(ki, state, ZExtExpr::create(arg, pType));
    break;
  }
  case Instruction::PtrToInt: {
    CastInst *ci = cast<CastInst>(i);
    Expr::Width iType = getWidthForLLVMType(ci->getType());
    ref<Expr> arg = eval(ki, 0, state).value;
    bindLocal(ki, state, ZExtExpr::create(arg, iType));
    break;
  }

  case Instruction::BitCast: {
    ref<Expr> result = eval(ki, 0, state).value;
    bindLocal(ki, state, result);
   
    /* SYSREL EXTENSION */
   if (lazyInit) {
    llvm::outs() <<  (*(ki->inst)) << "\n";
    llvm::outs() << "num ops " << getTypeName(ki->inst->getType()) << "\n"; 
    Type *t = ki->inst->getType(); 
    Type *frt = ki->inst->getOperand(0)->getType();
    if (frt) {
       if (frt->isPointerTy()) 
          frt = frt->getPointerElementType();
       StructType *st = dyn_cast<StructType>(frt);
       if (st) {
          state.addrToCastFromStructType[result] = frt;
          llvm::errs() << "bitcasting from base type: " << getTypeName(frt) << "for address " << result << "\n"; 
       }       
    }
    if (t->isPointerTy()) {
       t = t->getPointerElementType();
       if (!t->isPointerTy()) {
          StructType *st = dyn_cast<StructType>(t);
          std::string tname = getTypeName(t); 
          if (st && tname.find("struct") != std::string::npos) { // excluding unnamed struct types
             state.typeToAddr[t] = result;                         
             llvm::outs() << "mapping bitcast instance of " << tname << " to " << result << " type pointer=" << t << " in " << ki->inst << "\n";
             bool isSingle; int count;
             bool li = isAllocTypeLazyInit(t,isSingle,count);
             if (li && isSingle) {
                //state.lazyInitSingleInstances[t] = mo;
                //llvm::outs() << "storing address " << mo->getBaseExpr() << " as single instance of type " << tname << "\n";
                addSingleOrDerivative(state, result);
                llvm::errs() << "\n recording singleton or derivative " <<  result << "\n";
             }

          }
       }
    } 
   }     
    /* SYSREL EXTENSION */

    break;
  }

    // Floating point instructions

  case Instruction::FAdd: {
    ref<ConstantExpr> left = toConstant(state, eval(ki, 0, state).value,
                                        "floating point");
    ref<ConstantExpr> right = toConstant(state, eval(ki, 1, state).value,
                                         "floating point");
    if (!fpWidthToSemantics(left->getWidth()) ||
        !fpWidthToSemantics(right->getWidth()))
      return terminateStateOnExecError(state, "Unsupported FAdd operation");

    llvm::APFloat Res(*fpWidthToSemantics(left->getWidth()), left->getAPValue());
    Res.add(APFloat(*fpWidthToSemantics(right->getWidth()),right->getAPValue()), APFloat::rmNearestTiesToEven);
    bindLocal(ki, state, ConstantExpr::alloc(Res.bitcastToAPInt()));
    break;
  }

  case Instruction::FSub: {
    ref<ConstantExpr> left = toConstant(state, eval(ki, 0, state).value,
                                        "floating point");
    ref<ConstantExpr> right = toConstant(state, eval(ki, 1, state).value,
                                         "floating point");
    if (!fpWidthToSemantics(left->getWidth()) ||
        !fpWidthToSemantics(right->getWidth()))
      return terminateStateOnExecError(state, "Unsupported FSub operation");
    llvm::APFloat Res(*fpWidthToSemantics(left->getWidth()), left->getAPValue());
    Res.subtract(APFloat(*fpWidthToSemantics(right->getWidth()), right->getAPValue()), APFloat::rmNearestTiesToEven);
    bindLocal(ki, state, ConstantExpr::alloc(Res.bitcastToAPInt()));
    break;
  }

  case Instruction::FMul: {
    ref<ConstantExpr> left = toConstant(state, eval(ki, 0, state).value,
                                        "floating point");
    ref<ConstantExpr> right = toConstant(state, eval(ki, 1, state).value,
                                         "floating point");
    if (!fpWidthToSemantics(left->getWidth()) ||
        !fpWidthToSemantics(right->getWidth()))
      return terminateStateOnExecError(state, "Unsupported FMul operation");

    llvm::APFloat Res(*fpWidthToSemantics(left->getWidth()), left->getAPValue());
    Res.multiply(APFloat(*fpWidthToSemantics(right->getWidth()), right->getAPValue()), APFloat::rmNearestTiesToEven);
    bindLocal(ki, state, ConstantExpr::alloc(Res.bitcastToAPInt()));
    break;
  }

  case Instruction::FDiv: {
    ref<ConstantExpr> left = toConstant(state, eval(ki, 0, state).value,
                                        "floating point");
    ref<ConstantExpr> right = toConstant(state, eval(ki, 1, state).value,
                                         "floating point");
    if (!fpWidthToSemantics(left->getWidth()) ||
        !fpWidthToSemantics(right->getWidth()))
      return terminateStateOnExecError(state, "Unsupported FDiv operation");

    llvm::APFloat Res(*fpWidthToSemantics(left->getWidth()), left->getAPValue());
    Res.divide(APFloat(*fpWidthToSemantics(right->getWidth()), right->getAPValue()), APFloat::rmNearestTiesToEven);
    bindLocal(ki, state, ConstantExpr::alloc(Res.bitcastToAPInt()));
    break;
  }

  case Instruction::FRem: {
    ref<ConstantExpr> left = toConstant(state, eval(ki, 0, state).value,
                                        "floating point");
    ref<ConstantExpr> right = toConstant(state, eval(ki, 1, state).value,
                                         "floating point");
    if (!fpWidthToSemantics(left->getWidth()) ||
        !fpWidthToSemantics(right->getWidth()))
      return terminateStateOnExecError(state, "Unsupported FRem operation");
    llvm::APFloat Res(*fpWidthToSemantics(left->getWidth()), left->getAPValue());
#if LLVM_VERSION_CODE >= LLVM_VERSION(3, 8)
    Res.mod(
        APFloat(*fpWidthToSemantics(right->getWidth()), right->getAPValue()));
#else
    Res.mod(APFloat(*fpWidthToSemantics(right->getWidth()),right->getAPValue()),
            APFloat::rmNearestTiesToEven);
#endif
    bindLocal(ki, state, ConstantExpr::alloc(Res.bitcastToAPInt()));
    break;
  }

  case Instruction::FPTrunc: {
    FPTruncInst *fi = cast<FPTruncInst>(i);
    Expr::Width resultType = getWidthForLLVMType(fi->getType());
    ref<ConstantExpr> arg = toConstant(state, eval(ki, 0, state).value,
                                       "floating point");
    if (!fpWidthToSemantics(arg->getWidth()) || resultType > arg->getWidth())
      return terminateStateOnExecError(state, "Unsupported FPTrunc operation");

    llvm::APFloat Res(*fpWidthToSemantics(arg->getWidth()), arg->getAPValue());
    bool losesInfo = false;
    Res.convert(*fpWidthToSemantics(resultType),
                llvm::APFloat::rmNearestTiesToEven,
                &losesInfo);
    bindLocal(ki, state, ConstantExpr::alloc(Res));
    break;
  }

  case Instruction::FPExt: {
    FPExtInst *fi = cast<FPExtInst>(i);
    Expr::Width resultType = getWidthForLLVMType(fi->getType());
    ref<ConstantExpr> arg = toConstant(state, eval(ki, 0, state).value,
                                        "floating point");
    if (!fpWidthToSemantics(arg->getWidth()) || arg->getWidth() > resultType)
      return terminateStateOnExecError(state, "Unsupported FPExt operation");
    llvm::APFloat Res(*fpWidthToSemantics(arg->getWidth()), arg->getAPValue());
    bool losesInfo = false;
    Res.convert(*fpWidthToSemantics(resultType),
                llvm::APFloat::rmNearestTiesToEven,
                &losesInfo);
    bindLocal(ki, state, ConstantExpr::alloc(Res));
    break;
  }

  case Instruction::FPToUI: {
    FPToUIInst *fi = cast<FPToUIInst>(i);
    Expr::Width resultType = getWidthForLLVMType(fi->getType());
    ref<ConstantExpr> arg = toConstant(state, eval(ki, 0, state).value,
                                       "floating point");
    if (!fpWidthToSemantics(arg->getWidth()) || resultType > 64)
      return terminateStateOnExecError(state, "Unsupported FPToUI operation");

    llvm::APFloat Arg(*fpWidthToSemantics(arg->getWidth()), arg->getAPValue());
    uint64_t value = 0;
    bool isExact = true;
    Arg.convertToInteger(&value, resultType, false,
                         llvm::APFloat::rmTowardZero, &isExact);
    bindLocal(ki, state, ConstantExpr::alloc(value, resultType));
    break;
  }

  case Instruction::FPToSI: {
    FPToSIInst *fi = cast<FPToSIInst>(i);
    Expr::Width resultType = getWidthForLLVMType(fi->getType());
    ref<ConstantExpr> arg = toConstant(state, eval(ki, 0, state).value,
                                       "floating point");
    if (!fpWidthToSemantics(arg->getWidth()) || resultType > 64)
      return terminateStateOnExecError(state, "Unsupported FPToSI operation");
    llvm::APFloat Arg(*fpWidthToSemantics(arg->getWidth()), arg->getAPValue());

    uint64_t value = 0;
    bool isExact = true;
    Arg.convertToInteger(&value, resultType, true,
                         llvm::APFloat::rmTowardZero, &isExact);
    bindLocal(ki, state, ConstantExpr::alloc(value, resultType));
    break;
  }

  case Instruction::UIToFP: {
    UIToFPInst *fi = cast<UIToFPInst>(i);
    Expr::Width resultType = getWidthForLLVMType(fi->getType());
    ref<ConstantExpr> arg = toConstant(state, eval(ki, 0, state).value,
                                       "floating point");
    const llvm::fltSemantics *semantics = fpWidthToSemantics(resultType);
    if (!semantics)
      return terminateStateOnExecError(state, "Unsupported UIToFP operation");
    llvm::APFloat f(*semantics, 0);
    f.convertFromAPInt(arg->getAPValue(), false,
                       llvm::APFloat::rmNearestTiesToEven);

    bindLocal(ki, state, ConstantExpr::alloc(f));
    break;
  }

  case Instruction::SIToFP: {
    SIToFPInst *fi = cast<SIToFPInst>(i);
    Expr::Width resultType = getWidthForLLVMType(fi->getType());
    ref<ConstantExpr> arg = toConstant(state, eval(ki, 0, state).value,
                                       "floating point");
    const llvm::fltSemantics *semantics = fpWidthToSemantics(resultType);
    if (!semantics)
      return terminateStateOnExecError(state, "Unsupported SIToFP operation");
    llvm::APFloat f(*semantics, 0);
    f.convertFromAPInt(arg->getAPValue(), true,
                       llvm::APFloat::rmNearestTiesToEven);

    bindLocal(ki, state, ConstantExpr::alloc(f));
    break;
  }

  case Instruction::FCmp: {
    FCmpInst *fi = cast<FCmpInst>(i);
    ref<ConstantExpr> left = toConstant(state, eval(ki, 0, state).value,
                                        "floating point");
    ref<ConstantExpr> right = toConstant(state, eval(ki, 1, state).value,
                                         "floating point");
    if (!fpWidthToSemantics(left->getWidth()) ||
        !fpWidthToSemantics(right->getWidth()))
      return terminateStateOnExecError(state, "Unsupported FCmp operation");

    APFloat LHS(*fpWidthToSemantics(left->getWidth()),left->getAPValue());
    APFloat RHS(*fpWidthToSemantics(right->getWidth()),right->getAPValue());
    APFloat::cmpResult CmpRes = LHS.compare(RHS);

    bool Result = false;
    switch( fi->getPredicate() ) {
      // Predicates which only care about whether or not the operands are NaNs.
    case FCmpInst::FCMP_ORD:
      Result = (CmpRes != APFloat::cmpUnordered);
      break;

    case FCmpInst::FCMP_UNO:
      Result = (CmpRes == APFloat::cmpUnordered);
      break;

      // Ordered comparisons return false if either operand is NaN.  Unordered
      // comparisons return true if either operand is NaN.
    case FCmpInst::FCMP_UEQ:
      Result = (CmpRes == APFloat::cmpUnordered || CmpRes == APFloat::cmpEqual);
      break;
    case FCmpInst::FCMP_OEQ:
      Result = (CmpRes != APFloat::cmpUnordered && CmpRes == APFloat::cmpEqual);
      break;

    case FCmpInst::FCMP_UGT:
      Result = (CmpRes == APFloat::cmpUnordered || CmpRes == APFloat::cmpGreaterThan);
      break;
    case FCmpInst::FCMP_OGT:
      Result = (CmpRes != APFloat::cmpUnordered && CmpRes == APFloat::cmpGreaterThan);
      break;

    case FCmpInst::FCMP_UGE:
      Result = (CmpRes == APFloat::cmpUnordered || (CmpRes == APFloat::cmpGreaterThan || CmpRes == APFloat::cmpEqual));
      break;
    case FCmpInst::FCMP_OGE:
      Result = (CmpRes != APFloat::cmpUnordered && (CmpRes == APFloat::cmpGreaterThan || CmpRes == APFloat::cmpEqual));
      break;

    case FCmpInst::FCMP_ULT:
      Result = (CmpRes == APFloat::cmpUnordered || CmpRes == APFloat::cmpLessThan);
      break;
    case FCmpInst::FCMP_OLT:
      Result = (CmpRes != APFloat::cmpUnordered && CmpRes == APFloat::cmpLessThan);
      break;

    case FCmpInst::FCMP_ULE:
      Result = (CmpRes == APFloat::cmpUnordered || (CmpRes == APFloat::cmpLessThan || CmpRes == APFloat::cmpEqual));
      break;
    case FCmpInst::FCMP_OLE:
      Result = (CmpRes != APFloat::cmpUnordered && (CmpRes == APFloat::cmpLessThan || CmpRes == APFloat::cmpEqual));
      break;

    case FCmpInst::FCMP_UNE:
      Result = (CmpRes == APFloat::cmpUnordered || CmpRes != APFloat::cmpEqual);
      break;
    case FCmpInst::FCMP_ONE:
      Result = (CmpRes != APFloat::cmpUnordered && CmpRes != APFloat::cmpEqual);
      break;

    default:
      assert(0 && "Invalid FCMP predicate!");
      break;
    case FCmpInst::FCMP_FALSE:
      Result = false;
      break;
    case FCmpInst::FCMP_TRUE:
      Result = true;
      break;
    }

    bindLocal(ki, state, ConstantExpr::alloc(Result, Expr::Bool));
    break;
  }
  case Instruction::InsertValue: {
    KGEPInstruction *kgepi = static_cast<KGEPInstruction*>(ki);

    ref<Expr> agg = eval(ki, 0, state).value;
    ref<Expr> val = eval(ki, 1, state).value;

    ref<Expr> l = NULL, r = NULL;
    unsigned lOffset = kgepi->offset*8, rOffset = kgepi->offset*8 + val->getWidth();

    if (lOffset > 0)
      l = ExtractExpr::create(agg, 0, lOffset);
    if (rOffset < agg->getWidth())
      r = ExtractExpr::create(agg, rOffset, agg->getWidth() - rOffset);

    ref<Expr> result;
    if (!l.isNull() && !r.isNull())
      result = ConcatExpr::create(r, ConcatExpr::create(val, l));
    else if (!l.isNull())
      result = ConcatExpr::create(val, l);
    else if (!r.isNull())
      result = ConcatExpr::create(r, val);
    else
      result = val;

    bindLocal(ki, state, result);
    break;
  }
  case Instruction::ExtractValue: {
    KGEPInstruction *kgepi = static_cast<KGEPInstruction*>(ki);

    ref<Expr> agg = eval(ki, 0, state).value;

    ref<Expr> result = ExtractExpr::create(agg, kgepi->offset*8, getWidthForLLVMType(i->getType()));

    bindLocal(ki, state, result);
    break;
  }
  case Instruction::Fence: {
    // Ignore for now
    break;
  }
  case Instruction::InsertElement: {
    InsertElementInst *iei = cast<InsertElementInst>(i);
    ref<Expr> vec = eval(ki, 0, state).value;
    ref<Expr> newElt = eval(ki, 1, state).value;
    ref<Expr> idx = eval(ki, 2, state).value;

    ConstantExpr *cIdx = dyn_cast<ConstantExpr>(idx);
    if (cIdx == NULL) {
      terminateStateOnError(
          state, "InsertElement, support for symbolic index not implemented",
          Unhandled);
      return;
    }
    uint64_t iIdx = cIdx->getZExtValue();
    const llvm::VectorType *vt = iei->getType();
    unsigned EltBits = getWidthForLLVMType(vt->getElementType());

    if (iIdx >= vt->getNumElements()) {
      // Out of bounds write
      terminateStateOnError(state, "Out of bounds write when inserting element",
                            BadVectorAccess);
      return;
    }

    const unsigned elementCount = vt->getNumElements();
    llvm::SmallVector<ref<Expr>, 8> elems;
    elems.reserve(elementCount);
    for (unsigned i = elementCount; i != 0; --i) {
      auto of = i - 1;
      unsigned bitOffset = EltBits * of;
      elems.push_back(
          of == iIdx ? newElt : ExtractExpr::create(vec, bitOffset, EltBits));
    }

    assert(Context::get().isLittleEndian() && "FIXME:Broken for big endian");
    ref<Expr> Result = ConcatExpr::createN(elementCount, elems.data());
    bindLocal(ki, state, Result);
    break;
  }
  case Instruction::ExtractElement: {
    ExtractElementInst *eei = cast<ExtractElementInst>(i);
    ref<Expr> vec = eval(ki, 0, state).value;
    ref<Expr> idx = eval(ki, 1, state).value;

    ConstantExpr *cIdx = dyn_cast<ConstantExpr>(idx);
    if (cIdx == NULL) {
      terminateStateOnError(
          state, "ExtractElement, support for symbolic index not implemented",
          Unhandled);
      return;
    }
    uint64_t iIdx = cIdx->getZExtValue();
    const llvm::VectorType *vt = eei->getVectorOperandType();
    unsigned EltBits = getWidthForLLVMType(vt->getElementType());

    if (iIdx >= vt->getNumElements()) {
      // Out of bounds read
      terminateStateOnError(state, "Out of bounds read when extracting element",
                            BadVectorAccess);
      return;
    }

    unsigned bitOffset = EltBits * iIdx;
    ref<Expr> Result = ExtractExpr::create(vec, bitOffset, EltBits);
    bindLocal(ki, state, Result);
    break;
  }
  case Instruction::ShuffleVector:
    // Should never happen due to Scalarizer pass removing ShuffleVector
    // instructions.
    terminateStateOnExecError(state, "Unexpected ShuffleVector instruction");
    break;
  // Other instructions...
  // Unhandled
  default:
    terminateStateOnExecError(state, "illegal instruction");
    break;
  }
}

void Executor::updateStates(ExecutionState *current) {
  if (searcher) {
    searcher->update(current, addedStates, removedStates);
    searcher->update(nullptr, continuedStates, pausedStates);
    pausedStates.clear();
    continuedStates.clear();
  }
  
  states.insert(addedStates.begin(), addedStates.end());
  addedStates.clear();

  for (std::vector<ExecutionState *>::iterator it = removedStates.begin(),
                                               ie = removedStates.end();
       it != ie; ++it) {
    ExecutionState *es = *it;
    std::set<ExecutionState*>::iterator it2 = states.find(es);
    assert(it2!=states.end());
    states.erase(it2);
    std::map<ExecutionState*, std::vector<SeedInfo> >::iterator it3 = 
      seedMap.find(es);
    if (it3 != seedMap.end())
      seedMap.erase(it3);
    processTree->remove(es->ptreeNode);
    delete es;
  }
  removedStates.clear();
}

template <typename TypeIt>
void Executor::computeOffsets(KGEPInstruction *kgepi, TypeIt ib, TypeIt ie) {
  ref<ConstantExpr> constantOffset =
    ConstantExpr::alloc(0, Context::get().getPointerWidth());
  uint64_t index = 1;
  //llvm::errs() << "gep: " << (*kgepi->inst) << "\n";
  for (TypeIt ii = ib; ii != ie; ++ii) {
    if (StructType *st = dyn_cast<StructType>(*ii)) {
      //llvm::errs() << "gep offset for type " << getTypeName(st) << "\n";
      const StructLayout *sl = kmodule->targetData->getStructLayout(st);
      const ConstantInt *ci = cast<ConstantInt>(ii.getOperand());
      //llvm::errs() << "index: " << ci->getZExtValue() << "\n";
      uint64_t addend = sl->getElementOffset((unsigned) ci->getZExtValue());
      //llvm:errs() << "addend " << addend << " for gep " << (*kgepi->inst) << "\n";
      constantOffset = constantOffset->Add(ConstantExpr::alloc(addend,
                                                               Context::get().getPointerWidth()));
      //llvm::errs() << "current value of offset : " << constantOffset << "\n";
    } else {
      const SequentialType *set = cast<SequentialType>(*ii);
      uint64_t elementSize = 
        kmodule->targetData->getTypeStoreSize(set->getElementType());
      Value *operand = ii.getOperand();
      if (Constant *c = dyn_cast<Constant>(operand)) {
        ref<ConstantExpr> index = 
          evalConstant(c)->SExt(Context::get().getPointerWidth());
        ref<ConstantExpr> addend = 
          index->Mul(ConstantExpr::alloc(elementSize,
                                         Context::get().getPointerWidth()));
        constantOffset = constantOffset->Add(addend);
      } else {
        kgepi->indices.push_back(std::make_pair(index, elementSize));
      }
    }
    index++;
  }
  kgepi->offset = constantOffset->getZExtValue();
  //llvm::errs() << "computed gep offset: " << kgepi->offset << "\n";
}

void Executor::bindInstructionConstants(KInstruction *KI) {
  KGEPInstruction *kgepi = static_cast<KGEPInstruction*>(KI);

  if (GetElementPtrInst *gepi = dyn_cast<GetElementPtrInst>(KI->inst)) {
    computeOffsets(kgepi, gep_type_begin(gepi), gep_type_end(gepi));
  } else if (InsertValueInst *ivi = dyn_cast<InsertValueInst>(KI->inst)) {
    computeOffsets(kgepi, iv_type_begin(ivi), iv_type_end(ivi));
    assert(kgepi->indices.empty() && "InsertValue constant offset expected");
  } else if (ExtractValueInst *evi = dyn_cast<ExtractValueInst>(KI->inst)) {
    computeOffsets(kgepi, ev_type_begin(evi), ev_type_end(evi));
    assert(kgepi->indices.empty() && "ExtractValue constant offset expected");
  }
}

void Executor::bindModuleConstants() {
  for (std::vector<KFunction*>::iterator it = kmodule->functions.begin(), 
         ie = kmodule->functions.end(); it != ie; ++it) {
    KFunction *kf = *it;
    for (unsigned i=0; i<kf->numInstructions; ++i)
      bindInstructionConstants(kf->instructions[i]);
  }

  kmodule->constantTable = new Cell[kmodule->constants.size()];
  for (unsigned i=0; i<kmodule->constants.size(); ++i) {
    Cell &c = kmodule->constantTable[i];
    c.value = evalConstant(kmodule->constants[i]);
  }
}

void Executor::checkMemoryUsage() {
  if (!MaxMemory)
    return;
  if ((stats::instructions & 0xFFFF) == 0) {
    // We need to avoid calling GetTotalMallocUsage() often because it
    // is O(elts on freelist). This is really bad since we start
    // to pummel the freelist once we hit the memory cap.
    unsigned mbs = (util::GetTotalMallocUsage() >> 20) +
                   (memory->getUsedDeterministicSize() >> 20);

    if (mbs > MaxMemory) {
      if (mbs > MaxMemory + 100) {
        // just guess at how many to kill
        unsigned numStates = states.size();
        unsigned toKill = std::max(1U, numStates - numStates * MaxMemory / mbs);
        klee_warning("killing %d states (over memory cap)", toKill);
        std::vector<ExecutionState *> arr(states.begin(), states.end());
        for (unsigned i = 0, N = arr.size(); N && i < toKill; ++i, --N) {
          unsigned idx = rand() % N;
          // Make two pulls to try and not hit a state that
          // covered new code.
          if (arr[idx]->coveredNew)
            idx = rand() % N;

          std::swap(arr[idx], arr[N - 1]);
          terminateStateEarly(*arr[N - 1], "Memory limit exceeded.");
        }
      }
      atMemoryLimit = true;
    } else {
      atMemoryLimit = false;
    }
  }
}

void Executor::doDumpStates() {

  if (dontcareStats)
        dontcareStats->close();

  if (InferDataConstraints)
     printInferences();

  if (!DumpStatesOnHalt || states.empty()) {
     if (ReportMetadataChecksOnExit) 
        performMetadataChecks();
    return;
  }

  klee_message("halting execution, dumping remaining states");
  for (const auto &state : states) {
    checkMetadataOnCondition(*state); 
    terminateStateEarly(*state, "Execution halting.");
  }
  updateStates(nullptr);
  if (ReportMetadataChecksOnExit) 
     performMetadataChecks();

}

Function *checkAndGetFunction(std::string fstr, Module *module) {
     Function *f = module->getFunction(fstr);
     if (f) return f;
     std::set<std::string> cs;
     for(auto &f: (*module)) {
         std::string fname = f.getName();
         if (fname.find(fstr) != std::string::npos) {
            cs.insert(fname);
         }              
     }
     llvm::errs() << "Candidate functions that include " << fstr << ":\n";
     for(auto fs : cs)
        llvm::errs() << fs << " ";
     llvm::errs() << "\n";
     if (cs.size() > 1) {
        llvm::errs() << "Multiple candidate functions for reachable states function!\n";
        exit(1);
     }
     else if (cs.size() == 0) {
        llvm::errs() << "No candidate functions!\n";
        exit(1);
     }
     for(auto fs : cs) {
        llvm::errs() << "Using " << fs << " for " << fstr << " as the reachable state function\n"; 
        return module->getFunction(fs); 
     }
}

void Executor::computeDontCareTransitions(int argc,
                                 char **argv,
                                 char **envp) {
  if (DontCareTransitionMode && ReachableStatesStepFunction != "" && 
      ApproximateReachableStatesStepFunction != "") {
     dontCareStartTime = util::getWallTime();
     Function *rsfunction = checkAndGetFunction(ReachableStatesStepFunction, 
                                                kmodule->module);
     Function *arsfunction = checkAndGetFunction(ApproximateReachableStatesStepFunction, 
                                                kmodule->module);
     runFunctionAsMain(rsfunction, argc, argv, envp);
     runFunctionAsMain(arsfunction, argc, argv, envp);
     if (dontcareStats)
        dontcareStats->close();
  }
}

void Executor::run(ExecutionState &initialState) {

  bindModuleConstants();

  // Delay init till now so that ticks don't accrue during
  // optimization and such.
  initTimers();

  states.insert(&initialState);

  if (usingSeeds) {
    std::vector<SeedInfo> &v = seedMap[&initialState];
    
    for (std::vector<KTest*>::const_iterator it = usingSeeds->begin(), 
           ie = usingSeeds->end(); it != ie; ++it)
      v.push_back(SeedInfo(*it));

    int lastNumSeeds = usingSeeds->size()+10;
    double lastTime, startTime = lastTime = util::getWallTime();
    ExecutionState *lastState = 0;
    while (!seedMap.empty()) {
      if (haltExecution) {
        doDumpStates();
        return;
      }

      std::map<ExecutionState*, std::vector<SeedInfo> >::iterator it = 
        seedMap.upper_bound(lastState);
      if (it == seedMap.end())
        it = seedMap.begin();
      lastState = it->first;
      unsigned numSeeds = it->second.size();
      ExecutionState &state = *lastState;
      KInstruction *ki = state.pc;
      stepInstruction(state);
      /* SYSREL extension */
      singleSuccessor = true;
      successorsPaths->erase(successorsPaths->begin(), successorsPaths->end());
      /* SYSREL extension */
      executeInstruction(state, ki);
      /* SYSREL extension */
      if (RecordValueFlow)
         generateValuedInstruction(state, ki);
      // First check if any programming model related action to be executed
      if (singleSuccessor) {
         bool abort = false;
         ref<Expr> offendingAddress = Expr::createPointer(0);
         state.executePM(abort, offendingAddress);
         if (abort) {
	   terminateStateOnError(state, "Memory error", Ptr, NULL, getAddressInfo(state, offendingAddress));
         }
      }
      /* SYSREL extension */  
      processTimers(&state, MaxInstructionTime * numSeeds);
      updateStates(&state);

      if ((stats::instructions % 1000) == 0) {
        int numSeeds = 0, numStates = 0;
        for (std::map<ExecutionState*, std::vector<SeedInfo> >::iterator
               it = seedMap.begin(), ie = seedMap.end();
             it != ie; ++it) {
          numSeeds += it->second.size();
          numStates++;
        }
        double time = util::getWallTime();
        if (SeedTime>0. && time > startTime + SeedTime) {
          klee_warning("seed time expired, %d seeds remain over %d states",
                       numSeeds, numStates);
          break;
        } else if (numSeeds<=lastNumSeeds-10 ||
                   time >= lastTime+10) {
          lastTime = time;
          lastNumSeeds = numSeeds;          
          klee_message("%d seeds remaining over: %d states", 
                       numSeeds, numStates);
        }
      }
    }

    klee_message("seeding done (%d states remain)", (int) states.size());

    // XXX total hack, just because I like non uniform better but want
    // seed results to be equally weighted.
    for (std::set<ExecutionState*>::iterator
           it = states.begin(), ie = states.end();
         it != ie; ++it) {
      (*it)->weight = 1.;
    }

    if (OnlySeed) {
      doDumpStates();
      return;
    }
  }

  searcher = constructUserSearcher(*this);

  std::vector<ExecutionState *> newStates(states.begin(), states.end());
  searcher->update(0, newStates, std::vector<ExecutionState *>());

  while (!states.empty() && !haltExecution) {
    ExecutionState &state = searcher->selectState();
    successorsPaths->erase(successorsPaths->begin(), successorsPaths->end());
    successorsPaths->insert(&state);
    /* SYSREL */
    // Schedule async function if applicable 
    llvm::outs() << "Number of states=" << states.size() << "\n";
    if (asyncMode) { 
    int tid = -1;
    if ((tid = state.scheduleAsync(memory)) >= 0) {
       llvm::outs() << "scheduling thread " << tid << "\n"; 
       KInstruction *kia = state.threads[tid].pc;
       stepInstructionThread(state, tid);
       llvm::outs() << "after step instruction for thread " << tid << "..\n";
       kia->inst->dump();      
       executeInstructionThread(state, kia, tid);
       if (RecordValueFlow) 
          generateValuedInstruction(state, kia);
       llvm::outs() << "after execute instruction for thread " << tid << "..\n";
       processTimers(&state, MaxInstructionTime);
       checkMemoryUsage();       
       updateStates(&state);       
    }
    else {
      if (!state.getWaitingForThreadsToTerminate()) {
       llvm::outs() << "scheduling main thread\n"; 
       KInstruction *ki = state.pc;
       stepInstruction(state);
       llvm::outs() << "after step instruction for the main thread\n"; 
       ki->inst->dump(); 
       /* SYSREL extension */
       singleSuccessor = true;
       /* SYSREL extension */
       llvm::errs() << "\nnext instruction: " << (*ki->inst) << "\n";
       ExprPPrinter::printConstraints(llvm::errs(), state.constraints);
       executeInstruction(state, ki);
       /* SYSREL extension */
       if (RecordValueFlow)
          generateValuedInstruction(state, ki); 
       // First check if any programming model related action to be executed
       if (singleSuccessor) {
           bool abort = false;
           ref<Expr> offendingAddress = Expr::createPointer(0);
           state.executePM(abort, offendingAddress);
           if (abort) {
	     terminateStateOnError(state, "Memory error", Ptr, NULL, getAddressInfo(state, offendingAddress));
          }     
       }
       /* SYSREL extension */  
       llvm::outs() << "after execute instruction for the main thread\n";   
       processTimers(&state, MaxInstructionTime);

       checkMemoryUsage();
       updateStates(&state);
     }
     else {
        llvm::outs() << "terminating main thread\n";
        terminateStateOnExit(state);
        updateStates(&state);
     }
    }
    }
    else {
    /* SYSREL */
      KInstruction *ki = state.pc;
      stepInstruction(state);
      singleSuccessor = true;
      llvm::errs() << "\nnext instruction: " << (*ki->inst) << "\n";
      ExprPPrinter::printConstraints(llvm::errs(), state.constraints);
      executeInstruction(state, ki);
      if (RecordValueFlow)
         generateValuedInstruction(state, ki);
      /* SYSREL extension */
      // First check if any programming model related action to be executed
      if (singleSuccessor) {
         bool abort = false;
         ref<Expr> offendingAddress = Expr::createPointer(0); 
         state.executePM(abort, offendingAddress);
         if (abort) {
	   terminateStateOnError(state, "Memory error", Ptr, NULL, getAddressInfo(state, offendingAddress));
         }
      }
      /* SYSREL extension */  
      processTimers(&state, MaxInstructionTime);
      checkMemoryUsage();
      updateStates(&state);
   }
  }

  delete searcher;
  searcher = 0;

	
  doDumpStates();
}

std::string Executor::getAddressInfo(ExecutionState &state, 
                                     ref<Expr> address) const{
  std::string Str;
  llvm::raw_string_ostream info(Str);
  info << "\taddress: " << address << "\n";
  uint64_t example;
  if (ConstantExpr *CE = dyn_cast<ConstantExpr>(address)) {
    example = CE->getZExtValue();
  } else {
    ref<ConstantExpr> value;
    bool success = solver->getValue(state, address, value);
    assert(success && "FIXME: Unhandled solver failure");
    (void) success;
    example = value->getZExtValue();
    info << "\texample: " << example << "\n";
    std::pair< ref<Expr>, ref<Expr> > res = solver->getRange(state, address);
    info << "\trange: [" << res.first << ", " << res.second <<"]\n";
  }
  
  MemoryObject hack((unsigned) example);    
  MemoryMap::iterator lower = state.addressSpace.objects.upper_bound(&hack);
  info << "\tnext: ";
  if (lower==state.addressSpace.objects.end()) {
    info << "none\n";
  } else {
    const MemoryObject *mo = lower->first;
    std::string alloc_info;
    mo->getAllocInfo(alloc_info);
    info << "object at " << mo->address
         << " of size " << mo->size << "\n"
         << "\t\t" << alloc_info << "\n";
  }
  if (lower!=state.addressSpace.objects.begin()) {
    --lower;
    info << "\tprev: ";
    if (lower==state.addressSpace.objects.end()) {
      info << "none\n";
    } else {
      const MemoryObject *mo = lower->first;
      std::string alloc_info;
      mo->getAllocInfo(alloc_info);
      info << "object at " << mo->address 
           << " of size " << mo->size << "\n"
           << "\t\t" << alloc_info << "\n";
    }
  }

  return info.str();
}

void Executor::pauseState(ExecutionState &state){
  auto it = std::find(continuedStates.begin(), continuedStates.end(), &state);
  // If the state was to be continued, but now gets paused again
  if (it != continuedStates.end()){
    // ...just don't continue it
    std::swap(*it, continuedStates.back());
    continuedStates.pop_back();
  } else {
    pausedStates.push_back(&state);
  }
}

void Executor::continueState(ExecutionState &state){
  auto it = std::find(pausedStates.begin(), pausedStates.end(), &state);
  // If the state was to be paused, but now gets continued again
  if (it != pausedStates.end()){
    // ...don't pause it
    std::swap(*it, pausedStates.back());
    pausedStates.pop_back();
  } else {
    continuedStates.push_back(&state);
  }
}

void Executor::terminateState(ExecutionState &state) {
  /* SYSREL extension */
  llvm::errs() << "Checking the state at the end of path\n"; 
  state.check();
  /* SYSREL extension */


  if (replayKTest && replayPosition!=replayKTest->numObjects) {
    klee_warning_once(replayKTest,
                      "replay did not consume all objects in test input.");
  }

  interpreterHandler->incPathsExplored();

  std::vector<ExecutionState *>::iterator it =
      std::find(addedStates.begin(), addedStates.end(), &state);
  if (it==addedStates.end()) {
    state.pc = state.prevPC;

    removedStates.push_back(&state);
  } else {
    // never reached searcher, just delete immediately
    std::map< ExecutionState*, std::vector<SeedInfo> >::iterator it3 = 
      seedMap.find(&state);
    if (it3 != seedMap.end())
      seedMap.erase(it3);
    addedStates.erase(it);
    processTree->remove(state.ptreeNode);
    delete &state;
  }
}

void Executor::terminateStateEarly(ExecutionState &state, 
                                   const Twine &message) {

  if (!OnlyOutputStatesCoveringNew || state.coveredNew ||
      (AlwaysOutputSeeds && seedMap.count(&state))) {
    if (recordStackTraces) {
       std::string straces = getLongestStackTraces(state, stackTraceCount);
       std::string mes = straces + (message + "\n").str();
       interpreterHandler->processTestCase(state, mes.c_str(),
                                        "early");
    }
    else interpreterHandler->processTestCase(state, (message + "\n").str().c_str(),
                                        "early");
  }
  terminateState(state);
}

void Executor::terminateStateOnExit(ExecutionState &state) {
  if (!OnlyOutputStatesCoveringNew || state.coveredNew || 
      (AlwaysOutputSeeds && seedMap.count(&state))) {
     if (recordStackTraces) {
        std::string straces = getLongestStackTraces(state, stackTraceCount);
        interpreterHandler->processTestCase(state, straces.c_str(), "normalTerm");
     }
     else interpreterHandler->processTestCase(state, 0, 0);
  }
  terminateState(state);
}

const InstructionInfo & Executor::getLastNonKleeInternalInstruction(const ExecutionState &state,
    Instruction ** lastInstruction) {
  // unroll the stack of the applications state and find
  // the last instruction which is not inside a KLEE internal function
  ExecutionState::stack_ty::const_reverse_iterator it = state.stack.rbegin(),
      itE = state.stack.rend();

  // don't check beyond the outermost function (i.e. main())
  itE--;

  const InstructionInfo * ii = 0;
  if (kmodule->internalFunctions.count(it->kf->function) == 0){
    ii =  state.prevPC->info;
    *lastInstruction = state.prevPC->inst;
    //  Cannot return yet because even though
    //  it->function is not an internal function it might of
    //  been called from an internal function.
  }

  // Wind up the stack and check if we are in a KLEE internal function.
  // We visit the entire stack because we want to return a CallInstruction
  // that was not reached via any KLEE internal functions.
  for (;it != itE; ++it) {
    // check calling instruction and if it is contained in a KLEE internal function
    const Function * f = (*it->caller).inst->getParent()->getParent();
    if (kmodule->internalFunctions.count(f)){
      ii = 0;
      continue;
    }
    if (!ii){
      ii = (*it->caller).info;
      *lastInstruction = (*it->caller).inst;
    }
  }

  if (!ii) {
    // something went wrong, play safe and return the current instruction info
    *lastInstruction = state.prevPC->inst;
    return *state.prevPC->info;
  }
  return *ii;
}

bool Executor::shouldExitOn(enum TerminateReason termReason) {
  std::vector<TerminateReason>::iterator s = ExitOnErrorType.begin();
  std::vector<TerminateReason>::iterator e = ExitOnErrorType.end();

  for (; s != e; ++s)
    if (termReason == *s)
      return true;

  return false;
}

void Executor::terminateStateOnError(ExecutionState &state,
                                     const llvm::Twine &messaget,
                                     enum TerminateReason termReason,
                                     const char *suffix,
                                     const llvm::Twine &info) {
  std::string message = messaget.str();
  static std::set< std::pair<Instruction*, std::string> > emittedErrors;
  static std::set< std::tuple<Instruction*, std::string, int> > emittedErrorsAlt;
  Instruction * lastInst;
  const InstructionInfo &ii = getLastNonKleeInternalInstruction(state, &lastInst);

  /* SYSREL extension */
  llvm::errs() << "Error instruction " << lastInst << " content " << (*lastInst) << "\n";
  /* SYSREL extension */

  
  // DEBUG
  if (info.str() != "")
     llvm::outs() << "Info: \n" << info.str() << "\n";
  else llvm::outs() << "No info\n"; 
  // END DEBUG


  if (EmitAllErrors || (state.hasLCM() ? emittedErrorsAlt.insert(std::make_tuple(lastInst, message, state.getLCMState())).second : 
      emittedErrors.insert(std::make_pair(lastInst, message)).second)) {
    if (ii.file != "") {
      klee_message("ERROR: %s:%d: %s", ii.file.c_str(), ii.line, message.c_str());
    } else {
      klee_message("ERROR: (location information missing) %s", message.c_str());
    }
    if (!EmitAllErrors)
      klee_message("NOTE: now ignoring this error at this location");

    std::string MsgString;
    llvm::raw_string_ostream msg(MsgString);
    msg << "Error: " << message << "\n";
    if (ii.file != "") {
      msg << "File: " << ii.file << "\n";
      msg << "Line: " << ii.line << "\n";
      msg << "assembly.ll line: " << ii.assemblyLine << "\n";
    }
    msg << "Stack: \n";
    state.dumpStack(msg);

    std::string info_str = info.str();
    if (info_str != "")
      msg << "Info: \n" << info_str;

    std::string suffix_buf;
    if (!suffix) {
      suffix_buf = TerminateReasonNames[termReason];
      suffix_buf += ".err";
      suffix = suffix_buf.c_str();
    }
    
    /* SYSREL extension */
    llvm::errs() << "processing test case in error state termination\n"; 
    /* SYSREL extension */
   
    interpreterHandler->processTestCase(state, msg.str().c_str(), suffix);
  }
  else {
        /* SYSREL extension */
    llvm::errs() << "error seen before\n"; 
    /* SYSREL extension */
  }
    
  terminateState(state);

  if (shouldExitOn(termReason))
    haltExecution = true;

  llvm::outs() << "Execution halting? " << haltExecution << "\n";
}

// XXX shoot me
static const char *okExternalsList[] = { "printf", 
                                         "fprintf", 
                                         "puts",
                                         "getpid" };
static std::set<std::string> okExternals(okExternalsList,
                                         okExternalsList + 
                                         (sizeof(okExternalsList)/sizeof(okExternalsList[0])));

void Executor::callExternalFunction(ExecutionState &state,
                                    KInstruction *target,
                                    Function *function,
                                    std::vector< ref<Expr> > &arguments) {
  // check if specialFunctionHandler wants it
  if (specialFunctionHandler->handle(state, function, target, arguments))
    return;
  
  if (NoExternals && !okExternals.count(function->getName())) {
    klee_warning("Disallowed call to external function: %s\n",
               function->getName().str().c_str());
    terminateStateOnError(state, "externals disallowed", User);
    return;
  }

  // normal external function handling path
  // allocate 128 bits for each argument (+return value) to support fp80's;
  // we could iterate through all the arguments first and determine the exact
  // size we need, but this is faster, and the memory usage isn't significant.
  uint64_t *args = (uint64_t*) alloca(2*sizeof(*args) * (arguments.size() + 1));
  memset(args, 0, 2 * sizeof(*args) * (arguments.size() + 1));
  unsigned wordIndex = 2;
  for (std::vector<ref<Expr> >::iterator ai = arguments.begin(), 
       ae = arguments.end(); ai!=ae; ++ai) {
    if (AllowExternalSymCalls) { // don't bother checking uniqueness
      ref<ConstantExpr> ce;
      bool success = solver->getValue(state, *ai, ce);
      assert(success && "FIXME: Unhandled solver failure");
      (void) success;
      ce->toMemory(&args[wordIndex]);
      ObjectPair op;
      // Checking to see if the argument is a pointer to something
      if (ce->getWidth() == Context::get().getPointerWidth() &&
          state.addressSpace.resolveOne(ce, op)) {
        op.second->flushToConcreteStore(solver, state);
      }
      wordIndex += (ce->getWidth()+63)/64;
    } else {
      ref<Expr> arg = toUnique(state, *ai);
      if (ConstantExpr *ce = dyn_cast<ConstantExpr>(arg)) {
        // XXX kick toMemory functions from here
        ce->toMemory(&args[wordIndex]);
        wordIndex += (ce->getWidth()+63)/64;
      } else {
        /* SYSREL EXTENSION */
        if (progModel || lazyInit)
           break;   
        /* SYSREL EXTENSION */
        terminateStateOnExecError(state, 
                                  "external call with symbolic argument: " + 
                                  function->getName());
        
        return;
      }
    }
  }

  // Prepare external memory for invoking the function
  state.addressSpace.copyOutConcretes();
#ifndef WINDOWS
  // Update external errno state with local state value
  int *errno_addr = getErrnoLocation(state);
  ObjectPair result;
  bool resolved = state.addressSpace.resolveOne(
      ConstantExpr::create((uint64_t)errno_addr, Expr::Int64), result);
  if (!resolved)
    klee_error("Could not resolve memory object for errno");
  ref<Expr> errValueExpr = result.second->read(0, sizeof(*errno_addr) * 8);
  ConstantExpr *errnoValue = dyn_cast<ConstantExpr>(errValueExpr);
  if (!errnoValue) {
    terminateStateOnExecError(state,
                              "external call with errno value symbolic: " +
                                  function->getName());
    return;
  }

  externalDispatcher->setLastErrno(
      errnoValue->getZExtValue(sizeof(*errno_addr) * 8));
#endif

  if (!SuppressExternalWarnings) {

    std::string TmpStr;
    llvm::raw_string_ostream os(TmpStr);
    os << "calling external: " << function->getName().str() << "(";
    for (unsigned i=0; i<arguments.size(); i++) {
      os << arguments[i];
      if (i != arguments.size()-1)
        os << ", ";
    }
    os << ") at " << state.pc->getSourceLocation();
    
    if (AllExternalWarnings)
      klee_warning("%s", os.str().c_str());
    else
      klee_warning_once(function, "%s", os.str().c_str());
  }

   /* SYSREL EXTENSION */
  bool success = false;
  if (!APIHandler::handles(removeDotSuffix(function->getName()))) {
     success = externalDispatcher->executeCall(function, target->inst, args);

  llvm::outs() << "external dispatcher result for " << function->getName() << " " << success << "\n";
 } 
 /* SYSREL EXTENSION */

  if (!success) {

    /* SYSREL EXTENSION */


    if (progModel) {

     // check if the function is modeled by another function
     if (functionModeledBy.find(function->getName()) != functionModeledBy.end()) {
        llvm::errs() << "WARNING: Using " << functionModeledBy[function->getName()] 
                        << " for " << function->getName() << "\n";
        Function *modelFn = moduleHandle->getFunction(functionModeledBy[function->getName()]);
        if (modelFn) {
           ((CallInst*)target->inst)->setCalledFunction(modelFn);
           executeCall(state, target, modelFn, arguments);
        }
        else {
           llvm::errs() << "Model function: " << functionModeledBy[function->getName()] << "\n";
           assert(0 && "Model function not defined!");
        }
        return;
     }

      // check if PROSE version of the function exists, if so use that one
      std::string prosename = function->getName().str() + "_PROSE"; 
      Function *proseFn = moduleHandle->getFunction(prosename);
      if (proseFn) {
         llvm::errs() << "WARNING: Using " << prosename << " for " << function->getName() << "\n";
         ((CallInst*)target->inst)->setCalledFunction(proseFn);
         executeCall(state, target, proseFn, arguments);
         return;
      }

       // let the generic API handler handle the arg and return value symbolization
       std::vector<ExecutionState*> successors;
       llvm::errs() << "state=" << &state << " are we handling external function " << function->getName() << "\n";
       for(unsigned a=0; a<arguments.size(); a++)
          llvm::errs() << "arg" << a << "=" << arguments[a] << "\n";         
       bool abort = false; 
       ref<Expr> offendingAddress = Expr::createPointer(0);
       bool resHandled =  APIHandler::handle(state, successors, function->getName(), arguments, target, abort, offendingAddress);
       if (abort) {
	 terminateStateOnError(state, "Memory error", Ptr, NULL, getAddressInfo(state, offendingAddress));
          return;
       }
       bool term = false;
       if (resHandled && APIHandler::isIgnore(function->getName()) && 
                          havocArgs.find(function->getName()) != havocArgs.end()) {
          llvm::errs() << "will havoc the sepcified args for " << function->getName() << "\n";
          // havoc those arguments that are specified
          for(auto ai : havocArgs[function->getName()]) 
             llvm::errs() << "arg " << ai << " in function " << function->getName() 
                          << " will be havoced!\n";
          symbolizeArguments(state, target, function, arguments, term, 
                                      &havocArgs[function->getName()]);
          return;
       } 
       if (!resHandled) {
          llvm::errs() << "symbolizing args and ret  value for function " << function->getName() << "\n";
          symbolizeArguments(state, target, function, arguments, term);
          if (!term) {
             symbolizeReturnValue(state, target, function, abort);
             if (abort) {
                terminateStateOnError(state, "Memory error", Ptr, NULL, "Possible use-after-free");
                return;
             }
          }
       }
       return;
    }
    else {
    /* SYSREL EXTENSION */

    terminateStateOnError(state, "failed external call: " + function->getName(),
                          External);
    return;
    }
  }

  if (!state.addressSpace.copyInConcretes()) {
    terminateStateOnError(state, "external modified read-only object",
                          External);
    return;
  }

#ifndef WINDOWS
  // Update errno memory object with the errno value from the call
  int error = externalDispatcher->getLastErrno();
  state.addressSpace.copyInConcrete(result.first, result.second,
                                    (uint64_t)&error);
#endif

  Type *resultType = target->inst->getType();
  if (resultType != Type::getVoidTy(function->getContext())) {
    ref<Expr> e = ConstantExpr::fromMemory((void*) args, 
                                           getWidthForLLVMType(resultType));
    bindLocal(target, state, e);
  }
}

/* SYSREL extension */

bool Executor::loadPointerArguments(ExecutionState &state, 
                                  KInstruction *target,
                                  Function *function,
				    std::vector< ref<Expr> > &arguments, ref<Expr> &offendingAddress) {
    unsigned int ai = 0;
    for(llvm::Function::arg_iterator agi = function->arg_begin(); agi != function->arg_end(); agi++, ai++) { 
       llvm::outs() << "ext function operand " << ai+1 << " " << target->operands[ai+1] << "\n";
       if (target->operands[ai+1] >= 0) { // a local var
          Type *at = agi->getType();
          if (at->isPointerTy()) {
                ObjectPair op;
                //ref<Expr> base = eval(target, ai+1, state).value;
                ref<Expr> base = arguments[ai];
                bool memoryerror = false;
                if (!executeCheckAddressInBound(state, base, at->getPointerElementType(), memoryerror)) {
		   if (memoryerror) {
  		      offendingAddress = base;  
  		      llvm::errs() << "argument pointer expression " << base << " out of bound!\n";
                      return false;
                   }
		}
	  }
       }
    }
    return true;
}

void Executor::symbolizeArguments(ExecutionState &state, 
                                  KInstruction *target,
                                  Function *function,
                                  std::vector< ref<Expr> > &arguments, 
                                  bool &term,
                                  std::set<unsigned> *args) {
    LLVMContext &ctx = moduleHandle->getContext();
    unsigned int ai = 0;
    for(llvm::Function::arg_iterator agi = function->arg_begin(); agi != function->arg_end(); agi++, ai++) { 
       llvm::errs() << "ext function " << function->getName() << " operand " << ai+1 << " " << target->operands[ai+1] << "\n";
       if (target->operands[ai+1] >= 0) { // a local var
          if (args != NULL && args->find(ai) == args->end()) {
             llvm::errs() << "Skips havocing arg\n";
             continue; // skip arg based on the spec
          }
          Type *at = agi->getType();
          if (at->isPointerTy()) {
             Type *bt = at->getPointerElementType();      
                 std::string type_str;
                 llvm::raw_string_ostream rso(type_str);
                 at->print(rso);
             //if (bt->getPrimitiveSizeInBits()) {
                llvm::errs() << "Type of parameter " << ai << " is " << rso.str() << "\n";
                DataLayout *TD = kmodule->targetData;
                // find the MemoryObject for this value
                ObjectPair op;
                bool asuccess;
                ref<Expr> base = eval(target, ai+1, state).value;
                if (SimplifySymIndices) {
                   if (!isa<ConstantExpr>(base))
                      base = state.constraints.simplifyExpr(base);
                }
                solver->setTimeout(coreSolverTimeout);
                if (!state.addressSpace.resolveOne(state, solver, base, op, asuccess)) {
                   base = toConstant(state, base, "resolveOne failure");
                   asuccess = state.addressSpace.resolveOne(cast<ConstantExpr>(base), op);
                }
                if (asuccess && SkipSingletonHavocing && 
                          isSingleOrDerivative(state, op.first->getBaseExpr())) {
                   std::set<unsigned> ha;
                   if (havocArgs.find(function->getName()) != havocArgs.end())
                      ha = havocArgs[function->getName()];
                   if (ha.find(ai) == ha.end())  {
                      llvm::errs() << "Argument " << ai << " of function " << function->getName() << " is a single or derivative\n";
                      continue;
                   }
                   else llvm::errs() << "Argument " << ai << " of function " 
                                     << function->getName() << " is havoced as directed\n";
                }
                solver->setTimeout(0);             
                if (asuccess) {      
                    size_t allocsize;
                    if (!bt->isSized()) {
                       allocsize =  SIZE_FOR_UNTYPED;
                       bt = Type::getInt8Ty(ctx);
                    }
                    else 
                       allocsize = TD->getTypeAllocSize(bt); 
                   llvm::errs() << "allocation size: " << allocsize << "\n";
                   MemoryObject *sm = memory->allocate(allocsize, op.first->isLocal, 
                           op.first->isGlobal, op.first->allocSite, TD->getPrefTypeAlignment(bt), 
                           1, bt);
                   recordMemObj(state, sm);
                   llvm::errs() << "Symbolizing argument of function " << function->getName() << ", address=" << sm->getBaseExpr() << "\n"; 
                   llvm::errs() << "base addres=" << base << "\n";
                   llvm::errs() << "mo base address=" << op.first->getBaseExpr() << "\n";
                   unsigned id = 0;
                   std::string name = state.getUnique(function->getName().str()) + std::string("_arg_") + std::to_string(ai);
                   std::string uniqueName = name;
                   while (!state.arrayNames.insert(uniqueName).second) {
                       uniqueName = name + "_" + llvm::utostr(++id);
                   }
                   // we're mimicking what executeMemoryOperation do without a relevant load or store instruction
                   const Array *array = arrayCache.CreateArray(uniqueName, sm->size);
                   ObjectState *sos = bindObjectInState(state, sm, true, array);
                   if (!bt->isSized()) { 
                      llvm::errs() << "Skipping symbolizing arg due to unsized type!\n";
                      continue;
                   }
                   ref<Expr> result = sos->read(ConstantExpr::alloc(0, Expr::Int64), getWidthForLLVMType(bt));
                   ObjectState *wos = state.addressSpace.getWriteable(op.first, op.second);
                   // compute offset: base - op.first->getBaseExpr() 
                   ref<Expr> offsetexpr = SubExpr::create(base, op.first->getBaseExpr());
                   //llvm::errs() << allocsize << " vs width=" << getWidthForLLVMType(bt) << "offsetexpr=" << offsetexpr << "result=" << result << " width=" << getWidthForLLVMType(bt) << " sm->size=" << sm->size << "targetbase=" << op.first->getBaseExpr() << " targetsize=" << op.first->size << "\n";
                   // check sanity
                   const ConstantExpr *co = dyn_cast<ConstantExpr>(offsetexpr);
                   if (co) {
                      if ((op.first->size - co->getZExtValue()) < sm->size) {
                         llvm::errs() << "Symbolization of a void pointer mismatches real type, " 
                                       << (op.first->size - co->getZExtValue()) << " vs " << sm->size << "\n";
                         terminateStateOnError(state, "memory error: cast due a void pointer", Ptr,
                            NULL, getAddressInfo(state, op.first->getBaseExpr()));
                         term = true;
                         return;
                      }
                   }               
                   wos->write(offsetexpr, result);
                   llvm::errs() << "Wrote " << result << " to symbolized arg address " << base << " for function " << function->getName() << "\n"; 
               }
               else llvm::errs() << "Couldn't resolve address during symbolization of arg: " << base << " for function " << function->getName() << "\n";
             //}

         }
       }
      } 

}


const MemoryObject *Executor::symbolizeReturnValueForAsmInstruction(ExecutionState &state, 
                                  KInstruction *target, llvm::Value *inst,
                                  bool &abort) {
    std::string type_str;
    llvm::raw_string_ostream rso(type_str);
    llvm::InlineAsm *iasm = dyn_cast<llvm::InlineAsm>(inst);
    if (!iasm) return NULL;
    Type *retType = iasm->getFunctionType()->getReturnType();
    retType->print(rso);
    const MemoryObject *mo;
    ref<Expr> laddr;
    llvm::Type *rType;
    bool mksym;
    Type *allocType = retType;
    if (retType->isPointerTy())
       allocType = retType->getPointerElementType();
    mo = memory->allocateLazyForTypeOrEmbedding(state, state.prevPC->inst, allocType, allocType,
          isLazySingle(retType, "*"), 1, rType, laddr, mksym, abort);
    if (!mo) {
       return NULL;
    }
    mo->name = "%sym" + std::to_string(target->dest) + "_" + getUniqueSymRegion("asm"); 
    //#ifdef VB
    llvm::outs() << "symbolizing return value \n";
    //#endif
    executeMakeSymbolic(state, mo, mo->name, true, allocType, true);
    if (retType->isVoidTy())
       return mo;
    if (allocType == retType) {
       executeMemoryOperation(state, false, laddr, 0, target);
    }
    else
       bindLocal(target, state, laddr);
   return mo;
}





const MemoryObject *Executor::symbolizeReturnValue(ExecutionState &state, 
                                  KInstruction *target,
                                  Function *function, bool &abort) {

    if (function->getReturnType()->isVoidTy())
       return NULL;  
    std::string type_str;
    llvm::raw_string_ostream rso(type_str);
    function->getReturnType()->print(rso);
    llvm::outs() << "return type of external function " << function->getName() << ": " << rso.str() << "\n";
    const MemoryObject *mo;
    ref<Expr> laddr;
    llvm::Type *rType;
    bool mksym; 
    llvm::Type *retType = function->getReturnType();
    llvm::Type *allocType = retType;
    if (retType->isPointerTy())
       allocType = retType->getPointerElementType();
    mo = memory->allocateLazyForTypeOrEmbedding(state, state.prevPC->inst, allocType, allocType,  
          isLazySingle(function->getReturnType(), "*"), 1, rType, laddr, mksym, abort);
    if (abort) { 
       return NULL; 
    }
    // For pointer types also consider the NULL return value
    Executor::StatePair pair; 
    mo->name = "%sym" + std::to_string(target->dest) + "_" + state.getUnique(function->getName().str());
    llvm::outs() << "mo=" << mo << "\n";
    llvm::outs() << "base address of symbolic memory to be copied from " << mo->getBaseExpr() << " and real target address " << laddr << "\n";
    if (mksym) {
       llvm::outs() << "symbolizing return value \n";
       executeMakeSymbolic(state, mo, mo->name, true, allocType, true);
    }
    if (allocType == retType)
       executeMemoryOperation(state, false, laddr, 0, target);
    else  { // return type is a pointer type
       if (!nullReturnValue) {
          bindLocal(target, state, laddr);
       }
       else { 

       // first create a symbolic pointer
       const MemoryObject *moptr = memory->allocate(kmodule->targetData->getTypeAllocSize(retType), false,
                                          true, state.prevPC->inst,
                                          kmodule->targetData->getPrefTypeAlignment(retType),
                                          1, retType);
       recordMemObj(state, moptr);
       moptr->name = "%sym_retpointer_" + std::to_string(target->dest) + "_" + state.getUnique(function->getName().str());
       // we're mimicking what executeMemoryOperation do without a relevant load or store instruction
       const Array *array = arrayCache.CreateArray(moptr->name, moptr->size);
       ObjectState *sos = bindObjectInState(state, moptr, true, array);
       ref<Expr> result = sos->read(ConstantExpr::alloc(0, Expr::Int64), getWidthForLLVMType(retType)); 
       //llvm::errs() << "PC before symbolize return value for state " << &state << "\n";
       //ExprPPrinter::printConstraints(llvm::errs(), state.constraints);
       //llvm::errs() << "first assigning " << result << " to the return value\n";      
       bindLocal(target,  state, result);
       //ref<Expr> nullret = EqExpr::create(target, Expr::createPointer(0));
       //llvm::errs() << "forking on null return value: " << nullret << "\n";
       Executor::StatePair pair = fork(state, Expr::createIsZero(result), true);
       //llvm::errs() << "result: " << result << " first: " << pair.first << " second: " << pair.second << "\n";
       //llvm::errs() << "symbolize return value for : " << (*target->inst) << "\n";
       //llvm::errs() << "PC for symbolize return value\n";
       //ExprPPrinter::printConstraints(llvm::errs(), state.constraints);
       if (pair.first && pair.second) {
          // we need to enforce null pointer here or lazy initialization will assign a valid address upon memory access!
          bindLocal(target, *pair.first, Expr::createPointer(0)); 
          // make the not null case point to the symbolic memory of the base type
          //llvm::errs() << "assigning " << laddr << " in symbolizereturn in state " << pair.second << " orig state=" << &state << "\n"; 
          bindLocal(target, *pair.second, laddr);
       }
       else {
          assert(pair.first == &state || pair.second == &state);
          bool res;
          solver->setTimeout(coreSolverTimeout);
          bool success = solver->mustBeTrue(state, 
                                      Expr::createIsZero(result),
                                      res);
          solver->setTimeout(0);
          if (success) {
             if (res) {
                bindLocal(target, (pair.first ? *pair.first : *pair.second), Expr::createPointer(0));
                //llvm::errs() << "assigning in single successor NULL for return value\n";
             }
             else {
                bindLocal(target, (pair.first ? *pair.first : *pair.second) , laddr); 
                //llvm::errs() << "assigning in single successor " << laddr << "for return value\n";
             }
          }
          //else llvm::errs() << "keeping return value symbolic!!!\n"; 

       }
     }
    }
    
    return mo;
}

/* SYSREL extension */


/***/

ref<Expr> Executor::replaceReadWithSymbolic(ExecutionState &state, 
                                            ref<Expr> e) {
  unsigned n = interpreterOpts.MakeConcreteSymbolic;
  if (!n || replayKTest || replayPath)
    return e;

  // right now, we don't replace symbolics (is there any reason to?)
  if (!isa<ConstantExpr>(e))
    return e;

  if (n != 1 && random() % n)
    return e;

  // create a new fresh location, assert it is equal to concrete value in e
  // and return it.
  
  static unsigned id;
  const Array *array =
      arrayCache.CreateArray("rrws_arr" + llvm::utostr(++id),
                             Expr::getMinBytesForWidth(e->getWidth()));
  ref<Expr> res = Expr::createTempRead(array, e->getWidth());
  ref<Expr> eq = NotOptimizedExpr::create(EqExpr::create(e, res));
  llvm::errs() << "Making symbolic: " << eq << "\n";
  state.addConstraint(eq);
  return res;
}

ObjectState *Executor::bindObjectInState(ExecutionState &state, 
                                         const MemoryObject *mo,
                                         bool isLocal,
                                         const Array *array) {
  ObjectState *os = array ? new ObjectState(mo, array) : new ObjectState(mo);
  state.addressSpace.bindObject(mo, os);

  // Its possible that multiple bindings of the same mo in the state
  // will put multiple copies on this list, but it doesn't really
  // matter because all we use this list for is to unbind the object
  // on function return.
  if (isLocal)
    state.stack.back().allocas.push_back(mo);

  return os;
}

void Executor::executeAlloc(ExecutionState &state,
                            ref<Expr> size,
                            bool isLocal,
                            KInstruction *target,
                            bool zeroMemory,
                            bool record,
                            const ObjectState *reallocFrom) {
  llvm::outs() << "Alloc'ing...\n";
  size = toUnique(state, size);
  if (ConstantExpr *CE = dyn_cast<ConstantExpr>(size)) {
    const llvm::Value *allocSite = state.prevPC->inst;
    size_t allocationAlignment = getAllocationAlignment(allocSite);
    llvm::errs() << "Alloc size: " << CE->getZExtValue() << "\n";
    LLVMContext &ctx = moduleHandle->getContext();
    MemoryObject *mo =
        memory->allocate(CE->getZExtValue(), isLocal, /*isGlobal=*/false,
                         allocSite, allocationAlignment, CE->getZExtValue(), Type::getInt8Ty(ctx));
    recordMemObj(state, mo);
    /* SYSREL extension */

   if (mo)
      state.lastMallocedMem = mo;

   if (record)
      state.recordAlloc(mo->getBaseExpr());

   if (lazyInit) {
    Type *t = target->inst->getType();
    if (t->isPointerTy()) {
        t = t->getPointerElementType();
        if (!t->isPointerTy()) {
            StructType *st = dyn_cast<StructType>(t);
            if (st) {
               std::string tname = getTypeName(t); 
               state.typeToAddr[t] = mo->getBaseExpr();
               llvm::outs() << "mapping alloced " << tname << " to " << mo->getBaseExpr() << "\n";
            }
        }
    }  
   } 
    /* SYSREL extension */ 

    if (!mo) {
      bindLocal(target, state, 
                ConstantExpr::alloc(0, Context::get().getPointerWidth()));
    } else {
      ObjectState *os = bindObjectInState(state, mo, isLocal);
      if (zeroMemory) {
        os->initializeToZero();
      } else {
        os->initializeToRandom();
      }

      llvm::errs() << "mo=" << mo << "\n";
      llvm::errs() << "binding " << mo->getBaseExpr() << " to " << (*target->inst) << "\n";
      if (getDestCell(state, target).value.get())
         llvm::errs() << "address to be dest: " << getDestCell(state, target).value << "\n";


      bindLocal(target, state, mo->getBaseExpr());
      
      if (reallocFrom) {
        unsigned count = std::min(reallocFrom->size, os->size);
        for (unsigned i=0; i<count; i++)
          os->write(i, reallocFrom->read8(i));
        state.addressSpace.unbindObject(reallocFrom->getObject());
      }
    }
  } else {
    // XXX For now we just pick a size. Ideally we would support
    // symbolic sizes fully but even if we don't it would be better to
    // "smartly" pick a value, for example we could fork and pick the
    // min and max values and perhaps some intermediate (reasonable
    // value).
    // 
    // It would also be nice to recognize the case when size has
    // exactly two values and just fork (but we need to get rid of
    // return argument first). This shows up in pcre when llvm
    // collapses the size expression with a select.

    ref<ConstantExpr> example;
    bool success = solver->getValue(state, size, example);
    assert(success && "FIXME: Unhandled solver failure");
    (void) success;
    
    // Try and start with a small example.
    Expr::Width W = example->getWidth();
    while (example->Ugt(ConstantExpr::alloc(128, W))->isTrue()) {
      ref<ConstantExpr> tmp = example->LShr(ConstantExpr::alloc(1, W));
      bool res;
      bool success = solver->mayBeTrue(state, EqExpr::create(tmp, size), res);
      assert(success && "FIXME: Unhandled solver failure");      
      (void) success;
      if (!res)
        break;
      example = tmp;
    }

    StatePair fixedSize = fork(state, EqExpr::create(example, size), true);
    
    if (fixedSize.second) { 
      // Check for exactly two values
      ref<ConstantExpr> tmp;
      bool success = solver->getValue(*fixedSize.second, size, tmp);
      assert(success && "FIXME: Unhandled solver failure");      
      (void) success;
      bool res;
      success = solver->mustBeTrue(*fixedSize.second, 
                                   EqExpr::create(tmp, size),
                                   res);
      assert(success && "FIXME: Unhandled solver failure");      
      (void) success;
      if (res) {
        executeAlloc(*fixedSize.second, tmp, isLocal,
                     target, zeroMemory, record, reallocFrom);
      } else {
        // See if a *really* big value is possible. If so assume
        // malloc will fail for it, so lets fork and return 0.
        StatePair hugeSize = 
          fork(*fixedSize.second, 
               UltExpr::create(ConstantExpr::alloc(1U<<31, W), size),
               true);
        if (hugeSize.first) {
          klee_message("NOTE: found huge malloc, returning 0");
          bindLocal(target, *hugeSize.first, 
                    ConstantExpr::alloc(0, Context::get().getPointerWidth()));
        }
        
        if (hugeSize.second) {

          /* SYSREL extension */
          if (lazyInit) {
             llvm::errs() << "concretized symbolic size as 10\n"; 
              executeAlloc(*hugeSize.second, ConstantExpr::create(10,64), isLocal, 
                   target, zeroMemory, record, reallocFrom);

         }
         else {
         /* SYSREL extension */
          std::string Str;
          llvm::raw_string_ostream info(Str);
          ExprPPrinter::printOne(info, "  size expr", size);
          info << "  concretization : " << example << "\n";
          info << "  unbound example: " << tmp << "\n";
          terminateStateOnError(*hugeSize.second, "concretized symbolic size",
                                Model, NULL, info.str());
         }
        }
      }
    }

    if (fixedSize.first) // can be zero when fork fails
      executeAlloc(*fixedSize.first, example, isLocal, 
                   target, zeroMemory, record, reallocFrom);
  }
}

void Executor::executeFree(ExecutionState &state,
                           ref<Expr> address,
                           KInstruction *target) {
  llvm::errs() << "Executing free " << address << " state=" << &state << " from function " << state.prevPC->inst->getParent()->getParent()->getName() << "\n"; 

  state.recordFree(address); 
  StatePair zeroPointer = fork(state, Expr::createIsZero(address), true);
  if (zeroPointer.first) {
     llvm::outs() << "A zero pointer possibility in free " << address << "\n";
    if (target)
      bindLocal(target, *zeroPointer.first, Expr::createPointer(0));
  }
  if (zeroPointer.second) { // address != 0
    ExactResolutionList rl;
    llvm::outs() << "Resolving exact for free!";
    resolveExact(*zeroPointer.second, address, rl, "free");
    llvm::outs() << "Resolved exact for free!";
    for (Executor::ExactResolutionList::iterator it = rl.begin(), 
           ie = rl.end(); it != ie; ++it) {
      const MemoryObject *mo = it->first.first;
      if (mo->isLocal) {
        terminateStateOnError(*it->second, "free of alloca", Free, NULL,
                              getAddressInfo(*it->second, address));
      } else if (mo->isGlobal) {
        terminateStateOnError(*it->second, "free of global", Free, NULL,
                              getAddressInfo(*it->second, address));
      } else {
         llvm::outs() << "In free, unbinding obj at address "  << mo->getBaseExpr() << "\n";

         /* SYSREL extension */
         state.recordFree(mo->getBaseExpr());
         /* SYSREL extension */

        it->second->addressSpace.unbindObject(mo);
        if (target)
          bindLocal(target, *it->second, Expr::createPointer(0));
      }
    }
  }
}

void Executor::resolveExact(ExecutionState &state,
                            ref<Expr> p,
                            ExactResolutionList &results, 
                            const std::string &name) {
  // XXX we may want to be capping this?
  ResolutionList rl;
  state.addressSpace.resolve(state, solver, p, rl);
  
  ExecutionState *unbound = &state;
  for (ResolutionList::iterator it = rl.begin(), ie = rl.end(); 
       it != ie; ++it) {
    ref<Expr> inBounds = EqExpr::create(p, it->first->getBaseExpr());
    
    StatePair branches = fork(*unbound, inBounds, true);
    
    if (branches.first)
      results.push_back(std::make_pair(*it, branches.first));

    unbound = branches.second;
    if (!unbound) // Fork failure
      break;
  }

  if (unbound) {
    terminateStateOnError(*unbound, "memory error: invalid pointer: " + name,
                          Ptr, NULL, getAddressInfo(*unbound, p));
  }
}

/* SYSREL EXTENSION */ 

bool Executor::executeCheckAddressInBound(ExecutionState &state,
					  ref<Expr> address, Type *type, bool &memoryerror) {

  unsigned bytes = Expr::getMinBytesForWidth(getWidthForLLVMType(type));
 
  llvm::errs() << "size of checked region " << bytes << " for type=" << getTypeName(type) << "\n";

  if (SimplifySymIndices) {
    if (!isa<ConstantExpr>(address))
      address = state.constraints.simplifyExpr(address);
  }
  // fast path: single in-bounds resolution
  ObjectPair op;
  bool success;
  solver->setTimeout(coreSolverTimeout);
  if (!state.addressSpace.resolveOne(state, solver, address, op, success)) {
    address = toConstant(state, address, "resolveOne failure");
    success = state.addressSpace.resolveOne(cast<ConstantExpr>(address), op);
  }
  solver->setTimeout(0);

  if (success) {
    const MemoryObject *mo = op.first;

    if (MaxSymArraySize && mo->size>=MaxSymArraySize) {
      address = toConstant(state, address, "max-sym-array-size");
    }
    
    ref<Expr> offset = mo->getOffsetExpr(address);
    llvm::outs() << "address for memop " << address << "\n";
    llvm::outs() << "default offset for target address " << offset << "\n";    
    llvm::outs() << "base memory address " << mo->getBaseExpr() << "\n";

    bool inBounds;
    solver->setTimeout(coreSolverTimeout);
    bool success = solver->mustBeTrue(state, 
                                      mo->getBoundsCheckOffset(offset, bytes),
                                      inBounds);
    solver->setTimeout(0);
    if (!success) {
      state.pc = state.prevPC;
      //terminateStateEarly(state, "Query timed out (bounds check).");
      memoryerror = false; 
      return false;
    }

    llvm::errs() << "bounds check expression " << mo->getBoundsCheckOffset(offset, bytes) << "\n";
    llvm::errs() << "in bounds? " << inBounds << "\n";

    if (inBounds)
       return true; 
    else {
       // we are on an error path (no resolution, multiple resolution, one
       // resolution with out of bounds)
  
       ResolutionList rl;  
       bool incomplete = false;

       bool craftedResList = false;
       if (PreferredResolution) { // use the base address stored in getelementptr to use the MemoryObject for resolution
          //llvm::errs() << "Checking if we can identify the single resolution candidate with PreferredResolution option!\n"; 
          if (symIndexToMemBase.find((long)&state) != symIndexToMemBase.end()) {
             std::map<ref<Expr>, ref<Expr> > m = symIndexToMemBase[(long)&state];
             ref<Expr> addtocheck = address;
             int i=0;
             while (m.find(addtocheck) != m.end() && i++<3) {
                 //llvm::errs() << " checking mapping for " << addtocheck << "\n";
                 ref<Expr> mobase = m[addtocheck];
                 if (!isa<ConstantExpr>(mobase)) {
                    // non-constant; keep checking the address it gets mapped 
                    addtocheck = mobase;
                    continue;
                 }
                 if (addressToMemObj.find((long)&state) != addressToMemObj.end()) {
                    std::map<ref<Expr>, const MemoryObject *> m2 = addressToMemObj[(long)&state];
                    if (m2.find(mobase) != m2.end()) {
                       const MemoryObject *mres = m2[mobase];
                       const ObjectState *ores = state.addressSpace.findObject(mres);
                       if (mres && ores) {
                          ObjectPair opres;
                          opres.first = mres;
                          opres.second = ores;
                          rl.push_back(opres);
                          craftedResList = true; 
                          llvm::errs() << "Using mem obj with base " << mobase << " to resolve " << address << "\n";
                          break;
                       } 
                       else break;
                    }
                    else { 
                       if (addtocheck == mobase) break;
                       llvm::errs() << "memobj for " << mobase << " in state " << &state << " not found \n"; 
                       addtocheck = mobase;                   
                    }
                }
                else break;
            }
         }
      }

      if (!craftedResList) {
         solver->setTimeout(coreSolverTimeout);
         incomplete = state.addressSpace.resolve(state, solver, address, rl,
                                               0, coreSolverTimeout);
         solver->setTimeout(0);
      }
  
       // XXX there is some query wasteage here. who cares?
       ExecutionState *unbound = &state;
  
       for (ResolutionList::iterator i = rl.begin(), ie = rl.end(); i != ie; ++i) {
           const MemoryObject *mo = i->first;
           ref<Expr> inBounds = mo->getBoundsCheckPointer(address, bytes);
    
           StatePair branches = fork(*unbound, inBounds, true);
           unbound = branches.second;
           if (!unbound)
              break;
      }
  
      // XXX should we distinguish out of bounds and overlapped cases?
      if (unbound) {
         if (incomplete) {
            llvm::errs() << "Address validity check query timed out!\n";
            //terminateStateEarly(*unbound, "Query timed out (resolve).");
            memoryerror = false;  
         } 
         else {
            llvm::errs() << "Offending address " << address << "\n";
            std::string s;
            llvm::raw_string_ostream ors(s);
            ors << "Memory out of bound\n";
            state.dumpStack(ors);
            llvm::errs() << ors.str() ;
            ExprPPrinter::printConstraints(llvm::errs(), state.constraints);
            //terminateStateOnError(*unbound, "memory error: out of bound pointer", Ptr,
	    //NULL, getAddressInfo(*unbound, address));
            memoryerror = true; 
        }
     }
     return false;
    }

  }
  else {
     llvm::errs() << "Address validity check query timed out!\n";
     //terminateStateEarly(state, "Query timed out (resolve).");
     memoryerror = false;
     return false;
  }  
}


int getTypeBaseInObject(const MemoryObject *mo, Type *qt, 
             unsigned addressClue, unsigned baseAddress) {
  DataLayout *dl = kmoduleExt->targetData;
  Type *t = mo->baseType;
  if (t == qt) {
     unsigned bottom = baseAddress;
     unsigned top = baseAddress + dl->getTypeAllocSize(t);
     if (bottom <= addressClue && addressClue < top)
        return baseAddress;
     else return -1;
  }
  StructType *st = dyn_cast<StructType>(t);
  if (st) {
     const StructLayout *sl = dl->getStructLayout(st);
     unsigned relbase = baseAddress;
     bool done = false;
     StructType *tst = st;
     bool newst = true;
     while (newst) {
         newst = false;
         for(unsigned i=0; i<tst->getNumElements(); i++) {
            Type *et = tst->getElementType(i);
            unsigned bottom = relbase + sl->getElementOffset(i);
            unsigned top = relbase + sl->getElementOffset(i) + dl->getTypeAllocSize(et);
            llvm::errs() << "checking " << addressClue << " inside type region " 
                         << getTypeName(et) << " bw [" << bottom << "," << top << "]\n";
                          
            if (bottom <= addressClue && addressClue < top) { 
               StructType *est = dyn_cast<StructType>(et);
               if (est) {
                  if (est == qt)
                     return bottom;
                  else  {
                     tst = est;
                     newst = true;
                     relbase = relbase + sl->getElementOffset(i);
                     break;
                  }
               }
            }
         }
     }
  }
  return -1;
}

int getTypeBaseInArray(const MemoryObject *mo, Type *qt, 
             unsigned addressClue) {
  Type *t = mo->baseType;
  if (!dyn_cast<StructType>(t)) return -1;
  DataLayout *dl = kmoduleExt->targetData;
  assert(dyn_cast<klee::ConstantExpr>(mo->getBaseExpr()) && 
                  "Base address of the memory object must be constant!\n");
  unsigned mobase = dyn_cast<klee::ConstantExpr>(mo->getBaseExpr())->getZExtValue();  
  for(unsigned i=0; i<mo->num; i++) {
     unsigned newbase = mobase + i*dl->getTypeAllocSize(t); 
     int result = getTypeBaseInObject(mo, qt, addressClue, newbase);    
     if (result != -1)
        return result; 
  }
  llvm::errs() << "WARNING: Could not find the embedded type " << getTypeName(qt) 
               << " inside the memory object at address " << mo->getBaseExpr() 
               << " with recorded type " << getTypeName(mo->baseType) << "\n";
  return -1;
}

ref<Expr> Executor::performLazyInit(ExecutionState &state,
                                    ref<Expr> address,
                                    ref<Expr> offset, 
                                    ref<Expr> result, 
                                    KInstruction *target,
                                    ObjectPair op,
                                    bool &abort 
                                   ) {
   if (!lazyInit || TurnOffSymbAddressLI) return NULL;
   const MemoryObject *mo = op.first;
   llvm::outs() << "load orig result: " << result << "\n";
   bool lazyInitTemp = false, singleInstance = false;
   llvm::Instruction *inst = state.prevPC->inst;       
   llvm::LoadInst *li = dyn_cast<llvm::LoadInst>(inst);
   if (!li) return NULL;

   if (li) {
      Type *t = li->getPointerOperand()->getType();
      int count = 0;
      lazyInitTemp = isLazyInit(t, singleInstance, count);
      if (!lazyInitTemp && ForwardTypeInference) {
         // let's check if the loaded value might be converted to a pointer soon
         Type *ptype = checkPossiblePtrCast(target->inst);
         if (ptype) {
            llvm::errs() << "Using the inferred ptr type\n"; 
            // let's check again 
            t = ptype->getPointerTo();
            lazyInitTemp = isLazyInit(t, singleInstance, count);
         }
      }
      std::string rsostr = getTypeName(t);
      llvm::outs() << "Is " << rsostr << " (count=" << count << ") to be lazy init?\n";
      inst->dump();
      if (lazyInitTemp) {
         if (t->isPointerTy()) {
            t = t->getPointerElementType();
            if (t->isPointerTy()) 
               t = t->getPointerElementType();
            else 
               assert(false && "Expected a pointer type for lazy init");
         }
         else 
             assert(false && "Expected a pointer type for lazy init");
         llvm::errs() << "Yes!\n";
         llvm::errs() << "original load result: " << result << "\n";
         std::string rso2str = getTypeName(t);
         llvm::errs() << "Allocating memory for type " << rso2str << " of size " << "\n"; 
         if (rso2str.find("struct") == std::string::npos) {
            Type *temp = checkAndComputeBitcastInfo(inst, rso2str);
            if (temp) {
               t = temp;
               rso2str = getTypeName(t);
               llvm::errs() << "Using type " << rso2str << 
                          " instead of type i8 based on a recent bitcast!\n" ;                    
            } 
         }
         Type *enclosingType = dyn_cast<StructType>(mo->baseType);
         if (!enclosingType)
            enclosingType = getEnclosingObjectType(target->inst);
         std::string etname = (enclosingType ? getTypeName(enclosingType) : "");
         llvm::errs() << "enclosing type? " << etname << "\n";
         klee::ConstantExpr *OCE = dyn_cast<klee::ConstantExpr>(offset);
         if (enclosingType && OCE) {
            unsigned tempcount = getSizeofSpecArray(mo, enclosingType, t, address, 
                          OCE->getZExtValue());
            if (tempcount > 0) {
               count = tempcount;
               llvm::errs() << "using type specific count: " << count << "\n";
            }                
            int fas = getInitFieldArray(etname,OCE->getZExtValue());
            if (fas > 0) {
               llvm::errs() << "Array field at offset " << OCE->getZExtValue() 
                         << " in type " << etname << " is created to be size " 
                         << fas << "\n";
               count = fas; 
            } 
         }
         Type *possibleEncType = inferEnclosingTypeDueToPointerArithmetic(target->inst);
         ref<Expr> laddr;
         llvm::Type *rType;
         bool mksym;
         const MemoryObject *lmo = memory->allocateLazyForTypeOrEmbedding(state, 
            state.prevPC->inst, t, t, singleInstance, count, rType, laddr, 
            mksym, abort, possibleEncType); 
         if (abort) return NULL;      
         llvm::errs() << "mem obj addr=" << laddr << "\n";
         lmo->name = state.getUnique(rso2str);
         if (mksym) {
            llvm::errs() << "marking it symbolic!\n";
            ConstantExpr *ocexp = dyn_cast<ConstantExpr>(offset);
            // data constraints are applied inside executeMakeSymbolic
            if (enclosingType && ocexp) {
               ObjectState *los = executeMakeSymbolic(state, lmo, rso2str, true, t, true, count, 
                                             enclosingType, mo, op.second, ocexp->getZExtValue());
               // first simple equalities get applied..
               applyDataConstraintToArray(state, solver, lmo, los, 0, count, true);
               // then other constraints 
               applyDataConstraintToArray(state, solver, lmo, los, 0, count, false);
               applySizeOfConstraint(state, solver, lmo, t, count, address, 
                                     enclosingType, mo, op.second, 
                                        ocexp->getZExtValue());
               // the old interface for API model specs
               applyCommandlineSpecInitializationsToArray(state, solver, lmo, los, rType, count);
            }
            else {
               ObjectState *los = executeMakeSymbolic(state, lmo, rso2str, true, t, true, count);
               // first simple equalities get applied..
               applyDataConstraintToArray(state, solver, lmo, los, 0, count, true);
               // then other constraints 
               applyDataConstraintToArray(state, solver, lmo, los, 0, count, false);
               // the old interface for API model specs
               applyCommandlineSpecInitializationsToArray(state, solver, lmo, los, rType, count);
            }

            if (state.terminated) {
               terminateStateEarly(state, "Inconsinstency during lazy initialization\n"); 
               abort = true;
               return NULL;
            }

         }
         std::pair<unsigned, unsigned> fieldInfo;
         if (enclosingType) { 
            llvm::errs() << "enclosing type inferred from IR: " 
                      << getTypeName(enclosingType) << "\n";
            if (OCE) {
               llvm::errs() << "constant offset=" << OCE->getZExtValue() << "\n";
               // record the embedding type, offset pair for this object
               recordLazyInitEmbeddedPointers(state, lmo, enclosingType, OCE->getZExtValue());
               // apply the relevant data constraint, if any
               if (getDataConstraint(etname, OCE->getZExtValue(), fieldInfo)) {
                  ref<Expr> lengthExp = op.second->read(fieldInfo.first,fieldInfo.second);
                  ref<Expr> positiveExp = UgtExpr::create(lengthExp, 
                                                ConstantExpr::create(0,lengthExp->getWidth()));
                  ref<Expr> ltExp = UleExpr::create(lengthExp, 
                                            ConstantExpr::create(count,lengthExp->getWidth()));
                  ref<Expr> dcons = AndExpr::create(positiveExp,ltExp); 
                  addConstraint(state, dcons);
                  llvm::errs() << "Adding data constraint " << dcons << "\n"; 
               }
            }
          }
          llvm::outs() << "lazy initializing writing " << laddr 
                           << "( inside " << lmo->getBaseExpr() << ") to " << address << "\n";
          if (isSingleOrDerivative(state, mo->getBaseExpr()))  {
             addSingleOrDerivative(state, lmo->getBaseExpr());
             llvm::errs() << "recording singleton or derivative " << lmo->getBaseExpr() << "\n";
          }
          executeMemoryOperation(state, true, address, laddr, 0);
          return laddr;
     }
  }
  return NULL;  
}


// return true if abort
bool Executor::executeMemoryOperation(ExecutionState &state,
                                      bool isWrite,
                                      ref<Expr> address,
                                      ref<Expr> value /* undef if read */,
                                      KInstruction *target /* undef if write */) {


  llvm::errs() << "state=" << &state << " memory operation (inside " << state.prevPC->inst->getParent()->getParent()->getName() << ") \n"; 
  state.prevPC->inst->print(llvm::outs());  
  llvm::errs() << "\n address: " << address << "\n";

  llvm::errs() << "executeMemoryOperation isWrite? " << isWrite  << "\n";
  //if (isWrite)
    // llvm::outs() << "storing value " << value << "\n";

  Expr::Width type = (isWrite ? value->getWidth() : 
                     getWidthForLLVMType(target->inst->getType()));

  unsigned bytes = Expr::getMinBytesForWidth(type);

  llvm::errs() << "width for the memop: " << type << "\n";
  llvm::errs() << "bytes for the memop: " << bytes << "\n";


  if (SimplifySymIndices) {
    if (!isa<ConstantExpr>(address))
      address = state.constraints.simplifyExpr(address);
    if (isWrite && !isa<ConstantExpr>(value))
      value = state.constraints.simplifyExpr(value);
  }

  // fast path: single in-bounds resolution
  ObjectPair op;
  bool success;
  solver->setTimeout(coreSolverTimeout);
  if (!state.addressSpace.resolveOne(state, solver, address, op, success)) {
    address = toConstant(state, address, "resolveOne failure");
    success = state.addressSpace.resolveOne(cast<ConstantExpr>(address), op);
  }
  solver->setTimeout(0);

  llvm::errs() << "first solver query passed\n";

  if (success) {
    const MemoryObject *mo = op.first;

    if (MaxSymArraySize && mo->size>=MaxSymArraySize) {
      address = toConstant(state, address, "max-sym-array-size");
    }
    
    ref<Expr> offset = mo->getOffsetExpr(address);
    llvm::errs() << "address for memop " << address << "\n";
    llvm::errs() << "default offset for target address " << offset << "\n";    
    llvm::errs() << "base memory address " << mo->getBaseExpr() << "\n";

    bool inBounds;
    solver->setTimeout(coreSolverTimeout);
    bool success = solver->mustBeTrue(state, 
                                      mo->getBoundsCheckOffset(offset, bytes),
                                      inBounds);
    solver->setTimeout(0);
    if (!success) {
      state.pc = state.prevPC;
      terminateStateEarly(state, "Query timed out (bounds check).");
      return false;
    }

    llvm::errs() << "bounds check expression " << mo->getBoundsCheckOffset(offset, bytes) << "\n";
    llvm::errs() << "in bounds? " << inBounds << "\n";

    if (inBounds) {
      const ObjectState *os = op.second;
      if (isWrite) {
        if (os->readOnly) {
          terminateStateOnError(state, "memory error: object read only",
                                ReadOnly);
        } else {
          ObjectState *wos = state.addressSpace.getWriteable(mo, os);
          wos->write(offset, value);
          llvm::outs() << "just wrote:\n";
        }          
      } else {
        ref<Expr> result = os->read(offset, type);
        
        if (interpreterOpts.MakeConcreteSymbolic)
          result = replaceReadWithSymbolic(state, result);
        
        /* SYSREL EXTENSION */
        if (!dyn_cast<ConstantExpr>(result)) {
	   bool abort = false;
	   ref<Expr> lresult = performLazyInit(state,address,offset,result,target,op,abort);
           if (abort) 
              return true;
           if (!lresult.isNull())
              result = lresult;
        }
        /* SYSREL EXTENSION */

        if (getDestCell(state, target).value.get())
         llvm::errs() << "address to be dest: " << getDestCell(state, target).value << "\n";

        bindLocal(target, state, result);

       llvm::outs() << " load result: " << result << "\n";

       
       if (lazyInit && TurnOffSymbAddressLI) {          
          Type *t = NULL;
          if (isWrite) {
             StoreInst *stinst = dyn_cast<StoreInst>(target->inst);
             if (stinst) // if a real store instruction!
                t = ((StoreInst*)target->inst)->getPointerOperand()->getType();
          }
          else  t = ((LoadInst*)target->inst)->getPointerOperand()->getType();
          if (t && t->isPointerTy()) {
              t = t->getPointerElementType();
              if (!t->isPointerTy()) { // not interested in the pointer's address
                 std::string tname = getTypeName(t);
                 state.typeToAddr[t] =  address;
                 llvm::outs() <<  "recorded memory to type mapping (1) as " <<  address << "->" << tname <<"\n";
              } 
          }
       }
       
     }

      return false;
    }
  } 

  // we are on an error path (no resolution, multiple resolution, one
  // resolution with out of bounds)
  
  ResolutionList rl;  
  bool incomplete = false;

  bool craftedResList = false;
  if (PreferredResolution) { // use the base address stored in getelementptr to use the MemoryObject for resolution
     //llvm::errs() << "Checking if we can identify the single resolution candidate with PreferredResolution option! " << address << "\n"; 
     if (symIndexToMemBase.find((long)&state) != symIndexToMemBase.end()) {
          std::map<ref<Expr>, ref<Expr> > m = symIndexToMemBase[(long)&state];
          ref<Expr> addtocheck = address;
          int i=0;
          while (m.find(addtocheck) != m.end() && i++ < 3) {
             llvm::errs() << " checking mapping for " << addtocheck << "\n";
             ref<Expr> mobase = m[addtocheck];
             if (!isa<ConstantExpr>(mobase)) {
                // non-constant; keep checking the address it gets mapped 
                addtocheck = mobase;
                continue;
             }
             if (addressToMemObj.find((long)&state) != addressToMemObj.end()) {
                std::map<ref<Expr>, const MemoryObject *> m2 = addressToMemObj[(long)&state];
                if (m2.find(mobase) != m2.end()) {
                   const MemoryObject *mres = m2[mobase];
                   const ObjectState *ores = state.addressSpace.findObject(mres);
                   if (mres && ores) {
                      ObjectPair opres;
                      opres.first = mres;
                      opres.second = ores;
                      rl.push_back(opres);
                      craftedResList = true; 
                      llvm::errs() << "Using mem obj with base " << mobase << " to resolve " << address << "\n";
                      break;
                   } 
                   else break;
                }
                else { 
                   if (addtocheck == mobase) break;
                   llvm::errs() << "memobj for " << mobase << " in state " << &state << " not found \n"; 
                   addtocheck = mobase;                   
                }
             }
             else break;
          }
       }
  }

  if (!craftedResList) {
     solver->setTimeout(coreSolverTimeout);
     incomplete = state.addressSpace.resolve(state, solver, address, rl,
                                               0, coreSolverTimeout);
     solver->setTimeout(0);
  }
  
  // XXX there is some query wasteage here. who cares?
  ExecutionState *unbound = &state;
  
  const MemoryObject *emo = op.first;
  //llvm::errs() << "unresolved address=" << address << "\n";

  int unboundResolLimit = 3;
  int resC = 0;
  llvm::errs() << "resolution size=" << rl.size() << "\n";
  for (ResolutionList::iterator i = rl.begin(), ie = rl.end(); resC < unboundResolLimit && i != ie; ++i, resC++) {
    const MemoryObject *mo = i->first;
    const ObjectState *os = i->second;
    ref<Expr> inBounds = mo->getBoundsCheckPointer(address, bytes);
    
    StatePair branches = fork(*unbound, inBounds, true);
    //llvm::errs() << "Forking for symbolic unresolved address " << (target ? target->getSourceLocation() : "") << "\n";
    ExecutionState *bound = branches.first;

    // bound can be 0 on failure or overlapped 
    if (bound) {
      if (isWrite) {
        if (os->readOnly) {
          terminateStateOnError(*bound, "memory error: object read only",
                                ReadOnly);
        } else {
          ObjectState *wos = bound->addressSpace.getWriteable(mo, os);
          wos->write(mo->getOffsetExpr(address), value);
          llvm::outs() << "just wrote " << value << " to " << address 
                       << " at the base address of mo " << mo->getBaseExpr() 
                       << " at offset " << mo->getOffsetExpr(address) << "\n";
        }
      } else {
        ref<Expr> result; 
        result = os->read(mo->getOffsetExpr(address), type);
        /* SYSREL EXTENSION */
        if (!dyn_cast<ConstantExpr>(result)) {
           bool abort = false;
           ref<Expr> lresult = performLazyInit(state,address,mo->getOffsetExpr(address),
                                                                result,target,op,abort);
           if (abort) return true;
           if (!lresult.isNull())
              result = lresult;
        }
        /* SYSREL EXTENSION */
        bindLocal(target, *bound, result);
        llvm::outs() << " load result: " << result << "\n";
      }
    }

    unbound = branches.second;
    if (!unbound) {
       break;
    }
    
    if (unbound) {    
       if (InferDataConstraints)
          inferConstraintFromMemoryError(*unbound, mo, address, target, solver);
    }

  }
  
  // XXX should we distinguish out of bounds and overlapped cases?
  if (unbound) {
    if (incomplete) {
      terminateStateEarly(*unbound, "Query timed out (resolve).");
    } else {

     if (InferDataConstraints && emo)
          inferConstraintFromMemoryError(*unbound, emo, address, target, solver);

      llvm::outs() << "Offending address " << address << "\n";
      std::string s;
      llvm::raw_string_ostream ors(s);
      ors << "Memory out of bound\n";
      state.dumpStack(ors);
      llvm::outs() << ors.str() ;
      ExprPPrinter::printConstraints(llvm::outs(), state.constraints);
      terminateStateOnError(*unbound, "memory error: out of bound pointer", Ptr,
                            NULL, getAddressInfo(*unbound, address));
    }
  }
  return false;
}

ObjectState *Executor::executeMakeSymbolic(ExecutionState &state, 
                                   const MemoryObject *mo,
                                   const std::string &name,  
                                   bool forLazyInit,
                                   Type *t,
                                   bool clrFncPtr,
                                   unsigned count,
                                   llvm::Type *et, 
                                   const MemoryObject *emo,  
                                   const ObjectState *eobj, 
                                   unsigned eoffset,
                                   ref<Expr> address) {
  // Create a new object state for the memory object (instead of a copy).
  if (!replayKTest) {
    // Find a unique name for this array.  First try the original name,
    // or if that fails try adding a unique identifier.
    unsigned id = 0;
    std::string uniqueName = name;
    while (!state.arrayNames.insert(uniqueName).second) {
      uniqueName = name + "_" + llvm::utostr(++id);
    }
    const Array *array = arrayCache.CreateArray(uniqueName, mo->size);
    ObjectState *os = bindObjectInState(state, mo, false, array);
    state.addSymbolic(mo, array);
    /* SYSREL extension */
    if (forLazyInit) {
       if (clrFncPtr)
          clearFunctionPointers(mo, os, t); 
    }
    /* SYSREL extension */
    
    std::map< ExecutionState*, std::vector<SeedInfo> >::iterator it = 
      seedMap.find(&state);
    if (it!=seedMap.end()) { // In seed mode we need to add this as a
                             // binding.
      for (std::vector<SeedInfo>::iterator siit = it->second.begin(), 
             siie = it->second.end(); siit != siie; ++siit) {
        SeedInfo &si = *siit;
        KTestObject *obj = si.getNextInput(mo, NamedSeedMatching);

        if (!obj) {
          if (ZeroSeedExtension) {
            std::vector<unsigned char> &values = si.assignment.bindings[array];
            values = std::vector<unsigned char>(mo->size, '\0');
          } else if (!AllowSeedExtension) {
            terminateStateOnError(state, "ran out of inputs during seeding",
                                  User);
            break;
          }
        } else {
          if (obj->numBytes != mo->size &&
              ((!(AllowSeedExtension || ZeroSeedExtension)
                && obj->numBytes < mo->size) ||
               (!AllowSeedTruncation && obj->numBytes > mo->size))) {
	    std::stringstream msg;
	    msg << "replace size mismatch: "
		<< mo->name << "[" << mo->size << "]"
		<< " vs " << obj->name << "[" << obj->numBytes << "]"
		<< " in test\n";

            terminateStateOnError(state, msg.str(), User);
            break;
          } else {
            std::vector<unsigned char> &values = si.assignment.bindings[array];
            values.insert(values.begin(), obj->bytes, 
                          obj->bytes + std::min(obj->numBytes, mo->size));
            if (ZeroSeedExtension) {
              for (unsigned i=obj->numBytes; i<mo->size; ++i)
                values.push_back('\0');
            }
          }
        }
      }
    }
    return os;
  } else {
    ObjectState *os = bindObjectInState(state, mo, false);
    if (replayPosition >= replayKTest->numObjects) {
      terminateStateOnError(state, "replay count mismatch", User);
    } else {
      KTestObject *obj = &replayKTest->objects[replayPosition++];
      if (obj->numBytes != mo->size) {
        terminateStateOnError(state, "replay size mismatch", User);
      } else {
        for (unsigned i=0; i<mo->size; i++)
          os->write8(i, obj->bytes[i]);
      }
    }
    return os;
  }
}

/***/

/* SYSREL EXTENSION */

void Executor::clearFunctionPointers(const MemoryObject *mo, ObjectState *os, Type *at) {
    if (!InitFuncPtrs)
       return;
    llvm::StructType *st = dyn_cast<llvm::StructType>(at);
    if (st) {
       llvm::errs() << "Struct type=" << getTypeName(st) << "\n";
       const llvm::DataLayout &dl = kmodule->module->getDataLayout();
       const llvm::StructLayout *sl =  dl.getStructLayout(st);
       for(unsigned i=0; i < st->getNumElements(); i++) {
          Type *temp = st->getElementType(i);
          //llvm::errs() << "field " << i << " offset= " << sl->getElementOffset(i) << " type=" << getTypeName(temp) << " typeid=" << temp->getTypeID() << " vs " << llvm::Type::FunctionTyID << "\n";
          if (temp->isPointerTy()) {
             temp = temp->getPointerElementType(); 
             //llvm::errs() << "pointer element of field" << i << " offset= " << sl->getElementOffset(i) << " type=" << getTypeName(temp) << " typeid=" << temp->getTypeID() << " vs " << llvm::Type::FunctionTyID << "\n";
             // The second condition is to deal with a bug in the clang compiler..
             // Otherwise, some function pointers are not recognized. This may have a side effect of concretizing 
             // some of the symbolic pointers and hence preventing lazy initialization of such pointer fields..
             if (temp->isFunctionTy() || getTypeName(temp) == "{}") {
                llvm::errs() << "Setting function pointer field " << i << " of (out of " << st->getNumElements() << ")" << getTypeName(st) << "\n";
                llvm::errs() << "base addr=" << mo->getBaseExpr() << " offset " << sl->getElementOffset(i) << " type " << getTypeName(temp) << "\n";
                os->write(ConstantExpr::create(sl->getElementOffset(i), 64), Expr::createPointer(0));
             }
          }
       }       
    }
}



void Executor::constrainPath(ExecutionState &state, ref<Expr> &e) {
  llvm::errs() << "Constraining path with " << e << "\n";
  bool res;
  bool success __attribute__ ((unused)) = solver->mustBeFalse(state, e, res);
  assert(success && "FIXME: Unhandled solver failure");
  if (res) {
     terminateStateOnError(state,
                                     "invalid klee_assume call (provably false)",
                                     Executor::User);
  } else {
       addConstraint(state, e);
  }
}

void Executor::constrainPath(ExecutionState &state, ref<Expr> &e, int value) {
   ref<Expr> eqe = EqExpr::create(e, ConstantExpr::create(value, e->getWidth()));
   constrainPath(state, eqe);
}

void Executor::constrainPath(ExecutionState &state, MemoryObject *mo, ObjectState *sos, std::string value, bool nullTerm = true) {
     if (value.size() == 0) {
        return;
     }
     unsigned size = value.size();
     if (size > mo->size) {
        if (!nullTerm)
           size = mo->size;
        else size = mo->size - 1;
     }
     else if (size == mo->size && nullTerm)
        size--;
     ref<Expr> result;
     unsigned i=0;
     for(; i<size; i++)  {
        ref<Expr> be = sos->read(ConstantExpr::alloc(i, Expr::Int64), 8); 
        ref<Expr> eqbe = EqExpr::create(be, ConstantExpr::alloc(value[i], Expr::Int8));
        if (result.isNull())
           result = eqbe;        
        else 
           result = AndExpr::create(result, eqbe);
     }
     if (nullTerm) {  
        // add the null character
        ref<Expr> be = sos->read(ConstantExpr::alloc(i, Expr::Int64), 8); 
        ref<Expr> eqbe = EqExpr::create(be, ConstantExpr::alloc(0, Expr::Int8));
        if (result.isNull())
           result = eqbe;        
        else 
           result = AndExpr::create(result, eqbe);
     }
     constrainPath(state, result);
}

void Executor::constrainPath(ExecutionState &state, std::string fname, int argno, MemoryObject *mo, ObjectState *sos, ref<Expr> &e) { 
   if (argConstrainMap.find(fname) != argConstrainMap.end()) 
      if (argConstrainMap[fname].find(argno) != argConstrainMap[fname].end()) {
         if (argConstrainMap[fname][argno].type == ConstrainValue_t::INT_TYPE)
            constrainPath(state, e, argConstrainMap[fname][argno].ival);
         else if (argConstrainMap[fname][argno].type == ConstrainValue_t::STRING_TYPE)
           constrainPath(state, mo, sos, argConstrainMap[fname][argno].sval);
      }                  
}


void Executor::initArgsAsSymbolic(ExecutionState &state, Function *entryFunc, bool &abort, bool nosym) {
   KFunction *kf = kmodule->functionMap[entryFunc];
   unsigned int ind = 0;
   LLVMContext &ctx = moduleHandle->getContext();
   std::map<unsigned, std::pair<MemoryObject*,ObjectState*> > argObjs;
   std::map<unsigned, unsigned> argSizes;
   for(llvm::Function::arg_iterator ai = entryFunc->arg_begin(); ai != entryFunc->arg_end(); ai++) {
     Type *at = ai->getType();
     std::string type_str;
     llvm::raw_string_ostream rso(type_str);
     at->print(rso);
     if (at->isPointerTy()) {
        llvm::outs() << "arg " << ind << " type " << rso.str() << "\n";
        at = at->getPointerElementType();
        bool singleInstance = false;
        int count = 1; // force symbolic init of pointers to array types
        bool lazyInitT = isAllocTypeLazyInit(at, singleInstance, count);
        if (lazyInitT) {
              int argSize = getInitArgArraySize(entryFunc->getName(),ind);
              if (argSize > 0) {
                 llvm::errs() << "Argument no " << ind 
                              << " of function " << entryFunc->getName() 
                              << " is created to be size " << argSize << "\n";
                 count = argSize;
              }
              // We now handle all these individual cases in a uniform way!!!
              ref<Expr> laddr;
              llvm::Type *rType;
              bool mksym;
              std::map<unsigned, unsigned>  m;
              if (funcSpecificArrayFieldSize.find(entryFunc->getName()) != 
                           funcSpecificArrayFieldSize.end())
                 m = funcSpecificArrayFieldSize[entryFunc->getName()];
              if (m.find(ind) != m.end()) {
                 count = m[ind];
                 llvm::errs() << "using specific size " << count << "for lazy init of " 
                              << entryFunc->getName() << " arg " << ind << "\n";   
              }
              const MemoryObject *mo = memory->allocateLazyForTypeOrEmbedding(state, 
                            state.prevPC->inst, at, at, singleInstance, 
                              count, rType, laddr, mksym, abort);
              if (abort) return;
              llvm::outs() << "Symbolizing arg of " << entryFunc->getName() << ", address " << mo->getBaseExpr() << "\n";
              //mo = memory->allocateForLazyInit(state, state.prevPC->inst, at, singleInstance, count, laddr);
              llvm::outs() << "is arg " << ind <<  " type " << rso.str() << " single instance? " << singleInstance << "\n";
              llvm::outs() << "to be made symbolic? " << mksym << "\n";
              mo->name = state.getUnique(entryFunc->getName().str() + std::string("_arg_") + std::to_string(ind));
              if (!nosym && mksym) {
                 ObjectState *mos = executeMakeSymbolic(state, mo, 
                                     entryFunc->getName().str() + 
                                           std::string("_arg_") + 
                                                std::to_string(ind),
                                     true, at, true, count);
 
                 // first simple equalities get applied..
                 applyDataConstraintToArray(state, solver, mo, mos,0, count, true); 
                 // then other constraints
                 applyDataConstraintToArray(state, solver, mo, mos,0, count, false); 

                 if (state.terminated) {
                    terminateStateEarly(state, "Inconsinstency during lazy initialization\n"); 
                    return;
                 }

                 // the old interface for API model specs
                 applyCommandlineSpecInitializationsToArray(state, solver, mo, mos, rType, count);

              }
              llvm::errs() << "Address of lazy allocated arg " << laddr << "\n";
              bindArgument(kf, ind, state, laddr);
              llvm::outs() << "binding arg " << ind << " of type " << rso.str() << " to address " << laddr << 
                                                                " (in " << mo->getBaseExpr() << ")\n";
              argSizes[ind] = count; 
           //}
        }
        else llvm::outs() << "skipping lazy init for " << rso.str() << "\n";
     } 
     else {
        size_t allocationAlignment = 8;
        Instruction *inst = &*(entryFunc->begin()->begin());
        const llvm::DataLayout & dl = inst->getParent()->getParent()->getParent()->getDataLayout();
        size_t allocsize;
        if (!at->isSized()) {
           allocsize =  SIZE_FOR_UNTYPED;
           at = Type::getInt8Ty(ctx);
        }
        else 
           allocsize = dl.getTypeAllocSize(at); 
        MemoryObject *mo =  memory->allocate(allocsize, false, /*true*/false, inst, 
                                   allocationAlignment, 1, at);
        recordMemObj(state, mo);
        mo->name = state.getUnique(entryFunc->getName().str()) + std::string("_arg_") + std::to_string(ind);
        std::string uniqueName = mo->name;
        // we're mimicking what executeMemoryOperation do without a relevant load or store instruction
        const Array *array = arrayCache.CreateArray(uniqueName, mo->size);
        ObjectState *sos = bindObjectInState(state, mo, true, array);
        ref<Expr> result = sos->read(ConstantExpr::alloc(0, Expr::Int64), getWidthForLLVMType(at));         
        llvm::errs() << "Content of lazy allocated arg " << result << "\n";
        ref<Expr> dummy = result;
        bindArgument(kf, ind, state, result);
        constrainPath(state, entryFunc->getName().str(), ind, mo, sos, result);
        // the old interface for API model specs
        applyCommandlineSpecInitializationsToArray(state, solver, mo, sos, at, 1);
        llvm::outs() << "binding nonpointer arg " << ind << " of type " << rso.str() << " to value " << result << "\n"; 
        std::pair<MemoryObject*,ObjectState*> p = std::make_pair(mo,sos);
        argObjs[ind] = p;
        argSizes[ind] = 1;
     }     
     ind++; 
   }
   std::string sname = simplifyName(entryFunc->getName().str());
   if (funcArgConstraintMap.find(sname) != funcArgConstraintMap.end()) {
      std::vector<BoundAST> bv = funcArgConstraintMap[sname];
      for(unsigned bi=0; bi<bv.size(); bi++) {
         if (isSimpleEquality(bv[bi])) {
            ref<Expr> value = NULL;
            int index=-1;
            applyEquality(bv[bi], entryFunc, argObjs, argSizes, value, index);
            bindArgument(kf, index, state, value); 
         }
         else {
            ref<Expr> cexp = generateExp(bv[bi], entryFunc, argObjs, argSizes, NULL);
            bool result;
            bool success = solver->mayBeTrue(state, cexp, result);
            assert(success && "Solver failure during consistency checking!");
            if (result) {
               llvm::errs() << "generated exp: " << cexp << "\n";
               addConstraint(state,cexp);
            }
            else {
               state.terminated = true;
               terminateStateEarly(state, "Inconsinstency during lazy initialization\n"); 
            }
         }
      }
   } 
}

/* SYSREL EXTENSION */

/***/

void detectFuncsWithInlineAssembly(Module *m) {
  for(Module::iterator mi = m->begin(); mi != m->end(); mi++) {
    for (Function::iterator fi = (*mi).begin(); 
              fi != (*mi).end(); fi++) {
        for (BasicBlock::iterator bi = (*fi).begin(); 
                  bi != (*fi).end(); bi++) {
            if ((*bi).getOpcode() == Instruction::Call) {
               CallSite cs(&(*bi));
               Value *fp = cs.getCalledValue();
               if (isa<InlineAsm>(fp)) {
                  std::string fn = removeDotSuffix((*mi).getName());
                  if (enforceOrig.find(fn) != enforceOrig.end()) {
                     llvm::errs() << "WARNING: function " << fn << " will NOT be modeled as specified!\n"; 
                  }
                  else {
                     bool found = false;
                     for(auto ptp : enforceOrigPatternWExceptions) { 
                       if (fn.find(ptp.first) != std::string::npos) {
                          std::set<std::string> exceptions = ptp.second;
                          if (exceptions.find(fn) == exceptions.end()) {
                             llvm::errs() << "WARNING: function " << fn << " will NOT be modeled as specified as a pattern!\n"; 
                             found = true;
                             break;
                          }
                       } 
                     }
                     if (!found) {
                        llvm::errs() << "WARNING: function " << fn << " is modeled due to inline assembly!\n";
                        APIHandler::addIgnoreHandler(fn);
                        assert(APIHandler::handles(fn));
                     }
                  }
               }
            }
        }
    }
  }
}

void Executor::runFunctionAsMain(Function *f,
				 int argc,
				 char **argv,
				 char **envp) {

  /* SYSREL EXTENSION */
  entryFunc = f;
  if (ModelFuncWithInlineASM)
     detectFuncsWithInlineAssembly(kmodule->module);
  /* SYSREL EXTENSION */

  std::vector<ref<Expr> > arguments;

  // force deterministic initialization of memory objects
  srand(1);
  srandom(1);
  
  MemoryObject *argvMO = 0;

  // In order to make uclibc happy and be closer to what the system is
  // doing we lay out the environments at the end of the argv array
  // (both are terminated by a null). There is also a final terminating
  // null that uclibc seems to expect, possibly the ELF header?

  int envc;
  for (envc=0; envp[envc]; ++envc) ;

  llvm::outs() << "num args " << argc << " num envc " << envc << "\n";

  unsigned NumPtrBytes = Context::get().getPointerWidth() / 8;
  KFunction *kf = kmodule->functionMap[f];
  assert(kf);
  Function::arg_iterator ai = f->arg_begin(), ae = f->arg_end();
  LLVMContext &ctx = kmodule->module->getContext();
 /* SYSREL extension to handle entry points with more than 3 args */ 
 if (!lazyInit) {
 /* SYSREL extension end */
  if (ai!=ae) {
    arguments.push_back(ConstantExpr::alloc(argc, Expr::Int32));
    if (++ai!=ae) {
      Instruction *first = &*(f->begin()->begin());
      argvMO =
          memory->allocate((argc + 1 + envc + 1 + 1) * NumPtrBytes,
                           /*isLocal=*/false, /*isGlobal=*/true,
                           /*allocSite=*/first, /*alignment=*/8,
                           (argc + 1 + envc + 1 + 1) * NumPtrBytes, 
                           Type::getInt8Ty(ctx));
      if (!argvMO)
        klee_error("Could not allocate memory for function arguments");

      arguments.push_back(argvMO->getBaseExpr());

      if (++ai!=ae) {
        uint64_t envp_start = argvMO->address + (argc+1)*NumPtrBytes;
        arguments.push_back(Expr::createPointer(envp_start));

        if (++ai!=ae)
          klee_error("invalid main function (expect 0-3 arguments)");
      }
    }
  }
  }
  

  llvm::errs() << "before creating the initial state:\n";
  llvm::errs() << "malloc usage: " << util::GetTotalMallocUsage() << "\n";
  llvm::errs() << "executor memory: " << memory->getUsedDeterministicSize() << "\n";

  ExecutionState *state = new ExecutionState(kmodule->functionMap[f]);
  
  llvm::errs() << "after creating the initial state:\n";
  llvm::errs() << "malloc usage: " << util::GetTotalMallocUsage() << "\n";
  llvm::errs() << "executor memory: " << memory->getUsedDeterministicSize() << "\n";


  if (pathWriter) 
    state->pathOS = pathWriter->open();
  if (symPathWriter) 
    state->symPathOS = symPathWriter->open();


  if (statsTracker)
    statsTracker->framePushed(*state, 0);

 /* SYSREL extension to handle entry points with more than 3 args */ 
 if (!lazyInit) 
 /* SYSREL extension end */  
  assert(arguments.size() == f->arg_size() && "wrong number of arguments");

  /* SYSREL EXTENSION */
  if (lazyInit) {
     // to avoid memory out of bound errors due to lazy init of void pointers
     // currently relies on the input model
     // TODO: scan the code to find bitcasts and maximum possible target type size
     computeMaxVoidTypeCastSize(); 
     /// visit all struct types in this module
     llvm::TypeFinder StructTypes;
     StructTypes.run(*(kmodule->module), true);
     for (auto *STy : StructTypes) {
         std::set<std::string> temp;
         collectEmbeddedPointerTypes(STy, lazyInits, temp);
     }

     // visit parameter types of all functions in this module 
     for(llvm::Module::iterator fc = kmodule->module->begin(); fc != kmodule->module->end(); fc++) {
        for(llvm::Function::arg_iterator ai = fc->arg_begin(); ai != fc->arg_end(); ai++) {
           if (lazyInit) {
              std::set<std::string> temp;
              collectEmbeddedPointerTypes(ai->getType(), lazyInits, temp);
           }
        }
     }

     for (auto *STy : StructTypes) {
       for(unsigned i=0; i < STy->getNumElements(); i++) {
           Type *et = STy->getElementType(i);
           if (!et->isPointerTy()) {
              StructType *est = dyn_cast<StructType>(et);
              if (est) {
                 embeddedTypes.insert(et);
                 std::set<Type*> embeddings;
                 if (embeddingTypes.find(et) != embeddingTypes.end())
                     embeddings = embeddingTypes[et]; 
                 embeddings.insert(STy);
                 embeddingTypes[et] = embeddings;             
                 llvm::outs() << getTypeName(et) << " is an embedded type, embedded by " << getTypeName(STy) << "\n"; 
              }
           }
       }
     }

  }

  llvm::errs() << "afterprocessing the embedded types:\n";
  llvm::errs() << "malloc usage: " << util::GetTotalMallocUsage() << "\n";
  llvm::errs() << "executor memory: " << memory->getUsedDeterministicSize() << "\n";


  /* SYSREL EXTENSION */

 /* SYSREL extension to handle entry points with more than 3 args */ 
 if (!lazyInit) {
 /* SYSREL extension end */
  for (unsigned i = 0, e = f->arg_size(); i != e; ++i) {
    bindArgument(kf, i, *state, arguments[i]);
  }
 }

  if (argvMO) {
    ObjectState *argvOS = bindObjectInState(*state, argvMO, false);
    LLVMContext &ctx = moduleHandle->getContext();
    for (int i=0; i<argc+1+envc+1+1; i++) {
      if (i==argc || i>=argc+1+envc) {
        // Write NULL pointer
        argvOS->write(i * NumPtrBytes, Expr::createPointer(0));
      } else {
        char *s = i<argc ? argv[i] : envp[i-(argc+1)];
        int j, len = strlen(s);

        MemoryObject *arg =
            memory->allocate(len + 1, /*isLocal=*/false, /*isGlobal=*/true,
                             /*allocSite=*/state->pc->inst, /*alignment=*/8, 
                             len + 1, Type::getInt8Ty(ctx));
        if (!arg)
          klee_error("Could not allocate memory for function arguments");
        recordMemObj(*state, arg);

        ObjectState *os = bindObjectInState(*state, arg, false);
        for (j=0; j<len+1; j++)
          os->write8(j, s[j]);

        // Write pointer to newly allocated and initialised argv/envp c-string
        argvOS->write(i * NumPtrBytes, arg->getBaseExpr());
      }
    }
  }
  

  llvm::errs() << "before initializing globals:\n";
  llvm::errs() << "malloc usage: " << util::GetTotalMallocUsage() << "\n";
  llvm::errs() << "executor memory: " << memory->getUsedDeterministicSize() << "\n";


  initializeGlobals(*state);


  llvm::errs() << "after initializing globals:\n";
  llvm::errs() << "malloc usage: " << util::GetTotalMallocUsage() << "\n";
  llvm::errs() << "executor memory: " << memory->getUsedDeterministicSize() << "\n";


  /* SYSREL EXTENSION */
  staticAllocStatTracking = false;
  /* SYSREL EXTENSION */
  processTree = new PTree(state);
  state->ptreeNode = processTree->root;
  /* SYSREL extension */
  // the very first state should be constructed according to the first step of life-cycle model, in other words initialize
  if (state->hasLCM())
     state->updateLCMState();
  if (lazyInit) {
   // Lazy init args of the entryFunc
   bool abort = false;
   initArgsAsSymbolic(*state, entryFunc, abort);
   assert(!abort);
  }
  /* SYSREL extension */

  llvm::errs() << "before starting symex:\n";
  llvm::errs() << "malloc usage: " << util::GetTotalMallocUsage() << "\n";
  llvm::errs() << "executor memory: " << memory->getUsedDeterministicSize() << "\n";


  run(*state);
  delete processTree;
  processTree = 0;

  // hack to clear memory objects
  delete memory;
  memory = new MemoryManager(NULL);

  globalObjects.clear();
  globalAddresses.clear();
  /* SYSREL extension */ 
  globalAddressesRev.clear();
  /* SYSREL extension */ 
  

  if (statsTracker)
    statsTracker->done();
}

unsigned Executor::getPathStreamID(const ExecutionState &state) {
  assert(pathWriter);
  return state.pathOS.getID();
}

unsigned Executor::getSymbolicPathStreamID(const ExecutionState &state) {
  assert(symPathWriter);
  return state.symPathOS.getID();
}

void Executor::getConstraintLog(const ExecutionState &state, std::string &res,
                                Interpreter::LogType logFormat) {

  switch (logFormat) {
  case STP: {
    Query query(state.constraints, ConstantExpr::alloc(0, Expr::Bool));
    char *log = solver->getConstraintLog(query);
    res = std::string(log);
    free(log);
  } break;

  case KQUERY: {
    std::string Str;
    llvm::raw_string_ostream info(Str);
    ExprPPrinter::printConstraints(info, state.constraints);
    res = info.str();
  } break;

  case SMTLIB2: {
    std::string Str;
    llvm::raw_string_ostream info(Str);
    ExprSMTLIBPrinter printer;
    printer.setOutput(info);
    Query query(state.constraints, ConstantExpr::alloc(0, Expr::Bool));
    printer.setQuery(query);
    printer.generateOutput();
    res = info.str();
  } break;

  default:
    klee_warning("Executor::getConstraintLog() : Log format not supported!");
  }
}

bool Executor::getSymbolicSolution(const ExecutionState &state,
                                   std::vector< 
                                   std::pair<std::string,
                                   std::vector<unsigned char> > >
                                   &res) {
  solver->setTimeout(coreSolverTimeout);

  ExecutionState tmp(state);

  // Go through each byte in every test case and attempt to restrict
  // it to the constraints contained in cexPreferences.  (Note:
  // usually this means trying to make it an ASCII character (0-127)
  // and therefore human readable. It is also possible to customize
  // the preferred constraints.  See test/Features/PreferCex.c for
  // an example) While this process can be very expensive, it can
  // also make understanding individual test cases much easier.
  for (unsigned i = 0; i != state.symbolics.size(); ++i) {
    const MemoryObject *mo = state.symbolics[i].first;
    std::vector< ref<Expr> >::const_iterator pi = 
      mo->cexPreferences.begin(), pie = mo->cexPreferences.end();
    for (; pi != pie; ++pi) {
      bool mustBeTrue;
      // Attempt to bound byte to constraints held in cexPreferences
      bool success = solver->mustBeTrue(tmp, Expr::createIsZero(*pi), 
					mustBeTrue);
      // If it isn't possible to constrain this particular byte in the desired
      // way (normally this would mean that the byte can't be constrained to
      // be between 0 and 127 without making the entire constraint list UNSAT)
      // then just continue on to the next byte.
      if (!success) break;
      // If the particular constraint operated on in this iteration through
      // the loop isn't implied then add it to the list of constraints.
      if (!mustBeTrue) tmp.addConstraint(*pi);
    }
    if (pi!=pie) break;
  }

  std::vector< std::vector<unsigned char> > values;
  std::vector<const Array*> objects;
  for (unsigned i = 0; i != state.symbolics.size(); ++i)
    objects.push_back(state.symbolics[i].second);
  bool success = solver->getInitialValues(tmp, objects, values);
  solver->setTimeout(0);
  if (!success) {
    klee_warning("unable to compute initial values (invalid constraints?)!");
    ExprPPrinter::printQuery(llvm::errs(), state.constraints,
                             ConstantExpr::alloc(0, Expr::Bool));
    return false;
  }
  
  for (unsigned i = 0; i != state.symbolics.size(); ++i)
    res.push_back(std::make_pair(state.symbolics[i].first->name, values[i]));
  return true;
}

void Executor::getCoveredLines(const ExecutionState &state,
                               std::map<const std::string*, std::set<unsigned> > &res) {
  res = state.coveredLines;
}

void Executor::doImpliedValueConcretization(ExecutionState &state,
                                            ref<Expr> e,
                                            ref<ConstantExpr> value) {
  abort(); // FIXME: Broken until we sort out how to do the write back.

  if (DebugCheckForImpliedValues)
    ImpliedValue::checkForImpliedValues(solver->solver, e, value);

  ImpliedValueList results;
  ImpliedValue::getImpliedValues(e, value, results);
  for (ImpliedValueList::iterator it = results.begin(), ie = results.end();
       it != ie; ++it) {
    ReadExpr *re = it->first.get();
    
    if (ConstantExpr *CE = dyn_cast<ConstantExpr>(re->index)) {
      // FIXME: This is the sole remaining usage of the Array object
      // variable. Kill me.
      const MemoryObject *mo = 0; //re->updates.root->object;
      const ObjectState *os = state.addressSpace.findObject(mo);

      if (!os) {
        // object has been free'd, no need to concretize (although as
        // in other cases we would like to concretize the outstanding
        // reads, but we have no facility for that yet)
      } else {
        assert(!os->readOnly && 
               "not possible? read only object with static read?");
        ObjectState *wos = state.addressSpace.getWriteable(mo, os);
        wos->write(CE, it->second);
      }
    }
  }
}

Expr::Width Executor::getWidthForLLVMType(llvm::Type *type) const {
  return kmodule->targetData->getTypeSizeInBits(type);
}

size_t Executor::getAllocationAlignment(const llvm::Value *allocSite) const {
  // FIXME: 8 was the previous default. We shouldn't hard code this
  // and should fetch the default from elsewhere.
  const size_t forcedAlignment = 8;
  size_t alignment = 0;
  llvm::Type *type = NULL;
  std::string allocationSiteName(allocSite->getName().str());
  if (const GlobalValue *GV = dyn_cast<GlobalValue>(allocSite)) {
    alignment = GV->getAlignment();
    if (const GlobalVariable *globalVar = dyn_cast<GlobalVariable>(GV)) {
      // All GlobalVariables's have pointer type
      llvm::PointerType *ptrType =
          dyn_cast<llvm::PointerType>(globalVar->getType());
      assert(ptrType && "globalVar's type is not a pointer");
      type = ptrType->getElementType();
    } else {
      type = GV->getType();
    }
  } else if (const AllocaInst *AI = dyn_cast<AllocaInst>(allocSite)) {
    alignment = AI->getAlignment();
    type = AI->getAllocatedType();
  } else if (isa<InvokeInst>(allocSite) || isa<CallInst>(allocSite)) {
    // FIXME: Model the semantics of the call to use the right alignment
    llvm::Value *allocSiteNonConst = const_cast<llvm::Value *>(allocSite);
    const CallSite cs = (isa<InvokeInst>(allocSiteNonConst)
                             ? CallSite(cast<InvokeInst>(allocSiteNonConst))
                             : CallSite(cast<CallInst>(allocSiteNonConst)));
    llvm::Function *fn =
        klee::getDirectCallTarget(cs, /*moduleIsFullyLinked=*/true);
    if (fn)
      allocationSiteName = fn->getName().str();

    klee_warning_once(fn != NULL ? fn : allocSite,
                      "Alignment of memory from call \"%s\" is not "
                      "modelled. Using alignment of %zu.",
                      allocationSiteName.c_str(), forcedAlignment);
    alignment = forcedAlignment;
  } else {
    llvm_unreachable("Unhandled allocation site");
  }

  if (alignment == 0) {
    assert(type != NULL);
    // No specified alignment. Get the alignment for the type.
    if (type->isSized()) {
      alignment = kmodule->targetData->getPrefTypeAlignment(type);
    } else {
      klee_warning_once(allocSite, "Cannot determine memory alignment for "
                                   "\"%s\". Using alignment of %zu.",
                        allocationSiteName.c_str(), forcedAlignment);
      alignment = forcedAlignment;
    }
  }

  // Currently we require alignment be a power of 2
  if (!bits64::isPowerOfTwo(alignment)) {
    klee_warning_once(allocSite, "Alignment of %zu requested for %s but this "
                                 "not supported. Using alignment of %zu",
                      alignment, allocSite->getName().str().c_str(),
                      forcedAlignment);
    alignment = forcedAlignment;
  }
  assert(bits64::isPowerOfTwo(alignment) &&
         "Returned alignment must be a power of two");
  return alignment;
}

void Executor::prepareForEarlyExit() {
  if (statsTracker) {
    // Make sure stats get flushed out
    statsTracker->done();
  }
}

/// Returns the errno location in memory
int *Executor::getErrnoLocation(const ExecutionState &state) const {
#ifndef __APPLE__
  /* From /usr/include/errno.h: it [errno] is a per-thread variable. */
  return __errno_location();
#else
  return __error();
#endif
}

///

Interpreter *Interpreter::create(LLVMContext &ctx, const InterpreterOptions &opts,
                                 InterpreterHandler *ih) {
  return new Executor(ctx, opts, ih);
}
