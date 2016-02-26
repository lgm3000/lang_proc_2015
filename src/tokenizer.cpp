/*
yw11614 Imperial College
2016-feb-12
	tokenizer not based on flex
*/
/*
#include<iostream>
#include<fstream>
#include<map>
#include<string>
#include<vector>
#include<algorithm>
#include<cstdlib>

using namespace std;

static map<string,string> tk;
static map<string,string> tkclass;
static string file_n;
static char punct[]={'+','-','*','/','&','|','!','=','<','>'};
static char punct_[]={'^','~','.',';',':',','};

class _cline {
public:
	_cline(string ln);
	const int tok_num();
	const string token(const int& i);
	const string _wholeline();
	const int is_empty();
	const string filename();
private:
	const int islet(const char& c);
	const int isnum(const char& c);
	const int is_(const char& c);
	const int is_punct(const char& c);
	const int is_punct_(const char& c);
	const int isbracket(const char& c);
	const int isstr(const char& c);
	const int ischar(const char& c);
	const int isbkslash(const char& c);
	vector<string> tok;
	string whole_line;
	string file;
	
};

void existinmap(const string& str,const string& tclass,const string& type);
//string removespaces(string input);
void load_token_data();

int main()
{
// initialising token map,loading
// all known operators and keywords into map<str,str>,with
// the name of token as key, token class as value
// merits: ez traverse through tokens; ez change token class; ez make tokentype unique etc.
// currently tokentype is the token itself. can be modified by using a struct as value

	load_token_data();

	//stripping out filename from first line
	string tmpln;
	vector<_cline> line;
	//input file into vector line
	getline(cin,tmpln);
	int i=0;
	while(cin)
	{
		//string nsline = removeSpaces(tmpln);
		line.push_back(_cline(tmpln));
		getline(cin,tmpln);
	}


	//prints elements (and their attributes) from vector<> line

	for(int i=0;i<line.size();i++)
	{
		if(!line[i].is_empty())
			for(int j=0;j<line[i].tok_num();j++)
			{
				cout.width(10);cout << left << line[i].token(j);
				cout.width(15);cout << left << tkclass[line[i].token(j)];
				cout.width(20);cout << left << tk[line[i].token(j)];
				cout.width(5);cout << left << i+1;
				cout.width(12);cout << left << line[i].filename();
				cout << line[i]._wholeline() << endl;
				cout << endl;
			}
	}

	return 0;
	
}


//removes spaces fom input;

// checks whether the token inputed is existent or not: if not, check its class: identifier, constant or stringliteral 
// (or invalid:P)

void existinmap(const string& str,const string& tclass,const string& type){
	map<string,string>::iterator it = tk.find(str);
	if(it == tk.end()){
		tkclass[str] = tclass;
		tk[str]      = type;		
		}
}


//loads tokens and their classes into map<> tk
void load_token_data(){
	ifstream fin;
	fin.open("token.txt");
	if(!fin.is_open()){
		cout << "Failed to load default tokens";
		exit(EXIT_FAILURE);
	}
	string tmp,tmptype;
	for(int i=0;i<32;i++){fin >> tmp >> tmptype; tk[tmp] = tmptype; tkclass[tmp] = "Keyword";}
	for(int i=32;i<80;i++){fin >> tmp >> tmptype; tk[tmp] = tmptype; tkclass[tmp] = "Operator";}

}

//constructor: a lexer that takes in line as string and generates a vector containing all tokens identified
_cline::_cline(string ln): whole_line(ln)
{
	file = file_n;
	int i=0,j=1;
	while(j<=ln.size())
	{
		if(islet(ln[i])||is_(ln[i]))
		{
			while((isnum(ln[j])||islet(ln[j])||is_(ln[j]))&&j<ln.size())j++;
			tok.push_back(ln.substr(i,j-i));
			existinmap(ln.substr(i,j-i),"Identifier","IDENTIFIER");
			i=j++;			
		}
		else
		if(isnum(ln[i]))
		{
			while(isnum(ln[j])&&j<ln.size())j++;
			if(ln[j]=='.'&&isnum(ln[j+1]))
			{
				j++;
				while(isnum(ln[j])&&j<ln.size())j++;
			}
			if(islet(ln[j])||is_(ln[i]))
			{
				while((isnum(ln[j])||islet(ln[j])||is_(ln[j]))&&j<ln.size())j++;
				tok.push_back(ln.substr(i,j-i));
				existinmap(ln.substr(i,j-i),"Invalid","Invalid");
				i=j++;		
			}
			else
			{
				tok.push_back(ln.substr(i,j-i));
				existinmap(ln.substr(i,j-i),"Constant","NUMERICALCONSTANT");
				i=j++;
			}
		}
		else
		if(is_punct_(ln[i]))
		{
			if(ln[i] == '/' && ln[i+1] == '/') j+=ln.size();
			else{		
				tok.push_back(ln.substr(i,1));
				i=j++;			
			}
		}
		else
		if(is_punct(ln[i]))
		{
			while(is_punct(ln[j])&&j<ln.size())j++;
			tok.push_back(ln.substr(i,j-i));
			existinmap(ln.substr(i,j-i),"Invalid","Invalid");
			i=j++;
		}
		else
			//more modifications should be done here, mb implementing bracket checks or sth
		if(isbracket(ln[i]))
		{
			tok.push_back(ln.substr(i,1));		
			i = j++;		
		}
		else
		if(isstr(ln[i]))
		{
			while((!isstr(ln[j]))&&j<ln.size())j++;
			if(j<ln.size())j++;
			tok.push_back(ln.substr(i,j-i));
			existinmap(ln.substr(i,j-i),"StringLiteral","STRINGLITERAL");
			i=j++;			
		}
		else
		if(ischar(ln[i]))
		{
			while((!ischar(ln[j]))&&j<ln.size())j++;
			j++;
			tok.push_back(ln.substr(i,j-i));
			existinmap(ln.substr(i,j-i),"Constant","CHARACTERCONSTANT");
			i=j++;			
		}
		else
		if(isbkslash(ln[i]))
		{
			tok.push_back(ln.substr(j,1));
			existinmap(ln.substr(j,1),"Constant","CHARACTERCONSTANT");
			i=j++;
			i=j++;			
		}
		else
		if(ln[i]=='#')
		{/*
			if(i==0 && isnum(ln[2]) && isnum(ln[ln.size()-1]){
				j = 5;
				while(ln[j]!=' ')j++;
				j++;
				while(j<=ln.size()){
					if(ln[j]=='1'||ln[j]=='2') file_n = ln.substr(5,j-6);
					j+=2;
				}
				
			}*//*
			j+=ln.size();
		}
		else
		{
			i++;j++;
		}
								
	}
}
const int _cline::islet(const char& c){
	if (((c <= 'z') && (c >= 'a')) || ((c <= 'Z') && (c >= 'A')))
		return 1;
	else
		return 0;
}
const int _cline::isnum(const char& c){
	if (((c >= '0') && (c <= '9')))
		return 1;
	else
		return 0;
}
const int _cline::is_(const char& c){
	if (c == '_')
		return 1;
	else
		return 0;
}
const int _cline::is_punct_(const char& c){
	for(int i=0;i< 6;i++)
		if(c == punct_[i]) return 1;
	return 0;
}
const int _cline::is_punct(const char& c){
	for(int i=0;i<11;i++)
		if(c == punct[i]) return 1;
	return 0;
}
const int _cline::isbracket(const char& c){
	if (c == '('|| c == ')'||c == '['|| c == ']'||c == '{'|| c == '}')
		return 1;
	else
		return 0;
}
const int _cline::isstr(const char& c){
	if (c == '"')
		return 1;
	else
		return 0;
}
const int _cline::ischar(const char& c){
	if (c == '\'')
		return 1;
	else
		return 0;
}
const int _cline::isbkslash(const char& c){
	if (c == '\\')
		return 1;
	else
		return 0;
}
const int _cline::is_empty(){
	if(tok.size()==0)return 1;
	return 0;
}

// returning token number
const int _cline::tok_num(){
	return tok.size();
}
// returning the respective token indexed by i
const string _cline::token(const int& i){
	return tok[i];
}
//literally returning the whole line :)
const string _cline::_wholeline(){
	return whole_line;
}
//returning filename
const string _cline::filename(){
	return file;
}
