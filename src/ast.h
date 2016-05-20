/*
 *	Abstract Syntax Tree (AST)
 *	references: 
 *	 - llpilla/compiler_examples/allen (github)
 *	 - Aho, Alfred, et al - Compilers: principles, techniques, and tools - 2nd ed. 2007 Pearson Education
 *	 - Levine, John - Flex & Bison - Unix text processing tools - 2009 O'Reilly Media
 */
#pragma once

#include <iostream>
#include <vector>
#include "staff.h"

using namespace std;

extern void yyerrer(const char *s, ...);
namespace AST {

	class Node;

	/*
	 *	List of ASTs
	 */
	typedef std::vector<Node*> NodeList;

	/*
	 *	@class Node to define a node of the syntax tree
	 *	@param Type::Type form the staff.h to indicate the type of the node ( integer, real, boolean )
	 *	@method printTree is used to print the tree	 @return void
	 */
	class Node {
		public:
			Type::Type type;
			virtual ~Node() { }
			Node (Type::Type type) : type(type) { }
			Node () { }
			virtual void printTree() { }
	};

	/*
	 *	@class Block to work with a block structure
	 *	@attribute NodeList (list of lines)
	 *	@param none
	 *	@method printTree  @return void
	 */
	class Block : public Node {
		public:
			NodeList lines;
			Block() { }
			void printTree();
	};

	/*
	 *	@class BinOp to work with binary operation ( +, *, =, ~=, ... )
	 *	@param Node, Operation::Operation, Node
	 *	@method printTree  @return void
	 */
	class BinOp : public Node {
		public:
			Operation::Operation op;
			Node *left;
			Node *right;
			BinOp(Node *left, Operation::Operation op, Node *right) : left(left), op(op), right(right) { }
			void printTree();
	};

	/*
	 *	@class UnOp to work with unary operation ( -, ~, := )
	 *	@param Operation::Operation, Node
	 *	@method printTree  @return void
	 */
	class UnOp : public Node {
		public:
			Operation::Operation op;
			Node *node;
			UnOp(Operation::Operation op, Node *node) : node(node), op(op) { }
			void printTree();
	};

	/*
	 *	@class Word to work with strings (declare variables)
	 *	@param std::string, Type::Type (type is assigned to the Node)
	 *	@method printTree  @return void
	 */
	class Word : public Node {
		public:
			std::string word;
			Type::Type type;
			Word(std::string word, Type::Type type) : word(word), type(type), Node(type) { }
			void printTree();
	};

	/*
	 *	@class Value to receive numerical values
	 *	@param std::string, Type::Type (type is assigned to the Node)
	 *	@method printTree  @return void
	 */
	class Value : public Node {
		public:
			std::string value;
			Type::Type type;
			Value(std::string value, Type::Type type) : value(value), type(type), Node(type) { }
			void printTree();
	};

	/*
	 *	@class VariableDeclaration to receive numerical values
	 *	@attribute NodeList (list of variables)
	 *	@param Type::Type (type is assigned to the Node)
	 *	@method printTree  @return void
	 */
	 class VariableDeclaration : public Node {
	 	public:
	 		Type::Type type;
	 		NodeList variables;
	 		VariableDeclaration (Type::Type type) : type(type), Node(type) { }
	 		void printTree();
	 };
}
