/*
 *	Staff
 *	references: 
 *	 - llpilla/compiler_examples/allen (github)
 *	 - Aho, Alfred, et al - Compilers: principles, techniques, and tools - 2nd ed. 2007 Pearson Education
 *	 - Levine, John - Flex & Bison - Unix text processing tools - 2009 O'Reilly Media
 */
 #pragma once

#include <iostream>
#include <vector>

using namespace std;

extern void yyerrer(const char *s, ...);

namespace Type {

	/*
	 *	ebuneration for the possible types of varialbe
	 */
	enum Type { 
		integer, 
		real, 
		boolean
	};

	static Type lastType;
}

namespace Operation{

	/*
	 *	enumeration for the possible kinds of operation
	 */
	enum Operation { 
		plus, 
		minus, 
		times, 
		divide, 
		assign, 
		greater, 
		greater_equals, 
		smaller, 
		smaller_equals, 
		equals, 
		different, 
		not_op, 
		and_op, 
		or_op
	};
}
