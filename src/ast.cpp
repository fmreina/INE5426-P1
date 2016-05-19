/*
 *	Abstract Syntax Tree (AST)
 *	references: 
 *	 - llpilla/compiler_examples/allen (github)
 *	 - Aho, Alfred, et al - Compilers: principles, techniques, and tools - 2nd ed. 2007 Pearson Education
 *	 - Levine, John - Flex & Bison - Unix text processing tools - 2009 O'Reilly Media
 */
#define PRINTER_H
#include "printer.h"

#include "ast.h"
#include "symbolTable.h"

using namespace AST;

extern ST::SymbolTable symTab;

/*
 *	prints each line stored in the list lines
 *	example:	line <break line>
 *				line <break line>
 *				line <break line>
 */
void Block::printTree(){
	for (Node* line: lines) {
		line->printTree();
		std::cout << std::endl;
	}
}

/*
 *	prints the binary operation in the following format
 *	( <Node> (<Operation::Operation> <Type::Type>) <Node>)
 *	example: ( 2 (sum real) 3)
 */
void BinOp::printTree(){
	std::cout << "(";
	left->printTree();
	std::cout << " (" << op << " " << type << ") ";
	right->printTree();
	std::cout << ")";
	return;
}

/*
 *	prints the unary operation in the following format
 *	((<Operation::Operation> <Type::Type>) <Node>)
 *	example: ((negation boolean) true)
 */
void UnOp::printTree(){
	std::cout << "(";
	std::cout << "(" << op << " " << type << ") ";
	node->printTree();
	std::cout << ")";
	return;
}

/*
 *	prints the variable in the following format (using portuguese)
 *	variável <Type::Type> <std::string>
 *	exemple: variável boolean flag
 */
void Word::printTree(){
	std::cout << "variável " << type << " " << word;
	return;
}

/*
 *	prints the value in the following format (using portuguese)
 *	valor <Type::Type> <std::string>
 *	exemple: valor boolean TRUE
 */
 void Value::printTree(){
 	std::cout << "valor " << type << " " << value;
 	return;
 }

/*
 *	prints the value in the following format (using portuguese)
 *	valor <Type::Type> <std::string>
 *	exemple: valor boolean TRUE
 */
 void VariableDeclaration::printTree(){
 	std::cout << "Declaracão de variável " << type << ": ";
 	for( auto var = variables.begin(); var != variables.end(); var ++){
 		std::cout << dynamic_cast<Word *>(*var)->word;
 		if(next(var) != variables.end())
 			std::cout << ", ";
 	}
 }