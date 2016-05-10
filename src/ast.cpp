#define PRINTER_H
#include "printer.h"

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
		case plus: std::cout << " + ";	/*std::cout << "(soma "<< typeid(left).name() <<")";*/ break;
		case minus: std:: cout << " - "; break;
		case times: std::cout << " * "; break;
		case divide: std::cout << " / "; break;
		case assign: std::cout << " := "; break;
		case greater: std::cout << " > "; break;
		case greater_equals: std::cout << " >= "; break;
		case smaller: std::cout << " < "; break;
		case smaller_equals: std::cout << " <= "; break;
		case equals: std::cout << " = "; break;
		case different: std::cout << " ~= "; break;
		case not_op: std::cout << " ~ "; break;
		case and_op: std::cout << " AND "; break;
		case or_op: std::cout << " OR "; break;
	}
	right->printTree();
	return;
}

int BinOp::computeTree(){
	int value, lvalue, rvalue;
	lvalue = left->computeTree();
	rvalue = right->computeTree();
	debug("Debug test");
	switch(op){
		case plus: { printOp(lvalue, "", "soma", "inteira", rvalue, "inteiro");
						value = lvalue + rvalue; } break;
		case minus: { std::cout<< "(valor "<< "<tipo> " << lvalue <<"(subtracão" << "<tipo>" << ") " << "valor "<< "<tipo>)"<< rvalue <<endl;
						value = lvalue - rvalue; } break;
		case times: { std::cout<< "(valor "<< "<tipo> " << lvalue <<"(multiplicacão" << "<tipo>" << ") " << "valor "<< "<tipo>)"<< rvalue <<endl;
						value = lvalue * rvalue; } break;
		case divide: { std::cout<< "(valor "<< "<tipo> " << lvalue <<"(divisão" << "<tipo>" << ") " << "valor "<< "<tipo>)"<< rvalue <<endl;
						value = lvalue / rvalue; } break;
		case assign: { std::cout<< "((atribuicão" << "<tipo>" << ") " << "valor "<< "<tipo>)"<< rvalue<< endl;
					Word* leftvar = dynamic_cast<Word*>(left);
					symTab.entryList[leftvar->word].value = rvalue;
					value = rvalue;
					} break;
		case greater: { std::cout<< "(valor "<< "<tipo> " << lvalue <<"(maior" << "<tipo>" << ") " << "valor "<< "<tipo>)"<< rvalue <<endl;
						value = (lvalue > rvalue)? 1 : -1 ; } break;
		case greater_equals: { std::cout<< "(valor "<< "<tipo> " << lvalue <<"(maior igual" << "<tipo>" << ") " << "valor "<< "<tipo>)"<< rvalue <<endl;
								value = (lvalue >= rvalue)? 1 : -1 ; } break;
		case smaller: { std::cout<< "(valor "<< "<tipo> " << lvalue <<"(menor" << "<tipo>" << ") " << "valor "<< "<tipo>)"<< rvalue <<endl;
						value = (lvalue < rvalue)? 1 : -1 ; } break;
		case smaller_equals: { std::cout<< "(valor "<< "<tipo> " << lvalue <<"(menor igual" << "<tipo>" << ") " << "valor "<< "<tipo>)"<< rvalue <<endl;
								value = (lvalue <= rvalue)? 1 : -1 ; } break;
		case equals: { std::cout<< "(valor "<< "<tipo> " << lvalue <<"(igualdade" << "<tipo>" << ") " << "valor "<< "<tipo>)"<< rvalue <<endl;
						value = (lvalue == rvalue)? 1 : -1 ; } break;
		case different: { std::cout<< "(valor "<< "<tipo> " << lvalue <<"(diferenca" << "<tipo>" << ") " << "valor "<< "<tipo>)"<< rvalue <<endl;
							value = (lvalue != rvalue)? 1 : -1 ; } break;
		case not_op: { std::cout<< "not_op" << endl; } break;
		case and_op: { std::cout<< "and_op" << endl; } break;
		case or_op: { std::cout<< "or_op" << endl; } break;	
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

// class Word
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
