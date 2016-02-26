%option noyywrap


%{
#include "tree.h"
#include "parser.tab.h"
%}

DIGIT			[0-9]
LETTER			[a-zA-Z_]


%%
["][^"]["]	{return(STRINGLITERAL);}
"auto"		{return(AUTO);}
"break"		{return(BREAK);}
"case"		{return(CASE);}
"char"		{return(CHAR);}
"const"		{return(CONST);}
"continue"	{return(CONTINUE);}
"default"	{return(DEFAULT);}
"do"		{return(DO);}
"double"	{return(DOUBLE);}
"else"		{return(ELSE);}
"enum"		{return(ENUM);}
"extern"	{return(EXTERN);}
"float"		{return(FLOAT);}
"for"		{return(FOR);}
"goto"		{return(GOTO);}
"if"		{return(IF);}
"int"		{return(INT);}
"long"		{return(LONG);}
"register"	{return(REGISTER);}
"return"	{return(RETURN);}
"short"		{return(SHORT);}
"signed"	{return(SIGNED);}
"static"	{return(STATIC);}
"struct"	{return(STRUCT);}
"switch"	{return(SWITCH);}
"typedef"	{return(TYPEDEF);}
"union"		{return(UNION);}
"unsigned"	{return(UNSIGNED);}
"void"		{return(VOID);}
"volatile"	{return(VOLATILE);}
"while"		{return(WHILE);}
"sizeof"	{return(SIZEOF);}

"{"		{return('{');}
"}"		{return('}');}
"[]"		{return(INDEX);}
"["		{return('[');}
"]"		{return(']');}
"("		{return('(');}
")"		{return(')');}
"."		{return('.');}
"->"		{return(POINTER);}
"++"		{return(PLUSPLUS);}
"--"		{return(MINUSMINUS);}
"<<"		{return(BITWISESHIFTLEFT);}
">>"		{return(BITWISESHIFTRIGHT);}
"<="		{return(LESSOREQUAL);}
">="		{return(GREATOREQUAL);}
"=="		{return(EQUAL);}
"!="		{return(NOTEQUAL);}
"&&"		{return(AND);}
"||"		{return(OR);}
"##"		{return(JINGJING);}
"*="		{return(MULTEQUAL);}
"/="		{return(DIVEQUAL);}
"%="		{return(MODEQUAL);}
"+="		{return(PLUSEQUAL);}
"-="		{return(MINUSEQUAL);}
"<<="		{return(BSLEQUAL);}
">>="		{return(BSREQUAL);}
"&="		{return(BANDEQUAL);}
"^="		{return(BXOREQUAL);}
"|="		{return(BOREQUAL);}
","		{return(',');}
"#"		{return('#');}
";"		{return(EOL);}
":"		{return(':');}
"&"		{return('&');}
"*"		{return('*');}
"+"		{return('+');}
"-"		{return('-');}
"~"		{return('~');}
"!"		{return('!');}
"/"		{return('/');}
"%"		{return('%');}
"="		{return('=');}
"^"		{return('^');}
"|"		{return('|');}
"<"		{return('<');}
">"		{return('>');}


{DIGIT}+	{return(CONSTANT);}
{LETTER}({LETTER}|{DIGIT})*	{yylval.name=strdup(yytext);return(IDENTIFIER);}

[ ]		{}
[\n]		{}
.		{}



%%
