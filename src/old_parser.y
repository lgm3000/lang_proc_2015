/*


Lite Version of Bison Parser: Specified for assessment2
Imperial College
Yiming Wang

*/
%{
#include <iostream>
#include <cstdlib>
#include <sstream>
using namespace std;
int yylex();
int yyerror(const char* s);
int scope = 0;
string spaces(int num);
%}
 
%union{
	char*	name;
}


%token AUTO BREAK CASE CHAR CONST CONTINUE DEFAULT DO DOUBLE ELSE ENUM EXTERN FLOAT FOR GOTO IF INT LONG REGISTER RETURN SHORT SIGNED STATIC STRUCT SWITCH TYPEDEF UNION UNSIGNED VOID VOLATILE WHILE SIZEOF INDEX POINTER PLUSPLUS MINUSMINUS BITWISESHIFTLEFT BITWISESHIFTRIGHT LESSOREQUAL GREATOREQUAL EQUAL NOTEQUAL AND OR MULTEQUAL DIVEQUAL MODEQUAL PLUSEQUAL MINUSEQUAL BSLEQUAL BSREQUAL BANDEQUAL BXOREQUAL BOREQUAL JINGJING EOL
%token IDENTIFIER CONSTANT STRINGLITERAL
%type<name> IDENTIFIER id variable	
%start program
%%
program		: program dio{}|
		dio{}
		;
dio		:function|line;

function	: func_def'{' code '}'{scope--;}
		; 
func_def	: type id '(' parameter_list ')'{scope--;cout << spaces(scope) << "SCOPE" << endl;scope++;}
		;
parameter_list	:parameter_sub|
		;
parameter_sub	: parameter_sub ',' type IDENTIFIER{cout << spaces(scope) <<"PARAMETER : "<< $4 << endl;}|
		type IDENTIFIER {cout << spaces(scope) <<"PARAMETER : "<< $2 << endl;}
		;
type		: INT | VOID;

line		: var|expr EOL|flow|consumable;

code		: line code|
		line|
		;
flow		: f_if'('expr')' inner after{scope--;}|
		f_do inner WHILE '('expr')' EOL{scope--;}|
		f_c inner{scope--;}
		;

f_c		:f_for'('expr ',' expr ',' expr')'|
		f_while'('expr')'
		;
f_for		: FOR	;
f_if		: IF	;
f_else		: ELSE ;
f_do		: DO	;
f_while		: WHILE	;
after		: f_else inner|;

inner		:scoping code '}'|
		line;
// For printing out the SCOPE
scoping		:'{'{cout << spaces(scope) << "SCOPE" << endl;scope++;};
var		: type variable_list EOL 
		;
variable_list	: variable_list ',' variable {cout <<spaces(scope)<<"VARIABLE : "<< $3 << endl;}|
		variable {cout <<spaces(scope)<<"VARIABLE : "<< $1 << endl;}
		;
variable	: IDENTIFIER '=' expr{$$ = $1;}|IDENTIFIER{$$ = $1;}
		;
expr		:term oper expr|
		term|
		;
term		:IDENTIFIER|CONSTANT|STRINGLITERAL;
oper		:SIZEOF|PLUSPLUS|MINUSMINUS|'&'|'*'|'+'|'-'|'~'|'!'|'/'|'%'|BITWISESHIFTLEFT|BITWISESHIFTRIGHT|'<'|'>'|LESSOREQUAL|GREATOREQUAL|EQUAL|NOTEQUAL|'^'|'|'|AND|OR|'='|MULTEQUAL|DIVEQUAL|MODEQUAL|PLUSEQUAL|MINUSEQUAL|BSLEQUAL|BSREQUAL|BANDEQUAL|BXOREQUAL|BOREQUAL
		;
id		: IDENTIFIER{cout << "FUNCTION : " << $1 << endl;scope++;}
		;
consumable	: RETURN expr EOL;
%%
string spaces(int num){
	stringstream ss;
	for(int i=0;i<num*4;i++) ss<< " ";	
	return ss.str();
}

int yyerror(const char* s){
	cout << "Error: " << s;
    return 0;
}
int main(void) {
	yyparse();
	return 0;
}
