//===-- ExecutionState.h ----------------------------------------*- C++ -*-===//
//
//                     The KLEE Symbolic Virtual Machine
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#ifndef KLEE_EXECUTIONSTATE_H
#define KLEE_EXECUTIONSTATE_H
/* SYSREL extension */
#include "llvm/IR/Function.h"
#include "llvm/IR/Value.h"
#include <queue>
#include "../../lib/Core/SpecialFunctionHandler.h"
#include "../../lib/Prose/Prose.h"
/* SYSREL extension */
#include "klee/Constraints.h"
#include "klee/Expr.h"
#include "klee/Internal/ADT/TreeStream.h"
#include "klee/MergeHandler.h"

// FIXME: We do not want to be exposing these? :(
#include "../../lib/Core/AddressSpace.h"
#include "klee/Internal/Module/KInstIterator.h"


#include <map>
#include <set>
#include <vector>

namespace klee {
class MemoryManager;
class Array;
class CallPathNode;
struct Cell;
struct KFunction;
struct KInstruction;
class MemoryObject;
class PTreeNode;
struct InstructionInfo;

llvm::raw_ostream &operator<<(llvm::raw_ostream &os, const MemoryMap &mm);

struct StackFrame {
  KInstIterator caller;
  KFunction *kf;
  CallPathNode *callPathNode;

  std::vector<const MemoryObject *> allocas;
  Cell *locals;

  /// Minimum distance to an uncovered instruction once the function
  /// returns. This is not a good place for this but is used to
  /// quickly compute the context sensitive minimum distance to an
  /// uncovered instruction. This value is updated by the StatsTracker
  /// periodically.
  unsigned minDistToUncoveredOnReturn;

  // For vararg functions: arguments not passed via parameter are
  // stored (packed tightly) in a local (alloca) memory object. This
  // is set up to match the way the front-end generates vaarg code (it
  // does not pass vaarg through as expected). VACopy is lowered inside
  // of intrinsic lowering.
  MemoryObject *varargs;

  StackFrame(KInstIterator caller, KFunction *kf);
  StackFrame(const StackFrame &s);
  ~StackFrame();
};

/* SYSREL extension begin */

/*class tuple{
  protected:
	ref<Expr> prevState;
	ref<Expr> nextState;
	ref<Expr> input;
	ref<Expr> output;
};*/


struct ConstrainValue {
  enum vtype {INT_TYPE, STRING_TYPE, UNDEF};
  vtype type;
  int ival;
  std::string sval;
};

typedef struct ConstrainValue ConstrainValue_t;

class Async {
public:
  Async(ExecutionState *state, llvm::Function *f, int tid, MemoryManager *memory);
  Async(const Async&);
  llvm::Function *function;
  KFunction *kfunction;
  std::vector<StackFrame> stack;
  KInstIterator pc;
  KInstIterator prevPC;
  unsigned incomingBBIndex;
  bool preemptable;
  int tid;
  ExecutionState *context;
  bool terminated;
  // programming model specific state
  std::map<ref<Expr>,int> stateModel;  
  std::map<ref<Expr>, ref<Expr> > assocModel; 
  std::map<std::string, int> returnValueModel;
};

class AsyncInfo { 
public:
  AsyncInfo(llvm::Function *);
  llvm::Function *function;
  //unsigned blockNo;
  unsigned count;
  unsigned numstarted;
};

enum lcmType { sequential, identifier, parallel};

class Sequential {
private:
  std::vector<Sequential*> sequence;
  bool finalized;
protected:
  lcmType type; 
public:
  Sequential(); 
  void addStep(Sequential *seq);
  void printStep(unsigned int s);
  virtual void print();
  void finalize();
  bool isFinalized();
  unsigned int getNumSteps();
  Sequential *getStep(unsigned int);
  lcmType getType() ;
};



class Identifier : public Sequential {
private:
  std::string name;
  int successretval;
  BoundAST *bast;
public:
  Identifier(std::string s);
  BoundAST *getSuccessConstraint();
  void setSuccessConstraint(BoundAST *);  
  void setSuccessReturnValue(int);
  int getSuccessReturnValue();
  virtual void print();
  std::string getValue();
};

class Parallel : public Sequential {
private:
  std::vector<std::string> par;
public:
  Parallel(std::vector<std::string> p);
  int getNumInstance(std::string s);
  bool member(std::string s);
  std::vector<std::string> getComponents();
  virtual void print(); 
};



class LifeCycleModelState {
private:
  unsigned int state;
  bool initialized;
  bool completed;
  std::vector<std::string> componentsCompleted;
public: 
  static Sequential *lcm;
  static void setLifeCycleModel(Sequential *lcm);
  static Sequential *getLifeCycleModel();
  LifeCycleModelState();
  LifeCycleModelState(LifeCycleModelState&);
  bool moveStep();
  int getCurrentStep();
  int getCurrentSuccessValue();
  BoundAST *getCurrentSuccessConstraint();
  bool hasCompleted();
  bool isInitialized();
  void setInitialized();
  bool stepMovesWhenReturns(std::string);
  bool isCompleted();
  bool completesWith(std::string);
};

class PMFrame {
  private:
   int currentAction;
   APIAction *action;
   KInstruction *target;
   std::vector<ref<Expr> > args;
   int tid;
   std::string callback;
   friend class ExecutionState;
  public:
    PMFrame();
    PMFrame(APIAction *a, std::vector< ref<Expr> > &arguments, 
             KInstruction *target, int tid=-1);
    PMFrame(const PMFrame&);
    void execute(ExecutionState &state, bool &term, bool &comp, bool &abort, ref<Expr> &offendingAddress);
    void setCallback(std::string);
    void setPMAction(int);

};


/* SYSREL extension end */




/// @brief ExecutionState representing a path under exploration
class ExecutionState {
public:
  typedef std::vector<StackFrame> stack_ty;
  /* SYSREL extension begin */
  bool terminated;
  std::vector<std::pair<llvm::Value*,ref<Expr> > > lastValuedInst;
  std::string lastContext;
  const MemoryObject *lastMallocedMem;
  unsigned int stackFrameBeforeExecInst;
  ref<Expr> lastConstraint, lastBranchInstConstraint;
  std::map<ref<Expr>,int> lockModel;
  std::map<ref<Expr>,int> stateModel;
  std::map<ref<Expr>, ref<Expr> > assocModel; 
  std::map<std::string, long int> returnValueModel;
  std::map<ref<Expr>, int> refCountModel;
  std::map<ref<Expr>, std::vector<std::string> > refCountStack;
  std::map<ref<Expr>, ref<Expr> > metadataMap; 
  std::map<std::string, ref<Expr> > symbolDefs;
  std::map<std::string, llvm::Type *> symbolTypes;
  std::map<llvm::Type*, ref<Expr> > typeToAddr;
  std::map<ref<Expr>, llvm::Type*> addrToCastFromStructType;
  std::map<std::string, long int> symIdCounters;
  std::vector<PMFrame*> pmstack;
  void pushPMFrame(APIAction *a, std::vector< ref<Expr> > arguments, 
             KInstruction *target, int tid=-1);
  void popPMFrame();
  bool isPMStackEmpty();
  int getPMAction();
  int getPMNumActions();
  void executePM(bool &abort, ref<Expr> &offendingAddress);
  void setPMCallback(std::string cbn);
  std::string getPMCallback();
  void checkAndSetPMCallbackCompleted(std::string cbn);
  bool hasLCM();
  int getLCMState();
  bool lcmCompleted();
  void updateLCMState();
  bool lcmStepMovesWhenReturns(std::string);
  int getCurrentSuccessReturnValue();
  BoundAST *getCurrentSuccessConstraint();
  static void setLifeCycleModel(Sequential *lcm);
  void setWaitingForThreadsToTerminate(bool);
  bool getWaitingForThreadsToTerminate(); 
  void terminateThread(int tid);
  bool activeThreads();
  bool threadTerminated(int tid);
  void printPC();
  int getID();
  bool lcmCompletesWith(std::string);
  void addSymbolDef(std::string, ref<Expr>);
  ref<Expr> getSymbolDef(std::string);
  void addSymbolType(std::string, llvm::Type*);
  void recordRefcountOp(ref<Expr>, std::string);
  void check(); 
  llvm::Type *getSymbolType(std::string);  
  std::map<llvm::Type *, MemoryObject *> lazyInitSingleInstances;
  double getCustomWeight();
  static double CustomWeightThreshold;
  static std::string  CustomWeightType;
  /* SYSREL extension begin */
private:
  // unsupported, use copy constructor
  ExecutionState &operator=(const ExecutionState &);

  std::map<std::string, std::string> fnAliases;
  /* SYSREL extension begin */
  static int counter;
  int id;
  bool waitingForThreadsToTerminate;
  LifeCycleModelState *lcmState;
  std::set<ref<Expr> > alloced;
  std::set<ref<Expr> > freed;
  /* SYSREL extension begin */
public:
  /* SYSREL extension begin */
  std::vector<Async> threads;
  // -1 is used for the main thread
  std::queue<int> threadsQueue;
  // running thread id; -1 denotes the main thread
  int rtid; 
  bool preemptable = false; 
  std::map<std::string,AsyncInfo> initiatedAsync;
  
  int initiateAsync(llvm::Function *f);
  int scheduleAsync(MemoryManager *memory);
  int setPreemptable(int tid, bool value);
  void setRefCount(ref<Expr>,int); 
  int getRefCount(ref<Expr>); 
  void setMetadata(ref<Expr>, ref<Expr>);
  ref<Expr> getMetadata(ref<Expr>);
  std::string getUnique(std::string);
  /* SYSREL extension end */
  // Execution - Control Flow specific

  /// @brief Pointer to instruction to be executed after the current
  /// instruction
  KInstIterator pc;

  /// @brief Pointer to instruction which is currently executed
  KInstIterator prevPC;

  /// @brief Stack representing the current instruction stream
  stack_ty stack;

  /// @brief Remember from which Basic Block control flow arrived
  /// (i.e. to select the right phi values)
  unsigned incomingBBIndex;

  // Overall state of the state - Data specific

  /// @brief Address space used by this state (e.g. Global and Heap)
  AddressSpace addressSpace;

  /// @brief Constraints collected so far
  ConstraintManager constraints;

  /// Statistics and information

  /// @brief Costs for all queries issued for this state, in seconds
  mutable double queryCost;

  /// @brief Weight assigned for importance of this state.  Can be
  /// used for searchers to decide what paths to explore
  double weight;

  /// @brief Exploration depth, i.e., number of times KLEE branched for this state
  unsigned depth;

  /// @brief History of complete path: represents branches taken to
  /// reach/create this state (both concrete and symbolic)
  TreeOStream pathOS;

  /// @brief History of symbolic path: represents symbolic branches
  /// taken to reach/create this state
  TreeOStream symPathOS;

  /// @brief Counts how many instructions were executed since the last new
  /// instruction was covered.
  unsigned instsSinceCovNew;

  /// @brief Whether a new instruction was covered in this state
  bool coveredNew;

  /// @brief Disables forking for this state. Set by user code
  bool forkDisabled;

  /// @brief Set containing which lines in which files are covered by this state
  std::map<const std::string *, std::set<unsigned> > coveredLines;

  /// @brief Pointer to the process tree of the current state
  PTreeNode *ptreeNode;

  /// @brief Ordered list of symbolics: used to generate test cases.
  //
  // FIXME: Move to a shared list structure (not critical).
  std::vector<std::pair<const MemoryObject *, const Array *> > symbolics;

  /// @brief Set of used array names for this state.  Used to avoid collisions.
  std::set<std::string> arrayNames;

  std::string getFnAlias(std::string fn);
  void addFnAlias(std::string old_fn, std::string new_fn);
  void removeFnAlias(std::string fn);

  // The objects handling the klee_open_merge calls this state ran through
  std::vector<ref<MergeHandler> > openMergeStack;

  // The numbers of times this state has run through Executor::stepInstruction
  std::uint64_t steppedInstructions;

private:
  ExecutionState() : ptreeNode(0) {}

public:
  ExecutionState(KFunction *kf);

  // XXX total hack, just used to make a state so solver can
  // use on structure
  ExecutionState(const std::vector<ref<Expr> > &assumptions);

  ExecutionState(const ExecutionState &state);

  /* SYSREL EXTENSION */
  // continue a path after termination with a new function executed sequentially
  void extendExecutionWith(KFunction *kf);
  /* SYSREL EXTENSION */
  

  ~ExecutionState();

  ExecutionState *branch();

  void pushFrame(KInstIterator caller, KFunction *kf);
  /* SYSREL extension */
  void pushFrameThread(KInstIterator caller, KFunction *kf, int tid);
  /* SYSREL extension */
  void popFrame();
  /* SYSREL extension */
  void popFrameThread(int tid);
  /* SYSREL extension */

  void addSymbolic(const MemoryObject *mo, const Array *array);
  void addConstraint(ref<Expr> e) { constraints.addConstraint(e); }

  bool merge(const ExecutionState &b);
  void dumpStack(llvm::raw_ostream &out) const;
  /* SYSREL extension */
  void dumpStackThread(llvm::raw_ostream &out) const;
  void recordAlloc(ref<Expr>);
  void recordFree(ref<Expr>);
  bool isFreed(ref<Expr>); 
  /* SYSREL extension */
};
}

#endif
