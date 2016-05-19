/*
 *	Symbol Table
 *	references: 
 *	 - llpilla/compiler_examples/allen (github)
 *	 - Aho, Alfred, et al - Compilers: principles, techniques, and tools - 2nd ed. 2007 Pearson Education
 *	 - Levine, John - Flex & Bison - Unix text processing tools - 2009 O'Reilly Media
 */
#pragma once

#include <map>
#include "ast.h"
#include "staff.h"

extern void yyerror(const char* s, ...);

namespace ST {
	class Symbol;

	// enum Type { integer, real, boolean };
	enum Kind { variable };

	typedef std::map<std::string, Symbol> SymbolList; // set of symbols

	class Symbol {
		public:
			Type::Type type;
			Kind kind;
			bool initialized;
			Symbol( Type::Type type, Kind kind, bool initialized ) : type(type), kind(kind), initialized(initialized) { }
			Symbol( ) {type = Type::integer; kind = variable; initialized = false; }
	};

	class SymbolTable {
		public:
			SymbolList entryList;
			SymbolTable(){}
			bool checkId( std::string id ) { return entryList.find(id) != entryList.end(); } // @return true if variable was defined
			void addSymbol(std::string id, Symbol newSymbol) { entryList[id] = newSymbol; }
			// AST::Node* newVariable( std::string id, AST::Node* next);
			AST::Node* newVariable( std::string id, Type::Type type);
			AST::Node* assignVariable(std::string id);
			AST::Node* useVariable(std::string id);
	};
}
