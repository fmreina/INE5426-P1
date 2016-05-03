%{
#include <string>
#include "ast.h"
#include "parser.h"

extern int yylineno;

void yyerror(const char* s, ...);

%}

%option noyywrap nodefault yylineno

digit[0-9]+
word[a-zA-Z]+

%%

[/t]	; // to ignore spaaces
\n		{ return T_NEW_LINE; }
"+"		{ return T_PLUS; }
"="		{ return T_ASSIGN; }

"def"	{ return T_DEFINITION; }

{digit}	{ yylval.integer = std::atoi(yytext); return T_INT; }
{word}	{ yylval.string = strdup(yytext); return T_WORD; }

.		{ yyerror("Unknown token! %c\n", *yytext); } /* inform of any unknow character */

%%
void yyerror(const char *s, ...){
	va_list ap;
	va_start(ap, s);
	std::fprintf(stderr, "Line %d: error: ", yylineno);
	std::vfprintf(stderr,s,ap);
}
