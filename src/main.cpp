#include <iostream>
#include "ast.h"

extern AST::Block* programRoot; // set on bison file
extern int yyparse();

int main (int argc, char **argv){
	yyparse();					// parses the data
	programRoot->printTree();	// prints the AST
	programRoot->computeTree();	// computes the AST
	return 0;
}
