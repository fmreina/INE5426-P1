%{
	#include "ast.h"
	
	// TODO: SymbolTable
	
	AST::Block* programRoot; /* root node of program AST */
	
	extern int yylex();
	extern void yyerror(const char* s, ...);
%}

/* yylval == %union 
 * union informs the values data can be stored */
%union {
	int integer;

	AST::Node *node;
	AST::Block *block;
}

/* token defines terminal Symbols (tokens) */
%token T_NEW_LINE
%token T_PLUS
%token <integer> T_INT

/* type defines the type of our nonterminal symbols.
 * Types should match the names used in the union.
 * Example: %type<node> expr
 */
 %type <block> lines
 %type <node> line
 %type <node> inter 
 
 /* Operator precedence for mathematical operators
 * The latest it is listed, the highest the precedence
 */
 %left T_PLUS
 %nonassoc error
 
 /* starting rule */
 %start program
 
 %%
 
 program : lines { programRoot = $1; }
 	;
 	
 lines : line { $$ = new AST::Block(); if ($1 != NULL) $$->lines.push_back($1); }
 		| lines line { if($2 != NULL) $1->lines.push_back($2); }
 		;
 		
line : T_NEW_LINE { $$ = NULL; } /* nothing to be used */
		| inter T_NEW_LINE /* $$ = $1 when nothing is said */
		;
		
inter: T_INT { $$ = new AST::Integer($1); } 
		 | inter T_PLUS inter { $$ = new AST::BinOp($1, AST::plus,$3); }
		 ;
		 

 	
 	
 	
 	
 	
 	
 	
 	
 	
 