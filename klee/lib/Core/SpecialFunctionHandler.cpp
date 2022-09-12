//===-- SpecialFunctionHandler.cpp ----------------------------------------===//
//
//                     The KLEE Symbolic Virtual Machine
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "Memory.h"
#include "SpecialFunctionHandler.h"
#include "TimingSolver.h"
#include "klee/MergeHandler.h"

#include "klee/ExecutionState.h"
#include "klee/util/ExprPPrinter.h"

#include "klee/Internal/Module/KInstruction.h"
#include "klee/Internal/Module/KModule.h"
#include "klee/Internal/Support/Debug.h"
#include "klee/Internal/Support/ErrorHandling.h"
#include "klee/Internal/System/Time.h"

#include "Executor.h"
#include "MemoryManager.h"
/* SYSREL extension */
#include "StatsTracker.h"
/* SYSREL extension */
#include "klee/CommandLine.h"

#include "llvm/IR/Module.h"
#include "llvm/ADT/Twine.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/CallSite.h"
#include "llvm/IR/TypeFinder.h"
#include "llvm/IR/LLVMContext.h"

#include <errno.h>
#include <sstream>
#include <fstream>
#include <tuple>
using namespace llvm;
using namespace klee;

std::map<ref<Expr>, std::vector<ref<Expr> > > globalPCVctMap;
std::map<ref<Expr>, std::set<ref<Expr> > > globalASSctMap; //global assertion signal set

std::map<ref<Expr>, std::set<ref<Expr> > > globalInputSetMap;/* For 1 input variable FSM */
std::map<ref<Expr>, std::set<ref<Expr> > > globalTwoInputSetMap;/* For 2 inputs variable FSM */
std::map<ref<Expr>, std::set<ref<Expr> > > globalThreeInputSetMap;/* For 3 input variable FSM */
std::map<ref<Expr>, std::set<ref<Expr> > > globalFourInputSetMap;/* For 4 input variable FSM */
std::map<ref<Expr>, std::set<ref<Expr> > > globalFiveInputSetMap;/* For 5 input variable FSM */
std::map<ref<Expr>, std::set<ref<Expr> > > globalMetadataSetMap;

std::map<ref<Expr>, std::vector<ref<Expr> > > globalTransitionPrevVectorMap;
std::map<ref<Expr>, std::vector<ref<Expr> > > globalTransitionNextVectorMap;
std::map<ref<Expr>, std::vector<ref<Expr> > > globalTransitionInputVectorMap;

std::map<ref<Expr>, std::set<std::tuple<ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr> , ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>>> > globalRegTupleForward; //arg[1]->stateVar, other is regVar
std::map<ref<Expr>, std::set<std::tuple<ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr> , ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>>> > globalRegTupleBackward;
std::map<ref<Expr>, std::set<std::tuple<ref<Expr>, ref<Expr>>> > globalOneRegTupleForward; //arg[1]->stateVar, other is regVar
std::map<ref<Expr>, std::set<std::tuple<ref<Expr>, ref<Expr>>> > globalOneRegTupleBackward;
static int numofstates = 0;
double dontCareFinishTime = 0;
double addBackOutputfinishTime;

std::map<ref<Expr>, std::set<std::tuple<ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr> > > > globalOutputTupleForward;
std::map<ref<Expr>, std::set<std::tuple<ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr> > > > globalOutputTupleBackward;

std::map<ref<Expr>, std::set<std::tuple<ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>, double > > > globalOutputTupleFindAllTransFromSrc;

std::map<ref<Expr>, std::vector<ref<Expr> > > globalOutputVectorMap;


std::map<long, std::map<ref<Expr>, std::set<ref<Expr> > > > localInputSetMap;/* For 1 input variable FSM */
std::map<long, std::map<ref<Expr>, std::set<ref<Expr> > > > localTwoInputSetMap;/* For 2 inputs variable FSM */
std::map<long, std::map<ref<Expr>, std::set<ref<Expr> > > > localThreeInputSetMap;/* For 3 input variable FSM */
std::map<long, std::map<ref<Expr>, std::set<ref<Expr> > > > localFourInputSetMap;/* For 4 input variable FSM */
std::map<long, std::map<ref<Expr>, std::set<ref<Expr> > > > localMetadataSetMap;

std::set<std::pair<long,long> > globalMetadataSetsToBeChecked;
std::map<long, std::set<std::pair<long,long> > > localMetadataSetsToBeChecked;
std::map<std::pair<long,long>, std::string > globalMetadataMessage;
std::map<long, std::map<std::pair<long,long>, std::string> > localMetadataMessage;
std::map<ref<Expr>, std::pair<ref<Expr>,ref<Expr> > > globalRecordMetadataMap;
std::map<long, std::map<ref<Expr>, std::pair<ref<Expr>,ref<Expr> > > > localRecordMetadataMap;
std::map<ref<Expr>, std::string> globalMetadataConditionMessage;
std::map<long, std::map<ref<Expr>, std::string> > localMetadataConditionMessage;

extern void recordMemObj(ExecutionState &state, const MemoryObject *mo);
extern cl::opt<bool> PruningMode;

cl::opt<bool>
TerminateNoDCTState("terminate-no-dct-state",
                    cl::init(false),
                    cl::desc("terminate state that don't have an incoming DCT, used in Trojan detection"));

cl::opt<unsigned>
NUMSTEPS("numsteps-value",
             cl::desc("Value of numsteps\n"),
             cl::init(0)); 
             
cl::opt<unsigned>
SourceState("src-state-value",
             cl::desc("Value of source state\n"),
             cl::init(99)); 
             
cl::opt<unsigned>
DestState("dest-state-value",
             cl::desc("Value of dest state\n"),
             cl::init(99)); 
             
             
cl::opt<unsigned>
rstState("reset-state",
             cl::desc("Value of reset state\n"),
             cl::init(99)); 
                              
cl::opt<std::string>
DontCareTransFile("dontcare-trans-file",
                 cl::desc("Name of the file that stores statistics and other info about found dontcare transitions\n")); 

std::fstream *dontcareStats = NULL;
extern double dontCareStartTime;

cl::opt<std::string>
OutputTrojanFile("output-trojan-file",
                 cl::desc("Name of the file that stores statistics and other info about found output Trojans\n")); 
std::fstream *outputTrojan = NULL;
extern double outputTrojanTime;

cl::opt<std::string>
RegForwardFile("add-reg-forward",
                 cl::desc("Name of the file that stores forward add_reg_metadata() \n")); 
std::fstream *regForward = NULL;

cl::opt<std::string>
RegBackwardFile("add-reg-backward",
                 cl::desc("Name of the file that stores backward add_and_check_reg_metadata() \n")); 
std::fstream *regBackward = NULL;


cl::opt<std::string>
OutputForwardFile("add-output-forward",
                 cl::desc("Name of the file that stores forward add_output_metadata() \n")); 
std::fstream *outputForward = NULL;

cl::opt<std::string>
OutputBackwardFile("add-output-backward",
                 cl::desc("Name of the file that stores backward add_output_metadata() \n")); 
std::fstream *outputBackward = NULL;

cl::opt<std::string>
FindAllTransFromSrcFile("find-all-trans-from-src",
                 cl::desc("Name of the file that stores klee_find_all_transitions_from_given_src_globally() \n")); 
std::fstream *findAllTransFromSrc = NULL;

namespace {
  cl::opt<bool>
  ReadablePosix("readable-posix-inputs",
            cl::init(false),
            cl::desc("Prefer creation of POSIX inputs (command-line arguments, files, etc.) with human readable bytes. "
                     "Note: option is expensive when creating lots of tests (default=false)"));

  cl::opt<bool>
  SilentKleeAssume("silent-klee-assume",
                   cl::init(false),
                   cl::desc("Silently terminate paths with an infeasible "
                            "condition given to klee_assume() rather than "
                            "emitting an error (default=false)"));
}


/* SYSREL EXTENSION */
 typedef std::pair<ExecutionState*,ExecutionState*> StatePair;
std::set<std::string> assemblyFunctions;
 typedef std::pair<ExecutionState*,ExecutionState*> StatePair;
extern Interpreter *theInterpreter;
extern const Module * moduleHandle;
extern KModule *kmoduleExt;
extern std::string getTypeName(llvm::Type*);
extern bool isLazyInit(Type *t, bool &single, int &count);
extern bool isAllocTypeLazyInit(Type *t, bool &single, int &count) ;
extern int primArraySize;
extern void addSingleOrDerivative(ExecutionState &state, ref<Expr> address);

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

AllocAPIHandler *APIHandler::allocAPIHandler = NULL;
FreeAPIHandler *APIHandler::freeAPIHandler = NULL;
IgnoreAPIHandler *APIHandler::ignoreAPIHandler = NULL;
SideEffectAPIHandler *APIHandler::sideEffectAPIHandler = NULL;
ReturnAPIHandler *APIHandler::returnAPIHandler = NULL;
RefCountAPIHandler *APIHandler::refcountAPIHandler = NULL;
CallbackAPIHandler *APIHandler::callbackAPIHandler = NULL;
TerminateAPIHandler *APIHandler::terminateAPIHandler = NULL;
std::map<std::string, std::set<APIAction*>> APIHandler::apiModel;
std::map<std::string, APIAction*> APIHandler::symbolTable;
/* SYSREL EXTENSION */

/// \todo Almost all of the demands in this file should be replaced
/// with terminateState calls.

///



// FIXME: We are more or less committed to requiring an intrinsic
// library these days. We can move some of this stuff there,
// especially things like realloc which have complicated semantics
// w.r.t. forking. Among other things this makes delayed query
// dispatch easier to implement.
static SpecialFunctionHandler::HandlerInfo handlerInfo[] = {
#define add(name, handler, ret) { name, \
                                  &SpecialFunctionHandler::handler, \
                                  false, ret, false }
#define addDNR(name, handler) { name, \
                                &SpecialFunctionHandler::handler, \
                                true, false, false }
  addDNR("__assert_rtn", handleAssertFail),
  addDNR("__assert_fail", handleAssertFail),
  addDNR("_assert", handleAssert),
  addDNR("abort", handleAbort),
  addDNR("_exit", handleExit),
  { "exit", &SpecialFunctionHandler::handleExit, true, false, true },
  addDNR("klee_abort", handleAbort),
  addDNR("klee_silent_exit", handleSilentExit),
  addDNR("klee_report_error", handleReportError),
  add("calloc", handleCalloc, true),
  add("free", handleFree, false),
  add("klee_assume", handleAssume, false),
  add("klee_check_memory_access", handleCheckMemoryAccess, false),
  add("klee_get_valuef", handleGetValue, true),
  add("klee_get_valued", handleGetValue, true),
  add("klee_get_valuel", handleGetValue, true),
  add("klee_get_valuell", handleGetValue, true),
  add("klee_get_value_i32", handleGetValue, true),
  add("klee_get_value_i64", handleGetValue, true),
  add("klee_define_fixed_object", handleDefineFixedObject, false),
  add("klee_get_obj_size", handleGetObjSize, true),
  add("klee_get_errno", handleGetErrno, true),
#ifndef __APPLE__
  add("__errno_location", handleErrnoLocation, true),
#else
  add("__error", handleErrnoLocation, true),
#endif
  add("klee_is_symbolic", handleIsSymbolic, true),
  add("klee_make_symbolic", handleMakeSymbolic, false),
  add("klee_mark_global", handleMarkGlobal, false),
  add("klee_open_merge", handleOpenMerge, false),
  add("klee_close_merge", handleCloseMerge, false),
  add("klee_prefer_cex", handlePreferCex, false),
  add("klee_posix_prefer_cex", handlePosixPreferCex, false),
  add("klee_print_expr", handlePrintExpr, false),
  add("klee_print_range", handlePrintRange, false),
  add("klee_set_forking", handleSetForking, false),
  add("klee_stack_trace", handleStackTrace, false),
  add("klee_warning", handleWarning, false),
  add("klee_warning_once", handleWarningOnce, false),
  add("klee_alias_function", handleAliasFunction, false),
  add("malloc", handleMalloc, true),
  add("realloc", handleRealloc, true),

  /* SYSREL EXTENSION */
  add("klee_set_metadata", handleSetMetadata, false),
  add("klee_get_metadata", handleGetMetadata, true),
  
  add("klee_check_and_record_path_condition", handleCheckAndRecordPCGlobally, false),
  add("klee_check_and_record_path_condition_with_assume", handleCheckAndRecordPCWithAssumeGlobally, false),
  add("klee_add_assume", handleAddAssumeAsPC, false),  
  add("klee_get_input_pattern", handleAcquireInputPatternGlobally, false),
  add("klee_get_input_pattern_previous_cycle", handleAcquireInputPatternPreviousCycleGlobally, false),
  add("klee_clear_path_constraint", handleClearPCGlobally, false),
  
  add("klee_add_metadata_globally", handleAddMetadataGlobally, false),
  add("klee_add_metadata_globally_TwoInput", handleAddMetadataGloballyTwoInput, false),
  add("klee_add_metadata_globally_ThreeInput", handleAddMetadataGloballyThreeInput, false),
  add("klee_add_metadata_globally_FourInput", handleAddMetadataGloballyFourInput, false),
  add("klee_add_metadata_globally_FiveInput", handleAddMetadataGloballyFiveInput, false),

  add("klee_check_dontcare_transition_globally", handleDontCareTransitionGlobally, false), 
  add("klee_check_dontcare_transition_globally_TwoInput", handleDontCareTransitionGloballyTwoInput, false), 
  add("klee_check_dontcare_transition_globally_ThreeInput", handleDontCareTransitionGloballyThreeInput, false), 
  add("klee_check_dontcare_transition_globally_FourInput", handleDontCareTransitionGloballyFourInput, false), 
  add("klee_check_dontcare_transition_globally_FiveInput", handleDontCareTransitionGloballyFiveInput, false),

  add("klee_find_all_transitions_from_given_src_globally", handleAllTransitionFromGivenSrcGlobally, false),     
  add("klee_find_all_transitions_from_given_unreachable_src_one_step_globally", handleAllTransitionFromGivenUnreachableSrcOneStepGlobally, false),   

  //add("klee_add_symboinput_globally", handleAddSymbInputGlobally, false),//new func with regard to gate level
  add("klee_add_metadata_locally", handleAddMetadataLocally, false),
  add("klee_add_metadata_locally_TwoInput", handleAddMetadataLocallyTwoInput, false),
  add("klee_add_metadata_locally_ThreeInput", handleAddMetadataLocallyThreeInput, false),
  add("klee_add_metadata_locally_FourInput", handleAddMetadataLocallyFourInput, false), 
  
  add("klee_check_dontcare_transition_locally", handleDontCareTransitionLocally, false), 
  add("klee_check_dontcare_transition_locally_TwoInput", handleDontCareTransitionLocallyTwoInput, false), 
  add("klee_check_dontcare_transition_locally_ThreeInput", handleDontCareTransitionLocallyThreeInput, false), 
  add("klee_check_dontcare_transition_locally_FourInput", handleDontCareTransitionLocallyFourInput, false), 


  add("klee_add_transition_metadata_globally", handleAddTransitionMetadataGlobally, false),
  
  add("klee_add_inter_metadata_globally", handleAddInterMetadataGlobally, false), 
  
  add("klee_add_forward_reg_metadata_globally", handleAddForwardRegisterMetadataGlobally, false),
  add("klee_add_and_check_abstract_reg_metadata_globally", handleAddCheckAbstractRegisterMetadataGlobally, false),
  add("klee_add_one_forward_reg_metadata_globally", handleAddOneForwardRegisterMetadataGlobally, false),
  add("klee_add_and_check_abstract_one_reg_metadata_globally", handleAddCheckAbstractOneRegisterMetadataGlobally, false),
  
  add("klee_add_output_metadata_globally", handleAddOutputMetadataGlobally, false),
  add("klee_add_back_output_metadata_globally", handleAddBackOutputMetadataGlobally, false),
  add("klee_detect_trojan_for_output", handleDetectOutputTrojan, false),
  add("klee_check_DCT_finish_time", handleCheckDCTfinishTime, false),
  add("klee_set_source_state", handleSetSourceState, false),
  add("klee_set_dest_state", handleSetDestState, false),
  
  
    
  //add("klee_diff_metadata_globally", handleDiffMetadataGlobally, false), 
  add("klee_add_metadata_globally_on_condition", handleAddMetadataGloballyOnCondition, false),
  add("klee_add_metadata_locally_on_condition", handleAddMetadataLocallyOnCondition, false),
  add("klee_record_metadata_globally_on_condition", handleRecordMetadataGloballyOnCondition, false),
  add("klee_record_metadata_locally_on_condition", handleRecordMetadataLocallyOnCondition, false),
  add("klee_diff_and_check_metadata_globally", handleReportDiffMetadataGlobally, true),
  add("klee_diff_and_check_metadata_locally", handleReportDiffMetadataLocally, true),
  add("klee_check_metadata_membership_globally", handleCheckMetadataMembershipGlobally, true),
  add("klee_check_metadata_membership_locally", handleCheckMetadataMembershipLocally, true),
  add("klee_find_tuple_for_diff_locally", handleFindTupleForDiffLocally, false),
  
  add("klee_record_step_trace_locally", handleRecordStepTraceLocally, false),//versym
  /* SYSREL EXTENSION */

  // operator delete[](void*)
  add("_ZdaPv", handleDeleteArray, false),
  // operator delete(void*)
  add("_ZdlPv", handleDelete, false),

  // operator new[](unsigned int)
  add("_Znaj", handleNewArray, true),
  // operator new(unsigned int)
  add("_Znwj", handleNew, true),

  // FIXME-64: This is wrong for 64-bit long...

  // operator new[](unsigned long)
  add("_Znam", handleNewArray, true),
  // operator new(unsigned long)
  add("_Znwm", handleNew, true),

  // Run clang with -fsanitize=signed-integer-overflow and/or
  // -fsanitize=unsigned-integer-overflow
  add("__ubsan_handle_add_overflow", handleAddOverflow, false),
  add("__ubsan_handle_sub_overflow", handleSubOverflow, false),
  add("__ubsan_handle_mul_overflow", handleMulOverflow, false),
  add("__ubsan_handle_divrem_overflow", handleDivRemOverflow, false),

#undef addDNR
#undef add
};

SpecialFunctionHandler::const_iterator SpecialFunctionHandler::begin() {
  return SpecialFunctionHandler::const_iterator(handlerInfo);
}

SpecialFunctionHandler::const_iterator SpecialFunctionHandler::end() {
  // NULL pointer is sentinel
  return SpecialFunctionHandler::const_iterator(0);
}

SpecialFunctionHandler::const_iterator& SpecialFunctionHandler::const_iterator::operator++() {
  ++index;
  if ( index >= SpecialFunctionHandler::size())
  {
    // Out of range, return .end()
    base=0; // Sentinel
    index=0;
  }

  return *this;
}

int SpecialFunctionHandler::size() {
	return sizeof(handlerInfo)/sizeof(handlerInfo[0]);
}

SpecialFunctionHandler::SpecialFunctionHandler(Executor &_executor) 
  : executor(_executor) {}


void SpecialFunctionHandler::prepare() {
  unsigned N = size();

  for (unsigned i=0; i<N; ++i) {
    HandlerInfo &hi = handlerInfo[i];
    Function *f = executor.kmodule->module->getFunction(hi.name);
    
    // No need to create if the function doesn't exist, since it cannot
    // be called in that case.
  
    if (f && (!hi.doNotOverride || f->isDeclaration())) {
      // Make sure NoReturn attribute is set, for optimization and
      // coverage counting.
      if (hi.doesNotReturn)
        f->addFnAttr(Attribute::NoReturn);

      // Change to a declaration since we handle internally (simplifies
      // module and allows deleting dead code).
      if (!f->isDeclaration())
        f->deleteBody();
    }
  }
}

void SpecialFunctionHandler::bind() {
  unsigned N = sizeof(handlerInfo)/sizeof(handlerInfo[0]);

  for (unsigned i=0; i<N; ++i) {
    HandlerInfo &hi = handlerInfo[i];
    Function *f = executor.kmodule->module->getFunction(hi.name);
    
    if (f && (!hi.doNotOverride || f->isDeclaration()))
      handlers[f] = std::make_pair(hi.handler, hi.hasReturnValue);
  }
}


bool SpecialFunctionHandler::handle(ExecutionState &state, 
                                    Function *f,
                                    KInstruction *target,
                                    std::vector< ref<Expr> > &arguments) {
  handlers_ty::iterator it = handlers.find(f);
  if (it != handlers.end()) {    
    Handler h = it->second.first;
    bool hasReturnValue = it->second.second;
     // FIXME: Check this... add test?
    if (!hasReturnValue && !target->inst->use_empty()) {
      executor.terminateStateOnExecError(state, 
                                         "expected return value from void special function");
    } else {
      (this->*h)(state, target, arguments);
    }
    return true;
  } else {
    return false;
  }
}

/****/

// reads a concrete string from memory
std::string 
SpecialFunctionHandler::readStringAtAddress(ExecutionState &state, 
                                            ref<Expr> addressExpr) {
  ObjectPair op;
  addressExpr = executor.toUnique(state, addressExpr);
  if (!isa<ConstantExpr>(addressExpr)) {
    executor.terminateStateOnError(
        state, "Symbolic string pointer passed to one of the klee_ functions",
        Executor::TerminateReason::User);
    return "";
  }
  ref<ConstantExpr> address = cast<ConstantExpr>(addressExpr);
  if (!state.addressSpace.resolveOne(address, op)) {
    executor.terminateStateOnError(
        state, "Invalid string pointer passed to one of the klee_ functions",
        Executor::TerminateReason::User);
    return "";
  }
  bool res __attribute__ ((unused));
  assert(executor.solver->mustBeTrue(state, 
                                     EqExpr::create(address, 
                                                    op.first->getBaseExpr()),
                                     res) &&
         res &&
         "XXX interior pointer unhandled");
  const MemoryObject *mo = op.first;
  const ObjectState *os = op.second;

  char *buf = new char[mo->size];

  unsigned i;
  for (i = 0; i < mo->size - 1; i++) {
    ref<Expr> cur = os->read8(i);
    cur = executor.toUnique(state, cur);
    assert(isa<ConstantExpr>(cur) && 
           "hit symbolic char while reading concrete string");
    buf[i] = cast<ConstantExpr>(cur)->getZExtValue(8);
  }
  buf[i] = 0;
  
  std::string result(buf);
  delete[] buf;
  return result;
}

/****/

void SpecialFunctionHandler::handleAbort(ExecutionState &state,
                           KInstruction *target,
                           std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==0 && "invalid number of arguments to abort");
  executor.terminateStateOnError(state, "abort failure", Executor::Abort);
}

void SpecialFunctionHandler::handleExit(ExecutionState &state,
                           KInstruction *target,
                           std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==1 && "invalid number of arguments to exit");
  executor.terminateStateOnExit(state);
}

void SpecialFunctionHandler::handleSilentExit(ExecutionState &state,
                                              KInstruction *target,
                                              std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==1 && "invalid number of arguments to exit");
  executor.terminateState(state);
}

void SpecialFunctionHandler::handleAliasFunction(ExecutionState &state,
						 KInstruction *target,
						 std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==2 && 
         "invalid number of arguments to klee_alias_function");
  std::string old_fn = readStringAtAddress(state, arguments[0]);
  std::string new_fn = readStringAtAddress(state, arguments[1]);
  KLEE_DEBUG_WITH_TYPE("alias_handling", llvm::errs() << "Replacing " << old_fn
                                           << "() with " << new_fn << "()\n");
  if (old_fn == new_fn)
    state.removeFnAlias(old_fn);
  else state.addFnAlias(old_fn, new_fn);
}

void SpecialFunctionHandler::handleAssert(ExecutionState &state,
                                          KInstruction *target,
                                          std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==3 && "invalid number of arguments to _assert");  
  executor.terminateStateOnError(state,
				 "ASSERTION FAIL: " + readStringAtAddress(state, arguments[0]),
				 Executor::Assert);
}

void SpecialFunctionHandler::handleAssertFail(ExecutionState &state,
                                              KInstruction *target,
                                              std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==4 && "invalid number of arguments to __assert_fail");
  executor.terminateStateOnError(state,
				 "ASSERTION FAIL: " + readStringAtAddress(state, arguments[0]),
				 Executor::Assert);
}

void SpecialFunctionHandler::handleReportError(ExecutionState &state,
                                               KInstruction *target,
                                               std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==4 && "invalid number of arguments to klee_report_error");
  
  // arguments[0], arguments[1] are file, line
  executor.terminateStateOnError(state,
				 readStringAtAddress(state, arguments[2]),
				 Executor::ReportError,
				 readStringAtAddress(state, arguments[3]).c_str());
}

void SpecialFunctionHandler::handleOpenMerge(ExecutionState &state,
    KInstruction *target,
    std::vector<ref<Expr> > &arguments) {
  if (!UseMerge) {
    klee_warning_once(0, "klee_open_merge ignored, use '-use-merge'");
    return;
  }

  state.openMergeStack.push_back(
      ref<MergeHandler>(new MergeHandler(&executor, &state)));

  if (DebugLogMerge)
    llvm::errs() << "open merge: " << &state << "\n";
}

void SpecialFunctionHandler::handleCloseMerge(ExecutionState &state,
    KInstruction *target,
    std::vector<ref<Expr> > &arguments) {
  if (!UseMerge) {
    klee_warning_once(0, "klee_close_merge ignored, use '-use-merge'");
    return;
  }
  Instruction *i = target->inst;

  if (DebugLogMerge)
    llvm::errs() << "close merge: " << &state << " at " << i << '\n';

  if (state.openMergeStack.empty()) {
    std::ostringstream warning;
    warning << &state << " ran into a close at " << i << " without a preceding open";
    klee_warning("%s", warning.str().c_str());
  } else {
    executor.inCloseMerge.insert(&state);
    state.openMergeStack.back()->addClosedState(&state, i);
    state.openMergeStack.pop_back();
  }
}

void SpecialFunctionHandler::handleNew(ExecutionState &state,
                         KInstruction *target,
                         std::vector<ref<Expr> > &arguments) {
  // XXX should type check args
  assert(arguments.size()==1 && "invalid number of arguments to new");

  executor.executeAlloc(state, arguments[0], false, target);
}

void SpecialFunctionHandler::handleDelete(ExecutionState &state,
                            KInstruction *target,
                            std::vector<ref<Expr> > &arguments) {
  // FIXME: Should check proper pairing with allocation type (malloc/free,
  // new/delete, new[]/delete[]).

  // XXX should type check args
  assert(arguments.size()==1 && "invalid number of arguments to delete");
  executor.executeFree(state, arguments[0]);
}

void SpecialFunctionHandler::handleNewArray(ExecutionState &state,
                              KInstruction *target,
                              std::vector<ref<Expr> > &arguments) {
  // XXX should type check args
  assert(arguments.size()==1 && "invalid number of arguments to new[]");
  executor.executeAlloc(state, arguments[0], false, target);
}

void SpecialFunctionHandler::handleDeleteArray(ExecutionState &state,
                                 KInstruction *target,
                                 std::vector<ref<Expr> > &arguments) {
  // XXX should type check args
  assert(arguments.size()==1 && "invalid number of arguments to delete[]");
  executor.executeFree(state, arguments[0]);
}

void SpecialFunctionHandler::handleMalloc(ExecutionState &state,
                                  KInstruction *target,
                                  std::vector<ref<Expr> > &arguments) {
  // XXX should type check args
  /* SYSREL EXTENSION */
  // we need this to handle kmalloc and kzalloc via malloc
  assert(arguments.size()>=1 && "invalid number of arguments to malloc");
  //assert(arguments.size()==1 && "invalid number of arguments to malloc");
  llvm::outs() << "argument to malloc: " << arguments[0] << "\n";
  /* SYSREL EXTENSION */
  executor.executeAlloc(state, arguments[0], false, target, false, true);
}

void SpecialFunctionHandler::handleAssume(ExecutionState &state,
                            KInstruction *target,
                            std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==1 && "invalid number of arguments to klee_assume");
  
  ref<Expr> e = arguments[0];
  
  if (e->getWidth() != Expr::Bool)
    e = NeExpr::create(e, ConstantExpr::create(0, e->getWidth()));
  
  bool res;
  bool success __attribute__ ((unused)) = executor.solver->mustBeFalse(state, e, res);
  assert(success && "FIXME: Unhandled solver failure");
  if (res) {
    if (SilentKleeAssume) {
      executor.terminateState(state);
    } else {
      executor.terminateStateOnError(state,
                                     "invalid klee_assume call (provably false)",
                                     Executor::User);
    }
  } else {
    executor.addConstraint(state, e);
  }
}

void SpecialFunctionHandler::handleIsSymbolic(ExecutionState &state,
                                KInstruction *target,
                                std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==1 && "invalid number of arguments to klee_is_symbolic");

  executor.bindLocal(target, state, 
                     ConstantExpr::create(!isa<ConstantExpr>(arguments[0]),
                                          Expr::Int32));
}

void SpecialFunctionHandler::handlePreferCex(ExecutionState &state,
                                             KInstruction *target,
                                             std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==2 &&
         "invalid number of arguments to klee_prefex_cex");

  ref<Expr> cond = arguments[1];
  if (cond->getWidth() != Expr::Bool)
    cond = NeExpr::create(cond, ConstantExpr::alloc(0, cond->getWidth()));

  Executor::ExactResolutionList rl;
  executor.resolveExact(state, arguments[0], rl, "prefex_cex");
  
  assert(rl.size() == 1 &&
         "prefer_cex target must resolve to precisely one object");

  rl[0].first.first->cexPreferences.push_back(cond);
}

void SpecialFunctionHandler::handlePosixPreferCex(ExecutionState &state,
                                             KInstruction *target,
                                             std::vector<ref<Expr> > &arguments) {
  if (ReadablePosix)
    return handlePreferCex(state, target, arguments);
}

void SpecialFunctionHandler::handlePrintExpr(ExecutionState &state,
                                  KInstruction *target,
                                  std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==2 &&
         "invalid number of arguments to klee_print_expr");

  std::string msg_str = readStringAtAddress(state, arguments[0]);
  llvm::errs() << msg_str << ":" << arguments[1] << "\n";
}

void SpecialFunctionHandler::handleSetForking(ExecutionState &state,
                                              KInstruction *target,
                                              std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==1 &&
         "invalid number of arguments to klee_set_forking");
  ref<Expr> value = executor.toUnique(state, arguments[0]);
  
  if (ConstantExpr *CE = dyn_cast<ConstantExpr>(value)) {
    state.forkDisabled = CE->isZero();
  } else {
    executor.terminateStateOnError(state, 
                                   "klee_set_forking requires a constant arg",
                                   Executor::User);
  }
}

void SpecialFunctionHandler::handleStackTrace(ExecutionState &state,
                                              KInstruction *target,
                                              std::vector<ref<Expr> > &arguments) {
  state.dumpStack(outs());
}

void SpecialFunctionHandler::handleWarning(ExecutionState &state,
                                           KInstruction *target,
                                           std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==1 && "invalid number of arguments to klee_warning");

  std::string msg_str = readStringAtAddress(state, arguments[0]);
  klee_warning("%s: %s", state.stack.back().kf->function->getName().data(), 
               msg_str.c_str());
}

void SpecialFunctionHandler::handleWarningOnce(ExecutionState &state,
                                               KInstruction *target,
                                               std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==1 &&
         "invalid number of arguments to klee_warning_once");

  std::string msg_str = readStringAtAddress(state, arguments[0]);
  klee_warning_once(0, "%s: %s", state.stack.back().kf->function->getName().data(),
                    msg_str.c_str());
}

void SpecialFunctionHandler::handlePrintRange(ExecutionState &state,
                                  KInstruction *target,
                                  std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==2 &&
         "invalid number of arguments to klee_print_range");

  std::string msg_str = readStringAtAddress(state, arguments[0]);
  llvm::errs() << msg_str << ":" << arguments[1];
  if (!isa<ConstantExpr>(arguments[1])) {
    // FIXME: Pull into a unique value method?
    ref<ConstantExpr> value;
    bool success __attribute__ ((unused)) = executor.solver->getValue(state, arguments[1], value);
    assert(success && "FIXME: Unhandled solver failure");
    bool res;
    success = executor.solver->mustBeTrue(state, 
                                          EqExpr::create(arguments[1], value), 
                                          res);
    assert(success && "FIXME: Unhandled solver failure");
    if (res) {
      llvm::errs() << " == " << value;
    } else { 
      llvm::errs() << " ~= " << value;
      std::pair< ref<Expr>, ref<Expr> > res =
        executor.solver->getRange(state, arguments[1]);
      llvm::errs() << " (in [" << res.first << ", " << res.second <<"])";
    }
  }
  llvm::errs() << "\n";
}

void SpecialFunctionHandler::handleGetObjSize(ExecutionState &state,
                                  KInstruction *target,
                                  std::vector<ref<Expr> > &arguments) {
  // XXX should type check args
  assert(arguments.size()==1 &&
         "invalid number of arguments to klee_get_obj_size");
  Executor::ExactResolutionList rl;
  executor.resolveExact(state, arguments[0], rl, "klee_get_obj_size");
  for (Executor::ExactResolutionList::iterator it = rl.begin(), 
         ie = rl.end(); it != ie; ++it) {
    executor.bindLocal(
        target, *it->second,
        ConstantExpr::create(it->first.first->size,
                             executor.kmodule->targetData->getTypeSizeInBits(
                                 target->inst->getType())));
  }
}

void SpecialFunctionHandler::handleGetErrno(ExecutionState &state,
                                            KInstruction *target,
                                            std::vector<ref<Expr> > &arguments) {
  // XXX should type check args
  assert(arguments.size()==0 &&
         "invalid number of arguments to klee_get_errno");
#ifndef WINDOWS
  int *errno_addr = executor.getErrnoLocation(state);
#else
  int *errno_addr = nullptr;
#endif

  // Retrieve the memory object of the errno variable
  ObjectPair result;
  bool resolved = state.addressSpace.resolveOne(
      ConstantExpr::create((uint64_t)errno_addr, Expr::Int64), result);
  if (!resolved)
    executor.terminateStateOnError(state, "Could not resolve address for errno",
                                   Executor::User);
  executor.bindLocal(target, state, result.second->read(0, Expr::Int32));
}

void SpecialFunctionHandler::handleErrnoLocation(
    ExecutionState &state, KInstruction *target,
    std::vector<ref<Expr> > &arguments) {
  // Returns the address of the errno variable
  assert(arguments.size() == 0 &&
         "invalid number of arguments to __errno_location/__error");

#ifndef WINDOWS
  int *errno_addr = executor.getErrnoLocation(state);
#else
  int *errno_addr = nullptr;
#endif

  executor.bindLocal(
      target, state,
      ConstantExpr::create((uint64_t)errno_addr,
                           executor.kmodule->targetData->getTypeSizeInBits(
                               target->inst->getType())));
}
void SpecialFunctionHandler::handleCalloc(ExecutionState &state,
                            KInstruction *target,
                            std::vector<ref<Expr> > &arguments) {
  // XXX should type check args
  assert(arguments.size()==2 &&
         "invalid number of arguments to calloc");

  ref<Expr> size = MulExpr::create(arguments[0],
                                   arguments[1]);
  executor.executeAlloc(state, size, false, target, true, true);
}

void SpecialFunctionHandler::handleRealloc(ExecutionState &state,
                            KInstruction *target,
                            std::vector<ref<Expr> > &arguments) {
  // XXX should type check args
  assert(arguments.size()==2 &&
         "invalid number of arguments to realloc");
  ref<Expr> address = arguments[0];
  ref<Expr> size = arguments[1];

  Executor::StatePair zeroSize = executor.fork(state, 
                                               Expr::createIsZero(size), 
                                               true);
  
  if (zeroSize.first) { // size == 0
    executor.executeFree(*zeroSize.first, address, target);   
  }
  if (zeroSize.second) { // size != 0
    Executor::StatePair zeroPointer = executor.fork(*zeroSize.second, 
                                                    Expr::createIsZero(address), 
                                                    true);
    
    if (zeroPointer.first) { // address == 0
      executor.executeAlloc(*zeroPointer.first, size, false, target, false, true);
    } 
    if (zeroPointer.second) { // address != 0
      Executor::ExactResolutionList rl;
      executor.resolveExact(*zeroPointer.second, address, rl, "realloc");
      
      for (Executor::ExactResolutionList::iterator it = rl.begin(), 
             ie = rl.end(); it != ie; ++it) {
        executor.executeAlloc(*it->second, size, false, target, false, true,
                              it->first.second);
      }
    }
  }
}

void SpecialFunctionHandler::handleFree(ExecutionState &state,
                          KInstruction *target,
                          std::vector<ref<Expr> > &arguments) {
  // XXX should type check args
  assert(arguments.size()==1 &&
         "invalid number of arguments to free");
  executor.executeFree(state, arguments[0]);
}

void SpecialFunctionHandler::handleCheckMemoryAccess(ExecutionState &state,
                                                     KInstruction *target,
                                                     std::vector<ref<Expr> > 
                                                       &arguments) {
  assert(arguments.size()==2 &&
         "invalid number of arguments to klee_check_memory_access");

  ref<Expr> address = executor.toUnique(state, arguments[0]);
  ref<Expr> size = executor.toUnique(state, arguments[1]);
  if (!isa<ConstantExpr>(address) || !isa<ConstantExpr>(size)) {
    executor.terminateStateOnError(state, 
                                   "check_memory_access requires constant args",
				   Executor::User);
  } else {
    ObjectPair op;

    if (!state.addressSpace.resolveOne(cast<ConstantExpr>(address), op)) {
      executor.terminateStateOnError(state,
                                     "check_memory_access: memory error",
				     Executor::Ptr, NULL,
                                     executor.getAddressInfo(state, address));
    } else {
      ref<Expr> chk = 
        op.first->getBoundsCheckPointer(address, 
                                        cast<ConstantExpr>(size)->getZExtValue());
      if (!chk->isTrue()) {
        executor.terminateStateOnError(state,
                                       "check_memory_access: memory error",
				       Executor::Ptr, NULL,
                                       executor.getAddressInfo(state, address));
      }
    }
  }
}

void SpecialFunctionHandler::handleGetValue(ExecutionState &state,
                                            KInstruction *target,
                                            std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==1 &&
         "invalid number of arguments to klee_get_value");

  executor.executeGetValue(state, arguments[0], target);
}

void SpecialFunctionHandler::handleDefineFixedObject(ExecutionState &state,
                                                     KInstruction *target,
                                                     std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==2 &&
         "invalid number of arguments to klee_define_fixed_object");
  assert(isa<ConstantExpr>(arguments[0]) &&
         "expect constant address argument to klee_define_fixed_object");
  assert(isa<ConstantExpr>(arguments[1]) &&
         "expect constant size argument to klee_define_fixed_object");
  
  uint64_t address = cast<ConstantExpr>(arguments[0])->getZExtValue();
  uint64_t size = cast<ConstantExpr>(arguments[1])->getZExtValue();
  MemoryObject *mo = executor.memory->allocateFixed(address, size, state.prevPC->inst);
  executor.bindObjectInState(state, mo, false);
  mo->isUserSpecified = true; // XXX hack;
}

/* SYSREL extension */
void SpecialFunctionHandler::handleSetMetadata(ExecutionState &state,
                                                KInstruction *target,
                                                std::vector<ref<Expr> > &arguments) {
     state.setMetadata(arguments[0], arguments[1]);
}

void SpecialFunctionHandler::handleGetMetadata(ExecutionState &state,
                                                KInstruction *target,
                                                std::vector<ref<Expr> > &arguments) {
     ref<Expr> cv = state.getMetadata(arguments[0]);
     executor.bindLocal(target, state, cv);
}


/* arguments[0]: condition
   arguments[1]: key for true cases
   arguments[2]: key for false cases
   Records the conditions and the sets to be checked at the end of the execution
*/
void SpecialFunctionHandler::handleRecordMetadataGloballyOnCondition(ExecutionState &state,
                                                KInstruction *target,
                                                std::vector<ref<Expr> > &arguments) {

  llvm::errs() << "HANDLE RECORD METADATA args " << arguments.size() << "\n";

  ref<Expr> e = arguments[0];
  
  if (e->getWidth() != Expr::Bool)
    e = NeExpr::create(e, ConstantExpr::create(0, e->getWidth()));

  std::pair<ref<Expr>, ref<Expr> > sets;
  sets.first = arguments[1];
  sets.second = arguments[2];

  globalRecordMetadataMap[e] = sets;
  globalMetadataConditionMessage[e] = readStringAtAddress(state, arguments[3]);
}

void SpecialFunctionHandler::handleRecordMetadataLocallyOnCondition(ExecutionState &state,
                                                KInstruction *target,
                                                std::vector<ref<Expr> > &arguments) {

  llvm::errs() << "HANDLE RECORD METADATA args " << arguments.size() << "\n";

  ref<Expr> e = arguments[0];
  
  if (e->getWidth() != Expr::Bool)
    e = NeExpr::create(e, ConstantExpr::create(0, e->getWidth()));

  std::pair<ref<Expr>, ref<Expr> > sets;
  sets.first = arguments[1];
  sets.second = arguments[2];

  std::map<ref<Expr>, std::pair<ref<Expr>, ref<Expr> > > m;
  if (localRecordMetadataMap.find((long)&state) != localRecordMetadataMap.end())
     m = localRecordMetadataMap[(long)&state]; 
  m[e] = sets;
  localRecordMetadataMap[(long)&state] = m;
  std::map<ref<Expr>, std::string> m2;
  if (localMetadataConditionMessage.find((long)&state) != localMetadataConditionMessage.end())
     m2 = localMetadataConditionMessage[(long)&state];
  m2[e] = readStringAtAddress(state, arguments[3]);
  localMetadataConditionMessage[(long)&state] = m2;
}


/* arguments[0]: condition
   arguments[1]: key for true cases
   arguments[2]: key for false cases
   Checks the conditions upon execution in the system under test
*/
void SpecialFunctionHandler::handleAddMetadataGloballyOnCondition
            (ExecutionState &state,
             KInstruction *target,
             std::vector<ref<Expr> > &arguments) {

  llvm::errs() << "HANDLE ADD METADATA args " << arguments.size() << "\n";

  ref<Expr> e = arguments[0];
  
  if (e->getWidth() != Expr::Bool)
    e = NeExpr::create(e, ConstantExpr::create(0, e->getWidth()));
  

  bool resF, resT;
  bool successF __attribute__ ((unused)) = executor.solver->mustBeFalse(
                                                  state, e, resF);
  bool successT __attribute__ ((unused)) = executor.solver->mustBeTrue(
                                                  state, e, resT);

  llvm::errs() << "checking metadata condition " << e << " " << resT << " " << resF << "\n";
  llvm::errs() << "keys: " << arguments[1] << " " << arguments[2] << "\n";
  ExprPPrinter::printConstraints(llvm::errs(), state.constraints);

  assert(successF && successT && "FIXME: Unhandled solver failure");
  if (resT) {
     std::set<ref<Expr> > ms;
     if (globalMetadataSetMap.find(arguments[1]) != globalMetadataSetMap.end()) 
       ms = globalMetadataSetMap[arguments[1]]; 
     ms.insert(ConstantExpr::create((long)&state,64));
     globalMetadataSetMap[arguments[1]] = ms;
    llvm::errs() << "Adding metadata " << ((long)&state) << " to the set of " << arguments[1] << "\n";
  }
  else if (resF) {
     std::set<ref<Expr> > ms;
     if (globalMetadataSetMap.find(arguments[2]) != globalMetadataSetMap.end()) 
       ms = globalMetadataSetMap[arguments[2]]; 
     ms.insert(ConstantExpr::create((long)&state,64));
     globalMetadataSetMap[arguments[2]] = ms;
    llvm::errs() << "Adding metadata " << ((long)&state) << " to the set of " << arguments[2] << "\n";
  } else { // both are feasible so add the state pointer to both sets
     std::set<ref<Expr> > ms1;
     if (globalMetadataSetMap.find(arguments[1]) != globalMetadataSetMap.end()) 
       ms1 = globalMetadataSetMap[arguments[1]]; 
     ms1.insert(ConstantExpr::create((long)&state,64));
     globalMetadataSetMap[arguments[1]] = ms1;
    llvm::errs() << "Adding metadata " << ((long)&state) << " to the set of " << arguments[1] << "\n";
 
    std::set<ref<Expr> > ms;
    if (globalMetadataSetMap.find(arguments[2]) != globalMetadataSetMap.end()) 
       ms = globalMetadataSetMap[arguments[2]]; 
    ms.insert(ConstantExpr::create((long)&state,64));
    globalMetadataSetMap[arguments[2]] = ms;
    llvm::errs() << "Adding metadata " << ((long)&state) << " to the set of " << arguments[2] << "\n";
        
  }

  std::pair<long,long> dp;
  if (globalMetadataSetMap.find(arguments[1]) != globalMetadataSetMap.end()) 
       dp.first = (long)&globalMetadataSetMap[arguments[1]];
  if (globalMetadataSetMap.find(arguments[2]) != globalMetadataSetMap.end()) 
       dp.second = (long)&globalMetadataSetMap[arguments[2]];
  llvm::errs() << "metadata set addresses: " << dp.first << " " << dp.second << "\n";
  globalMetadataSetsToBeChecked.insert(dp);

  globalMetadataMessage[dp] = readStringAtAddress(state, arguments[3]);
}

/* arguments[0]: condition
   arguments[1]: key for true cases
   arguments[2]: key for false cases
   Checks the conditions upon execution in the system under test
*/
void SpecialFunctionHandler::handleAddMetadataLocallyOnCondition(ExecutionState &state,
                                                KInstruction *target,
                                                std::vector<ref<Expr> > &arguments) {

  llvm::errs() << "HANDLE ADD METADATA args " << arguments.size() << "\n";

  ref<Expr> e = arguments[0];
  
  if (e->getWidth() != Expr::Bool)
    e = NeExpr::create(e, ConstantExpr::create(0, e->getWidth()));
  

  bool resF, resT;
  bool successF __attribute__ ((unused)) = executor.solver->mustBeFalse(state, e, resF);
  bool successT __attribute__ ((unused)) = executor.solver->mustBeTrue(state, e, resT);

  llvm::errs() << "checking metadata condition " << e << " " << resT << " " << resF << "\n";
  llvm::errs() << "keys: " << arguments[1] << " " << arguments[2] << "\n";
  ExprPPrinter::printConstraints(llvm::errs(), state.constraints);

  assert(successF && successT && "FIXME: Unhandled solver failure");
  std::map<ref<Expr>, std::set<ref<Expr> > > gm;
  if (localMetadataSetMap.find((long)&state) != localMetadataSetMap.end())
     gm = localMetadataSetMap[(long)&state];

  if (resT) {
     std::set<ref<Expr> > ms;
     if (gm.find(arguments[1]) != gm.end()) 
       ms = gm[arguments[1]]; 
     ms.insert(ConstantExpr::create((long)&state,64));
     gm[arguments[1]] = ms;
     localMetadataSetMap[(long)&state] = gm;
    llvm::errs() << "Adding metadata " << ((long)&state) << " to the set of " << arguments[1] << "\n";
  }
  else if (resF) {
     std::set<ref<Expr> > ms;
     if (gm.find(arguments[2]) != gm.end()) 
       ms = gm[arguments[2]]; 
     ms.insert(ConstantExpr::create((long)&state,64));
     gm[arguments[2]] = ms;
     localMetadataSetMap[(long)&state] = gm;
    llvm::errs() << "Adding metadata " << ((long)&state) << " to the set of " << arguments[2] << "\n";
  } else { // both are feasible so add the state pointer to both sets
     std::set<ref<Expr> > ms1;
     if (gm.find(arguments[1]) != gm.end()) 
       ms1 = gm[arguments[1]]; 
     ms1.insert(ConstantExpr::create((long)&state,64));
     gm[arguments[1]] = ms1;
    llvm::errs() << "Adding metadata " << ((long)&state) << " to the set of " << arguments[1] << "\n";
 
    std::set<ref<Expr> > ms;
    if (gm.find(arguments[2]) != gm.end()) 
       ms = gm[arguments[2]]; 
    ms.insert(ConstantExpr::create((long)&state,64));
    gm[arguments[2]] = ms;
    llvm::errs() << "Adding metadata " << ((long)&state) << " to the set of " << arguments[2] << "\n";

    localMetadataSetMap[(long)&state] = gm;
        
  }

  std::pair<long,long> dp;
  if (gm.find(arguments[1]) != gm.end()) 
       dp.first = (long)&gm[arguments[1]];
  if (gm.find(arguments[2]) != gm.end()) 
       dp.second = (long)&gm[arguments[2]];
  llvm::errs() << "metadata set addresses: " << dp.first << " " << dp.second << "\n";
  std::set<std::pair<long,long> > ls;
  if (localMetadataSetsToBeChecked.find((long)&state) != localMetadataSetsToBeChecked.end())
     ls = localMetadataSetsToBeChecked[(long)&state];
  ls.insert(dp);
  localMetadataSetsToBeChecked[(long)&state] = ls;
  std::map<std::pair<long,long>, std::string>  lm2;
  if (localMetadataMessage.find((long)&state) != localMetadataMessage.end())
     lm2 = localMetadataMessage[(long)&state];
  lm2[dp] = readStringAtAddress(state, arguments[3]);
  localMetadataMessage[(long)&state] = lm2;
}

////////////////////////////////For 1 input variable FSM(add local metadata)////////////////////////////
void SpecialFunctionHandler::handleAddMetadataLocally(ExecutionState &state,
                                                KInstruction *target,
                                    std::vector<ref<Expr> > &arguments) {

    std::map<ref<Expr>, std::set<ref<Expr> > > gm;
    std::map<ref<Expr>, std::set<ref<Expr> > > gmInput;
    if (localMetadataSetMap.find((long)&state) != localMetadataSetMap.end())
        gm = localMetadataSetMap[(long)&state];
    std::set<ref<Expr> > ms;
    if (gm.find(arguments[0]) != gm.end()) 
       ms = gm[arguments[0]]; 
    ms.insert(arguments[1]);
    gm[arguments[0]] = ms;
    localMetadataSetMap[(long)&state] = gm;
    llvm::errs() << "Adding metadata " << arguments[1] << " to the set of " << arguments[0] << "\n";

    if (localInputSetMap.find((long)&state) != localInputSetMap.end())
        gmInput = localInputSetMap[(long)&state];
    std::set<ref<Expr> > msInput;
    if (gmInput.find(arguments[0]) != gmInput.end()) 
       msInput = gmInput[arguments[0]]; 
    msInput.insert(arguments[2]);
    gmInput[arguments[0]] = msInput;
    localInputSetMap[(long)&state] = gmInput;
}


////////////////////////////////For 2 input variable FSM(add local metadata)////////////////////////////
void SpecialFunctionHandler::handleAddMetadataLocallyTwoInput(ExecutionState &state,
                                                KInstruction *target,
                                    std::vector<ref<Expr> > &arguments) {

    std::map<ref<Expr>, std::set<ref<Expr> > > gm;
    std::map<ref<Expr>, std::set<ref<Expr> > > gmInput;
	std::map<ref<Expr>, std::set<ref<Expr> > > gmInputTwo;
    if (localMetadataSetMap.find((long)&state) != localMetadataSetMap.end())
        gm = localMetadataSetMap[(long)&state];
    std::set<ref<Expr> > ms;
    if (gm.find(arguments[0]) != gm.end()) 
       ms = gm[arguments[0]]; 
    ms.insert(arguments[1]);
    gm[arguments[0]] = ms;
    localMetadataSetMap[(long)&state] = gm;
    llvm::errs() << "Adding metadata " << arguments[1] << " to the set of " << arguments[0] << "\n";

    if (localInputSetMap.find((long)&state) != localInputSetMap.end())
        gmInput = localInputSetMap[(long)&state];
    std::set<ref<Expr> > msInput;
    if (gmInput.find(arguments[0]) != gmInput.end()) 
       msInput = gmInput[arguments[0]]; 
    msInput.insert(arguments[2]);
    gmInput[arguments[0]] = msInput;
    localInputSetMap[(long)&state] = gmInput;
	
	if (localTwoInputSetMap.find((long)&state) != localTwoInputSetMap.end())
        gmInputTwo = localTwoInputSetMap[(long)&state];
    std::set<ref<Expr> > msInputTwo;
    if (gmInputTwo.find(arguments[0]) != gmInputTwo.end()) 
       msInputTwo = gmInputTwo[arguments[0]]; 
    msInputTwo.insert(arguments[3]);
    gmInputTwo[arguments[0]] = msInputTwo;
    localTwoInputSetMap[(long)&state] = gmInputTwo;
}


////////////////////////////////For 3 input variable FSM(add local metadata)////////////////////////////
void SpecialFunctionHandler::handleAddMetadataLocallyThreeInput(ExecutionState &state,
                                                KInstruction *target,
                                    std::vector<ref<Expr> > &arguments) {

    std::map<ref<Expr>, std::set<ref<Expr> > > gm;
    std::map<ref<Expr>, std::set<ref<Expr> > > gmInput;
	std::map<ref<Expr>, std::set<ref<Expr> > > gmInputTwo;
	std::map<ref<Expr>, std::set<ref<Expr> > > gmInputThree;
    if (localMetadataSetMap.find((long)&state) != localMetadataSetMap.end())
        gm = localMetadataSetMap[(long)&state];
    std::set<ref<Expr> > ms;
    if (gm.find(arguments[0]) != gm.end()) 
       ms = gm[arguments[0]]; 
    ms.insert(arguments[1]);
    gm[arguments[0]] = ms;
    localMetadataSetMap[(long)&state] = gm;
    llvm::errs() << "Adding metadata " << arguments[1] << " to the set of " << arguments[0] << "\n";

    if (localInputSetMap.find((long)&state) != localInputSetMap.end())
        gmInput = localInputSetMap[(long)&state];
    std::set<ref<Expr> > msInput;
    if (gmInput.find(arguments[0]) != gmInput.end()) 
       msInput = gmInput[arguments[0]]; 
    msInput.insert(arguments[2]);
    gmInput[arguments[0]] = msInput;
    localInputSetMap[(long)&state] = gmInput;
	
	if (localTwoInputSetMap.find((long)&state) != localTwoInputSetMap.end())
        gmInputTwo = localTwoInputSetMap[(long)&state];
    std::set<ref<Expr> > msInputTwo;
    if (gmInputTwo.find(arguments[0]) != gmInputTwo.end()) 
       msInputTwo = gmInputTwo[arguments[0]]; 
    msInputTwo.insert(arguments[3]);
    gmInputTwo[arguments[0]] = msInputTwo;
    localTwoInputSetMap[(long)&state] = gmInputTwo;
	
	if (localThreeInputSetMap.find((long)&state) != localThreeInputSetMap.end())
        gmInputThree = localThreeInputSetMap[(long)&state];
    std::set<ref<Expr> > msInputThree;
    if (gmInputThree.find(arguments[0]) != gmInputThree.end()) 
       msInputThree = gmInputThree[arguments[0]]; 
    msInputThree.insert(arguments[4]);
    gmInputThree[arguments[0]] = msInputThree;
    localThreeInputSetMap[(long)&state] = gmInputThree;
}


////////////////////////////////For 4 input variable FSM(add local metadata)////////////////////////////
void SpecialFunctionHandler::handleAddMetadataLocallyFourInput(ExecutionState &state,
                                                KInstruction *target,
                                    std::vector<ref<Expr> > &arguments) {

    std::map<ref<Expr>, std::set<ref<Expr> > > gm;
    std::map<ref<Expr>, std::set<ref<Expr> > > gmInput;
	std::map<ref<Expr>, std::set<ref<Expr> > > gmInputTwo;
	std::map<ref<Expr>, std::set<ref<Expr> > > gmInputThree;
	std::map<ref<Expr>, std::set<ref<Expr> > > gmInputFour;
    if (localMetadataSetMap.find((long)&state) != localMetadataSetMap.end())
        gm = localMetadataSetMap[(long)&state];
    std::set<ref<Expr> > ms;
    if (gm.find(arguments[0]) != gm.end()) 
       ms = gm[arguments[0]]; 
    ms.insert(arguments[1]	);
    gm[arguments[0]] = ms;
    localMetadataSetMap[(long)&state] = gm;
    llvm::errs() << "Adding metadata " << arguments[1] << " to the set of " << arguments[0] << "\n";

    if (localInputSetMap.find((long)&state) != localInputSetMap.end())
        gmInput = localInputSetMap[(long)&state];
    std::set<ref<Expr> > msInput;
    if (gmInput.find(arguments[0]) != gmInput.end()) 
       msInput = gmInput[arguments[0]]; 
    msInput.insert(arguments[2]);
    gmInput[arguments[0]] = msInput;
    localInputSetMap[(long)&state] = gmInput;
	
	if (localTwoInputSetMap.find((long)&state) != localTwoInputSetMap.end())
        gmInputTwo = localTwoInputSetMap[(long)&state];
    std::set<ref<Expr> > msInputTwo;
    if (gmInputTwo.find(arguments[0]) != gmInputTwo.end()) 
       msInputTwo = gmInputTwo[arguments[0]]; 
    msInputTwo.insert(arguments[3]);
    gmInputTwo[arguments[0]] = msInputTwo;
    localTwoInputSetMap[(long)&state] = gmInputTwo;
	
	if (localThreeInputSetMap.find((long)&state) != localThreeInputSetMap.end())
        gmInputThree = localThreeInputSetMap[(long)&state];
    std::set<ref<Expr> > msInputThree;
    if (gmInputThree.find(arguments[0]) != gmInputThree.end()) 
       msInputThree = gmInputThree[arguments[0]]; 
    msInputThree.insert(arguments[4]);
    gmInputThree[arguments[0]] = msInputThree;
    localThreeInputSetMap[(long)&state] = gmInputThree;
	
	if (localFourInputSetMap.find((long)&state) != localFourInputSetMap.end())
        gmInputFour = localFourInputSetMap[(long)&state];
    std::set<ref<Expr> > msInputFour;
    if (gmInputFour.find(arguments[0]) != gmInputFour.end()) 
       msInputFour = gmInputFour[arguments[0]]; 
    msInputFour.insert(arguments[5]);
    gmInputFour[arguments[0]] = msInputFour;
    localFourInputSetMap[(long)&state] = gmInputFour;
}



////////////////////////////////For 1 input variable FSM(From local metadata)//////////////////////////////////////////
void SpecialFunctionHandler::handleDontCareTransitionLocally(
                                    ExecutionState &state,
                                    KInstruction *target,
                                    std::vector<ref<Expr> > &arguments) {

    StatsTracker * statsTracker = ((Executor*)theInterpreter)->getStatsTracker();
    if (dontcareStats == NULL) {
       std::string fname = "dontcarestats.txt";
       if (DontCareTransFile != "")
          fname = DontCareTransFile; 
       dontcareStats = new std::fstream(fname, std::fstream::out);
    }

    std::fstream & out = *dontcareStats;

    /////////start: hander reachable set from forward execution//////////////////
    std::map<ref<Expr>, std::set<ref<Expr> > > gm1;
    if (localMetadataSetMap.find((long)&state) != localMetadataSetMap.end())
        gm1 = localMetadataSetMap[(long)&state];
    std::set<ref<Expr> > rs, rsConcrete; 
    if (gm1.find(arguments[0]) != gm1.end()) 
        rs = gm1[arguments[0]]; 

    ref<Expr> reachable = NULL;

	////Begin: Convert symbolic rs to concrete rs////
    /*for(auto v: rs){
       ExecutionState *fakeRS = new ExecutionState(state);
       std::pair<ref<Expr>, ref<Expr>> rsSymbolic = executor.solver->getRange(*fakeRS, v);
       ref<Expr> rsSymbolicFirst = rsSymbolic.first;
       auto rsSymbolicFirstConstant = dyn_cast<ConstantExpr>(rsSymbolicFirst);
       uint64_t rsSymbolicFirstUint = rsSymbolicFirstConstant->getZExtValue();
       ref<Expr> rsSymbolicSecond = rsSymbolic.second;
       auto rsSymbolicSecondConstant = dyn_cast<ConstantExpr>(rsSymbolicSecond);
       uint64_t rsSymbolicSecondUint = rsSymbolicSecondConstant->getZExtValue();
       for(auto v1 = rsSymbolicFirstUint; v1 <= rsSymbolicSecondUint; v1++){
		auto v2 = v1;
		rsConcrete.insert(ConstantExpr::create(v2, arguments[2]->getWidth()));
       }
	
    }*/
	////End: Convert symbolic rs to concrete rs////

    for(auto v : rs) {
              std::string Str2;
  	      llvm::raw_string_ostream info2(Str2);
              ExprPPrinter::printSingleExpr(info2, v);
              out << "reachable set from rs: " << info2.str() << "\n";
       llvm::errs() << " reachable value " << v << "\n";
       ref<Expr> eqexp = EqExpr::create(arguments[2], v);
       if (reachable.isNull())
          reachable = eqexp;
       else {
          ref<Expr> temp = reachable;
          reachable = OrExpr::create(temp, eqexp);
       }
    }  

    if (!reachable.isNull()){
       llvm::errs() << "reachable set: " << reachable << "\n"; 
    }
     else
	return;

    ref<Expr> notreachable = NotExpr::create(reachable); 
    llvm::errs() << "Value of notreachable: " << notreachable << "\n"; 
    /////////end: hander reachable set from forward execution////////////////// 

    /////////start: hander first input variable//////////////////
    std::map<ref<Expr>, std::set<ref<Expr> > > gmInput1;
    if (localInputSetMap.find((long)&state) != localInputSetMap.end())
        gmInput1 = localInputSetMap[(long)&state];
    std::set<ref<Expr> > rsInput;
    if (gmInput1.find(arguments[0]) != gmInput1.end()) 
        rsInput = gmInput1[arguments[0]]; 

    ref<Expr> reachableInput = NULL;//this var represents OR( EQ(inSec, inFirst_i) )

    for(auto v1 : rsInput) {
       llvm::errs() << " reachable first input name " << v1 << "\n";
       ref<Expr> eqexpInput = EqExpr::create(arguments[4], v1);

       if (reachableInput.isNull())
          reachableInput = eqexpInput;
       else
          reachableInput = OrExpr::create(reachableInput, eqexpInput);
    }
    llvm::errs() << "Width of reachableInput: " << reachableInput->getWidth() << "\n";
    llvm::errs() << "Value of reachableInput: " << reachableInput << "\n";
    /////////end: hander first input variable//////////////////
  bool terminateSuccessDest = false;
    for(auto v1 : rs){
	bool sourceMatches;
	bool destMatches;
        ConstantExpr *consv1 = dyn_cast<ConstantExpr>(v1);

	ref<Expr> v1eqexp1 = EqExpr::create(arguments[3], v1);
	ref<Expr> v1eqexp2 = EqExpr::create(arguments[3], arguments[1]);
	ref<Expr> Andv1eqexp = AndExpr::create(v1eqexp1, v1eqexp2);
	executor.solver->setTimeout(executor.coreSolverTimeout);
   	std::vector<ref<Expr>> vf;
    	const std::vector<ref<Expr>> &vrDest = vf;
	ExecutionState *fakeDest = new ExecutionState(vrDest);

	ref<ConstantExpr> sourceValue;
	ref<ConstantExpr> destValue;
	
	bool destSuccess = executor.solver->mayBeTrue(*fakeDest, Andv1eqexp, destMatches);

	if (destSuccess && destMatches){
           executor.solver->setTimeout(executor.coreSolverTimeout);
           ref<Expr> notreachableANDinputs = AndExpr::create(notreachable, reachableInput);
              std::string Str1;
  	      llvm::raw_string_ostream info1(Str1);
              ExprPPrinter::printSingleExpr(info1, notreachableANDinputs);
              out << "notreachableANDinputs: " << info1.str() << "\n";
           bool sourceSuccess = executor.solver->mayBeTrue(state, notreachableANDinputs, sourceMatches);
	   if (sourceSuccess && sourceMatches && destSuccess &&destMatches) {
               terminateSuccessDest = true;
              out << " Found a don't care transition, Time=" 
                  << (util::getWallTime() - dontCareStartTime) << "\n";  	
	      llvm::errs() << " Found a don't care transition, " << " source: \n";
	      ExprPPrinter::printConstraints(llvm::errs(), state.constraints);
	      llvm::errs() << "destination " << Andv1eqexp << "\n";
	      ExecutionState *fakeSource = new ExecutionState(state);
	      fakeSource->addConstraint(notreachableANDinputs);
              	std::string Str;
  	     	llvm::raw_string_ostream info(Str);
             	ExprPPrinter::printConstraints(info, fakeSource->constraints);
                out << "fakeSource: " << info.str() << "\n";
	      /////////////////////////new added begin, try to find all possible source///////////////////////////
	      std::pair<ref<Expr>, ref<Expr>> res = executor.solver->getRange(*fakeSource, arguments[2]);
	      ConstantExpr *consfirst = dyn_cast<ConstantExpr>(res.first);
	      ConstantExpr *conssecond = dyn_cast<ConstantExpr>(res.second);
	      llvm::errs() << "Return range of source in getRange: [" 
                           << consfirst->getZExtValue() << "," 
                           << conssecond->getZExtValue() << "]\n";
	      /////////////////////////new added end, try to find all possible source///////////////////////////
              out << "Range of source state in : [" 
                  << consfirst->getZExtValue() << "," 
                  << conssecond->getZExtValue() << "]\n";
	      //executor.solver->getValue(*fakeSource, arguments[2], sourceValue);
	      //llvm::errs() << "Return value of sourceValue in getValue: " << sourceValue->getZExtValue() << "\n";

	      fakeDest->addConstraint(Andv1eqexp);
	      executor.solver->getValue(*fakeDest, arguments[3], destValue);
	      llvm::errs() << "Return value of destValue in getValue: " 
                           << destValue->getZExtValue() << "\n";
              out << "Destination state: " 
                  << destValue->getZExtValue() << "\n";
	   }	
	 }
 }
 
}

////////////////////////////////For 2 input variables FSM (from local metadata)//////////////////////////////////////////
void SpecialFunctionHandler::handleDontCareTransitionLocallyTwoInput(
                                    ExecutionState &state,
                                    KInstruction *target,
                                    std::vector<ref<Expr> > &arguments) {
    llvm::errs() << "Handle don't care transition, args: " << arguments[0] << " " << arguments[1] 
                 << " \n" << arguments[2] << "\n"<<arguments[3]<< "\n";
    StatsTracker * statsTracker = ((Executor*)theInterpreter)->getStatsTracker();
    if (dontcareStats == NULL) {
       std::string fname = "dontcarestats.txt";
       if (DontCareTransFile != "")
          fname = DontCareTransFile; 
       dontcareStats = new std::fstream(fname, std::fstream::out);
    }

    std::fstream & out = *dontcareStats;
      
    /////////start: hander reachable set from forward execution//////////////////
    std::map<ref<Expr>, std::set<ref<Expr> > > gm1;
    if (localMetadataSetMap.find((long)&state) != localMetadataSetMap.end())
        gm1 = localMetadataSetMap[(long)&state];
    std::set<ref<Expr> > rs, rsConcrete; 
    if (gm1.find(arguments[0]) != gm1.end()) 
        rs = gm1[arguments[0]]; 

    ref<Expr> reachable = NULL;

	////Begin: Convert symbolic rs to concrete rs////
    for(auto v: rs){
       std::pair<ref<Expr>, ref<Expr>> rsSymbolic = executor.solver->getRange(state, v);
       ref<Expr> rsSymbolicFirst = rsSymbolic.first;
       auto rsSymbolicFirstConstant = dyn_cast<ConstantExpr>(rsSymbolicFirst);
       uint64_t rsSymbolicFirstUint = rsSymbolicFirstConstant->getZExtValue();
       ref<Expr> rsSymbolicSecond = rsSymbolic.second;
       auto rsSymbolicSecondConstant = dyn_cast<ConstantExpr>(rsSymbolicSecond);
       uint64_t rsSymbolicSecondUint = rsSymbolicSecondConstant->getZExtValue();
       for(auto v1 = rsSymbolicFirstUint; v1 <= rsSymbolicSecondUint; v1++){
		auto v2 = v1;
		rsConcrete.insert(ConstantExpr::create(v2, arguments[2]->getWidth()));
       }
	
    }
	////End: Convert symbolic rs to concrete rs////
    
    for(auto v : rs) {
              std::string Str2;
  	      llvm::raw_string_ostream info2(Str2);
              ExprPPrinter::printSingleExpr(info2, v);
              out << "reachable set from rs: " << info2.str() << "\n";
       llvm::errs() << " reachable value " << v << "\n";
       ref<Expr> eqexp = EqExpr::create(arguments[2], v);
       if (reachable.isNull())
          reachable = eqexp;
       else {
          ref<Expr> temp = reachable;
          reachable = OrExpr::create(temp, eqexp);
       }
    }  

    if (!reachable.isNull()){
       llvm::errs() << "reachable set: " << reachable << "\n"; 
    }
     else
	return;
    ref<Expr> notreachable = NotExpr::create(reachable); 
    llvm::errs() << "Value of notreachable: " << notreachable << "\n"; 
    /////////end: hander reachable set from forward execution////////////////// 


    /////////start: hander first input variable//////////////////
    std::map<ref<Expr>, std::set<ref<Expr> > > gmInput1;
    if (localInputSetMap.find((long)&state) != localInputSetMap.end())
        gmInput1 = localInputSetMap[(long)&state];
    std::set<ref<Expr> > rsInputFirst;
    //if (gmInput1.find(arguments[0]) != gmInput1.end()) 
        rsInputFirst = gmInput1[arguments[0]]; 

    ref<Expr> reachableInputFirst = NULL;//this var represents OR( EQ(inSec, inFirst_i) )
    for(auto v1 : rsInputFirst) {
       llvm::errs() << " reachable first input name " << v1 << "\n";
       ref<Expr> eqexpInputFirst = EqExpr::create(arguments[4], v1);

       if (reachableInputFirst.isNull())
          reachableInputFirst = eqexpInputFirst;
       else
          reachableInputFirst = OrExpr::create(reachableInputFirst, eqexpInputFirst);
    }
   	////////handle second input variable:
    std::map<ref<Expr>, std::set<ref<Expr> > > gmInput2;
    if (localTwoInputSetMap.find((long)&state) != localTwoInputSetMap.end())
        gmInput2 = localTwoInputSetMap[(long)&state];
    std::set<ref<Expr> > rsInputSecond;
    //if (gmInput2.find(arguments[0]) != gmInput2.end()) 
        rsInputSecond = gmInput2[arguments[0]]; 
    ref<Expr> reachableInputSecond = NULL;
    for(auto v1 : rsInputSecond) {
       llvm::errs() << " reachable Second input name " << v1 << "\n";
       ref<Expr> eqexpInputSecond = EqExpr::create(arguments[5], v1);

       if (reachableInputSecond.isNull())
          reachableInputSecond = eqexpInputSecond;
       else
          reachableInputSecond = OrExpr::create(reachableInputSecond, eqexpInputSecond);
    }
   	////////And two input variables:
    ref<Expr> reachableInput = AndExpr::create(reachableInputFirst, reachableInputSecond);

    llvm::errs() << "Width of reachableInput: " << reachableInput->getWidth() << "\n";
    llvm::errs() << "Value of reachableInput: " << reachableInput << "\n";
    /////////end: hander first input variable//////////////////

    for(auto v1 : rs){
	bool sourceMatches;
	bool destMatches;
        ConstantExpr *consv1 = dyn_cast<ConstantExpr>(v1);

	ref<Expr> v1eqexp1 = EqExpr::create(arguments[3], v1);
	ref<Expr> v1eqexp2 = EqExpr::create(arguments[3], arguments[1]);
	ref<Expr> Andv1eqexp = AndExpr::create(v1eqexp1, v1eqexp2);
	executor.solver->setTimeout(executor.coreSolverTimeout);
   	std::vector<ref<Expr>> vf;
    	const std::vector<ref<Expr>> &vrDest = vf;
	ExecutionState *fakeDest = new ExecutionState(vrDest);

	ref<ConstantExpr> sourceValue;
	ref<ConstantExpr> destValue;
	
	bool destSuccess = executor.solver->mayBeTrue(*fakeDest, Andv1eqexp, destMatches);

	if (destSuccess && destMatches){
           executor.solver->setTimeout(executor.coreSolverTimeout);
           ref<Expr> notreachableANDinputs = AndExpr::create(notreachable, reachableInput);
              std::string Str1;
  	      llvm::raw_string_ostream info1(Str1);
              ExprPPrinter::printSingleExpr(info1, notreachableANDinputs);
              out << "notreachableANDinputs: " << info1.str() << "\n";
           bool sourceSuccess = executor.solver->mayBeTrue(state, notreachableANDinputs, sourceMatches);
	   if (sourceSuccess && sourceMatches && destSuccess &&destMatches) {
              out << " Found a don't care transition, Time=" 
                  << (util::getWallTime() - dontCareStartTime) << "\n";  	
	      llvm::errs() << " Found a don't care transition, " << " source: \n";
	      ExprPPrinter::printConstraints(llvm::errs(), state.constraints);
	      llvm::errs() << "destination " << Andv1eqexp << "\n";
	      ExecutionState *fakeSource = new ExecutionState(state);
	      fakeSource->addConstraint(notreachableANDinputs);
              std::string Str;
  	      llvm::raw_string_ostream info(Str);
              ExprPPrinter::printConstraints(info, fakeSource->constraints);
              out << "fakeSource: " << info.str() << "\n";
	      /////////////////////////new added begin, try to find all possible source///////////////////////////
	      std::pair<ref<Expr>, ref<Expr>> res = executor.solver->getRange(*fakeSource, arguments[2]);
	      ConstantExpr *consfirst = dyn_cast<ConstantExpr>(res.first);
	      ConstantExpr *conssecond = dyn_cast<ConstantExpr>(res.second);
	      llvm::errs() << "Return range of source in getRange: [" 
                           << consfirst->getZExtValue() << "," 
                           << conssecond->getZExtValue() << "]\n";
	      /////////////////////////new added end, try to find all possible source///////////////////////////
              out << "Range of source state in : [" 
                  << consfirst->getZExtValue() << "," 
                  << conssecond->getZExtValue() << "]\n";
	      //executor.solver->getValue(*fakeSource, arguments[2], sourceValue);
	      //llvm::errs() << "Return value of sourceValue in getValue: " << sourceValue->getZExtValue() << "\n";

	      fakeDest->addConstraint(Andv1eqexp);
	      executor.solver->getValue(*fakeDest, arguments[3], destValue);
	      llvm::errs() << "Return value of destValue in getValue: " 
                           << destValue->getZExtValue() << "\n";
              out << "Destination state: " 
                  << destValue->getZExtValue() << "\n";
	   }	
	}
    }
}

////////////////////////////////For 3 input variables FSM (from local metadata)//////////////////////////////////////////
void SpecialFunctionHandler::handleDontCareTransitionLocallyThreeInput(
                                    ExecutionState &state,
                                    KInstruction *target,
                                    std::vector<ref<Expr> > &arguments) {
    llvm::errs() << "Handle don't care transition, args: " << arguments[0] << " " << arguments[1] 
                 << " \n" << arguments[2] << "\n"<<arguments[3]<< "\n";
    StatsTracker * statsTracker = ((Executor*)theInterpreter)->getStatsTracker();
    if (dontcareStats == NULL) {
       std::string fname = "dontcarestats.txt";
       if (DontCareTransFile != "")
          fname = DontCareTransFile; 
       dontcareStats = new std::fstream(fname, std::fstream::out);
    }

    std::fstream & out = *dontcareStats;
    
    /////////start: hander reachable set from forward execution//////////////////       
    std::map<ref<Expr>, std::set<ref<Expr> > > gm3;
    if (localMetadataSetMap.find((long)&state) != localMetadataSetMap.end())
        gm3 = localMetadataSetMap[(long)&state];
    std::set<ref<Expr> > rs, rsConcrete; 
    if (gm3.find(arguments[0]) != gm3.end()) 
        rs = gm3[arguments[0]]; 

    ref<Expr> reachable = NULL;

	////Begin: Convert symbolic rs to concrete rs////
    for(auto v: rs){
       std::pair<ref<Expr>, ref<Expr>> rsSymbolic = executor.solver->getRange(state, v);
       ref<Expr> rsSymbolicFirst = rsSymbolic.first;
       auto rsSymbolicFirstConstant = dyn_cast<ConstantExpr>(rsSymbolicFirst);
       uint64_t rsSymbolicFirstUint = rsSymbolicFirstConstant->getZExtValue();
       ref<Expr> rsSymbolicSecond = rsSymbolic.second;
       auto rsSymbolicSecondConstant = dyn_cast<ConstantExpr>(rsSymbolicSecond);
       uint64_t rsSymbolicSecondUint = rsSymbolicSecondConstant->getZExtValue();
       for(auto v1 = rsSymbolicFirstUint; v1 <= rsSymbolicSecondUint; v1++){
		auto v2 = v1;
		rsConcrete.insert(ConstantExpr::create(v2, arguments[2]->getWidth()));
       }
	
    }
	////End: Convert symbolic rs to concrete rs////

    for(auto v : rs) {
        std::string Str2;
  	    llvm::raw_string_ostream info2(Str2);
        ExprPPrinter::printSingleExpr(info2, v);
        out << "reachable set from rs: " << info2.str() << "\n";
		llvm::errs() << " reachable value " << v << "\n";
		ref<Expr> eqexp = EqExpr::create(arguments[2], v);
		if (reachable.isNull())
          reachable = eqexp;
		else {
          ref<Expr> temp = reachable;
          reachable = OrExpr::create(temp, eqexp);
		}
    }  

    if (!reachable.isNull()){
       llvm::errs() << "reachable set: " << reachable << "\n"; 
    }
    else
		return;

    ref<Expr> notreachable = NotExpr::create(reachable); 
    llvm::errs() << "Value of notreachable: " << notreachable << "\n"; 
    /////////end: hander reachable set from forward execution////////////////// 


    //////////////start: hander first input variable///////////////////////////
    	////////handle first input variable:
    /////////start: hander first input variable//////////////////
    std::map<ref<Expr>, std::set<ref<Expr> > > gmInput1;
    if (localInputSetMap.find((long)&state) != localInputSetMap.end())
        gmInput1 = localInputSetMap[(long)&state];
    std::set<ref<Expr> > rsInputFirst;
    if (gmInput1.find(arguments[0]) != gmInput1.end()) 
        rsInputFirst = gmInput1[arguments[0]]; 

    ref<Expr> reachableInputFirst = NULL;//this var represents OR( EQ(inSec, inFirst_i) )
    for(auto v1 : rsInputFirst) {
       llvm::errs() << " reachable first input name " << v1 << "\n";
       ref<Expr> eqexpInputFirst = EqExpr::create(arguments[4], v1);

       if (reachableInputFirst.isNull())
          reachableInputFirst = eqexpInputFirst;
       else
          reachableInputFirst = OrExpr::create(reachableInputFirst, eqexpInputFirst);
    }
   	////////handle second input variable:
    std::map<ref<Expr>, std::set<ref<Expr> > > gmInput2;
    if (localTwoInputSetMap.find((long)&state) != localTwoInputSetMap.end())
        gmInput2 = localTwoInputSetMap[(long)&state];
    std::set<ref<Expr> > rsInputSecond;
    if (gmInput2.find(arguments[0]) != gmInput2.end()) 
        rsInputSecond = gmInput2[arguments[0]]; 
    ref<Expr> reachableInputSecond = NULL;
    for(auto v1 : rsInputSecond) {
       llvm::errs() << " reachable Second input name " << v1 << "\n";
       ref<Expr> eqexpInputSecond = EqExpr::create(arguments[5], v1);

       if (reachableInputSecond.isNull())
          reachableInputSecond = eqexpInputSecond;
       else
          reachableInputSecond = OrExpr::create(reachableInputSecond, eqexpInputSecond);
    }
   	////////handle third input variable:   
   std::map<ref<Expr>, std::set<ref<Expr> > > gmInput3;
    if (localThreeInputSetMap.find((long)&state) != localThreeInputSetMap.end())
        gmInput3 = localThreeInputSetMap[(long)&state];
    std::set<ref<Expr> > rsInputThird;
    if (gmInput3.find(arguments[0]) != gmInput3.end()) 
        rsInputThird = gmInput3[arguments[0]]; 

    ref<Expr> reachableInputThird = NULL;
    for(auto v1 : rsInputThird) {
       llvm::errs() << " reachable Third input name " << v1 << "\n";
       ref<Expr> eqexpInputThird = EqExpr::create(arguments[6], v1);

       if (reachableInputThird.isNull())
          reachableInputThird = eqexpInputThird;
       else
          reachableInputThird = OrExpr::create(reachableInputThird, eqexpInputThird);
    }
   	
    

    ref<Expr> reachableInputFirstSecond = AndExpr::create(reachableInputFirst, reachableInputSecond);//And first with second input variables	
 
    ref<Expr> reachableInput = AndExpr::create(reachableInputFirstSecond, reachableInputThird);//And FirstSecond with Third input variables

    llvm::errs() << "Width of reachableInput: " << reachableInput->getWidth() << "\n";
    llvm::errs() << "Value of reachableInput: " << reachableInput << "\n";
    /////////end: hander first input variable//////////////////
    bool terminateSuccessDest = false;
    for(auto v1 : rs){
	bool sourceMatches;
	bool destMatches;
        ConstantExpr *consv1 = dyn_cast<ConstantExpr>(v1);

	ref<Expr> v1eqexp1 = EqExpr::create(arguments[3], v1);
	ref<Expr> v1eqexp2 = EqExpr::create(arguments[3], arguments[1]);
	ref<Expr> Andv1eqexp = AndExpr::create(v1eqexp1, v1eqexp2);
	executor.solver->setTimeout(executor.coreSolverTimeout);
   	std::vector<ref<Expr>> vf;
    	const std::vector<ref<Expr>> &vrDest = vf;
	ExecutionState *fakeDest = new ExecutionState(vrDest);

	ref<ConstantExpr> sourceValue;
	ref<ConstantExpr> destValue;
	
	bool destSuccess = executor.solver->mayBeTrue(*fakeDest, Andv1eqexp, destMatches);

	if (destSuccess && destMatches){
           executor.solver->setTimeout(executor.coreSolverTimeout);
           ref<Expr> notreachableANDinputs = AndExpr::create(notreachable, reachableInput);
           
           std::string Str1;
  	       llvm::raw_string_ostream info1(Str1);
           ExprPPrinter::printSingleExpr(info1, notreachableANDinputs);
           out << "notreachableANDinputs: " << info1.str() << "\n";
          
           bool sourceSuccess = executor.solver->mayBeTrue(state, notreachableANDinputs, sourceMatches);
	   if (sourceSuccess && sourceMatches && destSuccess &&destMatches) {
	      terminateSuccessDest = true;
              out << " Found a don't care transition, Time=" 
                  << (util::getWallTime() - dontCareStartTime) << "\n";  	
	      llvm::errs() << " Found a don't care transition, " << " source: \n";
	      ExprPPrinter::printConstraints(llvm::errs(), state.constraints);
	      llvm::errs() << "destination " << Andv1eqexp << "\n";
	      ExecutionState *fakeSource = new ExecutionState(state);
	      fakeSource->addConstraint(notreachableANDinputs);
             
        std::string Str;
  	    llvm::raw_string_ostream info(Str);
        ExprPPrinter::printConstraints(info, fakeSource->constraints);
        out << "fakeSource: " << info.str() << "\n";
              
	      /////////////////////////new added begin, try to find all possible source///////////////////////////
	      std::pair<ref<Expr>, ref<Expr>> res = executor.solver->getRange(*fakeSource, arguments[2]);
	      ConstantExpr *consfirst = dyn_cast<ConstantExpr>(res.first);
	      ConstantExpr *conssecond = dyn_cast<ConstantExpr>(res.second);
	      llvm::errs() << "Return range of source in getRange: [" 
                           << consfirst->getZExtValue() << "," 
                           << conssecond->getZExtValue() << "]\n";
	      /////////////////////////new added end, try to find all possible source///////////////////////////
              out << "Range of source state in : [" 
                  << consfirst->getZExtValue() << "," 
                  << conssecond->getZExtValue() << "]\n";
	      //executor.solver->getValue(*fakeSource, arguments[2], sourceValue);
	      //llvm::errs() << "Return value of sourceValue in getValue: " << sourceValue->getZExtValue() << "\n";

	      fakeDest->addConstraint(Andv1eqexp);
	      executor.solver->getValue(*fakeDest, arguments[1], destValue);
	      llvm::errs() << "Return value of destValue in getValue: " 
                           << destValue->getZExtValue() << "\n";
              out << "Destination state: " 
                  << destValue->getZExtValue() << "\n";
	   }	
	}
    }

}


////////////////////////////////For 4 input variables FSM (from local metadata)//////////////////////////////////////////
void SpecialFunctionHandler::handleDontCareTransitionLocallyFourInput(
                                    ExecutionState &state,
                                    KInstruction *target,
                                    std::vector<ref<Expr> > &arguments) {
    llvm::errs() << "Handle don't care transition, args: " << arguments[0] << " " << arguments[1] 
                 << " \n" << arguments[2] << "\n"<<arguments[3]<< "\n";
    StatsTracker * statsTracker = ((Executor*)theInterpreter)->getStatsTracker();
    if (dontcareStats == NULL) {
       std::string fname = "dontcarestats.txt";
       if (DontCareTransFile != "")
          fname = DontCareTransFile; 
       dontcareStats = new std::fstream(fname, std::fstream::out);
    }

    std::fstream & out = *dontcareStats;
    /////////start: hander reachable set from forward execution//////////////////       
    std::map<ref<Expr>, std::set<ref<Expr> > > gm4;
    if (localMetadataSetMap.find((long)&state) != localMetadataSetMap.end())
        gm4 = localMetadataSetMap[(long)&state];
    std::set<ref<Expr> > rs, rsConcrete; 
    if (gm4.find(arguments[0]) != gm4.end()) 
        rs = gm4[arguments[0]]; 

    ref<Expr> reachable = NULL;

	////Begin: Convert symbolic rs to concrete rs////
    /*for(auto v: rs){
       std::pair<ref<Expr>, ref<Expr>> rsSymbolic = executor.solver->getRange(state, v);
       ref<Expr> rsSymbolicFirst = rsSymbolic.first;
       auto rsSymbolicFirstConstant = dyn_cast<ConstantExpr>(rsSymbolicFirst);
       uint64_t rsSymbolicFirstUint = rsSymbolicFirstConstant->getZExtValue();
       ref<Expr> rsSymbolicSecond = rsSymbolic.second;
       auto rsSymbolicSecondConstant = dyn_cast<ConstantExpr>(rsSymbolicSecond);
       uint64_t rsSymbolicSecondUint = rsSymbolicSecondConstant->getZExtValue();
       for(auto v1 = rsSymbolicFirstUint; v1 <= rsSymbolicSecondUint; v1++){
		auto v2 = v1;
		rsConcrete.insert(ConstantExpr::create(v2, arguments[2]->getWidth()));
       }
	
    }*/
	////End: Convert symbolic rs to concrete rs////

    for(auto v : rs) {
        std::string Str2;
  	    llvm::raw_string_ostream info2(Str2);
        ExprPPrinter::printSingleExpr(info2, v);
        out << "reachable set from rs: " << info2.str() << "\n";
		llvm::errs() << " reachable value " << v << "\n";
		ref<Expr> eqexp = EqExpr::create(arguments[2], v);
		if (reachable.isNull())
          reachable = eqexp;
		else {
          ref<Expr> temp = reachable;
          reachable = OrExpr::create(temp, eqexp);
		}
    }  

    if (!reachable.isNull()){
       llvm::errs() << "reachable set: " << reachable << "\n"; 
    }
    else
		return;

    ref<Expr> notreachable = NotExpr::create(reachable); 
    llvm::errs() << "Value of notreachable: " << notreachable << "\n"; 
    /////////end: hander reachable set from forward execution////////////////// 


    //////////////start: hander first input variable///////////////////////////
    	////////handle first input variable:
    /////////start: hander first input variable//////////////////
    std::map<ref<Expr>, std::set<ref<Expr> > > gmInput1;
    if (localInputSetMap.find((long)&state) != localInputSetMap.end())
        gmInput1 = localInputSetMap[(long)&state];
    std::set<ref<Expr> > rsInputFirst;
    if (gmInput1.find(arguments[0]) != gmInput1.end()) 
        rsInputFirst = gmInput1[arguments[0]]; 

    ref<Expr> reachableInputFirst = NULL;//this var represents OR( EQ(inSec, inFirst_i) )
    for(auto v1 : rsInputFirst) {
       llvm::errs() << " reachable first input name " << v1 << "\n";
       ref<Expr> eqexpInputFirst = EqExpr::create(arguments[4], v1);

       if (reachableInputFirst.isNull())
          reachableInputFirst = eqexpInputFirst;
       else
          reachableInputFirst = OrExpr::create(reachableInputFirst, eqexpInputFirst);
    }
   	////////handle second input variable:
    std::map<ref<Expr>, std::set<ref<Expr> > > gmInput2;
    if (localTwoInputSetMap.find((long)&state) != localTwoInputSetMap.end())
        gmInput2 = localTwoInputSetMap[(long)&state];
    std::set<ref<Expr> > rsInputSecond;
    if (gmInput2.find(arguments[0]) != gmInput2.end()) 
        rsInputSecond = gmInput2[arguments[0]]; 
    ref<Expr> reachableInputSecond = NULL;
    for(auto v1 : rsInputSecond) {
       llvm::errs() << " reachable Second input name " << v1 << "\n";
       ref<Expr> eqexpInputSecond = EqExpr::create(arguments[5], v1);

       if (reachableInputSecond.isNull())
          reachableInputSecond = eqexpInputSecond;
       else
          reachableInputSecond = OrExpr::create(reachableInputSecond, eqexpInputSecond);
    }
   	////////handle third input variable:   
   std::map<ref<Expr>, std::set<ref<Expr> > > gmInput3;
    if (localThreeInputSetMap.find((long)&state) != localThreeInputSetMap.end())
        gmInput3 = localThreeInputSetMap[(long)&state];
    std::set<ref<Expr> > rsInputThird;
    if (gmInput3.find(arguments[0]) != gmInput3.end()) 
        rsInputThird = gmInput3[arguments[0]]; 

    ref<Expr> reachableInputThird = NULL;
    for(auto v1 : rsInputThird) {
       llvm::errs() << " reachable Third input name " << v1 << "\n";
       ref<Expr> eqexpInputThird = EqExpr::create(arguments[6], v1);

       if (reachableInputThird.isNull())
          reachableInputThird = eqexpInputThird;
       else
          reachableInputThird = OrExpr::create(reachableInputThird, eqexpInputThird);
    }
	
	   	////////handle fourth input variable:
	std::map<ref<Expr>, std::set<ref<Expr> > > gmInput4;
    if (localFourInputSetMap.find((long)&state) != localFourInputSetMap.end())
        gmInput4 = localFourInputSetMap[(long)&state];
    std::set<ref<Expr> > rsInputFourth;
    if (gmInput4.find(arguments[0]) != gmInput4.end()) 
        rsInputFourth = gmInput4[arguments[0]];

    ref<Expr> reachableInputFourth = NULL;
    for(auto v1 : rsInputFourth) {
       llvm::errs() << " reachable Fourth input name " << v1 << "\n";
       ref<Expr> eqexpInputFourth = EqExpr::create(arguments[7], v1);

       if (reachableInputFourth.isNull())
          reachableInputFourth = eqexpInputFourth;
       else
          reachableInputFourth = OrExpr::create(reachableInputFourth, eqexpInputFourth);
    }

    ref<Expr> reachableInputFirstSecond = AndExpr::create(reachableInputFirst, reachableInputSecond);//And first with second input variables	
    ref<Expr> reachableInputThirdFourth = AndExpr::create(reachableInputFourth, reachableInputThird);//And third with fourth input variables
 
    ref<Expr> reachableInput = AndExpr::create(reachableInputFirstSecond, reachableInputThirdFourth);//And FirstSecond with ThirdFourth

    llvm::errs() << "Width of reachableInput: " << reachableInput->getWidth() << "\n";
    llvm::errs() << "Value of reachableInput: " << reachableInput << "\n";
    /////////end: hander first input variable//////////////////
    bool terminateSuccessDest = false;
    for(auto v1 : rs){
	bool sourceMatches;
	bool destMatches;
        ConstantExpr *consv1 = dyn_cast<ConstantExpr>(v1);

	ref<Expr> v1eqexp1 = EqExpr::create(arguments[3], v1);
	ref<Expr> v1eqexp2 = EqExpr::create(arguments[3], arguments[1]);
	ref<Expr> Andv1eqexp = AndExpr::create(v1eqexp1, v1eqexp2);
	executor.solver->setTimeout(executor.coreSolverTimeout);
   	std::vector<ref<Expr>> vf;
    	const std::vector<ref<Expr>> &vrDest = vf;
	ExecutionState *fakeDest = new ExecutionState(vrDest);

	ref<ConstantExpr> sourceValue;
	ref<ConstantExpr> destValue;
	
	bool destSuccess = executor.solver->mayBeTrue(*fakeDest, Andv1eqexp, destMatches);

	if (destSuccess && destMatches){
           executor.solver->setTimeout(executor.coreSolverTimeout);
           ref<Expr> notreachableANDinputs = AndExpr::create(notreachable, reachableInput);
           
          std::string Str1;
  	      llvm::raw_string_ostream info1(Str1);
          ExprPPrinter::printSingleExpr(info1, notreachableANDinputs);
          out << "notreachableANDinputs: " << info1.str() << "\n";
          
           bool sourceSuccess = executor.solver->mayBeTrue(state, notreachableANDinputs, sourceMatches);
	   if (sourceSuccess && sourceMatches && destSuccess &&destMatches) {
	      terminateSuccessDest = true;
              out << " Found a don't care transition, Time=" 
                  << (util::getWallTime() - dontCareStartTime) << "\n";  	
	      llvm::errs() << " Found a don't care transition, " << " source: \n";
	      ExprPPrinter::printConstraints(llvm::errs(), state.constraints);
	      llvm::errs() << "destination " << Andv1eqexp << "\n";
	      ExecutionState *fakeSource = new ExecutionState(state);
	      fakeSource->addConstraint(notreachableANDinputs);
             
        std::string Str;
  	    llvm::raw_string_ostream info(Str);
        ExprPPrinter::printConstraints(info, fakeSource->constraints);
        out << "fakeSource: " << info.str() << "\n";
              
	      /////////////////////////new added begin, try to find all possible source///////////////////////////
	      std::pair<ref<Expr>, ref<Expr>> res = executor.solver->getRange(*fakeSource, arguments[2]);
	      ConstantExpr *consfirst = dyn_cast<ConstantExpr>(res.first);
	      ConstantExpr *conssecond = dyn_cast<ConstantExpr>(res.second);
	      llvm::errs() << "Return range of source in getRange: [" 
                           << consfirst->getZExtValue() << "," 
                           << conssecond->getZExtValue() << "]\n";
	      /////////////////////////new added end, try to find all possible source///////////////////////////
              out << "Range of source state in : [" 
                  << consfirst->getZExtValue() << "," 
                  << conssecond->getZExtValue() << "]\n";
	      //executor.solver->getValue(*fakeSource, arguments[2], sourceValue);
	      //llvm::errs() << "Return value of sourceValue in getValue: " << sourceValue->getZExtValue() << "\n";

	      fakeDest->addConstraint(Andv1eqexp);
	      executor.solver->getValue(*fakeDest, arguments[1], destValue);
	      llvm::errs() << "Return value of destValue in getValue: " 
                           << destValue->getZExtValue() << "\n";
              out << "Destination state: " 
                  << destValue->getZExtValue() << "\n";
	   }	
	}
   }

}

///////////////////////// For finding all transitions from a source state///////////////////
//klee_find_all_transitions_from_given_src_globally(&S, depth, srcState, sinkState, protecState);
//klee_find_all_transitions_from_given_src_globally(arg0, arg1,   arg2,    arg3,        arg4);
void SpecialFunctionHandler::handleAllTransitionFromGivenSrcGlobally(
                                    ExecutionState &state,
                                    KInstruction *target,
                                    std::vector<ref<Expr> > &arguments) {
    llvm::errs() << "Calling function klee_find_all_transitions_from_given_src_globally(): arg[1]=" 
                 << arguments[1] << "; arg[2]=" << arguments[2] << "; arg[3]=" << arguments[3] << "; arg[4]=" << arguments[4];   
    
    //a set of tuples, while in each tuple: (srcState, sinkState, depth, pathCondition)
    llvm::errs() << " Time=" << (util::getWallTime() - dontCareStartTime) << "\n";
    std::set<std::tuple<ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>, double>> stFindAllTransFromSrc;

    // a set that contains all reachable states, for debug case
    //std::set<ref<Expr> > ms;
    
        
    StatsTracker * statsTracker = ((Executor*)theInterpreter)->getStatsTracker();
    if (findAllTransFromSrc == NULL) {
       std::string fname = "allTransFromSrc.txt";
       if (FindAllTransFromSrcFile != "")
          fname = FindAllTransFromSrcFile; 
       findAllTransFromSrc = new std::fstream(fname, std::fstream::out);
    }

    std::fstream & out = *findAllTransFromSrc;
    
    out << "Calling function klee_find_all_transitions_from_given_src_globally()\n";
    
    //if (globalMetadataSetMap.find(arguments[0]) != globalMetadataSetMap.end()) 
       //ms = globalMetadataSetMap[arguments[0]];
       
    if(globalOutputTupleFindAllTransFromSrc.find(arguments[0]) !=  globalOutputTupleFindAllTransFromSrc.end())
       stFindAllTransFromSrc = globalOutputTupleFindAllTransFromSrc[arguments[0]];

    // create a fake state
   	std::vector<ref<Expr>> vf;
    const std::vector<ref<Expr>> &vrf = vf;
   	ExecutionState *fake = new ExecutionState(vrf);
      
    //ConstantExpr *constarg1 = dyn_cast<ConstantExpr>(arguments[1]);
    ConstantExpr *constarg2 = dyn_cast<ConstantExpr>(arguments[2]);
    ConstantExpr *constarg3 = dyn_cast<ConstantExpr>(arguments[3]);
    ConstantExpr *constarg4 = dyn_cast<ConstantExpr>(arguments[4]);
    
    ref<ConstantExpr> concreteConstArg2, concreteConstArg3;
    
    //check if arguments[2] (i.e. srcState) is concrete or symbolic
    if (constarg2) 
        concreteConstArg2 = constarg2;
      
    else {
        executor.solver->getValue(*fake, arguments[2], concreteConstArg2);
        //executor.solver->getValue(state, arguments[2], concreteConstArg2);
        llvm::errs() << "\nConvert symbolic arg2 to concrete: " << concreteConstArg2;
    }
    
    //ms.insert(concreteConstArg2);
    
    //check if arguments[3] (i.e. sinkState) is concrete or symbolic
    if (constarg3)
        concreteConstArg3 = constarg3;
        
    else {
        executor.solver->getValue(*fake, arguments[3], concreteConstArg3);
        //executor.solver->getValue(state, arguments[3], concreteConstArg3);
        llvm::errs() << "\nConvert symbolic arg3 to concrete: " << concreteConstArg3 << "\n";
    }
    
    //ms.insert(concreteConstArg3);


    if ((concreteConstArg2->getZExtValue() == rstState) || (concreteConstArg3->getZExtValue() == rstState)) {
        out << " Unreachable->rstState, terminate! Time=" 
            << (util::getWallTime() - dontCareStartTime) << "s\n";
        executor.terminateState(state);
    }
    
    //acquire path condition
    std::vector<ref<Expr>> pcConditiontemp = state.constraints.getConstraints();
    ref<Expr> pcCondition = NULL;
    std::vector< ref<Expr> >::const_iterator vi = pcConditiontemp.begin();
    while (vi != pcConditiontemp.end()) {
        if (pcCondition.isNull())
            pcCondition = *vi;
        else
            pcCondition = AndExpr::create(*vi, pcCondition);
        vi++;
    }

    llvm::errs() << "Collected path condition\n";

    double pathTime = (util::getWallTime() - dontCareStartTime);
    
    //stFindAllTransFromSrc.insert(std::make_tuple(arguments[2], arguments[3], arguments[1], pcCondition, pathTime));
    stFindAllTransFromSrc.insert(std::make_tuple(concreteConstArg2, concreteConstArg3, arguments[1], pcCondition, pathTime));
    globalOutputTupleFindAllTransFromSrc[arguments[0]] = stFindAllTransFromSrc;
    
    //globalMetadataSetMap[arguments[0]] = ms;
    //llvm::errs() << "reachable states: ";
    //for(auto v : ms)        
       //llvm::errs() << v << "; ";  
    //llvm::errs() << "\n";
      
    bool terminateSuccess = false;    
    // if given depth is reached OR destState == protectState, print all tuples in the set and terminate execution

    //uint64_t arg1 = constarg1->getZExtValue();
    //if (/*(arg1 = NUMSTEPS) ||*/ (concreteConstArg3->getZExtValue() == constarg4->getZExtValue())){
        out  << "***********Finishing finding all transitions from a given srcState to protecState, results:\n ";
        llvm::errs()  << "***********Finishing finding all transitions from a given srcState to protecState, results:\n ";
        
       
        for(auto& tuple: stFindAllTransFromSrc){
            std::string Str0;
	          llvm::raw_string_ostream info0(Str0);
            ExprPPrinter::printSingleExpr(info0, std::get<0>(tuple));
            out  << "srcState: "<< info0.str(); 
            llvm::errs()  << "srcState" << std::get<0>(tuple);

            std::string Str1;
	          llvm::raw_string_ostream info1(Str1);
            ExprPPrinter::printSingleExpr(info1, std::get<1>(tuple));
            out  << "; sinkState: "<< info1.str(); 
            llvm::errs()  << "; sinkState: " << std::get<1>(tuple);

            std::string Str2;
	          llvm::raw_string_ostream info2(Str2);
            ExprPPrinter::printSingleExpr(info2, std::get<2>(tuple));
            out  << "; depth: "<< info2.str(); 
            llvm::errs()  << "; depth: " << std::get<2>(tuple);
            
            //std::string Str4;
	          //llvm::raw_string_ostream info4(Str4);
            //ExprPPrinter::printSingleExpr(info3, std::get<3>(tuple));
            double pathTimeTemp = std::get<4>(tuple);
            out  << "; path time: " << pathTimeTemp << "s\n";
            llvm::errs()  << "; path time: " << std::get<4>(tuple);

            std::string Str3;
            llvm::errs() << "; arg3 in tuple:" << std::get<3>(tuple) <<"\n";
	          llvm::raw_string_ostream info3(Str3);
            ExprPPrinter::printSingleExpr(info3, std::get<3>(tuple));
            out  << "path constraint: "<< info3.str() << "\n";
        }
        out  << "***********\n";
        terminateSuccess == true;
      //}
    
    
    if (terminateSuccess == true){
        out  << "Terminating execution!!\n";
        //executor.terminateState(state);
    }
}


///////////////////////// For finding all transitions from a unreachable source state///////////////////
void SpecialFunctionHandler::handleAllTransitionFromGivenUnreachableSrcOneStepGlobally(
                                    ExecutionState &state,
                                    KInstruction *target,
                                    std::vector<ref<Expr> > &arguments) {
    llvm::errs() << "Calling function klee_find_all_transitions_from_given_unreachable_src_one_step_globally(): arg[1]=" 
                 << arguments[1] << "; arg[2]=" << arguments[2] << "; arg[3]=" << arguments[3] << "; arg[4]=" << arguments[4];   
 
    StatsTracker * statsTracker = ((Executor*)theInterpreter)->getStatsTracker();
    if (dontcareStats == NULL) {
       std::string fname = "dontcarestats.txt";
       if (DontCareTransFile != "")
          fname = DontCareTransFile; 
       dontcareStats = new std::fstream(fname, std::fstream::out);
    }

    std::fstream & out = *dontcareStats;
    
    std::set<std::tuple<ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>, double>> stFindAllTransFromSrc;
    if(globalOutputTupleFindAllTransFromSrc.find(arguments[5]) !=  globalOutputTupleFindAllTransFromSrc.end())
       stFindAllTransFromSrc = globalOutputTupleFindAllTransFromSrc[arguments[5]];
       
    /////////start: hander reachable set from forward execution//////////////////       
    std::set<ref<Expr> > rs;
    if (globalMetadataSetMap.find(arguments[0]) != 
                                  globalMetadataSetMap.end())
       rs = globalMetadataSetMap[arguments[0]];
    ref<Expr> reachable = NULL;
    

    //acquire path condition
    std::vector<ref<Expr>> pcConditiontemp = state.constraints.getConstraints();
    ref<Expr> pcCondition = NULL;
    std::vector< ref<Expr> >::const_iterator vi = pcConditiontemp.begin();
    while (vi != pcConditiontemp.end()) {
        if (pcCondition.isNull())
            pcCondition = *vi;
        else
            pcCondition = AndExpr::create(*vi, pcCondition);
        vi++;
    }
    
     
    for(auto v : rs) {
       //llvm::errs() << " reachable value " << v << "\n";
        std::string Str2;
  	    llvm::raw_string_ostream info2(Str2);
        ExprPPrinter::printSingleExpr(info2, v);
        out << "reachable set from rs: " << info2.str() << "\n";
       ref<Expr> eqexp = EqExpr::create(arguments[2], v);
       if (reachable.isNull())
          reachable = eqexp;
       else {
          ref<Expr> temp = reachable;
          reachable = OrExpr::create(temp, eqexp);
       }
    }  
    if (!reachable.isNull())
       llvm::errs() << "reachable set: " << reachable << "\n"; 
    else
        return;

    ref<Expr> notreachable = NotExpr::create(reachable); 
    llvm::errs() << "Value of notreachable: " << notreachable << "\n"; 
    /////////end: hander reachable set from forward execution////////////////// 


    /////////start: hander first input variable//////////////////
    std::set<ref<Expr> > rsInput;
    if (globalInputSetMap.find(arguments[0]) != globalInputSetMap.end())
       rsInput = globalInputSetMap[arguments[0]];
    ref<Expr> reachableInput = NULL;//this var represents OR( EQ(inSec, inFirst_i) )
    for(auto v1 : rsInput) {
       llvm::errs() << " reachable first input name " << v1 << "\n";
       ref<Expr> eqexpInput = EqExpr::create(arguments[4], v1);

       if (reachableInput.isNull())
          reachableInput = eqexpInput;
       else
          reachableInput = OrExpr::create(reachableInput, eqexpInput);
    }
    llvm::errs() << "Width of reachableInput: " << reachableInput->getWidth() << "\n";
    llvm::errs() << "Value of reachableInput: " << reachableInput << "\n";
    /////////end: hander first input variable//////////////////
    bool terminateSuccessDest = false;
  for(auto v1 : rs){
	  bool sourceMatches;
	  bool destMatches;
    ConstantExpr *consv1 = dyn_cast<ConstantExpr>(v1);

	  ref<Expr> v1eqexp1 = EqExpr::create(arguments[3], v1);
  	ref<Expr> v1eqexp2 = EqExpr::create(arguments[3], arguments[1]);
	  ref<Expr> Andv1eqexp = AndExpr::create(v1eqexp1, v1eqexp2);
	  //executor.solver->setTimeout(executor.coreSolverTimeout);
     
   	std::vector<ref<Expr>> vf;
    const std::vector<ref<Expr>> &vrDest = vf;
	  ExecutionState *fakeDest = new ExecutionState(vrDest);

      //ExecutionState *fakeDest = new ExecutionState(state);
      executor.solver->setTimeout(executor.coreSolverTimeout);
      
	  ref<ConstantExpr> sourceValue;
  	ref<ConstantExpr> destValue;
	
	  bool destSuccess = executor.solver->mayBeTrue(*fakeDest, Andv1eqexp, destMatches);

	  if (destSuccess && destMatches){
        executor.solver->setTimeout(executor.coreSolverTimeout);
        ref<Expr> notreachableANDinputs = AndExpr::create(notreachable, reachableInput);
           
        std::string Str1;
        llvm::raw_string_ostream info1(Str1);
        ExprPPrinter::printSingleExpr(info1, notreachableANDinputs);
        //out << "notreachableANDinputs: " << info1.str() << "\n";
              
        bool sourceSuccess = executor.solver->mayBeTrue(state, notreachableANDinputs, sourceMatches);
        if (sourceSuccess && sourceMatches && destSuccess &&destMatches) {
            terminateSuccessDest = true;
            out << " Found a don't care transition, Time=" 
                << (util::getWallTime() - dontCareStartTime) << "\n";  	
            llvm::errs() << " Found a don't care transition, " << " source: \n";
            ExprPPrinter::printConstraints(llvm::errs(), state.constraints);
            llvm::errs() << "destination " << Andv1eqexp << "\n";
            ExecutionState *fakeSource = new ExecutionState(state);
            fakeSource->addConstraint(notreachableANDinputs);
             
            std::string Str;
            llvm::raw_string_ostream info(Str);
            ExprPPrinter::printConstraints(info, fakeSource->constraints);
            //out << "fakeSource: " << info.str() << "\n";
              
            /////////////////////////new added begin, try to find all possible source///////////////////////////
            std::pair<ref<Expr>, ref<Expr>> res = executor.solver->getRange(*fakeSource, arguments[2]);
            ConstantExpr *consfirst = dyn_cast<ConstantExpr>(res.first);
            ConstantExpr *conssecond = dyn_cast<ConstantExpr>(res.second);
            llvm::errs() << "Return range of source in getRange: [" 
                         << consfirst->getZExtValue() << "," 
                         << conssecond->getZExtValue() << "]\n";
                         
            ref<ConstantExpr> concreteConsfirst, concreteConstArg3;             
            if (consfirst)
                concreteConsfirst = consfirst;
        
            else {
                executor.solver->getValue(*fakeDest, arguments[3], concreteConstArg3);
                //executor.solver->getValue(state, arguments[3], concreteConstArg3);
                llvm::errs() << "\nConvert symbolic arg3 to concrete: " << concreteConstArg3 << "\n";
            }
            /////////////////////////new added end, try to find all possible source///////////////////////////
            out << "Range of source state in : [" 
                << consfirst->getZExtValue() << "," 
                << conssecond->getZExtValue() << "]\n";
            //executor.solver->getValue(*fakeSource, arguments[2], sourceValue);
            //llvm::errs() << "Return value of sourceValue in getValue: " << sourceValue->getZExtValue() << "\n";

            fakeDest->addConstraint(Andv1eqexp);
            executor.solver->getValue(*fakeDest, arguments[3], destValue);
            llvm::errs() << "Return value of destValue in getValue: " 
                         << destValue->getZExtValue() << "\n";
            out << "Destination state: " 
                << destValue->getZExtValue() << "\n";
                
            double pathTime = (util::getWallTime() - dontCareStartTime);
    
            //stFindAllTransFromSrc.insert(std::make_tuple(arguments[2], arguments[3], arguments[1], pcCondition, pathTime));
            stFindAllTransFromSrc.insert(std::make_tuple(concreteConsfirst, destValue, arguments[6], pcCondition, pathTime));
            globalOutputTupleFindAllTransFromSrc[arguments[5]] = stFindAllTransFromSrc; 
        }        
        else
            continue;
        	
	  }
    else
        continue;
  }
	std::vector<ref<Expr>> vf;
  const std::vector<ref<Expr>> &vrDest = vf;
	ExecutionState *fake = new ExecutionState(vrDest);    
  ref<ConstantExpr> destValueDebug;
    
  if ((terminateSuccessDest == false) && (TerminateNoDCTState==true)){
    executor.terminateState(state);
    out << " Terminate state that don't have incoming DCT successfully! ";
    
    executor.solver->getValue(*fake, arguments[1], destValueDebug);
    out << "Which is state = : " << destValueDebug->getZExtValue() << "\n";
    return;
    } 
} 
////////////////////////////////For 1 input variable FSM(From global metadata)//////////////////////////////////////////
void SpecialFunctionHandler::handleDontCareTransitionGlobally(
                                    ExecutionState &state,
                                    KInstruction *target,
                                    std::vector<ref<Expr> > &arguments) {
    //llvm::errs() << "Handle don't care transition, args: " << arguments[0] << " " << arguments[1] 
                // << " \n" << arguments[2] << "\n"<<arguments[3]<< "\n";
    StatsTracker * statsTracker = ((Executor*)theInterpreter)->getStatsTracker();
    if (dontcareStats == NULL) {
       std::string fname = "dontcarestats.txt";
       if (DontCareTransFile != "")
          fname = DontCareTransFile; 
       dontcareStats = new std::fstream(fname, std::fstream::out);
    }

    std::fstream & out = *dontcareStats;
    //out << "calling function klee_check_dontcare_trans_global(): \n";
    //out << " Finish forward analysis, total time=" 
                //<< (util::getWallTime() - dontCareStartTime) << "\n";  
    /////////start: hander reachable set from forward execution//////////////////       
    std::set<ref<Expr> > rs;
    if (globalMetadataSetMap.find(arguments[0]) != 
                                  globalMetadataSetMap.end())
       rs = globalMetadataSetMap[arguments[0]];
    ref<Expr> reachable = NULL;
    
    /*out << " Explore all state space, Time=" 
        << (util::getWallTime() - dontCareStartTime);*/
 
    for(auto v : rs) {
        std::string Str2;
  	    llvm::raw_string_ostream info2(Str2);
        ExprPPrinter::printSingleExpr(info2, v);
        out << "reachable set from rs: " << info2.str() << "\n";
       ref<Expr> eqexp = EqExpr::create(arguments[2], v);
       if (reachable.isNull())
          reachable = eqexp;
       else {
          ref<Expr> temp = reachable;
          reachable = OrExpr::create(temp, eqexp);
       }
    }  
    if (reachable.isNull())
        return;

    ref<Expr> notreachable = NotExpr::create(reachable); 
    //llvm::errs() << "Value of notreachable: " << notreachable << "\n"; 
    /////////end: hander reachable set from forward execution////////////////// 


    /////////start: hander first input variable//////////////////
    std::set<ref<Expr> > rsInput;
    if (globalInputSetMap.find(arguments[0]) != globalInputSetMap.end())
       rsInput = globalInputSetMap[arguments[0]];
    ref<Expr> reachableInput = NULL;//this var represents OR( EQ(inSec, inFirst_i) )
    for(auto v1 : rsInput) {
       //llvm::errs() << " reachable first input name " << v1 << "\n";
       ref<Expr> eqexpInput = EqExpr::create(arguments[4], v1);

       if (reachableInput.isNull())
          reachableInput = eqexpInput;
       else
          reachableInput = OrExpr::create(reachableInput, eqexpInput);
    }
    //llvm::errs() << "Width of reachableInput: " << reachableInput->getWidth() << "\n";
    //llvm::errs() << "Value of reachableInput: " << reachableInput << "\n";
    /////////end: hander first input variable//////////////////
    bool terminateSuccessDest = false;
    for(auto v1 : rs){
	      bool sourceMatches;
	      bool destMatches;
        ConstantExpr *consv1 = dyn_cast<ConstantExpr>(v1);

	      ref<Expr> v1eqexp1 = EqExpr::create(arguments[3], v1);
  	    ref<Expr> v1eqexp2 = EqExpr::create(arguments[3], arguments[1]);
	      ref<Expr> Andv1eqexp = AndExpr::create(v1eqexp1, v1eqexp2);
	      //executor.solver->setTimeout(executor.coreSolverTimeout);
     
   	    std::vector<ref<Expr>> vf;
        const std::vector<ref<Expr>> &vrDest = vf;
	      ExecutionState *fakeDest = new ExecutionState(vrDest);
        executor.solver->setTimeout(executor.coreSolverTimeout);
      
	      ref<ConstantExpr> sourceValue;
  	    ref<ConstantExpr> destValue;
	
        bool destSuccess = executor.solver->mayBeTrue(state, Andv1eqexp, destMatches);

	      if (destSuccess && destMatches){
            executor.solver->setTimeout(executor.coreSolverTimeout);
            ref<Expr> notreachableANDinputs = AndExpr::create(notreachable, reachableInput);
           
            //std::string Str1;
            //llvm::raw_string_ostream info1(Str1);
            //ExprPPrinter::printSingleExpr(info1, notreachableANDinputs);
            //out << "notreachableANDinputs: " << info1.str() << "\n";
              
            bool sourceSuccess = executor.solver->mayBeTrue(state, notreachableANDinputs, sourceMatches);
            if (sourceSuccess && sourceMatches && destSuccess &&destMatches) {
                terminateSuccessDest = true;
                out << " Found a don't care transition, Time=" 
                    << (util::getWallTime() - dontCareStartTime) << "\n";  	
                //llvm::errs() << " Found a don't care transition, " << " source: \n";
                //ExprPPrinter::printConstraints(llvm::errs(), state.constraints);
                //llvm::errs() << "destination " << Andv1eqexp << "\n";
                ExecutionState *fakeSource = new ExecutionState(state);
                fakeSource->addConstraint(notreachableANDinputs);
             
                //std::string Str;
                //llvm::raw_string_ostream info(Str);
                //ExprPPrinter::printConstraints(info, fakeSource->constraints);
                //out << "fakeSource: " << info.str() << "\n";
              
            /////////////////////////new added begin, try to find all possible source///////////////////////////
                std::pair<ref<Expr>, ref<Expr>> res = executor.solver->getRange(*fakeSource, arguments[2]);
                ConstantExpr *consfirst = dyn_cast<ConstantExpr>(res.first);
                ConstantExpr *conssecond = dyn_cast<ConstantExpr>(res.second);
                //llvm::errs() << "Return range of source in getRange: [" 
                             //<< consfirst->getZExtValue() << "," 
                             //<< conssecond->getZExtValue() << "]\n";
            /////////////////////////new added end, try to find all possible source///////////////////////////
                out << "Range of source state in : [" 
                    << consfirst->getZExtValue() << "," 
                    << conssecond->getZExtValue() << "]\n";
                //executor.solver->getValue(*fakeSource, arguments[2], sourceValue);
                //llvm::errs() << "Return value of sourceValue in getValue: " << sourceValue->getZExtValue() << "\n";

                fakeDest->addConstraint(Andv1eqexp);
                executor.solver->getValue(*fakeDest, arguments[3], destValue);
                //llvm::errs() << "Return value of destValue in getValue: " 
                             //<< destValue->getZExtValue() << "\n";
                out << "Destination state: " 
                    << destValue->getZExtValue() << "\n";
            }        
            else
                continue;
        	
	      }
        else
            continue;
  }
	/*std::vector<ref<Expr>> vf;
  const std::vector<ref<Expr>> &vrDest = vf;
	ExecutionState *fake = new ExecutionState(vrDest);    
  ref<ConstantExpr> destValueDebug;*/
    
  if ((terminateSuccessDest == false) && (TerminateNoDCTState==true)){
    executor.terminateState(state);
    //out << " Terminate state that don't have incoming DCT successfully! ";
    
    //executor.solver->getValue(*fake, arguments[1], destValueDebug);
    //out << "Which is state = : " << destValueDebug->getZExtValue() << "\n";
    return;
    }
  /*else{
    executor.solver->getValue(*fake, arguments[1], destValueDebug);
    out << "******************************\n";
    out << "State " << destValueDebug->getZExtValue() << " has an incoming DCT\n";
    out << "******************************\n";
  }*/
  dontCareFinishTime = util::getWallTime();
  //llvm::errs() << "\nFinish abstract analysis, total time (dontCareFinishTime): " << (dontCareFinishTime- dontCareStartTime) << "\n";
  out << "\nFinish abstract analysis, total time (dontCareFinishTime): " << (dontCareFinishTime- dontCareStartTime) << "\n";
}

////////////////////////////////For 2 input variables FSM//////////////////////////////////////////
void SpecialFunctionHandler::handleDontCareTransitionGloballyTwoInput(
                                    ExecutionState &state,
                                    KInstruction *target,
                                    std::vector<ref<Expr> > &arguments) {
    llvm::errs() << "Handle don't care transition, args: " << arguments[0] << " " << arguments[1] 
                 << " \n" << arguments[2] << "\n"<<arguments[3]<< "\n";
    StatsTracker * statsTracker = ((Executor*)theInterpreter)->getStatsTracker();
    if (dontcareStats == NULL) {
       std::string fname = "dontcarestats.txt";
       if (DontCareTransFile != "")
          fname = DontCareTransFile; 
       dontcareStats = new std::fstream(fname, std::fstream::out);
    }

    std::fstream & out = *dontcareStats;

    /////////start: hander reachable set from forward execution////////////////// 
    std::set<ref<Expr> > rs, rsConcrete;
    if (globalMetadataSetMap.find(arguments[0]) != 
                                  globalMetadataSetMap.end())
       rs = globalMetadataSetMap[arguments[0]];
       
    ref<Expr> reachable = NULL;

    for(auto v : rs) {
       llvm::errs() << "reachable set from rs: " << v << "\n";
        
       ref<Expr> eqexp = EqExpr::create(arguments[2], v);
       if (reachable.isNull())
          reachable = eqexp;
       else {
          ref<Expr> temp = reachable;
          reachable = OrExpr::create(temp, eqexp);
       }
    }  
    if (reachable.isNull()) {
         llvm::errs() << "Empty reachable!, return!!\n";
         return;
    }

    //ref<Expr> notreachable = NotExpr::create(dyn_cast<ConstantExpr>(reachable)); 
    ref<Expr> notreachable = NotExpr::create(reachable); 
    llvm::errs() << "Value of notreachable: " << notreachable << "\n"; 
    /////////end: hander reachable set from forward execution////////////////// 


    //////////////start: hander first input variable///////////////////////////
    	////////handle first input variable:
    std::set<ref<Expr> > rsInputFirst;
    if (globalInputSetMap.find(arguments[0]) != globalInputSetMap.end())
       rsInputFirst = globalInputSetMap[arguments[0]];
    ref<Expr> reachableInputFirst = NULL;//this var represents OR( EQ(inSec, inFirst_i) )
    for(auto v1 : rsInputFirst) {
       llvm::errs() << " reachable first input name " << v1 << "\n";
       ref<Expr> eqexpInputFirst = EqExpr::create(arguments[4], v1);

       if (reachableInputFirst.isNull())
          reachableInputFirst = eqexpInputFirst;
       else
          reachableInputFirst = OrExpr::create(reachableInputFirst, eqexpInputFirst);
    }
   	////////handle second input variable:
    std::set<ref<Expr> > rsInputSecond;
    if (globalTwoInputSetMap.find(arguments[0]) != globalTwoInputSetMap.end())
       rsInputSecond = globalTwoInputSetMap[arguments[0]];
    ref<Expr> reachableInputSecond = NULL;
    for(auto v1 : rsInputSecond) {
       llvm::errs() << " reachable Second input name " << v1 << "\n";
       ref<Expr> eqexpInputSecond = EqExpr::create(arguments[5], v1);

       if (reachableInputSecond.isNull())
          reachableInputSecond = eqexpInputSecond;
       else
          reachableInputSecond = OrExpr::create(reachableInputSecond, eqexpInputSecond);
    }
   	////////And two input variables:
    ref<Expr> reachableInput = AndExpr::create(reachableInputFirst, reachableInputSecond);

    llvm::errs() << "Width of reachableInput: " << reachableInput->getWidth() << "\n";
    llvm::errs() << "Value of reachableInput: " << reachableInput << "\n";
    /////////end: hander first input variable//////////////////

    bool terminateSuccessDest = false;
    
    for(auto v1 : rs){
	bool sourceMatches;
	bool destMatches;
        ConstantExpr *consv1 = dyn_cast<ConstantExpr>(v1);

	ref<Expr> v1eqexp1 = EqExpr::create(arguments[3], v1);
	ref<Expr> v1eqexp2 = EqExpr::create(arguments[3], arguments[1]);
	ref<Expr> Andv1eqexp = AndExpr::create(v1eqexp1, v1eqexp2);
	executor.solver->setTimeout(executor.coreSolverTimeout);
   	std::vector<ref<Expr>> vf;
    	const std::vector<ref<Expr>> &vrDest = vf;
	ExecutionState *fakeDest = new ExecutionState(vrDest);

	ref<ConstantExpr> sourceValue;
	ref<ConstantExpr> destValue;
	
	bool destSuccess = executor.solver->mayBeTrue(*fakeDest, Andv1eqexp, destMatches);

	if (destSuccess && destMatches){
           executor.solver->setTimeout(executor.coreSolverTimeout);
           ref<Expr> notreachableANDinputs = AndExpr::create(notreachable, reachableInput);
              std::string Str1;
  	          llvm::raw_string_ostream info1(Str1);
              ExprPPrinter::printSingleExpr(info1, notreachableANDinputs);
              out << "notreachableANDinputs: " << info1.str() << "\n";
           bool sourceSuccess = executor.solver->mayBeTrue(state, notreachableANDinputs, sourceMatches);
	   if (sourceSuccess && sourceMatches && destSuccess &&destMatches) {       
       terminateSuccessDest = true;
       
              out << " Found a don't care transition, Time=" 
                  << (util::getWallTime() - dontCareStartTime) << "\n";  	
	      llvm::errs() << " Found a don't care transition, " << " source: \n";
	      ExprPPrinter::printConstraints(llvm::errs(), state.constraints);
	      llvm::errs() << "destination " << Andv1eqexp << "\n";
	      ExecutionState *fakeSource = new ExecutionState(state);
	      fakeSource->addConstraint(notreachableANDinputs);
              std::string Str;
  	          llvm::raw_string_ostream info(Str);
              ExprPPrinter::printConstraints(info, fakeSource->constraints);
              out << "fakeSource: " << info.str() << "\n";
	      /////////////////////////new added begin, try to find all possible source///////////////////////////
	      std::pair<ref<Expr>, ref<Expr>> res = executor.solver->getRange(*fakeSource, arguments[2]);
	      ConstantExpr *consfirst = dyn_cast<ConstantExpr>(res.first);
	      ConstantExpr *conssecond = dyn_cast<ConstantExpr>(res.second);
	      llvm::errs() << "Return range of source in getRange: [" 
                           << consfirst->getZExtValue() << "," 
                           << conssecond->getZExtValue() << "]\n";
	      /////////////////////////new added end, try to find all possible source///////////////////////////
              out << "Range of source state in : [" 
                  << consfirst->getZExtValue() << "," 
                  << conssecond->getZExtValue() << "]\n";
	      //executor.solver->getValue(*fakeSource, arguments[2], sourceValue);
	      //llvm::errs() << "Return value of sourceValue in getValue: " << sourceValue->getZExtValue() << "\n";

	      fakeDest->addConstraint(Andv1eqexp);
	      executor.solver->getValue(*fakeDest, arguments[3], destValue);
	      llvm::errs() << "Return value of destValue in getValue: " 
                           << destValue->getZExtValue() << "\n";
              out << "Destination state: " 
                  << destValue->getZExtValue() << "\n";
	   }	
	}
    }
	std::vector<ref<Expr>> vf;
  const std::vector<ref<Expr>> &vrDest = vf;
	ExecutionState *fake = new ExecutionState(vrDest);    
  ref<ConstantExpr> destValueDebug;
    
  if ((terminateSuccessDest == false) && (TerminateNoDCTState==true)){
    executor.terminateState(state);
    out << " Terminate state that don't have incoming DCT successfully! ";
    
    executor.solver->getValue(*fake, arguments[1], destValueDebug);
    out << "Which is state = : " << destValueDebug->getZExtValue() << "\n";
    return;
    }
  else{
    executor.solver->getValue(*fake, arguments[1], destValueDebug);
    out << "******************************\n";
    out << "State " << destValueDebug->getZExtValue() << " has an incoming DCT\n";
    out << "******************************\n";
  }
  dontCareFinishTime = util::getWallTime();
  //llvm::errs() << "\nFinish abstract analysis, total time (dontCareFinishTime): " << (dontCareFinishTime- dontCareStartTime) << "\n";
  out << "\nFinish abstract analysis, total time (dontCareFinishTime): " << (dontCareFinishTime- dontCareStartTime) << "\n";
}

////////////////////////////////For 3 input variables FSM//////////////////////////////////////////
void SpecialFunctionHandler::handleDontCareTransitionGloballyThreeInput(
                                    ExecutionState &state,
                                    KInstruction *target,
                                    std::vector<ref<Expr> > &arguments) {
    //llvm::errs() << "Handle don't care transition, args: " << arguments[0] << " " << arguments[1] 
                 //<< " \n" << arguments[2] << "\n"<<arguments[3]<< "\n";
    StatsTracker * statsTracker = ((Executor*)theInterpreter)->getStatsTracker();
    if (dontcareStats == NULL) {
       std::string fname = "dontcarestats.txt";
       if (DontCareTransFile != "")
          fname = DontCareTransFile; 
       dontcareStats = new std::fstream(fname, std::fstream::out);
    }

    std::fstream & out = *dontcareStats;

    /////////start: hander reachable set from forward execution//////////////////       
    std::set<ref<Expr> > rs, rsConcrete;
    if (globalMetadataSetMap.find(arguments[0]) != 
                                  globalMetadataSetMap.end())
       rs = globalMetadataSetMap[arguments[0]];
    ref<Expr> reachable = NULL;

    for(auto v : rs) {
	      //std::string Str3;
	      //llvm::raw_string_ostream info3(Str3);
      	//ExprPPrinter::printSingleExpr(info3, v);
      	//out << "reachable state: " << info3.str() << "\n";
       
       //llvm::errs() << " reachable value " << v << "\n";
       ref<Expr> eqexp = EqExpr::create(arguments[2], v);
       if (reachable.isNull())
          reachable = eqexp;
       else {
          ref<Expr> temp = reachable;
          reachable = OrExpr::create(temp, eqexp);
       }
    }  
    if (reachable.isNull())
       return; 

    ref<Expr> notreachable = NotExpr::create(reachable); 
    //llvm::errs() << "Value of notreachable: " << notreachable << "\n"; 
    /////////end: hander reachable set from forward execution////////////////// 


    //////////////start: hander first input variable///////////////////////////
    	////////handle first input variable:
    std::set<ref<Expr> > rsInputFirst;
    if (globalInputSetMap.find(arguments[0]) != globalInputSetMap.end())
       rsInputFirst = globalInputSetMap[arguments[0]];
    ref<Expr> reachableInputFirst = NULL;//this var represents OR( EQ(inSec, inFirst_i) )
    for(auto v1 : rsInputFirst) {
       //llvm::errs() << " reachable first input name " << v1 << "\n";
       ref<Expr> eqexpInputFirst = EqExpr::create(arguments[4], v1);

       if (reachableInputFirst.isNull())
          reachableInputFirst = eqexpInputFirst;
       else
          reachableInputFirst = OrExpr::create(reachableInputFirst, eqexpInputFirst);
    }
   	////////handle second input variable:
    std::set<ref<Expr> > rsInputSecond;
    if (globalTwoInputSetMap.find(arguments[0]) != globalTwoInputSetMap.end())
       rsInputSecond = globalTwoInputSetMap[arguments[0]];
    ref<Expr> reachableInputSecond = NULL;
    for(auto v1 : rsInputSecond) {
       //llvm::errs() << " reachable Second input name " << v1 << "\n";
       ref<Expr> eqexpInputSecond = EqExpr::create(arguments[5], v1);

       if (reachableInputSecond.isNull())
          reachableInputSecond = eqexpInputSecond;
       else
          reachableInputSecond = OrExpr::create(reachableInputSecond, eqexpInputSecond);
    }
   	////////handle third input variable:
    std::set<ref<Expr> > rsInputThird;
    if (globalThreeInputSetMap.find(arguments[0]) != globalThreeInputSetMap.end())
       rsInputThird = globalThreeInputSetMap[arguments[0]];

    ref<Expr> reachableInputThird = NULL;
    for(auto v1 : rsInputThird) {
       //llvm::errs() << " reachable Third input name " << v1 << "\n";
       ref<Expr> eqexpInputThird = EqExpr::create(arguments[6], v1);

       if (reachableInputThird.isNull())
          reachableInputThird = eqexpInputThird;
       else
          reachableInputThird = OrExpr::create(reachableInputThird, eqexpInputThird);
    }
   	
    

    ref<Expr> reachableInputFirstSecond = AndExpr::create(reachableInputFirst, reachableInputSecond);//And first with second input variables	
 
    ref<Expr> reachableInput = AndExpr::create(reachableInputFirstSecond, reachableInputThird);//And FirstSecond with Third input variables

    //llvm::errs() << "Width of reachableInput: " << reachableInput->getWidth() << "\n";
    //llvm::errs() << "Value of reachableInput: " << reachableInput << "\n";
    /////////end: hander first input variable//////////////////
    bool terminateSuccessDest = false;
    for(auto v1 : rs){
	    bool sourceMatches;
	    bool destMatches;
	    ConstantExpr *consv1 = dyn_cast<ConstantExpr>(v1);

	    ref<Expr> v1eqexp1 = EqExpr::create(arguments[3], v1);
	    ref<Expr> v1eqexp2 = EqExpr::create(arguments[3], arguments[1]);
	    ref<Expr> Andv1eqexp = AndExpr::create(v1eqexp1, v1eqexp2);
         
	    std::vector<ref<Expr>> vf;
    	const std::vector<ref<Expr>> &vrDest = vf;
	    ExecutionState *fakeDest = new ExecutionState(vrDest);
	    executor.solver->setTimeout(executor.coreSolverTimeout);
      
      ref<ConstantExpr> sourceValue;
	    ref<ConstantExpr> destValue;
	
	    bool destSuccess = executor.solver->mayBeTrue(*fakeDest, Andv1eqexp, destMatches);

	    if (destSuccess && destMatches){
          executor.solver->setTimeout(executor.coreSolverTimeout);
          ref<Expr> notreachableANDinputs = AndExpr::create(notreachable, reachableInput);
           
          //std::string Str1;
			    //llvm::raw_string_ostream info1(Str1);
          //ExprPPrinter::printSingleExpr(info1, notreachableANDinputs);
          //out << "notreachableANDinputs: " << info1.str() << "\n";
              
          bool sourceSuccess = executor.solver->mayBeTrue(state, notreachableANDinputs, sourceMatches);
          if (sourceSuccess && sourceMatches && destSuccess &&destMatches) {
              terminateSuccessDest = true;
              out << " Found a don't care transition, Time=" 
                  << (util::getWallTime() - dontCareStartTime) << "\n";  	
              //llvm::errs() << " Found a don't care transition, " << " source: \n";
              //ExprPPrinter::printConstraints(llvm::errs(), state.constraints);
              //llvm::errs() << "destination " << Andv1eqexp << "\n";
              ExecutionState *fakeSource = new ExecutionState(state);              
              fakeSource->addConstraint(notreachableANDinputs);
       
              //std::string Str;
              //llvm::raw_string_ostream info(Str);
              //ExprPPrinter::printConstraints(info, fakeSource->constraints);
              //out << "fakeSource: " << info.str() << "\n";
        
              /////////////////////////new added begin, try to find all possible source///////////////////////////
              std::pair<ref<Expr>, ref<Expr>> res = executor.solver->getRange(*fakeSource, arguments[2]);
              ConstantExpr *consfirst = dyn_cast<ConstantExpr>(res.first);
              ConstantExpr *conssecond = dyn_cast<ConstantExpr>(res.second);
              //llvm::errs() << "Return range of source in getRange: [" 
                           //<< consfirst->getZExtValue() << "," 
                           //<< conssecond->getZExtValue() << "]\n";
              /////////////////////////new added end, try to find all possible source///////////////////////////
              out << "Range of source state in : [" 
                  << consfirst->getZExtValue() << "," 
                  << conssecond->getZExtValue() << "]\n";

              fakeDest->addConstraint(Andv1eqexp);
              executor.solver->getValue(*fakeDest, arguments[1], destValue);
              //llvm::errs() << "Return value of destValue in getValue: " 
                          // << destValue->getZExtValue() << "\n";
              out << "Destination state: " 
                  << destValue->getZExtValue() << "\n";
          }
          
          else
              continue;	
	    }
         
      else
          continue;
         
  }

	//std::vector<ref<Expr>> vf;
  //const std::vector<ref<Expr>> &vrDest = vf;
	//ExecutionState *fake = new ExecutionState(vrDest);    
  //ref<ConstantExpr> destValueDebug;
    
  if ((terminateSuccessDest == false) && (TerminateNoDCTState==true)){
    executor.terminateState(state);
    //out << " Terminate state that don't have incoming DCT successfully! ";
    //executor.solver->getValue(*fake, arguments[1], destValueDebug);
    //out << "Which is state = : " << destValueDebug->getZExtValue() << "\n";
    return;
    }
  //else{
    //executor.solver->getValue(*fake, arguments[1], destValueDebug);
    //out << "******************************\n";
    //out << "State " << destValueDebug->getZExtValue() << " has an incoming DCT\n";
    //out << "******************************\n";
  //}

  dontCareFinishTime = util::getWallTime();
  llvm::errs() << "\nFinish abstract analysis, total time (dontCareFinishTime): " << (dontCareFinishTime- dontCareStartTime) << "\n";
  out << "\nFinish abstract analysis, total time (dontCareFinishTime): " << (dontCareFinishTime- dontCareStartTime) << "\n";
  
}

////////////////////////////////For 4 input variables FSM//////////////////////////////////////////
void SpecialFunctionHandler::handleDontCareTransitionGloballyFourInput(
                                    ExecutionState &state,
                                    KInstruction *target,
                                    std::vector<ref<Expr> > &arguments) {
    llvm::errs() << "Handle don't care transition, args: " << arguments[0] << " " << arguments[1] 
                 << " \n" << arguments[2] << "\n"<<arguments[3]<< "\n";
    StatsTracker * statsTracker = ((Executor*)theInterpreter)->getStatsTracker();
    if (dontcareStats == NULL) {
       std::string fname = "dontcarestats.txt";
       if (DontCareTransFile != "")
          fname = DontCareTransFile; 
       dontcareStats = new std::fstream(fname, std::fstream::out);
    }

    std::fstream & out = *dontcareStats;

    /////////start: hander reachable set from forward execution//////////////////       
    std::set<ref<Expr> > rs, rsConcrete;
    if (globalMetadataSetMap.find(arguments[0]) != 
                                  globalMetadataSetMap.end())
       rs = globalMetadataSetMap[arguments[0]];
    ref<Expr> reachable = NULL;

	////Begin: Convert symbolic rs to concrete rs////
    /*for(auto v: rs){
       std::pair<ref<Expr>, ref<Expr>> rsSymbolic = executor.solver->getRange(state, v);
       ref<Expr> rsSymbolicFirst = rsSymbolic.first;
       auto rsSymbolicFirstConstant = dyn_cast<ConstantExpr>(rsSymbolicFirst);
       uint64_t rsSymbolicFirstUint = rsSymbolicFirstConstant->getZExtValue();
       ref<Expr> rsSymbolicSecond = rsSymbolic.second;
       auto rsSymbolicSecondConstant = dyn_cast<ConstantExpr>(rsSymbolicSecond);
       uint64_t rsSymbolicSecondUint = rsSymbolicSecondConstant->getZExtValue();
       for(auto v1 = rsSymbolicFirstUint; v1 <= rsSymbolicSecondUint; v1++){
		auto v2 = v1;
		rsConcrete.insert(ConstantExpr::create(v2, arguments[2]->getWidth()));
       }
	
    }*/
	////End: Convert symbolic rs to concrete rs////

    for(auto v : rs) {
       //llvm::errs() << " reachable value " << v << "\n";
       std::string Str2;
  	    llvm::raw_string_ostream info2(Str2);
        ExprPPrinter::printSingleExpr(info2, v);
        out << "reachable set from rs: " << info2.str() << "\n";
        
       ref<Expr> eqexp = EqExpr::create(arguments[2], v);
       if (reachable.isNull())
          reachable = eqexp;
       else {
          ref<Expr> temp = reachable;
          reachable = OrExpr::create(temp, eqexp);
       }
    }  
    if (!reachable.isNull())
       llvm::errs() << "reachable set: " << reachable << "\n"; 

    ref<Expr> notreachable = NotExpr::create(reachable); 
    llvm::errs() << "Value of notreachable: " << notreachable << "\n"; 
    /////////end: hander reachable set from forward execution////////////////// 


    //////////////start: hander first input variable///////////////////////////
    	////////handle first input variable:
    std::set<ref<Expr> > rsInputFirst;
    if (globalInputSetMap.find(arguments[0]) != globalInputSetMap.end())
       rsInputFirst = globalInputSetMap[arguments[0]];
    ref<Expr> reachableInputFirst = NULL;//this var represents OR( EQ(inSec, inFirst_i) )
    for(auto v1 : rsInputFirst) {
       llvm::errs() << " reachable first input name " << v1 << "\n";
       ref<Expr> eqexpInputFirst = EqExpr::create(arguments[4], v1);

       if (reachableInputFirst.isNull())
          reachableInputFirst = eqexpInputFirst;
       else
          reachableInputFirst = OrExpr::create(reachableInputFirst, eqexpInputFirst);
    }
   	////////handle second input variable:
    std::set<ref<Expr> > rsInputSecond;
    if (globalTwoInputSetMap.find(arguments[0]) != globalTwoInputSetMap.end())
       rsInputSecond = globalTwoInputSetMap[arguments[0]];
    ref<Expr> reachableInputSecond = NULL;
    for(auto v1 : rsInputSecond) {
       llvm::errs() << " reachable Second input name " << v1 << "\n";
       ref<Expr> eqexpInputSecond = EqExpr::create(arguments[5], v1);

       if (reachableInputSecond.isNull())
          reachableInputSecond = eqexpInputSecond;
       else
          reachableInputSecond = OrExpr::create(reachableInputSecond, eqexpInputSecond);
    }
   	////////handle third input variable:
    std::set<ref<Expr> > rsInputThird;
    if (globalThreeInputSetMap.find(arguments[0]) != globalThreeInputSetMap.end())
       rsInputThird = globalThreeInputSetMap[arguments[0]];

    ref<Expr> reachableInputThird = NULL;
    for(auto v1 : rsInputThird) {
       llvm::errs() << " reachable Third input name " << v1 << "\n";
       ref<Expr> eqexpInputThird = EqExpr::create(arguments[6], v1);

       if (reachableInputThird.isNull())
          reachableInputThird = eqexpInputThird;
       else
          reachableInputThird = OrExpr::create(reachableInputThird, eqexpInputThird);
    }
   	////////handle fourth input variable:
    std::set<ref<Expr> > rsInputFourth;
    if (globalFourInputSetMap.find(arguments[0]) != globalFourInputSetMap.end())
       rsInputFourth = globalFourInputSetMap[arguments[0]];

    ref<Expr> reachableInputFourth = NULL;
    for(auto v1 : rsInputFourth) {
       llvm::errs() << " reachable Fourth input name " << v1 << "\n";
       ref<Expr> eqexpInputFourth = EqExpr::create(arguments[7], v1);

       if (reachableInputFourth.isNull())
          reachableInputFourth = eqexpInputFourth;
       else
          reachableInputFourth = OrExpr::create(reachableInputFourth, eqexpInputFourth);
    }

    ref<Expr> reachableInputFirstSecond = AndExpr::create(reachableInputFirst, reachableInputSecond);//And first with second input variables	
    ref<Expr> reachableInputThirdFourth = AndExpr::create(reachableInputFourth, reachableInputThird);//And third with fourth input variables
 
    ref<Expr> reachableInput = AndExpr::create(reachableInputFirstSecond, reachableInputThirdFourth);//And FirstSecond with ThirdFourth

    llvm::errs() << "Width of reachableInput: " << reachableInput->getWidth() << "\n";
    llvm::errs() << "Value of reachableInput: " << reachableInput << "\n";
    /////////end: hander first input variable//////////////////
    bool terminateSuccessDest = false;
    for(auto v1 : rs){
	    bool sourceMatches;
	    bool destMatches;
      ConstantExpr *consv1 = dyn_cast<ConstantExpr>(v1);

	    ref<Expr> v1eqexp1 = EqExpr::create(arguments[3], v1);
	    ref<Expr> v1eqexp2 = EqExpr::create(arguments[3], arguments[1]);
	    ref<Expr> Andv1eqexp = AndExpr::create(v1eqexp1, v1eqexp2);
	    executor.solver->setTimeout(executor.coreSolverTimeout);
      std::vector<ref<Expr>> vf;
    	const std::vector<ref<Expr>> &vrDest = vf;
	    ExecutionState *fakeDest = new ExecutionState(vrDest);

	ref<ConstantExpr> sourceValue;
	ref<ConstantExpr> destValue;
	
	bool destSuccess = executor.solver->mayBeTrue(*fakeDest, Andv1eqexp, destMatches);

	if (destSuccess && destMatches){
           executor.solver->setTimeout(executor.coreSolverTimeout);
           ref<Expr> notreachableANDinputs = AndExpr::create(notreachable, reachableInput);
           
           std::string Str1;
			     llvm::raw_string_ostream info1(Str1);
           ExprPPrinter::printSingleExpr(info1, notreachableANDinputs);
           out << "notreachableANDinputs: " << info1.str() << "\n";
              
           bool sourceSuccess = executor.solver->mayBeTrue(state, notreachableANDinputs, sourceMatches);
	   if (sourceSuccess && sourceMatches && destSuccess &&destMatches) {
        terminateSuccessDest = true;
              out << " Found a don't care transition, Time=" 
                  << (util::getWallTime() - dontCareStartTime) << "\n";  	
	      llvm::errs() << " Found a don't care transition, " << " source: \n";
	      ExprPPrinter::printConstraints(llvm::errs(), state.constraints);
	      llvm::errs() << "destination " << Andv1eqexp << "\n";
	      ExecutionState *fakeSource = new ExecutionState(state);
	      fakeSource->addConstraint(notreachableANDinputs);
       
        std::string Str;
  	    llvm::raw_string_ostream info(Str);
        ExprPPrinter::printConstraints(info, fakeSource->constraints);
        out << "fakeSource: " << info.str() << "\n";
              
	      /////////////////////////new added begin, try to find all possible source///////////////////////////
	      std::pair<ref<Expr>, ref<Expr>> res = executor.solver->getRange(*fakeSource, arguments[2]);
	      ConstantExpr *consfirst = dyn_cast<ConstantExpr>(res.first);
	      ConstantExpr *conssecond = dyn_cast<ConstantExpr>(res.second);
	      llvm::errs() << "Return range of source in getRange: [" 
                           << consfirst->getZExtValue() << "," 
                           << conssecond->getZExtValue() << "]\n";
	      /////////////////////////new added end, try to find all possible source///////////////////////////
              out << "Range of source state in : [" 
                  << consfirst->getZExtValue() << "," 
                  << conssecond->getZExtValue() << "]\n";
	      //executor.solver->getValue(*fakeSource, arguments[2], sourceValue);
	      //llvm::errs() << "Return value of sourceValue in getValue: " << sourceValue->getZExtValue() << "\n";

	      fakeDest->addConstraint(Andv1eqexp);
	      executor.solver->getValue(*fakeDest, arguments[3], destValue);
	      llvm::errs() << "Return value of destValue in getValue: " 
                           << destValue->getZExtValue() << "\n";
              out << "Destination state: " 
                  << destValue->getZExtValue() << "\n";
	   }	
	  }
   }
  if (terminateSuccessDest == false){
    executor.terminateState(state);
    out << " Terminate state that don't have incoming DCT successfully! ";
    
    ref<ConstantExpr> destValueDebug;
   
    ExecutionState *fake = new ExecutionState(state);
    executor.solver->setTimeout(executor.coreSolverTimeout);
    //fake->addConstraint(Andv1eqexp);
    executor.solver->getValue(*fake, arguments[1], destValueDebug);
    out << "Which is state = : " << destValueDebug->getZExtValue() << "\n";
    return;
    }
}


////////////////////////////////For 5 input variables FSM//////////////////////////////////////////
void SpecialFunctionHandler::handleDontCareTransitionGloballyFiveInput(
                                    ExecutionState &state,
                                    KInstruction *target,
                                    std::vector<ref<Expr> > &arguments) {
    llvm::errs() << "Handle don't care transition, args: " << arguments[0] << " " << arguments[1] 
                 << " \n" << arguments[2] << "\n"<<arguments[3]<< "\n";
    StatsTracker * statsTracker = ((Executor*)theInterpreter)->getStatsTracker();
    if (dontcareStats == NULL) {
       std::string fname = "dontcarestats.txt";
       if (DontCareTransFile != "")
          fname = DontCareTransFile; 
       dontcareStats = new std::fstream(fname, std::fstream::out);
    }

    std::fstream & out = *dontcareStats;

    /////////start: hander reachable set from forward execution//////////////////       
    std::set<ref<Expr> > rs, rsConcrete;
    if (globalMetadataSetMap.find(arguments[0]) != 
                                  globalMetadataSetMap.end())
       rs = globalMetadataSetMap[arguments[0]];
    ref<Expr> reachable = NULL;

	////Begin: Convert symbolic rs to concrete rs////
    /*for(auto v: rs){
       std::pair<ref<Expr>, ref<Expr>> rsSymbolic = executor.solver->getRange(state, v);
       ref<Expr> rsSymbolicFirst = rsSymbolic.first;
       auto rsSymbolicFirstConstant = dyn_cast<ConstantExpr>(rsSymbolicFirst);
       uint64_t rsSymbolicFirstUint = rsSymbolicFirstConstant->getZExtValue();
       ref<Expr> rsSymbolicSecond = rsSymbolic.second;
       auto rsSymbolicSecondConstant = dyn_cast<ConstantExpr>(rsSymbolicSecond);
       uint64_t rsSymbolicSecondUint = rsSymbolicSecondConstant->getZExtValue();
       for(auto v1 = rsSymbolicFirstUint; v1 <= rsSymbolicSecondUint; v1++){
		auto v2 = v1;
		rsConcrete.insert(ConstantExpr::create(v2, arguments[2]->getWidth()));
       }
	
    }*/
	////End: Convert symbolic rs to concrete rs////

    for(auto v : rs) {
       //llvm::errs() << " reachable value " << v << "\n";
        std::string Str2;
  	llvm::raw_string_ostream info2(Str2);
        ExprPPrinter::printSingleExpr(info2, v);
        out << "reachable set from rs: " << info2.str() << "\n";
        
       ref<Expr> eqexp = EqExpr::create(arguments[2], v);
       if (reachable.isNull())
          reachable = eqexp;
       else {
          ref<Expr> temp = reachable;
          reachable = OrExpr::create(temp, eqexp);
       }
    }  
    if (!reachable.isNull())
       llvm::errs() << "reachable set: " << reachable << "\n"; 

    ref<Expr> notreachable = NotExpr::create(reachable); 
    llvm::errs() << "Value of notreachable: " << notreachable << "\n"; 
    /////////end: hander reachable set from forward execution////////////////// 


    //////////////start: hander first input variable///////////////////////////
    	////////handle first input variable:
    std::set<ref<Expr> > rsInputFirst;
    if (globalInputSetMap.find(arguments[0]) != globalInputSetMap.end())
       rsInputFirst = globalInputSetMap[arguments[0]];
    ref<Expr> reachableInputFirst = NULL;//this var represents OR( EQ(inSec, inFirst_i) )
    for(auto v1 : rsInputFirst) {
       llvm::errs() << " reachable first input name " << v1 << "\n";
       ref<Expr> eqexpInputFirst = EqExpr::create(arguments[4], v1);

       if (reachableInputFirst.isNull())
          reachableInputFirst = eqexpInputFirst;
       else
          reachableInputFirst = OrExpr::create(reachableInputFirst, eqexpInputFirst);
    }
   	////////handle second input variable:
    std::set<ref<Expr> > rsInputSecond;
    if (globalTwoInputSetMap.find(arguments[0]) != globalTwoInputSetMap.end())
       rsInputSecond = globalTwoInputSetMap[arguments[0]];
    ref<Expr> reachableInputSecond = NULL;
    for(auto v1 : rsInputSecond) {
       llvm::errs() << " reachable Second input name " << v1 << "\n";
       ref<Expr> eqexpInputSecond = EqExpr::create(arguments[5], v1);

       if (reachableInputSecond.isNull())
          reachableInputSecond = eqexpInputSecond;
       else
          reachableInputSecond = OrExpr::create(reachableInputSecond, eqexpInputSecond);
    }
   	////////handle third input variable:
    std::set<ref<Expr> > rsInputThird;
    if (globalThreeInputSetMap.find(arguments[0]) != globalThreeInputSetMap.end())
       rsInputThird = globalThreeInputSetMap[arguments[0]];

    ref<Expr> reachableInputThird = NULL;
    for(auto v1 : rsInputThird) {
       llvm::errs() << " reachable Third input name " << v1 << "\n";
       ref<Expr> eqexpInputThird = EqExpr::create(arguments[6], v1);

       if (reachableInputThird.isNull())
          reachableInputThird = eqexpInputThird;
       else
          reachableInputThird = OrExpr::create(reachableInputThird, eqexpInputThird);
    }
   	////////handle fourth input variable:
    std::set<ref<Expr> > rsInputFourth;
    if (globalFourInputSetMap.find(arguments[0]) != globalFourInputSetMap.end())
       rsInputFourth = globalFourInputSetMap[arguments[0]];

    ref<Expr> reachableInputFourth = NULL;
    for(auto v1 : rsInputFourth) {
       llvm::errs() << " reachable Fourth input name " << v1 << "\n";
       ref<Expr> eqexpInputFourth = EqExpr::create(arguments[7], v1);

       if (reachableInputFourth.isNull())
          reachableInputFourth = eqexpInputFourth;
       else
          reachableInputFourth = OrExpr::create(reachableInputFourth, eqexpInputFourth);
    }

   	////////handle fifth input variable:
    std::set<ref<Expr> > rsInputFifth;
    if (globalFiveInputSetMap.find(arguments[0]) != globalFiveInputSetMap.end())
       rsInputFifth = globalFiveInputSetMap[arguments[0]];

    ref<Expr> reachableInputFifth = NULL;
    for(auto v1 : rsInputFifth) {
       llvm::errs() << " reachable Fourth input name " << v1 << "\n";
       ref<Expr> eqexpInputFourth = EqExpr::create(arguments[8], v1);

       if (reachableInputFifth.isNull())
          reachableInputFifth = eqexpInputFourth;
       else
          reachableInputFifth = OrExpr::create(reachableInputFifth, eqexpInputFourth);
    }

    ref<Expr> reachableInputFirstSecond = AndExpr::create(reachableInputFirst, reachableInputSecond);//And first with second input variables	
    ref<Expr> reachableInputThirdFourth = AndExpr::create(reachableInputFourth, reachableInputThird);//And third with fourth input variables
 
    ref<Expr> reachableInputOneToFour = AndExpr::create(reachableInputFirstSecond, reachableInputThirdFourth);//And FirstSecond with ThirdFourth
    ref<Expr> reachableInput = AndExpr::create(reachableInputOneToFour, reachableInputFifth);//And all expr

    llvm::errs() << "Width of reachableInput: " << reachableInput->getWidth() << "\n";
    llvm::errs() << "Value of reachableInput: " << reachableInput << "\n";
    /////////end: hander first input variable//////////////////

    for(auto v1 : rs){
	bool sourceMatches;
	bool destMatches;
        ConstantExpr *consv1 = dyn_cast<ConstantExpr>(v1);

	ref<Expr> v1eqexp1 = EqExpr::create(arguments[3], v1);
	ref<Expr> v1eqexp2 = EqExpr::create(arguments[3], arguments[1]);
	ref<Expr> Andv1eqexp = AndExpr::create(v1eqexp1, v1eqexp2);
	executor.solver->setTimeout(executor.coreSolverTimeout);
   	std::vector<ref<Expr>> vf;
    	const std::vector<ref<Expr>> &vrDest = vf;
	ExecutionState *fakeDest = new ExecutionState(vrDest);

	ref<ConstantExpr> sourceValue;
	ref<ConstantExpr> destValue;
	
	bool destSuccess = executor.solver->mayBeTrue(*fakeDest, Andv1eqexp, destMatches);

	if (destSuccess && destMatches){
           executor.solver->setTimeout(executor.coreSolverTimeout);
           ref<Expr> notreachableANDinputs = AndExpr::create(notreachable, reachableInput);
           
           std::string Str1;
	   llvm::raw_string_ostream info1(Str1);
           ExprPPrinter::printSingleExpr(info1, notreachableANDinputs);
           out << "notreachableANDinputs: " << info1.str() << "\n";
              
           bool sourceSuccess = executor.solver->mayBeTrue(state, notreachableANDinputs, sourceMatches);
	   if (sourceSuccess && sourceMatches && destSuccess &&destMatches) {
              out << " Found a don't care transition, Time=" 
                  << (util::getWallTime() - dontCareStartTime) << "\n";  	
	      llvm::errs() << " Found a don't care transition, " << " source: \n";
	      ExprPPrinter::printConstraints(llvm::errs(), state.constraints);
	      llvm::errs() << "destination " << Andv1eqexp << "\n";
	      ExecutionState *fakeSource = new ExecutionState(state);
	      fakeSource->addConstraint(notreachableANDinputs);
       
        std::string Str;
  	    llvm::raw_string_ostream info(Str);
        ExprPPrinter::printConstraints(info, fakeSource->constraints);
        out << "fakeSource: " << info.str() << "\n";
              
	      /////////////////////////new added begin, try to find all possible source///////////////////////////
	      std::pair<ref<Expr>, ref<Expr>> res = executor.solver->getRange(*fakeSource, arguments[2]);
	      ConstantExpr *consfirst = dyn_cast<ConstantExpr>(res.first);
	      ConstantExpr *conssecond = dyn_cast<ConstantExpr>(res.second);
	      llvm::errs() << "Return range of source in getRange: [" 
                           << consfirst->getZExtValue() << "," 
                           << conssecond->getZExtValue() << "]\n";
	      /////////////////////////new added end, try to find all possible source///////////////////////////
              out << "Range of source state in : [" 
                  << consfirst->getZExtValue() << "," 
                  << conssecond->getZExtValue() << "]\n";
	      //executor.solver->getValue(*fakeSource, arguments[2], sourceValue);
	      //llvm::errs() << "Return value of sourceValue in getValue: " << sourceValue->getZExtValue() << "\n";

	      fakeDest->addConstraint(Andv1eqexp);
	      executor.solver->getValue(*fakeDest, arguments[3], destValue);
	      llvm::errs() << "Return value of destValue in getValue: " 
                           << destValue->getZExtValue() << "\n";
              out << "Destination state: " 
                  << destValue->getZExtValue() << "\n";
	   }	
	}
    }
}

// Example usage:
// Let K denote the number of iterations, >= DIAMETER of the FSM
// Configure the FSM properly and call top->eval to find RS
// After each iteration add the reached values in S:
// klee_add_metadata_globally(&S, top->state);
// let's assume S collects the concrete FMS states (precise RS)
// Now compute the approximate set of reachable states 
// (note RS^+ is not stored as for each reached value 
// the diff with S is performed)
// top->state = sym_value  
// top->eval();
// klee_find_tuple_for_diff_locally(&S, top->state);
// first argument is the key for the value set
// second argument is the value of the variable, e.g., top->state
// the value should be evaluated locally as the PC will be derived 
// from the state
void SpecialFunctionHandler::handleFindTupleForDiffLocally(
                                    ExecutionState &state,
                                    KInstruction *target,
                                    std::vector<ref<Expr> > &arguments) {
    
    // get the set of values mapped to the key  
    std::set<ref<Expr> > ms;

    if (globalMetadataSetMap.find(arguments[0]) != 
                                  globalMetadataSetMap.end())
       ms = globalMetadataSetMap[arguments[0]];

    ConstantExpr *CE = dyn_cast<ConstantExpr>(arguments[1]);
    if (CE) {
       // if the value in the current state is a constant
       // check if it is in the set of values in RS
       bool found = false;
       for(auto v : ms) {
          ConstantExpr *CE1 = dyn_cast<ConstantExpr>(v);
          if (CE1) {      
             if (CE->getZExtValue() == CE1->getZExtValue()) 
             {
                found = true;
                break;
             }
          }
          else assert(0 && "Unexpected symbolic value in the RS!\n"); 
       }
       if (!found) {
          llvm::errs() << "Found a don't care transition for dest value " 
                       << CE->getZExtValue() << "\n";
           llvm::errs() << "From input/state: \n";
           ExprPPrinter::printConstraints(llvm::errs(), state.constraints);
       }
    }
    else {
      // if the value in the current state is a symbolic expression      
    }  

    /*std::set<ref<Expr> > ms1;
    if (globalMetadataSetMap.find(arguments[1]) != 
                                  globalMetadataSetMap.end())
       ms1 = globalMetadataSetMap[arguments[1]];

    std::set<ref<Expr> > ms2;
    if (globalMetadataSetMap.find(arguments[2]) != 
                                  globalMetadataSetMap.end())
       ms2 = globalMetadataSetMap[arguments[2]];


    //std::set<std::pair<ref<Expr>,ref<Expr> > >  ms;
    //if (globalMetadataTupleSetMap.find(arguments[0]) != 
    //       globalMetadataTupleSetMap.end())
    ///   ms = globalMetadataTupleSetMap[arguments[0]];

    // for each value v in ms1 \ ms2
    for(auto v1 : ms1) {
       bool found = false;
       for(auto v2 : ms2) {
          if (v1 == v2) {
             found = true;
             break;
          }
       }
       if (!found) {
         // PC that can reach value of 3rd arg == v1
         // find the memory object (MemoryObject) mo that 
         // corresponds to the 3nd arg in state
         ObjectPair op;
         bool success;
         solver->setTimeout(coreSolverTimeout);
         if (!state.addressSpace.resolveOne(state, solver, arguments[3], 
                                                           op, success)) {
            address = toConstant(state, arguments[3], "resolveOne failure");
            success = state.addressSpace.resolveOne(
                        cast<ConstantExpr>(arguments[3]), op);
         } 
         solver->setTimeout(0);
         if (success) {
            const MemoryObject *mo = op.first;
   
         // read from mo  to find its current value in state
         // check if value read from mo is equal to 
         ref<Expr> result = os->read(0, mo.size);
         bool valueMatches;
         solver->setTimeout(coreSolverTimeout);
         success = solver->mayBeTrue(state, 
                                      EqExpr::create(result,v1),
                                      valueMatches);
         solver->setTimeout(0);
         if (success) {
            // if so get the PC and generate the tuple (PC, v1) 
            // add (PC, v1)  to ms
            //ms.insert(std::make_tuple(state.constraints,v1));
            llvm::errs() << "Found a don't care transition for dest value " 
                         << v1 << "\n";
            llvm::errs() << "From input/state: \n";
            ExprPPrinter::printConstraints(llvm::errs(), state.constraints);
         }
       }
   }
   // update globalMetadataTupleSetMap[arguments[0]] with  ms
   //globalMetadataTupleSetMap[arguments[0]] = ms;          
   */
}

////////////////////////////For 1 input variable add transition function////////////////////////////////////
void SpecialFunctionHandler::handleAddTransitionMetadataGlobally(ExecutionState &state,
                             KInstruction *target,
                             std::vector<ref<Expr> > &arguments) {
    std::vector<ref<Expr> > mvPrev;
    std::vector<ref<Expr> > mvNext;
    std::vector<ref<Expr> > mvInput;

    llvm::errs() << "Value of arg[1], i.e., previous state: " << arguments[1] << "\n";
    if(globalTransitionPrevVectorMap.find(arguments[0]) !=  globalTransitionPrevVectorMap.end())
       mvPrev = globalTransitionPrevVectorMap[arguments[0]]; 
    mvPrev.push_back(arguments[1]);//add previous state

    llvm::errs() << "Value of arg[2], i.e., next state: " << arguments[2] << "\n";
    if(globalTransitionNextVectorMap.find(arguments[0]) !=  globalTransitionNextVectorMap.end())
       mvNext = globalTransitionNextVectorMap[arguments[0]]; 
    mvNext.push_back(arguments[2]);//add next state

    llvm::errs() << "Value of arg[3], i.e., input condition: " << arguments[2] << "\n";
    if(globalTransitionInputVectorMap.find(arguments[0]) != globalTransitionInputVectorMap.end())
      mvInput = globalTransitionInputVectorMap[arguments[0]];
    mvInput.push_back(arguments[3]);//input condition

    llvm::errs() << "A transition in forward execution, from current state [" << arguments[1] << "] to next state ["
	  << arguments[2] << "] under input condition: " << arguments[3] << "\n";
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////


///////////////////////////////////Add intermediate value like roundKey/////////////////////////////////////////
void SpecialFunctionHandler::handleAddInterMetadataGlobally(ExecutionState &state,
                             KInstruction *target,
                             std::vector<ref<Expr> > &arguments) {
                       //numRound time roundKey      
    std::set<std::tuple<int, double, ref<Expr> > > ts;

    StatsTracker * statsTracker = ((Executor*)theInterpreter)->getStatsTracker();
    if (outputForward == NULL) {
       std::string fname = "outIntermediate.txt";
       if (OutputForwardFile != "")
          fname = OutputForwardFile; 
       outputForward = new std::fstream(fname, std::fstream::out);
    }

    std::fstream & out = *outputForward;
    
    out  << "\nCalling function klee_add_inter_metadata_globally: \n ";
    
    double timeStart = (util::getWallTime() - dontCareStartTime);

    //if(globalOutputTupleForward.find(arguments[0]) !=  globalOutputTupleForward.end())
      // ts = globalOutputTupleForward[arguments[0]]; 
       
    //std::vector<ref<Expr>> pcConditiontemp = state.constraints.getConstraints();

    ref<ConstantExpr> arg1, arg2, arg4;
    
  
    
	std::vector<ref<Expr>> vf;
    const std::vector<ref<Expr>> &vrFake = vf;
	ExecutionState *fake = new ExecutionState(vrFake);
	executor.solver->setTimeout(executor.coreSolverTimeout);
         
    executor.solver->getValue(*fake, arguments[1], arg1);

    double timeEnd = (util::getWallTime() - dontCareStartTime);
    double timePeriod = (timeStart - timeEnd);
    //ts.insert(std::make_tuple(arguments[1], timePeriod, arguments[2]));
    

    //globalOutputTupleForward[arguments[0]] = ts;

    /*for(auto& tuple: ts)
    	llvm::errs() << "previous state: " << std::get<0>(tuple) << "; next state: " << std::get<1>(tuple) << 
		        "\n PC: " << pcCondition << "; output: " << std::get<3>(tuple)  << 
		        "syminput var." << std::get<4>(tuple) << "\n";*/
  //for(auto& tuple: ts){
        std::string Str0;
	      llvm::raw_string_ostream info0(Str0);
        ExprPPrinter::printSingleExpr(info0, arguments[1]);
        out  << "\nnumRound: "<< info0.str() << "\n"; 
        //out  << "\nnumRound: "<< arguments[1];

        //std::string Str1;
      	//llvm::raw_string_ostream info1(Str1);
        //ExprPPrinter::printSingleExpr(info1, std::get<1>(tuple));
        //out  << "; time: "<< info1.str() << "\n"; 
        out  << "; time: "<< timePeriod << "\n"; 
        
        std::string Str2;
	      llvm::raw_string_ostream info2(Str2);
        ExprPPrinter::printSingleExpr(info2, arguments[2]);
        out  << "roundKey: "<< info2.str() << "\n"; 
        //out  << "\nroundKey: "<<arguments[2] << "\n"; 
    //}
    
    //out << " Finish forward analysis, total time=" 
               // << (util::getWallTime() - dontCareStartTime) << "\n"; 
}

////////////////////////////For add one reg forward function////////////////////////////////////////////
void SpecialFunctionHandler::handleAddOneForwardRegisterMetadataGlobally(ExecutionState &state,
                             KInstruction *target,
                             std::vector<ref<Expr> > &arguments) {
    std::set<std::tuple<ref<Expr>,ref<Expr> > > ts;

    StatsTracker * statsTracker = ((Executor*)theInterpreter)->getStatsTracker();
    if (regForward == NULL) {
       std::string fname = "regForward.txt";
       if (RegForwardFile != "")
          fname = RegForwardFile; 
       regForward = new std::fstream(fname, std::fstream::out);
    }

    std::fstream & out = *regForward;
    
    llvm::errs()  << "\nCalling function klee_add_one_forward_reg_metadata_globally: \n ";
    llvm::errs() << "arg[1] = " << arguments[1] << "; arg[2] = " << arguments[2] << "\n";

    if(globalOneRegTupleForward.find(arguments[0]) !=  globalOneRegTupleForward.end())
       ts = globalOneRegTupleForward[arguments[0]]; 
           
    ts.insert(std::make_tuple(arguments[1], arguments[2]));
    globalOneRegTupleForward[arguments[0]] = ts;
    
    llvm::errs() << " Finish forward reg collection, total time=" 
                << (util::getWallTime() - dontCareStartTime) << "\n"; 
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////For add_and_check_one_reg_abstract function////////////////////////////////////////////
void SpecialFunctionHandler::handleAddCheckAbstractOneRegisterMetadataGlobally(ExecutionState &state,
                             KInstruction *target,
                             std::vector<ref<Expr> > &arguments) {
    std::set<std::tuple<ref<Expr>,ref<Expr> > > tsForward;
    std::tuple<ref<Expr>,ref<Expr> > tupleb;

    StatsTracker * statsTracker = ((Executor*)theInterpreter)->getStatsTracker();
    if (regBackward == NULL) {
       std::string fname = "regBackward.txt";
       if (RegBackwardFile != "")
          fname = RegBackwardFile; 
       regBackward = new std::fstream(fname, std::fstream::out);
    }

    std::fstream & out = *regBackward;
    
    
    llvm::errs()  << "\nCalling function klee_add_and_check_abstract_one_reg_metadata_globally: \n ";
    static int numofstates1reg = 1;
    
    llvm::errs() << "arg[1] = " << arguments[1] << "; arg[2] = " << arguments[2] << "\n";

    if(globalOneRegTupleForward.find(arguments[0]) !=  globalOneRegTupleForward.end())
       tsForward = globalOneRegTupleForward[arguments[0]]; 
    
    tupleb = std::make_tuple(arguments[1], arguments[2]);
    
    bool forwarg0success, forwarg1success;
    bool forwarg0successgetval, forwarg1successgetval;
    ref<ConstantExpr> forwargvalue0, forwargvalue1;
    
    bool backarg0success, backarg1success;
    bool backarg0successgetval, backarg1successgetval;
    ref<ConstantExpr> backargvalue0, backargvalue1;
    
    bool arg0success, arg1success;

    backarg0successgetval = executor.solver->getValue(state, arguments[1], backargvalue0);
    backarg1successgetval = executor.solver->getValue(state, arguments[2], backargvalue1);
    llvm::errs() << "backarg0successgetval/backargvalue0=" << backarg0successgetval << "/" << backargvalue0 
                 << "\nbackarg1successgetval/backargvalue1=" << backarg1successgetval << "/" << backargvalue1 << "\n\n";

    for (auto& tuplef: tsForward){
        forwarg0successgetval = executor.solver->getValue(state, std::get<0>(tuplef), forwargvalue0);
        forwarg1successgetval = executor.solver->getValue(state, std::get<1>(tuplef), forwargvalue1);
        llvm::errs() << "forwarg0successgetval/forwargvalue0=" << forwarg0successgetval << "/" << forwargvalue0 
                     << "\nforwarg1successgetval/forwargvalue1=" << forwarg1successgetval << "/" << forwargvalue1 << "\n\n";
        
        arg0success = ((backargvalue0->getZExtValue()) == (forwargvalue0->getZExtValue()));
        arg1success = ((backargvalue1->getZExtValue()) == (forwargvalue1->getZExtValue()));
        
        llvm::errs() << "arg0success=" << arg0success  << "\narg1success=" << arg1success << "\n";
        if (arg0success) {
            llvm::errs() << "Check each register in state: " << (forwargvalue0->getZExtValue()) << "\n";
            if (arg1success)
                 llvm::errs() << "All register values are consist between forward and abstract stage!\n";
            else {
                 llvm::errs() << "Some register value(s) is(are) different!! Potential TROJAN reported here!! Time: " << (util::getWallTime() - dontCareStartTime) << ". NumberOfStates: " << numofstates1reg++ << ". Termiante state from klee_add_and_check_abstract_one_reg_metadata_globally()\n";
                 executor.terminateStateOnExecError(state, 
                                         "Some register value(s) is(are) different!! Potential TROJAN reported here!!"); 
                 break;
            }
        }
        
        else
            llvm::errs() << "Can NOT find the state=" <<(std::get<0>(tupleb))<< " from forward analysis with abstract stage, go to next  iteration\n";
        continue;
    }
    
    /*bool arg0consist, arg1consist;
    bool arg0success, arg1success;
    bool arg0successgetval, arg1successgetval;
    ref<ConstantExpr> argvalue0, argvalue1;

    arg0successgetval = executor.solver->getValue(state, arguments[1], argvalue0);
    arg1successgetval = executor.solver->getValue(state, arguments[2], argvalue1);
    llvm::errs() << "arg0successgetval/argvalue0=" << arg0successgetval << "/" << argvalue0 
                 << "\narg1successgetval/argvalue1=" << arg1successgetval << "/" << argvalue1 << "\n";

    for (auto& tuplef: tsForward){
        static int i=1;
        arg0success = executor.solver->mayBeTrue(state, EqExpr::create(std::get<0>(tupleb), std::get<0>(tuplef)), arg0consist);
        arg1success = executor.solver->mayBeTrue(state, EqExpr::create(std::get<1>(tupleb), std::get<1>(tuplef)), arg1consist);
        
        llvm::errs() << "arg0success/consist=" << arg0success << "/" << arg0consist 
                     << "\narg1success/consist=" << arg1success << "/" << arg1consist  << "\n";
        if (arg0success && arg0consist) {
            llvm::errs() << "Check each register in state: " << (std::get<0>(tupleb)) << "\n";
            if (((arg1consist && arg1success) || (!arg1success)) )
                 llvm::errs() << "All register values are consist between forward and abstract stage!\n";
            else {
                 llvm::errs() << "Some register value(s) is(are) different!! Potential TROJAN reported here!! Time: " << (util::getWallTime() - dontCareStartTime) << ". NumberOfStates: " << numofstates1reg++ << ". Termiante state from klee_add_and_check_abstract_one_reg_metadata_globally()\n";
                 executor.terminateStateOnExecError(state, 
                                         "Some register value(s) is(are) different!! Potential TROJAN reported here!!"); 
                 break;
            }
        }
        
        else
            llvm::errs() << "Can NOT find the state=" <<(std::get<0>(tupleb))<< " from forward analysis with abstract stage in No. " << i++ << " depth, go to other iteration\n";
        continue;
    }*/
    
    //llvm::errs() << " Finish backward one reg check, total time=" 
                //<< (util::getWallTime() - dontCareStartTime) << "\n"; 
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////For add reg forward function////////////////////////////////////////////
void SpecialFunctionHandler::handleAddForwardRegisterMetadataGlobally(ExecutionState &state,
                             KInstruction *target,
                             std::vector<ref<Expr> > &arguments) {
    std::set<std::tuple<ref<Expr>,ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr> > > ts;

    StatsTracker * statsTracker = ((Executor*)theInterpreter)->getStatsTracker();
    /*if (regForward == NULL) {
       std::string fname = "regForward.txt";
       if (RegForwardFile != "")
          fname = RegForwardFile; 
       regForward = new std::fstream(fname, std::fstream::out);
    }

    std::fstream & out = *regForward;
    
    llvm::errs()  << "\nCalling function klee_add_forward_reg_metadata_globally: \n ";
    llvm::errs() << "arg[1] = " << arguments[1] << "; arg[2] = " << arguments[2] << "; arg[3] = " << arguments[3] << "; arg[4] = " << arguments[4] << "; arg[5] = " << arguments[5] << "; arg[6] = " << arguments[6] << "; arg[7] = " << arguments[7] << "; arg[8] = " << arguments[8] << "; arg[9] = " << arguments[9] << "; arg[10] = " << arguments[10] << "; arg[11] = " << arguments[11] << "; arg[12] = " << arguments[12] << "; arg[13] = " << arguments[13] << "\n";*/

    if(globalRegTupleForward.find(arguments[0]) !=  globalRegTupleForward.end())
       ts = globalRegTupleForward[arguments[0]]; 
           
    ts.insert(std::make_tuple(arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6], arguments[7], arguments[8], arguments[9], arguments[10], arguments[11], arguments[12], arguments[13]));
    globalRegTupleForward[arguments[0]] = ts;
    
    llvm::errs() << " Finish forward reg collection, total time=" 
                << (util::getWallTime() - dontCareStartTime) << "\n"; 
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////For add_and_check_reg_abstract function////////////////////////////////////////////
void SpecialFunctionHandler::handleAddCheckAbstractRegisterMetadataGlobally(ExecutionState &state,
                             KInstruction *target,
                             std::vector<ref<Expr> > &arguments) {
    //llvm::errs() << "dontCareFinishTime:" << dontCareFinishTime <<"\nstart time of klee_add_and_check_abstract_reg_metadata_globally(): " << (util::getWallTime() - dontCareFinishTime)  << "\n";
    std::set<std::tuple<ref<Expr>,ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr> > > tsForward;
    std::tuple<ref<Expr>,ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr> > tupleb;

    /*StatsTracker * statsTracker = ((Executor*)theInterpreter)->getStatsTracker();
    if (regBackward == NULL) {
       std::string fname = "regBackward.txt";
       if (RegBackwardFile != "")
          fname = RegBackwardFile; 
       regBackward = new std::fstream(fname, std::fstream::out);
    }

    std::fstream & out = *regBackward;*/
    numofstates++;
    std::fstream & out = *dontcareStats;
    out << "dontCareFinishTime:" << dontCareFinishTime <<"\nstart time of klee_add_and_check_abstract_reg_metadata_globally(): " << (util::getWallTime() - dontCareFinishTime)  << "\n";
    
    //llvm::errs()  << "\nCalling function klee_add_and_check_abstract_reg_metadata_globally: \n ";
    
    /*llvm::errs() << "arg[1] = " << arguments[1] << "; arg[2] = " << arguments[2] << "; arg[3] = " << arguments[3] << "; arg[4] = " << arguments[4] << "; arg[5] = " << arguments[5] << "; arg[6] = " << arguments[6] << "; arg[7] = " << arguments[7] << "; arg[8] = " << arguments[8] << "; arg[9] = " << arguments[9] << "; arg[10] = " << arguments[10] << "; arg[11] = " << arguments[11] << "; arg[12] = " << arguments[12] << "; arg[13] = " << arguments[13] << "\n\n";*/

    if(globalRegTupleForward.find(arguments[0]) !=  globalRegTupleForward.end())
       tsForward = globalRegTupleForward[arguments[0]]; 
    
    tupleb = std::make_tuple(arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6], arguments[7], arguments[8], arguments[9], arguments[10], arguments[11], arguments[12], arguments[13]);
    
    bool arg0consist, arg1consist, arg2consist, arg3consist, arg4consist, arg5consist, arg6consist, arg7consist, arg8consist, arg9consist, arg10consist, arg11consist, arg12consist;
    bool arg0success, arg1success, arg2success, arg3success, arg4success, arg5success, arg6success, arg7success, arg8success, arg9success, arg10success, arg11success, arg12success;
    
    bool terminateStateDontHaveRegDiverg = false;
    /*bool arg0successgetval, arg1successgetval, arg2successgetval, arg3successgetval, arg4successgetval, arg5successgetval, arg6successgetval, arg7successgetval, arg8successgetval, arg9successgetval, arg10successgetval, arg11successgetval, arg12successgetval;
    ref<ConstantExpr> argvalue0, argvalue1, argvalue2, argvalue3, argvalue4, argvalue5, argvalue6, argvalue7, argvalue8, argvalue9, argvalue10, argvalue11, argvalue12;*/

    /*arg0successgetval = executor.solver->getValue(state, arguments[1], argvalue0);
    arg1successgetval = executor.solver->getValue(state, arguments[2], argvalue1);
    arg2successgetval = executor.solver->getValue(state, arguments[3], argvalue2);
    arg3successgetval = executor.solver->getValue(state, arguments[4], argvalue3);
    arg4successgetval = executor.solver->getValue(state, arguments[5], argvalue4);
    arg5successgetval = executor.solver->getValue(state, arguments[6], argvalue5);
    arg6successgetval = executor.solver->getValue(state, arguments[7], argvalue6);
    arg7successgetval = executor.solver->getValue(state, arguments[8], argvalue7);
    arg8successgetval = executor.solver->getValue(state, arguments[9], argvalue8);
    arg9successgetval = executor.solver->getValue(state, arguments[10], argvalue9);
    arg10successgetval = executor.solver->getValue(state, arguments[11], argvalue10);
    arg11successgetval = executor.solver->getValue(state, arguments[12], argvalue11);
    arg12successgetval = executor.solver->getValue(state, arguments[13], argvalue12);
    llvm::errs() << "arg0successgetval/argvalue0=" << arg0successgetval << "/" << argvalue0 
                 << "\narg1successgetval/argvalue1=" << arg1successgetval << "/" << argvalue1
                 << "\narg2successgetval/argvalue2=" << arg2successgetval << "/" << argvalue2 
                 << "\narg3successgetval/argvalue3=" << arg3successgetval << "/" << argvalue3 
                 << "\narg4successgetval/argvalue4=" << arg4successgetval << "/" << argvalue4 
                 << "\narg5successgetval/argvalue5=" << arg5successgetval << "/" << argvalue5 
                 << "\narg6successgetval/argvalue6=" << arg6successgetval << "/" << argvalue6 
                 << "\narg7successgetval/argvalue7=" << arg7successgetval << "/" << argvalue7 
                 << "\narg8successgetval/argvalue8=" << arg8successgetval << "/" << argvalue8 
                 << "\narg9successgetval/argvalue9=" << arg9successgetval << "/" << argvalue9 
                 << "\narg10successgetval/argvalue10=" << arg10successgetval << "/" << argvalue10 
                 << "\narg11successgetval/argvalue11=" << arg11successgetval << "/" << argvalue11 
                 << "\narg12successgetval/argvalue12=" << arg12successgetval << "/" << argvalue12 << "\n\n";*/

    for (auto& tuplef: tsForward){
        //llvm::errs() << "\nHandling state:" << std::get<0>(tuplef) << "from tuplef\n";
        arg0success = executor.solver->mayBeTrue(state, EqExpr::create(std::get<0>(tupleb), std::get<0>(tuplef)), arg0consist);
        arg1success = executor.solver->mayBeTrue(state, EqExpr::create(std::get<1>(tupleb), std::get<1>(tuplef)), arg1consist);
        arg2success = executor.solver->mayBeTrue(state, EqExpr::create(std::get<2>(tupleb), std::get<2>(tuplef)), arg2consist);
        arg3success = executor.solver->mayBeTrue(state, EqExpr::create(std::get<3>(tupleb), std::get<3>(tuplef)), arg3consist);
        arg4success = executor.solver->mayBeTrue(state, EqExpr::create(std::get<4>(tupleb), std::get<4>(tuplef)), arg4consist);
        arg5success = executor.solver->mayBeTrue(state, EqExpr::create(std::get<5>(tupleb), std::get<5>(tuplef)), arg5consist);
        arg6success = executor.solver->mayBeTrue(state, EqExpr::create(std::get<6>(tupleb), std::get<6>(tuplef)), arg6consist);
        arg7success = executor.solver->mayBeTrue(state, EqExpr::create(std::get<7>(tupleb), std::get<7>(tuplef)), arg7consist);
        arg8success = executor.solver->mayBeTrue(state, EqExpr::create(std::get<8>(tupleb), std::get<8>(tuplef)), arg8consist);
        arg9success = executor.solver->mayBeTrue(state, EqExpr::create(std::get<9>(tupleb), std::get<9>(tuplef)), arg9consist);
        arg10success = executor.solver->mayBeTrue(state, EqExpr::create(std::get<10>(tupleb), std::get<10>(tuplef)), arg10consist);
        arg11success = executor.solver->mayBeTrue(state, EqExpr::create(std::get<11>(tupleb), std::get<11>(tuplef)), arg11consist);
        arg12success = executor.solver->mayBeTrue(state, EqExpr::create(std::get<12>(tupleb), std::get<12>(tuplef)), arg12consist);

        /*llvm::errs() << "arg0success/consist=" << arg0success << "/" << arg0consist 
                     << "\narg1success/consist=" << arg1success << "/" << arg1consist 
                     << "\narg2success/consist=" << arg2success << "/" << arg2consist 
                     << "\narg3success/consist=" << arg3success << "/" << arg3consist 
                     << "\narg4success/consist=" << arg4success << "/" << arg4consist 
                     << "\narg5success/consist=" << arg5success << "/" << arg5consist 
                     << "\narg6success/consist=" << arg6success << "/" << arg6consist 
                     << "\narg7success/consist=" << arg7success << "/" << arg7consist 
                     << "\narg8success/consist=" << arg8success << "/" << arg8consist 
                     << "\narg9success/consist=" << arg9success << "/" << arg9consist 
                     << "\narg10success/consist=" << arg10success << "/" << arg10consist 
                     << "\narg11success/consist=" << arg11success << "/" << arg11consist 
                     << "\narg12success/consist=" << arg12success << "/" << arg12consist << "\n";*/
        if (arg0success && arg0consist) {
            llvm::errs() << "Check each register in state: " << (std::get<0>(tuplef)) << "\n";
            if (((arg1consist && arg1success) || (!arg1success)) && ((arg2consist && arg2success) || (!arg2success)) && ((arg3consist && arg3success) || (!arg3success)) && ((arg4consist && arg4success) || (!arg4success)) && ((arg5consist && arg5success) || (!arg5success)) && ((arg6consist && arg6success) || (!arg6success)) && ((arg7consist && arg7success) || (!arg7success)) && ((arg8consist && arg8success) || (!arg8success)) && ((arg9consist && arg9success) || (!arg9success)) && ((arg10consist && arg10success) || (!arg10success)) && ((arg11consist && arg11success) || (!arg11success)) && ((arg12consist && arg12success) || (!arg12success)))
                 //llvm::errs() << "All register values are consist between forward and abstract stage!\n";
                 continue;
            else {
                 
                 llvm::errs() << "Some register value(s) is(are) different!! Potential TROJAN reported here!! Time: " << (util::getWallTime() - dontCareFinishTime) << ". NumberOfStates: " << numofstates << ". Termiante state from klee_add_and_check_abstract_reg_metadata_globally()\n";
                 out << "\nSome register value(s) is(are) different!! Potential TROJAN reported here!! Time: " << (util::getWallTime() - dontCareFinishTime) << ". NumberOfStates: " << numofstates++ << ". Termiante state from klee_add_and_check_abstract_reg_metadata_globally()\n";
                 terminateStateDontHaveRegDiverg = true;
                 //executor.terminateStateOnExecError(state, 
                                         //"Some register value(s) is(are) different!! Potential TROJAN reported here!!"); 
                 break;
            }
        }
        
        else
            //llvm::errs() << "Can NOT find the state=" <<(std::get<0>(tupleb))<< " from forward analysis with abstract stage, go to other iteration\n";
            continue;
    }
    
    
    //if (!terminateStateDontHaveRegDiverg)
        //executor.terminateStateOnError(
                                 //state, "Terminate state Don't have RegDiverging",
                                 //Executor::TerminateReason::User);
        
    llvm::errs() << "DON'T find Trojan in current state, Time: " << (util::getWallTime() - dontCareFinishTime) << "\n";
    out << "DON'T find Trojan in current state, Time: " << (util::getWallTime() - dontCareFinishTime) << "\n";
    dontCareFinishTime = util::getWallTime();
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////For 1 input variable add output function////////////////////////////////////////////
void SpecialFunctionHandler::handleAddOutputMetadataGlobally(ExecutionState &state,
                             KInstruction *target,
                             std::vector<ref<Expr> > &arguments) {
    std::set<std::tuple<ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr> > > ts;

    /*StatsTracker * statsTracker = ((Executor*)theInterpreter)->getStatsTracker();
    if (outputForward == NULL) {
       std::string fname = "outForward.txt";
       if (OutputForwardFile != "")
          fname = OutputForwardFile; 
       outputForward = new std::fstream(fname, std::fstream::out);
    }

    std::fstream & out = *outputForward;
    
    out  << "\nCalling function klee_add_output_metadata_globally: \n ";*/

    if(globalOutputTupleForward.find(arguments[0]) !=  globalOutputTupleForward.end())
       ts = globalOutputTupleForward[arguments[0]]; 
       
    std::vector<ref<Expr>> pcConditiontemp = state.constraints.getConstraints();
    ref<Expr> pcCondition = NULL;
    for(auto pc: pcConditiontemp){
      if (pcCondition.isNull())
          pcCondition = pc;
      else
          pcCondition = AndExpr::create(pc, pcCondition);
    }
    ref<ConstantExpr> arg1, arg2, arg4, arg5;

    executor.solver->getValue(state, arguments[1], arg1);
    executor.solver->getValue(state, arguments[2], arg2);
    executor.solver->getValue(state, arguments[4], arg4);
    executor.solver->getValue(state, arguments[5], arg5);
    
    //ts.insert(std::make_tuple(arg1, arg2,pcCondition, arg4, arguments[5]));
    ts.insert(std::make_tuple(arg1, arg2,pcCondition, arg4, arg5));
    

    globalOutputTupleForward[arguments[0]] = ts;

    /*for(auto& tuple: ts)
    	llvm::errs() << "previous state: " << std::get<0>(tuple) << "; next state: " << std::get<1>(tuple) << 
		        "\n PC: " << pcCondition << "; output: " << std::get<3>(tuple)  << 
		        "syminput var." << std::get<4>(tuple) << "\n";*/
  /*for(auto& tuple: ts){
        std::string Str0;
	      llvm::raw_string_ostream info0(Str0);
        ExprPPrinter::printSingleExpr(info0, std::get<0>(tuple));
        out  << "\nprevious state: "<< info0.str() << "\n"; 

        std::string Str1;
      	llvm::raw_string_ostream info1(Str1);
        ExprPPrinter::printSingleExpr(info1, std::get<1>(tuple));
        out  << "next state: "<< info1.str() << "\n"; 

        std::string Str2;
	      llvm::raw_string_ostream info2(Str2);
        ExprPPrinter::printSingleExpr(info2, std::get<2>(tuple));
        out  << "input condition: "<< info2.str() << "\n"; 

        std::string Str3;
	      llvm::raw_string_ostream info3(Str3);
        ExprPPrinter::printSingleExpr(info3, std::get<3>(tuple));
        out  << "arg4: "<< info3.str() << "\n"; 

        std::string Str4;
	      llvm::raw_string_ostream info4(Str4);
        ExprPPrinter::printSingleExpr(info4, std::get<4>(tuple));
        out  << "arg5: "<< info4.str() << "\n";
    }*/
    
    //out << " Finish add_output_metadata, total time=" 
                //<< (util::getWallTime() - dontCareStartTime) << "\n"; 
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////For 1 input variable add backward output function////////////////////////////////////
void SpecialFunctionHandler::handleAddBackOutputMetadataGlobally(ExecutionState &state,
                             KInstruction *target,
                             std::vector<ref<Expr> > &arguments) {
    std::set<std::tuple<ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr> > > ts;

    //StatsTracker * statsTracker = ((Executor*)theInterpreter)->getStatsTracker();
    /*if (outputBackward == NULL) {
       std::string fname = "outBackward.txt";
       if (OutputBackwardFile != "")
          fname = OutputBackwardFile; 
       outputBackward = new std::fstream(fname, std::fstream::out);
    }

    std::fstream & out = *outputBackward;*/


    if(globalOutputTupleBackward.find(arguments[0]) !=  globalOutputTupleBackward.end())
       ts = globalOutputTupleBackward[arguments[0]]; 
       
    std::vector<ref<Expr>> pcConditiontemp = state.constraints.getConstraints();
    ref<Expr> pcCondition = NULL;
    for(auto pc: pcConditiontemp){
      if (pcCondition.isNull())
          pcCondition = pc;
      else
          pcCondition = AndExpr::create(pc, pcCondition);
    }

    ref<ConstantExpr> arg1, arg2, arg4;
    
    //ExecutionState *fake = new ExecutionState(state);
    
	  std::vector<ref<Expr>> vf;
    const std::vector<ref<Expr>> &vrFake = vf;
	  ExecutionState *fake = new ExecutionState(vrFake);
	  executor.solver->setTimeout(executor.coreSolverTimeout);
         
    executor.solver->getValue(*fake, arguments[1], arg1);
    executor.solver->getValue(*fake, arguments[2], arg2);
    executor.solver->getValue(*fake, arguments[4], arg4);

    ts.insert(std::make_tuple(arg1, arg2,pcCondition, arg4, arguments[5]));
        

    globalOutputTupleBackward[arguments[0]] = ts;

    /*for(auto& tuple: ts){
        std::string Str0;
	      llvm::raw_string_ostream info0(Str0);
        ExprPPrinter::printSingleExpr(info0, std::get<0>(tuple));
        out  << "\nprevious state: "<< info0.str() << "\n"; 

        std::string Str1;
	      llvm::raw_string_ostream info1(Str1);
        ExprPPrinter::printSingleExpr(info1, std::get<1>(tuple));
        out  << "next state: "<< info1.str() << "\n"; 

        std::string Str2;
	      llvm::raw_string_ostream info2(Str2);
        ExprPPrinter::printSingleExpr(info2, std::get<2>(tuple));
        out  << "input condition: "<< info2.str() << "\n"; 

        std::string Str3;
	      llvm::raw_string_ostream info3(Str3);
        ExprPPrinter::printSingleExpr(info3, std::get<3>(tuple));
        out  << "output value: "<< info3.str() << "\n"; 
    }*/
    //addBackOutputfinishTime = util::getWallTime();
    //out << " Finish add_back_output_metadata, total time=" 
                //<< (util::getWallTime() - dontCareStartTime) << "\n"; 
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void SpecialFunctionHandler::handleCheckDCTfinishTime(ExecutionState &state,
                             KInstruction *target,
                             std::vector<ref<Expr> > &arguments) {
    if (!dontCareFinishTime)
        dontCareFinishTime = (util::getWallTime());
        
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void SpecialFunctionHandler::handleDetectOutputTrojan(ExecutionState &state,
                             KInstruction *target,
                             std::vector<ref<Expr> > &arguments) {

    std::set<std::tuple<ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr> > > tsf;
    std::set<std::tuple<ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr>, ref<Expr> > > tsb;
    
    /*StatsTracker * statsTracker = ((Executor*)theInterpreter)->getStatsTracker();
    if (outputTrojan == NULL) {
       std::string fname = "outTrojan.txt";
       if (OutputTrojanFile != "")
          fname = OutputTrojanFile; 
       outputTrojan = new std::fstream(fname, std::fstream::out);
    }

    std::fstream & out = *outputTrojan;*/
    std::fstream & out = *dontcareStats;

    if (globalOutputTupleForward.find(arguments[0]) !=  globalOutputTupleForward.end())
        tsf = globalOutputTupleForward[arguments[0]];

    if (globalOutputTupleBackward.find(arguments[1]) !=  globalOutputTupleBackward.end())
        tsb = globalOutputTupleBackward[arguments[1]];

    
	  std::vector<ref<Expr>> vf;
    const std::vector<ref<Expr>> &vrFake = vf;
	  ExecutionState *fake = new ExecutionState(vrFake);
         
    //executor.solver->setTimeout(executor.coreSolverTimeout);
    
    //out  << "calling function klee_detect_output_trojan" << "\n";
    for (auto& tupleb: tsb){

	    ConstantExpr *constupleb0 = dyn_cast<ConstantExpr>(std::get<0>(tupleb));//prevState
    	ConstantExpr *constupleb1 = dyn_cast<ConstantExpr>(std::get<1>(tupleb));//nextState
    	ConstantExpr *constupleb2 = dyn_cast<ConstantExpr>(std::get<2>(tupleb));//inputCond
    	ConstantExpr *constupleb3 = dyn_cast<ConstantExpr>(std::get<3>(tupleb));//output
    	//ConstantExpr *constupleb4 = dyn_cast<ConstantExpr>(std::get<4>(tupleb));//symInput var

	    for(auto& tuplef: tsf){
          //executor.solver->setTimeout(executor.coreSolverTimeout);
          
          bool outTrojanDetectSuccess = false;
         
	        bool preStatMatch = false;
          bool preStatSymMatch = false;
          bool preStatSymMatchPC = false;        
	        bool nextStatMatch = false;
          bool nextStatSymMatch = false;
          bool nextStatSymMatchPC = false;        
	        bool inputMatch = false;
	        bool inputSymMatch = false;
          bool inputSymMatchPC = false;
	        bool outputMatch = false;
          bool outputSymMatch = false;

	        ref<ConstantExpr> preStatValueForward;
	        ref<ConstantExpr> preStatValueBackward;
	        ref<ConstantExpr> nextStatValueForward;
	        ref<ConstantExpr> nextStatValueBackward;
	        ref<ConstantExpr> inputValueForward;
	        ref<ConstantExpr> inputValueBackward;
	        ref<ConstantExpr> outputValueForward;
	        ref<ConstantExpr> outputValueBackward;

	        ConstantExpr *constuplef0 = dyn_cast<ConstantExpr>(std::get<0>(tuplef));//prevState
	        ConstantExpr *constuplef1 = dyn_cast<ConstantExpr>(std::get<1>(tuplef));//nextState
	        ConstantExpr *constuplef2 = dyn_cast<ConstantExpr>(std::get<2>(tuplef));//inputCond
	        ConstantExpr *constuplef3 = dyn_cast<ConstantExpr>(std::get<3>(tuplef));//output

/////////////////////handle first element in both tuples, i.e. previous state////////////////////
          if(constupleb0 && constuplef0){ 
		        if (constupleb0->getZExtValue() == constuplef0->getZExtValue()) {
		            preStatMatch = true;
                //out << "\nfirst elements(preState) of both tuple are concrete and same\n"
			              //<< "Previous state Forward : " << constuplef0->getZExtValue() << "\n"
			              //<< "Previous state Backward: " << constupleb0->getZExtValue() << "\n";    

	       	  }
		       else {
               continue;
           }
	        }
	
	       else {
		        ref<Expr> b0eqf0 = AndExpr::create(std::get<0>(tupleb), std::get<0>(tuplef));
          
            if (!(executor.solver->mayBeTrue(state, b0eqf0, preStatSymMatch)) )
                continue;                

                  /*std::string Str0;
	                llvm::raw_string_ostream info0(Str0);
                  ExprPPrinter::printSingleExpr(info0, std::get<0>(tuplef));
                  out  << "\nfirst elements(preState) of both tuple are symbolic and same\n"
                       << "Previous state Forward: " << info0.str() << "\n"; 
                       
                  std::string Str1;
	                llvm::raw_string_ostream info1(Str1);
                  ExprPPrinter::printSingleExpr(info1, std::get<0>(tupleb));
                  out  << "Previous state Backward: " << info1.str() << "\n";*/              
	      } 

/////////////////////handle second element in both tuples, i.e. next state////////////////////
        if(constupleb1 && constuplef1) {
		      if (constupleb1->getZExtValue() == constuplef1->getZExtValue()) {
		          nextStatMatch = true;
              //out << "second elements(nextState) of both tuple are concrete and same\n"
			            //<< "Next state Forward : " << constuplef1->getZExtValue() << "\n"
			            //<< "Next state Backward: " << constupleb1->getZExtValue() << "\n"; 
		      }
		    else 
            continue;
	      }
             
	    else {
		        ref<Expr> b1eqf1 = AndExpr::create(std::get<1>(tupleb), std::get<1>(tuplef));
            if (!(executor.solver->mayBeTrue(state, b1eqf1, nextStatSymMatch)) )
                continue;
                 /*std::string Str2;
  	             llvm::raw_string_ostream info2(Str2);
                 ExprPPrinter::printSingleExpr(info2, std::get<1>(tuplef));                
		             out << "second elements(nextState) of both tuple are symbolic and same\n"
			               << "Next state Forward: " << info2.str() << "\n";
                                       
                 std::string Str3;
  	             llvm::raw_string_ostream info3(Str3);
                 ExprPPrinter::printSingleExpr(info3, std::get<1>(tupleb));                
		             out << "Next state Backward: " << info3.str() << "\n";*/
           
	    } 


/////////////////////handle third element in both tuples, i.e. input condition////////////////////
	    if(constupleb2 && constuplef2) { 
		    if (constupleb2->getZExtValue() == constuplef2->getZExtValue()) {
		       inputMatch = true;
		        //out << "third elements(input) of both tuple are concrete and same\n"
			          //<< "Input condition Forward : " << constuplef2->getZExtValue() << "\n"
			          //<< "Input condition Backward: " << constupleb2->getZExtValue() << "\n";
        }
		    else 
           continue;
	    }
         
	    else {                          
		        ref<Expr> b2eqf2 = AndExpr::create(std::get<2>(tupleb), std::get<2>(tuplef));
		        ref<Expr> b4eqf4 = EqExpr::create(std::get<4>(tupleb), std::get<4>(tuplef)); 
		        b4eqf4 = ZExtExpr::create(b4eqf4 ,b2eqf2->getWidth());
		        ref<Expr> b2eqf2ANDb4eqf4 = AndExpr::create(b2eqf2, b4eqf4);
				    if( !(executor.solver->mayBeTrue(*fake, b2eqf2ANDb4eqf4, inputSymMatch)) )
		           continue;
            inputMatch = true;
                      
                  /*std::string Str4;
  	              llvm::raw_string_ostream info4(Str4);
                  ExprPPrinter::printSingleExpr(info4, b2eqf2ANDb4eqf4);                                         
	                out << "third elements(input) of both tuple are symbolic and same\n"
			                << "Input condition: " << info4.str() << "\n"; */
            
	    } 

/////////////////////handle fourth element in both tuples, i.e. output values////////////////////
	    if(constupleb3 && constuplef3) { 
		    if (constupleb3->getZExtValue() != constuplef3->getZExtValue()) {
		        outputMatch = true;
            outTrojanDetectSuccess = true;
		        //out << "fourth elements(output) of both tuple are concrete and NOT same!!!\n";
              out << "***Output value Forward : " << constuplef3->getZExtValue() << "***\n"
		            << "***Output value Backward: " << constupleb3->getZExtValue() << "***\n";
		               //<< "***Output value: " << constupleb3->getZExtValue() << "***\n";
		    }
		    else 
           continue;
	    }
         
	    else {
		      ref<Expr> b3eqf3 = AndExpr::create(std::get<3>(tupleb), std::get<3>(tuplef));
          if( executor.solver->mayBeTrue(*fake, b3eqf3, outputSymMatch) )
		          continue;
          outTrojanDetectSuccess = true;
          /*else {
                executor.solver->getValue(*fake, std::get<3>(tuplef), outputValueForward);
                executor.solver->getValue(*fake, std::get<3>(tupleb), outputValueBackward);
		            out << "fourth elements(output) of both tuple are symbolic and NOT same!!!\n"
		                << "***Output value Forward : " << outputValueForward->getZExtValue() << "***\n"
		                << "  ***Output value Backward: " << outputValueBackward->getZExtValue() << "***\n";
          }*/
	    }
         
      if (outTrojanDetectSuccess){
          out << " \nFound an output Trojan: \nTime from dontCareStartTime="  << (util::getWallTime() - dontCareStartTime) 
              << "\nTime from dontCareFinishTime = " << (util::getWallTime() - dontCareFinishTime) << "\n\n"; 
         llvm::errs() << " \nFound an output Trojan: \nTime from dontCareStartTime="  << (util::getWallTime() - dontCareStartTime) 
              << "\nTime from dontCareFinishTime = " << (util::getWallTime() - dontCareFinishTime) << "\n\n"; 
          executor.terminateStateOnExecError(state, 
                                         "Output value different!! TROJAN payload reported here!!"); 
          /*out << "\nfirst elements(preState) of both tuple are concrete and same\n"
			              << "Previous state Forward : " << constuplef0->getZExtValue() << "\n"
			              << "Previous state Backward: " << constupleb0->getZExtValue() << "\n";
                                     
          out << "second elements(nextState) of both tuple are concrete and same\n"
			            << "Next state Forward : " << constuplef1->getZExtValue() << "\n"
			            << "Next state Backward: " << constupleb1->getZExtValue() << "\n";
                                 
          out << "third elements(input) of both tuple are symbolic and same\n";*/
          
           
          /*ref<Expr> b2eqf2 = AndExpr::create(std::get<2>(tupleb), std::get<2>(tuplef));
		        ref<Expr> b4eqf4 = EqExpr::create(std::get<4>(tupleb), std::get<4>(tuplef)); 
		        b4eqf4 = ZExtExpr::create(b4eqf4 ,b2eqf2->getWidth());
		        ref<Expr> b2eqf2ANDb4eqf4 = AndExpr::create(b2eqf2, b4eqf4);                      
          std::string Str8;
          llvm::raw_string_ostream info8(Str8);
          ExprPPrinter::printSingleExpr(info8, b2eqf2ANDb4eqf4);                                         
          out << "third elements(input) of both tuple are symbolic and same\n"
			        << "Input condition: " << info8.str() << "\n";
                         
          out << "fourth elements(output) of both tuple are concrete and NOT same!!!\n"
		            << "***Output value Forward : " << constuplef3->getZExtValue() << "***\n"
		            << "***Output value Backward: " << constupleb3->getZExtValue() << "***\n";*/
      }
         
	  }
  }

}

void SpecialFunctionHandler::handleSetSourceState(ExecutionState &state,
                             KInstruction *target,
                             std::vector<ref<Expr> > &arguments) {
                             
    if (SourceState != 99){
        unsigned source = SourceState;
        ref<ConstantExpr> temp = Expr::createPointer(source);
        llvm::errs() << "arg[0](value of destState) before klee_set_source_state(): " << arguments[0] << "\n";
        
        std::set<ref<Expr>> ts;
        ts.insert(temp);
        
        auto it = ts.end();
        it--;
        ref<Expr> state = *it;
                    
        arguments[0]= state;
        
        llvm::errs() << "Assign srcState value " << *temp << " to state register!\n";
        llvm::errs() << "arg[0](value of srcState) after klee_set_source_state(): " << arguments[0] << "\n";
    }
    
    else
        return;
}

void SpecialFunctionHandler::handleSetDestState(ExecutionState &state,
                             KInstruction *target,
                             std::vector<ref<Expr> > &arguments) {
                             
    if (DestState != 99){
        unsigned dest = DestState;
        ref<ConstantExpr> temp = Expr::createPointer(dest);
        llvm::errs() << "arg[0](value of destState) before klee_set_dest_state(): " << arguments[0] << "\n";
                
        arguments[0] = temp;
        
        llvm::errs() << "Assign destState value " << temp << " to state register!\n";
        llvm::errs() << "arg[0](value of destState) after klee_set_dest_state(): " << arguments[0] << "\n";
    }
    
    else
        return;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///arguments[1] -> assume condition ; arguments[0] -> address of set
void SpecialFunctionHandler::handleAddAssumeAsPC(ExecutionState &state,
                            KInstruction *target,
                            std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==2 && "invalid number of arguments to klee_assume");
  
  std::vector<ref<Expr> > ms;
  if (globalPCVctMap.find(arguments[0]) != globalPCVctMap.end()) 
    ms = globalPCVctMap[arguments[0]]; 
       
  ref<Expr> e = arguments[1];
  
  if (e->getWidth() != Expr::Bool)
    e = NeExpr::create(e, ConstantExpr::create(0, e->getWidth()));
  
  bool res;
  bool success __attribute__ ((unused)) = executor.solver->mustBeFalse(state, e, res);
  assert(success && "FIXME: Unhandled solver failure");
  if (res) {
    if (SilentKleeAssume) {
      executor.terminateState(state);
    } else {
      executor.terminateStateOnError(state,
                                     "invalid klee_assume call (provably false)",
                                     Executor::User);
    }
  } else {
    ms.push_back(e);
    globalPCVctMap[arguments[0]] = ms;
    //executor.addConstraint(state, e);
  }
}

////////////////////////////////////For clear PC//////////////////////////////////////
void SpecialFunctionHandler::handleClearPCGlobally(ExecutionState &state,
                             KInstruction *target,
                             std::vector<ref<Expr> > &arguments) {
    std::vector<ref<Expr> > ms;

    if (globalPCVctMap.find(arguments[0]) != globalPCVctMap.end()) 
       ms = globalPCVctMap[arguments[0]]; 
    
    //clear state constraints
    state.constraints.clear();
    
    //add assumption to pc
    for (auto v : ms) {
        llvm::errs() << "Constraint in globalPCVctMap: " << v << "\n";
        state.addConstraint(v);
    }
}   


////////////////////////////////////For analyze deep Trojan with Assume//////////////////////////////////////

void SpecialFunctionHandler::handleCheckAndRecordPCWithAssumeGlobally(ExecutionState &state,
                             KInstruction *target,
                             std::vector<ref<Expr> > &arguments) {
    std::vector<ref<Expr> > ms;
    std::set<ref<Expr> > ass; //assertSignalSet
    llvm::errs() << "Calling function klee_check_and_record_path_condition_with_assume(): \n arg[1] (assumption) = " << arguments[1] << "\n";  
                 
    if (globalPCVctMap.find(arguments[0]) != globalPCVctMap.end()) 
       ms = globalPCVctMap[arguments[0]];
           
    //////For the case that give ONE assumption
    if (arguments.size()==2) {
       ref<Expr> e = arguments[1];
       
       llvm::errs() << "Condition BEFORE NeExpr::create():" << e << "\n";
       if (e->getWidth() != Expr::Bool){
          e = NeExpr::create(e, ConstantExpr::create(0, e->getWidth()));
          llvm::errs() << "Condition AFTER NeExpr::create():" << e << "\n";
       }
       
       bool result=false;
       bool satisfyAssume = executor.solver->mayBeTrue(state, e, result);
       
       //ref<ConstantExpr> conste;
       //executor.solver->getValue(state, e, conste);
       //llvm::errs() << "Possible value for e: " << conste << "\n";   
       
       if (satisfyAssume && result) {
           ms.push_back(e);
           globalPCVctMap[arguments[0]] = ms;
           llvm::errs() << "Assume condition ***Maybe TRUE***! after simplifyExpr(): " << e << "\n";
           
           state.addConstraint(e);
           ref<ConstantExpr> conste;
           executor.solver->getValue(state, e, conste);
           llvm::errs() << "Possible value for e: " << conste << "\n";         
        }
       
       else {
           llvm::errs() << "Assumption doesn't hold\n";
           executor.terminateStateOnError(state,"Assumption doesn't hold from klee_check_and_record_path_condition_with_assume",
                                     Executor::User);
      }
  }            
    //////////////Begin: collect current PC and add Assumption(s)
    /*std::vector<ref<Expr>> pcConditiontemp = state.constraints.getConstraints();
    ref<Expr> pcCondition = NULL;
    std::vector< ref<Expr> >::const_iterator vi_current = pcConditiontemp.begin();
    while (vi_current != pcConditiontemp.end()) {
        if (pcCondition.isNull())
            pcCondition = *vi_current;
        else
            pcCondition = AndExpr::create(*vi_current, pcCondition);
        vi_current++;
    }
    //ms.push_back(pcCondition);
    //globalPCVctMap[arguments[0]] = ms;
    llvm::errs() << "Current path condition: " << pcCondition << "\n";*/
    
    
    ////////////////End: collect current path condition
}

                  
////////////////////////////////////For analyze deep Trojan without Assume//////////////////////////////////////
void SpecialFunctionHandler::handleCheckAndRecordPCGlobally(ExecutionState &state,
                             KInstruction *target,
                             std::vector<ref<Expr> > &arguments) {
    std::vector<ref<Expr> > ms;
    std::set<ref<Expr> > ass; //assertSignalSet
    //state.constraints.clear();

    if (globalPCVctMap.find(arguments[0]) != globalPCVctMap.end()) 
       ms = globalPCVctMap[arguments[0]];   
             
    //////////////Begin: collect and check previous path condition
    ref<Expr> PrevpcCondition = NULL;
    std::vector< ref<Expr> >::const_iterator vi = ms.begin();
    while (vi != ms.end()) {
        if (PrevpcCondition.isNull())
            PrevpcCondition = *vi;
        else
            PrevpcCondition = AndExpr::create(*vi, PrevpcCondition);
        vi++;
    }
    //llvm::errs() << "Previous path condition: " << PrevpcCondition << "\n";
    state.addConstraint(PrevpcCondition);
    llvm::errs() << "Assumption coindition from step #1: " << PrevpcCondition << "\n";

	  //std::vector<ref<Expr>> vf;
    //const std::vector<ref<Expr>> &vrFake = vf;
	  //ExecutionState *fake = new ExecutionState(vrFake);    
	  //executor.solver->setTimeout(executor.coreSolverTimeout);
    
    bool PrevPCSol;
    bool satisfyPrevPC = false;
    if (!PrevpcCondition.isNull())
        satisfyPrevPC = executor.solver->mayBeTrue(state, PrevpcCondition, PrevPCSol);
            
    if (!(satisfyPrevPC && PrevPCSol)) {
        executor.terminateStateOnError(state,"Previous PC doesn't satisfy from klee_check_and_record_path_condition",
                                     Executor::User);
    }
    else
      llvm::errs() << "Previous PC satisfied from klee_check_and_record_path_condition()!\n";
    ////////////////End: collect and check previous path condition 
        
    //////////////Begin: collect current path condition and add previous PC
    std::vector<ref<Expr>> pcConditiontemp = state.constraints.getConstraints();
    ref<Expr> pcCondition = NULL;
    std::vector< ref<Expr> >::const_iterator vi_current = pcConditiontemp.begin();
    while (vi_current != pcConditiontemp.end()) {
        if (pcCondition.isNull())
            pcCondition = *vi_current;
        else
            pcCondition = AndExpr::create(*vi_current, pcCondition);
        vi_current++;
    }
    //ms.push_back(pcCondition);
    //globalPCVctMap[arguments[0]] = ms;
    llvm::errs() << "Current path condition: " << pcCondition << "\n"; 
    
    bool CurrentPCSol;
    bool satisfyCurrentPC = false;
    if (!pcCondition.isNull())
        satisfyCurrentPC = executor.solver->mayBeTrue(state, pcCondition, CurrentPCSol);
     
    if (!(satisfyCurrentPC && CurrentPCSol)) {
        executor.terminateStateOnError(state,"Current PC doesn't satisfy",
                                     Executor::User);
    }
    ////////////////End: collect current path condition
}


////////////////////////////////////Get input sequence/////////////////////////////
void SpecialFunctionHandler::handleAcquireInputPatternGlobally(ExecutionState &state,
                             KInstruction *target,
                             std::vector<ref<Expr> > &arguments) {
    std::vector<ref<Expr> > ms;
    
    if (globalPCVctMap.find(arguments[0]) != globalPCVctMap.end()) 
       ms = globalPCVctMap[arguments[0]];    
        
    /*ref<Expr> VctPC = NULL;
    std::vector< ref<Expr> >::const_iterator vi = ms.begin();
    for (auto vi : ms) {
        vi = fakeDest->constraints.simplifyExpr(vi);
        static int i = 0;
        
        bool viRes;
        if (vi->getKind() == Expr::Constant){
             llvm::errs() << "\nIgnoring No." <<  i << " pc; which is: \n" << vi << "\n\n";
            continue;
        }
        
        else {
            llvm::errs() << "\nAdding No." <<  i << " pc; " ;
            fakeDest->addConstraint(vi);
            llvm::errs() << "\nPath condition in vector: " << vi << "\n";
        }
         i++;
    }
    llvm::errs() << "\n";*/
    llvm::errs() << "arguments[1]=" << arguments[1] << "\narguments[2]=" << arguments[2] << "\narguments[3]=" << arguments[3] << "\narguments[4]=" << arguments[4] << "\narguments[5]=" << arguments[5] << "\narguments[6]=" << arguments[6]<< "\n";
    
	  //std::vector<ref<Expr>> vf;
    //const std::vector<ref<Expr>> &vrFake = vf;
	  //ExecutionState *fake = new ExecutionState(vrFake);    
	  //executor.solver->setTimeout(executor.coreSolverTimeout);
     
    ref<ConstantExpr> arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12;
    bool teminateStateforInvalidArg = true; 
    
    //////////arguments[1]////////////////
    ConstantExpr *constantarg1 = dyn_cast<ConstantExpr>(arguments[1]);
    if (constantarg1)
        llvm::errs() << "Value for arg1: " << *constantarg1 << "\n";
    else {
        bool arg1Res; 
        bool arg1Success = executor.solver->mayBeTrue(state, arguments[1], arg1Res);
        //llvm::errs() << "arg1Success=" << arg1Success << "; arg1Res=" << arg1Res << "\n";
       
        if (arg1Success && arg1Res) {
            executor.solver->getValue(state, arguments[1], arg1);
            //executor.solver->getValue(*fake, arguments[1], arg1);
	          llvm::errs() << "Value for arg1: " << arg1->getZExtValue() << "\n";
        }
        else {
             llvm::errs() << "Value for arg1 CANNOT FOUND!\n";
             teminateStateforInvalidArg = false;
             //executor.terminateStateOnError(state,"Value for arg1 CANNOT FOUND!", Executor::User);
        }
    }
    //2>&1 | tee temp.txt
    //////////arguments[2]////////////////
    ConstantExpr *constantarg2 = dyn_cast<ConstantExpr>(arguments[2]);
    if (constantarg2)
        llvm::errs() << "Value for arg2: " << *constantarg2 << "\n";
    else {
        bool arg2Res; 
        bool arg2Success = executor.solver->mayBeTrue(state, arguments[2], arg2Res);
        //llvm::errs() << "arg2Success=" << arg2Success << "; arg2Res=" << arg2Res << "\n";
       
        if (arg2Success && arg2Res) {
            executor.solver->getValue(state, arguments[2], arg2);
            //executor.solver->getValue(*fake, arguments[2], arg2);
	          llvm::errs() << "Value for arg2 " << arg2->getZExtValue() << "\n";
        } 
        else {
             llvm::errs() << "Value for arg2 CANNOT FOUND!\n";
             teminateStateforInvalidArg = false;
             //executor.terminateStateOnError(state,"Value for arg2 CANNOT FOUND!", Executor::User);
        }
    }
    
    //////////arguments[3]////////////////
    ConstantExpr *constantarg3 = dyn_cast<ConstantExpr>(arguments[3]);
    if (constantarg3)
        llvm::errs() << "Value for arg3: " << *constantarg3 << "\n";
    else {
        bool arg3Res; 
        bool arg3Success = executor.solver->mayBeTrue(state, arguments[3], arg3Res);
        //llvm::errs() << "arg3Success=" << arg3Success << "; arg3Res=" << arg3Res << "\n";
       
        if (arg3Success && arg3Res) {
            executor.solver->getValue(state, arguments[3], arg3);
            //executor.solver->getValue(*fake, arguments[3], arg3);
	          llvm::errs() << "Value for arg3: " << arg3->getZExtValue() << "\n";
        }
        else {
             llvm::errs() << "Value for arg3 CANNOT FOUND!\n";
             teminateStateforInvalidArg = false;
             //executor.terminateStateOnError(state,"Value for arg3 CANNOT FOUND!", Executor::User);
        }
    }
    //////////arguments[4]////////////////
    ConstantExpr *constantarg4 = dyn_cast<ConstantExpr>(arguments[4]);
    if (constantarg4)
        llvm::errs() << "Value for arg4: " << *constantarg4 << "\n";
    else {
        bool arg4Res; 
        bool arg4Success = executor.solver->mayBeTrue(state, arguments[4], arg4Res);
        //llvm::errs() << "arg4Success=" << arg4Success << "; arg4Res=" << arg4Res << "\n";
       
        if (arg4Success && arg4Res) {
            executor.solver->getValue(state, arguments[4], arg4);
            //executor.solver->getValue(*fake, arguments[4], arg4);
	          llvm::errs() << "Value for arg4: " << arg4->getZExtValue() << "\n";
        }
        else {
             llvm::errs() << "Value for arg4 CANNOT FOUND!\n";
             teminateStateforInvalidArg = false;
             //executor.terminateStateOnError(state,"Value for arg4 CANNOT FOUND!", Executor::User);
        }
    }
    
    //////////arguments[5]////////////////
    ConstantExpr *constantarg5 = dyn_cast<ConstantExpr>(arguments[5]);
    if (constantarg5)
        llvm::errs() << "Value for arg5: " << *constantarg5 << "\n";
    else {
        bool arg5Res; 
        bool arg5Success = executor.solver->mayBeTrue(state, arguments[5], arg5Res);
        //llvm::errs() << "arg5Success=" << arg5Success << "; arg5Res=" << arg5Res << "\n";
       
        if (arg5Success && arg5Res) {
            executor.solver->getValue(state, arguments[5], arg5);
            //executor.solver->getValue(*fake, arguments[5], arg5);
	          llvm::errs() << "Value for arg5: " << arg5->getZExtValue() << "\n";
        }
        else {
             llvm::errs() << "Value for arg5 CANNOT FOUND!\n";
             teminateStateforInvalidArg = false;
             //executor.terminateStateOnError(state,"Value for arg5 CANNOT FOUND!", Executor::User);
        }
    }

    //////////arguments[6]////////////////
    ConstantExpr *constantarg6 = dyn_cast<ConstantExpr>(arguments[6]);
    if (constantarg6)
        llvm::errs() << "Value for arg6: " << *constantarg6 << "\n";
    else {
        bool arg6Res; 
        bool arg6Success = executor.solver->mayBeTrue(state, arguments[6], arg6Res);
        //llvm::errs() << "arg6Success=" << arg6Success << "; arg6Res=" << arg6Res << "\n";
       
        if (arg6Success && arg6Res) {
            executor.solver->getValue(state, arguments[6], arg6);
            //executor.solver->getValue(*fake, arguments[6], arg6);
	          llvm::errs() << "Value for arg6: " << arg6->getZExtValue() << "\n";
        }
        else {
             llvm::errs() << "Value for arg6 CANNOT FOUND!\n";
             teminateStateforInvalidArg = false;
             //executor.terminateStateOnError(state,"Value for arg6 CANNOT FOUND!", Executor::User);
        }
    }
        
    if (teminateStateforInvalidArg==false)
        executor.terminateStateOnError(state,"Value for arg* CANNOT FOUND!", Executor::User);
    else 
        llvm::errs() << "***Possible value for ALL arguments can be found!***\n";
    /*
    //////////arguments[6]////////////////
    bool arg6Res; 
    bool arg6Success = executor.solver->mayBeTrue(state, arguments[6], arg6Res);      
    llvm::errs() << "arg6Success=" << arg6Success << "; arg6Res=" << arg6Res << "\n";
       
    if (arg6Success && arg6Res) {
        executor.solver->getValue(state, arguments[6], arg6);
	      llvm::errs() << "Value for arg6: " << arg6->getZExtValue() << "\n";
    }   
    
    //////////arguments[7]////////////////
    bool arg7Res; 
    bool arg7Success = executor.solver->mayBeTrue(state, arguments[7], arg7Res);      
    llvm::errs() << "arg7Success=" << arg7Success << "; arg7Res=" << arg7Res << "\n";
       
    if (arg7Success && arg7Res) {
        executor.solver->getValue(state, arguments[7], arg7);
	      llvm::errs() << "Value for arg7: " << arg7->getZExtValue() << "\n";
    }
 
    //////////arguments[8]////////////////
    bool arg8Res; 
    bool arg8Success = executor.solver->mayBeTrue(state, arguments[8], arg8Res);      
    llvm::errs() << "arg8Success=" << arg8Success << "; arg8Res=" << arg8Res << "\n";
       
    if (arg8Success && arg8Res) {
        executor.solver->getValue(state, arguments[8], arg8);
	      llvm::errs() << "Value for arg8: " << arg8->getZExtValue() << "\n";
    }

    //////////arguments[9]////////////////
    bool arg9Res; 
    bool arg9Success = executor.solver->mayBeTrue(state, arguments[9], arg9Res);      
    llvm::errs() << "arg9Success=" << arg9Success << "; arg9Res=" << arg9Res << "\n";
       
    if (arg9Success && arg9Res) {
        executor.solver->getValue(state, arguments[9], arg9);
	      llvm::errs() << "Value for arg9: " << arg9->getZExtValue() << "\n";
    }
    
    //////////arguments[10]////////////////
    bool arg10Res; 
    bool arg10Success = executor.solver->mayBeTrue(state, arguments[10], arg10Res);      
    llvm::errs() << "arg10Success=" << arg10Success << "; arg10Res=" << arg10Res << "\n";
       
    if (arg10Success && arg10Res) {
        executor.solver->getValue(state, arguments[10], arg10);
	      llvm::errs() << "Value for arg10: " << arg10->getZExtValue() << "\n";
    }  

    //////////arguments[11]////////////////
    bool arg11Res; 
    bool arg11Success = executor.solver->mayBeTrue(state, arguments[11], arg11Res);      
    llvm::errs() << "arg11Success=" << arg11Success << "; arg11Res=" << arg11Res << "\n";
       
    if (arg11Success && arg11Res) {
        executor.solver->getValue(state, arguments[11], arg11);
	      llvm::errs() << "Value for arg11: " << arg11->getZExtValue() << "\n";
    } 
    
    //////////arguments[12]////////////////
    bool arg12Res; 
    bool arg12Success = executor.solver->mayBeTrue(state, arguments[12], arg12Res);      
    llvm::errs() << "arg12Success=" << arg12Success << "; arg12Res=" << arg12Res << "\n";
       
    if (arg12Success && arg12Res) {
        executor.solver->getValue(state, arguments[12], arg12);
	      llvm::errs() << "Value for arg12: " << arg12->getZExtValue() << "\n";
    }*/
                                    
    /*   	  
    executor.solver->getValue(*fakeDest, arguments[1], arg1);
	  llvm::errs() << "Value for arg1: " << arg1->getZExtValue() << "\n";

    executor.solver->getValue(*fakeDest, arguments[2], arg2);
	  llvm::errs() << "Value for arg2: " << arg2->getZExtValue() << "\n";
    
    executor.solver->getValue(*fakeDest, arguments[3], arg3);
	  llvm::errs() << "Value for arg3: " << arg3->getZExtValue() << "\n";
    
    executor.solver->getValue(*fakeDest, arguments[4], arg4);
	  llvm::errs() << "Value for arg4: " << arg4->getZExtValue() << "\n";
    
    executor.solver->getValue(*fakeDest, arguments[5], arg5);
	  llvm::errs() << "Value for arg5: " << arg5->getZExtValue() << "\n";
    
    executor.solver->getValue(*fakeDest, arguments[6], arg6);
	  llvm::errs() << "Value for arg6: " << arg6->getZExtValue() << "\n";
    
    executor.solver->getValue(*fakeDest, arguments[7], arg7);
	  llvm::errs() << "Value for arg7: " << arg7->getZExtValue() << "\n";
    
    executor.solver->getValue(*fakeDest, arguments[8], arg8);
	  llvm::errs() << "Value for arg8: " << arg8->getZExtValue() << "\n";
    
    executor.solver->getValue(*fakeDest, arguments[9], arg9);
	  llvm::errs() << "Value for arg9: " << arg9->getZExtValue() << "\n";
    
    executor.solver->getValue(*fakeDest, arguments[10], arg10);
	  llvm::errs() << "Value for arg10: " << arg10->getZExtValue() << "\n";
    
    executor.solver->getValue(*fakeDest, arguments[11], arg11);
	  llvm::errs() << "Value for arg11: " << arg11->getZExtValue() << "\n";
    
    executor.solver->getValue(*fakeDest, arguments[12], arg12);
	  llvm::errs() << "Value for arg12: " << arg12->getZExtValue() << "\n";     
    */
}

////////////////////////////////////Get input sequence/////////////////////////////
void SpecialFunctionHandler::handleAcquireInputPatternPreviousCycleGlobally(ExecutionState &state,
                             KInstruction *target,
                             std::vector<ref<Expr> > &arguments) {
    std::vector<ref<Expr> > ms;
    
    if (globalPCVctMap.find(arguments[0]) != globalPCVctMap.end()) 
       ms = globalPCVctMap[arguments[0]];    
        
    llvm::errs() << "prev_arguments[1]=" << arguments[1] << "\nprev_arguments[2]=" << arguments[2] << "\nprev_arguments[3]=" << arguments[3] << "\nprev_arguments[4]=" << arguments[4] << "\nprev_arguments[5]=" << arguments[5] << "\nprev_arguments[6]=" << arguments[6]<< "\n";
    
	  //std::vector<ref<Expr>> vf;
    //const std::vector<ref<Expr>> &vrFake = vf;
	  //ExecutionState *fake = new ExecutionState(vrFake);    
	  //executor.solver->setTimeout(executor.coreSolverTimeout);
     
    ref<ConstantExpr> arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12;
    bool teminateStateforInvalidArg = true; 
    
    //////////arguments[1]////////////////
    ConstantExpr *constantarg1 = dyn_cast<ConstantExpr>(arguments[1]);
    if (constantarg1)
        llvm::errs() << "Value for prev_arg1: " << *constantarg1 << "\n";
    else {
        bool arg1Res; 
        bool arg1Success = executor.solver->mayBeTrue(state, arguments[1], arg1Res);
        //llvm::errs() << "arg1Success=" << arg1Success << "; arg1Res=" << arg1Res << "\n";
       
        if (arg1Success && arg1Res) {
            executor.solver->getValue(state, arguments[1], arg1);
            //executor.solver->getValue(*fake, arguments[1], arg1);
	          llvm::errs() << "Value for prev_arg1: " << arg1->getZExtValue() << "\n";
        }
        else {
             llvm::errs() << "Value for prev_arg1 CANNOT FOUND!\n";
             teminateStateforInvalidArg = false;
             //executor.terminateStateOnError(state,"Value for arg1 CANNOT FOUND!", Executor::User);
        }
    }
    //2>&1 | tee temp.txt
    //////////arguments[2]////////////////
    ConstantExpr *constantarg2 = dyn_cast<ConstantExpr>(arguments[2]);
    if (constantarg2)
        llvm::errs() << "Value for prev_arg2: " << *constantarg2 << "\n";
    else {
        bool arg2Res; 
        bool arg2Success = executor.solver->mayBeTrue(state, arguments[2], arg2Res);
        //llvm::errs() << "arg2Success=" << arg2Success << "; arg2Res=" << arg2Res << "\n";
       
        if (arg2Success && arg2Res) {
            executor.solver->getValue(state, arguments[2], arg2);
            //executor.solver->getValue(*fake, arguments[2], arg2);
	          llvm::errs() << "Value for prev_arg2 " << arg2->getZExtValue() << "\n";
        } 
        else {
             llvm::errs() << "Value for prev_arg2 CANNOT FOUND!\n";
             teminateStateforInvalidArg = false;
             //executor.terminateStateOnError(state,"Value for arg2 CANNOT FOUND!", Executor::User);
        }
    }
    
    //////////arguments[3]////////////////
    ConstantExpr *constantarg3 = dyn_cast<ConstantExpr>(arguments[3]);
    if (constantarg3)
        llvm::errs() << "Value for prev_arg3: " << *constantarg3 << "\n";
    else {
        bool arg3Res; 
        bool arg3Success = executor.solver->mayBeTrue(state, arguments[3], arg3Res);
        //llvm::errs() << "arg3Success=" << arg3Success << "; arg3Res=" << arg3Res << "\n";
       
        if (arg3Success && arg3Res) {
            executor.solver->getValue(state, arguments[3], arg3);
            //executor.solver->getValue(*fake, arguments[3], arg3);
	          llvm::errs() << "Value for prev_arg3: " << arg3->getZExtValue() << "\n";
        }
        else {
             llvm::errs() << "Value for prev_arg3 CANNOT FOUND!\n";
             teminateStateforInvalidArg = false;
             //executor.terminateStateOnError(state,"Value for arg3 CANNOT FOUND!", Executor::User);
        }
    }
    //////////arguments[4]////////////////
    ConstantExpr *constantarg4 = dyn_cast<ConstantExpr>(arguments[4]);
    if (constantarg4)
        llvm::errs() << "Value for prev_arg4: " << *constantarg4 << "\n";
    else {
        bool arg4Res; 
        bool arg4Success = executor.solver->mayBeTrue(state, arguments[4], arg4Res);
        //llvm::errs() << "arg4Success=" << arg4Success << "; arg4Res=" << arg4Res << "\n";
       
        if (arg4Success && arg4Res) {
            executor.solver->getValue(state, arguments[4], arg4);
            //executor.solver->getValue(*fake, arguments[4], arg4);
	          llvm::errs() << "Value for prev_arg4: " << arg4->getZExtValue() << "\n";
        }
        else {
             llvm::errs() << "Value for prev_arg4 CANNOT FOUND!\n";
             teminateStateforInvalidArg = false;
             //executor.terminateStateOnError(state,"Value for arg4 CANNOT FOUND!", Executor::User);
        }
    }
    
    //////////arguments[5]////////////////
    ConstantExpr *constantarg5 = dyn_cast<ConstantExpr>(arguments[5]);
    if (constantarg5)
        llvm::errs() << "Value for prev_arg5: " << *constantarg5 << "\n";
    else {
        bool arg5Res; 
        bool arg5Success = executor.solver->mayBeTrue(state, arguments[5], arg5Res);
        //llvm::errs() << "arg5Success=" << arg5Success << "; arg5Res=" << arg5Res << "\n";
       
        if (arg5Success && arg5Res) {
            executor.solver->getValue(state, arguments[5], arg5);
            //executor.solver->getValue(*fake, arguments[5], arg5);
	          llvm::errs() << "Value for prev_arg5: " << arg5->getZExtValue() << "\n";
        }
        else {
             llvm::errs() << "Value for prev_arg5 CANNOT FOUND!\n";
             teminateStateforInvalidArg = false;
             //executor.terminateStateOnError(state,"Value for arg5 CANNOT FOUND!", Executor::User);
        }
    }

    //////////arguments[6]////////////////
    ConstantExpr *constantarg6 = dyn_cast<ConstantExpr>(arguments[6]);
    if (constantarg6)
        llvm::errs() << "Value for prev_arg6: " << *constantarg6 << "\n";
    else {
        bool arg6Res; 
        bool arg6Success = executor.solver->mayBeTrue(state, arguments[6], arg6Res);
        //llvm::errs() << "arg6Success=" << arg6Success << "; arg6Res=" << arg6Res << "\n";
       
        if (arg6Success && arg6Res) {
            executor.solver->getValue(state, arguments[6], arg6);
            //executor.solver->getValue(*fake, arguments[6], arg6);
	          llvm::errs() << "Value for prev_arg6: " << arg6->getZExtValue() << "\n";
        }
        else {
             llvm::errs() << "Value for prev_arg6 CANNOT FOUND!\n";
             teminateStateforInvalidArg = false;
             //executor.terminateStateOnError(state,"Value for arg6 CANNOT FOUND!", Executor::User);
        }
    }
        
    if (teminateStateforInvalidArg==false)
        llvm::errs() << "***Possible value for Some prev_arguments can NOT be found!***\n";//executor.terminateStateOnError(state,"Value for prev_arg* CANNOT FOUND!", Executor::User);
    else 
        llvm::errs() << "***Possible value for ALL prev_arguments can be found!***\n";
}


// Versym extension begin: Record the instructions executed in the last step, e.g., clock cycle.
void SpecialFunctionHandler::handleRecordStepTraceLocally(ExecutionState &state,
                                               KInstruction *target,
                                               std::vector<ref<Expr> > &arguments) {
   /*ConstantExpr *CE = dyn_cast<ConstantExpr>(arguments[0]);
   assert(CE && "Step no must be concrete!\n");
   int stepNo = CE->getZExtValue();
   llvm::errs() << "Recording step " << stepNo << "\n";
   std::map<int, std::vector<KInstruction*> > sm;
   if (stepInstructionMap.find((long)&state) != stepInstructionMap.end())
      sm = stepInstructionMap[(long)&state];
   if (sm.find(stepNo) == sm.end()) {
      sm[stepNo] = state.lastStep;
      llvm::errs() << "Recording " << sm[stepNo].size() << "instructions\n";   
      state.lastStep.clear();
      stepInstructionMap[(long)&state] = sm; 
   } 
   state.stepStartIndex[stepNo+1] = state.lastStepVC.size(); */
   /*std::map<int, std::vector<ValuedContext> > vm;
   if (stepContextMap.find((long)&state) != stepContextMap.end())
      vm = stepContextMap[(long)&state];
   if (vm.find(stepNo) == vm.end()) { 
      std::vector<ValuedContext> v;
      for(unsigned i=0; i<state.lastStepVC.size(); i++) {
         ValuedContext vc;
         for(unsigned j=0; j < state.lastStepVC[i].second.second.size(); j++)
            vc.second.second.push_back(state.lastStepVC[i].second.second[j]);
         vc.first = state.lastStepVC[i].first;
         vc.second.first = state.lastStepVC[i].second.first; 
         v.push_back(vc);
      }
      stepContextMap[(long)&state].insert(std::make_pair(stepNo,v)); 
   }*/
}
// Versym extension end: Record the instructions executed in the last step, e.g., clock cycle.

////////////////////////////For 1 input variable FSM function////////////////////////////////////
void SpecialFunctionHandler::handleAddMetadataGlobally(ExecutionState &state,
                             KInstruction *target,
                             std::vector<ref<Expr> > &arguments) {
    //llvm::errs() << "Calling function klee_add_metadata_globally():\n";
                                 
    std::set<ref<Expr> > ms;
    std::set<ref<Expr> > msInput;//container for input variable
    //llvm::errs() << "Value of arg[1] in forward execution " << arguments[1] << "\n";
    if (globalMetadataSetMap.find(arguments[0]) != globalMetadataSetMap.end()) 
       ms = globalMetadataSetMap[arguments[0]]; 

    bool terminateSuccess = false;
    ConstantExpr *constarg1 = dyn_cast<ConstantExpr>(arguments[1]);
    
    ref<ConstantExpr> arg1;
    
	  std::vector<ref<Expr>> vf;
    const std::vector<ref<Expr>> &vrFake = vf;
	  ExecutionState *fake = new ExecutionState(vrFake);
	  executor.solver->setTimeout(executor.coreSolverTimeout);
             
    if (constarg1){
        for (auto v : ms){
            ConstantExpr *constv = dyn_cast<ConstantExpr>(v);
                if (constv->getZExtValue() == constarg1->getZExtValue()){
                    terminateSuccess = true;
                    break;
                }
            
                else 
                    continue;
        }
    }
    /*else{
        executor.solver->getValue(*fake, arguments[1], arg1);
        for (auto v : ms){
            ConstantExpr *constv = dyn_cast<ConstantExpr>(v);
                if (constv->getZExtValue() == constarg1->getZExtValue()){
                    terminateSuccess = true;
                    break;
                }
            
                else 
                    continue;
        }
    }*/
           
    
    if (PruningMode == true){
        if (terminateSuccess == true){
            //llvm::errs() << "terminate state" <<  arguments[1] << "successfully \n";
            executor.terminateState(state);
            return;
        }
        
        else{
            if(constarg1){
                ms.insert(arguments[1]);
            }
            
            else{
   	            ////Begin: Convert symbolic arguments[1] to concrete arguments[1]////
                std::pair<ref<Expr>, ref<Expr>> rsSymbolic1 = executor.solver->getRange(state, arguments[1]);
        
                ref<Expr> rsSymbolicFirst1 = rsSymbolic1.first;
                auto rsSymbolicFirstConstant1 = dyn_cast<ConstantExpr>(rsSymbolicFirst1);
                uint64_t rsSymbolicFirstUint1 = rsSymbolicFirstConstant1->getZExtValue();
        
                ref<Expr> rsSymbolicSecond1 = rsSymbolic1.second;
                auto rsSymbolicSecondConstant1 = dyn_cast<ConstantExpr>(rsSymbolicSecond1);
                uint64_t rsSymbolicSecondUint1 = rsSymbolicSecondConstant1->getZExtValue();
        
                for(auto v1 = rsSymbolicFirstUint1; v1 <= rsSymbolicSecondUint1; v1++){
                    auto v2 = v1;
                    //rsConcrete.insert(ConstantExpr::create(v2, arguments[2]->getWidth()));
                    ms.insert(ConstantExpr::create(v2, arguments[1]->getWidth())); 
                }
                ////End: Convert symbolic arguments[1] to concrete arguments[1]////
           }
        }
    }
    
    else{
    
        ConstantExpr *constantarg1 = dyn_cast<ConstantExpr>(arguments[1]);
        if(constantarg1){
            ms.insert(arguments[1]);
        }
        else{
   	        ////Begin: Convert symbolic arguments[1] to concrete arguments[1]////
            std::pair<ref<Expr>, ref<Expr>> rsSymbolic = executor.solver->getRange(state, arguments[1]);
        
            ref<Expr> rsSymbolicFirst = rsSymbolic.first;
            auto rsSymbolicFirstConstant = dyn_cast<ConstantExpr>(rsSymbolicFirst);
            uint64_t rsSymbolicFirstUint = rsSymbolicFirstConstant->getZExtValue();
        
            ref<Expr> rsSymbolicSecond = rsSymbolic.second;
            auto rsSymbolicSecondConstant = dyn_cast<ConstantExpr>(rsSymbolicSecond);
            uint64_t rsSymbolicSecondUint = rsSymbolicSecondConstant->getZExtValue();
        
            for(auto v1 = rsSymbolicFirstUint; v1 <= rsSymbolicSecondUint; v1++){
                auto v2 = v1;
                ms.insert(ConstantExpr::create(v2, arguments[1]->getWidth())); 
            }
                ////End: Convert symbolic arguments[1] to concrete arguments[1]////
           } 
        }
    globalMetadataSetMap[arguments[0]] = ms;
    /*for(auto v : ms){
       llvm::errs() << "reachable states from add_meta_global: " << v << "\n";      
       std::string Str4;
	     llvm::raw_string_ostream info4(Str4);
       ExprPPrinter::printSingleExpr(info4, v);
       llvm::errs() << " Adding metadata " << info4.str() << "to RS"; 
    }*/

    //llvm::errs() << "Adding metadata " << arguments[1] << " to the set of " << arguments[0] << "\n";
        
    if (globalInputSetMap.find(arguments[0]) != globalInputSetMap.end()) 
       msInput = globalInputSetMap[arguments[0]]; 
    msInput.insert(arguments[2]);
    //for(auto v1 : msInput)
       //llvm::errs() << "reachable input variable first: " << v1 << "\n";
    globalInputSetMap[arguments[0]] = msInput;
    //llvm::errs() << "Adding input variable " << arguments[2] << " to the set msInput\n";
    
      
}

////////////////////////////For 2 input variables FSM function////////////////////////////////////
void SpecialFunctionHandler::handleAddMetadataGloballyTwoInput(ExecutionState &state,
                             KInstruction *target,
                             std::vector<ref<Expr> > &arguments) {
    std::set<ref<Expr> > ms;
    std::set<ref<Expr> > msInput;//container for input variable
    std::set<ref<Expr> > msInputTwo;

    llvm::errs() << "Value of arg[1] in forward execution " << arguments[1] << "\n";
    if (globalMetadataSetMap.find(arguments[0]) != globalMetadataSetMap.end()) 
       ms = globalMetadataSetMap[arguments[0]]; 
       
    bool terminateSuccess = false;
    ConstantExpr *constarg1 = dyn_cast<ConstantExpr>(arguments[1]);
    if (constarg1){
        for (auto v : ms){
            ConstantExpr *constv = dyn_cast<ConstantExpr>(v);
            if (constv->getZExtValue() == constarg1->getZExtValue()){
                terminateSuccess = true;
                break;
            }
            
            else 
                continue;
        }
    }
    if (PruningMode == true){    
        if (terminateSuccess == true){
            llvm::errs() << "terminate state" <<  arguments[1] << "successfully \n";
            executor.terminateState(state);
            return;
        }

        else{
    
            ConstantExpr *constantarg1 = dyn_cast<ConstantExpr>(arguments[1]);
            if(constantarg1)
               ms.insert(arguments[1]); 
            else{                
                std::pair<ref<Expr>, ref<Expr>> rsSymbolic = executor.solver->getRange(state, arguments[1]);
        
                ref<Expr> rsSymbolicFirst = rsSymbolic.first;
                auto rsSymbolicFirstConstant = dyn_cast<ConstantExpr>(rsSymbolicFirst);
                uint64_t rsSymbolicFirstUint = rsSymbolicFirstConstant->getZExtValue();
        
                ref<Expr> rsSymbolicSecond = rsSymbolic.second;
                auto rsSymbolicSecondConstant = dyn_cast<ConstantExpr>(rsSymbolicSecond);
                uint64_t rsSymbolicSecondUint = rsSymbolicSecondConstant->getZExtValue();
        
                for(auto v1 = rsSymbolicFirstUint; v1 <= rsSymbolicSecondUint; v1++){
		               auto v2 = v1;
		               //rsConcrete.insert(ConstantExpr::create(v2, arguments[2]->getWidth()));
                   ms.insert(ConstantExpr::create(v2, arguments[1]->getWidth())); 
                }
           } 	    

        }
    }    
    else{
        ConstantExpr *constantarg2 = dyn_cast<ConstantExpr>(arguments[1]);
        if(constantarg2)
           ms.insert(arguments[1]); 
        else{             
             std::pair<ref<Expr>, ref<Expr>> rsSymbolic2 = executor.solver->getRange(state, arguments[1]);
        
             ref<Expr> rsSymbolicFirst2 = rsSymbolic2.first;
             auto rsSymbolicFirstConstant2 = dyn_cast<ConstantExpr>(rsSymbolicFirst2);
             uint64_t rsSymbolicFirstUint2 = rsSymbolicFirstConstant2->getZExtValue();
        
             ref<Expr> rsSymbolicSecond2 = rsSymbolic2.second;
             auto rsSymbolicSecondConstant2 = dyn_cast<ConstantExpr>(rsSymbolicSecond2);
             uint64_t rsSymbolicSecondUint2 = rsSymbolicSecondConstant2->getZExtValue();
        
             for(auto v1 = rsSymbolicFirstUint2; v1 <= rsSymbolicSecondUint2; v1++){
                 auto v2 = v1;
		             //rsConcrete.insert(ConstantExpr::create(v2, arguments[2]->getWidth()));
                 ms.insert(ConstantExpr::create(v2, arguments[1]->getWidth())); 
             }
         }     
    }
        //ms.insert(arguments[1]); 
 
    for(auto v : ms)
       llvm::errs() << "reachable states from add_meta_global: " << v << "\n";
    globalMetadataSetMap[arguments[0]] = ms;
    llvm::errs() << "Adding metadata " << arguments[1] << " to the set of " << arguments[0] << "\n";


    if (globalInputSetMap.find(arguments[0]) != globalInputSetMap.end()) 
       msInput = globalInputSetMap[arguments[0]]; 
    msInput.insert(arguments[2]);
    for(auto v1 : msInput)
       llvm::errs() << "reachable input variable first: " << v1 << "\n";
    globalInputSetMap[arguments[0]] = msInput;
    llvm::errs() << "Adding input variable " << arguments[2] << " to the set msInputFirst\n";

    if (globalTwoInputSetMap.find(arguments[0]) != globalTwoInputSetMap.end()) 
       msInputTwo = globalTwoInputSetMap[arguments[0]]; 
    msInputTwo.insert(arguments[3]);
    for(auto v2 : msInputTwo)
       llvm::errs() << "reachable input variable second: " << v2 << "\n";
    globalTwoInputSetMap[arguments[0]] = msInputTwo;
    llvm::errs() << "Adding input variable " << arguments[3] << " to the set msInputSecond\n";
}

////////////////////////////For 3 input variables FSM function////////////////////////////////////
void SpecialFunctionHandler::handleAddMetadataGloballyThreeInput(ExecutionState &state,
                             KInstruction *target,
                             std::vector<ref<Expr> > &arguments) {
    std::set<ref<Expr> > ms;
    std::set<ref<Expr> > msInput;//container for input variable
    std::set<ref<Expr> > msInputTwo;
    std::set<ref<Expr> > msInputThree;

    //llvm::errs() << "Value of arg[1] in forward execution " << arguments[1] << "\n";
    if (globalMetadataSetMap.find(arguments[0]) != globalMetadataSetMap.end()) 
       ms = globalMetadataSetMap[arguments[0]];
       
    bool terminateSuccess = false;
    ConstantExpr *constarg1 = dyn_cast<ConstantExpr>(arguments[1]);
    if (constarg1){
        for (auto v : ms){
            ConstantExpr *constv = dyn_cast<ConstantExpr>(v);
            if (constv->getZExtValue() == constarg1->getZExtValue()){
                terminateSuccess = true;
                break;
            }
            
            else 
                continue;
        }
    }
    
    if (PruningMode == true){      
        if (terminateSuccess == true){
            llvm::errs() << "terminate state" <<  arguments[1] << "successfully \n";
            executor.terminateState(state);
            return;
        }

        else{
    
            ConstantExpr *constarg1 = dyn_cast<ConstantExpr>(arguments[1]);
            if(constarg1)
               ms.insert(arguments[1]); 
            else{
          	    ////Begin: Convert symbolic arguments[1] to concrete arguments[1]////
                //std::set<ref<Expr> > rsConcrete;
                //ref<ConstantExpr> result;
                std::pair<ref<Expr>, ref<Expr>> rsSymbolic = executor.solver->getRange(state, arguments[1]);
        
                ref<Expr> rsSymbolicFirst = rsSymbolic.first;
                auto rsSymbolicFirstConstant = dyn_cast<ConstantExpr>(rsSymbolicFirst);
                uint64_t rsSymbolicFirstUint = rsSymbolicFirstConstant->getZExtValue();
        
                ref<Expr> rsSymbolicSecond = rsSymbolic.second;
                auto rsSymbolicSecondConstant = dyn_cast<ConstantExpr>(rsSymbolicSecond);
                uint64_t rsSymbolicSecondUint = rsSymbolicSecondConstant->getZExtValue();
        
                for(auto v1 = rsSymbolicFirstUint; v1 <= rsSymbolicSecondUint; v1++){
		               auto v2 = v1;
		               //rsConcrete.insert(ConstantExpr::create(v2, arguments[2]->getWidth()));
                   ms.insert(ConstantExpr::create(v2, arguments[1]->getWidth())); 
                }
                ////End: Convert symbolic arguments[1] to concrete arguments[1]////
           } 
       }
    }
    
    else{
        ConstantExpr *constantarg2 = dyn_cast<ConstantExpr>(arguments[1]);
        if(constantarg2)
           ms.insert(arguments[1]); 
        else{
             std::pair<ref<Expr>, ref<Expr>> rsSymbolic2 = executor.solver->getRange(state, arguments[1]);
        
             ref<Expr> rsSymbolicFirst2 = rsSymbolic2.first;
             auto rsSymbolicFirstConstant2 = dyn_cast<ConstantExpr>(rsSymbolicFirst2);
             uint64_t rsSymbolicFirstUint2 = rsSymbolicFirstConstant2->getZExtValue();
        
             ref<Expr> rsSymbolicSecond2 = rsSymbolic2.second;
             auto rsSymbolicSecondConstant2 = dyn_cast<ConstantExpr>(rsSymbolicSecond2);
             uint64_t rsSymbolicSecondUint2 = rsSymbolicSecondConstant2->getZExtValue();
        
             for(auto v1 = rsSymbolicFirstUint2; v1 <= rsSymbolicSecondUint2; v1++){
                 auto v2 = v1;
		             //rsConcrete.insert(ConstantExpr::create(v2, arguments[2]->getWidth()));
                 ms.insert(ConstantExpr::create(v2, arguments[1]->getWidth())); 
             }
         }       
    }
    //ms.insert(arguments[1]); 
         
    //for(auto v : ms)
       //llvm::errs() << "reachable states from add_meta_global: " << v << "\n";
    globalMetadataSetMap[arguments[0]] = ms;
    //llvm::errs() << "Adding metadata " << arguments[1] << " to the set of " << arguments[0] << "\n";

    ///////////////////////////////////1st input var.//////////////////////////////////////////
    if (globalInputSetMap.find(arguments[0]) != globalInputSetMap.end()) 
       msInput = globalInputSetMap[arguments[0]]; 
    msInput.insert(arguments[2]);
    //for(auto v1 : msInput)
       //llvm::errs() << "reachable input variable first: " << v1 << "\n";
    globalInputSetMap[arguments[0]] = msInput;
    //llvm::errs() << "Adding input variable " << arguments[2] << " to the set msInputFirst\n";
    ///////////////////////////////////2nd input var.//////////////////////////////////////////
    if (globalTwoInputSetMap.find(arguments[0]) != globalTwoInputSetMap.end()) 
       msInputTwo = globalTwoInputSetMap[arguments[0]]; 
    msInputTwo.insert(arguments[3]);
    //for(auto v2 : msInputTwo)
       //llvm::errs() << "reachable input variable second: " << v2 << "\n";
    globalTwoInputSetMap[arguments[0]] = msInputTwo;
    //llvm::errs() << "Adding input variable " << arguments[3] << " to the set msInputSecond\n";
    ///////////////////////////////////3rd input var.//////////////////////////////////////////
    if (globalThreeInputSetMap.find(arguments[0]) != globalThreeInputSetMap.end()) 
       msInputThree = globalThreeInputSetMap[arguments[0]]; 
    msInputThree.insert(arguments[4]);
    //for(auto v2 : msInputThree)
       //llvm::errs() << "reachable input variable second: " << v2 << "\n";
    globalThreeInputSetMap[arguments[0]] = msInputThree;
    //llvm::errs() << "Adding input variable " << arguments[4] << " to the set msInputSecond\n";
}

////////////////////////////For 4 input variables FSM function////////////////////////////////////
void SpecialFunctionHandler::handleAddMetadataGloballyFourInput(ExecutionState &state,
                             KInstruction *target,
                             std::vector<ref<Expr> > &arguments) {
    std::set<ref<Expr> > ms;
    std::set<ref<Expr> > msInput;//container for 1st input variable
    std::set<ref<Expr> > msInputTwo;//container for 2nd input variable
    std::set<ref<Expr> > msInputThree;//container for 3rd input variable
    std::set<ref<Expr> > msInputFourth;//container for 4st input variable

    llvm::errs() << "Value of arg[1] in forward execution " << arguments[1] << "\n";
    if (globalMetadataSetMap.find(arguments[0]) != globalMetadataSetMap.end()) 
       ms = globalMetadataSetMap[arguments[0]]; 
    ms.insert(arguments[1]);   
    for(auto v : ms)
       llvm::errs() << "reachable states from add_meta_global: " << v << "\n";
    globalMetadataSetMap[arguments[0]] = ms;
    llvm::errs() << "Adding metadata " << arguments[1] << " to the set of " << arguments[0] << "\n";

    ///////////////////////////////////1st input var.//////////////////////////////////////////
    if (globalInputSetMap.find(arguments[0]) != globalInputSetMap.end()) 
       msInput = globalInputSetMap[arguments[0]]; 
    msInput.insert(arguments[2]);
    for(auto v1 : msInput)
       llvm::errs() << "reachable input variable first: " << v1 << "\n";
    globalInputSetMap[arguments[0]] = msInput;
    llvm::errs() << "Adding input variable " << arguments[2] << " to the set msInputFirst\n";
    ///////////////////////////////////2nd input var.//////////////////////////////////////////
    if (globalTwoInputSetMap.find(arguments[0]) != globalTwoInputSetMap.end()) 
       msInputTwo = globalTwoInputSetMap[arguments[0]]; 
    msInputTwo.insert(arguments[3]);
    for(auto v2 : msInputTwo)
       llvm::errs() << "reachable input variable second: " << v2 << "\n";
    globalTwoInputSetMap[arguments[0]] = msInputTwo;
    llvm::errs() << "Adding input variable " << arguments[3] << " to the set msInputSecond\n";
    ///////////////////////////////////3rd input var.//////////////////////////////////////////
    if (globalThreeInputSetMap.find(arguments[0]) != globalThreeInputSetMap.end()) 
       msInputThree = globalThreeInputSetMap[arguments[0]]; 
    msInputThree.insert(arguments[4]);
    for(auto v2 : msInputThree)
       llvm::errs() << "reachable input variable second: " << v2 << "\n";
    globalThreeInputSetMap[arguments[0]] = msInputThree;
    llvm::errs() << "Adding input variable " << arguments[4] << " to the set msInputThird\n";
    ///////////////////////////////////4th input var.//////////////////////////////////////////
    if (globalFourInputSetMap.find(arguments[0]) != globalFourInputSetMap.end()) 
       msInputFourth = globalFourInputSetMap[arguments[0]]; 
    msInputFourth.insert(arguments[5]);
    for(auto v2 : msInputFourth)
       llvm::errs() << "reachable input variable second: " << v2 << "\n";
    globalFourInputSetMap[arguments[0]] = msInputFourth;
    llvm::errs() << "Adding input variable " << arguments[5] << " to the set msInputFourth\n";
}


////////////////////////////For 5 input variables FSM function////////////////////////////////////
void SpecialFunctionHandler::handleAddMetadataGloballyFiveInput(ExecutionState &state,
                             KInstruction *target,
                             std::vector<ref<Expr> > &arguments) {
    std::set<ref<Expr> > ms;
    std::set<ref<Expr> > msInput;//container for 1st input variable
    std::set<ref<Expr> > msInputTwo;//container for 2nd input variable
    std::set<ref<Expr> > msInputThree;//container for 3rd input variable
    std::set<ref<Expr> > msInputFourth;//container for 4st input variable
    std::set<ref<Expr> > msInputFive;//container for 4st input variable

    llvm::errs() << "Value of arg[1] in forward execution " << arguments[1] << "\n";
    if (globalMetadataSetMap.find(arguments[0]) != globalMetadataSetMap.end()) 
       ms = globalMetadataSetMap[arguments[0]]; 
    ms.insert(arguments[1]);   
    for(auto v : ms)
       llvm::errs() << "reachable states from add_meta_global: " << v << "\n";
    globalMetadataSetMap[arguments[0]] = ms;
    llvm::errs() << "Adding metadata " << arguments[1] << " to the set of " << arguments[0] << "\n";

    ///////////////////////////////////1st input var.//////////////////////////////////////////
    if (globalInputSetMap.find(arguments[0]) != globalInputSetMap.end()) 
       msInput = globalInputSetMap[arguments[0]]; 
    msInput.insert(arguments[2]);
    for(auto v1 : msInput)
       llvm::errs() << "reachable input variable first: " << v1 << "\n";
    globalInputSetMap[arguments[0]] = msInput;
    llvm::errs() << "Adding input variable " << arguments[2] << " to the set msInputFirst\n";
    ///////////////////////////////////2nd input var.//////////////////////////////////////////
    if (globalTwoInputSetMap.find(arguments[0]) != globalTwoInputSetMap.end()) 
       msInputTwo = globalTwoInputSetMap[arguments[0]]; 
    msInputTwo.insert(arguments[3]);
    for(auto v2 : msInputTwo)
       llvm::errs() << "reachable input variable second: " << v2 << "\n";
    globalTwoInputSetMap[arguments[0]] = msInputTwo;
    llvm::errs() << "Adding input variable " << arguments[3] << " to the set msInputSecond\n";
    ///////////////////////////////////3rd input var.//////////////////////////////////////////
    if (globalThreeInputSetMap.find(arguments[0]) != globalThreeInputSetMap.end()) 
       msInputThree = globalThreeInputSetMap[arguments[0]]; 
    msInputThree.insert(arguments[4]);
    for(auto v2 : msInputThree)
       llvm::errs() << "reachable input variable second: " << v2 << "\n";
    globalThreeInputSetMap[arguments[0]] = msInputThree;
    llvm::errs() << "Adding input variable " << arguments[4] << " to the set msInputThird\n";
    ///////////////////////////////////4th input var.//////////////////////////////////////////
    if (globalFourInputSetMap.find(arguments[0]) != globalFourInputSetMap.end()) 
       msInputFourth = globalFourInputSetMap[arguments[0]]; 
    msInputFourth.insert(arguments[5]);
    for(auto v2 : msInputFourth)
       llvm::errs() << "reachable input variable second: " << v2 << "\n";
    globalFourInputSetMap[arguments[0]] = msInputFourth;
    llvm::errs() << "Adding input variable " << arguments[5] << " to the set msInputFourth\n";
    ///////////////////////////////////5th input var.//////////////////////////////////////////
    if (globalFiveInputSetMap.find(arguments[0]) != globalFiveInputSetMap.end()) 
       msInputFive = globalFiveInputSetMap[arguments[0]]; 
    msInputFive.insert(arguments[6]);
    for(auto v2 : msInputFive)
       llvm::errs() << "reachable input variable second: " << v2 << "\n";
    globalFiveInputSetMap[arguments[0]] = msInputFive;
    llvm::errs() << "Adding input variable " << arguments[6] << " to the set msInputFive\n";
}


////////////////////////////////////////////////////////////////////////////////////////////////
void SpecialFunctionHandler::handleCheckMetadataMembershipLocally(ExecutionState &state,
                                                KInstruction *target,
                                                std::vector<ref<Expr> > &arguments) {

    std::map<ref<Expr>, std::set<ref<Expr> > > gm;
    if (localMetadataSetMap.find((long)&state) != localMetadataSetMap.end())
        gm = localMetadataSetMap[(long)&state];
    std::set<ref<Expr> > ms;
    if (gm.find(arguments[0]) != gm.end()) 
       ms = gm[arguments[0]]; 
    llvm::errs() << "Checking for membership of " << arguments[1] << "\n";
    llvm::errs() << "On the path with constraint:\n"; 
    ExprPPrinter::printConstraints(llvm::errs(), state.constraints);
    if (ms.find(arguments[1]) != ms.end()) {
       std::string message = readStringAtAddress(state, arguments[2]);
       llvm::errs() << (message == "" ? "Metadata membership holds! " : message) << arguments[1]
                    << " in the set of " << arguments[0] << "\n";
    }

}

void SpecialFunctionHandler::handleCheckMetadataMembershipGlobally(ExecutionState &state,
                                                KInstruction *target,
                                                std::vector<ref<Expr> > &arguments) {

    std::set<ref<Expr> > ms;
    if (globalMetadataSetMap.find(arguments[0]) != globalMetadataSetMap.end()) 
       ms = globalMetadataSetMap[arguments[0]]; 
    llvm::errs() << "Checking for membership of " << arguments[1] << "\n";
    if (ms.find(arguments[1]) != ms.end()) {
       std::string message = readStringAtAddress(state, arguments[2]);
       llvm::errs() << (message == "" ? "Metadata membership holds! " : message) << arguments[1]
                    << " in the set of " << arguments[0] << "\n";
    }

}


void SpecialFunctionHandler::handleReportDiffMetadataLocally(ExecutionState &state,
                                                KInstruction *target,
                                                std::vector<ref<Expr> > &arguments) {
    std::map<ref<Expr>, std::set<ref<Expr> > > gm;
    if (localMetadataSetMap.find((long)&state) != localMetadataSetMap.end())
        gm = localMetadataSetMap[(long)&state];
    std::pair<long,long> dp;
    if (gm.find(arguments[0]) != gm.end()) 
       dp.first = (long)&gm[arguments[0]];
    if (gm.find(arguments[1]) != gm.end()) 
       dp.second = (long)&gm[arguments[1]];
    std::set<std::pair<long,long> > ls;
    if (localMetadataSetsToBeChecked.find((long)&state) != localMetadataSetsToBeChecked.end())
       ls = localMetadataSetsToBeChecked[(long)&state];
    ls.insert(dp);
    localMetadataSetsToBeChecked[(long)&state] = ls;
    std::map<std::pair<long,long>, std::string> lm;
    if (localMetadataMessage.find((long)&state) != localMetadataMessage.end())
       lm = localMetadataMessage[(long)&state];
    lm[dp] = readStringAtAddress(state, arguments[2]);
    localMetadataMessage[(long)&state] = lm;
}

void SpecialFunctionHandler::handleReportDiffMetadataGlobally(ExecutionState &state,
                                                KInstruction *target,
                                                std::vector<ref<Expr> > &arguments) {
    std::pair<long,long> dp;
    if (globalMetadataSetMap.find(arguments[0]) != globalMetadataSetMap.end()) 
       dp.first = (long)&globalMetadataSetMap[arguments[0]];
    if (globalMetadataSetMap.find(arguments[1]) != globalMetadataSetMap.end()) 
       dp.second = (long)&globalMetadataSetMap[arguments[1]];
    globalMetadataSetsToBeChecked.insert(dp);
    globalMetadataMessage[dp] = readStringAtAddress(state, arguments[2]);
}


/* SYSREL extension */




void SpecialFunctionHandler::handleMakeSymbolic(ExecutionState &state,
                                                KInstruction *target,
                                                std::vector<ref<Expr> > &arguments) {
  std::string name;

  // FIXME: For backwards compatibility. We should eventually enforce the
  // correct arguments and types.
  switch (arguments.size()) {
    case 2:
      klee_warning("klee_make_symbolic: deprecated number of arguments (2 instead of 3)");
      break;
    case 3:
      name = readStringAtAddress(state, arguments[2]);
      break;
    default:
      executor.terminateStateOnError(state, "illegal number of arguments to klee_make_symbolic(void*, size_t, char*)", Executor::User);
      return;
  }
  if (name.length() == 0) {
    name = "unnamed";
    klee_warning("klee_make_symbolic: renamed empty name to \"unnamed\"");
  }

  Executor::ExactResolutionList rl;
  executor.resolveExact(state, arguments[0], rl, "make_symbolic");
  
  for (Executor::ExactResolutionList::iterator it = rl.begin(), 
         ie = rl.end(); it != ie; ++it) {
    const MemoryObject *mo = it->first.first;
    mo->setName(name);
    
    const ObjectState *old = it->first.second;
    ExecutionState *s = it->second;
    
    if (old->readOnly) {
      executor.terminateStateOnError(*s, "cannot make readonly object symbolic",
                                     Executor::User);
      return;
    } 

    // FIXME: Type coercion should be done consistently somewhere.
    bool res;
    bool success __attribute__ ((unused)) =
      executor.solver->mustBeTrue(*s, 
                                  EqExpr::create(ZExtExpr::create(arguments[1],
                                                                  Context::get().getPointerWidth()),
                                                 mo->getSizeExpr()),
                                  res);
    assert(success && "FIXME: Unhandled solver failure");
    
    if (res) {
      executor.executeMakeSymbolic(*s, mo, name);
    } else {      
      executor.terminateStateOnError(*s, 
                                     "wrong size given to klee_make_symbolic[_name]", 
                                     Executor::User);
    }
  }
}

void SpecialFunctionHandler::handleMarkGlobal(ExecutionState &state,
                                              KInstruction *target,
                                              std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==1 &&
         "invalid number of arguments to klee_mark_global");  

  Executor::ExactResolutionList rl;
  executor.resolveExact(state, arguments[0], rl, "mark_global");
  
  for (Executor::ExactResolutionList::iterator it = rl.begin(), 
         ie = rl.end(); it != ie; ++it) {
    const MemoryObject *mo = it->first.first;
    assert(!mo->isLocal);
    mo->isGlobal = true;
  }
}

void SpecialFunctionHandler::handleAddOverflow(ExecutionState &state,
                                               KInstruction *target,
                                               std::vector<ref<Expr> > &arguments) {
  executor.terminateStateOnError(state, "overflow on addition",
                                 Executor::Overflow);
}

void SpecialFunctionHandler::handleSubOverflow(ExecutionState &state,
                                               KInstruction *target,
                                               std::vector<ref<Expr> > &arguments) {
  executor.terminateStateOnError(state, "overflow on subtraction",
                                 Executor::Overflow);
}

void SpecialFunctionHandler::handleMulOverflow(ExecutionState &state,
                                               KInstruction *target,
                                               std::vector<ref<Expr> > &arguments) {
  executor.terminateStateOnError(state, "overflow on multiplication",
                                 Executor::Overflow);
}

void SpecialFunctionHandler::handleDivRemOverflow(ExecutionState &state,
                                               KInstruction *target,
                                               std::vector<ref<Expr> > &arguments) {
  executor.terminateStateOnError(state, "overflow on division or remainder",
                                 Executor::Overflow);
}


ReturnAPIHandler::ReturnAPIHandler() : APIHandler() {}

bool ReturnAPIHandler::interpret(PMFrame &pmf, APIAction *action,ExecutionState &state,  
          std::vector< ref<Expr> > &arguments, KInstruction *target, bool &term, bool &comp, bool &abort, ref<Expr> &offendingAddress, int tid) {

  comp = true;
  std::vector<std::string> par = action->getParams();
  std::string api = par[0];
  if (par[1].find("arg") != std::string::npos || par[1].find("alloc") != std::string::npos) {
     const DataLayout &dl = target->inst->getParent()->getParent()->getParent()->getDataLayout();
     llvm::CallSite cs(target->inst);
     Value *fp = cs.getCalledValue();
     Function *caller = ((Executor*)theInterpreter)->getTargetFunction(fp, state);
     ref<Expr> refobjaddr = eval(state,  dl, caller, arguments, par[1], target, true, abort);
     if (abort)
        return false; 
     for(int i=0; i<arguments.size(); i++)
        llvm::outs() << "arg " << i << " " << arguments[i] << "\n";
     llvm::outs() << "returning value " << refobjaddr << "\n";
     ((Executor*)(theInterpreter))->bindLocal(target, state, refobjaddr);
  }
  else {     
     int val = std::stoi(par[1]);
     ((Executor*)(theInterpreter))->bindLocal(target, state, ConstantExpr::create(val, Expr::Int64)); 
  }  
  return true;
}
     
bool ReturnAPIHandler::assignsRetValue(APIAction *action) {
  llvm::errs() << "return API handler..\n";
  return true;
}


RefCountAPIHandler::RefCountAPIHandler() : APIHandler() {}

bool RefCountAPIHandler::assignsRetValue(APIAction *action) {
  return false;   
}

bool RefCountAPIHandler::interpret(PMFrame &pmf, APIAction *action, ExecutionState &state, 
    std::vector< ref<Expr> > &arguments, KInstruction *target, bool &temp, bool &comp, bool &abort,ref<Expr> &offendingAddress,  int tid){   

  std::vector<std::string> par = action->getParams();
  std::string api = par[0];
  std::string op = par[1];
  const DataLayout &dl = target->inst->getParent()->getParent()->getParent()->getDataLayout();
  llvm::CallSite cs(target->inst);
  Value *fp = cs.getCalledValue();
  Function *caller = ((Executor*)theInterpreter)->getTargetFunction(fp, state);
  bool address = false;
  std::string expr = par[2]; 
  if (expr[0] == '&') {
     address = true;
     expr = expr.substr(1);
  }
  if (expr[0] == '*') {
     address = false;
     expr = expr.substr(1);
  }
  ref<Expr> refobjaddr = eval(state,  dl, caller, arguments, expr, target, address, abort);
  if (abort) {
     return false;
  }
  llvm::errs() << "memory object at base addr " << refobjaddr  << "\n";
  int value = std::stoi(par[3]);
  std::string onzerocb = par[4]; 
 
  if (op == "set") {
     state.setRefCount(refobjaddr, value);
     llvm::errs() << "refcount for " << refobjaddr  << " set to " << value << "\n";
     assert(value >= 0 && "Negative refcount value set!");
     state.recordRefcountOp(refobjaddr, api + " :set to " + std::to_string(value));
     comp = true;
  }
  else if (op == "inc") {
     int cv = state.getRefCount(refobjaddr);
     llvm::errs() << "refcount for " << refobjaddr  << " set to " << cv + value << "\n";
     state.setRefCount(refobjaddr, cv + value);
     state.recordRefcountOp(refobjaddr, api + " :inc to " + std::to_string(cv + value));
     comp = true;
  }
  else if (op == "dec") {
     int cv = state.getRefCount(refobjaddr);
     state.setRefCount(refobjaddr, cv - value);
     llvm::errs() << "refcount for " << refobjaddr  << " set to " << cv - value << "\n";
     state.recordRefcountOp(refobjaddr, api + " :dec to " +  std::to_string(cv - value));
     if ((cv - value) < 0)
        ((Executor*)(theInterpreter))->terminateStateOnError(state,
        "Negative refcount encountered in decrement!",Executor::TerminateReason::NegativeRefcount);
     //assert((cv - value) >= 0 && "Negative refcount encountered in decrement!");
     if ((cv - value) == 0) {
        if (onzerocb != "none") {
           if (onzerocb.find("arg") != std::string::npos) { 
              llvm::outs() << "executing callback " << onzerocb << " on zero refcount\n";
              executeCallback(state, onzerocb, arguments, target, comp, abort, tid);
              if (abort) return false; 
           }
           else {
             llvm::outs() << "executing subblock " << onzerocb << " on zero refcount\n";
             APIAction *action = APIHandler::lookup(onzerocb);
             llvm::errs() << "onzerocb=" << onzerocb << "\n";
             assert(action);
             bool term2 = false;
             if (action) {
                llvm::errs() << "args before pushing frame for apisubblock\n";
                for(auto a: arguments) 
                   llvm::errs() << "arg " << a << "\n";    

                std::vector<ref<Expr> > ar;
                for(auto a: arguments) 
                   ar.push_back(a);

                state.pushPMFrame(action, ar, target, tid);
                comp = false;
                // old way of doing things.. 
                //action->execute(state, arguments, target, term2, comp, tid);
             }
             else { 
                llvm::errs() << "Couldn't find subblock " << onzerocb << "\n"; 
                assert(false);
             }
           }
        }
        else comp = true;
     }
  }
  return true;
};

AllocAPIHandler::AllocAPIHandler() : APIHandler() {
}

bool AllocAPIHandler::assignsRetValue(APIAction *action) {
     std::vector<std::string> pars = action->getParams();
     llvm::outs() << "Alloc API assigns to return value? " << pars[4] << "entered\n";
     return (pars[4] == "true");   
}

bool AllocAPIHandler::interpret(PMFrame &pmf, APIAction *action, ExecutionState &state,
         std::vector< ref<Expr> > &arguments, KInstruction *target, bool &term, bool &comp, bool &abort, ref<Expr> &offendingAddress, int tid) {
    comp = true;
    std::vector<std::string> par = action->getParams();
    LLVMContext &ctx = moduleHandle->getContext();
    if (par[0] == "anonymous") {
       if (!par[1].empty() && std::all_of(par[1].begin(), par[1].end(), ::isdigit)) {
          // spec with size
          size_t allocationSize = std::stoi(par[1]);
          Type *t = llvm::IntegerType::get(((Executor*)theInterpreter)->kmodule->module->getContext(),8);
          bool sym = (par[3] == "true");
          const DataLayout &dl = target->inst->getParent()->getParent()->getParent()->getDataLayout();
          size_t allocationAlignment = dl.getPrefTypeAlignment(t);
          MemoryObject *mo = ((Executor*)(theInterpreter))->memory->allocate(allocationSize, false, false,
                         target->inst, allocationAlignment, allocationSize, Type::getInt8Ty(ctx));
          if (!mo) {
             llvm::outs() << "Could not allocate memory object while handling anonymous alloc API!\n";
             return false;
          }
          recordMemObj(state, mo);
          llvm::errs() << "Allocated memory object of size " << allocationSize << " at " << mo->getBaseExpr() << " to handle anonymous alloc " << par[5] << "\n"; 

          state.recordAlloc(mo->getBaseExpr());
          if (par.size() > 5) {
             state.addSymbolDef(par[5], mo->getBaseExpr());
             state.addSymbolType(par[5], t);
          }
          if (sym) {
             mo->name = state.getUnique("anonymous") + "_" + par[5];
             if (tid == -1) {
                ((Executor*)(theInterpreter))->executeMakeSymbolic(state, mo, mo->name, 
                                                                         true, t, true);
             } 
             else {
                ((Executor*)(theInterpreter))->executeMakeSymbolicThread(state, mo, mo->name, tid); 
             }
          }        
          else {
             ObjectState *os = ((Executor*)(theInterpreter))->bindObjectInState(state, mo, false, 0);
             if (par[2] == "true")
                os->initializeToZero();
          }
          return true;
          
       }
       llvm::TypeFinder StructTypes;
       StructTypes.run(*(((Executor*)theInterpreter)->kmodule->module), true);
       bool found = false;
       Type *t = NULL;
       for (auto *STy : StructTypes) {
          if (getTypeName(STy) == par[1]) {
             found = true;
             t = STy;
             break;
          }
       }
       if (found) {
          bool sym = (par[3] == "true");
          const DataLayout &dl = target->inst->getParent()->getParent()->getParent()->getDataLayout();
          size_t allocationAlignment = dl.getPrefTypeAlignment(t);
          size_t allocationSize = dl.getTypeAllocSize(t);
          MemoryObject *mo = ((Executor*)(theInterpreter))->memory->allocate(allocationSize, false, false,
                         target->inst, allocationAlignment, 1, t);
          if (!mo) {
             llvm::outs() << "Could not allocate memory object while handling anonymous alloc API!\n";
             return false;
          }
          recordMemObj(state, mo);
          llvm::errs() << "Allocated memory object of size " << allocationSize << " at " << mo->getBaseExpr() << " to handle anonymous alloc " << par[5] << "\n"; 
          state.recordAlloc(mo->getBaseExpr());
          if (par.size() > 5) {
             state.addSymbolDef(par[5], mo->getBaseExpr());
             state.addSymbolType(par[5], t);
          }

          llvm::StructType *st = dyn_cast<llvm::StructType>(t);
          if (st) {
             std::string tname = getTypeName(t); 
             state.typeToAddr[t] = mo->getBaseExpr();
             llvm::outs() << "mapping lazy instance of " << tname << " to " << mo->getBaseExpr() << "\n";
             bool isSingle; int count;
             bool li = isAllocTypeLazyInit(t,isSingle,count);
             if (li && isSingle) {
                if (state.lazyInitSingleInstances.find(t) != state.lazyInitSingleInstances.end()) {
                   llvm::errs() << "Cannot allocate object of singleton type " << t << " due to contradiction!\n"; 
                   exit(1);
                }
                state.lazyInitSingleInstances[t] = mo;
                llvm::outs() << "storing address " << mo->getBaseExpr() << " as single instance of type " << tname << "\n"; 
                addSingleOrDerivative(state, mo->getBaseExpr());
                llvm::errs() << "recording singleton or derivative " <<  mo->getBaseExpr() << "\n";
            }
          }   


     
          if (sym) {
             mo->name = state.getUnique("anonymous") + "_" + par[5];
             if (tid == -1) {
                ((Executor*)(theInterpreter))->executeMakeSymbolic(state, mo, mo->name, 
                                                                            true, t, true);
             } 
             else {
                ((Executor*)(theInterpreter))->executeMakeSymbolicThread(state, mo, mo->name, tid); 
             }
          }        
          else {
             ObjectState *os = ((Executor*)(theInterpreter))->bindObjectInState(state, mo, false, 0);
             if (par[2] == "true")
                os->initializeToZero();
          }
          return true;
       }
       assert(false && "Could not find anonymous alloc type!");
    }
    std::string fname = par[0];
    llvm::outs() << "Handling alloc api " << fname << " in thread " << tid << "\n";
    llvm::outs() << "Target instruction " << (*target->inst) << "\n";
    bool zeroMemory = (par[2] == "true");
    llvm::CallInst *ci = dyn_cast<CallInst>(target->inst);
    if (!ci)
       assert(false && "Expected a call instruction for allocation API!\n");
    int param = std::stoi(par[1]); 
    llvm::errs() << "size=" << arguments[param] << " vs " << ConstantExpr::create(0,32) << "\n"; 
    if (arguments[param] == ConstantExpr::create(0,32)) {
       llvm::errs() << "Skipping 0 size alloc API: \n"; action->print(); 
       return true;
    }
    bool sym = (par[3] == "true");
    bool retAssign = (par[4] == "true");
    size_t allocationAlignment;
    size_t allocationSize;
    const DataLayout &dl = target->inst->getParent()->getParent()->getParent()->getDataLayout();
    Type *t = ci->getArgOperand(param)->getType();
    if (t->isPointerTy()) {
       t = t->getPointerElementType();
       if (t->isPointerTy()) {
          t = t->getPointerElementType();
          allocationAlignment = dl.getPrefTypeAlignment(t);
          allocationSize = dl.getTypeAllocSize(t);
       }
       else assert(false && "Alloc API param type must be a double-pointer!\n");
    }
    else {
       //const llvm::Value *allocSite = state.prevPC->inst;
       const llvm::Value *allocSite = target->inst;
       allocationAlignment = ((Executor*)(theInterpreter))->getAllocationAlignment(allocSite);
       ConstantExpr *constexp = dyn_cast<ConstantExpr>(arguments[param]);
       if (constexp)
          allocationSize = constexp->getZExtValue();
      else {
           // check if we can derive a solution consistent with primArraySize
           ref<Expr> primeq = EqExpr::create(arguments[param], ConstantExpr::create(primArraySize, arguments[param]->getWidth()));
           bool ret = false;
           bool success = ((Executor*)(theInterpreter))->solver->mayBeTrue(state, primeq, ret);
           if(!success || !ret) {
             llvm::errs() << "Terminating path due to a symbolic size for AllocAPIHandler!\n";  
             ((Executor*)(theInterpreter))->terminateStateOnError(state, "concretized symbolic size",
                                Executor::Model, NULL, "A symbolic size is passed to an AllocAPIHandler"); 
             return false;
           }
           else  {
              llvm::errs() << "Using " << primArraySize << " for the symbolic size expression \ 
                         and constraining the path condition accordingly\n";
              ((Executor*)(theInterpreter))->addConstraint(state, primeq); 
              allocationSize = primArraySize;
           }
      }
    }
    MemoryObject *mo = ((Executor*)(theInterpreter))->memory->allocate(allocationSize, false, false,
                         ci, allocationAlignment, allocationSize, Type::getInt8Ty(ctx));
    if (!mo) {
       llvm::outs() << "Could not allocate memory object while handling alloc API!\n";
       return false;
    }
    recordMemObj(state, mo);
    llvm::outs() << "Allocated memory object at " << mo->getBaseExpr() << " to handle alloc API " << fname << "\n"; 
    state.recordAlloc(mo->getBaseExpr());
    if (par.size() > 5) {  
       state.addSymbolDef(par[5], mo->getBaseExpr());
       state.addSymbolType(par[5], t);
    } 

    llvm::StructType *st = dyn_cast<llvm::StructType>(t);
    if (st) {
       std::string tname = getTypeName(t); 
       state.typeToAddr[t] = mo->getBaseExpr();
       llvm::outs() << "mapping lazy instance of " << tname << " to " << mo->getBaseExpr() << "\n";
       bool isSingle; int count;
       bool li = isAllocTypeLazyInit(t,isSingle,count);
       if (li && isSingle) {
          if (state.lazyInitSingleInstances.find(t) != state.lazyInitSingleInstances.end()) {
                   llvm::errs() << "Cannot allocate object of singleton type " << t << " due to conttradiction!\n";
                   exit(1);
          }
          state.lazyInitSingleInstances[t] = mo;
          llvm::outs() << "storing address " << mo->getBaseExpr() << " as single instance of type " << tname << "\n"; 
          addSingleOrDerivative(state, mo->getBaseExpr());
          llvm::errs() << "recording singleton or derivative " <<  mo->getBaseExpr() << "\n";
       }
    }   
     
 
    if (sym) {
        mo->name = state.getUnique(fname) + "_" + std::to_string(param);

       if (tid == -1) {
          ((Executor*)(theInterpreter))->executeMakeSymbolic(state, mo, mo->name, true, t, true);
          abort = ((Executor*)(theInterpreter))->executeMemoryOperation(state, true, arguments[param], mo->getBaseExpr(), 0);
          if (abort) return false;
       } 
       else {
          ((Executor*)(theInterpreter))->executeMakeSymbolicThread(state, mo, mo->name, tid); 
          ((Executor*)(theInterpreter))->executeMemoryOperationThread(state, true, arguments[param], mo->getBaseExpr(), 0, tid); 
       }
    }
    else { 
       ObjectState *os = ((Executor*)(theInterpreter))->bindObjectInState(state, mo, false, 0);
       if (par[2] == "true")
          os->initializeToZero();
    }

    if (retAssign) {
       ((Executor*)(theInterpreter))->bindLocal(target, state, mo->getBaseExpr());
    }

    return true;
}


FreeAPIHandler::FreeAPIHandler() : APIHandler() {}

bool FreeAPIHandler::assignsRetValue(APIAction *action) {
  return false;
}

       
bool FreeAPIHandler::interpret(PMFrame &pmf, APIAction *action, ExecutionState &state, 
          std::vector< ref<Expr> > &arguments, KInstruction *target, bool &term, bool &comp, bool &abort, ref<Expr> &offendingAddress, int tid) {
     comp = true;
     std::vector<std::string> pars = action->getParams();
     llvm::outs() << "Handling free api " << pars[0] << "\n";

     if (pars[0] == "anonymous") {
        Function *f = kmoduleExt->module->getFunction(action->getFunctionName());
        const DataLayout &dl = target->inst->getParent()->getParent()->getParent()->getDataLayout();
        ref<Expr> addr = eval(state, dl, f, arguments, pars[1], target, true, abort);
        if (abort) return false; 
        llvm::errs() << "Freeing address " << addr << " as anonymous free of function";         
        if (tid == -1)  
           ((Executor*)(theInterpreter))->executeFree(state, addr, NULL);
        else
           ((Executor*)(theInterpreter))->executeFreeThread(state, addr, NULL, tid);      
        return true;
     }

     int arg =  std::stoi(pars[1]);
     if (tid == -1)  
         ((Executor*)(theInterpreter))->executeFree(state, arguments[arg], NULL);
     else
         ((Executor*)(theInterpreter))->executeFreeThread(state, arguments[arg], NULL, tid);     
     return true;
}

IgnoreAPIHandler::IgnoreAPIHandler() : APIHandler() {
}


bool IgnoreAPIHandler::interpret(PMFrame &pmf, APIAction *action, ExecutionState &state, 
				 std::vector< ref<Expr> > &arguments, KInstruction *target, bool &term, bool &comp, bool &abort, ref<Expr> &offendingAddress,  int tid) {
    comp = true;
    std::vector<std::string> pars = action->getParams();
    llvm::outs() << "Handling ignore api " << pars[0] << "\n";
    Function *function = kmoduleExt->module->getFunction(pars[0]);
    // load pointer type parameters to detect memory issues precisely
    abort = ! ((Executor*)theInterpreter)->loadPointerArguments(state, target, function, arguments, offendingAddress); 
    return true;
}

bool IgnoreAPIHandler::assignsRetValue(APIAction *action) {
  return false;
}

void APIHandler::executeCallback(ExecutionState &state, std::string cbexpr, std::vector< ref<Expr> > &arguments, 
         KInstruction *target, bool &comp, bool &abort, int tid) {
   llvm::outs() << "cbexpr= " << cbexpr << "\n";
   APIAction *sub = APIHandler::getSubblock(cbexpr);
   if (sub) {
      llvm::outs() << "executing subblock " << cbexpr << " on condition\n";
      bool term2 = false;
      llvm::errs() << "args before pushing frame for apisubblock\n";
      for(auto a: arguments) 
         llvm::errs() << "arg " << a << "\n";    

      std::vector<ref<Expr> > ar;
      for(auto a: arguments) 
         ar.push_back(a);

      state.pushPMFrame(sub, ar, target, tid);
      comp = false;
      return;
   } 
   const Function *f = NULL;
   if (cbexpr.find("arg") == 0 || cbexpr.find("alloc") == 0) {
      llvm::CallSite cs(target->inst);
      Value *fp = cs.getCalledValue();
      Function *caller = ((Executor*)theInterpreter)->getTargetFunction(fp, state);
      const DataLayout &dl = target->inst->getParent()->getParent()->getParent()->getDataLayout();
      ref<Expr> cbaddr = eval(state,  dl, caller, arguments, cbexpr, target, false, abort) ;
      if (abort) return;
      llvm::errs() << "cbaddr=" << cbaddr << "\n";
      f = ((Executor*)theInterpreter)->getFunctionFromAddress(cbaddr);
   }
   else 
      f = kmoduleExt->module->getFunction(cbexpr);
   llvm::errs() << "callback expr: " << cbexpr << "\n";
   if (!f) {
      //assert(f && "Callback function not defined!\n");
      llvm::errs() << "WARNING: Callback function not defined, expr=" << cbexpr << "!\n";
      comp = true;
      return;
   }
   llvm::errs() << "calling callback " << f->getName() << "\n";
   Function *ncf = target->inst->getParent()->getParent()->getParent()->getFunction(f->getName());
   KFunction *kf = kmoduleExt->functionMap[ncf];      
   if (kf) {
      state.setPMCallback(f->getName());
      comp = false; 
     state.pushFrame(state.prevPC, kf);
    state.pc = kf->instructions;

   StatsTracker * statsTracker = ((Executor*)theInterpreter)->getStatsTracker();
   if (statsTracker) {
      if (tid == -1)
         statsTracker->framePushed(state, &state.stack[state.stack.size()-2]);
      else
         statsTracker->framePushedThread(state, &state.stack[state.stack.size()-2], tid);
   }
   // allocate symbolic arguments
   ((Executor*)theInterpreter)->initArgsAsSymbolic(state, kf->function, abort, true);
   if (abort) return;       
  }
  else {
     llvm::errs() << "WARNING: Callback function is an external function, expr=" << cbexpr << "!\n";
     comp = true;
     return ;
  }
}  

CallbackAPIHandler::CallbackAPIHandler() : APIHandler() {}

bool CallbackAPIHandler::assignsRetValue(APIAction *action) {
  return false;
}

bool APIHandler::checkCondition(APIAction *action, ExecutionState &state, 
      std::vector< ref<Expr> > &arguments, std::string cexpr, KInstruction *target, bool &abort) {
  std::vector<std::string> par = action->getParams();
  bool negate = false;
  bool address = true;
  if (cexpr[0] == '!') {
     negate = true;
     cexpr = cexpr.substr(1);
  }
  if (cexpr[0] == '*') {
     address = false;
     cexpr = cexpr.substr(1);   
  }
  Function *f = kmoduleExt->module->getFunction(par[0]);
  const DataLayout &dl = target->inst->getParent()->getParent()->getParent()->getDataLayout();  
  ref<Expr> result = eval(state, dl, f, arguments, cexpr, target, address, abort);
  if (abort) return false;
  llvm::errs() << "condition eval " << cexpr << "=" << result << "\n"; 
  ConstantExpr *CE;
  if (!negate)
     return (result == Expr::createPointer(0) || !((CE = dyn_cast<ConstantExpr>(result))));
  else return (result != Expr::createPointer(0) && (CE = dyn_cast<ConstantExpr>(result)));
}

bool CallbackAPIHandler::interpret(PMFrame &pmf, APIAction *action, ExecutionState &state, 
      std::vector< ref<Expr> > &arguments, KInstruction *target, bool &term, bool &comp, bool &abort, ref<Expr> &offendingAddress, int tid) {
   std::vector<std::string> par = action->getParams();
   bool cond = true;
   if (par.size() == 3) {
      // check the condition
      cond = checkCondition(action, state, arguments, par[2], target, abort);
      if (abort) return false; 
      llvm::errs() << "Callback condition " << par[2] << "? " << cond << "\n";
   }
   if (cond) {
      executeCallback(state, par[1], arguments, target, comp, abort, tid);
      if (abort) return false; 
   }
   else comp = true;
   return true; 
}
 

TerminateAPIHandler::TerminateAPIHandler() : APIHandler() {}

bool TerminateAPIHandler::interpret(PMFrame &pmf, APIAction *action, ExecutionState &state, 
                                std::vector< ref<Expr> > &arguments, 
				    KInstruction *target, bool &term, bool &comp,bool &abort, ref<Expr> &offendingAddress, int tid) {
  comp = true;
  llvm::errs() << "Handling terminate api\n " ; action->print();
  std::vector<std::string>  par = action->getParams();
  std::string texpr = par[1];
  term = checkCondition(action, state, arguments, texpr, target, abort);
  if (abort) return false; 
  return true;
}       

bool TerminateAPIHandler::assignsRetValue(APIAction *action) {
  return false;
}


SideEffectAPIHandler::SideEffectAPIHandler() : APIHandler() {}

// syntax argi([-> | .]fieldindex)+
// we assume that argi holds base address of the memory object pointed by that pointer type argument
// to do: handle the * operator
ref<Expr> APIHandler::eval(ExecutionState &state,  const DataLayout &dl, Function *f, 
     std::vector< ref<Expr> > &arguments, std::string oexpr, KInstruction *target, bool address, bool &abort) {

   if (oexpr == "NULL")
      return Expr::createPointer(0);

   if (!oexpr.empty() && std::all_of(oexpr.begin(), oexpr.end(), ::isdigit)) {
      int val = std::stoi(oexpr);
      return ConstantExpr::create(val,64);
   }

   std::string expr;

   if (oexpr[0] == '&') {
      address = true;
      expr = oexpr.substr(1);
   }
   else expr = oexpr;

   llvm::errs() << "In SE eval for " <<  expr << "\n";
   bool modelsymbol = false;
   std::string hint("struct.usb_interface");
   ref<Expr> cur;
   llvm::Type *t = NULL;
   llvm::StructType *st = NULL;
   llvm::Type *ptrtype = NULL;
   unsigned i; 
   auto pos = expr.find("arg");
   if (pos != std::string::npos) {
    for(i = pos + 3; expr[i] != '-' && expr[i] != '.' && i < expr.length() ; i++) ;
    std::string index;
    int argindex; 
    if (i == expr.length()) 
       index = expr.substr(pos+3);
    else {
       index = expr.substr(pos+3, i);
    }     
    argindex = std::stoi(index); 
    // find the type of the argument
    int j = 0;
    for(llvm::Argument & arg : f->args()) {
       if (j == argindex) {
           t = arg.getType();
           break;
       }
       j++;
    }
    if (t->isPointerTy()) {
       ptrtype = t;
       t = t->getPointerElementType(); 
    } 
    st = dyn_cast<StructType>(t);
    cur = arguments[argindex];
    llvm::errs() << "In SE:  arguments[" << argindex << "] is " <<  cur << "\n";
 }
 else { 
       pos = expr.find("alloc");
       if (pos == std::string::npos) {
          llvm::outs() <<  expr << "\n";
          assert(0 && "expression does not refer to an argument or an alloc symbol");
       }
       else {
          modelsymbol = true;
          for(i = pos + 5; expr[i] != '-' && expr[i] != '.' && i < expr.length() ; i++) ;
          std::string symb;
          if (i == expr.length()) 
             symb = expr.substr(pos);
          else 
             symb = expr.substr(pos, i);
          if ((t=state.getSymbolType(symb))) {
             cur = state.getSymbolDef(symb);
             if (dyn_cast<ConstantExpr>(cur)) {
                const auto CE = dyn_cast<ConstantExpr>(cur);
                if (!CE->getZExtValue()) {
                   llvm::errs() << "Symbol " << symb  << " NULL!";
                   //assert(0 && "Alloc symbol not defined!");
                   return cur;
                }
             }
             if (t->isPointerTy()) {
                ptrtype = t;
                t = t->getPointerElementType(); 
             } 
             st = dyn_cast<StructType>(t);
             llvm::errs() << "In SE: " << symb << " is " << cur << " of type " << getTypeName(t) << "\n";
          }
          else return Expr::createPointer(0);
       }
  }

    bool exprParsed = false;
    int last = 0;
    std::string field;
    int fieldIndex; 
    ref<Expr> addressRes = cur;
    bool simple = true;
    while (i < expr.length()) {
        llvm::errs() <<"parsing loop \n";
        if ((expr[i] == '-' || expr[i] == '.')) {
           simple = false;
           if (!st)
              assert(0 && "Dereferencing into a non-struct type pointer!\n");
           if (expr[i] == '-') {
              assert(expr[i+1] == '>' && "Unexpected dereferencing operator in the update expression!\n");
              i = i + 2;
           }
           else  i = i + 1;
           last = i;
           if (i == expr.length())
              assert(0 && "Incomplete update expression field name does not follow the dereferencing operator!\n");
           else {
              while (i < expr.length() && expr[i] != '-' && expr[i] != '.') {
                i++;
              }  
              exprParsed =  (i == expr.length());
              field = expr.substr(last, i);
              fieldIndex = std::stoi(field); 
              Type *fieldType = st->getElementType(fieldIndex);
              uint64_t offset = dl.getStructLayout(st)->getElementOffset(fieldIndex);
              llvm::errs() << "using " << cur << "\n"; 
              cur = AddExpr::create(ConstantExpr::create(offset, Expr::Int64), cur);
              llvm::errs() << "computed addr " << cur << "\n";
              if (fieldType->isPointerTy()) {
                 ptrtype = t;
                 // load the pointer object and update cur with the base address
                 bool asuccess;
                 ObjectPair op;
                 ((Executor*)(theInterpreter))->solver->setTimeout(((Executor*)(theInterpreter))->coreSolverTimeout);
                 if (!state.addressSpace.resolveOne(state, ((Executor*)(theInterpreter))->solver, cur, op, asuccess)) {
                    cur = ((Executor*)(theInterpreter))->toConstant(state, cur, "resolveOne failure");
                    asuccess = state.addressSpace.resolveOne(cast<ConstantExpr>(cur), op);
                 }
                 ((Executor*)(theInterpreter))->solver->setTimeout(0);             
                 if (asuccess) {
                    addressRes = cur;
                    ref<Expr> offsetExpr = SubExpr::create(cur, op.first->getBaseExpr()); 
                    cur = op.second->read(offsetExpr,Context::get().getPointerWidth()/*dl.getPointerTypeSizeInBits(ptrtype)*/);
                    llvm::errs() << "after updating with the value, cur=" << cur << "\n";
                    // read the field string           
                 }
                 else {
                   if (t->isPointerTy())
                      t = t->getPointerElementType();
                   llvm::Type *rallocType;
                   ref<Expr> resaddr; 
                   bool sym;
                   int count = 0;
                   bool singleInstance = false;
                   bool lazyInitTemp = isLazyInit(t, singleInstance, count);
                   if (!lazyInitTemp)
                      count = 1;
                   const MemoryObject *mo = ((Executor*)(theInterpreter))->memory->allocateLazyForTypeOrEmbedding(state, target->inst, 
                              t, t, singleInstance, count, rallocType, resaddr, sym, abort, 
                              NULL, hint.c_str());
                   if (abort) return Expr::createPointer(0);
                   mo->name = "sym_" + state.getUnique(getTypeName(t)); 
                   if (sym) {
                      llvm::errs() << "lazy initializing, new object at " << resaddr << " while evaluating expression\n";
                      ((Executor*)(theInterpreter))->executeMakeSymbolic(state, mo, mo->name, 
                                                                         true, t, true);  
                      abort = ((Executor*)(theInterpreter))->executeMemoryOperation(state, true, cur, resaddr, 0);
                      if (abort) return Expr::createPointer(0);
                      addressRes = cur;
                      cur = resaddr;
                   }
                   else { 
                      assert(resaddr == cur);
                      llvm::errs() << "returned an existing instance " <<   resaddr << " (inside " << mo->getBaseExpr() << ")\n"; 
                      addressRes = resaddr;
                      // read from addressRes and store into cur 
                      const ObjectState *os = state.addressSpace.findObject(mo);
                      ref<Expr> offsetExpr = SubExpr::create(resaddr, mo->getBaseExpr()); 
                      llvm::errs() << "reading from " << mo->getBaseExpr() << " offset=" << offsetExpr << "\n";
                      cur = os->read(offsetExpr,Context::get().getPointerWidth());
                      llvm::errs() << "read value=" << cur << " from " << addressRes << "\n";	
                   }
                 }

              }  
              else if (exprParsed) {
                 // done reading the expression; should read the value and note the address
                 bool asuccess;
                 ObjectPair op;
                 ((Executor*)(theInterpreter))->solver->setTimeout(((Executor*)(theInterpreter))->coreSolverTimeout);
                 if (!state.addressSpace.resolveOne(state, ((Executor*)(theInterpreter))->solver, cur, op, asuccess)) {
                    cur = ((Executor*)(theInterpreter))->toConstant(state, cur, "resolveOne failure");
                    asuccess = state.addressSpace.resolveOne(cast<ConstantExpr>(cur), op);
                 }
                 ((Executor*)(theInterpreter))->solver->setTimeout(0);             
                 if (asuccess) {
                    addressRes = cur;
                    ref<Expr> offsetExpr = SubExpr::create(cur, op.first->getBaseExpr()); 
                    cur = op.second->read(offsetExpr,Context::get().getPointerWidth()/*dl.getPointerTypeSizeInBits(ptrtype)*/);
                    llvm::errs() << "after updating with the value, cur=" << cur << "\n";
                    // read the field string           
                 }                 
              } // otherwise keep dereferencing
              t = fieldType;
              std::string type_str;
              llvm::raw_string_ostream rso(type_str);
              t->print(rso);
              llvm::errs() << "type in SE expr: " << rso.str() << "\n";
              if (t->isPointerTy())
                 st = dyn_cast<StructType>(t->getPointerElementType());
              else 
                 st = dyn_cast<StructType>(t);
           }
        }
        else {
           assert(0 && "Unexpected dereferencing operator in the update expression!\n");
        }
    } 
    if (address)
       return addressRes;
    else {
       if (modelsymbol && simple) {
          bool asuccess;
          ObjectPair op;
          ((Executor*)(theInterpreter))->solver->setTimeout(((Executor*)(theInterpreter))->coreSolverTimeout);
          if (!state.addressSpace.resolveOne(state, ((Executor*)(theInterpreter))->solver, cur, op, asuccess)) {
             cur = ((Executor*)(theInterpreter))->toConstant(state, cur, "resolveOne failure");
             asuccess = state.addressSpace.resolveOne(cast<ConstantExpr>(cur), op);
          }
          ((Executor*)(theInterpreter))->solver->setTimeout(0);             
          if (asuccess) {
             addressRes = cur;
             ref<Expr> offsetExpr = SubExpr::create(cur, op.first->getBaseExpr()); 
             cur = op.second->read(offsetExpr,Context::get().getPointerWidth()/*dl.getPointerTypeSizeInBits(ptrtype)*/);
             llvm::errs() << "after updating with the value, cur=" << cur << "\n";
                    // read the field string           
             return cur;
          }
          assert(false && "Model symbol couldn't be read!");
       }
       else  
          return cur;   
    }
}

bool SideEffectAPIHandler::assignsRetValue(APIAction *action) {
     return false;
}

bool SideEffectAPIHandler::interpret(PMFrame &pmf, APIAction *action, ExecutionState &state, std::vector< ref<Expr> > &arguments, 
      KInstruction *target, bool &term, bool &comp, bool &abort, ref<Expr> &offendingAddress, int tid) {
   comp = true;
   std::vector<std::string> pars = action->getParams();
   std::string fname = pars[0];
   llvm::outs() << "Handling side-effect api " << fname << "\n";
   Function *f = kmoduleExt->module->getFunction(fname);
   const DataLayout &dl = target->inst->getParent()->getParent()->getParent()->getDataLayout();
   std::string uexpr = pars[1];
      std::string lhs, rhs; 
      std::istringstream ss(uexpr);
      getline(ss, lhs, '=');
      getline(ss, rhs, '=');
      lhs = ltrim(rtrim(lhs));
      rhs = ltrim(rtrim(rhs));
      llvm::errs() << "lhs=" << lhs << "\n";
      llvm::errs() << "rhs=" << rhs << "\n";
      ref<Expr> addr = eval(state, dl, f, arguments, lhs, target, true, abort);
      if (abort) return false;
      ref<Expr> value = eval(state, dl, f, arguments, rhs, target, false, abort);
      if (abort) return false;
      llvm::errs() << "addr=" << addr << "\n";
      llvm::errs() << "value=" << value << "\n";
      // write value to addr
      bool asuccess;
      ObjectPair op; 
      ((Executor*)(theInterpreter))->solver->setTimeout(((Executor*)(theInterpreter))->coreSolverTimeout);
      if (!state.addressSpace.resolveOne(state, ((Executor*)(theInterpreter))->solver, addr, op, asuccess)) {
         addr = ((Executor*)(theInterpreter))->toConstant(state, addr, "resolveOne failure");
         asuccess = state.addressSpace.resolveOne(cast<ConstantExpr>(addr), op);
      }
      ((Executor*)(theInterpreter))->solver->setTimeout(0);             
      if (asuccess) {
         ObjectState *wos = state.addressSpace.getWriteable(op.first, op.second);
         ref<Expr> offsetexpr =  SubExpr::create(addr, op.first->getBaseExpr());
         llvm::errs() << "executing side-effect expr: " << uexpr << " and writing " << value << 
                         " to address " << op.first->getBaseExpr() << " at offset " << offsetexpr << "\n";
         wos->write(offsetexpr, value);         
      }      
   return true;
}


APIHandler::APIHandler() {
}

APIAction* APIHandler::lookup(std::string label) {
  if (symbolTable.find(label) != symbolTable.end())
     return symbolTable[label];
  return NULL;
}

bool APIHandler::assignsRetValue(APIAction *action) {
  return false;
}

bool APIHandler::handles(std::string fname) {
  return (apiModel.find(fname) != apiModel.end());
}

bool APIHandler::isIgnore(std::string fname) {
  if (apiModel.find(fname) == apiModel.end())
     return false;
  for(auto action : apiModel[fname]) {
     if (action->desc == "ignore")
        return true;
  }
  return false;
}

bool APIHandler::handle(ExecutionState &state, 
                               std::vector<ExecutionState*> &branches,
                               std::string fname, 
                               std::vector< ref<Expr> > &arguments, 
			KInstruction *target, bool &abort, ref<Expr> &offendingAddress,
                               int tid) {
  if (apiModel.find(fname) == apiModel.end()) {
     llvm::outs() << "external function " << fname << " not handled\n"; 
     return false;
  }
  Function *function = kmoduleExt->module->getFunction(fname);
  std::set<RetCond> conds;
  bool symbolizeRetValueOK = true;
  //bool initArgs = false;
  for(auto action : apiModel[fname]) {
     conds.insert(action->getReturnCond());
     if (action->assignsRetValue())
        symbolizeRetValueOK = false;
     //if (action->setsArgs())
       // initArgs = false;
  }
  bool branching = false;
  for(auto c : conds) {
     if (c != TRUE) {
        branching = true;
        break; 
     }
  }
  bool term = false;
  if (!branching || !symbolizeRetValueOK) {
     if (branching && !symbolizeRetValueOK)
        llvm::outs() << "WARNING: api both branching and requesting not to symbolize the return value!\n";

     if (symbolizeRetValueOK) {
        llvm::outs() << "symbolizing ret value in handler for function " << function->getName() << "\n";
        ((Executor*)(theInterpreter))->symbolizeReturnValue(state, target, function, abort);
        if (abort) return false;
     }
     
     if (apiModel[fname].size() > 1)
        assert(false && "Cannot interpret an API in multiple ways in the same state!");

     std::vector<ref<Expr> > ar;
     for(auto a: arguments) 
        ar.push_back(a);

     for(auto action : apiModel[fname]) {
        state.pushPMFrame(action, ar, target, tid);
     }

  }
  else {
   llvm::outs() << "Branching semantics, current path condition:\n";
   Function *f = kmoduleExt->module->getFunction(fname);
   assert(f);
   const MemoryObject *srt = ((Executor*)(theInterpreter))->symbolizeReturnValue(state, target, function, abort);
   if (abort) return false;
   bool asuccess;
   ObjectPair op;
   if (srt) { 
    ref<Expr> srtbase = srt->getBaseExpr();
    ((Executor*)(theInterpreter))->solver->setTimeout(((Executor*)(theInterpreter))->coreSolverTimeout);
    if (!state.addressSpace.resolveOne(state, ((Executor*)(theInterpreter))->solver, srtbase, op, asuccess)) {
       srtbase = ((Executor*)(theInterpreter))->toConstant(state, srtbase, "resolveOne failure");
       asuccess = state.addressSpace.resolveOne(cast<ConstantExpr>(srtbase), op);
    }
    else asuccess = true;
    ((Executor*)(theInterpreter))->solver->setTimeout(0);             
    if (asuccess) {
       // generate all possible branches
       bool ltzero = conds.find(LTZERO) != conds.end();
       bool lteqzero = conds.find(LTEQZERO) != conds.end();
       bool gtzero = conds.find(GTZERO) != conds.end();
       bool gteqzero = conds.find(GTEQZERO) != conds.end();
       bool zero = conds.find(ZERO) != conds.end();
       bool notzero = conds.find(NOTZERO) != conds.end();
       std::map<RetCond, std::set<ExecutionState*> > partition;        
       std::set<ExecutionState*> empty;
       partition[ZERO] = empty;
       partition[LTZERO] = empty;
       partition[LTEQZERO] = empty;
       partition[GTZERO] = empty;
       partition[GTEQZERO] = empty;
       partition[NOTZERO] = empty;  
       Expr::Width retwidth = ((Executor*)(theInterpreter))->getWidthForLLVMType(target->inst->getType());
       ref<Expr> retexpr = op.second->read(0, retwidth);
       if ((ltzero && gtzero) || (lteqzero && gteqzero) || 
           ((zero || notzero) && (ltzero || lteqzero || gtzero || gteqzero))) {
          StatePair p = ((Executor*)(theInterpreter))->fork(state,
                  EqExpr::create(retexpr, ConstantExpr::create(0, retwidth)),
                  false);
          branches.push_back(p.first);
          partition[ZERO].insert(p.first);
          partition[LTEQZERO].insert(p.first);
          partition[GTEQZERO].insert(p.first);
          StatePair p2 = ((Executor*)(theInterpreter))->fork(*p.second, 
                     SltExpr::create(retexpr, ConstantExpr::create(0, retwidth)), 
                 false);           
          branches.push_back(p2.first);
          partition[LTZERO].insert(p2.first);
          partition[NOTZERO].insert(p2.first);
          partition[LTEQZERO].insert(p2.first);
          branches.push_back(p2.second);
          partition[GTZERO].insert(p2.second);
          partition[NOTZERO].insert(p2.second);
          partition[GTEQZERO].insert(p2.second);
          llvm::outs() << "generated =0, <0, and >0 partitions on the ret val\n";
       }
       else if (zero || notzero) { 
          StatePair p = ((Executor*)(theInterpreter))->fork(state,
               EqExpr::create(retexpr, ConstantExpr::create(0, retwidth)),
               false);
          branches.push_back(p.first);
          partition[ZERO].insert(p.first); 
          branches.push_back(p.second);
          partition[NOTZERO].insert(p.second);
          llvm::outs() << "generated =0 and <>0 partitions on the ret val\n";
      }
      else {
          if (lteqzero) {
             
             StatePair p = ((Executor*)(theInterpreter))->fork(state, 
                     SleExpr::create(retexpr, ConstantExpr::create(0, retwidth)), 
                   false);
             branches.push_back(p.first);
             partition[LTEQZERO].insert(p.first);
             branches.push_back(p.second);           
             partition[GTZERO].insert(p.second);
             llvm::outs() << "generated =<0 and >0 partitions on the ret val\n";
          }
          else if (gteqzero) {
             ref<Expr> cond = SgeExpr::create(retexpr, ConstantExpr::create(0, retwidth));
             StatePair p = ((Executor*)(theInterpreter))->fork(state,cond,false);
             branches.push_back(p.first);
             partition[GTEQZERO].insert(p.first);
             branches.push_back(p.second);           
             llvm::outs() << " fork condition: " << cond << "\n";
             partition[LTZERO].insert(p.second);
             llvm::outs() << "generated <0 and >=0 partitions on the ret val\n";
         }        
         else {
           partition[TRUE].insert(&state);
           llvm::outs() << "No partitions generated on the ret val\n";
         }
      } 
    
      std::vector<ref<Expr> > ar;
      for(auto a: arguments) 
         ar.push_back(a);

      for(auto action : apiModel[fname]) {
         llvm::outs() << "checking branches in the partition " << action->getReturnCond() << "\n";
         action->print();
         for(auto branch : partition[action->getReturnCond()]) {
            if (branch) {
               branch->pushPMFrame(action, ar, target, tid);
            }
         }
      }

     }
     else {
        llvm::outs() << "Failure in memory resolution for the return value object\n";
     }
    }
    else {
     llvm::outs() << "Return value object null\n";
    }

  }
  return true;  
}

void APIHandler::addSubblock(std::string label, APIAction *action) {
   symbolTable[label] = action;
}

APIAction *APIHandler::getSubblock(std::string label) {
   if (symbolTable.find(label) == symbolTable.end())
      return NULL;
   return symbolTable[label];
}

void APIHandler::addAction(std::string api, APIAction *action) {
  std::set<APIAction*> set;
  if (apiModel.find(api) != apiModel.end())
      set = apiModel[api];
  set.insert(action);
  apiModel[api] = set;
  llvm::outs() << "Added API action for " << api << "\n";
}

void read(std::istringstream& iss, std::vector<std::string> &par) {
     std::string item = "";
     while(getline(iss, item, ',')) {
       item = ltrim(rtrim(item));
       par.push_back(item);
    }
      
}

void APIHandler::addIgnoreHandler(std::string fname) {
  if (handles(fname)) return; 
  std::vector<std::string> par(0);
  par.insert(par.begin(), fname); 
  if (!ignoreAPIHandler)
     ignoreAPIHandler = new IgnoreAPIHandler();
  APIAction *a = new APIAction("ignore",par,ignoreAPIHandler);
  addAction(par[0],a);
}

void APIHandler::readProgModelSpec(const char *name) {
  allocAPIHandler = new AllocAPIHandler();
  ignoreAPIHandler = new IgnoreAPIHandler();
  callbackAPIHandler = new CallbackAPIHandler();
  returnAPIHandler = new ReturnAPIHandler();
  refcountAPIHandler = new RefCountAPIHandler();
  freeAPIHandler = new FreeAPIHandler();
  sideEffectAPIHandler = new SideEffectAPIHandler();
  terminateAPIHandler = new TerminateAPIHandler();
  std::fstream cf(name, std::fstream::in);
  if (cf.is_open()) {
     std::string line, desc, data;
     APIBlock *apiblock = NULL;
     std::string mainapi = "";
     std::string subblocklabel = ""; 
     RetCond rcond = TRUE; 
     while(std::getline(cf,line)) { 
       desc = data = "";  
       std::istringstream iss(line);
       getline(iss, desc, ':');
       desc = ltrim(rtrim(desc));
       getline(iss, data);
       llvm::outs() << desc << ":" << data << "\n";
       if (desc == "apiblock") {
          std::string rcondst;
          std::istringstream iss2(data);
          getline(iss2, mainapi, ',');
          getline(iss2, rcondst, ','); 
          mainapi = ltrim(rtrim(mainapi));
          rcondst = ltrim(rtrim(rcondst));           
          if (rcondst == "zero")
             rcond = ZERO;
          else if (rcondst == "ltzero")
             rcond = LTZERO;
          else if (rcondst == "lteqzero")
             rcond = LTEQZERO;
          else if (rcondst == "gtzero")
             rcond = GTZERO;
          else if (rcondst == "gteqzero")
             rcond = GTEQZERO;
          else if (rcondst == "nonzero")
             rcond = NOTZERO;
          apiblock = new APIBlock();
          apiblock->setReturnCond(rcond);
       }
       else if (desc == "endapiblock") {
          addAction(mainapi, apiblock);  
          addSubblock(mainapi, apiblock);
          mainapi = "";        
          apiblock = NULL;
          rcond = TRUE;
       } 
       else if (desc == "apisubblock") {
          std::istringstream iss2(data); 
          getline(iss2, mainapi, ',');
          getline(iss2, subblocklabel, ',');
          mainapi = ltrim(rtrim(mainapi));
          subblocklabel = ltrim(rtrim(subblocklabel));
          apiblock = new APIBlock();
       }
       else if (desc == "endapisubblock") {
          addSubblock(subblocklabel, apiblock);
          mainapi = "";  
          subblocklabel = "";
          apiblock = NULL;
          rcond = TRUE;
       }
       else if (desc == "assembly") {
          std::string afunc;
          afunc = ltrim(rtrim(data));
          assemblyFunctions.insert(afunc);
          llvm::outs() << "assembly " << afunc << "\n"; 
       }
       else {
          std::vector<std::string> par(0);
          std::istringstream iss2(data);
          read(iss2, par);
          APIAction *a = NULL;
          if (desc[0] == '/' && desc[1] == '/') 
             continue;
          if (desc == "terminate") {
             if (par.size() == 1)
                par.insert(par.begin(), mainapi);
             a = new APIAction(desc, par, terminateAPIHandler);
             llvm::outs() << "registering terminate expr "; a->print();
             assert(par.size() == 2 && "Incorrect number of params for terminate spec!");
          }
          else if (desc == "side-effect") {
             if (par.size() == 1)
                par.insert(par.begin(), mainapi);
             a = new APIAction(desc,par,sideEffectAPIHandler);
             llvm::outs() << "registering sideeffect expr "; a->print();
             assert(par.size() == 2 && "Incorrect number of params for side-effect spec!");
          }
          else if (desc == "anon_alloc,type,initzero,symbolic,return,symname") {
            if (par.size() == 5)
               par.insert(par.begin(), "anonymous");
            a = new APIAction(desc,par,allocAPIHandler);
            llvm::outs() << "anon_alloc,type,sym,symname"; a->print();
            assert(par.size() == 6 && "Incorrect number of params for anonymous alloc spec!");  
          }
          else if (desc == "alloc,parameter,initzero,symbolic,return,symname") {
             if (par.size() == 5)
                par.insert(par.begin(), mainapi); 
             a = new APIAction(desc,par,allocAPIHandler);
             llvm::outs() << " alloc,parameter,initzero,sym interface "; a->print();
             assert(par.size() == 6 && "Incorrect number of params for alloc spec!"); 
          }
          else if (desc == "anon_alloc,size,initzero,symbolic,return,symname") {
             if (par.size() == 5)
                par.insert(par.begin(), "anonymous"); 
             a = new APIAction(desc,par,allocAPIHandler);
             llvm::outs() << " alloc,size,initzero,sym interface "; a->print();
             assert(par.size() == 6 && "Incorrect number of params for alloc spec!"); 
          }
          else if (desc == "anon_free,parameter") {
             if (par.size() == 1)
                par.insert(par.begin(), "anonymous");
             a = new APIAction(desc, par, freeAPIHandler);
             llvm::outs() << "anon_free,parameter interface "; a->print();
             assert(par.size() == 2 && "Incorrect number of params for anonymous free spec!"); 
          }
          else if (desc == "free,parameter") {
             if (par.size() == 1)
                par.insert(par.begin(), mainapi); 
             a = new APIAction(desc, par, freeAPIHandler);
             llvm::outs() << " free,parameter interface "; a->print(); 
             assert(par.size() == 2 && "Incorrect number of params for free spec!");
          }
          else if (desc == "return") {
             if (par.size() == 1)
                par.insert(par.begin(), mainapi); 
             a = new APIAction(desc, par, returnAPIHandler);
             llvm::outs() << " return interface "; a->print();
             assert(par.size() == 2 && "Incorrect number of params for return spec!");
          }
          else if (desc == "refcount,op,expr,value,onzerocb") {
             if (par.size() == 4)
                par.insert(par.begin(), mainapi); 
             a = new APIAction(desc, par, refcountAPIHandler);
             llvm::outs() << " refcount,op,expr,value,onzerocb interface "; a->print();
             assert(par.size() == 5 && "Incorrect number of params for refcount spec!");
          }
          else if (desc == "callback") {
             if (par.size() == 1)
                par.insert(par.begin(), mainapi); 
             a = new APIAction(desc, par, callbackAPIHandler); 
             llvm::outs() << "callback interface "; a->print();
             assert(par.size() == 2 && "Incorrect number of params for callback spec!");
          }
          else if (desc == "cond_callback") {
             if (par.size() == 2)
                par.insert(par.begin(), mainapi); 
             a = new APIAction(desc, par, callbackAPIHandler); 
             llvm::outs() << "cond_callback interface "; a->print();
             assert(par.size() == 3 && "Incorrect number of params for cond_callback spec!");
          }          
          else if (desc == "ignore") {
             if (par.size() == 0)
                par.insert(par.begin(), mainapi); 
             a = new APIAction(desc,par,ignoreAPIHandler);
             llvm::outs() << "ignore interface "; a->print();
             assert(par.size() == 1 && "Incorrect number of params for ignore spec!");
          }
          if (apiblock) {
             if (a) {
                a->setFunctionName(mainapi);
                apiblock->addNextAction(a, rcond);
                a = NULL;
             }
          }
          else {
             if (a) {
                addAction(par[0],a);
                a = NULL;
             }
          }
       }
      
     }
     llvm::outs() << "Parsed Prog Model Spec \n";     
     for(auto acs : apiModel) {
        llvm::outs() << acs.first << ":\n";
        for(auto ac : acs.second) {
           ac->print();
        }
     } 
     for(auto st : symbolTable) {
       llvm::outs() << "subblock labeled " << st.first << "\n";
       st.second->print();
     }
     cf.close();
  }
}


bool APIHandler::interpret(PMFrame &pmf, APIAction *action, ExecutionState &state, std::vector< ref<Expr> > &arguments, 
            KInstruction *target, bool &term, bool &comp, bool &abort,ref<Expr> &offendingAddress,  int tid) {
     llvm::outs() << "Superclass interpret should not be executing!\n";
     return true;
}


bool APIHandler::setsArgs() {
   return true;
}


APIAction::APIAction()  {
  handler = NULL;
  terminated = false;
  std::vector<std::string> p(0);
  param = p;
  fname = "";
}

       
APIAction::APIAction(std::string desc, std::vector<std::string> param, APIHandler *handler, RetCond retCond) {
   this->desc = desc;
   this->param = param;
   this->handler = handler;
   returnCondition = retCond;
   terminated = false;
   fname = "";
}

APIAction::APIAction(const APIAction &a) {
   desc = a.desc;
   param = a.param;
   handler = a.handler;
   returnCondition = a.returnCondition;
   terminated = a.terminated;
   fname = a.fname;
}

bool APIAction::hasTerminated() {
  return terminated;
}

void APIAction::terminate() {
  terminated = true;
}

int APIAction::getNumActions() {
  return 1;
}

std::vector<std::string> APIAction::getParams() {
    return param;
}

RetCond APIAction::getReturnCond() {
   return returnCondition;
}

void APIAction::setReturnCond(RetCond rt) {
  returnCondition = rt;
}

void APIAction::setFunctionName(std::string fn) {
   fname = fn;
}
       
std::string APIAction::getFunctionName() {
  return fname;
}

       
bool APIAction::assignsRetValue() {
   llvm::errs() << "Checking return value with the handler..\n";
   return handler->assignsRetValue(this);
}

bool APIAction::setsArgs() {
   return handler->setsArgs();
}


void APIAction::execute(PMFrame &pmf, ExecutionState &state, std::vector< ref<Expr> > &arguments, 
          KInstruction *target, bool &term, bool &comp, bool &abort, ref<Expr> &offendingAddress,  int tid) {
  handler->interpret(pmf, this, state, arguments, target, term, comp, abort, offendingAddress, tid);
}

void APIAction::print() {
   llvm::errs() << desc << ":" ;
   for(auto p : param) {
      llvm::errs() << p << ",";
   }
   llvm::errs() << "\n";
}

APIBlock::APIBlock() : APIAction() {
  returnCondition = TRUE;
}

APIBlock::APIBlock(const APIBlock &ab) : APIAction(ab) {
  body = ab.body;
  returnCondition = ab.returnCondition;
}

void APIBlock::addNextAction(APIAction *action, RetCond rcond) {
   action->setReturnCond(rcond);
   body.push_back(action);
}

bool APIBlock::assignsRetValue() {
   llvm::errs() << "Checking return value for " << desc << "\n";
   for(auto a : body) {
       a->print();
       if (a->assignsRetValue()) {
          llvm::errs() << "Assigns return value!\n";
          return true;
       }
   }
   return false;
}

bool APIBlock::setsArgs() {
   for(auto action : body) {
       if (action->setsArgs())
          return true;
   }
   return false;
}

int APIBlock::getNumActions() {
  return body.size();
}

void APIBlock::execute(PMFrame &pmf, ExecutionState &state, std::vector< ref<Expr> > &arguments, 
         KInstruction *target, bool &term, bool &comp, bool &abort, ref<Expr> &offendingAddress, int tid) {
     term = false;
     comp = true;
     int i = state.getPMAction();
     for(int i = state.getPMAction(); i < body.size(); i++) {
        if (!term)  {
           bool term2 = false;
           bool comp2 = false;
           body[i]->execute(pmf, state, arguments, target, term2, comp2, abort, offendingAddress, tid);
           if (abort) return;
           if (term2) {
              term = term2;
              break;
           }
           if (!comp2) {
              // we use the handle to the relevant PMFrame
              // in case another frame has been pushed on the PMstack, e.g., apisubblock	
              pmf.setPMAction(i+1);
              comp = false;
              break;
           } 
        }
     }
     if (comp)
        pmf.setPMAction(body.size());
}

void APIBlock::print() {
     llvm::outs() << "Return condition=" << returnCondition << "\n";
     for(auto action : body) {
        action->print();
     }
}

/* SYSREL EXTENSION */



