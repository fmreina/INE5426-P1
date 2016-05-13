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

/* 
 *	yylval == %union 
 * 	union informs the values data can be stored 
 */
%union {
	const char* string;
	
	AST::Node *node;
	AST::Block *block;
}

/*
 *	token defines terminal Symbols (tokens)
 */
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

%token <string> T_INT
%token <string> T_REAL
%token <string> T_BOOL
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

/* 
 *	type defines the type of our nonterminal symbols.
 *	Types should match the names used in the union.
 *	Example: %type<node> expr
 */
%type <block> program
%type <block> lines
%type <node> line
%type <node> declaration
%type <node> type
%type <node> variable_list
%type <node> assignment
%type <node> expression 
 
/*
 *	Operator precedence for mathematical operators
 *	The latest it is listed, the highest the precedence
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
 
/*
 *	starting rule 
 */
%start program
 
%%
/*
 * Grammar structure as presented by llpilla 
 */
program : lines { programRoot = $1; }
 		;
 	
lines :	line { $$ = new AST::Block(); if ($1 != NULL) $$->lines.push_back($1); }
 		| lines line { if($2 != NULL) $1->lines.push_back($2); }
 		;
 		
line :	declaration T_SEMICOLON T_NEW_LINE { $$ = $1; }
		| assignment T_SEMICOLON T_NEW_LINE
		;

declaration :	type T_COLON variable_list { $$ = $3; }
				;

type :	T_TYPE_INT { Type::lastType = Type::integer; }
		| T_TYPE_REAL { Type::lastType = Type::real; }
		| T_TYPE_BOOL { Type::lastType = Type::boolean; }
		;

variable_list:	T_WORD {  }
			variable_list T_COMMA T_WORD {  }
			;

assignment: T_WORD T_ASSIGN expression {  }
			;

expression:	T_WORD {}
			| T_INT {}
			| T_REAL {}
			| T_BOOL {}
			| expression T_PLUS expression { }
			;


%%
 	