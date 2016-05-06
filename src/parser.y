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
	const char* type;

	AST::Node *node;
	AST::Block *block;
}

/* token defines terminal Symbols (tokens) */
%token T_NEW_LINE

%token T_PLUS
%token T_MINUS
%token T_TIMES
%token T_DIVIDE
%token T_GREATER
%token T_GREATER_EQUALS	
%token T_SMALLER
%token T_SMALLER_EQUALS	
%token T_EQUALS	
%token T_DIFFERENT	
%token T_NOT	
%token T_TRUE	
%token T_FALSE	
%token T_AND	
%token T_OR	

%token <integer> T_INT
%token <string> T_WORD

%token T_DEFINITION
%token T_TYPE_INT
%token T_TYPE_REAL
%token T_TYPE_BOOL

%token T_ASSIGN
%token T_COMMA
%token T_COLON
%token T_SEMICOLON
%token T_OPEN_PARENTHESIS
%token T_CLOSE_PARENTHESIS

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
 %left T_PLUS T_MINUS
 %left T_TIMES T_DIVIDE
 %left T_AND T_OR
 %left T_NOT T_TRUE T_FALSE
 %left T_GREATER T_GREATER_EQUALS T_SMALLER T_SMALLER_EQUALS T_EQUALS T_DIFFERENT
 %left T_CLOSE_PARENTHESIS
 %left T_OPEN_PARENTHESIS
 %right U_NEGATIVE
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
		| expression T_SEMICOLON T_NEW_LINE /* $$ = $1 when nothing is said */
		| T_DEFINITION T_COLON definition T_SEMICOLON T_NEW_LINE { $$ = $3;}
		| T_TYPE_INT T_COLON definition T_SEMICOLON T_NEW_LINE { $$ = $3; }
		| T_TYPE_REAL T_COLON definition T_SEMICOLON T_NEW_LINE { $$ = $3;}
		| T_TYPE_BOOL T_COLON definition T_SEMICOLON T_NEW_LINE { $$ = $3;}
		| T_WORD T_ASSIGN expression T_SEMICOLON T_NEW_LINE { AST::Node* node = symTab.assignVariable($1);
						$$ = new AST::BinOp(node, AST::assign, $3); }
		;
		
expression: T_INT { $$ = new AST::Integer($1); } 
		 | expression T_PLUS expression { $$ = new AST::BinOp($1, AST::plus,$3); }
		 | expression T_MINUS expression { $$ = new AST::BinOp($1, AST::minus,$3); }
		 | expression T_DIVIDE expression { $$ = new AST::BinOp($1, AST::divide,$3); }
		 | expression T_TIMES expression { $$ = new AST::BinOp($1, AST::times,$3); }
		 | expression T_SMALLER expression { $$ = new AST::BinOp($1, AST::smaller,$3); }
		 | expression T_SMALLER_EQUALS expression { $$ = new AST::BinOp($1, AST::smaller_equals,$3); }
		 | expression T_GREATER expression { $$ = new AST::BinOp($1, AST::greater,$3); }
		 | expression T_GREATER_EQUALS expression { $$ = new AST::BinOp($1, AST::greater_equals,$3); }
		 | expression T_EQUALS expression { $$ = new AST::BinOp($1, AST::equals,$3); }
		 | expression T_DIFFERENT expression { $$ = new AST::BinOp($1, AST::different,$3); }
		 | expression T_AND expression { $$ = new AST::BinOp($1, AST::and_op,$3); }
		 | expression T_OR expression { $$ = new AST::BinOp($1, AST::or_op,$3); }
		 /*| T_MINUS expression %prec U_NEGATIVE { $$ = new AST::Integer(-$2); }*/
		 | T_OPEN_PARENTHESIS expression T_CLOSE_PARENTHESIS { $$ = ( $2 ); }
		 | T_WORD { $$ = symTab.useVariable($1); }
		 ;
		 
definition: T_WORD { $$ = symTab.newVariable( $1, NULL );}
			| definition T_COMMA T_WORD { $$ = symTab.newVariable( $3, $1 ); }
			;
 	
 	
 	
%%
 	

