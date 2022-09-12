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
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/TypeBuilder.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/Process.h"
#include "llvm/Support/raw_ostream.h"

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


extern  cl::opt<unsigned> MaxForks;

namespace klee {
 extern  RNG theRNG;
}

/* begin SYSREL extension */
extern const Module * moduleHandle;
extern bool isAsyncInitiate(std::string name);
extern bool isAsync(std::string name);
extern std::string getAsyncFunction(std::string fn);

extern bool lazyInit;
extern bool lazySpec;
extern int numLazyInst;
extern std::vector<std::string> lazyInits;
extern std::set<std::string> lazyInitSingles;
extern std::map<std::string, int> lazyInitNumInstances;

extern bool isLazyInit(Type *t, bool &single, int &count);
bool isLazySingle(Type *t, std::string pointertype="**");
extern bool isAllocTypeLazyInit(Type *t, bool &single, int &count);
extern APIHandler *apiHandler;
/*
extern RegistrationAPIHandler  *regAPIHandler;
extern ResourceAllocReleaseAPIHandler *resADAPIHandler;
extern MutexAPIHandler*  mutexAPIHandler;
extern RefCountAPIHandler *refcountAPIHandler;
extern SetGetAPIHandler *setgetAPIHandler;
extern AllocAPIHandler *allocAPIHandler;
extern FreeAPIHandler *freeAPIHandler;
extern ReadWriteAPIHandler *readWriteAPIHandler;
extern IgnoreAPIHandler *ignoreAPIHandler;
extern CallbackAPIHandler *callbackAPIHandler;
extern SideEffectAPIHandler *sideEffectAPIHandler;
*/
extern bool progModel;
extern std::string getTypeName(Type *t);
/* end SYSREL extension */

//extern const llvm::fltSemantics * fpWidthToSemantics(unsigned width);
extern  cl::opt<bool> OnlyReplaySeeds;
extern  cl::opt<double> MaxStaticForkPct;
extern  cl::opt<double> MaxStaticSolvePct;
extern  cl::opt<double> MaxStaticCPForkPct;
extern  cl::opt<double> MaxStaticCPSolvePct;
extern  cl::opt<unsigned> MaxDepth;
extern  cl::opt<unsigned> MaxMemory;
extern  cl::opt<bool> MaxMemoryInhibit;
extern  cl::opt<unsigned long long> StopAfterNInstructions;
extern  cl::opt<bool> OnlyOutputStatesCoveringNew; 
extern  cl::opt<bool> AlwaysOutputSeeds;
extern  cl::opt<bool> EmitAllErrors;
extern  cl::opt<bool> NoExternals;
extern  cl::opt<bool> AllowExternalSymCalls;
extern  cl::opt<bool> SuppressExternalWarnings;
extern  cl::opt<bool> AllExternalWarnings;
extern  cl::opt<bool> SimplifySymIndices;
extern  cl::opt<unsigned> MaxSymArraySize;
extern    cl::opt<bool>
NamedSeedMatching;
extern   cl::opt<bool>
  ZeroSeedExtension;
 
extern   cl::opt<bool>
  AllowSeedTruncation;

extern   cl::opt<bool>
AllowSeedExtension;
 
extern bool isDebugIntrinsic(const Function *f, KModule *KM);

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

MemoryObject * Executor::addExternalObjectThread(ExecutionState &state, 
                                           void *addr, unsigned size, 
                                           bool isReadOnly, int tid) {
  MemoryObject *mo = memory->allocateFixed((uint64_t) (unsigned long) addr, 
                                           size, 0);
  ObjectState *os = bindObjectInStateThread(state, mo, false, 0, tid);
  for(unsigned i = 0; i < size; i++)
    os->write8(i, ((uint8_t*)addr)[i]);
  if(isReadOnly)
    os->setReadOnly(true);  
  return mo;
}

void Executor::branchThread(ExecutionState &state, 
                      const std::vector< ref<Expr> > &conditions,
                      std::vector<ExecutionState*> &result, int tid) {
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
          terminateStateThread(*result[i], tid);
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
Executor::forkThread(ExecutionState &current, ref<Expr> condition, bool isInternal, int tid) {
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
    current.threads[tid].pc = current.threads[tid].prevPC;
    terminateStateEarlyThread(current, "Query timed out (fork).", tid);
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
        } else  {
          res = Solver::False;
          addConstraint(current, Expr::createIsZero(condition));
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
        } else {
          addConstraint(current, Expr::createIsZero(condition));
          res = Solver::False;
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
    addConstraint(*falseState, Expr::createIsZero(condition));

    // Kinda gross, do we even really still want this option?
    if (MaxDepth && MaxDepth<=trueState->depth) {
      terminateStateEarlyThread(*trueState, "max-depth exceeded.", tid);
      terminateStateEarlyThread(*falseState, "max-depth exceeded.", tid);
      return StatePair(0, 0);
    }

    return StatePair(trueState, falseState);
  }
}



const Cell& Executor::evalThread(KInstruction *ki, unsigned index, 
                           ExecutionState &state, int tid) const {
  llvm::outs() << "evalThread, index=" << index << " should be < " << ki->inst->getNumOperands() << "\n";
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
    llvm::outs() << "current stack size for thread " << tid << " is " << state.threads[tid].stack.size() << "\n"; 
    StackFrame &sf = state.threads[tid].stack.back();
    return sf.locals[index];
  }
}

void Executor::bindLocalThread(KInstruction *target, ExecutionState &state, 
                         ref<Expr> value, int tid) {
  getDestCellThread(state, target, tid).value = value;
}

void Executor::bindArgumentThread(KFunction *kf, unsigned index, 
				  ExecutionState &state, ref<Expr> value, int tid) {
  getArgumentCellThread(state, kf, index, tid).value = value;
}


void Executor::stepInstructionThread(ExecutionState &state, int tid) {
 
  llvm::outs() << "step instruction thread " << tid << "\n";

  printDebugInstructions(state);
  if (statsTracker)
    statsTracker->stepInstructionThread(state, tid);

  ++stats::instructions;
  state.threads[tid].prevPC = state.threads[tid].pc;
  ++state.threads[tid].pc;

  if (stats::instructions==StopAfterNInstructions)
    haltExecution = true;
}

void Executor::executeCallThread(ExecutionState &state, 
                           KInstruction *ki,
                           Function *f,
                           std::vector< ref<Expr> > &arguments, int tid) {
  Instruction *i = ki->inst;
  if (f && f->isDeclaration()) {
    switch(f->getIntrinsicID()) {
    case Intrinsic::not_intrinsic:
      // state may be destroyed by this call, cannot touch
      callExternalFunctionThread(state, ki, f, arguments, tid);
      break;
        
      // va_arg is handled by caller and intrinsic lowering, see comment for
      // ExecutionState::varargs
    case Intrinsic::vastart:  {
      StackFrame &sf = state.threads[tid].stack.back();

      // varargs can be zero if no varargs were provided
      if (!sf.varargs)
        return;

      // FIXME: This is really specific to the architecture, not the pointer
      // size. This happens to work for x86-32 and x86-64, however.
      Expr::Width WordSize = Context::get().getPointerWidth();
      if (WordSize == Expr::Int32) {
        executeMemoryOperationThread(state, true, arguments[0], 
                               sf.varargs->getBaseExpr(), 0, tid);
      } else {
        assert(WordSize == Expr::Int64 && "Unknown word size!");

        // x86-64 has quite complicated calling convention. However,
        // instead of implementing it, we can do a simple hack: just
        // make a function believe that all varargs are on stack.
        executeMemoryOperationThread(state, true, arguments[0],
                               ConstantExpr::create(48, 32), 0, tid); // gp_offset
        executeMemoryOperationThread(state, true,
                               AddExpr::create(arguments[0], 
                                               ConstantExpr::create(4, 64)),
                               ConstantExpr::create(304, 32), 0, tid); // fp_offset
        executeMemoryOperationThread(state, true,
                               AddExpr::create(arguments[0], 
                                               ConstantExpr::create(8, 64)),
                               sf.varargs->getBaseExpr(), 0, tid); // overflow_arg_area
        executeMemoryOperationThread(state, true,
                               AddExpr::create(arguments[0], 
                                               ConstantExpr::create(16, 64)),
                               ConstantExpr::create(0, 64), 0, tid); // reg_save_area
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
      transferToBasicBlockThread(ii->getNormalDest(), i->getParent(), state, tid);
  } else {
    // FIXME: I'm not really happy about this reliance on prevPC but it is ok, I
    // guess. This just done to avoid having to pass KInstIterator everywhere
    // instead of the actual instruction, since we can't make a KInstIterator
    // from just an instruction (unlike LLVM).
    KFunction *kf = kmodule->functionMap[f];
    state.pushFrameThread(state.threads[tid].prevPC, kf, tid);
    state.threads[tid].pc = kf->instructions;

    if (statsTracker)
      statsTracker->framePushedThread(state, &state.threads[tid].stack[state.threads[tid].stack.size()-2], tid);

     // TODO: support "byval" parameter attribute
     // TODO: support zeroext, signext, sret attributes

    unsigned callingArgs = arguments.size();
    unsigned funcArgs = f->arg_size();
    if (!f->isVarArg()) {
      if (callingArgs > funcArgs) {
        klee_warning_once(f, "calling %s with extra arguments.", 
                          f->getName().data());
      } else if (callingArgs < funcArgs) {
        terminateStateOnErrorThread(state, "calling function with too few arguments", User,  NULL, "", tid);
        return;
      }
    } else {
      Expr::Width WordSize = Context::get().getPointerWidth();

      if (callingArgs < funcArgs) {
        terminateStateOnErrorThread(state, "calling function with too few arguments",
				    User, NULL, "", tid);
        return;
      }

      StackFrame &sf = state.threads[tid].stack.back();
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
             size = llvm::RoundUpToAlignment(size, 16);
             requires16ByteAlignment = true;
          }
          size += llvm::RoundUpToAlignment(argWidth, WordSize) / 8;
        }
      }

      MemoryObject *mo = sf.varargs =
          memory->allocate(size, true, false, state.threads[tid].prevPC->inst,
                           (requires16ByteAlignment ? 16 : 8));
      if (!mo && size) {
        terminateStateOnExecErrorThread(state, "out of memory (varargs)", "", tid);
        return;
      }

      if (mo) {
        if ((WordSize == Expr::Int64) && (mo->address & 15) &&
            requires16ByteAlignment) {
          // Both 64bit Linux/Glibc and 64bit MacOSX should align to 16 bytes.
          klee_warning_once(
              0, "While allocating varargs: malloc did not align to 16 bytes.");
        }

        ObjectState *os = bindObjectInStateThread(state, mo, true, 0, tid);
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
              offset = llvm::RoundUpToAlignment(offset, 16);
            }
            os->write(offset, arguments[i]);
            offset += llvm::RoundUpToAlignment(argWidth, WordSize) / 8;
          }
        }
      }
    }

    unsigned numFormals = f->arg_size();
    for (unsigned i=0; i<numFormals; ++i) 
      bindArgumentThread(kf, i, state, arguments[i], tid);
  }
}

void Executor::transferToBasicBlockThread(BasicBlock *dst, BasicBlock *src, 
                                    ExecutionState &state, int tid) {
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

  //llvm::outs() << "trnsfertobasic block stack size " << state.threads[tid].stack.size() << "\n"; 
  KFunction *kf = state.threads[tid].stack.back().kf;
  unsigned entry = kf->basicBlockEntry[dst];
  state.threads[tid].pc = &kf->instructions[entry];
  if (state.threads[tid].pc->inst->getOpcode() == Instruction::PHI) {
    PHINode *first = static_cast<PHINode*>(state.threads[tid].pc->inst);
    state.threads[tid].incomingBBIndex = first->getBasicBlockIndex(src);
  }
  state.setPreemptable(tid, true); 
}


bool isTerminationInstruction(ExecutionState &state, KInstruction *ki, int tid) {
   Instruction *i = ki->inst;
   Function *f = (Function*)i->getParent()->getParent();
   return f == state.threads[tid].function;
}

/* executes instruction ki of thread aid in state*/ 
void Executor::executeInstructionThread(ExecutionState &state, KInstruction *ki, int tid) {

  llvm::outs() << "in thread, executing instruction " << ki->getSourceLocation() << "\n";
  Instruction *i = ki->inst;
  switch (i->getOpcode()) {
    // Control flow
  case Instruction::Ret: {
    ReturnInst *ri = cast<ReturnInst>(i);
    KInstIterator kcaller = state.threads[tid].stack.back().caller;
    Instruction *caller = kcaller ? kcaller->inst : 0;
    bool isVoidReturn = (ri->getNumOperands() == 0);
    ref<Expr> result = ConstantExpr::alloc(0, Expr::Bool);
    
    if (!isVoidReturn) {
      result = evalThread(ki, 0, state,tid).value;
      /* SYSREL EXTENSION */
      if (progModel) {
         ConstantExpr *re = dyn_cast<ConstantExpr>(result);
         if (re) {
            llvm::outs() << "Recording return value " << re->getZExtValue() << " for " << ri->getParent()->getParent()->getName();
            state.threads[tid].returnValueModel[ri->getParent()->getParent()->getName()] = re->getZExtValue();
         }
      }
      /* SYSREL EXTENSION */
    }
    
    if (state.threads[tid].stack.size() <= 1) {
      assert(!caller && "caller set on initial stack frame");
      Function *rf = ri->getParent()->getParent();
      if (state.hasLCM()) {
         if (state.lcmStepMovesWhenReturns(rf->getName())) {
            if (state.threads[tid].returnValueModel.find(rf->getName()) != state.threads[tid].returnValueModel.end() && 
                    state.threads[tid].returnValueModel[rf->getName()] == 0)
   	       state.updateLCMState();
            else {
               llvm::outs() << "terminating state of thread " << tid << " and the life cycle early due to error return value!\n";
               terminateStateOnExitThread(state,tid);
            }
         }
         else  {
            
         }
      }
      else {
         llvm::outs() << "returning from main function of thread " << tid << "\n";
         terminateStateOnExitThread(state,tid);
      } 
    } else {
      state.popFrameThread(tid);

      if (statsTracker)
        statsTracker->framePoppedThread(state, tid);

      if (InvokeInst *ii = dyn_cast<InvokeInst>(caller)) {
        transferToBasicBlockThread(ii->getNormalDest(), caller->getParent(), state, tid);
      } else {
        state.threads[tid].pc = kcaller;
        ++state.threads[tid].pc;
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

          bindLocalThread(kcaller, state, result, tid);
        }
      } else {
        // We check that the return value has no users instead of
        // checking the type, since C defaults to returning int for
        // undeclared functions.
        if (!caller->use_empty()) {
          terminateStateOnExecErrorThread(state, "return void when caller expected a result","", tid);
        }
      }
    }      
    break;
  }
  case Instruction::Br: {
    BranchInst *bi = cast<BranchInst>(i);
    if (bi->isUnconditional()) {
      transferToBasicBlockThread(bi->getSuccessor(0), bi->getParent(), state, tid);
    } else {
      // FIXME: Find a way that we don't have this hidden dependency.
      assert(bi->getCondition() == bi->getOperand(0) &&
             "Wrong operand index!");
      ref<Expr> cond = evalThread(ki, 0, state, tid).value;
      Executor::StatePair branches = forkThread(state, cond, false, tid);

      // NOTE: There is a hidden dependency here, markBranchVisited
      // requires that we still be in the context of the branch
      // instruction (it reuses its statistic id). Should be cleaned
      // up with convenient instruction specific data.
      if (statsTracker && state.threads[tid].stack.back().kf->trackCoverage)
        statsTracker->markBranchVisited(branches.first, branches.second);

      if (branches.first) {
        transferToBasicBlockThread(bi->getSuccessor(0), bi->getParent(), *branches.first, tid);
      }
      if (branches.second) {
        transferToBasicBlockThread(bi->getSuccessor(1), bi->getParent(), *branches.second, tid);
      }
    }
    break;
  }
  case Instruction::Switch: {
    SwitchInst *si = cast<SwitchInst>(i);
    ref<Expr> cond = evalThread(ki, 0, state, tid).value;
    BasicBlock *bb = si->getParent();

    cond = toUnique(state, cond);
    if (ConstantExpr *CE = dyn_cast<ConstantExpr>(cond)) {
      // Somewhat gross to create these all the time, but fine till we
      // switch to an internal rep.
      llvm::IntegerType *Ty = cast<IntegerType>(si->getCondition()->getType());
      ConstantInt *ci = ConstantInt::get(Ty, CE->getZExtValue());
      unsigned index = si->findCaseValue(ci).getSuccessorIndex();
      transferToBasicBlockThread(si->getSuccessor(index), si->getParent(), state, tid);
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
      for (SwitchInst::CaseIt i = si->case_begin(), e = si->case_end(); i != e;
           ++i) {
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
      branchThread(state, conditions, branches, tid);

      std::vector<ExecutionState*>::iterator bit = branches.begin();
      for (std::vector<BasicBlock *>::iterator it = bbOrder.begin(),
                                               ie = bbOrder.end();
           it != ie; ++it) {
        ExecutionState *es = *bit;
        if (es)
          transferToBasicBlockThread(*it, bb, *es, tid);
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
    terminateStateOnExecErrorThread(state, "reached \"unreachable\" instruction", "", tid);
    break;

  case Instruction::Invoke:
  case Instruction::Call: {



    CallSite cs(i);


    unsigned numArgs = cs.arg_size();
    Value *fp = cs.getCalledValue();
    Function *f = getTargetFunction(fp, state);

   /* begin SYSREL extension */
    if (f && isAsyncInitiate(f->getName())) {
      std::string asyncName = getAsyncFunction(f->getName());
      llvm::outs() << "checking for async function name " << asyncName << "\n";
      if (isAsync(asyncName)) {
         Function *asyncF =  moduleHandle->getFunction(asyncName);
         int c = state.initiateAsync(asyncF);
         llvm::outs() << "async function " << asyncName << " initiated, count=" << c << "\n"; 
         break;
      }
    }
    /* end SYSREL extension */


    // Skip debug intrinsics, we can't evaluate their metadata arguments.
    if (f && isDebugIntrinsic(f, kmodule))
      break;

    if (isa<InlineAsm>(fp)) {
      terminateStateOnExecErrorThread(state, "inline assembly is unsupported", "", tid);
      break;
    }
    // evaluate arguments
    std::vector< ref<Expr> > arguments;
    arguments.reserve(numArgs);

    for (unsigned j=0; j<numArgs; ++j)
      arguments.push_back(evalThread(ki, j+1, state, tid).value);

    if (f) {
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

      executeCallThread(state, ki, f, arguments, tid);
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
        StatePair res = forkThread(*free, EqExpr::create(v, value), true, tid);
        if (res.first) {
          uint64_t addr = value->getZExtValue();
          if (legalFunctions.count(addr)) {
            f = (Function*) addr;

            // Don't give warning on unique resolution
            if (res.second || !first)
              klee_warning_once((void*) (unsigned long) addr, 
                                "resolved symbolic function pointer to: %s",
                                f->getName().data());

            executeCallThread(*res.first, ki, f, arguments, tid);
          } else {
            if (!hasInvalid) {
              terminateStateOnExecErrorThread(state, "invalid function pointer", "", tid);
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
    ref<Expr> result = evalThread(ki, state.threads[tid].incomingBBIndex, state, tid).value;
    bindLocalThread(ki, state, result, tid);
    break;
  }

    // Special instructions
  case Instruction::Select: {
    // NOTE: It is not required that operands 1 and 2 be of scalar type.
    ref<Expr> cond = evalThread(ki, 0, state, tid).value;
    ref<Expr> tExpr = evalThread(ki, 1, state, tid).value;
    ref<Expr> fExpr = evalThread(ki, 2, state, tid).value;
    ref<Expr> result = SelectExpr::create(cond, tExpr, fExpr);
    bindLocalThread(ki, state, result, tid);
    break;
  }

  case Instruction::VAArg:
    terminateStateOnExecErrorThread(state, "unexpected VAArg instruction", "", tid);
    break;

    // Arithmetic / logical

  case Instruction::Add: {
    state.dumpStackThread(llvm::outs());
    ref<Expr> left = evalThread(ki, 0, state, tid).value;
    ref<Expr> right = evalThread(ki, 1, state, tid).value;
    bindLocalThread(ki, state, AddExpr::create(left, right), tid);
    break;
  }

  case Instruction::Sub: {
    ref<Expr> left = evalThread(ki, 0, state, tid).value;
    ref<Expr> right = evalThread(ki, 1, state, tid).value;
    bindLocalThread(ki, state, SubExpr::create(left, right), tid);
    break;
  }
 
  case Instruction::Mul: {
    ref<Expr> left = evalThread(ki, 0, state, tid).value;
    ref<Expr> right = evalThread(ki, 1, state, tid).value;
    bindLocalThread(ki, state, MulExpr::create(left, right),tid);
    break;
  }

  case Instruction::UDiv: {
    ref<Expr> left = evalThread(ki, 0, state, tid).value;
    ref<Expr> right = evalThread(ki, 1, state, tid).value;
    ref<Expr> result = UDivExpr::create(left, right);
    bindLocalThread(ki, state, result,tid);
    break;
  }

  case Instruction::SDiv: {
    ref<Expr> left = evalThread(ki, 0, state, tid).value;
    ref<Expr> right = evalThread(ki, 1, state, tid).value;
    ref<Expr> result = SDivExpr::create(left, right);
    bindLocalThread(ki, state, result, tid);
    break;
  }

  case Instruction::URem: {
    ref<Expr> left = evalThread(ki, 0, state, tid).value;
    ref<Expr> right = evalThread(ki, 1, state, tid).value;
    ref<Expr> result = URemExpr::create(left, right);
    bindLocalThread(ki, state, result, tid);
    break;
  }

  case Instruction::SRem: {
    ref<Expr> left = evalThread(ki, 0, state, tid).value;
    ref<Expr> right = evalThread(ki, 1, state, tid).value;
    ref<Expr> result = SRemExpr::create(left, right);
    bindLocalThread(ki, state, result, tid);
    break;
  }

  case Instruction::And: {
    ref<Expr> left = evalThread(ki, 0, state, tid).value;
    ref<Expr> right = evalThread(ki, 1, state, tid).value;
    ref<Expr> result = AndExpr::create(left, right);
    bindLocalThread(ki, state, result, tid);
    break;
  }

  case Instruction::Or: {
    ref<Expr> left = evalThread(ki, 0, state, tid).value;
    ref<Expr> right = evalThread(ki, 1, state, tid).value;
    ref<Expr> result = OrExpr::create(left, right);
    bindLocalThread(ki, state, result, tid);
    break;
  }

  case Instruction::Xor: {
    ref<Expr> left = evalThread(ki, 0, state, tid).value;
    ref<Expr> right = evalThread(ki, 1, state, tid).value;
    ref<Expr> result = XorExpr::create(left, right);
    bindLocalThread(ki, state, result, tid);
    break;
  }

  case Instruction::Shl: {
    ref<Expr> left = evalThread(ki, 0, state, tid).value;
    ref<Expr> right = evalThread(ki, 1, state, tid).value;
    ref<Expr> result = ShlExpr::create(left, right);
    bindLocalThread(ki, state, result, tid);
    break;
  }

  case Instruction::LShr: {
    ref<Expr> left = evalThread(ki, 0, state, tid).value;
    ref<Expr> right = evalThread(ki, 1, state, tid).value;
    ref<Expr> result = LShrExpr::create(left, right);
    bindLocalThread(ki, state, result, tid);
    break;
  }

  case Instruction::AShr: {
    ref<Expr> left = evalThread(ki, 0, state, tid).value;
    ref<Expr> right = evalThread(ki, 1, state, tid).value;
    ref<Expr> result = AShrExpr::create(left, right);
    bindLocalThread(ki, state, result, tid);
    break;
  }

    // Compare

  case Instruction::ICmp: {
    CmpInst *ci = cast<CmpInst>(i);
    ICmpInst *ii = cast<ICmpInst>(ci);

    switch(ii->getPredicate()) {
    case ICmpInst::ICMP_EQ: {
      ref<Expr> left = evalThread(ki, 0, state, tid).value;
      ref<Expr> right = evalThread(ki, 1, state, tid).value;
      ref<Expr> result = EqExpr::create(left, right);
      bindLocalThread(ki, state, result, tid);
      break;
    }

    case ICmpInst::ICMP_NE: {
      ref<Expr> left = evalThread(ki, 0, state, tid).value;
      ref<Expr> right = evalThread(ki, 1, state, tid).value;
      ref<Expr> result = NeExpr::create(left, right);
      bindLocalThread(ki, state, result, tid);
      break;
    }

    case ICmpInst::ICMP_UGT: {
      ref<Expr> left = evalThread(ki, 0, state, tid).value;
      ref<Expr> right = evalThread(ki, 1, state, tid).value;
      ref<Expr> result = UgtExpr::create(left, right);
      bindLocalThread(ki, state,result, tid);
      break;
    }

    case ICmpInst::ICMP_UGE: {
      ref<Expr> left = evalThread(ki, 0, state, tid).value;
      ref<Expr> right = evalThread(ki, 1, state, tid).value;
      ref<Expr> result = UgeExpr::create(left, right);
      bindLocalThread(ki, state, result, tid);
      break;
    }

    case ICmpInst::ICMP_ULT: {
      ref<Expr> left = evalThread(ki, 0, state, tid).value;
      ref<Expr> right = evalThread(ki, 1, state, tid).value;
      ref<Expr> result = UltExpr::create(left, right);
      bindLocalThread(ki, state, result, tid);
      break;
    }

    case ICmpInst::ICMP_ULE: {
      ref<Expr> left = evalThread(ki, 0, state, tid).value;
      ref<Expr> right = evalThread(ki, 1, state, tid).value;
      ref<Expr> result = UleExpr::create(left, right);
      bindLocalThread(ki, state, result, tid);
      break;
    }

    case ICmpInst::ICMP_SGT: {
      ref<Expr> left = evalThread(ki, 0, state, tid).value;
      ref<Expr> right = evalThread(ki, 1, state, tid).value;
      ref<Expr> result = SgtExpr::create(left, right);
      bindLocalThread(ki, state, result, tid);
      break;
    }

    case ICmpInst::ICMP_SGE: {
      ref<Expr> left = evalThread(ki, 0, state, tid).value;
      ref<Expr> right = evalThread(ki, 1, state, tid).value;
      ref<Expr> result = SgeExpr::create(left, right);
      bindLocalThread(ki, state, result, tid);
      break;
    }

    case ICmpInst::ICMP_SLT: {
      ref<Expr> left = evalThread(ki, 0, state, tid).value;
      ref<Expr> right = evalThread(ki, 1, state, tid).value;
      ref<Expr> result = SltExpr::create(left, right);
      bindLocalThread(ki, state, result, tid);
      break;
    }

    case ICmpInst::ICMP_SLE: {
      ref<Expr> left = evalThread(ki, 0, state, tid).value;
      ref<Expr> right = evalThread(ki, 1, state, tid).value;
      ref<Expr> result = SleExpr::create(left, right);
      bindLocalThread(ki, state, result, tid);
      break;
    }

    default:
      terminateStateOnExecErrorThread(state, "invalid ICmp predicate", "", tid);
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
      ref<Expr> count = evalThread(ki, 0, state, tid).value;
      count = Expr::createZExtToPointerWidth(count);
      size = MulExpr::create(size, count);
    }
    executeAllocThread(state, size, true, ki, tid);
    break;
  }

  case Instruction::Load: {
    ref<Expr> base = evalThread(ki, 0, state, tid).value;
    executeMemoryOperationThread(state, false, base, 0, ki, tid);
    break;
  }
  case Instruction::Store: {
    ref<Expr> base = evalThread(ki, 1, state, tid).value;
    ref<Expr> value = evalThread(ki, 0, state, tid).value;
    executeMemoryOperationThread(state, true, base, value, 0, tid);
    break;
  }

  case Instruction::GetElementPtr: {
    KGEPInstruction *kgepi = static_cast<KGEPInstruction*>(ki);
    ref<Expr> base = evalThread(ki, 0, state, tid).value;

    for (std::vector< std::pair<unsigned, uint64_t> >::iterator 
           it = kgepi->indices.begin(), ie = kgepi->indices.end(); 
         it != ie; ++it) {
      uint64_t elementSize = it->second;
      ref<Expr> index = evalThread(ki, it->first, state, tid).value;
      base = AddExpr::create(base,
                             MulExpr::create(Expr::createSExtToPointerWidth(index),
                                             Expr::createPointer(elementSize)));
    }
    if (kgepi->offset)
      base = AddExpr::create(base,
                             Expr::createPointer(kgepi->offset));
    bindLocalThread(ki, state, base, tid);
    break;
  }

    // Conversion
  case Instruction::Trunc: {
    CastInst *ci = cast<CastInst>(i);
    ref<Expr> result = ExtractExpr::create(evalThread(ki, 0, state, tid).value,
                                           0,
                                           getWidthForLLVMType(ci->getType()));
    bindLocalThread(ki, state, result, tid);
    break;
  }
  case Instruction::ZExt: {
    CastInst *ci = cast<CastInst>(i);
    ref<Expr> result = ZExtExpr::create(evalThread(ki, 0, state, tid).value,
                                        getWidthForLLVMType(ci->getType()));
    bindLocalThread(ki, state, result, tid);
    break;
  }
  case Instruction::SExt: {
    CastInst *ci = cast<CastInst>(i);
    ref<Expr> result = SExtExpr::create(evalThread(ki, 0, state, tid).value,
                                        getWidthForLLVMType(ci->getType()));
    bindLocalThread(ki, state, result, tid);
    break;
  }

  case Instruction::IntToPtr: {
    CastInst *ci = cast<CastInst>(i);
    Expr::Width pType = getWidthForLLVMType(ci->getType());
    ref<Expr> arg = evalThread(ki, 0, state, tid).value;
    bindLocalThread(ki, state, ZExtExpr::create(arg, pType), tid);
    break;
  }
  case Instruction::PtrToInt: {
    CastInst *ci = cast<CastInst>(i);
    Expr::Width iType = getWidthForLLVMType(ci->getType());
    ref<Expr> arg = evalThread(ki, 0, state, tid).value;
    bindLocalThread(ki, state, ZExtExpr::create(arg, iType), tid);
    break;
  }

  case Instruction::BitCast: {
    ref<Expr> result = evalThread(ki, 0, state, tid).value;
    bindLocalThread(ki, state, result, tid);

    /* SYSREL EXTENSION */
   if (lazyInit) {
    Type *t = ki->inst->getOperand(1)->getType(); 
    if (t->isPointerTy()) {
       t = t->getPointerElementType();
       if (!t->isPointerTy()) {
          StructType *st = dyn_cast<StructType>(t);
          if (st) {
             std::string tname = getTypeName(t); 
             state.typeToAddr[t] = result;
             llvm::outs() << "mapping bitcast instance of " << tname << " to " << result << "\n";
          }
       }
    } 
   }     
    /* SYSREL EXTENSION */



    break;
  }

    // Floating point instructions

  case Instruction::FAdd: {
    ref<ConstantExpr> left = toConstant(state, evalThread(ki, 0, state, tid).value,
                                        "floating point");
    ref<ConstantExpr> right = toConstant(state, evalThread(ki, 1, state, tid).value,
                                         "floating point");
    if (!fpWidthToSemantics(left->getWidth()) ||
        !fpWidthToSemantics(right->getWidth()))
      return terminateStateOnExecErrorThread(state, "Unsupported FAdd operation", "", tid);

    llvm::APFloat Res(*fpWidthToSemantics(left->getWidth()), left->getAPValue());
    Res.add(APFloat(*fpWidthToSemantics(right->getWidth()),right->getAPValue()), APFloat::rmNearestTiesToEven);
    bindLocalThread(ki, state, ConstantExpr::alloc(Res.bitcastToAPInt()), tid);
    break;
  }

  case Instruction::FSub: {
    ref<ConstantExpr> left = toConstant(state, evalThread(ki, 0, state, tid).value,
                                        "floating point");
    ref<ConstantExpr> right = toConstant(state, evalThread(ki, 1, state, tid).value,
                                         "floating point");
    if (!fpWidthToSemantics(left->getWidth()) ||
        !fpWidthToSemantics(right->getWidth()))
      return terminateStateOnExecErrorThread(state, "Unsupported FSub operation", "", tid);
    llvm::APFloat Res(*fpWidthToSemantics(left->getWidth()), left->getAPValue());
    Res.subtract(APFloat(*fpWidthToSemantics(right->getWidth()), right->getAPValue()), APFloat::rmNearestTiesToEven);
    bindLocalThread(ki, state, ConstantExpr::alloc(Res.bitcastToAPInt()), tid);
    break;
  }

  case Instruction::FMul: {
    ref<ConstantExpr> left = toConstant(state, evalThread(ki, 0, state, tid).value,
                                        "floating point");
    ref<ConstantExpr> right = toConstant(state, evalThread(ki, 1, state, tid).value,
                                         "floating point");
    if (!fpWidthToSemantics(left->getWidth()) ||
        !fpWidthToSemantics(right->getWidth()))
      return terminateStateOnExecErrorThread(state, "Unsupported FMul operation", "", tid);

    llvm::APFloat Res(*fpWidthToSemantics(left->getWidth()), left->getAPValue());
    Res.multiply(APFloat(*fpWidthToSemantics(right->getWidth()), right->getAPValue()), APFloat::rmNearestTiesToEven);
    bindLocalThread(ki, state, ConstantExpr::alloc(Res.bitcastToAPInt()), tid);
    break;
  }

  case Instruction::FDiv: {
    ref<ConstantExpr> left = toConstant(state, evalThread(ki, 0, state, tid).value,
                                        "floating point");
    ref<ConstantExpr> right = toConstant(state, evalThread(ki, 1, state, tid).value,
                                         "floating point");
    if (!fpWidthToSemantics(left->getWidth()) ||
        !fpWidthToSemantics(right->getWidth()))
      return terminateStateOnExecErrorThread(state, "Unsupported FDiv operation", "", tid);

    llvm::APFloat Res(*fpWidthToSemantics(left->getWidth()), left->getAPValue());
    Res.divide(APFloat(*fpWidthToSemantics(right->getWidth()), right->getAPValue()), APFloat::rmNearestTiesToEven);
    bindLocalThread(ki, state, ConstantExpr::alloc(Res.bitcastToAPInt()), tid);
    break;
  }

  case Instruction::FRem: {
    ref<ConstantExpr> left = toConstant(state, evalThread(ki, 0, state, tid).value,
                                        "floating point");
    ref<ConstantExpr> right = toConstant(state, evalThread(ki, 1, state, tid).value,
                                         "floating point");
    if (!fpWidthToSemantics(left->getWidth()) ||
        !fpWidthToSemantics(right->getWidth()))
      return terminateStateOnExecErrorThread(state, "Unsupported FRem operation", "", tid);
    llvm::APFloat Res(*fpWidthToSemantics(left->getWidth()), left->getAPValue());
#if LLVM_VERSION_CODE >= LLVM_VERSION(3, 8)
    Res.mod(APFloat(*fpWidthToSemantics(right->getWidth()),right->getAPValue()));
#else
    Res.mod(APFloat(*fpWidthToSemantics(right->getWidth()),right->getAPValue()),
         APFloat::rmNearestTiesToEven);
#endif
    bindLocalThread(ki, state, ConstantExpr::alloc(Res.bitcastToAPInt()), tid);
    break;
  }

  case Instruction::FPTrunc: {
    FPTruncInst *fi = cast<FPTruncInst>(i);
    Expr::Width resultType = getWidthForLLVMType(fi->getType());
    ref<ConstantExpr> arg = toConstant(state, evalThread(ki, 0, state, tid).value,
                                       "floating point");
    if (!fpWidthToSemantics(arg->getWidth()) || resultType > arg->getWidth())
      return terminateStateOnExecErrorThread(state, "Unsupported FPTrunc operation", "", tid);

    llvm::APFloat Res(*fpWidthToSemantics(arg->getWidth()), arg->getAPValue());
    bool losesInfo = false;
    Res.convert(*fpWidthToSemantics(resultType),
                llvm::APFloat::rmNearestTiesToEven,
                &losesInfo);
    bindLocalThread(ki, state, ConstantExpr::alloc(Res), tid);
    break;
  }

  case Instruction::FPExt: {
    FPExtInst *fi = cast<FPExtInst>(i);
    Expr::Width resultType = getWidthForLLVMType(fi->getType());
    ref<ConstantExpr> arg = toConstant(state, evalThread(ki, 0, state, tid).value,
                                        "floating point");
    if (!fpWidthToSemantics(arg->getWidth()) || arg->getWidth() > resultType)
      return terminateStateOnExecErrorThread(state, "Unsupported FPExt operation", "", tid);
    llvm::APFloat Res(*fpWidthToSemantics(arg->getWidth()), arg->getAPValue());
    bool losesInfo = false;
    Res.convert(*fpWidthToSemantics(resultType),
                llvm::APFloat::rmNearestTiesToEven,
                &losesInfo);
    bindLocalThread(ki, state, ConstantExpr::alloc(Res), tid);
    break;
  }

  case Instruction::FPToUI: {
    FPToUIInst *fi = cast<FPToUIInst>(i);
    Expr::Width resultType = getWidthForLLVMType(fi->getType());
    ref<ConstantExpr> arg = toConstant(state, evalThread(ki, 0, state, tid).value,
                                       "floating point");
    if (!fpWidthToSemantics(arg->getWidth()) || resultType > 64)
      return terminateStateOnExecErrorThread(state, "Unsupported FPToUI operation", "", tid);

    llvm::APFloat Arg(*fpWidthToSemantics(arg->getWidth()), arg->getAPValue());
    uint64_t value = 0;
    bool isExact = true;
    Arg.convertToInteger(&value, resultType, false,
                         llvm::APFloat::rmTowardZero, &isExact);
    bindLocalThread(ki, state, ConstantExpr::alloc(value, resultType), tid);
    break;
  }

  case Instruction::FPToSI: {
    FPToSIInst *fi = cast<FPToSIInst>(i);
    Expr::Width resultType = getWidthForLLVMType(fi->getType());
    ref<ConstantExpr> arg = toConstant(state, eval(ki, 0, state).value,
                                       "floating point");
    if (!fpWidthToSemantics(arg->getWidth()) || resultType > 64)
      return terminateStateOnExecErrorThread(state, "Unsupported FPToSI operation", "", tid);
    llvm::APFloat Arg(*fpWidthToSemantics(arg->getWidth()), arg->getAPValue());

    uint64_t value = 0;
    bool isExact = true;
    Arg.convertToInteger(&value, resultType, true,
                         llvm::APFloat::rmTowardZero, &isExact);
    bindLocalThread(ki, state, ConstantExpr::alloc(value, resultType), tid);
    break;
  }

  case Instruction::UIToFP: {
    UIToFPInst *fi = cast<UIToFPInst>(i);
    Expr::Width resultType = getWidthForLLVMType(fi->getType());
    ref<ConstantExpr> arg = toConstant(state, evalThread(ki, 0, state, tid).value,
                                       "floating point");
    const llvm::fltSemantics *semantics = fpWidthToSemantics(resultType);
    if (!semantics)
      return terminateStateOnExecErrorThread(state, "Unsupported UIToFP operation", "", tid);
    llvm::APFloat f(*semantics, 0);
    f.convertFromAPInt(arg->getAPValue(), false,
                       llvm::APFloat::rmNearestTiesToEven);

    bindLocalThread(ki, state, ConstantExpr::alloc(f), tid);
    break;
  }

  case Instruction::SIToFP: {
    SIToFPInst *fi = cast<SIToFPInst>(i);
    Expr::Width resultType = getWidthForLLVMType(fi->getType());
    ref<ConstantExpr> arg = toConstant(state, evalThread(ki, 0, state, tid).value,
                                       "floating point");
    const llvm::fltSemantics *semantics = fpWidthToSemantics(resultType);
    if (!semantics)
      return terminateStateOnExecErrorThread(state, "Unsupported SIToFP operation", "", tid);
    llvm::APFloat f(*semantics, 0);
    f.convertFromAPInt(arg->getAPValue(), true,
                       llvm::APFloat::rmNearestTiesToEven);

    bindLocalThread(ki, state, ConstantExpr::alloc(f), tid);
    break;
  }

  case Instruction::FCmp: {
    FCmpInst *fi = cast<FCmpInst>(i);
    ref<ConstantExpr> left = toConstant(state, evalThread(ki, 0, state, tid).value,
                                        "floating point");
    ref<ConstantExpr> right = toConstant(state, evalThread(ki, 1, state, tid).value,
                                         "floating point");
    if (!fpWidthToSemantics(left->getWidth()) ||
        !fpWidthToSemantics(right->getWidth()))
      return terminateStateOnExecErrorThread(state, "Unsupported FCmp operation", "", tid);

    APFloat LHS(*fpWidthToSemantics(left->getWidth()),left->getAPValue());
    APFloat RHS(*fpWidthToSemantics(right->getWidth()),right->getAPValue());
    APFloat::cmpResult CmpRes = LHS.compare(RHS);

    bool Result = false;
    switch( fi->getPredicate() ) {
      // Predicates which only care about whether or not the operands are NaNs.
    case FCmpInst::FCMP_ORD:
      Result = CmpRes != APFloat::cmpUnordered;
      break;

    case FCmpInst::FCMP_UNO:
      Result = CmpRes == APFloat::cmpUnordered;
      break;

      // Ordered comparisons return false if either operand is NaN.  Unordered
      // comparisons return true if either operand is NaN.
    case FCmpInst::FCMP_UEQ:
      if (CmpRes == APFloat::cmpUnordered) {
        Result = true;
        break;
      }
    case FCmpInst::FCMP_OEQ:
      Result = CmpRes == APFloat::cmpEqual;
      break;

    case FCmpInst::FCMP_UGT:
      if (CmpRes == APFloat::cmpUnordered) {
        Result = true;
        break;
      }
    case FCmpInst::FCMP_OGT:
      Result = CmpRes == APFloat::cmpGreaterThan;
      break;

    case FCmpInst::FCMP_UGE:
      if (CmpRes == APFloat::cmpUnordered) {
        Result = true;
        break;
      }
    case FCmpInst::FCMP_OGE:
      Result = CmpRes == APFloat::cmpGreaterThan || CmpRes == APFloat::cmpEqual;
      break;

    case FCmpInst::FCMP_ULT:
      if (CmpRes == APFloat::cmpUnordered) {
        Result = true;
        break;
      }
    case FCmpInst::FCMP_OLT:
      Result = CmpRes == APFloat::cmpLessThan;
      break;

    case FCmpInst::FCMP_ULE:
      if (CmpRes == APFloat::cmpUnordered) {
        Result = true;
        break;
      }
    case FCmpInst::FCMP_OLE:
      Result = CmpRes == APFloat::cmpLessThan || CmpRes == APFloat::cmpEqual;
      break;

    case FCmpInst::FCMP_UNE:
      Result = CmpRes == APFloat::cmpUnordered || CmpRes != APFloat::cmpEqual;
      break;
    case FCmpInst::FCMP_ONE:
      Result = CmpRes != APFloat::cmpUnordered && CmpRes != APFloat::cmpEqual;
      break;

    default:
      assert(0 && "Invalid FCMP predicate!");
    case FCmpInst::FCMP_FALSE:
      Result = false;
      break;
    case FCmpInst::FCMP_TRUE:
      Result = true;
      break;
    }

    bindLocalThread(ki, state, ConstantExpr::alloc(Result, Expr::Bool), tid);
    break;
  }
  case Instruction::InsertValue: {
    KGEPInstruction *kgepi = static_cast<KGEPInstruction*>(ki);

    ref<Expr> agg = evalThread(ki, 0, state, tid).value;
    ref<Expr> val = evalThread(ki, 1, state, tid).value;

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

    bindLocalThread(ki, state, result, tid);
    break;
  }
  case Instruction::ExtractValue: {
    KGEPInstruction *kgepi = static_cast<KGEPInstruction*>(ki);

    ref<Expr> agg = evalThread(ki, 0, state, tid).value;

    ref<Expr> result = ExtractExpr::create(agg, kgepi->offset*8, getWidthForLLVMType(i->getType()));

    bindLocalThread(ki, state, result, tid);
    break;
  }
  case Instruction::Fence: {
    // Ignore for now
    break;
  }
  case Instruction::InsertElement: {
    InsertElementInst *iei = cast<InsertElementInst>(i);
    ref<Expr> vec = evalThread(ki, 0, state, tid).value;
    ref<Expr> newElt = evalThread(ki, 1, state, tid).value;
    ref<Expr> idx = evalThread(ki, 2, state, tid).value;

    ConstantExpr *cIdx = dyn_cast<ConstantExpr>(idx);
    if (cIdx == NULL) {
      terminateStateOnErrorThread(
          state, "InsertElement, support for symbolic index not implemented",
          Unhandled,   NULL, "", tid);
      return;
    }
    uint64_t iIdx = cIdx->getZExtValue();
    const llvm::VectorType *vt = iei->getType();
    unsigned EltBits = getWidthForLLVMType(vt->getElementType());

    if (iIdx >= vt->getNumElements()) {
      // Out of bounds write
      terminateStateOnErrorThread(state, "Out of bounds write when inserting element",
                            BadVectorAccess,  NULL, "", tid);
      return;
    }

    const unsigned elementCount = vt->getNumElements();
    llvm::SmallVector<ref<Expr>, 8> elems;
    elems.reserve(elementCount);
    for (unsigned i = 0; i < elementCount; ++i) {
      // evalConstant() will use ConcatExpr to build vectors with the
      // zero-th element leftmost (most significant bits), followed
      // by the next element (second leftmost) and so on. This means
      // that we have to adjust the index so we read left to right
      // rather than right to left.
      unsigned bitOffset = EltBits * (elementCount - i - 1);
      elems.push_back(i == iIdx ? newElt
                                : ExtractExpr::create(vec, bitOffset, EltBits));
    }

    ref<Expr> Result = ConcatExpr::createN(elementCount, elems.data());
    bindLocalThread(ki, state, Result, tid);
    break;
  }
  case Instruction::ExtractElement: {
    ExtractElementInst *eei = cast<ExtractElementInst>(i);
    ref<Expr> vec = evalThread(ki, 0, state, tid).value;
    ref<Expr> idx = evalThread(ki, 1, state, tid).value;

    ConstantExpr *cIdx = dyn_cast<ConstantExpr>(idx);
    if (cIdx == NULL) {
      terminateStateOnErrorThread(
          state, "ExtractElement, support for symbolic index not implemented",
          Unhandled,  NULL, "", tid);
      return;
    }
    uint64_t iIdx = cIdx->getZExtValue();
    const llvm::VectorType *vt = eei->getVectorOperandType();
    unsigned EltBits = getWidthForLLVMType(vt->getElementType());

    if (iIdx >= vt->getNumElements()) {
      // Out of bounds read
      terminateStateOnErrorThread(state, "Out of bounds read when extracting element",
                            BadVectorAccess,  NULL, "", tid);
      return;
    }

    // evalConstant() will use ConcatExpr to build vectors with the
    // zero-th element left most (most significant bits), followed
    // by the next element (second left most) and so on. This means
    // that we have to adjust the index so we read left to right
    // rather than right to left.
    unsigned bitOffset = EltBits*(vt->getNumElements() - iIdx -1);
    ref<Expr> Result = ExtractExpr::create(vec, bitOffset, EltBits);
    bindLocalThread(ki, state, Result, tid);
    break;
  }
  case Instruction::ShuffleVector:
    // Should never happen due to Scalarizer pass removing ShuffleVector
    // instructions.
    terminateStateOnExecErrorThread(state, "Unexpected ShuffleVector instruction", "", tid);
    break;
  // Other instructions...
  // Unhandled
  default:
    terminateStateOnExecErrorThread(state, "illegal instruction", "", tid);
    break;
  }
}





void Executor::terminateStateThread(ExecutionState &state, int tid) {
   state.terminateThread(tid);

 /*

  if (replayKTest && replayPosition!=replayKTest->numObjects) {
    klee_warning_once(replayKTest,
                      "replay did not consume all objects in test input.");
  }

  interpreterHandler->incPathsExplored();

  std::vector<ExecutionState *>::iterator it =
      std::find(addedStates.begin(), addedStates.end(), &state);
  if (it==addedStates.end()) {
    state.threads[tid].pc = state.threads[tid].prevPC;

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
 */
}

void Executor::terminateStateEarlyThread(ExecutionState &state, 
                                   const Twine &message, int tid) {
 state.terminateThread(tid);
 /*
  if (!OnlyOutputStatesCoveringNew || state.coveredNew ||
      (AlwaysOutputSeeds && seedMap.count(&state)))
    interpreterHandler->processTestCase(state, (message + "\n").str().c_str(),
                                        "early");
  terminateStateThread(state, tid);
  */
}

void Executor::terminateStateOnExitThread(ExecutionState &state, int tid) {
  state.terminateThread(tid);
  /*
  if (!OnlyOutputStatesCoveringNew || state.coveredNew || 
      (AlwaysOutputSeeds && seedMap.count(&state)))
    interpreterHandler->processTestCase(state, 0, 0);
  terminateStateThread(state, tid);
  */
}

const InstructionInfo & Executor::getLastNonKleeInternalInstructionThread(const ExecutionState &state,
    Instruction ** lastInstruction, int tid) {
  // unroll the stack of the applications state and find
  // the last instruction which is not inside a KLEE internal function
  ExecutionState::stack_ty::const_reverse_iterator it = state.threads[tid].stack.rbegin(),
      itE = state.threads[tid].stack.rend();

  // don't check beyond the outermost function (i.e. main())
  itE--;

  const InstructionInfo * ii = 0;
  if (kmodule->internalFunctions.count(it->kf->function) == 0){
    ii =  state.threads[tid].prevPC->info;
    *lastInstruction = state.threads[tid].prevPC->inst;
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
    *lastInstruction = state.threads[tid].prevPC->inst;
    return *state.threads[tid].prevPC->info;
  }
  return *ii;
}


void Executor::terminateStateOnErrorThread(ExecutionState &state,
                                     const llvm::Twine &messaget,
                                     enum TerminateReason termReason,
                                     const char *suffix,
                                     const llvm::Twine &info, int tid) {
  std::string message = messaget.str();
  static std::set< std::pair<Instruction*, std::string> > emittedErrors;
  Instruction * lastInst;
  const InstructionInfo &ii = getLastNonKleeInternalInstructionThread(state, &lastInst, tid);
  
  if (EmitAllErrors ||
      emittedErrors.insert(std::make_pair(lastInst, message)).second) {
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

    interpreterHandler->processTestCase(state, msg.str().c_str(), suffix);
  }
    
  terminateStateThread(state, tid);

  if (shouldExitOn(termReason))
    haltExecution = true;
}

// XXX shoot me
static const char *okExternalsList[] = { "printf", 
                                         "fprintf", 
                                         "puts",
                                         "getpid" };

static std::set<std::string> okExternals(okExternalsList,
                                         okExternalsList + 
                                         (sizeof(okExternalsList)/sizeof(okExternalsList[0])));

void Executor::callExternalFunctionThread(ExecutionState &state,
                                    KInstruction *target,
                                    Function *function,
                                    std::vector< ref<Expr> > &arguments, int tid) {
  // check if specialFunctionHandler wants it
  if (specialFunctionHandler->handle(state, function, target, arguments))
    return;
  
  if (NoExternals && !okExternals.count(function->getName())) {
    klee_warning("Disallowed call to external function: %s\n",
               function->getName().str().c_str());
    terminateStateOnErrorThread(state, "externals disallowed", User,  NULL, "", tid);
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
      wordIndex += (ce->getWidth()+63)/64;
    } else {
      ref<Expr> arg = toUnique(state, *ai);
      if (ConstantExpr *ce = dyn_cast<ConstantExpr>(arg)) {
        // XXX kick toMemory functions from here
        ce->toMemory(&args[wordIndex]);
        wordIndex += (ce->getWidth()+63)/64;
      } else {
        terminateStateOnExecErrorThread(state, 
                                  "external call with symbolic argument: " + 
					function->getName(), "", tid);
        return;
      }
    }
  }

  state.addressSpace.copyOutConcretes();

  if (!SuppressExternalWarnings) {

    std::string TmpStr;
    llvm::raw_string_ostream os(TmpStr);
    os << "calling external: " << function->getName().str() << "(";
    for (unsigned i=0; i<arguments.size(); i++) {
      os << arguments[i];
      if (i != arguments.size()-1)
	os << ", ";
    }
    os << ") at ";
    os << state.pc->getSourceLocation();
    
    if (AllExternalWarnings)
      klee_warning("%s", os.str().c_str());
    else
      klee_warning_once(function, "%s", os.str().c_str());
  }
  bool success = externalDispatcher->executeCall(function, target->inst, args);
  if (!success) {

    /* SYSREL EXTENSION */

    if (progModel) {
       // let the generic API handler handle the arg and return value symbolization
       std::vector<ExecutionState*> successors;
       bool abort = false;
       ref<Expr> offendingAddress = Expr::createPointer(0);
       bool resHandled =  APIHandler::handle(state, successors, function->getName(), arguments, target, abort, offendingAddress, tid);
       assert(!abort); 
       if (!resHandled) {
          symbolizeArgumentsThread(state, target, function, arguments, tid);
          symbolizeReturnValueThread(state, target, function, tid); 
       }
       return;
/*
    bool argInitSkip = false;

    if (progModel) {
       bool resHandled = false;
       bool regApi = regAPIHandler->handle(state, function->getName(), arguments, tid);
       bool resApi = resADAPIHandler->handle(state, function->getName(), arguments, tid);
       bool mutApi = mutexAPIHandler->handle(state, function->getName(), arguments, tid);
       bool refAPI = refcountAPIHandler->handle(state, function->getName(), arguments, tid);
       bool allAPI = allocAPIHandler->handle(state, function->getName(), arguments, target, resHandled, tid); 
       bool freAPI = freeAPIHandler->handle(state, function->getName(), arguments, target, tid);
       bool rwAPI = readWriteAPIHandler->handle(state, function->getName(), arguments, target, tid);
       bool sgAPI = setgetAPIHandler->handle(state, function->getName(), arguments, target, tid);
       bool igAPI = ignoreAPIHandler->handle(state, function->getName(), arguments, target);
       bool cbAPI = callbackAPIHandler->handle(state, function->getName(), arguments, target); 
       bool seAPI = sideEffectAPIHandler->handle(state, function->getName(), arguments, target);
       if (regApi || resApi || mutApi || refAPI || allAPI || freAPI || rwAPI || sgAPI || igAPI | cbAPI || seAPI) {
          if (sgAPI || (allAPI && resHandled))
             return;
          argInitSkip = true; 
       }
    }   



   if (lazyInit) {
    // Instead of terminating the path, we would like to model such calls as functions that 

    if (!argInitSkip) {
    // 1) arbitrarily update data reachable from pointer or call by reference arguments and
    // We will consider primitive types for now
    // Since we were not able to do makeSymbolic on an existing ObjectState, we will create shadow sym values 
    // and copy them over the memory pointed by arg's; effectively making that memory symbolic
    // To find whether an argument is a pointer type, we need to find its use first!
    unsigned int ai = 0;
    for(llvm::Function::arg_iterator agi = function->arg_begin(); agi != function->arg_end(); agi++, ai++) { 
       llvm::outs() << "ext function operand " << ai+1 << " " << target->operands[ai+1] << "\n";
       if (target->operands[ai+1] >= 0) { // a local var
          Type *at = agi->getType();
          if (at->isPointerTy()) {
             Type *bt = at->getPointerElementType();      
             //if (bt->getPrimitiveSizeInBits()) {
                llvm::outs() << "Type of parameter " << ai << " to external func is a pointer type\n";
                DataLayout *TD = kmodule->targetData;
                // find the MemoryObject for this value
                ObjectPair op;
                bool asuccess;
                ref<Expr> base = eval(target, ai+1, state).value;
                solver->setTimeout(coreSolverTimeout);
                if (!state.addressSpace.resolveOne(state, solver, base, op, asuccess)) {
                   base = toConstant(state, base, "resolveOne failure");
                   asuccess = state.addressSpace.resolveOne(cast<ConstantExpr>(base), op);
                }
                solver->setTimeout(0);             
                if (asuccess) {      
                   MemoryObject *sm = memory->allocate(TD->getTypeAllocSize(bt), op.first->isLocal, 
                           op.first->isGlobal, op.first->allocSite, TD->getPrefTypeAlignment(bt));
                   unsigned id = 0;
                   std::string name = "shadow";
                   std::string uniqueName = name;
                   while (!state.arrayNames.insert(uniqueName).second) {
                       uniqueName = name + "_" + llvm::utostr(++id);
                   }
                   // we're mimicking what executeMemoryOperation do without a relevant load or store instruction
                   const Array *array = arrayCache.CreateArray(uniqueName, sm->size);
                   ObjectState *sos = bindObjectInState(state, sm, true, array);
                   ref<Expr> result = sos->read(ConstantExpr::alloc(0, Expr::Int64), getWidthForLLVMType(bt));
                   ObjectState *wos = state.addressSpace.getWriteable(op.first, op.second);
                   wos->write(ConstantExpr::alloc(0, Expr::Int64), result);
                   llvm::outs() << "Wrote " << result << " to lazy init arg address " << base << "\n"; 
               }
             //}

         }
       }
      }
    }     
  
              
    // 2) return an arbitrary result as follows:
    // Alloc the data of return type, make it symbolic, and load the value of the symbolic mem to target->dest
    // TODO: check if there is a return value!
    if (function->getReturnType()->isVoidTy())
       return;  
    std::string type_str;
    llvm::raw_string_ostream rso(type_str);
    function->getReturnType()->print(rso);
    llvm::outs() << "return type of external function: " << rso.str() << "\n";
    ref<Expr> laddr;
    llvm::Type *rType;
    bool mksym;
    const MemoryObject *mo = memory->allocateLazyForTypeOrEmbedding(state, state.prevPC->inst, function->getReturnType(), 
             function->getReturnType(), false, 1, rType, laddr, mksym); 
    //mo = memory->allocateForLazyInit(state, state.prevPC->inst, function->getReturnType(), false, 1, laddr);
    mo->name = "%sym" + std::to_string(target->dest);
    if (mksym)
       executeMakeSymbolicThread(state, mo, mo->name, tid);
    executeMemoryOperationThread(state, false, laddr, 0, target, tid);
    return;
    }
    else {
    /* SYSREL EXTENSION */


    terminateStateOnErrorThread(state, "failed external call: " + function->getName(),
                          External,  NULL, "", tid);
    return;
   }
  }

  if (!state.addressSpace.copyInConcretes()) {
    terminateStateOnErrorThread(state, "external modified read-only object",
                          External,  NULL, "", tid);
    return;
  }

  Type *resultType = target->inst->getType();
  if (resultType != Type::getVoidTy(function->getContext())) {
    ref<Expr> e = ConstantExpr::fromMemory((void*) args, 
                                           getWidthForLLVMType(resultType));
    bindLocalThread(target, state, e, tid);
  }
}

void Executor::symbolizeArgumentsThread(ExecutionState &state, 
                                  KInstruction *target,
                                  Function *function,
                                  std::vector< ref<Expr> > &arguments, int tid) {

    unsigned int ai = 0;
    for(llvm::Function::arg_iterator agi = function->arg_begin(); agi != function->arg_end(); agi++, ai++) { 
       llvm::outs() << "ext function operand " << ai+1 << " " << target->operands[ai+1] << "\n";
       if (target->operands[ai+1] >= 0) { // a local var
          Type *at = agi->getType();
          if (at->isPointerTy()) {
             Type *bt = at->getPointerElementType();      
                 std::string type_str;
                 llvm::raw_string_ostream rso(type_str);
                 at->print(rso);
             //if (bt->getPrimitiveSizeInBits()) {
                llvm::outs() << "Type of parameter " << ai << " is " << rso.str() << "\n";
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
                solver->setTimeout(0);             
                if (asuccess) {      
                   MemoryObject *sm = memory->allocate(TD->getTypeAllocSize(bt), op.first->isLocal, 
                           op.first->isGlobal, op.first->allocSite, TD->getPrefTypeAlignment(bt));
                   unsigned id = 0;
                   std::string name = "shadow";
                   std::string uniqueName = name;
                   while (!state.arrayNames.insert(uniqueName).second) {
                       uniqueName = name + "_" + llvm::utostr(++id);
                   }
                   // we're mimicking what executeMemoryOperation do without a relevant load or store instruction
                   const Array *array = arrayCache.CreateArray(uniqueName, sm->size);
                   ObjectState *sos = bindObjectInStateThread(state, sm, true, array,tid);
                   ref<Expr> result = sos->read(ConstantExpr::alloc(0, Expr::Int64), getWidthForLLVMType(bt));
                   ObjectState *wos = state.addressSpace.getWriteable(op.first, op.second);
                   wos->write(ConstantExpr::alloc(0, Expr::Int64), result);
                   llvm::outs() << "Wrote " << result << " to lazy init arg address " << base << " for function " << function->getName() << "\n"; 
               }
               else llvm::outs() << "Couldn't resolve address during lazy init arg: " << base << " for function " << function->getName() << "\n";
             //}

         }
       }
      }

}



const MemoryObject *Executor::symbolizeReturnValueThread(ExecutionState &state, 
                                  KInstruction *target,
                                  Function *function, int tid) {

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
    bool abort = false;
    mo = memory->allocateLazyForTypeOrEmbedding(state, state.prevPC->inst, function->getReturnType(), function->getReturnType(),  
          isLazySingle(function->getReturnType(), "*"), 1, rType, laddr, mksym, abort);
    assert(!false);
    //mo = memory->allocateForLazyInit(state, state.prevPC->inst, function->getReturnType(), isLazySingle(function->getReturnType(), "*"), 1, laddr);
    mo->name = "%sym" + std::to_string(target->dest) + "_" + function->getName().str();
    llvm::outs() << "base address of symbolic memory to be copied from " << mo->getBaseExpr() << " and real target address " << laddr << "\n";
    if (mksym)
       executeMakeSymbolicThread(state, mo, mo->name, tid);
    executeMemoryOperationThread(state, false, laddr, 0, target, tid);
    return mo;
}


ObjectState *Executor::bindObjectInStateThread(ExecutionState &state, 
                                         const MemoryObject *mo,
                                         bool isLocal,
                                         const Array *array, int tid) {
  ObjectState *os = array ? new ObjectState(mo, array) : new ObjectState(mo);
  state.addressSpace.bindObject(mo, os);

  // Its possible that multiple bindings of the same mo in the state
  // will put multiple copies on this list, but it doesn't really
  // matter because all we use this list for is to unbind the object
  // on function return.
  if (isLocal)
    state.threads[tid].stack.back().allocas.push_back(mo);
  

  return os;
}

void Executor::executeAllocThread(ExecutionState &state,
                            ref<Expr> size,
                            bool isLocal,
                            KInstruction *target,
                            int tid,
                            bool zeroMemory,
                            bool record,
                            const ObjectState *reallocFrom) {

  llvm::outs() << "tid=" << tid << "\n";
  size = toUnique(state, size);
  if (ConstantExpr *CE = dyn_cast<ConstantExpr>(size)) {
    const llvm::Value *allocSite = state.threads[tid].prevPC->inst;
    size_t allocationAlignment = getAllocationAlignment(allocSite);
    MemoryObject *mo =
        memory->allocate(CE->getZExtValue(), isLocal, /*isGlobal=*/false,
                         allocSite, allocationAlignment);

    /* SYSREL extension */
 
   if  (record)
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
      bindLocalThread(target, state, 
		      ConstantExpr::alloc(0, Context::get().getPointerWidth()), tid);
    } else {
      ObjectState *os = bindObjectInStateThread(state, mo, isLocal, 0, tid);
      if (zeroMemory) {
        os->initializeToZero();
      } else {
        os->initializeToRandom();
      }
      bindLocalThread(target, state, mo->getBaseExpr(), tid);
      
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

    StatePair fixedSize = forkThread(state, EqExpr::create(example, size), true, tid);
    
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
        executeAllocThread(*fixedSize.second, tmp, isLocal,
                     target, tid, zeroMemory, record, reallocFrom);
      } else {
        // See if a *really* big value is possible. If so assume
        // malloc will fail for it, so lets fork and return 0.
        StatePair hugeSize = 
          forkThread(*fixedSize.second, 
               UltExpr::create(ConstantExpr::alloc(1U<<31, W), size),
		     true, tid);
        if (hugeSize.first) {
          klee_message("NOTE: found huge malloc, returning 0");
          bindLocalThread(target, *hugeSize.first, 
                    ConstantExpr::alloc(0, Context::get().getPointerWidth()), tid);
        }
        
        if (hugeSize.second) {

          std::string Str;
          llvm::raw_string_ostream info(Str);
          ExprPPrinter::printOne(info, "  size expr", size);
          info << "  concretization : " << example << "\n";
          info << "  unbound example: " << tmp << "\n";
          terminateStateOnErrorThread(*hugeSize.second, "concretized symbolic size",
                                Model, NULL, info.str(), tid);
        }
      }
    }

    if (fixedSize.first) // can be zero when fork fails
      executeAllocThread(*fixedSize.first, example, isLocal, 
                   target, tid, zeroMemory, record, reallocFrom);
  }
}

void Executor::executeFreeThread(ExecutionState &state,
                           ref<Expr> address,
                           KInstruction *target, int tid) {
  StatePair zeroPointer = forkThread(state, Expr::createIsZero(address), true, tid);
  if (zeroPointer.first) {
    if (target)
      bindLocalThread(target, *zeroPointer.first, Expr::createPointer(0), tid);
  }
  if (zeroPointer.second) { // address != 0
    ExactResolutionList rl;
    resolveExactThread(*zeroPointer.second, address, rl, "free", tid);

    /* SYSREL extension */
    state.recordFree(address);
    /* SYSREL extension */
    

    for (Executor::ExactResolutionList::iterator it = rl.begin(), 
           ie = rl.end(); it != ie; ++it) {
      const MemoryObject *mo = it->first.first;
      if (mo->isLocal) {
        terminateStateOnErrorThread(*it->second, "free of alloca", Free, NULL,
                              getAddressInfo(*it->second, address), tid);
      } else if (mo->isGlobal) {
        terminateStateOnErrorThread(*it->second, "free of global", Free, NULL,
                              getAddressInfo(*it->second, address), tid);
      } else {
        it->second->addressSpace.unbindObject(mo);
        if (target)
          bindLocalThread(target, *it->second, Expr::createPointer(0), tid);
      }
    }
  }
}

void Executor::resolveExactThread(ExecutionState &state,
                            ref<Expr> p,
                            ExactResolutionList &results, 
                            const std::string &name, int tid) {
  // XXX we may want to be capping this?
  ResolutionList rl;
  state.addressSpace.resolve(state, solver, p, rl);
  
  ExecutionState *unbound = &state;
  for (ResolutionList::iterator it = rl.begin(), ie = rl.end(); 
       it != ie; ++it) {
    ref<Expr> inBounds = EqExpr::create(p, it->first->getBaseExpr());
    
    StatePair branches = forkThread(*unbound, inBounds, true, tid);
    
    if (branches.first)
      results.push_back(std::make_pair(*it, branches.first));

    unbound = branches.second;
    if (!unbound) // Fork failure
      break;
  }

  if (unbound) {
    terminateStateOnErrorThread(*unbound, "memory error: invalid pointer: " + name,
                          Ptr, NULL, getAddressInfo(*unbound, p), tid);
  }
}

void Executor::executeMemoryOperationThread(ExecutionState &state,
                                      bool isWrite,
                                      ref<Expr> address,
                                      ref<Expr> value /* undef if read */,
                                      KInstruction *target /* undef if write */, int tid) {


  /* SYSREL EXTENSION */ 
  static bool forcedOffset = false;
  /* SYSREL EXTENSION */ 



  Expr::Width type = (isWrite ? value->getWidth() : 
                     getWidthForLLVMType(target->inst->getType()));
  unsigned bytes = Expr::getMinBytesForWidth(type);

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

  if (success) {
    const MemoryObject *mo = op.first;

    if (MaxSymArraySize && mo->size>=MaxSymArraySize) {
      address = toConstant(state, address, "max-sym-array-size");
    }
    
    ref<Expr> offset = mo->getOffsetExpr(address);

    /* SYSREL EXTENSION */
    if (forcedOffset) {
       offset = ConstantExpr::alloc(0, Expr::Int64);
       llvm::outs() << "(forced) offset for target address " << offset << "\n";
    }
    /* SYSREL EXTENSION */

    bool inBounds;
    solver->setTimeout(coreSolverTimeout);
    bool success = solver->mustBeTrue(state, 
                                      mo->getBoundsCheckOffset(offset, bytes),
                                      inBounds);
    solver->setTimeout(0);
    if (!success) {
      state.threads[tid].pc = state.threads[tid].prevPC;
      terminateStateEarlyThread(state, "Query timed out (bounds check).", tid);
      return;
    }

    if (inBounds) {
      const ObjectState *os = op.second;
      if (isWrite) {
        if (os->readOnly) {
          terminateStateOnErrorThread(state, "memory error: object read only",
				      ReadOnly, NULL, "", tid);
        } else {
          ObjectState *wos = state.addressSpace.getWriteable(mo, os);
          /* SYSREL EXTENSION */
          if (forcedOffset)
             wos->write(ConstantExpr::alloc(0, Expr::Int64), value);
          else          
          /* SYSREL EXTENSION */
          wos->write(offset, value);
        }          
      } else {
        ref<Expr> result = os->read(offset, type);
        
        if (interpreterOpts.MakeConcreteSymbolic)
          result = replaceReadWithSymbolic(state, result);

        /* SYSREL EXTENSION */
       if (lazyInit) {
        if (!dyn_cast<ConstantExpr>(result)) {
            bool lazyInitTemp = false, singleInstance = false;
            llvm::Instruction *inst = state.threads[tid].prevPC->inst;       
            llvm::LoadInst *li = dyn_cast<llvm::LoadInst>(inst);
            if (li) {
               Type *t = li->getPointerOperand()->getType();
               int count = 0;
               lazyInitTemp = isLazyInit(t, singleInstance, count);
               std::string type_str;
               llvm::raw_string_ostream rso(type_str);
               t->print(rso);
               llvm::outs() << "Is " << rso.str() << " (count=" << count << ") to be lazy init?\n";
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
                  llvm::outs() << "Yes!\n";
                  llvm::outs() << "original load result: " << result << "\n";
                  std::string type_str2;
                  llvm::raw_string_ostream rso2(type_str2);
                  t->print(rso2);
                  llvm::outs() << "Allocating memory for type " << rso2.str() << " of size " << "\n"; 
                  ref<Expr> laddr;
                  llvm::Type *rType;
                  bool mksym;
                  bool abort = false;
                  const MemoryObject *mo = memory->allocateLazyForTypeOrEmbedding(state, state.threads[tid].prevPC->inst, t, t,
                             singleInstance, count, rType, laddr, mksym, abort); 
                  assert(!false);
                  //MemoryObject *mo = memory->allocateForLazyInit(state, state.threads[tid].prevPC->inst, t, singleInstance, count, laddr); 
                  mo->name = rso.str();
                  if (mksym)
                     executeMakeSymbolicThread(state, mo, rso.str(), tid);
                  llvm::outs() << "lazy initializing writing " << laddr << "( in " << mo->getBaseExpr() << ") to " << address << "\n";
                  forcedOffset = true;
                  executeMemoryOperationThread(state, true, address, laddr, 0, tid);
                  forcedOffset = false; 
                  result = mo->getBaseExpr();
              }
            }
        }
       }
        /* SYSREL EXTENSION */


        
        bindLocalThread(target, state, result, tid);

        /* SYSREL EXTENSION */

       if (lazyInit) {          
        if (!forcedOffset) { 
          Type *t;
          if (isWrite) {
             t = ((StoreInst*)target->inst)->getPointerOperand()->getType();
          }
          else  t = ((LoadInst*)target->inst)->getPointerOperand()->getType();
          if (t->isPointerTy()) {
              t = t->getPointerElementType();
              if (!t->isPointerTy()) { // not interested in the pointer's address
                 std::string tname = getTypeName(t);
                 state.typeToAddr[t] =  address;
                 llvm::outs() <<  "recorded memory to type mapping (1) as " <<  address << "->" << tname <<"\n";
              } 
          }
        }
       }
        /* SYSREL EXTENSION */


      }

      return;
    }
  } 

  // we are on an error path (no resolution, multiple resolution, one
  // resolution with out of bounds)
  
  ResolutionList rl;  
  solver->setTimeout(coreSolverTimeout);
  bool incomplete = state.addressSpace.resolve(state, solver, address, rl,
                                               0, coreSolverTimeout);
  solver->setTimeout(0);
  
  // XXX there is some query wasteage here. who cares?
  ExecutionState *unbound = &state;
  
  for (ResolutionList::iterator i = rl.begin(), ie = rl.end(); i != ie; ++i) {
    const MemoryObject *mo = i->first;
    const ObjectState *os = i->second;
    ref<Expr> inBounds = mo->getBoundsCheckPointer(address, bytes);
    
    StatePair branches = forkThread(*unbound, inBounds, true, tid);
    ExecutionState *bound = branches.first;

    // bound can be 0 on failure or overlapped 
    if (bound) {
      if (isWrite) {
        if (os->readOnly) {
          terminateStateOnErrorThread(*bound, "memory error: object read only",
				      ReadOnly, NULL, "", tid);
        } else {
          ObjectState *wos = bound->addressSpace.getWriteable(mo, os);
          wos->write(mo->getOffsetExpr(address), value);
        }
      } else {
        ref<Expr> result = os->read(mo->getOffsetExpr(address), type);
        bindLocalThread(target, *bound, result, tid);
      }
    }

    unbound = branches.second;
    if (!unbound)
      break;
  }
  
  // XXX should we distinguish out of bounds and overlapped cases?
  if (unbound) {
    if (incomplete) {
      terminateStateEarlyThread(*unbound, "Query timed out (resolve).", tid);
    } else {
      terminateStateOnErrorThread(*unbound, "memory error: out of bound pointer", Ptr,
                            NULL, getAddressInfo(*unbound, address), tid);
    }
  }
}

void Executor::executeMakeSymbolicThread(ExecutionState &state, 
                                   const MemoryObject *mo,
                                   const std::string &name, int tid) {
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
    bindObjectInStateThread(state, mo, false, array, tid);
    state.addSymbolic(mo, array);
    
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
            terminateStateOnErrorThread(state, "ran out of inputs during seeding",
					User, NULL, "", tid);
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

            terminateStateOnErrorThread(state, msg.str(), User, NULL, "", tid);
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
  } else {
    ObjectState *os = bindObjectInStateThread(state, mo, false, 0, tid);
    if (replayPosition >= replayKTest->numObjects) {
      terminateStateOnErrorThread(state, "replay count mismatch", User, NULL, "", tid);
    } else {
      KTestObject *obj = &replayKTest->objects[replayPosition++];
      if (obj->numBytes != mo->size) {
        terminateStateOnErrorThread(state, "replay size mismatch", User, NULL, "", tid);
      } else {
        for (unsigned i=0; i<mo->size; i++)
          os->write8(i, obj->bytes[i]);
      }
    }
  }
}

void Executor::executeGetValueThread(ExecutionState &state,
                               ref<Expr> e,
				     KInstruction *target, int tid) {
  e = state.constraints.simplifyExpr(e);
  std::map< ExecutionState*, std::vector<SeedInfo> >::iterator it = 
    seedMap.find(&state);
  if (it==seedMap.end() || isa<ConstantExpr>(e)) {
    ref<ConstantExpr> value;
    bool success = solver->getValue(state, e, value);
    assert(success && "FIXME: Unhandled solver failure");
    (void) success;
    bindLocalThread(target, state, value, tid);
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
    branchThread(state, conditions, branches, tid);
    
    std::vector<ExecutionState*>::iterator bit = branches.begin();
    for (std::set< ref<Expr> >::iterator vit = values.begin(), 
           vie = values.end(); vit != vie; ++vit) {
      ExecutionState *es = *bit;
      if (es)
        bindLocalThread(target, *es, *vit, tid);
      ++bit;
    }
  }
}
