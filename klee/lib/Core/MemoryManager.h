//===-- MemoryManager.h -----------------------------------------*- C++ -*-===//
//
//                     The KLEE Symbolic Virtual Machine
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#ifndef KLEE_MEMORYMANAGER_H
#define KLEE_MEMORYMANAGER_H

#include <set>
#include <stdint.h>
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Type.h"

namespace llvm {
class Value;
}

namespace klee {
class MemoryObject;
class ArrayCache;

class MemoryManager {
private:
  typedef std::set<MemoryObject *> objects_ty;
  typedef std::map<llvm::Type *, MemoryObject *> objects_mty;
  objects_ty objects;
  /* SYSREL extension */
  //std::map<llvm::Type *, MemoryObject *> lazyInitSingleInstances;
  /* SYSREL extension */
  ArrayCache *const arrayCache;

  char *deterministicSpace;
  char *nextFreeSlot;
  size_t spaceSize;

public:
  MemoryManager(ArrayCache *arrayCache);
  ~MemoryManager();

  /**
   * Returns memory object which contains a handle to real virtual process
   * memory.
   */
  // keeping for old code
  MemoryObject *allocate(uint64_t size, bool isLocal, bool isGlobal,
                         const llvm::Value *allocSite, size_t alignment); 
  MemoryObject *allocate(uint64_t size, bool isLocal, bool isGlobal,
                         const llvm::Value *allocSite, size_t alignment, 
                         unsigned count, llvm::Type *type);
  MemoryObject *allocateFixed(uint64_t address, uint64_t size,
                              const llvm::Value *allocSite);

  /* SYSREL extension */
  MemoryObject *simulateMalloc(ExecutionState &state, ref<Expr> size);
  MemoryObject *allocateForLazyInit(ExecutionState &state, llvm::Instruction *inst, llvm::Type *t, 
         bool isSingle, int count);
  const MemoryObject *allocateLazyForTypeOrEmbedding(ExecutionState &state, llvm::Instruction *inst, 
         llvm::Type *origType, llvm::Type *allocType, bool isSingle, int count, 
         llvm::Type *&rallocType, ref<Expr> &resaddr, bool &sym, bool &abort, 
         llvm::Type *infenc=NULL, const char *hint ="") ;
  const MemoryObject *allocateLazyForTypeOrEmbeddingSimple(ExecutionState &state, llvm::Instruction *inst, 
         llvm::Type *origType, llvm::Type *allocType, bool isSingle, int count, llvm::Type *&rallocType, ref<Expr> &resaddr, bool &sym, bool &abort) ;
  MemoryObject *getInstanceForType(ExecutionState &state, llvm::Type *t);
  ref<Expr> getInstanceAddressForType(ExecutionState &state, llvm::Type *t, bool &result);
  /* SYSREL extension */

  void deallocate(const MemoryObject *mo);
  void markFreed(MemoryObject *mo);
  ArrayCache *getArrayCache() const { return arrayCache; }

  /*
   * Returns the size used by deterministic allocation in bytes
   */
  size_t getUsedDeterministicSize();
};

} // End klee namespace

#endif
