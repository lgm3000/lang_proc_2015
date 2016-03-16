#ifndef TREE_HPP
#define TREE_HPP

#define T <<"\t"<< 
#define fliptt tt=0:1?1:0
#include<vector>
#include<string>
#include<iostream>
#include<map>
using namespace std;
class p_node;
static map<string,int> variable;
static int tt;
typedef p_node* nptr;

void reassemble(nptr curptr);
class p_node{
public:
	p_node():content("fuck me silly"),type("LOL"){}
	p_node(string c){content = c;}
	p_node(string t,string c){type = t;content = c;}
	p_node(nptr l,nptr r){left = l;right = r;}

	void add_child(nptr n){
		child.push_back(n);
	}
	virtual void lickdick(const int& allocate) = 0;
	nptr left = NULL;
	nptr right =NULL;
	vector<nptr> child;
	string type;
	string content;
};


class head_n: public p_node{
	void lickdick(const int& allocate){
		for(int i=0;i<child.size();i++)
			child[i]->lickdick(0);
	}

};

class func_n: public p_node{
public:

	void lickdick(const int& allocate){
		reassemble(right);
		int allocat = 0;
		cout T "globl" T content << endl;
		cout T ".ent" T content << endl;
		cout T ".type" T content << ", @function" << endl;
		cout << content << ":" << endl;
		if(right != NULL)		
			if(right->left!=NULL)
				allocat = (right->left->child.size())*4;
		allocat += 12;
		cout T ".frame" T "$fp," << allocat <<",$31"<<endl;
		cout T "addiu" T "$sp,$sp,-"<< allocat << endl;
		cout T "sw" T "$fp,"<< allocat - 4 <<"($sp)" << endl;
		cout T "move" T "$fp,$sp"<< endl;
		left->lickdick(allocat);
		tt = 0;
		right->lickdick(allocat);
		cout T "move" T "$sp,$fp"<< endl;
		cout T "lw" T "$fp,"<< allocat - 4 <<"($sp)\n";
		cout T "addiu" T "$sp,$sp,"<< allocat << endl;
		cout T "j" T "$31\n";
		cout T "nop"<<"\n\n" T ".end" T content<<endl;
		cout T ".size" T content <<", .-" <<content <<endl;
		//variable.clear();
	}

};

class para_n: public p_node{
public:
	void lickdick(const int& allocate){
		for(int i=0;i<child.size();i++){
			if(i<4)cout T "sw" T "$"<<i+4<<","<< allocate +i*4 <<"($fp)" << endl;
			variable[child[i]->content] = allocate + i*4;
		}
	}

};
class vard_n: public p_node{
public:
	void lickdick(const int& allocate){
		for(int i=0;i<child.size();i++) variable[child[i]->content] = 8+i*4;
	}
};

class line_n: public p_node{
public:
	void lickdick(const int& allocate){
		for(int i=0;i<child.size();i++)
			child[i]->lickdick(0);
	}

};
class isco_n: public p_node{
public:
	void lickdick(const int& allocate){
		left->lickdick(allocate);
		right->lickdick(allocate);
	}

};


class retn_n: public p_node{
public:
	void lickdick(const int& allocate){
		child[0]->lickdick(0);
	}
};
class asgn_n: public p_node{
public:
	asgn_n(string c){content = c;}
	void lickdick(const int& allocate){
		if (left->type != "IDENTIFIER") return;
		right->lickdick(0);
		cout T "sw" T "$"<< 2 + tt << "," << variable[left->content] << "($fp)" << endl;
	}

};
class addexpr_n: public p_node{
public:
	addexpr_n(nptr l,nptr r){left = l;right = r;}
	void lickdick(const int& allocate){
		if(right->type =="CONSTANT"){
			left->lickdick(1);
			cout T "addiu" T "$2,$3,"<<right->content<<endl;
		}
		else if(left->type == "CONSTANT"){
			right->lickdick(1);
			cout T "addiu" T "$2,$3,"<<left->content<<endl;
		}else{
			right->lickdick(0);
			left->lickdick(1);
			cout T "addu" T "$2,$2,$3\n";
		}
	}
};
class subexpr_n: public p_node{
public:
	subexpr_n(nptr l,nptr r){left = l;right = r;}
	void lickdick(const int& allocate){
		if(right->type =="CONSTANT"){
			left->lickdick(1);
			cout T "subiu" T "$2,$3,"<<right->content<<endl;
		}
		else{
			left->lickdick(0);
			right->lickdick(1);
			cout T "subu" T "$2,$2,$3\n";
		}
	}
};
class multexpr_n: public p_node{
public:
	multexpr_n(nptr l,nptr r){left = l;right = r;}
	void lickdick(const int& allocate){
		
	}
};
class divexpr_n: public p_node{
public:
	divexpr_n(nptr l,nptr r){left = l;right = r;}
	void lickdick(const int& allocate){
		
	}
};

class low_n: public p_node{
public:
	low_n(string t,string c){type = t;content = c;}
	void lickdick(const int& allocate){
		if(type == "IDENTIFIER") cout T "lw" T "$"<< 2 + allocate << "," << variable[content] << "($fp)\n";
		else cout T "li" T "$"<< 2 + allocate << "," << content  << endl;
	}
};



#endif
