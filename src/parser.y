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
	AST::FunctionDeclaration *fun;
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
%token T_DECL_FUNCTION
%token T_DEF_FUNCTION
%token T_END_FUNCTION
%token T_RETURN
%token T_IF
%token T_THEN
%token T_ELSE
%token T_END_IF

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
%type <fun> function_list
%type <node> def_func
%type <node> parameters
%type <var> variable_param
%type <arr> array_param
%type <node> scope
%type <node> if_scope
 
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
 *	Grammar structure based on the example presented by llpilla @github
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
		| scope T_NEW_LINE
		| def_func T_NEW_LINE
		;

/*
 *	A declaration is given by a type of variable 
 *	and a list of variables
 */
declaration :	type T_COLON variable_list { $$ = $3; }
				| type T_OPEN_BRACKETS size T_CLOSE_BRACKETS T_COLON array_list { $$ = $6; }
				| T_DECL_FUNCTION type T_COLON function_list { $$ = $4; }
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
			| target_array { $$ = $1; }		
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

/*
 *	target_array gets the array and the position to be assigned
 */
target_array: T_WORD T_OPEN_BRACKETS expression T_CLOSE_BRACKETS { $$ = symTab.assignVariable($1); $$->size = $3; }
			 ;

/*
 *	list the function declaration, similar as it is done with the variable declaration
 *	there is a problem with the list of parameters. it needs to be fixed to be able to get more than on parameter
 *	as a temporary solution, the function declaration accepts the maximum of two parameters.
 */
function_list: T_WORD T_OPEN_PARENTHESIS T_CLOSE_PARENTHESIS { $$ = new AST::FunctionDeclaration(TYPE::lastType);
					 											$$->funcs.push_back(symTab.newVariable($1, TYPE::lastType)); }
				| T_WORD T_OPEN_PARENTHESIS parameters T_CLOSE_PARENTHESIS { $$ = new AST::FunctionDeclaration(TYPE::lastType);
					 											$$->funcs.push_back(symTab.newVariable($1, TYPE::lastType));
					 											$$->params.push_back($3); }
				| T_WORD T_OPEN_PARENTHESIS parameters T_COMMA parameters T_CLOSE_PARENTHESIS { $$ = new AST::FunctionDeclaration(TYPE::lastType);
					 											$$->funcs.push_back(symTab.newVariable($1, TYPE::lastType));
					 											$$->params.push_back($3); $$->params.push_back($5);}
				;

/*
 *	gets the list of parameters - variables or arrays
 */
parameters : type T_COLON variable_param { $$ = $3; }
			| type T_OPEN_BRACKETS size T_CLOSE_BRACKETS T_COLON array_param { $$ = $6; }
			| parameters T_COMMA parameters { $$ = $1; $$->params.push_back($3);}
			;

/*
 *	gets the name for a variable param
 */
variable_param:	T_WORD { $$ = new AST::VariableDeclaration(TYPE::lastType);
						 $$->variables.push_back(symTab.newVariable($1, TYPE::lastType)); }
				;

/*
 *	gets the name for an array param
 */
array_param: T_WORD { $$ = new AST::ArrayDeclaration(TYPE::lastType, Array::lastSize);
					 $$->variables.push_back(symTab.newVariable($1, TYPE::lastType)); }
			;

scope: if_scope { $$ = $1; }
	 ;

if_scope: T_IF expression T_THEN T_NEW_LINE lines T_END_IF { $$ = $5; }
		;
/*
 *	the definition of functions still need to be implemented
 */
def_func: T_DEF_FUNCTION { std::cout<< "The function definition needs to be inplemented yet"<<endl; };
%%

