%{
#include <iostream>
#include <cstdlib>

int yylex();
int yyerror(const char* s);
%}
 
%union{
	string name;
	nptr   node
}


%token CHAR DOUBLE FLOAT INT VOID
%token IDENTIFIER CONSTANT STRINGLITERAL
%%
program		:functions
		;
		
functions	:functions function
		|function
		;
		
function	:function_call '{' code '}'
		;
		
function_dec	:declaration identifier '(' parameter_def ')'
		;

parameter_def	:parameter_def_sub
		|
		;
parameter_def_sub: parameter_def_sub',' type id
		|type id
		;
		
type		:INT			 
		;
				
id		:IDENTIFIER
		|CONSTANT
		;
declaration	:INT|
		VOID|
		CHAR
		;
%%

int yyerror(const char* s){ 
    std::cout << s << std::endl;
    return -1;
}

int main(void) {
  yyparse();
}
