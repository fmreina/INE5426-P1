#pragma once

#include <iostream>

using namespace std;

#define DEBUG false

void debug(std::string msg) {
	if(DEBUG)
		std::cout << msg << endl;
}

void printOp(int lvalue, std::string ltype, std::string op,
			std::string optype, int rvalue, std::string rtype){
	std::cout <<
	"(valor "<< ltype << " " << lvalue <<" (" << op << " " << optype 
	<< ") "	<< "valor "<< rtype << " " << rvalue << ")"<<endl;
}