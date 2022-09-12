%option nounput
%option noyywrap
%option noinput

%{
#include <stdbool.h>
#include "../../include/klee/Interpreter.h"
#include "Prose.h"
#include "../../include/klee/ExecutionState.h"
#include "llvm/Support/CommandLine.h"
#include "helper.h"
#include "parser.h"

extern
void BeginToken(char *t) ;

void yyerror(char const *s) {
  fprintf (stderr, "%s\n", s);
}
%}
%option yylineno
ID       [_a-zA-Z][_a-zA-Z0-9]*
%%

[ \t\r\n]+  {  BeginToken(yytext); }
"alloc" { BeginToken(yytext); return ALLOC; }
"args" { BeginToken(yytext); return ARGS; }
"arg" { BeginToken(yytext); return ARG; }
"argsize" { BeginToken(yytext); return ARGSIZE; }
"array" { BeginToken(yytext); return ARRAY; }
"asm" { BeginToken(yytext); return ASM; }
"bound" { BeginToken(yytext); return BOUND; }
"by" { BeginToken(yytext); return BY; }
"continue" { BeginToken(yytext); return CONTINUE; }
"constant" { BeginToken(yytext); return CONSTANT; }
"data" { BeginToken(yytext); return DATA; }
"embeds" { BeginToken(yytext); return EMBEDS; }
"entry-point" { BeginToken(yytext); return ENTRYPOINT; }
"except" { BeginToken(yytext); return EXCEPT; }
"false" { BeginToken(yytext); return FALSEVAL; }
"field" { BeginToken(yytext); return FIELD; }
"funcptrs" { BeginToken(yytext); return FUNCPTRS; }
"funcs" { BeginToken(yytext); return FUNCS; }
"function" { BeginToken(yytext); return FUNCTION; }
"global" { BeginToken(yytext); return GLOBAL; }
"havoc" { BeginToken(yytext); return HAVOC; }
"havocing" { BeginToken(yytext); return HAVOCING; }
"if" { BeginToken(yytext); return IF; }
"initzero" { BeginToken(yytext); return INITZERO; } 
"init" { BeginToken(yytext); return INIT; }
"is" { BeginToken(yytext); return IS; }
"init" { BeginToken(yytext); return INIT; }
"inline" { BeginToken(yytext); return INLINE; }
"lifecycle" { BeginToken(yytext); return LIFECYCLE; }
"loop" { BeginToken(yytext); return LOOP; }
"memarg" { BeginToken(yytext); return MEMARG; }
"memreturn" { BeginToken(yytext); return MEMRETURN; }
"model" { BeginToken(yytext); return MODEL; }
"models" { BeginToken(yytext); return MODELS; }
"modeled" { BeginToken(yytext); return MODELED; }
"null" { BeginToken(yytext); return NULL_TOKEN; }
"of" { BeginToken(yytext); return OF; }
"off" { BeginToken(yytext); return OFF; }
"on" { BeginToken(yytext); return ON; }
"but_use_original_with_pattern" { BeginToken(yytext); return PATTERN; }
"return" { BeginToken(yytext); return RETURN; }
"returnonly" { BeginToken(yytext); return RETURNONLY; }
"returnof" { BeginToken(yytext); return RETURNOF; }
"settings" { BeginToken(yytext); return SETTINGS; }
"singleton" { BeginToken(yytext); return SINGLETON; }
"singletons" { BeginToken(yytext); return SINGLETONS; }
"size" { BeginToken(yytext); return SIZE; }
"sizearg" { BeginToken(yytext); return SIZEARG; }
"sizeof" { BeginToken(yytext); return SIZEOF; }
"skip" { BeginToken(yytext); return SKIP; }
"symbolize" { BeginToken(yytext); return SYMBOLIZE; }
"type" { BeginToken(yytext); return TYPE; }
"to" { BeginToken(yytext); return TO; }
"true" { BeginToken(yytext); return TRUEVAL; }
"value" { BeginToken(yytext); return VALUE; }
"where" { BeginToken(yytext); return WHERE; }
"with" { BeginToken(yytext); return WITH; }
"<" { BeginToken(yytext); return LTS; }
"<=" { BeginToken(yytext); return LEQS; }
">" { BeginToken(yytext); return GTS; }
">=" { BeginToken(yytext); return GEQS; }
"=" { BeginToken(yytext); return EQS; }
"!" { BeginToken(yytext); return NOTS; }
"!=" { BeginToken(yytext); return NEQS; }
"+" { BeginToken(yytext); return PLUSS; }
"-" { BeginToken(yytext); return MINUSS; }
"*" { BeginToken(yytext); return TIMESS; }
{ID} {
    BeginToken(yytext);
    yylval.y_ident = (char*)malloc(strlen(yytext)+1);
    strcpy(yylval.y_ident, yytext);
    //printf("%s\n",yytext);
    std::string s(yytext);
    if (s == "argsize")
       return ARGSIZE;
    else if (s == "returnof")
       return RETURNOF;
    else if (s == "alloc")
       return ALLOC;
    else if (s == "free")
      return FREE;
    else if (s == "havoc")
      return HAVOC;
    else if (s == "returnOnly")
      return RETURNONLY;
    else if (s == "entry-point")
      return ENTRYPOINT;
    else return L_IDENT;
    } 
[0-9]+ { BeginToken(yytext); yylval.y_int=atoi(yytext); return INTEGER; }
"//".* { /* skip comment */
           BeginToken(yytext); 
         }
. { BeginToken(yytext); return yytext[0]; }
