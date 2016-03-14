%{
#include <iostream>
#include <cstdlib>
#include <sstream>
#include "tree.h"
using namespace std;
int yylex();
int yyerror(const char* s);
int scope = 0;
nptr head;
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
program		: program dio{$1->add_child($2);}|
		dio{head = new head_n();head->add_child($1);}
		;
dio		:function{$$ = $1;}|line{$$ = $1;};

function	: func_def'{' in_scope '}'{
			$$ =$1;$$->add_child($3);scope--;}
		; 
func_def	: type func_name '(' parameter_list ')'{
			$$ = new func_n();$$->scope = scope;$$->type = $1;$$->content = $2;$$->add_child($3);}
		;
parameter_list	:parameter_sub{
			$$ = $1;}|
		{
			$$ = new para_n;
			}
		;
		
parameter_sub	: parameter_sub ',' type IDENTIFIER{
			$$ = $1;$1-> add_child(new low_n($3,$4));}|
		type IDENTIFIER {
			$$ = new para_n;$$ -> add_child(new low_n($2,$3));}
		;
type		: INT | VOID;

line		: var EOL{$$ = $1;}|IDENTIFIER eq_opr expr EOL{$$ = new expr_n(new expr_n($1),$3);};

in_scope	: line in_scope{
			$$ = $2;$2->add_child($1);
			}|
		{
			$$ = new isco_n();
			}
		;
flow		: f_if'('expr')' inner after{scope--;}|
		f_c inner{scope--;}

		;

f_c		:f_for'('expr ',' expr ',' expr')'|
		f_while'('expr')'
		;
f_for		: FOR{cout << spaces(scope) << "SCOPE" << endl;scope++;};
f_if		: IF{cout << spaces(scope) << "SCOPE" << endl;scope++;};
f_while		: WHILE{cout << spaces(scope) << "SCOPE" << endl;scope++;};
f_else		: ELSE;
after		: f_else inner|;

inner		:'{' in_scope '}'|
		line;

var		: type variables {$$ = $2; $2->type = $1;}
		;
variables	: variables ',' variable|{$$ = $1;$1->add_child($3);}
		variable{$$ = new vard_n;$$->add_child($1);}
		;
variable	: IDENTIFIER '=' expr{$$ = new low_n($1);}|
		IDENTIFIER{$$ = new low_n($1);}
		;
//expr for +-*/
expr		: term '+' expr{$$ = new expr_n($1,$3);$$ -> mode = 1;}|
		term '-' expr{$$ = new expr_n($1,$3);$$ -> mode = 2;}|
		term '*' expr{$$ = new expr_n($1,$3);$$ -> mode = 3;}|
		term '/' expr{$$ = new expr_n($1,$3);$$ -> mode = 4;}|
		term{$$ = $1;}|
		;
term		:IDENTIFIER{$$ = new expr_n($1);$$ -> type = "IDENTIFIER";}|
		CONSTANT   {$$ = new expr_n($1);$$ -> type = "CONSTANT";}|
		'('expr')' {$$ = $2;}
		;

operator	:SIZEOF|INDEX|PLUSPLUS|MINUSMINUS|'&'|'*'|'+'|'-'|'~'|'!'|'/'|'%'|BITWISESHIFTLEFT|BITWISESHIFTRIGHT|'<'|'>'|LESSOREQUAL|GREATOREQUAL|EQUAL|NOTEQUAL|'^'|'|'|AND|OR|'='|MULTEQUAL|DIVEQUAL|MODEQUAL|PLUSEQUAL|MINUSEQUAL|BSLEQUAL|BSREQUAL|BANDEQUAL|BXOREQUAL|BOREQUAL|','|'#'|JINGJING|';'|':'
		;
func_name	: IDENTIFIER{$$ = $1;scope++;}
		;
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
