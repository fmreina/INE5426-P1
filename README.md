# INE5426 - Compilers Construction - INE/UFSC - Project 1

This is a project for the class **INE5426 - Compilers Construction**.
The objective is to begin building a compiler for a version of the Allen language using FLEX&BISON/C++.

* After calling the make file it will create a runnable "run". Call ./run to execute

####Files:
* ast.cpp & ast.h: C++ Abstract Syntax Tree definitions and methods
* parser.y: Bison parser
* scanner.l: Flex scanner
* main.cpp: C++ main file
* Makefile: call make to compile
* others: auxiliar

####References:
- All the work makes reference to the following
* [llpilla](https://github.com/llpilla/compiler_examples/tree/master/allen) - Allen @github

* Aho, Alfred, et al - **Compilers: principles, techniques, and tools** - 2nd ed. 2007 Pearson Education

* Levine, John - **Flex & Bison - Unix text processing tools** - 2009 O'Reilly Media

* [Debugging Lex, Yacc, etc.](http://www.cs.man.ac.uk/~pjj/cs212/debug.html)
