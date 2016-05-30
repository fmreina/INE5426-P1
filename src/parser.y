// Parser - references as shown on README.md
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
	AST::VariableDeclaration *var;
	AST::ArrayDeclaration *arr;
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
%token T_OPEN_BRACKETS
%token T_CLOSE_BRACKETS

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
%type <var> variable_list
%type <node> assignment
%type <node> expression 
%type <node> target
%type <string> size
%type <arr> array_list
%type <node> target_array
 
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
 *	Grammar structure as presented by llpilla @github
 */

/*
 *	A program is made of many lines (blocks) 
 */
program : lines { programRoot = $1; }
 		;
 	
/*
 *	Each group of lines can be a single line or 
 *	a group of lines followed by a single line
 */
lines :	line { $$ = new AST::Block(); if ($1 != NULL) $$->lines.push_back($1); }
 		| lines line { if($2 != NULL) $1->lines.push_back($2); }
 		;

/*
 *	A line may be a declaration or an assignment
 */ 		
line :	declaration T_SEMICOLON T_NEW_LINE { $$ = $1; }
		| assignment T_SEMICOLON T_NEW_LINE
		;

/*
 *	A declaration is given by a type of variable 
 *	and a list of variables
 */
declaration :	type T_COLON variable_list { $$ = $3; }
				| type T_OPEN_BRACKETS size T_CLOSE_BRACKETS T_COLON array_list { $$ = $6; }
				;

/*
 *	A type of variable may be an integer, real or boolean
 */
type :	T_TYPE_INT { TYPE::lastType = TYPE::integer; }
		| T_TYPE_REAL { TYPE::lastType = TYPE::real; }
		| T_TYPE_BOOL { TYPE::lastType = TYPE::boolean; }
		;

/*
 *	Each list of variable can be a single word { creates a new instance of variableDeclaration and push the variable into the variable list}
 *	or a list of variables followed by a word { receives a new list and a variable, and push the the variable into the list }
 */
variable_list:	T_WORD { $$ = new AST::VariableDeclaration(TYPE::lastType);
						 $$->variables.push_back(symTab.newVariable($1, TYPE::lastType)); }
				| variable_list T_COMMA T_WORD { $$ = $1;
												 $$->variables.push_back(symTab.newVariable($3, TYPE::lastType)); }
				;

/*
 *	creates a relation and assign a expression to a variable coming from target
 */
assignment: target T_ASSIGN expression { $$ = new AST::BinOp($1, OPERATION::assign, $3->coerce($1)); }
			| target_array T_ASSIGN expression { $$ = new AST::BinOp($1, OPERATION::assign, $3->coerce($1)); }
			;

/*
 *	creates a new variable in the symbol table
 */
target: T_WORD { $$ = symTab.assignVariable($1); }
		;

/*
 *	decalres a expression as being a variable, or a value, or an operation between two expressions, or a minus/negation operation of an expression
 *	for T_WORD, it uses a variable from the symbol table
 *	for the values, it creates a new instance of Value givin as parameters the value received and a <TYPE::type>
 */
expression:	T_WORD { $$ = symTab.useVariable($1); }
			| T_INT { $$ = new AST::Value($1, TYPE::integer); }
			| T_REAL { $$ = new AST::Value($1, TYPE::real); }
			| T_BOOL { $$ = new AST::Value($1, TYPE::boolean); }
			| expression T_PLUS expression { $$ = new AST::BinOp($1->coerce($3), OPERATION::plus, $3->coerce($1)); }
			| expression T_MINUS expression { $$ = new AST::BinOp($1->coerce($3), OPERATION::minus, $3->coerce($1)); }
			| expression T_TIMES expression { $$ = new AST::BinOp($1->coerce($3), OPERATION::times, $3->coerce($1)); }
			| expression T_DIVIDE expression { $$ = new AST::BinOp($1->coerce($3), OPERATION::divide, $3->coerce($1)); }
			| expression T_GREATER expression { $$ = new AST::BinOp($1->coerce($3), OPERATION::greater, $3->coerce($1)); }
			| expression T_GREATER_EQUALS expression { $$ = new AST::BinOp($1->coerce($3), OPERATION::greater_equals, $3->coerce($1)); }
			| expression T_SMALLER expression { $$ = new AST::BinOp($1->coerce($3), OPERATION::smaller, $3->coerce($1)); }
			| expression T_SMALLER_EQUALS expression { $$ = new AST::BinOp($1->coerce($3), OPERATION::smaller_equals, $3->coerce($1)); }
			| expression T_EQUALS expression { $$ = new AST::BinOp($1->coerce($3), OPERATION::equals, $3->coerce($1)); }
			| expression T_DIFFERENT expression { $$ = new AST::BinOp($1->coerce($3), OPERATION::different, $3->coerce($1)); }
			| expression T_AND expression { $$ = new AST::BinOp($1, OPERATION::and_op, $3); }
			| expression T_OR expression { $$ = new AST::BinOp($1, OPERATION::or_op, $3); }
			| T_NOT expression { $$ = new AST::UnOp(OPERATION::not_op, $2); }
			| T_MINUS expression %prec U_NEGATIVE { $$ = new AST::UnOp(OPERATION::u_minus, $2); }
			| T_OPEN_PARENTHESIS expression T_CLOSE_PARENTHESIS { $$ = $2; }			
			;

/*
 *	only sets the size for the array
 */
size: T_INT {  Array::lastSize = $1; }
	  ;

/*
 *	the array variable can be only one variable or a list of variables
 */
array_list: T_WORD { $$ = new AST::ArrayDeclaration(TYPE::lastType, Array::lastSize);
					 $$->variables.push_back(symTab.newVariable($1, TYPE::lastType)); }
			| array_list T_COMMA T_WORD { $$ = $1;
			 							  $$->variables.push_back(symTab.newVariable($3, TYPE::lastType)); }
			;

target_array: T_WORD T_OPEN_BRACKETS expression T_CLOSE_BRACKETS { $$ = symTab.assignVariable($1); $$->size = $3; }
			 ;
%%
