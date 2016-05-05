#include "ast.h"
#include "symbolTable.h"
#include <typeinfo>

using namespace AST;

extern ST::SymbolTable symTab;

// class Integer
void Integer::printTree(){
	std::cout << value;
	return;
}

int Integer::computeTree(){
	return value;
}

// class BinOp
void BinOp::printTree(){
	left->printTree();
	switch(op){
		case plus:
			std::cout << " + ";
			//std::cout << "(soma "<< typeid(left).name() <<")";
		break;
		case minus: std:: cout << " - "; break;
		case times: std::cout << " * "; break;
		case divide: std::cout << " / "; break;
		case assign: std::cout << " := "; break;
	}
	right->printTree();
	return;
}

int BinOp::computeTree(){
	int value, lvalue, rvalue;
	lvalue = left->computeTree();
	rvalue = right->computeTree();
	switch(op){
		case plus: value = lvalue + rvalue; break;
		case minus: value = lvalue - rvalue; break;
		case times: value = lvalue * rvalue; break;
		case divide: value = lvalue / rvalue; break;
		case assign: Word* leftvar = dynamic_cast<Word*>(left);
					symTab.entryList[leftvar->word].value = rvalue;
					value = rvalue;
					break;
	}
	return value;
}

// class Block
void Block::printTree(){
	for (Node* line: lines) {
		line->printTree();
		std::cout << std::endl;
	}
}

int Block::computeTree(){
	int value;
	for (Node* line: lines) {
		value = line->computeTree();
		std::cout << "Computed "<< value << std::endl;
	}
	return 0;
}

// TODO: Variable class
void Word::printTree(){
	if ( next != NULL ){
		next->printTree();
		std::cout << ", ";
	}
	std::cout << word;
	return;
}

int Word::computeTree(){
	return symTab.entryList[word].value;
}
