#ifndef TREE_HPP
#define TREE_HPP

#include<vector>
#include<string>
#include<iostream>
using namespace std;
class p_node;

typedef p_node* nptr;

class p_node{
public:
	p_node():content("fuck me silly"){}
	p_node(string str):content(str){}

	void add_child(nptr n){
		child.push_back(n);
	}
	nptr left = NULL;
	nptr right =NULL;
	vector<nptr> child;
	string type;
	string content;

};


class head_n: public p_node{


};

class func_n: public p_node{
public:
	int scope;

};

class para_n: public p_node{
public:
	
};

class isco_n: public p_node{
public:

};

class vard_n: public p_node{
public:

};
class lins_n: public p_node{
public:

};
class line_n: public p_node{
public:

};
class asgn_n: public p_node{
public:
	asgn_n(string c){content = c;}
};
class expr_n: public p_node{
public:
	expr_n(nptr l,nptr r){left = l;right = r;}
	expr_n(string c){content = c;}
};

class low_n: public p_node{
public:
	low_n(string c){content = c;}
	low_n(string t,string c){type = t;content = c;}
};



#endif
