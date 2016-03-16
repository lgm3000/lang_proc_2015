%{
#include <iostream>
#include <cstdlib>
#include <sstream>
#include "tree.hpp"
using namespace std;
int yylex();
int yyerror(const char* s);
int scope = 0;
nptr head;
string spaces(int num);
%}
 
%union{
	char*	name;
	nptr	node;
}


%token AUTO BREAK CASE CHAR CONST CONTINUE DEFAULT DO DOUBLE ELSE ENUM EXTERN FLOAT FOR GOTO IF INT LONG REGISTER RETURN SHORT SIGNED STATIC STRUCT SWITCH TYPEDEF UNION UNSIGNED VOID VOLATILE WHILE SIZEOF INDEX POINTER PLUSPLUS MINUSMINUS BITWISESHIFTLEFT BITWISESHIFTRIGHT LESSOREQUAL GREATOREQUAL EQUAL NOTEQUAL AND OR MULTEQUAL DIVEQUAL MODEQUAL PLUSEQUAL MINUSEQUAL BSLEQUAL BSREQUAL BANDEQUAL BXOREQUAL BOREQUAL JINGJING EOL
%token IDENTIFIER CONSTANT STRINGLITERAL
%type<name> INT VOID '='
%type<name> IDENTIFIER CONSTANT func_name type eq_opr
%type<node> program dio function func_def parameter_list parameter_sub lines line in_scope var_def variables variable expr term assign_statement return_statement	
%start program
%%
program		: program dio{$1->add_child($2);}|
		dio{head = new head_n();head->add_child($1);}
		;
dio		:function{$$ = $1;}|line{$$ = $1;};

function	: func_def'{' in_scope '}'{
			$$ =$1;$$->right = $3;scope--;}
		; 
func_def	: type func_name '(' parameter_list ')'{
			$$ = new func_n();$$->type = $1;$$->content = $2;$$->left = $4;}
		;
parameter_list	:parameter_sub{
			$$ = $1;}|
		{
			$$ = new para_n;
			}
		;
		
parameter_sub	: parameter_sub ',' type IDENTIFIER{
			$$ = $1;$1-> add_child(new low_n("IDENTIFIER",$4));}|
		type IDENTIFIER {
			$$ = new para_n;$$->content = "parameters";$$ -> add_child(new low_n($1,$2	));}
		;
type		: INT {$$ = $1;}| VOID{$$ = $1;};

in_scope	: lines {
			$$=$1;
			}|
		{
			$$ = new isco_n();
			}
		;


line		: var_def EOL{$$ = $1;}|assign_statement EOL{$$ = $1;}|return_statement EOL{$$ = $1;}|flow{$$ = new line_n;};

lines		: lines line{
			$$ = $1;$1->add_child($2);
			}|
		line{
			$$ = new isco_n();$$->add_child($1);$$->content = "in_scope";};

assign_statement: IDENTIFIER eq_opr expr{$$ = new asgn_n($2);$$ ->left =new low_n("IDENTIFIER",$1);$$->right = $3;}|IDENTIFIER{$$ = new low_n("IDENTIFIER",$1);};

return_statement: RETURN expr{$$ = new retn_n();$$->add_child($2);$$->content = "Return";};

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

var_def		: type variables {$$ = $2; $2->type = $1;}
		;
variables	: variables ',' variable{$$ = $1;$1->add_child($3);}|
		variable{$$ = new vard_n;$$ ->content = "Variable Def";$$->add_child($1);}
		;
variable	: IDENTIFIER '=' expr{$$ = new asgn_n($2);$$->left = new low_n("IDENTIFIER",$1);$$->right = $3;}|
		IDENTIFIER{$$ = new low_n("IDENTIFIER",$1);}
		;
//expr for +-*/
expr		: term '+' expr{$$ = new addexpr_n($1,$3);}|
		term '-' expr{$$ = new subexpr_n($1,$3);}|
		term '*' expr{$$ = new multexpr_n($1,$3);}|
		term '/' expr{$$ = new divexpr_n($1,$3);}|
		term{$$ = $1;}
		;
term		:IDENTIFIER{$$ = new low_n("IDENTIFIER",$1);}|
		CONSTANT   {$$ = new low_n("CONSTANT",$1);}|
		'('expr')' {$$ = $2;}
		;

eq_opr		:'='{$$ = $1;};
//operator	:SIZEOF|INDEX|PLUSPLUS|MINUSMINUS|'&'|'*'|'+'|'-'|'~'|'!'|'/'|'%'|BITWISESHIFTLEFT|BITWISESHIFTRIGHT|'<'|'>'|LESSOREQUAL|GREATOREQUAL|EQUAL|NOTEQUAL|'^'|'|'|AND|OR|','|'#'|JINGJING|';'|':'|MULTEQUAL|DIVEQUAL|MODEQUAL|PLUSEQUAL|MINUSEQUAL|BSLEQUAL|BSREQUAL|BANDEQUAL|BXOREQUAL|BOREQUAL;
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

void go_tree(nptr curptr){
	if(curptr->child.size()>0){
		for(int i=0;i<curptr->child.size();i++)
			go_tree(curptr->child[i]);
	cout << curptr->content << endl;
	}
	else {
		if(curptr->left!=NULL)
			go_tree(curptr->left);
		cout << curptr->content<<endl;
		
		if(curptr->right!=NULL)
			go_tree(curptr->right);
	}
}

int main(void) {
	yyparse();
	head -> content = "Finish";
	head->lickdick(0);
	return 0;
}

void reassemble(nptr curptr){
	int i=0;
	while(i<curptr->child.size() && (curptr->child[i]->content != "Variable Def")) i++;
	if(i<curptr->child.size()){
		for(int j=0;j<curptr->child[i]->child.size();j++)
			if(curptr->child[i]->child[j]->type != "IDENTIFIER"){
				curptr->child.insert(curptr->child.begin()+i+1,curptr->child[i]->child[j]);
				curptr->child[i]->child[j] = curptr->child[i]->child[j]->left;
			}
		for(int j=i+1;j<curptr->child.size();j++)
			if(curptr->child[j]->content == "Variable Def"){
				for(int k=0;k<curptr->child[j]->child.size();k++)
					if(curptr->child[j]->child[k]->type == "IDENTIFIER")
						curptr->child[i]->add_child(curptr->child[j]->child[k]);
					else{
						curptr->child[i]->add_child(curptr->child[j]->child[k]->left);
						curptr->child.insert(curptr->child.begin()+j+1,curptr->child[j]->child[k]);
					}
				curptr->child.erase(curptr->child.begin()+j);
				}
	
	curptr->left = curptr->child[i];
		curptr->child.erase(curptr->child.begin()+i);
	}
	else{
		curptr->left = new vard_n;
		}
	curptr->right = new line_n;
	for(i=0;i<curptr->child.size();i++)
			curptr->right->add_child(curptr->child[i]);
	curptr->child.clear();
				
}

