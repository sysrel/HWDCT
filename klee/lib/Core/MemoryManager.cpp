//===-- MemoryManager.cpp -------------------------------------------------===//
//
//                     The KLEE Symbolic Virtual Machine
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "CoreStats.h"
#include "Memory.h"
#include "MemoryManager.h"
#include "Executor.h"

#include "klee/Expr.h"
#include "klee/Internal/Support/ErrorHandling.h"
#include "klee/Interpreter.h"

#include "llvm/Support/CommandLine.h"
#include "llvm/Support/MathExtras.h"
#include "llvm/IR/DebugLoc.h"
#include "llvm/IR/LLVMContext.h"

#include <inttypes.h>
#include <sys/mman.h>
#include "klee/Internal/Module/KInstruction.h"
#include "klee/ExecutionState.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/DataLayout.h"

using namespace klee;

/* SYSREL EXTENSION */

// should be made default true eventually!
llvm::cl::opt<bool>
DisableEmbedding("disable-embedding", llvm::cl::desc("Disabled embedding by creating every object as is\n"),
llvm::cl::init(false));

extern const llvm::Module * moduleHandle;
extern std::set<llvm::Type*> embeddedTypes;
extern std::map<llvm::Type*, std::set<llvm::Type*> >  embeddingTypes;
extern std::string getTypeName(llvm::Type*);
extern bool isEmbeddedType(llvm::Type *t);
extern Interpreter *theInterpreter;
extern bool isAllocTypeLazyInit(llvm::Type *t, bool &single, int &count) ;
extern std::map<std::string, std::vector<std::string> > inferenceClue;
extern size_t maxVoidTypeCastSize;
extern bool staticAllocStatTracking;
extern int staticAlloc;
extern void addSingleOrDerivative(ExecutionState &state, ref<Expr> address);
extern std::map<long, std::map<ref<Expr>, const MemoryObject *> > addressToMemObj;
extern llvm::cl::opt<bool> PreferredResolution;
#define SIZE_FOR_UNTYPED 8
extern void recordLazyInitMemoryObject(ExecutionState &state, const MemoryObject *mo);

/* SYSREL EXTENSION */

void recordMemObj(ExecutionState &state, const MemoryObject *mo) {
    if (!mo) return;
    if (PreferredResolution) {
       std::map<ref<Expr>, const MemoryObject *> m;
       if (addressToMemObj.find((long)&state) != addressToMemObj.end()) {
          m = addressToMemObj[(long)&state];
          m[mo->getBaseExpr()] = mo;
          addressToMemObj[(long)&state] = m; 
       }
       else {
         m[mo->getBaseExpr()] = mo;
         addressToMemObj[(long)&state] = m; 
       }
       llvm::errs() << "storing memobj " << mo->getBaseExpr() << " for state " << &state << "\n";
    }
}

namespace {
llvm::cl::opt<bool> DeterministicAllocation(
    "allocate-determ",
    llvm::cl::desc("Allocate memory deterministically(default=off)"),
    llvm::cl::init(false));

llvm::cl::opt<unsigned> DeterministicAllocationSize(
    "allocate-determ-size",
    llvm::cl::desc(
        "Preallocated memory for deterministic allocation in MB (default=100)"),
    llvm::cl::init(100));

llvm::cl::opt<bool>
    NullOnZeroMalloc("return-null-on-zero-malloc",
                     llvm::cl::desc("Returns NULL in case malloc(size) was "
                                    "called with size 0 (default=off)."),
                     llvm::cl::init(false));

llvm::cl::opt<unsigned> RedZoneSpace(
    "red-zone-space",
    llvm::cl::desc("Set the amount of free space between allocations. This is "
                   "important to detect out-of-bound accesses (default=10)."),
    llvm::cl::init(10));

llvm::cl::opt<unsigned long long> DeterministicStartAddress(
    "allocate-determ-start-address",
    llvm::cl::desc("Start address for deterministic allocation. Has to be page "
                   "aligned (default=0x7ff30000000)."),
    llvm::cl::init(0x7ff30000000));
}

/***/
MemoryManager::MemoryManager(ArrayCache *_arrayCache)
    : arrayCache(_arrayCache), deterministicSpace(0), nextFreeSlot(0),
      spaceSize(DeterministicAllocationSize.getValue() * 1024 * 1024) {
  if (DeterministicAllocation) {
    // Page boundary
    void *expectedAddress = (void *)DeterministicStartAddress.getValue();

    char *newSpace =
        (char *)mmap(expectedAddress, spaceSize, PROT_READ | PROT_WRITE,
                     MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);

    if (newSpace == MAP_FAILED) {
      klee_error("Couldn't mmap() memory for deterministic allocations");
    }
    if (expectedAddress != newSpace && expectedAddress != 0) {
      klee_error("Could not allocate memory deterministically");
    }

    klee_message("Deterministic memory allocation starting from %p", newSpace);
    deterministicSpace = newSpace;
    nextFreeSlot = newSpace;
  }
}

MemoryManager::~MemoryManager() {
  while (!objects.empty()) {
    MemoryObject *mo = *objects.begin();
    if (!mo->isFixed && !DeterministicAllocation)
      free((void *)mo->address);
    objects.erase(mo);
    delete mo;
  }

  if (DeterministicAllocation)
    munmap(deterministicSpace, spaceSize);
}


/* SYSREL extension */

 MemoryObject *MemoryManager::getInstanceForType(ExecutionState &state, llvm::Type *t) {
     if (state.lazyInitSingleInstances.find(t) != state.lazyInitSingleInstances.end())
        return state.lazyInitSingleInstances[t];
     return NULL;
}


ref<Expr> MemoryManager::getInstanceAddressForType(ExecutionState &state, llvm::Type *t, bool &result) {
   llvm::errs() << "in getInstanceAddressForType " << getTypeName(t) << " type pointer=" << t << "\n";
  if (state.lazyInitSingleInstances.find(t) != state.lazyInitSingleInstances.end()) {
      result = true;
     return state.lazyInitSingleInstances[t]->getBaseExpr();
  }
  else  {
        // Grab the address mapped to this type
        if (state.typeToAddr.find(t) != state.typeToAddr.end()) {
            llvm::outs() << "found the instance for type " << getTypeName(t) << "\n";
            result = true;
            return state.typeToAddr[t];
        }
        // Grab the address for one of its ancestor embedding type and use the relative offset to compute the address
        //bool found = false;
        //while (!found) {
        if (embeddedTypes.find(t) != embeddedTypes.end()) {
           std::set<llvm::Type*> embset = embeddingTypes[t];
           if (embset.size() > 1) {
               llvm::errs() << "Warning: Single instance embedded type has multiple embedders!\n";
           }
           else { // must be one
               for(auto et : embset) {
                  
                  llvm::StructType *set = dyn_cast<llvm::StructType>(et);
                  assert(set);
                  bool res; 
                  ref<Expr> eaddr = getInstanceAddressForType(state, et, res);
                  if (res) {
                     const llvm::DataLayout &dl = moduleHandle->getDataLayout();
                     const llvm::StructLayout *sl =  dl.getStructLayout(set);
                     unsigned i = 0;
                     for(; i< set->getNumElements(); i++) {                   
                        if (set->getElementType(i) == t) {
                           llvm::outs() << "matched element " << i << " to type " << getTypeName(t) << "\n";
                            break;
                        }
                     }
                     assert(i >=0  && i < set->getNumElements());
                     ref<Expr> re = AddExpr::create(ConstantExpr::create(sl->getElementOffset(i), Expr::Int64), eaddr);
                     llvm::outs() << "instance for embedded type found at " << re << " after adding offset " << sl->getElementOffset(i) << " for element " << i << " to addr " << eaddr << "\n";
                     result = true;
                     return re;
                   }
                     
               }
          }
          // }
      }
  }
  result = false;
  return ConstantExpr::alloc(0, Expr::Int64);
}

// todo: pass the base type and the count
// assuming a byte array for now
MemoryObject *MemoryManager::simulateMalloc(ExecutionState &state, ref<Expr> size) {
 size_t allocationAlignment = 8;
 if (ConstantExpr *CE = dyn_cast<ConstantExpr>(size)) {
    llvm::LLVMContext &ctx = moduleHandle->getContext();
    MemoryObject *mo = allocate(CE->getZExtValue(), false, /*isGlobal=*/false,
                          state.prevPC->inst, allocationAlignment, CE->getZExtValue(), 
                          llvm::Type::getInt8Ty(ctx));
    mo->name = "smalloc" + CE->getZExtValue();
    recordMemObj(state, mo);
    llvm::outs() << "simulating allocation of size : " << CE->getZExtValue() << " at address " << mo->getBaseExpr() << "\n";
    return mo;  
 } 
 assert(false && "Not simulating symbolic size memory allocations!"); 

}


/* Meant to be used internally */
const MemoryObject *MemoryManager::allocateLazyForTypeOrEmbeddingSimple(ExecutionState &state, llvm::Instruction *inst, 
         llvm::Type *origType, llvm::Type *allocType, bool isSingle, int count, llvm::Type *&rallocType, ref<Expr> &resaddr, bool &sym, bool &abort) {
     llvm::errs() << "lazy init in function " << inst->getParent()->getParent()->getName() << "\n";
     std::string type_str;
     llvm::raw_string_ostream rso(type_str);
     allocType->print(rso); 
     size_t allocationAlignment = 8;
     const llvm::DataLayout & dl = inst->getParent()->getParent()->getParent()->getDataLayout();
     llvm::LoadInst *li = dyn_cast<llvm::LoadInst>(inst);
     if (li) {
        allocationAlignment = li->getAlignment();
     } 
     else {
       allocationAlignment = dl.getPrefTypeAlignment(allocType);
     }
      MemoryObject *mo = NULL; 
     if (isSingle) {  
        if (state.lazyInitSingleInstances.find(allocType) != state.lazyInitSingleInstances.end()) {
           rallocType = allocType;
           resaddr = state.lazyInitSingleInstances[allocType]->getBaseExpr();
           if (state.isFreed(resaddr)) {
              llvm::errs() << "Single instance use after free!\n";
              ((Executor*)theInterpreter)->terminateStateOnError(state, "Single instance use after free!", Executor::Ptr);
           }
           llvm::outs() << "returning address " << state.lazyInitSingleInstances[allocType]->getBaseExpr() << " as single instance of type " << rso.str() << "\n"; 
           sym = false;
           return state.lazyInitSingleInstances[allocType];
        }
        if (isEmbeddedType(origType) && state.typeToAddr.find(allocType) != state.typeToAddr.end()) {
           bool asuccess;
           ObjectPair op;
           ((Executor*)theInterpreter)->solver->setTimeout(((Executor*)theInterpreter)->coreSolverTimeout);
           if (!state.addressSpace.resolveOne(state, ((Executor*)theInterpreter)->solver, state.typeToAddr[allocType], op, asuccess)) {
              ref<Expr> base = ((Executor*)theInterpreter)->toConstant(state, state.typeToAddr[allocType], "resolveOne failure");
              asuccess = state.addressSpace.resolveOne(cast<ConstantExpr>(base), op);
           }
           ((Executor*)theInterpreter)->solver->setTimeout(0);             
           if (asuccess) {      
              rallocType = allocType;
              if (origType == allocType) 
                 resaddr = state.typeToAddr[allocType];  
              else {
                llvm::StructType *set = dyn_cast<llvm::StructType>(allocType);
                assert(set);
                const llvm::DataLayout &dl = moduleHandle->getDataLayout();
                const llvm::StructLayout *sl =  dl.getStructLayout(set);
                unsigned i = 0;
                for(; i< set->getNumElements(); i++) {                   
                    if (set->getElementType(i) == origType) {
                       llvm::outs() << "matched element " << i << " to type " << getTypeName(origType) << "\n";
                        break;
                    }
                }
                assert(i >=0  && i < set->getNumElements());
                resaddr = AddExpr::create(ConstantExpr::create(sl->getElementOffset(i), Expr::Int64), op.first->getBaseExpr());
              }
              llvm::outs() << "returning address " << op.first->getBaseExpr() << " as embedded type ancestor instance " << rso.str() << "\n"; 
              sym = false;
              return op.first;
           }
           abort = true;
           return NULL;
           //assert(0 && "could not resolve embedded type address\n");
        }
     }
     size_t allocsize;
     if (!allocType->isSized())
        allocsize =  SIZE_FOR_UNTYPED;
     else 
        allocsize = dl.getTypeAllocSize(allocType); 
     if (allocType->isIntegerTy(8))  {
        allocsize = maxVoidTypeCastSize;
        llvm::errs() << "allocation size for void type: " << allocsize << " times " << count << "\n"; 
     }
     llvm::outs() << "allocation size: " << allocsize*count << "\n"; 
     mo = allocate(allocsize*count, false, /*true*/false, inst, allocationAlignment, count, allocType);
     recordMemObj(state, mo);
     resaddr = mo->getBaseExpr();
     rallocType = allocType;
     llvm::StructType *st = dyn_cast<llvm::StructType>(allocType);
     if (st) {
        std::string tname = getTypeName(allocType); 
        state.typeToAddr[allocType] = mo->getBaseExpr();
        // check if there is an initializer and if so execute it
	//initializeLazyInit()
        llvm::outs() << "mapping lazy instance of " << tname << " to " << mo->getBaseExpr() << "\n";
     }   

     if (isSingle) {
        state.lazyInitSingleInstances[allocType] = mo;
        llvm::errs() << "storing address " << mo->getBaseExpr() << " as single instance of type " << rso.str() << "\n"; 
        addSingleOrDerivative(state, mo->getBaseExpr());
        llvm::errs() << "recording singleton or derivative " <<  mo->getBaseExpr() << "\n";
     }
     sym = true;

     // Record the MemoryObject address as one that has been lazy init along with the size
     // need to be state specific 
     recordLazyInitMemoryObject(state, mo);
     return mo;

 }

bool isAnInferenceClue(std::string embeddedType, std::string embeddingType) {
   if (inferenceClue.find(embeddedType) != inferenceClue.end()) {
      std::vector<std::string> inf = inferenceClue[embeddedType];
      for(int i=0; i<inf.size(); i++)
         if (inf[i] == embeddingType)
            return true;
      return false;
   }
   return false;
}

// in the very first call allocType is the same as origType
// if origType is an embeddedType and the corresponding object does not exist yet, 
// recursive calls with the embedding type as the allocType is made 
const MemoryObject *MemoryManager::allocateLazyForTypeOrEmbedding(ExecutionState &state, 
         llvm::Instruction *inst, llvm::Type *origType, llvm::Type *allocType, bool isSingle, 
         int count, llvm::Type *&rallocType, ref<Expr> &resaddr, bool &sym, bool &abort, 
         llvm::Type *infenc, const char * hint) {
  std::string type_str;
  llvm::raw_string_ostream rso(type_str);
  allocType->print(rso); 
  if (isEmbeddedType(allocType) && !DisableEmbedding) {
    if (isSingle) {  
        if (state.lazyInitSingleInstances.find(allocType) != state.lazyInitSingleInstances.end()) {
           rallocType = allocType;
           resaddr = state.lazyInitSingleInstances[allocType]->getBaseExpr();
           llvm::errs() << "returning address " << state.lazyInitSingleInstances[allocType]->getBaseExpr() << " as single instance of type " << rso.str() << "\n"; 
           sym = false;
           return state.lazyInitSingleInstances[allocType];
        }
        if (isEmbeddedType(origType) && state.typeToAddr.find(allocType) != state.typeToAddr.end()) {
            bool asuccess;
           ObjectPair op;
           ((Executor*)theInterpreter)->solver->setTimeout(((Executor*)theInterpreter)->coreSolverTimeout);
           if (!state.addressSpace.resolveOne(state, ((Executor*)theInterpreter)->solver, state.typeToAddr[allocType], op, asuccess)) {
              ref<Expr> base = ((Executor*)theInterpreter)->toConstant(state, state.typeToAddr[allocType], "resolveOne failure");
              asuccess = state.addressSpace.resolveOne(cast<ConstantExpr>(base), op);
           }
           ((Executor*)theInterpreter)->solver->setTimeout(0);             
           if (asuccess) {      
              rallocType = allocType;
              if (origType == allocType) 
                 resaddr = state.typeToAddr[allocType];  
              else {
                llvm::StructType *set = dyn_cast<llvm::StructType>(allocType);
                assert(set);
                const llvm::DataLayout &dl = moduleHandle->getDataLayout();
                const llvm::StructLayout *sl =  dl.getStructLayout(set);
                unsigned i = 0;
                for(; i< set->getNumElements(); i++) {                   
                    if (set->getElementType(i) == origType) {
                       llvm::outs() << "matched element " << i << " to type " << getTypeName(origType) << "\n";
                        break;
                    }
                }
                assert(i >=0  && i < set->getNumElements());
                resaddr = AddExpr::create(ConstantExpr::create(sl->getElementOffset(i), Expr::Int64), op.first->getBaseExpr());
              }
              llvm::outs() << "returning address " << op.first->getBaseExpr() << " as embedded type ancestor instance " << rso.str() << "\n"; 
              sym = false;
              return op.first;
           }
           assert(0 && "could not resolve embedded type address\n");
        }
     }

     std::set<llvm::Type*> embset = embeddingTypes[allocType];
     if (embset.size() > 1) {
        if (isSingle)
           llvm::errs() << "Warning: Single instance embedded type has multiple embedders!\n";
     }
     const llvm::DataLayout &dl = moduleHandle->getDataLayout();
     std::string es1 = getTypeName(allocType);
     std::string hintS(hint);
     for(auto et : embset) {
           std::string es2 = getTypeName(et);
           if (inferenceClue.find(es1) != inferenceClue.end() && !isAnInferenceClue(es1, es2))
              continue;
           llvm::errs() << "Checking inference clue " << es1 << "," << es2 << "\n";
           llvm::StructType *set = dyn_cast<llvm::StructType>(et);
           assert(set);
           llvm::errs() << "moduleHandle " << moduleHandle << " set=" << set << " opaque? " << set->isOpaque() << "\n";
           const llvm::StructLayout *sl =  dl.getStructLayout(set);
           ref<Expr> sub;
           int etcount = 1;
           bool etisSingle;
           bool ilz = isAllocTypeLazyInit(et, etisSingle, etcount);
           llvm::outs() << "Chose embedded type " << es2 << " etcount= " << etcount << "\n";      
           const MemoryObject *mo = allocateLazyForTypeOrEmbedding(state, inst, origType, et, etisSingle, etcount, rallocType, sub, sym, abort);
           if (mo) {
              //const llvm::DataLayout &dl = moduleHandle->getDataLayout();
              unsigned i = 0;
              for(; i< set->getNumElements(); i++) {                   
                 if (set->getElementType(i) == allocType) {
                    llvm::outs() << "matched element " << i << " to type " << getTypeName(allocType) << "\n";
                    break;
                 }
              }
              assert(i >=0  && i < set->getNumElements());
              resaddr = AddExpr::create(ConstantExpr::create(sl->getElementOffset(i), Expr::Int64), mo->getBaseExpr());
              llvm::outs() << "instance for embedded type found at " << resaddr << " after adding offset " 
                           << sl->getElementOffset(i) << " for element " << i << " to addr " << mo->getBaseExpr() << "\n";
              return mo;
           }
                     
     }
     // even though the type is embedded, obviously there are cases where it is used independently. So create an independent memory object
     return allocateLazyForTypeOrEmbeddingSimple(state, inst, origType, allocType, isSingle, count, rallocType, resaddr, sym, abort);
  }
  else { // base case: not an embedded type
     return allocateLazyForTypeOrEmbeddingSimple(state, inst, origType, allocType, isSingle, count, rallocType, resaddr, sym, abort);
 }
}

MemoryObject *MemoryManager::allocateForLazyInit(ExecutionState &state, llvm::Instruction *inst, llvm::Type *allocType, bool isSingle, int count) {
 std::string type_str;
 llvm::raw_string_ostream rso(type_str);
 allocType->print(rso); 
 size_t allocationAlignment = 8;
 const llvm::DataLayout & dl = inst->getParent()->getParent()->getParent()->getDataLayout();
 llvm::LoadInst *li = dyn_cast<llvm::LoadInst>(inst);
 if (li) {
    allocationAlignment = li->getAlignment();
 } 
 else {
    allocationAlignment = dl.getPrefTypeAlignment(allocType);
 }
 MemoryObject *mo = NULL; 
 if (isSingle) {
    mo = getInstanceForType(state, allocType);
   if (mo) {
      llvm::outs() << "returning address " << mo->getBaseExpr() << " as single instance of type " << rso.str() << "\n"; 
      return mo;
   }
 }
 size_t allocsize;
 if (!allocType->isSized())
    allocsize = SIZE_FOR_UNTYPED;
 else 
    allocsize = dl.getTypeAllocSize(allocType);
 if (allocType->isIntegerTy(8))  {
    allocsize = maxVoidTypeCastSize;
    llvm::errs() << "allocation size for void type: " << allocsize << " times " << count << "\n"; 
 }
 llvm::outs() << "allocation size: " << allocsize*count << "\n"; 
 mo = allocate(allocsize*count, false, /*true*/false, inst, allocationAlignment, count, allocType);
 recordMemObj(state, mo);
 llvm::StructType *st = dyn_cast<llvm::StructType>(allocType);
 if (st) {
    std::string tname = getTypeName(allocType); 
    state.typeToAddr[allocType] = mo->getBaseExpr();
    llvm::outs() << "mapping lazy instance of " << tname << " to " << mo->getBaseExpr() << "\n";
 }   


 if (isSingle) {
    state.lazyInitSingleInstances[allocType] = mo;
    llvm::outs() << "storing address " << mo->getBaseExpr() << " as single instance of type " << rso.str() << "\n"; 
    addSingleOrDerivative(state, mo->getBaseExpr());
    llvm::errs() << "recording singleton or derivative " <<  mo->getBaseExpr() << "\n";
 }
 return mo;
}
/* SYSREL extension */

MemoryObject *MemoryManager::allocate(uint64_t size, bool isLocal,
                                      bool isGlobal,
                                      const llvm::Value *allocSite,
                                      size_t alignment) {
  if (size > 10 * 1024 * 1024)
    klee_warning_once(0, "Large alloc: %" PRIu64
                         " bytes.  KLEE may run out of memory.",
                      size);

  // Return NULL if size is zero, this is equal to error during allocation
  if (NullOnZeroMalloc && size == 0)
    return 0;

  if (!llvm::isPowerOf2_64(alignment)) {
    klee_warning("Only alignment of power of two is supported");
    return 0;
  }

  uint64_t address = 0;
  if (DeterministicAllocation) {
#if LLVM_VERSION_CODE >= LLVM_VERSION(3, 9)
    address = llvm::alignTo((uint64_t)nextFreeSlot + alignment - 1, alignment);
#else
    address = llvm::RoundUpToAlignment((uint64_t)nextFreeSlot + alignment - 1,
                                       alignment);
#endif

    // Handle the case of 0-sized allocations as 1-byte allocations.
    // This way, we make sure we have this allocation between its own red zones
    size_t alloc_size = std::max(size, (uint64_t)1);
    if ((char *)address + alloc_size < deterministicSpace + spaceSize) {
      nextFreeSlot = (char *)address + alloc_size + RedZoneSpace;
    } else {
      klee_warning_once(0, "Couldn't allocate %" PRIu64
                           " bytes. Not enough deterministic space left.",
                        size);
      address = 0;
    }
  } else {
    // Use malloc for the standard case
    if (alignment <= 8)
      address = (uint64_t)malloc(size);
    else {
      int res = posix_memalign((void **)&address, alignment, size);
      if (res < 0) {
        klee_warning("Allocating aligned memory failed.");
        address = 0;
      }
    }
  }

  if (!address)
    return 0;

  ++stats::allocations;
  llvm::LLVMContext &ctx = moduleHandle->getContext();	
  MemoryObject *res = new MemoryObject(address, size, isLocal, isGlobal, false,
                                       allocSite, this, size, llvm::Type::getInt8Ty(ctx));

  llvm::outs() << "Allocated object of size " << size << " at address " << address << "\n";
  llvm::outs() << "Basexpr=" << res->getBaseExpr() << "\n";

  objects.insert(res);
  /* SYSREL EXTENSION */
  if (staticAllocStatTracking)
     staticAlloc++; 
  llvm::errs() << "num static alloc = " << staticAlloc << "\n";
  /* SYSREL EXTENSION */
  return res;

}

MemoryObject *MemoryManager::allocate(uint64_t size, bool isLocal,
                                      bool isGlobal,
                                      const llvm::Value *allocSite,
                                      size_t alignment, unsigned count, 
                                      llvm::Type *t) {
  if (size > 10 * 1024 * 1024)
    klee_warning_once(0, "Large alloc: %" PRIu64
                         " bytes.  KLEE may run out of memory.",
                      size);

  // Return NULL if size is zero, this is equal to error during allocation
  if (NullOnZeroMalloc && size == 0)
    return 0;

  if (!llvm::isPowerOf2_64(alignment)) {
    klee_warning("Only alignment of power of two is supported");
    return 0;
  }

  uint64_t address = 0;
  if (DeterministicAllocation) {
#if LLVM_VERSION_CODE >= LLVM_VERSION(3, 9)
    address = llvm::alignTo((uint64_t)nextFreeSlot + alignment - 1, alignment);
#else
    address = llvm::RoundUpToAlignment((uint64_t)nextFreeSlot + alignment - 1,
                                       alignment);
#endif

    // Handle the case of 0-sized allocations as 1-byte allocations.
    // This way, we make sure we have this allocation between its own red zones
    size_t alloc_size = std::max(size, (uint64_t)1);
    if ((char *)address + alloc_size < deterministicSpace + spaceSize) {
      nextFreeSlot = (char *)address + alloc_size + RedZoneSpace;
    } else {
      klee_warning_once(0, "Couldn't allocate %" PRIu64
                           " bytes. Not enough deterministic space left.",
                        size);
      address = 0;
    }
  } else {
    // Use malloc for the standard case
    if (alignment <= 8)
      address = (uint64_t)malloc(size);
    else {
      int res = posix_memalign((void **)&address, alignment, size);
      if (res < 0) {
        klee_warning("Allocating aligned memory failed.");
        address = 0;
      }
    }
  }

  if (!address)
    return 0;

  ++stats::allocations;
  MemoryObject *res = new MemoryObject(address, size, isLocal, isGlobal, false,
                                       allocSite, this, count, t);

  llvm::outs() << "Allocated object of size " << size << " at address " << address << "\n";
  llvm::outs() << "Basexpr=" << res->getBaseExpr() << "\n";

  objects.insert(res);
  /* SYSREL EXTENSION */
  if (staticAllocStatTracking)
     staticAlloc++; 
  llvm::errs() << "num static alloc = " << staticAlloc << "\n";
  /* SYSREL EXTENSION */
  return res;
}

MemoryObject *MemoryManager::allocateFixed(uint64_t address, uint64_t size,
                                           const llvm::Value *allocSite) {
#ifndef NDEBUG
  for (objects_ty::iterator it = objects.begin(), ie = objects.end(); it != ie;
       ++it) {
    MemoryObject *mo = *it;
    if (address + size > mo->address && address < mo->address + mo->size)
      klee_error("Trying to allocate an overlapping object");
  }
#endif

  ++stats::allocations;
  llvm::LLVMContext &ctx = moduleHandle->getContext();
  MemoryObject *res =
      new MemoryObject(address, size, false, true, true, allocSite, this, 
                       size, llvm::Type::getInt8Ty(ctx));
  objects.insert(res);
  return res;
}

void MemoryManager::deallocate(const MemoryObject *mo) { assert(0); }

void MemoryManager::markFreed(MemoryObject *mo) {
  if (objects.find(mo) != objects.end()) {
    if (!mo->isFixed && !DeterministicAllocation)
      free((void *)mo->address);
    objects.erase(mo);
  }
}

size_t MemoryManager::getUsedDeterministicSize() {
  return nextFreeSlot - deterministicSpace;
}
