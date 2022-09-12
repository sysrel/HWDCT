
#ifndef _PROSE_H
#define _PROSE_H

#include "klee/Expr.h"
#include "../Core/Memory.h"
#include "../Core/MemoryManager.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/Function.h"

#include <string>
#include <vector>
#include <map>

using namespace klee;
using namespace llvm;

enum LeafType {CONST, IDENT};

enum Op {LT, LTE, GT, GTE, EQ, NEQ, NEG, PLUS, MINUS, TIMES, DIV, AND, OR, NOOP};

void printOp(Op);

class ASTNode {
 public: 
  std::vector<ASTNode*> children;
  Op oper;
  ASTNode();
  ASTNode(Op);
  int getNumChild();
  void addChild(ASTNode *);
  ASTNode *getChild(int);
  virtual void print();
};

typedef struct ASTNode ASTNode;

class ConstantNode : public ASTNode {
 public: 
  int value;
  ConstantNode(int v);
  int getValue();
  virtual void print();
};

class IdentifierNode : public ASTNode {
 public:
   std::string value;
   IdentifierNode(std::string s);
   std::string getValue();
  virtual void print();
};


struct Binding {
  std::string type;  
  std::string comptype; // "sizeof", "argsize", "return", or "none"
  std::string entity;
  unsigned index;
};

typedef struct Binding Binding;

struct BoundAST {
  ASTNode *ast;
  std::map<std::string, Binding> bindings; 
};

typedef struct BoundAST BoundAST;

void parse(std::string &str, BoundAST &bast, std::string &ent, std::string &type);

ref<Expr> generateExp(BoundAST &bast, Function *f, std::map<unsigned, 
            std::pair<MemoryObject*,ObjectState*> > &argObjs, 
            std::map<unsigned, unsigned> &argSizes, ref<Expr> retVal); 

ref<Expr> generateExp(BoundAST &bast, const MemoryObject *mo, const ObjectState *obj, 
           unsigned baseOffset, const StructType *st, const StructLayout *sl, unsigned count=1, 
           unsigned offset=0, unsigned size=0);


bool isSimpleEquality(BoundAST &bast);

bool isSizeOfConstant(BoundAST &bast, Binding &bout, unsigned &size);

bool isArgSizeConstant(BoundAST &bast, Binding &bout, unsigned &size);


bool applyEquality(BoundAST &bast, const MemoryObject *mo, ObjectState *obj, 
           unsigned baseOffset, const StructType *st, const StructLayout *sl, unsigned count=1, 
           unsigned offset=0, unsigned size=0);


bool applyEquality(BoundAST &bast, Function *f, std::map<unsigned, 
            std::pair<MemoryObject*,ObjectState*> > &argObjs, 
            std::map<unsigned, unsigned> &argSizes,
            ref<Expr> &value, int &index); 


#endif
