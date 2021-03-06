/*
 *	Scanner
 *	references: 
 *	 - llpilla/compiler_examples/allen (github)
 *	 - Aho, Alfred, et al - Compilers: principles, techniques, and tools - 2nd ed. 2007 Pearson Education
 *	 - Levine, John - Flex & Bison - Unix text processing tools - 2009 O'Reilly Media
 *		*page 21 for the regular exprecion on <real>
 */
%{
#include <string>
#include "ast.h"
#include "parser.h"

extern int yylineno;

void yyerror(const char* s, ...);

%}

%option noyywrap nodefault yylineno

digit[0-9]+
real [0-9]*\.?[0-9]+|[0-9]+\.[0-9]*
word[a-zA-Z]+

%%

[ \t]	; // to ignore white spaces
\n		{ return T_NEW_LINE; }

"+"		{ return T_PLUS; }
"-"		{ return T_MINUS; }
"*"		{ return T_TIMES; }
"/"     { return T_DIVIDE; }
":="	{ return T_ASSIGN; }
">"		{ return T_GREATER; }
">="	{ return T_GREATER_EQUALS; }	
"<"		{ return T_SMALLER; }	
"<="	{ return T_SMALLER_EQUALS; }	
"="		{ return T_EQUALS; }	
"~="	{ return T_DIFFERENT; }	
"~"		{ return T_NOT; }	
"AND"	{ return T_AND; }	
"OR"	{ return T_OR; }	

","		{ return T_COMMA; }
":"		{ return T_COLON; }
";"		{ return T_SEMICOLON; } // semicolon indicates the end of the current line.
"("		{ return T_OPEN_PARENTHESIS; }
")"		{ return T_CLOSE_PARENTHESIS; }
"["		{ return T_OPEN_BRACKETS; }
"]"		{ return T_CLOSE_BRACKETS; }

"int"	{ return T_TYPE_INT; }
"real"	{ return T_TYPE_REAL; }
"bool"	{ return T_TYPE_BOOL; }
"decl fun"	{ return T_DECL_FUNCTION; }
"def fun"	{ return T_DEF_FUNCTION; }
"end def"	{ return T_END_DEF; }
"return"	{ return T_RETURN; }
"if"	{ return T_IF; }
"then"	{ return T_THEN; }
"else"	{ return T_ELSE; }
"end if"	{ return T_END_IF; }
"while"	{ return T_WHILE; }
"do"	{ return T_DO; }
"end while"	{ return T_END_WHILE; }
"def type" { return T_DEF_TYPE; }

"TRUE"	{ yylval.string = strdup(yytext); return T_BOOL; } // received as string as the objective is only printing
"FALSE"	{ yylval.string = strdup(yytext); return T_BOOL; } // received as string as the objective is only printing
{digit}	{ yylval.string = strdup(yytext); return T_INT; } // received as string as the objective is only printing
{real}	{ yylval.string = strdup(yytext); return T_REAL; } // received as string as the objective is only printing
{word}	{ yylval.string = strdup(yytext); return T_WORD; } // received as string as the objective is only printing

.		{ yyerror("Token desconhecido! %c\n", *yytext); } // inform of any unknow character (PT)

%%
void yyerror(const char *s, ...){
	va_list ap;
	va_start(ap, s);
	std::fprintf(stderr, "Line %d: error: ", yylineno);
	std::vfprintf(stderr,s,ap);
}
