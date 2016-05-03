#pragma once

#include <iostream>
#include <vector>

using namespace std;

extern void yyerrer(const char *s, ...);
namespace AST {

	// Binary operations
	enum Operation { plus, times, assign};

	class Node;

	// List of ASTs
	typedef std::vector<Node*> NodeList;

	class Node {
		public:
			virtual ~Node() {}
			virtual void printTree(){}
			virtual int computeTree(){return 0;}
	};

	class Integer : public Node{
		public:
			int value; // variable
			Integer(int value) : value(value) { } // constructor @param: value is setted to this value
			void printTree();
			int computeTree();
	};

	class BinOp : public Node {
		public:
			Operation op;
			Node *left;
			Node *right;
			BinOp(Node *left, Operation op, Node *right) : left(left), op(op), right(right) { }
			void printTree();
			int computeTree();
	};

	// TODO: must complete the block declaration?
	class Block : public Node {
		public:
			NodeList lines;
			Block() { }
			// Block(NodeList lines) : lines(lines) { }
			void printTree();
			int computeTree();
	};

	class Word : public Node {
		public:
			std::string word;
			Node* next;
			Word(std::string word, Node* next) : word(word), next(next) { }
			void printTree();
			int computeTree();
		};
}
