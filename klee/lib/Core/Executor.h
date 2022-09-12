//===-- Executor.h ----------------------------------------------*- C++ -*-===//
//
//                     The KLEE Symbolic Virtual Machine
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// Class to perform actual execution, hides implementation details from external
// interpreter.
//
//===----------------------------------------------------------------------===//

#ifndef KLEE_EXECUTOR_H
#define KLEE_EXECUTOR_H

#include "klee/ExecutionState.h"
#include "klee/Interpreter.h"
#include "klee/Internal/Module/Cell.h"
#include "klee/Internal/Module/KInstruction.h"
#include "klee/Internal/Module/KModule.h"
#include "klee/Internal/ADT/RNG.h"
#include "klee/util/ArrayCache.h"
#include "llvm/Support/raw_ostream.h"

#include "llvm/ADT/Twine.h"

#include <vector>
#include <string>
#include <map>
#include <set>

struct KTest;

namespace llvm {
  class BasicBlock;
  class BranchInst;
  class CallInst;
  class Constant;
  class ConstantExpr;
  class Function;
  class GlobalValue;
  class Instruction;
  class LLVMContext;
  class DataLayout;
  class Twine;
  class Value;
}

namespace klee {  
  class Array;
  struct Cell;
  class ExecutionState;
  class ExternalDispatcher;
  class Expr;
  class InstructionInfoTable;
  struct KFunction;
  struct KInstruction;
  class KInstIterator;
  class KModule;
  class MemoryManager;
  class MemoryObject;
  class ObjectState;
  class PTree;
  class Searcher;
  class SeedInfo;
  class SpecialFunctionHandler;
  struct StackFrame;
  class StatsTracker;
  class TimingSolver;
  class TreeStreamWriter;
  class MergeHandler;
  template<class T> class ref;



  /// \todo Add a context object to keep track of data only live
  /// during an instruction step. Should contain addedStates,
  /// removedStates, and haltExecution, among others.

class Executor : public Interpreter {
  friend class RandomPathSearcher;
  friend class OwningSearcher;
  friend class WeightedRandomSearcher;
  friend class SpecialFunctionHandler;
  friend class StatsTracker;
  friend class MergeHandler;
  friend class MergingSearcher;

public:
  class Timer {
  public:
    Timer();
    virtual ~Timer();

    /// The event callback.
    virtual void run() = 0;
  };

  typedef std::pair<ExecutionState*,ExecutionState*> StatePair;

  enum TerminateReason {
    Abort,
    Assert,
    BadVectorAccess,
    Exec,
    External,
    Free,
    Model,
    Overflow,
    Ptr,
    ReadOnly,
    ReportError,
    User,
    Unhandled,
    /* SYSREL extension */
    NegativeRefcount
   /* SYSREL extension */
  };
public:
  KModule *kmodule;
  /* SYSREL extension */
  void checkMetadataOnCondition(ExecutionState &state);
  void executeMakeSymbolicThread(ExecutionState &state, 
                                   const MemoryObject *mo,
				   const std::string &name,
                                   int tid);
  /* SYSREL extension */

  /* SYSREL extension */
  void bindArgumentThread(KFunction *kf, unsigned index, 
                          ExecutionState &state, ref<Expr> value, int tid);

  void recordStackTrace(ExecutionState &state);

  /* SYSREL extension */

private:
  static const char *TerminateReasonNames[];

  class TimerInfo;


  InterpreterHandler *interpreterHandler;
  Searcher *searcher;

  ExternalDispatcher *externalDispatcher;

  // making it public
  //TimingSolver *solver;
 
/* SYSREL extension */
public:
  TimingSolver *solver;
  MemoryManager *memory;

  void initializeLazyInit(ExecutionState &state, const MemoryObject *mo, ObjectState *obj, 
      llvm::Type *t, unsigned count, llvm::Type *et, const MemoryObject *emo, 
      const ObjectState *eobj, unsigned eoffset, ref<Expr> address);

  const llvm::Function *getFunctionFromAddress(ref<Expr> addr);

  void symbolizeArguments(ExecutionState &state, 
                                  KInstruction *target,
                                  llvm::Function *function,
                                  std::vector< ref<Expr> > &arguments, bool &term, 
                                  std::set<unsigned> *args=NULL) ;

  void symbolizeArgumentsThread(ExecutionState &state, 
                                  KInstruction *target,
                                  llvm::Function *function,
                                  std::vector< ref<Expr> > &arguments, int tid) ;


  const MemoryObject *symbolizeReturnValueForAsmInstruction(ExecutionState &state, 
                                   KInstruction *target, llvm::Value *inst, bool &abort);

  const MemoryObject *symbolizeReturnValue(ExecutionState &state, 
                                  KInstruction *target,
                                  llvm::Function *function, bool &abort);


  const MemoryObject *symbolizeReturnValueThread(ExecutionState &state, 
                                  KInstruction *target,
                                  llvm::Function *function, int tid);

private:
/* SYSREL extension */
  std::set<ExecutionState*> states;
  StatsTracker *statsTracker;
  TreeStreamWriter *pathWriter, *symPathWriter;
  SpecialFunctionHandler *specialFunctionHandler;
  std::vector<TimerInfo*> timers;
  PTree *processTree;

  /// Keeps track of all currently ongoing merges.
  /// An ongoing merge is a set of states which branched from a single state
  /// which ran into a klee_open_merge(), and not all states in the set have
  /// reached the corresponding klee_close_merge() yet.
  std::vector<MergeHandler *> mergeGroups;

  /// ExecutionStates currently paused from scheduling because they are
  /// waiting to be merged in a klee_close_merge instruction
  std::set<ExecutionState *> inCloseMerge;

  /// Used to track states that have been added during the current
  /// instructions step. 
  /// \invariant \ref addedStates is a subset of \ref states. 
  /// \invariant \ref addedStates and \ref removedStates are disjoint.
  std::vector<ExecutionState *> addedStates;
  /// Used to track states that have been removed during the current
  /// instructions step. 
  /// \invariant \ref removedStates is a subset of \ref states. 
  /// \invariant \ref addedStates and \ref removedStates are disjoint.
  std::vector<ExecutionState *> removedStates;

  /// Used to track states that are not terminated, but should not
  /// be scheduled by the searcher.
  std::vector<ExecutionState *> pausedStates;
  /// States that were 'paused' from scheduling, that now may be
  /// scheduled again
  std::vector<ExecutionState *> continuedStates;

  /// When non-empty the Executor is running in "seed" mode. The
  /// states in this map will be executed in an arbitrary order
  /// (outside the normal search interface) until they terminate. When
  /// the states reach a symbolic branch then either direction that
  /// satisfies one or more seeds will be added to this map. What
  /// happens with other states (that don't satisfy the seeds) depends
  /// on as-yet-to-be-determined flags.
  std::map<ExecutionState*, std::vector<SeedInfo> > seedMap;
  
  /// Map of globals to their representative memory object.
  std::map<const llvm::GlobalValue*, MemoryObject*> globalObjects;

  /// Map of globals to their bound address. This also includes
  /// globals that have no representative object (i.e. functions).
  std::map<const llvm::GlobalValue*, ref<ConstantExpr> > globalAddresses;

  /* SYSREL extension */
  /// Map of globals to their bound address. This also includes
  /// globals that have no representative object (i.e. functions).
  std::map<ref<ConstantExpr>, const llvm::GlobalValue*> globalAddressesRev;
  /* SYSREL extension */

  /// The set of legal function addresses, used to validate function
  /// pointers. We use the actual Function* address as the function address.
  std::set<uint64_t> legalFunctions;

  /// When non-null the bindings that will be used for calls to
  /// klee_make_symbolic in order replay.
  const struct KTest *replayKTest;
  /// When non-null a list of branch decisions to be used for replay.
  const std::vector<bool> *replayPath;
  /// The index into the current \ref replayKTest or \ref replayPath
  /// object.
  unsigned replayPosition;

  /// When non-null a list of "seed" inputs which will be used to
  /// drive execution.
  const std::vector<struct KTest *> *usingSeeds;  

  /// Disables forking, instead a random path is chosen. Enabled as
  /// needed to control memory usage. \see fork()
  bool atMemoryLimit;

  /// Disables forking, set by client. \see setInhibitForking()
  bool inhibitForking;

  /// Signals the executor to halt execution at the next instruction
  /// step.
  bool haltExecution;  

  /// Whether implied-value concretization is enabled. Currently
  /// false, it is buggy (it needs to validate its writes).
  bool ivcEnabled;

/* SYSREL EXTENSION */
public:
/* SYSREL EXTENSION */
  /// The maximum time to allow for a single core solver query.
  /// (e.g. for a single STP query)
  double coreSolverTimeout;

private:
  /// Assumes ownership of the created array objects
  ArrayCache arrayCache;

  /// File to print executed instructions to
  llvm::raw_ostream *debugInstFile;

  // @brief Buffer used by logBuffer
  std::string debugBufferString;

  // @brief buffer to store logs before flushing to file
  llvm::raw_string_ostream debugLogBuffer;

/* SYSREL extension */ 
public:
  llvm::Function* getTargetFunction(llvm::Value *calledVal,
                                    ExecutionState &state);

private:  
/* SYSREL extension */
  void executeInstruction(ExecutionState &state, KInstruction *ki);

  /* SYSREL extension */
  void executeInstructionThread(ExecutionState &state, KInstruction *ki, int tid);
  /* SYSREL extension */

  void printFileLine(ExecutionState &state, KInstruction *ki,
                     llvm::raw_ostream &file);

  void run(ExecutionState &initialState);

  public:
  /* SYSREL extension */

  void constrainPath(ExecutionState &state, ref<Expr> &e, int value);

  void constrainPath(ExecutionState &state, ref<Expr> &e);

  void constrainPath(ExecutionState &state, MemoryObject *mo, ObjectState *sos, std::string value, bool nullTerm);

  void constrainPath(ExecutionState &state, std::string fname, int argno, MemoryObject *mo, ObjectState *sos, ref<Expr> &e);

  void initArgsAsSymbolic(ExecutionState &state, llvm::Function *f, bool &abort, bool nosym=false); 
  /* SYSREL extension */

  private:

  // Given a concrete object in our [klee's] address space, add it to 
  // objects checked code can reference.
  MemoryObject *addExternalObject(ExecutionState &state, void *addr, 
                                  unsigned size, bool isReadOnly);

  /* SYSREL extension */
  MemoryObject * addExternalObjectThread(ExecutionState &state, 
                                           void *addr, unsigned size, 
						  bool isReadOnly, int tid); 
  /* SYSREL extension */

  void initializeGlobalObject(ExecutionState &state, ObjectState *os, 
			      const llvm::Constant *c,
			      unsigned offset);
  void initializeGlobals(ExecutionState &state);

  void stepInstruction(ExecutionState &state);
  /* SYSREL extension */
  void stepInstructionThread(ExecutionState &state, int tid);
  /* SYSREL extension */

  void updateStates(ExecutionState *current);
  void transferToBasicBlock(llvm::BasicBlock *dst, 
			    llvm::BasicBlock *src,
			    ExecutionState &state);

  /* SYSREL extension */
  void transferToBasicBlockThread(llvm::BasicBlock *dst, llvm::BasicBlock *src, 
					  ExecutionState &state, int tid) ;
  /* SYSREL extension */

  void callExternalFunction(ExecutionState &state,
                            KInstruction *target,
                            llvm::Function *function,
                            std::vector< ref<Expr> > &arguments);

  /* SYSREL extension */
  void callExternalFunctionThread(ExecutionState &state,
                                    KInstruction *target,
                                    llvm::Function *function,
					    std::vector< ref<Expr> > &arguments, int tid);


  /* SYSREL extension */
  public:
  ObjectState *bindObjectInState(ExecutionState &state, const MemoryObject *mo,
                                 bool isLocal, const Array *array = 0);
  /* SYSREL extension */
  ObjectState *bindObjectInStateThread(ExecutionState &state, 
                                         const MemoryObject *mo,
                                         bool isLocal,
				       const Array *array, int tid);
  /* SYSREL extension */
  private:
  /// Resolve a pointer to the memory objects it could point to the
  /// start of, forking execution when necessary and generating errors
  /// for pointers to invalid locations (either out of bounds or
  /// address inside the middle of objects).
  ///
  /// \param results[out] A list of ((MemoryObject,ObjectState),
  /// state) pairs for each object the given address can point to the
  /// beginning of.
  typedef std::vector< std::pair<std::pair<const MemoryObject*, const ObjectState*>, 
                                 ExecutionState*> > ExactResolutionList;
  void resolveExact(ExecutionState &state,
                    ref<Expr> p,
                    ExactResolutionList &results,
                    const std::string &name);
  /* SYSREL extension */
  void resolveExactThread(ExecutionState &state,
                            ref<Expr> p,
                            ExactResolutionList &results, 
			  const std::string &name, int tid);
  /* SYSREL extension */
  /// Allocate and bind a new object in a particular state. NOTE: This
  /// function may fork.
  ///
  /// \param isLocal Flag to indicate if the object should be
  /// automatically deallocated on function return (this also makes it
  /// illegal to free directly).
  ///
  /// \param target Value at which to bind the base address of the new
  /// object.
  ///
  /// \param reallocFrom If non-zero and the allocation succeeds,
  /// initialize the new object from the given one and unbind it when
  /// done (realloc semantics). The initialized bytes will be the
  /// minimum of the size of the old and new objects, with remaining
  /// bytes initialized as specified by zeroMemory.
  public:

  void generateValuedInstruction(ExecutionState &state, KInstruction *ki);


  void executeAlloc(ExecutionState &state,
                    ref<Expr> size,
                    bool isLocal,
                    KInstruction *target,
                    bool zeroMemory=false,
                    bool record = false,
                    const ObjectState *reallocFrom=0);
  /* SYSREL extension */
  void executeAllocThread(ExecutionState &state,
                            ref<Expr> size,
                            bool isLocal,
                            KInstruction *target,
                            int tid,
                            bool zeroMemory=false,
                            bool record=false,
				    const ObjectState *reallocFrom=0);
  /* SYSREL extension */
  /// Free the given address with checking for errors. If target is
  /// given it will be bound to 0 in the resulting states (this is a
  /// convenience for realloc). Note that this function can cause the
  /// state to fork and that \ref state cannot be safely accessed
  /// afterwards.
  void executeFree(ExecutionState &state,
                   ref<Expr> address,
                   KInstruction *target = 0);
  /* SYSREL extension */
  void executeFreeThread(ExecutionState &state,
                           ref<Expr> address,
				   KInstruction *target, int tid);
  /* SYSREL extension */   
  void executeCall(ExecutionState &state, 
                   KInstruction *ki,
                   llvm::Function *f,
                   std::vector< ref<Expr> > &arguments);
  /* SYSREL extension */              
  void executeCallThread(ExecutionState &state, 
                           KInstruction *ki,
                           llvm::Function *f,
				 std::vector< ref<Expr> > &arguments, int tid);
  /* SYSREL extension */  
  public: 

  // Returns the address of the lazily created object or NULL if none created
  ref<Expr> performLazyInit(ExecutionState &state,
                                    ref<Expr> address,
                                    ref<Expr> offset,
                                    ref<Expr> result, 
                                    KInstruction *target,
                                    ObjectPair op,
                                    bool &abort 
                                   );

  // do address resolution / object binding / out of bounds checking
  // and perform the operation
  /* SYSREL extension */ // return value is used for abort signaling
  bool executeMemoryOperation(ExecutionState &state,
                              bool isWrite,
                              ref<Expr> address,
                              ref<Expr> value /* undef if read */,
                              KInstruction *target /* undef if write */);
  /* SYSREL extension */
  bool loadPointerArguments(ExecutionState &state,   
                                  KInstruction *target,
                                  llvm::Function *function,
                                  std::vector< ref<Expr> > &arguments,
                                  ref<Expr> &offendingAddress);
  bool executeCheckAddressInBound(ExecutionState &state,
                                  ref<Expr> address, 
                                  llvm::Type *type,
                                  bool &memoryerror); 
  void executeMemoryOperationThread(ExecutionState &state,
                                      bool isWrite,
                                      ref<Expr> address,
                                      ref<Expr> value /* undef if read */,
					      KInstruction *target /* undef if write */, int tid) ;
  void clearFunctionPointers(const MemoryObject *mo, ObjectState *os, llvm::Type *at);
  /* SYSREL extension */  
  ObjectState *executeMakeSymbolic(ExecutionState &state, const MemoryObject *mo,
                           const std::string &name, 
                           bool forLazyInit=false, 
                           llvm::Type *t=NULL, 
                           bool clrFncPtr = false, unsigned count=1,
                           llvm::Type *et=NULL, const MemoryObject *emo=NULL,  
                           const ObjectState *eobj=NULL, unsigned eoffset=0, ref<Expr> address=NULL);


   private:

  /// Create a new state where each input condition has been added as
  /// a constraint and return the results. The input state is included
  /// as one of the results. Note that the output vector may included
  /// NULL pointers for states which were unable to be created.
  void branch(ExecutionState &state, 
              const std::vector< ref<Expr> > &conditions,
              std::vector<ExecutionState*> &result);
  /* SYSREL extension */
  void branchThread(ExecutionState &state, 
                      const std::vector< ref<Expr> > &conditions,
			    std::vector<ExecutionState*> &result, int tid);
  /* SYSREL extension */
public:
  // Fork current and return states in which condition holds / does
  // not hold, respectively. One of the states is necessarily the
  // current state, and one of the states may be null.
  StatePair fork(ExecutionState &current, ref<Expr> condition, bool isInternal);
  /* SYSREL extension */
  StatePair forkThread(ExecutionState &current, ref<Expr> condition, bool isInternal, int tid) ;

  /* SYSREL extension */
  /// Add the given (boolean) condition as a constraint on state. This
  /// function is a wrapper around the state's addConstraint function
  /// which also manages propagation of implied values,
  /// validity checks, and seed patching.
  void addConstraint(ExecutionState &state, ref<Expr> condition);

  // Called on [for now] concrete reads, replaces constant with a symbolic
  // Used for testing.
  ref<Expr> replaceReadWithSymbolic(ExecutionState &state, ref<Expr> e);

  const Cell& eval(KInstruction *ki, unsigned index, 
                   ExecutionState &state) const;
  /* SYSREL extension */
  const Cell& eval(KInstruction *ki, unsigned index, 
                           ExecutionState &state, StackFrame *sf) const;
  const Cell& evalThread(KInstruction *ki, unsigned index, 
				 ExecutionState &state, int tid) const;
private:
  /* SYSREL extension */
  Cell& getArgumentCell(ExecutionState &state,
                        KFunction *kf,
                        unsigned index) {
    llvm::errs() << " arg " << index << " mapping to " << kf->getArgRegister(index) << "\n";
    llvm::errs() << "local array " << state.stack.back().locals << "\n";
    return state.stack.back().locals[kf->getArgRegister(index)];
  }
  /* SYSREL extension */
  Cell& getArgumentCellThread(ExecutionState &state,
                        KFunction *kf,
                        unsigned index, int tid) {
    return state.threads[tid].stack.back().locals[kf->getArgRegister(index)];
  }
  /* SYSREL extension */
  public:
  Cell& getDestCell(ExecutionState &state,
                    KInstruction *target) {
    llvm::errs() << "cell for destination register " << target->dest << "\n";
    llvm::errs() << "locals array " << state.stack.back().locals << "\n";
    return state.stack.back().locals[target->dest];
  }

  /* SYSREL extension */
  Cell& getDestCellThread(ExecutionState &state,
                    KInstruction *target, int tid) {
    return state.threads[tid].stack.back().locals[target->dest];
  }
  /* SYSREL extension */
  void bindLocal(KInstruction *target, 
                 ExecutionState &state, 
                 ref<Expr> value);
  /* SYSREL extension */
  void bindLocalThread(KInstruction *target, ExecutionState &state, 
		       ref<Expr> value, int tid);
  private:
  /* SYSREL extension */
  void bindArgument(KFunction *kf, 
                    unsigned index,
                    ExecutionState &state,
                    ref<Expr> value);
  /// Evaluates an LLVM constant expression.  The optional argument ki
  /// is the instruction where this constant was encountered, or NULL
  /// if not applicable/unavailable.
  ref<klee::ConstantExpr> evalConstantExpr(const llvm::ConstantExpr *c,
					   const KInstruction *ki = NULL);

  /// Evaluates an LLVM constant.  The optional argument ki is the
  /// instruction where this constant was encountered, or NULL if
  /// not applicable/unavailable.
  ref<klee::ConstantExpr> evalConstant(const llvm::Constant *c,
				       const KInstruction *ki = NULL);

  /// Return a unique constant value for the given expression in the
  /// given state, if it has one (i.e. it provably only has a single
  /// value). Otherwise return the original expression.
  ref<Expr> toUnique(const ExecutionState &state, ref<Expr> &e);

 public:

  /// Return a constant value for the given expression, forcing it to
  /// be constant in the given state by adding a constraint if
  /// necessary. Note that this function breaks completeness and
  /// should generally be avoided.
  ///
  /// \param purpose An identify string to printed in case of concretization.
  ref<klee::ConstantExpr> toConstant(ExecutionState &state, ref<Expr> e, 
                                     const char *purpose);

private:
  /// Bind a constant value for e to the given target. NOTE: This
  /// function may fork state if the state has multiple seeds.
  void executeGetValue(ExecutionState &state, ref<Expr> e, KInstruction *target);
  /* SYSREL extension */
  void executeGetValueThread(ExecutionState &state,
                               ref<Expr> e,
			     KInstruction *target, int tid); 
  /* SYSREL extension */
  /// Get textual information regarding a memory address.
  std::string getAddressInfo(ExecutionState &state, ref<Expr> address) const;

  // Determines the \param lastInstruction of the \param state which is not KLEE
  // internal and returns its InstructionInfo
  const InstructionInfo & getLastNonKleeInternalInstruction(const ExecutionState &state,
      llvm::Instruction** lastInstruction);
  /* SYSREL extension */
  const InstructionInfo & getLastNonKleeInternalInstructionThread(const ExecutionState &state,
								  llvm::Instruction ** lastInstruction, int tid);
  /* SYSREL extension */
  bool shouldExitOn(enum TerminateReason termReason);

  // remove state from searcher only
  void pauseState(ExecutionState& state);
  // add state to searcher only
  void continueState(ExecutionState& state);
  // remove state from queue and delete
  void terminateState(ExecutionState &state);
  /* SYSREL extension */
  void terminateStateThread(ExecutionState &state, int tid);
  /* SYSREL extension */
  // call exit handler and terminate state
  void terminateStateEarly(ExecutionState &state, const llvm::Twine &message);
  /* SYSREL extension */
  void terminateStateEarlyThread(ExecutionState &state, 
				 const llvm::Twine &message, int tid);
  /* SYSREL extension */
  // call exit handler and terminate state
  void terminateStateOnExit(ExecutionState &state);
  /* SYSREL extension */
  void terminateStateOnExitThread(ExecutionState &state, int tid);
  /* SYSREL extension */
public:
  // call error handler and terminate state
  void terminateStateOnError(ExecutionState &state, const llvm::Twine &message,
                             enum TerminateReason termReason,
                             const char *suffix = NULL,
                             const llvm::Twine &longMessage = "");
  /* SYSREL extension */
  void terminateStateOnErrorThread(ExecutionState &state,
                                     const llvm::Twine &messaget,
                                     enum TerminateReason termReason,
                                     const char *suffix,
					     const llvm::Twine &info, int tid);
  /* SYSREL extension */
  // call error handler and terminate state, for execution errors
  // (things that should not be possible, like illegal instruction or
  // unlowered instrinsic, or are unsupported, like inline assembly)
  void terminateStateOnExecError(ExecutionState &state, 
                                 const llvm::Twine &message,
                                 const llvm::Twine &info="") {
    terminateStateOnError(state, message, Exec, NULL, info);
  }
  /* SYSREL extension */ 
  void terminateStateOnExecErrorThread(ExecutionState &state, 
                                 const llvm::Twine &message,
				       const llvm::Twine &info, int tid) {
    terminateStateOnErrorThread(state, message, Exec, NULL, info, tid);
  }
  /* SYSREL extension */
  /// bindModuleConstants - Initialize the module constant table.
  void bindModuleConstants();

  template <typename TypeIt>
  void computeOffsets(KGEPInstruction *kgepi, TypeIt ib, TypeIt ie);

  /// bindInstructionConstants - Initialize any necessary per instruction
  /// constant values.
  void bindInstructionConstants(KInstruction *KI);

  void handlePointsToObj(ExecutionState &state, 
                         KInstruction *target, 
                         const std::vector<ref<Expr> > &arguments);

  void doImpliedValueConcretization(ExecutionState &state,
                                    ref<Expr> e,
                                    ref<ConstantExpr> value);

  /// Add a timer to be executed periodically.
  ///
  /// \param timer The timer object to run on firings.
  /// \param rate The approximate delay (in seconds) between firings.
  void addTimer(Timer *timer, double rate);

  void initTimers();
  void processTimers(ExecutionState *current,
                     double maxInstTime);
  void checkMemoryUsage();
  void printDebugInstructions(ExecutionState &state);
  void doDumpStates();

public:
  Executor(llvm::LLVMContext &ctx, const InterpreterOptions &opts,
      InterpreterHandler *ie);
  virtual ~Executor();

  /* SYSREL extension */
  StatsTracker *getStatsTracker() { return statsTracker; }
  /* SYSREL extension */

  const InterpreterHandler& getHandler() {
    return *interpreterHandler;
  }

  virtual void setPathWriter(TreeStreamWriter *tsw) {
    pathWriter = tsw;
  }
  virtual void setSymbolicPathWriter(TreeStreamWriter *tsw) {
    symPathWriter = tsw;
  }

  virtual void setReplayKTest(const struct KTest *out) {
    assert(!replayPath && "cannot replay both buffer and path");
    replayKTest = out;
    replayPosition = 0;
  }

  virtual void setReplayPath(const std::vector<bool> *path) {
    assert(!replayKTest && "cannot replay both buffer and path");
    replayPath = path;
    replayPosition = 0;
  }

  virtual const llvm::Module *
  setModule(llvm::Module *module, const ModuleOptions &opts);

  virtual void useSeeds(const std::vector<struct KTest *> *seeds) { 
    usingSeeds = seeds;
  }

  virtual void runFunctionAsMain(llvm::Function *f,
                                 int argc,
                                 char **argv,
                                 char **envp);

  virtual void computeDontCareTransitions(int argc,
                                 char **argv,
                                 char **envp);

  /*** Runtime options ***/
  
  virtual void setHaltExecution(bool value) {
    haltExecution = value;
  }

  virtual void setInhibitForking(bool value) {
    inhibitForking = value;
  }

  void prepareForEarlyExit();

  /*** State accessor methods ***/

  virtual unsigned getPathStreamID(const ExecutionState &state);

  virtual unsigned getSymbolicPathStreamID(const ExecutionState &state);

  virtual void getConstraintLog(const ExecutionState &state,
                                std::string &res,
                                Interpreter::LogType logFormat = Interpreter::STP);

  virtual bool getSymbolicSolution(const ExecutionState &state, 
                                   std::vector< 
                                   std::pair<std::string,
                                   std::vector<unsigned char> > >
                                   &res);

  virtual void getCoveredLines(const ExecutionState &state,
                               std::map<const std::string*, std::set<unsigned> > &res);

  Expr::Width getWidthForLLVMType(llvm::Type *type) const;
  size_t getAllocationAlignment(const llvm::Value *allocSite) const;

  /// Returns the errno location in memory of the state
  int *getErrnoLocation(const ExecutionState &state) const;
};
  
} // End klee namespace

  // const llvm::fltSemantics * fpWidthToSemantics(unsigned width);
#endif
