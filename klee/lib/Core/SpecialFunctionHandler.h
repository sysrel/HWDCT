//===-- SpecialFunctionHandler.h --------------------------------*- C++ -*-===//
//
//                     The KLEE Symbolic Virtual Machine
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#ifndef KLEE_SPECIALFUNCTIONHANDLER_H
#define KLEE_SPECIALFUNCTIONHANDLER_H

#include <iterator>
#include <map>
#include <vector>
#include <string>
#include <set>
#include "llvm/IR/DataLayout.h"

namespace llvm {
  class Function;
}


namespace klee {
  class Executor;
  class Expr;
  class ExecutionState;
  struct KInstruction;
  template<typename T> class ref;

  /* SYSREL EXTENSION */
  class PMFrame; 
  class RefCountAPIHandler;
  class AllocAPIHandler;
  class FreeAPIHandler;
  class IgnoreAPIHandler;
  class SideEffectAPIHandler;
  class TerminateAPIHandler;
  class CallbackAPIHandler;
  class RefcountAPIHandler;
  class ReturnAPIHandler;
  class APIAction;
  class APIBlock;



  class APIHandler {
   protected:
    //static RegistrationAPIHandler  *regAPIHandler; 
    //static ResourceAllocReleaseAPIHandler *resADAPIHandler;
    //static MutexAPIHandler*  mutexAPIHandler;
    //static SetGetAPIHandler *setgetAPIHandler;
    //static ReadWriteAPIHandler *readWriteAPIHandler;
    ref<Expr> eval(ExecutionState &state,  const llvm::DataLayout &dl, llvm::Function *f, 
                     std::vector< ref<Expr> > &arguments, std::string expr, KInstruction *target, bool address, bool &abort);
    void executeCallback(ExecutionState &state, std::string cbexpr, std::vector< ref<Expr> > &arguments, 
         KInstruction *target, bool &comp, bool &abort, int tid=-1) ;
    bool checkCondition(APIAction *action, ExecutionState &state, 
      std::vector< ref<Expr> > &arguments, std::string cexpr, KInstruction *target, bool &abort);
    static std::map<std::string, APIAction*> symbolTable;
    public:
     static void addAction(std::string, APIAction *action);
     static void addSubblock(std::string, APIAction *action);
     static APIAction *getSubblock(std::string);
     static APIAction* lookup(std::string);
     static TerminateAPIHandler* terminateAPIHandler;
     static SideEffectAPIHandler *sideEffectAPIHandler;
     static  std::map<std::string, std::set<APIAction*>> apiModel;
     static IgnoreAPIHandler *ignoreAPIHandler;
     static AllocAPIHandler *allocAPIHandler;
     static FreeAPIHandler *freeAPIHandler;
     static RefCountAPIHandler *refcountAPIHandler;
     static CallbackAPIHandler *callbackAPIHandler;
     static ReturnAPIHandler *returnAPIHandler;
     static void readProgModelSpec(const char *name);
     static void addIgnoreHandler(std::string fname);
     static bool handle(ExecutionState &state, std::vector<ExecutionState*> &branches, std::string fname, 
                               std::vector< ref<Expr> > &arguments, KInstruction *target, bool &abort, ref<Expr> &offendingAddress, int tid=-1);
     static bool handles(std::string fname);
     static bool isIgnore(std::string fname);
     APIHandler();
     virtual bool interpret(PMFrame &pmf, APIAction *action, ExecutionState &state, 
        std::vector< ref<Expr> > &arguments, KInstruction *target, bool &term, bool &comp, bool &abort, ref<Expr> &offendingAddress, int tid);
     virtual bool assignsRetValue(APIAction *action);
     bool setsArgs();
  };

  enum RetCond {ZERO, NOTZERO, LTZERO, LTEQZERO, GTZERO, GTEQZERO, TRUE};


  class APIAction {
    protected: 
       // first element is the api function name
       std::vector<std::string> param;
       APIHandler *handler;
       RetCond returnCondition;
       bool terminated;
       std::string fname;
    public:
       std::string  desc;
       APIAction();
       APIAction(std::string desc, std::vector<std::string> param, APIHandler *handler, RetCond retCond=TRUE);
       APIAction(const APIAction &); 
       bool hasTerminated();
       void terminate();
       std::vector<std::string> getParams();
       RetCond getReturnCond();
       void setReturnCond(RetCond rt);
       void setFunctionName(std::string);
       std::string getFunctionName();
       virtual bool assignsRetValue();
       virtual bool setsArgs();
       virtual int getNumActions();
       void addChainAction(APIAction *action);
       virtual void execute(PMFrame &pmf, ExecutionState &state, std::vector< ref<Expr> > &arguments, 
             KInstruction *target, bool &term, bool &comp, bool &abort, ref<Expr> &offendingAddress, int tid = -1);
       virtual void print();
  };


  class APIBlock : public APIAction {
    protected:
       std::vector<APIAction*> body;
    public:
       APIBlock();
       APIBlock(const APIBlock &); 
       void addNextAction(APIAction *action, RetCond rc=TRUE);
       virtual bool assignsRetValue();
       virtual bool setsArgs();       
       virtual int getNumActions();
       virtual void execute(PMFrame &pmf, ExecutionState &state, std::vector< ref<Expr> > &arguments, 
             KInstruction *target, bool &term, bool &comp, bool &abort, ref<Expr> &offendingAddress, int tid = -1);  
       virtual void print();
  };



  /*
  class MutexAPIHandler : public APIHandler {
    private:
     std::set<std::string> initSet;
     std::map<std::string, std::string> initMap;
     std::map<std::string, std::string> acqRelMap;
     std::set<std::string> releaseSet;     
     bool handle(std::map<ref<Expr>, int> &stateModel, std::string fname, std::vector< ref<Expr> > &arguments);
    public:
     MutexAPIHandler();
     void addInitAcqRel(std::string acqf, std::string relf, std::string initf="");
     bool handle(ExecutionState &state, std::string fname, std::vector< ref<Expr> > &arguments);
     bool handle(ExecutionState &state, std::string fname, std::vector< ref<Expr> > &arguments, int tid);
    
  };
  */ 

  class ReturnAPIHandler : public APIHandler {
    public:      
     ReturnAPIHandler();
     virtual bool interpret(PMFrame &pmf, APIAction *action,ExecutionState &state,  
          std::vector< ref<Expr> > &arguments, KInstruction *target, bool &term, bool &comp, bool &abort, ref<Expr> &offendingAddress, int tid=-1);      
     virtual bool assignsRetValue(APIAction *action);

  };


  class RefCountAPIHandler : public APIHandler {
    public:      
     RefCountAPIHandler();
     virtual bool interpret(PMFrame &pmf, APIAction *action,ExecutionState &state,  
          std::vector< ref<Expr> > &arguments, KInstruction *target, bool &term, bool &comp, bool &abort, ref<Expr> &offendingAddress, int tid=-1);      
     virtual bool assignsRetValue(APIAction *action);

  };
 
  /*
  
  class RegistrationAPIHandler : public APIHandler {
    private:
     std::map<std::string, std::string> regAPIMap;
     std::map<std::string, std::string> unregAPIMap;
     std::map<std::string, std::set<std::string> > enabledFuncs;
     bool handle(std::map<ref<Expr>, int> &stateModel, std::string fname, std::vector< ref<Expr> > &arguments); 
    public:
     RegistrationAPIHandler();
     void addRegUnreg(std::string regf, std::string unregf, std::set<std::string> enabled);
     bool handle(ExecutionState &state, std::string fname, std::vector< ref<Expr> > &arguments);     
     bool handle(ExecutionState &state, std::string fname, std::vector< ref<Expr> > &arguments, int tid);     
     bool getEnabled(std::string reg, std::set<std::string> &q);
     bool getDisabled(std::string unreg, std::set<std::string> &q);  
  };

  class ResourceAllocReleaseAPIHandler : public APIHandler {
   public:
      ResourceAllocReleaseAPIHandler();
      bool interpret(APIAction &action,ExecutionState &state, std::string fname, std::vector< ref<Expr> > &arguments, bool &term, int tid=-1); 
  };

  class SetGetAPIHandler : public APIHandler {
   public:
     SetGetAPIHandler();
     bool interpret(APIAction &action,ExecutionState &state, std::string fname, std::vector< ref<Expr> > &arguments, KInstruction *target, bool &term, int tid=-1);
  };   
*/

   class AllocAPIHandler : public APIHandler {
    public:
      AllocAPIHandler();
      virtual bool interpret(PMFrame &pmf, APIAction *action, ExecutionState &state, std::vector< ref<Expr> > &arguments, 
                   KInstruction *target, bool &term, bool &comp, bool &abort, ref<Expr> &offendingAddress,  int tid=-1);     
      virtual bool assignsRetValue(APIAction *action);
  
   };

   class FreeAPIHandler : public APIHandler {
    public:
      FreeAPIHandler();
      virtual bool interpret(PMFrame &pmf, APIAction *action, ExecutionState &state, std::vector< ref<Expr> > &arguments, 
                   KInstruction *target, bool &term, bool &comp, bool &abort, ref<Expr> &offendingAddress, int tid=-1);       
      virtual bool assignsRetValue(APIAction *action);
  
   };

   /*
   class ReadWriteAPIHandler : public APIHandler {
    private:
     std::set<std::string> readAPI;
     std::set<std::string> writeAPI;
     std::map<std::string, std::pair<int,int> > writeAPIMap;
     bool handle(ExecutionState &state, int tid, std::string fname, std::vector< ref<Expr> > &arguments, KInstruction *target);
    public:
      ReadWriteAPIHandler();
      void addRead(std::string read); 
      void addWrite(std::string write); 
      // parameter position for the source location and the destination location
      void addWrite(std::string write, int source, int dest); 
      bool handle(ExecutionState &state, std::string fname, std::vector< ref<Expr> > &arguments, KInstruction *target);
      bool handle(ExecutionState &state, std::string fname, std::vector< ref<Expr> > &arguments, KInstruction *target, int tid);
   };
  */

   class IgnoreAPIHandler : public APIHandler {
    public:
     IgnoreAPIHandler();
     virtual bool interpret(PMFrame &pmf, APIAction *action, ExecutionState &state, std::vector< ref<Expr> > &arguments, 
                              KInstruction *target, bool &term, bool &comp, bool &abort, ref<Expr> &offendingAddress, int tid=-1); 
     virtual bool assignsRetValue(APIAction *action);
   };

   
   class CallbackAPIHandler : public APIHandler {
    public:
     CallbackAPIHandler();
     virtual bool interpret(PMFrame &pmf, APIAction *action, ExecutionState &state, std::vector< ref<Expr> > &arguments, 
                             KInstruction *target, bool &term, bool &comp, bool &abort, ref<Expr> &offendingAddress, int tid=-1);              
     virtual bool assignsRetValue(APIAction *action); 
   };
   

   class SideEffectAPIHandler : public APIHandler {
     public:
      SideEffectAPIHandler(); 
      virtual bool interpret(PMFrame &pmf, APIAction *action, ExecutionState &state, std::vector< ref<Expr> > &arguments, 
                                KInstruction *target, bool &term, bool &comp, bool &abort, ref<Expr> &offendingAddress, int tid=-1);         
      virtual bool assignsRetValue(APIAction *action);
     
   };

   class TerminateAPIHandler : public APIHandler {
    public:
     TerminateAPIHandler();
     virtual bool interpret(PMFrame &pmf, APIAction *action, ExecutionState &state, std::vector< ref<Expr> > &arguments, 
                                KInstruction *target, bool &term, bool &comp, bool &abort, ref<Expr> &offendingAddress, int tid=-1);         
     virtual bool assignsRetValue(APIAction *action);
   };

  /* SYSREL EXTENSION */ 

  class SpecialFunctionHandler {
  public:
    typedef void (SpecialFunctionHandler::*Handler)(ExecutionState &state,
                                                    KInstruction *target, 
                                                    std::vector<ref<Expr> > 
                                                      &arguments);
    typedef std::map<const llvm::Function*, 
                     std::pair<Handler,bool> > handlers_ty;

    handlers_ty handlers;
    class Executor &executor;

    struct HandlerInfo {
      const char *name;
      SpecialFunctionHandler::Handler handler;
      bool doesNotReturn; /// Intrinsic terminates the process
      bool hasReturnValue; /// Intrinsic has a return value
      bool doNotOverride; /// Intrinsic should not be used if already defined
    };

    // const_iterator to iterate over stored HandlerInfo
    // FIXME: Implement >, >=, <=, < operators
    class const_iterator : public std::iterator<std::random_access_iterator_tag, HandlerInfo>
    {
      private:
        value_type* base;
        int index;
      public:
      const_iterator(value_type* hi) : base(hi), index(0) {};
      const_iterator& operator++();  // pre-fix
      const_iterator operator++(int); // post-fix
      const value_type& operator*() { return base[index];}
      const value_type* operator->() { return &(base[index]);}
      const value_type& operator[](int i) { return base[i];}
      bool operator==(const_iterator& rhs) { return (rhs.base + rhs.index) == (this->base + this->index);}
      bool operator!=(const_iterator& rhs) { return !(*this == rhs);}
    };

    static const_iterator begin();
    static const_iterator end();
    static int size();



  public:
    SpecialFunctionHandler(Executor &_executor);

    /// Perform any modifications on the LLVM module before it is
    /// prepared for execution. At the moment this involves deleting
    /// unused function bodies and marking intrinsics with appropriate
    /// flags for use in optimizations.
    void prepare();

    /// Initialize the internal handler map after the module has been
    /// prepared for execution.
    void bind();

    bool handle(ExecutionState &state, 
                llvm::Function *f,
                KInstruction *target,
                std::vector< ref<Expr> > &arguments);

    /* Convenience routines */

    std::string readStringAtAddress(ExecutionState &state, ref<Expr> address);
    
    /* Handlers */

#define HANDLER(name) void name(ExecutionState &state, \
                                KInstruction *target, \
                                std::vector< ref<Expr> > &arguments)
    HANDLER(handleAbort);
    HANDLER(handleAssert);
    HANDLER(handleAssertFail);
    HANDLER(handleAssume);
    HANDLER(handleCalloc);
    HANDLER(handleCheckMemoryAccess);
    HANDLER(handleDefineFixedObject);
    HANDLER(handleDelete);    
    HANDLER(handleDeleteArray);
    HANDLER(handleExit);
    HANDLER(handleErrnoLocation);
    HANDLER(handleAliasFunction);
    HANDLER(handleFree);
    HANDLER(handleGetErrno);
    HANDLER(handleGetObjSize);
    HANDLER(handleGetValue);
    HANDLER(handleIsSymbolic);
    HANDLER(handleMakeSymbolic);
    HANDLER(handleMalloc);
    HANDLER(handleMarkGlobal);
    HANDLER(handleOpenMerge);
    HANDLER(handleCloseMerge);
    HANDLER(handleNew);
    HANDLER(handleNewArray);
    HANDLER(handlePreferCex);
    HANDLER(handlePosixPreferCex);
    HANDLER(handlePrintExpr);
    HANDLER(handlePrintRange);
    HANDLER(handleRange);
    HANDLER(handleRealloc);
    HANDLER(handleReportError);
    HANDLER(handleRevirtObjects);
    HANDLER(handleSetForking);
    HANDLER(handleSilentExit);
    HANDLER(handleStackTrace);
    HANDLER(handleUnderConstrained);
    HANDLER(handleWarning);
    HANDLER(handleWarningOnce);
    HANDLER(handleAddOverflow);
    HANDLER(handleMulOverflow);
    HANDLER(handleSubOverflow);
    HANDLER(handleDivRemOverflow);
    /* SYSREL extension */
    HANDLER(handleRecordStepTraceLocally);//Versym
    HANDLER(handleSetMetadata);
    HANDLER(handleGetMetadata);
	
	///@{ HWDCT extension
	// DCT detection
    HANDLER(handleAddMetadataGlobally);
    HANDLER(handleDontCareTransitionGlobally);
	// Trojan prediction
    HANDLER(handleAddForwardRegisterMetadataGlobally);
    HANDLER(handleAddCheckAbstractRegisterMetadataGlobally);
	// Trojan explanation
    HANDLER(handleAddOutputMetadataGlobally);
    HANDLER(handleAddBackOutputMetadataGlobally);
    HANDLER(handleDetectOutputTrojan);
	// DCT aware Reachability Analysis
	HANDLER(handleDCTAwarePath);
    HANDLER(handleAllTransitionFromGivenSrcGlobally);
    ///@}
	
    HANDLER(handleCheckAndRecordPCGlobally);
    HANDLER(handleCheckAndRecordPCWithAssumeGlobally);
    HANDLER(handleAddAssumeAsPC);
    
    HANDLER(handleRecordInitialStateGlobally);
    HANDLER(handleCheckReachInitialStateGlobally);
    HANDLER(handleCheckReachInitialStateRegGlobally);
    /* hybrid fuzzing exetension start*/
    HANDLER(handleAddGuardSignal);
    /* hybrid fuzzing exetension end  */
	  
    ///@{ Analyze hack@dac 21 benchmark
    HANDLER(handleCheckConstraintVarGlobally);
    ///@}
    
	  /* Ruochen */
  	HANDLER(handleClearPrevPCGlobally);
	HANDLER(handleAcquireInputModelGlobally);
    HANDLER(handlePrintPatternValue);
    HANDLER(handlePrintPatternAdressValue);
	  /* Ruochen */
    
    HANDLER(handleAcquireInputPatternGlobally);
    HANDLER(handleAcquireInputPatternPreviousCycleGlobally);
    HANDLER(handleClearPCGlobally);

    HANDLER(handleAllTransitionFromGivenUnreachableSrcOneStepGlobally);
    
    HANDLER(handleAddTransitionMetadataGlobally);
    
    HANDLER(handleAddOneForwardRegisterMetadataGlobally);//klee_add_one_forward_reg_metadata_globally
    HANDLER(handleAddCheckAbstractOneRegisterMetadataGlobally);//klee_add_and_check_abstract_one_reg_metadata_globally
    
    HANDLER(handleCheckDCTfinishTime);
    HANDLER(handleAddInterMetadataGlobally);
    
    HANDLER(handleSetSourceState);
    HANDLER(handleSetDestState);

    HANDLER(handleAddMetadataLocally);
    HANDLER(handleAddMetadataLocallyTwoInput);
    HANDLER(handleAddMetadataLocallyThreeInput);
    HANDLER(handleAddMetadataLocallyFourInput);
    
    HANDLER(handleDontCareTransitionLocally);
    HANDLER(handleDontCareTransitionLocallyTwoInput);
    HANDLER(handleDontCareTransitionLocallyThreeInput);
    HANDLER(handleDontCareTransitionLocallyFourInput);
    
    HANDLER(handleAddMetadataGloballyOnCondition);
    HANDLER(handleAddMetadataLocallyOnCondition);
    HANDLER(handleRecordMetadataGloballyOnCondition);
    HANDLER(handleRecordMetadataLocallyOnCondition);
    HANDLER(handleReportDiffMetadataGlobally);
    HANDLER(handleReportDiffMetadataLocally);
    HANDLER(handleCheckMetadataMembershipGlobally);
    HANDLER(handleCheckMetadataMembershipLocally);
    HANDLER(handleFindTupleForDiffLocally); 
    
    /* SYSREL extension */
#undef HANDLER

  };
} // End klee namespace

#endif
