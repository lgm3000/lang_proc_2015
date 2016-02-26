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
parameter_list	:parameter_sub{}|
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
		f_c inner{scope--;}

		;

f_c		:f_for'('expr ',' expr ',' expr')'|
		f_while'('expr')'
		;
f_for		: FOR	{cout << spaces(scope) << "SCOPE" << endl;scope++;};
f_if		: IF	{cout << spaces(scope) << "SCOPE" << endl;scope++;};
f_while		: WHILE	{cout << spaces(scope) << "SCOPE" << endl;scope++;};
f_else		: ELSE;

after		: f_else inner|;

inner		:'{' code '}'|
		line;

var		: type variable EOL {cout <<spaces(scope)<<"VARIABLE : "<< $2 << endl;}
		;
variable	: IDENTIFIER operator term{$$ = $1;}|IDENTIFIER{$$ = $1;};

expr		:term operator expr|
		term|
		;
term		:IDENTIFIER|CONSTANT;
operator	:SIZEOF|PLUSPLUS|MINUSMINUS|'&'|'*'|'+'|'-'|'~'|'!'|'/'|'%'|BITWISESHIFTLEFT|BITWISESHIFTRIGHT|'<'|'>'|LESSOREQUAL|GREATOREQUAL|EQUAL|NOTEQUAL|'^'|'|'|AND|OR|'='|MULTEQUAL|DIVEQUAL|MODEQUAL|PLUSEQUAL|MINUSEQUAL|BSLEQUAL|BSREQUAL|BANDEQUAL|BXOREQUAL|BOREQUAL
		;
id		: IDENTIFIER{cout << "FUNCTION : " << $1 << endl;scope++;}
		;
consumable	: RETURN expr EOL|type variable|EOL;
%%
string spaces(int num){
	stringstream ss;
	for(int i=0;i<num*4;i++) ss<< " ";	
	return ss.str();
}

int yyerror(const char* s){
	cout << "error";
    return 0;
}
int main(void) {
	yyparse();
	return 0;
}
