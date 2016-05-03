#include "symbolTable.h"

using namespace ST;

extern SymbolTable symTab;

AST::Node* SymbolTable::newVariable( std::string id, AST::Node* next){
	if( checkId(id) ) yyerror("Variable redefinition! %s\n", id.c_str());
	else {
		Symbol entry(integer, variable, 0, false);  // FIXME: gets  only integer?
		addSymbol( id, entry );
	}
	return new AST::Word( id, next );
}

AST::Node* SymbolTable::assignVariable( std::string id ){
	if( !checkId(id) ) yyerror("Variable not defined yet! %s\n", id.c_str());
	entryList[id].initialized = true;
	return new AST::Word( id, NULL );
}

AST::Node* SymbolTable::useVariable( std::string id ){
	if( !checkId(id) ) yyerror("Variable not defined yet! %s\n", id.c_str());
	if( !entryList[id].initialized ) yyerror("Variable not initialized yet! %s\n", id.c_str());
	return new AST::Word( id, NULL );
}

