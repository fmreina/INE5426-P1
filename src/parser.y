%{
	#include "ast.h"
	#include "symbolTable.h"
	using namespace std;
	using namespace AST;
	
	// TODO: SymbolTable
	
	AST::Block* programRoot; /* root node of program AST */
	ST::SymbolTable symTab;
	
	extern int yylex();
	extern void yyerror(const char* s, ...);
	
%}

/* yylval == %union 
 * union informs the values data can be stored */
%union {
	int integer;
	const char* string;

	AST::Node *node;
	AST::Block *block;
}

/* token defines terminal Symbols (tokens) */
%token T_NEW_LINE
%token T_PLUS
%token <integer> T_INT
%token <string> T_WORD
%token T_DEFINITION

/* type defines the type of our nonterminal symbols.
 * Types should match the names used in the union.
 * Example: %type<node> expr
 */
 %type <block> lines
 %type <node> line
 %type <node> inter 
 %type <node> definition
 
 /* Operator precedence for mathematical operators
 * The latest it is listed, the highest the precedence
 */
 %left T_DEFINITION
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
		| definition T_NEW_LINE
		;
		
inter: T_INT { $$ = new AST::Integer($1); } 
		 | inter T_PLUS inter { $$ = new AST::BinOp($1, AST::plus,$3); }
		 ;
		 
definition: T_DEFINITION T_WORD { $$ = symTab.newVariable( $2, NULL );}
			;
 	
 	
 	
 	
 	
 	
 	
 	
 	
 