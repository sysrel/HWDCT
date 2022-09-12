/* Grammar for the PROSE language describing constraints for PROMPT */

%{

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include "../../include/klee/Interpreter.h"
#include "Prose.h"
#include "../../include/klee/ExecutionState.h"
#include "llvm/Support/CommandLine.h"
#include "helper.h"

void yyerror(char const *s);
int yylex(void);

void panic(const char *msg) {
	fputs(msg, stderr);
	putc('\n', stderr);
	abort();
}

extern bool asyncMode;
extern klee::Interpreter *theInterpreter;
extern int primArraySize;
extern bool nullReturnValue;
extern cl::opt<bool> InitFuncPtrs;
extern cl::opt<bool> ModelFuncWithInlineASM;
extern cl::opt<bool> SkipSingletonHavocing;
extern cl::opt<std::string> EntryPoint;
extern std::map<std::string, std::string> functionModeledBy;
extern std::map<std::string, std::set<unsigned> > havocArgs;
extern std::map<std::string, std::set<std::string> > enforceOrigPatternWExceptions;
extern std::map<std::string, std::vector<BoundAST> > fieldConstraintMap;
extern std::map<std::string, std::vector<BoundAST> > funcArgConstraintMap;
extern std::map<std::string, std::map<unsigned, unsigned> > typeSpecificArrayFieldSize;
extern std::map<std::string, std::map<unsigned, unsigned> > funcSpecificArrayFieldSize;
extern unsigned loopBound;
extern bool symbolizeInlineAssembly;
extern std::set<std::string> lazyInitSingles;
extern std::map<std::string, std::vector<std::string> > inferenceClue;

%}

%token ALLOC
%token ARG
%token ARGS
%token ARGSIZE
%token ARRAY
%token ASM
%token BOUND
%token BY
%token CONTINUE
%token CONSTANT
%token DATA
%token EMBEDS
%token ENTRYPOINT
%token EXCEPT
%token FALSEVAL
%token FIELD
%token FREE
%token FUNCPTRS
%token FUNCS
%token FUNCTION
%token GLOBAL
%token HAVOC
%token HAVOCING
%token<y_ident> L_IDENT
%token IF
%token IS
%token INIT
%token INITZERO
%token INLINE
%token<y_int> INTEGER
%token LIFECYCLE
%token LOOP
%token MEMARG
%token MEMRETURN
%token MODEL
%token MODELS
%token MODELED
%token NULL_TOKEN
%token OF
%token OFF
%token ON
%token PATTERN
%token LTS
%token LEQS
%token GTS
%token GEQS
%token EQS
%token NOTS
%token NEQS
%token PLUSS
%token MINUSS
%token TIMESS
%token RETURN
%token RETURNONLY
%token RETURNOF
%token SETTINGS
%token SINGLETON
%token SINGLETONS
%token SIZE
%token SIZEARG
%token SIZEOF
%token SKIP
%token SYMBOLIZE
%token TO
%token TRUEVAL
%token TYPE
%token VALUE
%token WHERE
%token WITH

%left PLUSS MINUSS
%left TIMESS
%left NOTS

%error-verbose
%locations

%union {
	bool y_bool;
	int y_int;
	klee::Sequential *y_sequential;
	klee::Identifier *y_id;
        std::vector<klee::Identifier*> *y_id_list;
	ASTNode *y_ast;
	BoundAST *y_bound;
	std::map<std::string, Binding> *y_bind_map;
	std::pair<std::string, Binding> *y_bind_pair;
        std::set<std::string> *y_exception_set;
        std::set<unsigned> *y_number_list;
	Binding *y_bind;
	char *y_ident;
        Op op;
}

%type<y_bool> choice
%type<y_bool> boolean
%type<y_ast> expression
%type<y_bound> bound_constraint
%type<y_bind_map> bindings
%type<y_bind_pair> binding
%type<y_bind> entity
%type<y_id> lifecycle_entry
%type<y_sequential> lifecycle_model
%type<y_id_list> lifecycle_sequence;
%type<y_exception_set> regexplist
%type<y_number_list> numberList;

%%

API_model: GLOBAL SETTINGS ':' global_settings 
           DATA MODELS ':' data_models 
           FUNCTION MODELS ':' function_models 
           LIFECYCLE MODEL ':' lifecycle_model {
                //ExecutionState::setLifeCycleModel($4);
           };

global_settings:
	%empty
	| global_settings global_setting ';' 
	;

global_setting:
	ARRAY SIZE INTEGER { primArraySize = $INTEGER; }
	| NULL_TOKEN RETURN choice { nullReturnValue = $choice; }
	| INIT FUNCPTRS TO NULL_TOKEN choice { InitFuncPtrs = $choice; }
	| LOOP BOUND INTEGER { loopBound = $INTEGER; }
	| MODEL FUNCS WITH ASM choice { ModelFuncWithInlineASM = $choice; }
	| MODEL FUNCS WITH ASM choice PATTERN L_IDENT  
        { 
          std::string pattern($L_IDENT);
          /*if (pattern[0] == '*' && pattern[pattern.size()-1] == '*') 
             pattern = pattern.substr(1,pattern.size()-2);
          else assert(0 &&  "but_pattern should start and end with an asterisk\n");*/
          ModelFuncWithInlineASM = $choice; 
          assert(ModelFuncWithInlineASM && "Providing a pattern when NOT modeling functions with assembly does not have any affect!\n");
          if (enforceOrigPatternWExceptions.find(pattern) != 
                     enforceOrigPatternWExceptions.end())
             assert(0 && "Pattern defined twice for exceptional cases of inline assembly!\n");
          std::set<std::string> excp;
          enforceOrigPatternWExceptions[pattern] = excp;
        }
        | MODEL FUNCS WITH ASM choice PATTERN L_IDENT EXCEPT regexplist 
        { 
          std::string pattern($L_IDENT);
          /*if (pattern[0] == '*' && pattern[pattern.size()-1] == '*') 
             pattern = pattern.substr(1,pattern.size()-2);
          else assert(0 &&  "but_pattern should start and end with an asterisk\n");*/
          ModelFuncWithInlineASM = $choice;
          assert(ModelFuncWithInlineASM && "Providing a pattern when NOT modeling functions with assembly does not have any affect!\n");
          if (enforceOrigPatternWExceptions.find(pattern) !=
                     enforceOrigPatternWExceptions.end())
             assert(0 && "Pattern defined twice for exceptional cases of inline assembly!\n");
          enforceOrigPatternWExceptions[pattern] = *$regexplist;
        }
	| SYMBOLIZE INLINE ASM choice { symbolizeInlineAssembly = $choice; }
	| SKIP HAVOCING SINGLETONS choice { SkipSingletonHavocing = $choice; }
	;

choice:
	ON { $$ = true; }
	| OFF { $$ = false; }
	;

regexplist: L_IDENT
        { std::string es { $1 }; $$ = new std::set<std::string>(); $$->insert(es); }
        | regexplist ',' L_IDENT
        { std::string es { $3 }; $$->insert(es); }
        ;


data_models:
	%empty 
	| data_models data_model ';'

/* evaluated only for their side effects */
data_model:
	bound_constraint  {}
	| type_embedding { }
	| SINGLETON L_IDENT { std::string s($L_IDENT); lazyInitSingles.insert(s); }
	;

type_embedding:	TYPE L_IDENT EMBEDS TYPE L_IDENT {
	std::vector<std::string> inf;
	if (inferenceClue.find($5) != inferenceClue.end())
             inf = inferenceClue[$5];
        inf.push_back($2);
        inferenceClue[$5] = inf;
};

function_models:
	%empty
	| function_models function_model ';' 

function_model:
	L_IDENT MODELED BY L_IDENT { functionModeledBy[$1] = $4; }
	| RETURNONLY L_IDENT { APIHandler::addIgnoreHandler($2); } 
	| HAVOC ARGS numberList OF L_IDENT { 
            std::string f($L_IDENT); 
            havocArgs[f] = *$numberList; 
        } 
        | ALLOC L_IDENT SIZEARG INTEGER INITZERO boolean SYMBOLIZE 
                boolean 
        {
          std::vector<std::string> par;
          par.push_back($2);
          par.push_back(std::to_string($4));
          if ($6)
             par.push_back("true");
          else par.push_back("false");
          if ($8)
             par.push_back("true");
          else par.push_back("false");
          par.push_back("true"); // returns the pointer to the allocated mem 
          APIAction *a = new APIAction("alloc",par,new AllocAPIHandler()); 
          APIHandler::addAction($2,a);
        }
        | FREE L_IDENT MEMARG INTEGER { 
          std::vector<std::string> par;
          par.push_back($2);
          par.push_back(std::to_string($4));
          APIAction *a = new APIAction("free", par, new FreeAPIHandler());
          APIHandler::addAction($2,a);
        }
	| bound_constraint { }
	;

numberList:
        INTEGER { 
		$$ = new std::set<unsigned>(); 
		assert($1 >= 0 && "Negative argument no!\n"); 
		$$->insert($1); 
	}
        | numberList ',' INTEGER { 
		assert($3 >= 0 && "Negative argument no!\n");
		$1->insert($3); 
	}
        ;

boolean: TRUEVAL {
           $$ = true;
         }
        |
         FALSEVAL {
           $$ = false;
        }  
        ;


lifecycle_model: lifecycle_sequence { 
            $$ = new Sequential();
            for(unsigned i=0; i<$1->size(); i++)
               $$->addStep((*$1)[i]);           
            ExecutionState::setLifeCycleModel($$); 
        }
        | ENTRYPOINT L_IDENT  { std::string ep { $2 }; EntryPoint = ep; }
        | L_IDENT  { std::string ep { $1 }; EntryPoint = ep; }
        ;   


lifecycle_sequence: lifecycle_entry { 
           $$ = new std::vector<Identifier*>(); 
           $$->push_back($1);
           EntryPoint = $1->getValue(); 
        } 
        | lifecycle_sequence ';' lifecycle_entry { $1->push_back($3); $$ = $1; }
        ;

lifecycle_entry:
	L_IDENT {
          std::string fname { $L_IDENT };
          $$ = new Identifier(fname);
	  $$->setSuccessReturnValue(0);
	}
	| L_IDENT '[' INTEGER ']' {
          std::string fname { $L_IDENT };
          $$ = new Identifier(fname);
          $$->setSuccessReturnValue($3);
        } 
	| L_IDENT CONTINUE IF bound_constraint {
          std::string fname { $L_IDENT };
          $$ = new Identifier(fname);
          $$->setSuccessConstraint($4);
        }
	;

bound_constraint:
	'(' expression ')' WHERE bindings {
		auto bindings = *$bindings;
		delete $bindings;
		$$ = new BoundAST { $expression, bindings };
                std::string entity = ""; std::string type = ""; std::string comptype = "";
                for(auto bi : bindings) {
                   if (entity == "")
                      entity = bi.second.entity;
                   else if (entity != bi.second.entity)
                     assert(0 && "Multiple data types in the same constraint!\n");
                   if (type == "")
                      type = bi.second.type;
                   else if (type != bi.second.type)
                      assert(0 && "Cannot mix field and function argument related constraints\n");
                   if (bi.second.comptype == "return")
                      comptype = bi.second.comptype;
                }
                std::vector<BoundAST> s;
                if (type == "type") {
                   if (fieldConstraintMap.find(entity) != fieldConstraintMap.end())
                      s = fieldConstraintMap[entity]; 
                   Binding bc; unsigned size;
                   if (isSizeOfConstant(*$$, bc, size)) {
                      std::map<unsigned, unsigned>  m;
                      if (typeSpecificArrayFieldSize.find(bc.entity) != 
                                     typeSpecificArrayFieldSize.end())
                         m = typeSpecificArrayFieldSize[bc.entity];
                      m[bc.index] = size;
                      typeSpecificArrayFieldSize[bc.entity] = m;
                   }
                   else if (isSimpleEquality(*$$)) {
                      // equality constraints will be applied first
                      s.insert(s.begin(), *$$);
                   }
                   else s.push_back(*$$);
                   fieldConstraintMap[entity] = s;
                }
                else if (type == "func") {
                   if (comptype == "return") {
                      /*if (returnValueConstraintMap.find(entity) != returnValueConstraintMap.end())
                         s = returnValueConstraintMap[entity];
                      s.push_back(*$$);
                      returnValueConstraintMap[entity] = s;*/
                   }
                   else {
                      if (funcArgConstraintMap.find(entity) != funcArgConstraintMap.end())
                         s = funcArgConstraintMap[entity];
                      Binding bc; unsigned as; 
                      if (isArgSizeConstant(*$$, bc, as)) {
                         std::map<unsigned, unsigned>  m;
                         if (funcSpecificArrayFieldSize.find(bc.entity) != 
                                           funcSpecificArrayFieldSize.end())
                            m = funcSpecificArrayFieldSize[bc.entity];
                         m[bc.index] = as;
                         funcSpecificArrayFieldSize[bc.entity] = m;
                      }
                      else if (isSimpleEquality(*$$)) {
                         // equality constraints will be applied first
                         s.insert(s.begin(), *$$);
                      }   
                      else s.push_back(*$$);
                      funcArgConstraintMap[entity] = s;
                   }
                } 
                //std::cerr << "Generated constraint: \n";
                //$$->ast->print();	
                //std::cerr << "=============\n";
	}
	;

expression:
	INTEGER  { $$ = new ConstantNode($1); }
        | L_IDENT { std::string id($1); $$ = new IdentifierNode(id); }
        | TRUEVAL { $$ = new ConstantNode(1); }
        | FALSEVAL { $$ = new ConstantNode(0); }
	| NOTS expression { 
          $$ = new ASTNode(NEG); 
          $$->addChild($2);
        }
        | MINUSS expression { 
           $$ = new ASTNode(MINUS);
           $$->addChild($2);
        }
	| expression PLUSS expression {
          $$ = new ASTNode(PLUS);
          $$->addChild($1);
          $$->addChild($3);
	}
	| expression MINUSS expression {
          $$ = new ASTNode(MINUS);
          $$->addChild($1);
          $$->addChild($3); 
	}
	| expression TIMESS expression {
          $$ = new ASTNode(TIMES);
          $$->addChild($1);
          $$->addChild($3);
	}
	| expression LTS expression {
          $$ = new ASTNode(LT);
          $$->addChild($1);
          $$->addChild($3);
	}
	| expression LEQS expression {
          $$ = new ASTNode(LTE);
          $$->addChild($1);
          $$->addChild($3);
	}
	| expression GTS expression {
          $$ = new ASTNode(GT);
          $$->addChild($1);
          $$->addChild($3);
          std::cerr << "> exp\n";
	}
	| expression GEQS expression {
          $$ = new ASTNode(GTE);
          $$->addChild($1);
          $$->addChild($3);
	}
	| expression EQS expression {
          $$ = new ASTNode(EQ);
          $$->addChild($1);
          $$->addChild($3);
	}
	| expression NEQS expression {
          $$ = new ASTNode(NEQ);
          $$->addChild($1);
          $$->addChild($3);
	}
        | '(' expression ')' { $$ = $2; }
	;


// NOTE: non-empty
bindings:
	binding {
		$$ = new std::map<std::string, Binding> { *$binding };
		delete $binding;
	}
	| bindings ',' binding {
		$$ = $1;
		$$->insert(*$binding);
		delete $binding;
	}

binding:
	L_IDENT IS entity {
		$$ = new std::pair<std::string, Binding> { $L_IDENT, *$entity };
		delete $entity;
	}
	;

entity:
	L_IDENT FIELD INTEGER {
		// fieldConstraintMap
		$$ = new Binding { "type", "none", $L_IDENT, (unsigned int)$INTEGER };
	}
	| SIZEOF L_IDENT FIELD INTEGER  {
		// funcArgConstraintMap
		// entity: either a type or function name
		$$ = new Binding { "type", "sizeof", $L_IDENT, (unsigned int)$INTEGER };
	}
	| L_IDENT ARG INTEGER {
		$$ = new Binding { "func", "none", $L_IDENT, (unsigned int)$INTEGER };
	}
	| RETURNOF L_IDENT  {
                std::string s($L_IDENT);
		$$ = new Binding { "func", "return", s, 0 };
	}
        | ARGSIZE L_IDENT ARG INTEGER {
      		$$ = new Binding { "func", "argsize", $L_IDENT, (unsigned int)$INTEGER };
        }
        ;
%%
