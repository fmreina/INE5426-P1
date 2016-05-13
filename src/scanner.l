%{
#include <string>
#include "ast.h"
#include "parser.h"

extern int yylineno;

void yyerror(const char* s, ...);

%}

%option noyywrap nodefault yylineno

digit[0-9]+
real [0-9]*\.?[0-9]+|[0-9]+\.[0-9]* // from flexbison book page 21
word[a-zA-Z]+

%%

[ /t]	; // to ignore spaaces
\n		{ return T_NEW_LINE; }

"+"		{ return T_PLUS; }
"-"		{ return T_MINUS; }
"*"		{ return T_TIMES; }
"/"		{ return T_DIVIDE; }
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
"TRUE"	{ return T_BOOL; }	
"FALSE"	{ return T_BOOL; }	

","		{ return T_COMMA; }
":"		{ return T_COLON; }
";"		{ return T_SEMICOLON; } // semicolon indicates the end of the current line. It could indicates a new line?
"("		{ return T_OPEN_PARENTHESIS; }
")"		{ return T_CLOSE_PARENTHESIS; }

"def"	{ return T_DEFINITION; }
"int"	{ return T_TYPE_INT; }
"real"	{ return T_TYPE_REAL; }
"bool"	{ return T_TYPE_BOOL; }

{digit}	{ yylval.string = strdup(yytext); return T_INT; }
{word}	{ yylval.string = strdup(yytext); return T_WORD; }

.		{ yyerror("Unknown token! %c\n", *yytext); } /* inform of any unknow character */

%%
void yyerror(const char *s, ...){
	va_list ap;
	va_start(ap, s);
	std::fprintf(stderr, "Line %d: error: ", yylineno);
	std::vfprintf(stderr,s,ap);
}
