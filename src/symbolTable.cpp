/*
 *	Symbol Table
 *	references: 
 *	 - llpilla/compiler_examples/allen (github)
 *	 - Aho, Alfred, et al - Compilers: principles, techniques, and tools - 2nd ed. 2007 Pearson Education
 *	 - Levine, John - Flex & Bison - Unix text processing tools - 2009 O'Reilly Media
 */
#include "symbolTable.h"

using namespace ST;

extern SymbolTable symTab;

AST::Node* SymbolTable::newVariable( std::string id, AST::Node* next, Type::Type type){
	if( checkId(id) ) yyerror("Variable redefinition! %s\n", id.c_str());
	else {
		Symbol entry(type, variable, 0, false);  // FIXME: gets  only integer?
		addSymbol( id, entry );
	}
	std::cout << "Variavel criada. tipo: " << type << endl;
	std::cout<<"["<<id<<"]= "<<symTab.entryList[id].value<<endl;

	return new AST::Word( id, type );
}

AST::Node* SymbolTable::assignVariable( std::string id ){
	if( !checkId(id) ) yyerror("Variable not defined yet! %s\n", id.c_str());
	entryList[id].initialized = true;
	// return new AST::Word( id, NULL );
	return 0;
}

AST::Node* SymbolTable::useVariable( std::string id ){
	if( !checkId(id) ) yyerror("Variable not defined yet! %s\n", id.c_str());
	if( !entryList[id].initialized ) yyerror("Variable not initialized yet! %s\n", id.c_str());
	// return new AST::Word( id, NULL );
	return 0;
}

