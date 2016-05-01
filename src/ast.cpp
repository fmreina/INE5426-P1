#include "ast.h"
//TODO: #include "st.h" // TODO: symbol table

using namespace AST;

//TODO: extern ST::SymbolTable symtab;

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
		case plus: std::cout << " + "; break;
		case times: std::cout << " * "; break;
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
		case times: value = lvalue * rvalue; break;
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
