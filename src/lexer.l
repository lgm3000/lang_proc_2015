%option noyywrap


%{
#include "tree.hpp"
#include "parser.tab.h"
%}

DIGIT			[0-9]
LETTER			[a-zA-Z_]


%%
["][^"]["]	{yylval.name=strdup(yytext);return(STRINGLITERAL);}
"auto"		{yylval.name=strdup(yytext);return(AUTO);}
"break"		{yylval.name=strdup(yytext);return(BREAK);}
"case"		{yylval.name=strdup(yytext);return(CASE);}
"char"		{yylval.name=strdup(yytext);return(CHAR);}
"const"		{yylval.name=strdup(yytext);return(CONST);}
"continue"	{yylval.name=strdup(yytext);return(CONTINUE);}
"default"	{yylval.name=strdup(yytext);return(DEFAULT);}
"do"		{yylval.name=strdup(yytext);return(DO);}
"double"	{yylval.name=strdup(yytext);return(DOUBLE);}
"else"		{yylval.name=strdup(yytext);return(ELSE);}
"enum"		{yylval.name=strdup(yytext);return(ENUM);}
"extern"	{yylval.name=strdup(yytext);return(EXTERN);}
"float"		{yylval.name=strdup(yytext);return(FLOAT);}
"for"		{yylval.name=strdup(yytext);return(FOR);}
"goto"		{yylval.name=strdup(yytext);return(GOTO);}
"if"		{yylval.name=strdup(yytext);return(IF);}
"int"		{yylval.name=strdup(yytext);return(INT);}
"long"		{yylval.name=strdup(yytext);return(LONG);}
"register"	{yylval.name=strdup(yytext);return(REGISTER);}
"return"	{return(RETURN);}
"short"		{return(SHORT);}
"signed"	{return(SIGNED);}
"static"	{return(STATIC);}
"struct"	{return(STRUCT);}
"switch"	{return(SWITCH);}
"typedef"	{return(TYPEDEF);}
"union"		{return(UNION);}
"unsigned"	{return(UNSIGNED);}
"void"		{yylval.name=strdup(yytext);return(VOID);}
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
"*="		{yylval.name=strdup(yytext);return(MULTEQUAL);}
"/="		{yylval.name=strdup(yytext);return(DIVEQUAL);}
"%="		{yylval.name=strdup(yytext);return(MODEQUAL);}
"+="		{yylval.name=strdup(yytext);return(PLUSEQUAL);}
"-="		{yylval.name=strdup(yytext);return(MINUSEQUAL);}
"<<="		{yylval.name=strdup(yytext);return(BSLEQUAL);}
">>="		{yylval.name=strdup(yytext);return(BSREQUAL);}
"&="		{yylval.name=strdup(yytext);return(BANDEQUAL);}
"^="		{yylval.name=strdup(yytext);return(BXOREQUAL);}
"|="		{yylval.name=strdup(yytext);return(BOREQUAL);}
","		{return(',');}
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
"="		{yylval.name=strdup(yytext);return('=');}
"^"		{return('^');}
"|"		{return('|');}
"<"		{return('<');}
">"		{return('>');}
"#".*		{}
"//".*  {}


{DIGIT}+	{yylval.name=strdup(yytext);return(CONSTANT);}
{LETTER}({LETTER}|{DIGIT})*	{yylval.name=strdup(yytext);return(IDENTIFIER);}

[ ]		{}
[\n]		{}
.		{}



%%
