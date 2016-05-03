%{
	#include "ast.h"
	#include "symbolTable.h"
	using namespace std;
	using namespace AST;
	
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
%token T_ASSIGN

/* type defines the type of our nonterminal symbols.
 * Types should match the names used in the union.
 * Example: %type<node> expr
 */
%type <block> program
%type <block> lines
%type <node> line
%type <node> expression 
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
		| expression T_NEW_LINE /* $$ = $1 when nothing is said */
		| T_DEFINITION definition T_NEW_LINE { $$ = $2;}
		| T_WORD T_ASSIGN expression { AST::Node* node = symTab.assignVariable($1);
						$$ = new AST::BinOp(node, AST::assign, $3); }
		;
		
expression: T_INT { $$ = new AST::Integer($1); } 
		 | expression T_PLUS expression { $$ = new AST::BinOp($1, AST::plus,$3); }
		 | T_WORD { $$ = symTab.useVariable($1); }
		 ;
		 
definition: T_WORD { $$ = symTab.newVariable( $1, NULL );}
			;
 	
 	
 	
%%
 	

