/*
 *	Abstract Syntax Tree (AST)
 *	references: 
 *	 - llpilla/compiler_examples/allen (github)
 *	 - Aho, Alfred, et al - Compilers: principles, techniques, and tools - 2nd ed. 2007 Pearson Education
 *	 - Levine, John - Flex & Bison - Unix text processing tools - 2009 O'Reilly Media
 */

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
 *	( <Node> (<OPERATION::Operation> <TYPE::Type>) <Node>)
 *	example: ( 2 (sum real) 3)
 */
void BinOp::printTree(){
	switch(op){
		case OPERATION::assign:
			if(left->size == NULL){
				std::cout << "Atribuicão de valor para ";
				left->printTree();
				std::cout << ": ";
				right->printTree();
			}
			else if(left->size != NULL){
				std::cout << "Atribuicão de valor para arranjo "<<  TYPE::maleName[type] << " ";
				left->printTree();
				std::cout << " {+indice: ";
				left->size->printTree();
				std::cout << "}:";
				right->printTree();
			}
			break;
		default:
			std::cout << "(";
			left->printTree();
			std::cout << " (" << OPERATION::name[op] << " ";
			if(OPERATION::maleGender[op]){
				std::cout<< TYPE::maleName[type] << ") ";	
			} else{
				std::cout<< TYPE::femaleName[type] << ") ";	
			}
			right->printTree();
			std::cout << ")";
			break;
	}
	return;
}

/*
 *	prints the unary operation in the following format
 *	((<OPERATION::Operation> <TYPE::Type>) <Node>)
 *	example: ((negation boolean) true)
 */
void UnOp::printTree(){
	switch(op){
		case OPERATION::parenthesis:
			std::cout << "(abre parenteses) ";
            node->printTree();
            std::cout << " (fecha parenteses)";
			break;
		default:
			std::cout << "(";
			std::cout << "(" << OPERATION::name[op] << " ";
			if(OPERATION::maleGender[op]){
				std::cout<< TYPE::maleName[type] << ") ";	
			} else{
				std::cout<< TYPE::femaleName[type] << ") ";	
			}
			node->printTree();
			std::cout << ")";
			break;
	}
	return;
}

/*
 *	prints the variable in the following format (using portuguese)
 *	variável <TYPE::Type> <std::string>
 *	exemple: variável boolean flag
 */
void Word::printTree(){
	if(size == NULL){
		// if(type==TYPE::integer && type==TYPE::real && type==TYPE::boolean){
		// 	std::cout << "variável " << TYPE::femaleName[type] << " " << word;
		// } 
		std::cout << "variável " << word;
	}
	else{
		std::cout << word;	
	}
	return;
}

/*
 *	prints the value in the following format (using portuguese)
 *	valor <TYPE::Type> <std::string>
 *	exemple: valor boolean TRUE
 */
 void Value::printTree(){
 	std::cout << "valor " << TYPE::maleName[type] << " " << value;
 	return;
 }

/*
 *	prints the value declaration in the following format (using portuguese)
 *	Declaracão de variável <TYPE::Type> <std::string>: <list of variables>
 *	exemple: Declaracão de variável <inteira>: <variable>
 */
 void VariableDeclaration::printTree(){
 	std::cout << "Declaracão de variável "<< TYPE::femaleName[type] << ": ";
 	for( auto var = variables.begin(); var != variables.end(); var ++){
 		std::cout << dynamic_cast<Word *>(*var)->word;
 		if(next(var) != variables.end())
 			std::cout << ", ";
 	}
 }

/*
 *	Method to make the coercion from integer to real when needed
 */
 Node* Node::coerce(Node* node){
 	if(this->needCoersion(this->type, node->type)){
 		type = TYPE::real;
 		return new AST::Coercion(this);
 	}
 	type = TYPE::integer;
 	return this;
 }

/*
 *	check if needs to make a coercion. If this->node is integer and the other is real return true.
 */
 bool Node::needCoersion(TYPE::Type a, TYPE::Type b){
 	return(a == TYPE::integer && b == TYPE::real);
 }

/*
 *	prints the array declaration in the following format (using portuguese)
 *	Declaracão de arranjo <TYPE::Type> de tamanho <std::string>: <std::string>
 *	exemple: Declaracão de arranjo <inteiro> de tamanho <10>: <arr>
 */
 void ArrayDeclaration::printTree(){
 	std::cout << "Declaracão de arranjo " << TYPE::maleName[type] << " de tamanho "<< size <<": ";
 	for( auto var = variables.begin(); var != variables.end(); var ++){
 		std::cout << dynamic_cast<Word *>(*var)->word;
 		if(next(var) != variables.end())
 			std::cout << ", ";
 	}
 }

/*
 *	prints the coercion to real when needed
 */
 void Coercion::printTree(){
 	node->printTree();
 	std::cout << " para real";
 }
