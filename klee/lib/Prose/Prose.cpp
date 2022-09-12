#include <cstdlib>
#include "Prose.h"
#include "llvm/Support/raw_ostream.h"

#define SEP '#'

enum pstate { WSP, LPR, RPR, COMMA, LETTER, DIGIT, NONE};

Op checkOp(std::string t);
pstate checkpstate(char c) ;

unsigned getWidth(BoundAST &bast,ASTNode *n,const StructType *st) ;

void printOp(Op op) {
 if (op == LT)
    llvm::errs() << " LT\n"; 
 else if (op == LTE)
    llvm::errs() << " LTE\n";  
 else if (op == GT)
    llvm::errs() << " GT\n";  
 else if (op == GTE)
    llvm::errs() << " GTE\n";
 else if (op == EQ)
    llvm::errs() << " EQ\n";
 else if (op == NEQ)
    llvm::errs() << " NEQ\n";
 else if (op == NEG)
    llvm::errs() << " NEG\n";  
 else if (op == PLUS)
    llvm::errs() << " PLUS\n";  
 else if (op == MINUS)
    llvm::errs() << " MINUS\n";  
 else if (op == TIMES)
    llvm::errs() << " TIMES\n";  
 else if (op == DIV)
    llvm::errs() << " DIV\n";
 else if (op == AND)
    llvm::errs() << " AND\n";
 else if (op == OR)
    llvm::errs() << " OR\n"; 
 else if (op == NOOP)
    llvm::errs() << " NOOP\n";  
}

ASTNode::ASTNode() { oper = NOOP; }

ASTNode::ASTNode(Op op) { oper = op; }

int ASTNode::getNumChild() {return children.size(); }
 
void ASTNode::addChild(ASTNode *n) { children.push_back(n); }

ASTNode *ASTNode::getChild(int i) { 
  if (i >= children.size()) 
     assert(0 && "invalid child\n");
  return children[i];
}

void ASTNode::print() {
  llvm::errs() << "Op=";
  printOp(oper);
  llvm::errs() << "Operands:\n";
  for(unsigned i=0; i<children.size(); i++) {
     children[i]->print();
  }
     
}

ConstantNode::ConstantNode(int v) {
  oper = NOOP;
  value = v;
}

int ConstantNode::getValue() {
  return value;
}

void ConstantNode::print() {
  llvm::errs() << value << "\n";
}

IdentifierNode::IdentifierNode(std::string s) {
  oper = NOOP;
  value = s;
}

std::string IdentifierNode::getValue() {
  return value;
}

void IdentifierNode::print() {
  llvm::errs() << value << "\n";
}


// buffer has tokens in the form token_1 SEP token_2 SEP ... token_n SEP

Op getOp(std::vector<char> &b) {
   if (b.size() == 0)
      return NOOP; 
   assert(b.size() >= 2); 
   int last = b.size()-2;
   std::string s = std::string(1,b[last]);
   if (b.size() > 2 && b[last-1] != SEP)
      s = b[last-1] + s;
   Op res = checkOp(s);
   if (res != NOOP) {
      b.pop_back();
      b.pop_back();
      if (s.size() > 1)
         b.pop_back();
   }
   return res;
}

Op checkOp(std::string t) {
   if (t == "<")
      return LT;
   if (t == "<=")
      return LTE;
   if (t == ">")
      return GT;
   if (t == ">=")
      return GTE;
   if (t == "=")
      return EQ;
   if (t == "!=")
      return NEQ;
   if (t == "!")
      return NEG;
   if (t == "+")
      return PLUS;
   if (t == "-")
      return MINUS;
   if (t == "*")
      return TIMES;
   if (t == "/")
      return DIV;
   if (t == "&&")
      return AND;
   if (t == "||")
      return OR;
   return NOOP;
}

pstate getpstate(std::vector<char> &b) {
   if (b.size() == 0)
      return NONE;  
   assert(b.size() >= 2);
   char c = b[b.size()-2];
   pstate ps = checkpstate(c);  
   if (ps != NONE) {
      b.pop_back();
      b.pop_back();
   }
   return ps; 
}

pstate checkpstate(char c) {
  switch (c) {
    case ' ':
    case '\t':
    case '\n':
    case '\r':
    case '\f':
    case '\v':
       return WSP;
    default:
      if (c == ',')
         return COMMA;
      if (c == '(')
         return LPR;
      if (c == ')')
         return RPR;
      if (isalpha(c) || c == '_')
         return LETTER;
      if (isdigit(c))
         return DIGIT;
  }
  return NONE;
}

bool isToken(std::string s) {
  if (s == "where" || s == "is" || s == "field" || s == "arg" || 
         s == "size_of" || s == "return_of")
     return true;
  return false;
}

void recordState(pstate ps, std::vector<char> &b) {
   switch (ps) {
     case LPR:
        b.push_back('('); b.push_back(SEP); break;
     case RPR:
        b.push_back(')'); b.push_back(SEP); break;
     default: break;
   }
}

Op recordOp(Op op, std::vector<char> &b) {
  switch (op) {   
    case LT:
      b.push_back('<'); b.push_back(SEP); break;
    case LTE:
      b.push_back('<'); b.push_back('='); b.push_back(SEP); break;
    case GT:
      b.push_back('>'); b.push_back(SEP); break;
    case GTE:
      b.push_back('>'); b.push_back('='); b.push_back(SEP); break;
    case EQ:
         b.push_back('='); b.push_back(SEP); break;
    case NEQ:
      b.push_back('!'); b.push_back('='); b.push_back(SEP); break;
    case NEG: 
      b.push_back('!'); b.push_back(SEP); break;
    case PLUS:
      b.push_back('+'); b.push_back(SEP); break;
    case MINUS: 
      b.push_back('-'); b.push_back(SEP); break;
    case TIMES:
      b.push_back('*'); b.push_back(SEP); break;
    case DIV:
      b.push_back('/'); b.push_back(SEP); break;
    case AND:
      b.push_back('&'); b.push_back('&'); b.push_back(SEP); break;
    case OR: 
      b.push_back('|'); b.push_back('|'); b.push_back(SEP); break;
    default: break;
  }
  return op;
}

void reduceOp(Op op, std::vector<char> &buffer, std::vector<ASTNode*> &expstack) {
   bool binary = true;
   if (op == NEG || op == MINUS)
      binary = false;
   if (binary && expstack.size() < 2) {
      llvm::errs() << "Operator : " << op << "\n";
      assert(0 && "Two operands needed for the binary operator\n");
   } 
   if (!binary && expstack.size() < 1) {
      llvm::errs() << "Operator : " << op << "\n";
      assert(0 && "Operand of a unary operator missing\n"); 
   }
   ASTNode *n = new ASTNode(op);
   int last = expstack.size();
   if (binary) {
      n->addChild(expstack[last-2]);
      n->addChild(expstack[last-1]);
      expstack.pop_back();
      expstack.pop_back();
   }
   else  {
     n->addChild(expstack[last-1]);
     expstack.pop_back();
   }
   expstack.push_back(n);
}

void reduce(std::vector<char> &buffer, std::vector<ASTNode*> &expstack, BoundAST &bast) {
  if (buffer.size() == 0 && expstack.size() == 0)
     return;
  std::vector<char> parbuffer;
  Op op = NOOP;
  pstate ps = NONE;
  llvm::errs() << "buffer:\n";
  for(int j=0; j<buffer.size(); j++)
     llvm::errs() << buffer[j];
  llvm::errs() << "\n";
  llvm::errs() << "expressions:\n";
  for(int j=0; j<expstack.size(); j++)
     expstack[j]->print();
  while (buffer.size() > 0) {
     op = getOp(buffer);
     ps = getpstate(buffer);
     assert((op != NOOP || ps != NONE) &&  "Unrecognized grammar!");
     if (ps == RPR) {
        parbuffer.push_back(')');
     } 
     else if (ps == LPR) {
        if (parbuffer.size() == 0)
           assert(0 && "Paranthesis mismatch\n");
        parbuffer.pop_back(); 
     }
     if (op != NOOP)  
        reduceOp(op,buffer,expstack);
  } 
  if (expstack.size() != 1)
     assert(0 && "Expression could not be parsed!\n");
  bast.ast = expstack[0];
  llvm::errs() << "generated AST:\n";
  bast.ast->print();
  expstack.pop_back(); 
}

/* Recognizes numeric expressions possibly enclosed 
 * within paranthesis followed by a binding clause 
 * <boundexpression> ::= <expression> 'where' <bindings>
 * <binding> ::= <ident> 'is' <entity>
 * <entity>  ::= <ident> 'field' <unsigned> |
 *               <ident> 'arg' <unsigned>
 *               'return_of' <ident> 
 *               'size_of' <ident> 'field' <unsigned>      
 *               'arg_size' <ident> 'arg' <unsigned>
*/
// For internal use only and for testing simple constraints; 
// the real parser has been implemented with bison & flex
void parse(std::string &str, BoundAST &bast, std::string &e, std::string &t) {
 std::vector<char> buffer;  
 std::vector<ASTNode*> expstack; 

 std::string token = "";
 std::string symbol = ""; 
 std::string entity = "";
 unsigned no = -1;
 
 Op op = NOOP;
 unsigned i=0;
 bool tokenReady = false;
 bool binding = false;
 pstate current, prev;
 current = prev =  NONE;
 std::string bstate = "";
 bool sizeoftok = false;
 bool returnoftok = false;
 bool argsizetok = false;
 char prevC = ' ';
 while (i<str.size()) {
   llvm::errs() << "processing " << str[i] << "\n";
   tokenReady = false;
   prev = current;
   current = checkpstate(str[i]);
   recordState(current, buffer);
   Op temp = checkOp(token);
  
   // lookahead
   if ((temp == NEG || temp == LT || temp == GT) && str[i] == '=') {
      token = token + str[i];
      i++;
      continue;
   }

   temp = recordOp(temp, buffer);

   if (current == COMMA || current == LPR || current == RPR || 
       current == WSP || temp != NOOP)
       tokenReady = true;
   else
       token = token + str[i];
     
   if (i == str.size() - 1)
      tokenReady = true;

   if (tokenReady) {
      if (token != "") {
         llvm::errs() << "token " << token << "\n";
         //if (temp == NOOP) {
         ASTNode *an = NULL;
         char* p;
         const char *c = token.c_str();
         int num = strtol(c, &p, 10);
         if (!*p) {
             if (binding) { 
                if (bstate == "field" || bstate == "arg") {
                   assert(entity != "" && "Missing type or function name\n");
                   no = num;
                   Binding b;
                   b.entity = entity;
                   b.index = no;
                   if (bstate == "field") {
                      b.type = "type";
                      t = "type";
                      if (sizeoftok)
                         b.comptype = "sizeof";
                      else 
                         b.comptype = "none";
                      llvm::errs() << "creating symbol " << symbol << " to type " << entity << " mapping\n"; 
                   }
                   else { 
                      b.type = "func";
                      t = "func";
                      if (returnoftok)
                         b.comptype = "return";
                      else if (argsizetok)
                         b.comptype = "argsize";
                      else
                         b.comptype = "none";
                      llvm::errs() << "creating symbol " << symbol << " to function " << entity << " mapping\n"; 
                   }
                   if (bast.bindings.find(symbol) != bast.bindings.end())
                      assert(0 && "multiple binding clauses for the same symbol!");
                   if (e != "" && e != entity) {
                      if (bstate == "field")
                         assert(0 && "multiple types are not allowed in a bound constraint!\n");
                      if (bstate == "arg")
                        assert(0 && "multiple functions are not allowed in a bound constraint!\n"); 
                   }   
                   e = entity;
                   bast.bindings[symbol] = b;
                   bstate = "";
                   symbol = "";
                   entity = "";
                   returnoftok = false;
                   sizeoftok = false; 
                   argsizetok = false;
                   no = -1;
                }
                else assert(0 && "Unexpected number in the binding clause!\n");
             }
             else {
                an = new ConstantNode(num);
                llvm::errs() << "creating constant " << num << "\n"; 
             }
         }
         else { // not a number
             if (token != "" && !isToken(token)) { 
                if (binding) {
                   if (bstate == "") 
                      symbol = token;
                   else if (bstate == "is" || bstate == "return_of" || bstate == "size_of"
                            || bstate == "arg_size")
                      entity = token;
                   else assert(0 && "Unexpeccted string in the binding clause!\n");
                }
                else if (checkOp(token) == NOOP) { 
                   an = new IdentifierNode(token);
                   llvm::errs() << "creating identifier " << token << "\n";
                }
             }
         }
         if (an != NULL)
            expstack.push_back(an); 
         else {
            if (token == "where") {
               binding = true;
               llvm::errs() << "moves to binding..\n";
            }
            else if (binding) {
               if (token == "is" || token == "field" || token == "arg" || 
                      token == "return_of" || token == "size_of" || token == "arg_size")  {
                  if (token == "field" || token == "arg") {
                     llvm::errs() << "type or function name: " << entity << "\n";
                     assert(entity != "" && "Missing type or function name in a binding clause\n");
                  } 
                  bstate = token;
                  if (token == "return_of") 
                     returnoftok = true;
                  if (token == "size_of")
                     sizeoftok = true;
                  if (token == "arg_size")
                     argsizetok = true;
                  llvm::errs() << "moves to binding state " << bstate << "\n";
               }
            }
         }
         token = "";
     }
     tokenReady = false;
   }
   prevC = str[i];
   i++;  
 } 
 reduce(buffer,expstack,bast);
}


bool applyEquality(BoundAST &bast, const MemoryObject *mo, ObjectState *obj, 
           unsigned baseOffset, const StructType *st, const StructLayout *sl, 
           unsigned count, unsigned offset, unsigned size) {

   bool holds = isSimpleEquality(bast);
   if (!holds) return false;
   ASTNode *n1 = bast.ast->getChild(0);
   ASTNode *n2 = bast.ast->getChild(1);
   ref<Expr> value = NULL;
   unsigned width = getWidth(bast,bast.ast,st);
   if (dynamic_cast<ConstantNode*>(n1)) {
      value = ConstantExpr::alloc(((ConstantNode*)n1)->value, width);
   }
   if (dynamic_cast<ConstantNode*>(n2)) {
      value = ConstantExpr::alloc(((ConstantNode*)n2)->value, width);
   }
   if (dynamic_cast<IdentifierNode*>(n1)) {
      IdentifierNode *in1 = (IdentifierNode*)n1;
      Binding b1 = bast.bindings[in1->value];
      unsigned o = sl->getElementOffset(b1.index);
      if (b1.comptype == "sizeof") {
         if (o == offset) {
            value = ConstantExpr::alloc(count, width);
         }
      }
   }
   if (dynamic_cast<IdentifierNode*>(n2)) {
      IdentifierNode *in2 = (IdentifierNode*)n2;
      Binding b2 = bast.bindings[in2->value];
      unsigned o = sl->getElementOffset(b2.index);
      if (b2.comptype == "sizeof") {
         if (o == offset) {
            value = ConstantExpr::alloc(count, width);
         }
      }
   }
   assert(!value.isNull());

   
   bool wrote = false;
   if (dynamic_cast<IdentifierNode*>(n1)) {
      IdentifierNode *in1 = (IdentifierNode*)n1;
      Binding b1 = bast.bindings[in1->value];
      unsigned o = sl->getElementOffset(b1.index);
      if (b1.comptype == "none") {
         obj->write(baseOffset + o, value);
         wrote = true;
         llvm::errs() << "Wrote " << value << " of width " << width << " to offset " 
                      << baseOffset + o << " in " << mo->getBaseExpr() << "\n";
      }
   }
   if (dynamic_cast<IdentifierNode*>(n2)) {
      IdentifierNode *in2 = (IdentifierNode*)n2;
      Binding b2 = bast.bindings[in2->value];
      unsigned o = sl->getElementOffset(b2.index);
      if (b2.comptype == "none") {
         obj->write(baseOffset + o, value);
         wrote = true;
         llvm::errs() << "Wrote " << value << " of width " << width << " to offset " 
                      << baseOffset + o << " in " << mo->getBaseExpr() << "\n";
      }
   }   
   assert(wrote && "Error applying equality!");   
   return true;
}


ref<Expr> generateExp(BoundAST &bast, ASTNode *n, const MemoryObject *mo, const ObjectState *obj, 
    unsigned baseOffset, const StructType *st, const StructLayout *sl, unsigned c, unsigned offset, 
   unsigned size, unsigned width) {
   ref<Expr> res;
   if (n->oper == LT) {
      unsigned w = getWidth(bast,n,st);
      ref<Expr> c1 = generateExp(bast,n->getChild(0),mo,obj,baseOffset,st,sl,c,offset,size,w);
      ref<Expr> c2 = generateExp(bast,n->getChild(1),mo,obj,baseOffset,st,sl,c,offset,size,w);
      if (!c1.isNull() && !c2.isNull())
         res = SltExpr::create(c1,c2);  
      return res;
   }
   else if (n->oper == LTE) {
      unsigned w = getWidth(bast,n,st);
      ref<Expr> c1 = generateExp(bast,n->getChild(0),mo,obj,baseOffset,st,sl,c,offset,size,w);
      ref<Expr> c2 = generateExp(bast,n->getChild(1),mo,obj,baseOffset,st,sl,c,offset,size,w);
      if (!c1.isNull() && !c2.isNull())
         res = SleExpr::create(c1,c2);  
      return res;
   }
   else if (n->oper == GT) {
      unsigned w = getWidth(bast,n,st);
      ref<Expr> c1 = generateExp(bast,n->getChild(0),mo,obj,baseOffset,st,sl,c,offset,size,w);
      ref<Expr> c2 = generateExp(bast,n->getChild(1),mo,obj,baseOffset,st,sl,c,offset,size,w);
      if (!c1.isNull() && !c2.isNull())
         res = SgtExpr::create(c1,c2);  
      return res;
   } 
   else if (n->oper == GTE) {
      unsigned w = getWidth(bast,n,st);
      ref<Expr> c1 = generateExp(bast,n->getChild(0),mo,obj,baseOffset,st,sl,c,offset,size,w);
      ref<Expr> c2 = generateExp(bast,n->getChild(1),mo,obj,baseOffset,st,sl,c,offset,size,w);
      if (!c1.isNull() && !c2.isNull())
         res = SgeExpr::create(c1,c2);  
      return res;
   } 
   else if (n->oper == EQ) {
      unsigned w = getWidth(bast,n,st);
      ref<Expr> c1 = generateExp(bast,n->getChild(0),mo,obj,baseOffset,st,sl,c,offset,size,w);
      ref<Expr> c2 = generateExp(bast,n->getChild(1),mo,obj,baseOffset,st,sl,c,offset,size,w);
      if (!c1.isNull() && !c2.isNull())
         res = EqExpr::create(c1,c2);  
      return res;
   } 
   else if (n->oper == NEQ) {
      unsigned w = getWidth(bast,n,st);
      ref<Expr> c1 = generateExp(bast,n->getChild(0),mo,obj,baseOffset,st,sl,c,offset,size,w);
      ref<Expr> c2 = generateExp(bast,n->getChild(1),mo,obj,baseOffset,st,sl,c,offset,size,w);
      if (!c1.isNull() && !c2.isNull())
         res = NeExpr::create(c1,c2);  
      return res;
   }
   else if (n->oper == NEG) { 
      ref<Expr> c1 = generateExp(bast,n->getChild(0),mo,obj,baseOffset,st,sl,c,offset,size,width);
      if (!c1.isNull())
         res = NotExpr::create(c1);  
      return res;
   }
   else if (n->oper == PLUS) {
      unsigned w = getWidth(bast,n,st);
      ref<Expr> c1 = generateExp(bast,n->getChild(0),mo,obj,baseOffset,st,sl,c,offset,size,w);
      ref<Expr> c2 = generateExp(bast,n->getChild(1),mo,obj,baseOffset,st,sl,c,offset,size,w);
      if (!c1.isNull() && !c2.isNull())
         res = AddExpr::create(c1,c2);  
      return res;
   } 
   else if (n->oper == MINUS) {
      ref<Expr> c1 = generateExp(bast,n->getChild(0),mo,obj,baseOffset,st,sl,c,offset,size,width);
      ref<Expr> c2 = ConstantExpr::alloc(-1,width);
      if (!c1.isNull())
         res = MulExpr::create(c1,c2);  
      return res;
   }
   else if (n->oper == TIMES) {
      unsigned w = getWidth(bast,n,st);
      ref<Expr> c1 = generateExp(bast,n->getChild(0),mo,obj,baseOffset,st,sl,c,offset,size,w);
      ref<Expr> c2 = generateExp(bast,n->getChild(1),mo,obj,baseOffset,st,sl,c,offset,size,w);
      if (!c1.isNull() && !c2.isNull())
         res = MulExpr::create(c1,c2);  
      return res;
   }
   else if (n->oper == DIV) {
      unsigned w = getWidth(bast,n,st);
      ref<Expr> c1 = generateExp(bast,n->getChild(0),mo,obj,baseOffset,st,sl,c,offset,size,w);
      ref<Expr> c2 = generateExp(bast,n->getChild(1),mo,obj,baseOffset,st,sl,c,offset,size,w);
      if (!c1.isNull() && !c2.isNull())
         res = SDivExpr::create(c1,c2);  
      return res;
   }
   else if (n->oper == AND) {
      ref<Expr> c1 = generateExp(bast,n->getChild(0),mo,obj,baseOffset,st,sl,c,offset,size,width);
      ref<Expr> c2 = generateExp(bast,n->getChild(1),mo,obj,baseOffset,st,sl,c,offset,size,width);
      if (!c1.isNull() && !c2.isNull())
         res = AndExpr::create(c1,c2);  
      return res;
   }
   else if (n->oper == OR) {
      ref<Expr> c1 = generateExp(bast,n->getChild(0),mo,obj,baseOffset,st,sl,c,offset,size,width);
      ref<Expr> c2 = generateExp(bast,n->getChild(1),mo,obj,baseOffset,st,sl,c,offset,size,width);
      if (!c1.isNull() && !c2.isNull())
         res = OrExpr::create(c1,c2);  
      return res;
   }
   else if (n->oper == NOOP) {
      if (dynamic_cast<ConstantNode*>(n)) {
         res = ConstantExpr::alloc(((ConstantNode*)n)->value, width);
         return res;          
      }
      else if (dynamic_cast<IdentifierNode*>(n)) {
         IdentifierNode *in = (IdentifierNode*)n;
         Binding b = bast.bindings[in->value];
         unsigned o = sl->getElementOffset(b.index);
         llvm::errs() << "compund type " << b.comptype << " given offset " << offset 
                      << " computed offset " << o << "\n";
         if (b.comptype == "sizeof") {
            if (o == offset) {
               res = ConstantExpr::alloc(c, width);
               return res;
            }
            else return NULL;
         }
         else if (b.comptype == "none") {
            Type *et = st->getStructElementType(b.index);       
            unsigned width = et->getPrimitiveSizeInBits(); 
            res = obj->read(baseOffset + o, width);
            return res;
         }
      }
   }
}

unsigned getWidth(BoundAST &bast,ASTNode *n,const StructType *st) {
  if (dynamic_cast<IdentifierNode*>(n)) {
     IdentifierNode *in = (IdentifierNode*)n;
     Binding b = bast.bindings[in->value];
     Type *et = st->getStructElementType(b.index);
     return et->getPrimitiveSizeInBits();
  }
  unsigned maxw = 0;
  for(unsigned i=0; i<n->children.size(); i++) {
     unsigned w = getWidth(bast,n->children[i],st);
     if (w > maxw)
        maxw = w;
  }
  return maxw; 
}


// Generates a KLEE Expr object based on the AST and the binding info in bast
// (mo,obj) corresponds to the lazy init memory object to which the expr will 
// be applied
// sl provides structure layout to compute the relevant offsets
ref<Expr> generateExp(BoundAST &bast, const MemoryObject *mo, const ObjectState *obj, 
          unsigned baseOffset, const StructType *st, const StructLayout *sl, unsigned count, 
          unsigned offset, unsigned size) {
    unsigned width = 0;
    return generateExp(bast, bast.ast, mo, obj, baseOffset, st, sl, count, offset, size, width); 
}


unsigned getWidth(BoundAST &bast,ASTNode *n, Function *f, ref<Expr> retVal) {
  if (!retVal.isNull()) return retVal->getWidth();
  if (dynamic_cast<IdentifierNode*>(n)) {
     IdentifierNode *in = (IdentifierNode*)n;
     Binding b = bast.bindings[in->value];
     Type *t = NULL;
     unsigned i=0;
     for(llvm::Function::arg_iterator ai = f->arg_begin(); ai != f->arg_end(); ai++, i++) {
        if (i == b.index) {
           t = ai->getType();
           break;
        }
     }
     return t->getPrimitiveSizeInBits();
  }
  unsigned maxw = 0;
  for(unsigned i=0; i<n->children.size(); i++) {
     unsigned w = getWidth(bast,n->children[i],f,retVal);
     if (w > maxw)
        maxw = w;
  }
  return maxw; 
}

bool applyEquality(BoundAST &bast, Function *f, std::map<unsigned, 
            std::pair<MemoryObject*,ObjectState*> > &argObjs, 
            std::map<unsigned, unsigned> &argSizes,
            ref<Expr> &value, int &index) {

   bool holds = isSimpleEquality(bast);
   if (!holds) return false;
   ASTNode *n1 = bast.ast->getChild(0);
   ASTNode *n2 = bast.ast->getChild(1);
   value = NULL;

   unsigned width = getWidth(bast,bast.ast,f,NULL);   
   if (dynamic_cast<ConstantNode*>(n1)) {
      value = ConstantExpr::alloc(((ConstantNode*)n1)->value, width);
   }
   if (dynamic_cast<ConstantNode*>(n2)) {
      value = ConstantExpr::alloc(((ConstantNode*)n2)->value, width);
   }
   if (dynamic_cast<IdentifierNode*>(n1)) {
      IdentifierNode *in = (IdentifierNode*)n1;
      Binding b = bast.bindings[in->value];
      if (b.comptype == "argsize") {
         if (argSizes.find(b.index) != argSizes.end()) {
            value =  ConstantExpr::alloc(argSizes[b.index], width);       
         }        
      }
   }
   if (dynamic_cast<IdentifierNode*>(n2)) {
      IdentifierNode *in = (IdentifierNode*)n2;
      Binding b = bast.bindings[in->value];
      if (b.comptype == "argsize") {
         if (argSizes.find(b.index) != argSizes.end()) {
            value =  ConstantExpr::alloc(argSizes[b.index], width);       
         }        
      }
   }

   assert(!value.isNull());


   bool wrote = false;
   if (dynamic_cast<IdentifierNode*>(n1)) {
      IdentifierNode *in = (IdentifierNode*)n1;
      Binding b = bast.bindings[in->value];
      if (b.comptype == "return") { // todo
            assert(0 && "todo item: return");
      }
      else if (b.comptype == "none") { 
         if (argObjs.find(b.index) != argObjs.end()) {
            std::pair<MemoryObject*,ObjectState*> p = argObjs[b.index];
            p.second->write(0, value);
            index = b.index;
            wrote = true;
            llvm::errs() << "Wrote " << value << " to offset 0 in " 
                         << p.first->getBaseExpr() << "\n";
         }
     }
   }
   if (dynamic_cast<IdentifierNode*>(n2)) {
      IdentifierNode *in = (IdentifierNode*)n2;
      Binding b = bast.bindings[in->value];
      if (b.comptype == "return") { // todo
            assert(0 && "todo item: return");
      }
      else if (b.comptype == "none") {
         if (argObjs.find(b.index) != argObjs.end()) {
            std::pair<MemoryObject*,ObjectState*> p = argObjs[b.index];
            p.second->write(0, value);
            index = b.index;
            wrote = true;
            llvm::errs() << "Wrote " << value << " to 0 in " 
                         << p.first->getBaseExpr() << "\n";
         }
     }
   }

   assert(wrote); 
   return true;
}

ref<Expr> generateExp(BoundAST &bast, ASTNode *n, Function *f, std::map<unsigned, 
            std::pair<MemoryObject*,ObjectState*> > &argObjs, 
            std::map<unsigned, unsigned> &argSizes, unsigned width, ref<Expr> retVal) {
   ref<Expr> res;
   if (n->oper == LT) {
      unsigned w = getWidth(bast,n,f,retVal);
      ref<Expr> c1 = generateExp(bast,n->getChild(0),f,argObjs,argSizes,w,retVal);
      ref<Expr> c2 = generateExp(bast,n->getChild(1),f,argObjs,argSizes,w,retVal);
      if (!c1.isNull() && !c2.isNull())
         res = SltExpr::create(c1,c2);  
      return res;
   }
   if (n->oper == LTE) {
      unsigned w = getWidth(bast,n,f,retVal);
      ref<Expr> c1 = generateExp(bast,n->getChild(0),f,argObjs,argSizes,w,retVal);
      ref<Expr> c2 = generateExp(bast,n->getChild(1),f,argObjs,argSizes,w,retVal);
      if (!c1.isNull() && !c2.isNull())
         res = SleExpr::create(c1,c2);  
      return res;
   }
   if (n->oper == GT) {
      unsigned w = getWidth(bast,n,f,retVal);
      ref<Expr> c1 = generateExp(bast,n->getChild(0),f,argObjs,argSizes,w,retVal);
      ref<Expr> c2 = generateExp(bast,n->getChild(1),f,argObjs,argSizes,w,retVal);
      if (!c1.isNull() && !c2.isNull())
         res = SgtExpr::create(c1,c2);  
      return res;
   }
   if (n->oper == GTE) {
      unsigned w = getWidth(bast,n,f,retVal);
      ref<Expr> c1 = generateExp(bast,n->getChild(0),f,argObjs,argSizes,w,retVal);
      ref<Expr> c2 = generateExp(bast,n->getChild(1),f,argObjs,argSizes,w,retVal);
      if (!c1.isNull() && !c2.isNull())
         res = SgeExpr::create(c1,c2);  
      return res;      
   } 
   if (n->oper == EQ) {
      unsigned w = getWidth(bast,n,f,retVal);
      ref<Expr> c1 = generateExp(bast,n->getChild(0),f,argObjs,argSizes,w,retVal);
      ref<Expr> c2 = generateExp(bast,n->getChild(1),f,argObjs,argSizes,w,retVal);
      if (!c1.isNull() && !c2.isNull())
         res = EqExpr::create(c1,c2);  
      return res;      
   }
   if (n->oper == NEQ) {      
      unsigned w = getWidth(bast,n,f,retVal);
      ref<Expr> c1 = generateExp(bast,n->getChild(0),f,argObjs,argSizes,w,retVal);
      ref<Expr> c2 = generateExp(bast,n->getChild(1),f,argObjs,argSizes,w,retVal);
      if (!c1.isNull() && !c2.isNull())
         res = NeExpr::create(c1,c2);  
      return res;   
   } 
   if (n->oper == NEG) {
      unsigned w = getWidth(bast,n,f,retVal);
      ref<Expr> c1 = generateExp(bast,n->getChild(0),f,argObjs,argSizes,w,retVal);
      if (!c1.isNull())
         res = NotExpr::create(c1);  
      return res;  
   }
   if (n->oper == PLUS) {
      unsigned w = getWidth(bast,n,f,retVal);
      ref<Expr> c1 = generateExp(bast,n->getChild(0),f,argObjs,argSizes,w,retVal);
      ref<Expr> c2 = generateExp(bast,n->getChild(1),f,argObjs,argSizes,w,retVal);
      if (!c1.isNull() && !c2.isNull()) {
         n->getChild(0)->print();
         n->getChild(1)->print();
         llvm::errs() << "operand widths: " << c1->getWidth() 
                      << " " << c2->getWidth() << "\n";
         res = AddExpr::create(c1,c2);  
      }
      return res; 
   } 
   if (n->oper == MINUS) {
      unsigned w = getWidth(bast,n,f,retVal);
      ref<Expr> c1 = generateExp(bast,n->getChild(0),f,argObjs,argSizes,w,retVal);
      ref<Expr> c2 = ConstantExpr::alloc(-1,w);
      if (!c1.isNull())
         res = MulExpr::create(c1,c2);  
      return res; 
   } 
   if (n->oper == TIMES) {
      unsigned w = getWidth(bast,n,f,retVal);
      ref<Expr> c1 = generateExp(bast,n->getChild(0),f,argObjs,argSizes,w,retVal);
      ref<Expr> c2 = generateExp(bast,n->getChild(1),f,argObjs,argSizes,w,retVal);
      if (!c1.isNull() && !c2.isNull())
         res = MulExpr::create(c1,c2);  
      return res; 
   } 
   if (n->oper == DIV) {
      unsigned w = getWidth(bast,n,f,retVal);
      ref<Expr> c1 = generateExp(bast,n->getChild(0),f,argObjs,argSizes,w,retVal);
      ref<Expr> c2 = generateExp(bast,n->getChild(1),f,argObjs,argSizes,w,retVal);
      if (!c1.isNull() && !c2.isNull())
         res = SDivExpr::create(c1,c2);  
      return res; 
   }
   if (n->oper == AND) {
      unsigned w = getWidth(bast,n,f,retVal);
      ref<Expr> c1 = generateExp(bast,n->getChild(0),f,argObjs,argSizes,w,retVal);
      ref<Expr> c2 = generateExp(bast,n->getChild(1),f,argObjs,argSizes,w,retVal);
      if (!c1.isNull() && !c2.isNull())
         res = AndExpr::create(c1,c2);  
      return res; 
   } 
   if (n->oper == OR) {
      unsigned w = getWidth(bast,n,f,retVal);
      ref<Expr> c1 = generateExp(bast,n->getChild(0),f,argObjs,argSizes,w,retVal);
      ref<Expr> c2 = generateExp(bast,n->getChild(1),f,argObjs,argSizes,w,retVal);
      if (!c1.isNull() && !c2.isNull())
         res = OrExpr::create(c1,c2);  
      return res; 
   } 
   if (n->oper == NOOP) {
      if (dynamic_cast<ConstantNode*>(n)) {
         res = ConstantExpr::alloc(((ConstantNode*)n)->value, width);
         return res;          
      }
      else if (dynamic_cast<IdentifierNode*>(n)) {
         IdentifierNode *in = (IdentifierNode*)n;
         Binding b = bast.bindings[in->value];
         if (b.comptype == "return") {
            llvm::errs() << "entity == " << b.entity << " func name " << f->getName() << "\n";
            if (f->getName() == b.entity) 
               return retVal;
            return NULL;
         }
         else if (b.comptype == "argsize") {
            if (argSizes.find(b.index) == argSizes.end())
               return NULL;
            res = ConstantExpr::alloc(argSizes[b.index], width);
            return res;          
         }
         else if (b.comptype == "none") {
            if (argObjs.find(b.index) != argObjs.end()) {
               std::pair<MemoryObject*,ObjectState*> p = argObjs[b.index];
               res = p.second->read(0, width);
               return res;
            }
            else return NULL;
         }
     }
   }
}

// Generates a KLEE Expr object based on the AST and the binding info in bast
// (mo,obj) corresponds to the lazy init memory object to which the expr will 
// be applied
ref<Expr> generateExp(BoundAST &bast, Function *f, std::map<unsigned, 
            std::pair<MemoryObject*,ObjectState*> > &argObjs, 
            std::map<unsigned, unsigned> &argSizes, ref<Expr> retVal) {
  ref<Expr> crv = retVal; 
  if (!crv.isNull())
    return generateExp(bast,bast.ast,f,argObjs,argSizes,crv->getWidth(),crv);
  else
    return generateExp(bast,bast.ast,f,argObjs,argSizes,0,crv);
}

bool isSimpleEquality(BoundAST &bast) {
   if (bast.ast->oper == EQ) {
      ASTNode *n1 = bast.ast->getChild(0);
      ASTNode *n2 = bast.ast->getChild(1);
      if (dynamic_cast<ConstantNode*>(n1)) {
        if (dynamic_cast<IdentifierNode*>(n2)) {
           IdentifierNode *in = (IdentifierNode*)n2;
           Binding b = bast.bindings[in->value];
           if (b.comptype == "none")
              return true;
        }
      }
      else if (dynamic_cast<ConstantNode*>(n2)) { 
         if (dynamic_cast<IdentifierNode*>(n1)) {
            IdentifierNode *in = (IdentifierNode*)n1;
            Binding b = bast.bindings[in->value];
            if (b.comptype == "none")
               return true;
         }
      }
      else if (dynamic_cast<IdentifierNode*>(n1) && 
                dynamic_cast<IdentifierNode*>(n2)) {
         IdentifierNode *in1 = (IdentifierNode*)n1;
         IdentifierNode *in2 = (IdentifierNode*)n2;
         Binding b1 = bast.bindings[in1->value]; 
         Binding b2 = bast.bindings[in2->value]; 
         if (b1.comptype == "sizeof" || b2.comptype == "sizeof" || 
             b1.comptype == "argsize" || b2.comptype == "argsize")
            return true;
      }
   }
   return false;
}

bool isSizeOfConstant(BoundAST &bast, Binding &bout, unsigned &size) {
   if (bast.ast->oper == EQ) {
      ASTNode *n1 = bast.ast->getChild(0);
      ASTNode *n2 = bast.ast->getChild(1);
      if (dynamic_cast<ConstantNode*>(n1)) {
        if (dynamic_cast<IdentifierNode*>(n2)) {
           IdentifierNode *in = (IdentifierNode*)n2;
           Binding b = bast.bindings[in->value];
           if (b.comptype == "sizeof")  {
              bout = b;
              size = ((ConstantNode*)n1)->value;
              return true;
           }
        }
      }
      else if (dynamic_cast<ConstantNode*>(n2)) {
        if (dynamic_cast<IdentifierNode*>(n1)) {
           IdentifierNode *in = (IdentifierNode*)n1;
           Binding b = bast.bindings[in->value];
           if (b.comptype == "sizeof") {
              bout = b;
              size = ((ConstantNode*)n2)->value;
              return true;
           }
        }
      }
   }
   return false;
}

bool isArgSizeConstant(BoundAST &bast, Binding &bout, unsigned &size) {

   if (bast.ast->oper == EQ) {
      ASTNode *n1 = bast.ast->getChild(0);
      ASTNode *n2 = bast.ast->getChild(1);
      if (dynamic_cast<ConstantNode*>(n1)) {
        if (dynamic_cast<IdentifierNode*>(n2)) {
           IdentifierNode *in = (IdentifierNode*)n2;
           Binding b = bast.bindings[in->value];
           if (b.comptype == "argsize")  {
              bout = b;
              size = ((ConstantNode*)n1)->value;
              return true;
           }
        }
      }
      else if (dynamic_cast<ConstantNode*>(n2)) {
        if (dynamic_cast<IdentifierNode*>(n1)) {
           IdentifierNode *in = (IdentifierNode*)n1;
           Binding b = bast.bindings[in->value];
           if (b.comptype == "argsize") {
              bout = b;
              size = ((ConstantNode*)n2)->value;
              return true;
           }
        }
      }
   }
   return false;

}
