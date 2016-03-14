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
	p_node():parent(NULL),next(NULL),content("fuck me silly"){}
	p_node(string str):parent(NULL),next(NULL),content(str){}

	void add_child(nptr n){
		child.push_back(n);
	}
	virtual void render();
	
	tree* parent;
	tree* next;
	
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
class expr_n: public p_node{
public:
	int mode;
	expr_n(nptr l,nptr r):{child.push_back(l);child.push_back(r);}
	expr_n(string c):content(c){}
};
class low_n: public p_node{
public:
	para_n(string c):content(c){}
	para_n(string t,string c):type(t),content(c){}
	virtual void print(){}
};


void go_tree(nptr curptr){
	if(curptr->child.size()==0){
		cout << curptr->content;
	}
	else
		for(int i=0;i<curptr->child.size();i++)
			go_tree(curptr->child[i]);
			

}
#endif
