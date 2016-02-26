%code requires{
#include <stdio.h>
#include <iostream>



int yylex(void);
void yyerror(const char *);
struct strc{
	char *deal_str;
	struct strc *next;
};
}


%union{
int number;
char *str;
struct strc *node;

}

%token COMMA LCURLY RCURLY SEMICN  EQUOP LBKT RBKT

%token <str> STRING
%token <str> ID
%token <str> RETURN
%token <str> IF
%token <str> WHILE
%token <str> ELSE
%token <str> FOR
%token <str> ADDOP
%token <str> MUNISOP
%token <str> MULTIOP
%token <str> DIVOP
%token <str> DEQUOP
%token <str> GT
%token <str> LT
%token <str> GE
%token <str> LE
%token <str> DATA_TYPE
%token <str> ANY_STRING
%token <str> SCO
%token <number> NUM
%type <str> PARA_list
%type <str> STATEMENT_list
%type <str> ARITHMETIC
%type <str> FUN_BODY
%type <str> FUN_BODY_LIST
%type <str> CONDITION
%type <str> EXPR
%type <str> FACTOR
%type <node> FUN START
%start START

%{struct strc *root=0;
%}

%%
START : FUN {root=$1;};

FUN : DATA_TYPE STRING LBKT RBKT LCURLY RCURLY { std::cout <<"FUNCTION : "<<$2<<std::endl;}
    | DATA_TYPE STRING {std::cout <<"SCOPE\n"<<"    VARIABLE : "<<$2<<std::endl;}
    | DATA_TYPE STRING LBKT PARA_list RBKT LCURLY FUN_BODY_LIST RCURLY{ std::cout <<"FUNCTION : "<<$2<<"\n"<<std::endl; root = $7; $$->next =$7;};

PARA_list : PARA_list COMMA DATA_TYPE STRING 
          | DATA_TYPE STRING {std::cout<<"    PARAMETER : "<<$2<<std::endl; };

FUN_BODY_LIST: FUN_BODY_LIST FUN_BODY {$1 ->next($2); $$=$1;}
|FUN_BODY {$$->next($1);};

FUN_BODY :  IF LBKT CONDITION RBKT LCURLY STATEMENT_list RCURLY{if($3 == 1){$$->next == $6;};}
| ELSE LCURLY STATEMENT_list RCURLY{$$->next($3);}
| WHILE LBKT CONDITION RBKT LCURLY STATEMENT_list RCURLY{if($3 == 1){$$->next == $6;};}
| FOR LBKT CONDITION RBKT LCURLY STATEMENT_list RCURLY {if($3 == 1){$$->next == $6;};}
| STATEMENT_list {$$ = $1;}
;


CONDITION: ID DEQUOP EXPR {if($1==$3){return 1}; else {return false;} ;}
| ID GT EXPR {if($1>$3){return 1;} else {return 0;};}
| ID LT EXPR {if($1<$3){return 1;} else {return 0;};}
| ID GE EXPR {if($1>=$3){return 1;} else {return 0;}; }
| ID LE EXPR {if($1<=$3){return 1;} else {return 0;}; }
;

STATEMENT_list : STATEMENT_list ARITHMETIC {$1->next($2); $$ = $1; }
| ARITHMETIC {$$->next($1);}


ARITHMETIC: DATA_TYPE STRING SEMICN  {std::cout <<"SCOPE\n"<<"    VARIABLE : "<<$2<<std::endl;}
| DATA_TYPE STRING EQUOP EXPR SEMICN { std::cout <<"SCOPE\n"<<"    VARIABLE : "<<$2<<std::endl;$$->next($4); }
| RETURN STRING
;

EXPR: EXPR ADDOP EXPR { $$ = $1 +$3;}
| EXPR MUNISOP EXPR { $$ = $1 - $3;}
| EXPR MULTIOP EXPR { $$ = $1 * $3;}
| EXPR DIVOP EXPR { $$ = $1 / $3;}
| FACTOR {$$->next($1);}
;

FACTOR: LBKT EXPR RBKT { $$->next = $2; }
| NUM { $$ =$1;}
| STRING {$$ =$1; }
;

%%
