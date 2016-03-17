#ifndef TREE_HPP
#define TREE_HPP

#define T <<"\t"<<
#define yolo "IDENTIFIER"&&"CONSTANT"
#include<vector>
#include<string>
#include<cstdlib>
#include<iostream>
#include<map>
using namespace std;
class p_node;
static map<string,int> variable;
static int tt;
typedef p_node* nptr;

void reassemble(nptr curptr);
void shiftprint(string num);
class p_node{
public:
	p_node():content("debug_empty"),type("LOL"){}
	p_node(string c){content = c;}
	p_node(string t,string c){type = t;content = c;}
	p_node(nptr l,nptr r){left = l;right = r;}

	void add_child(nptr n){
		child.push_back(n);
	}
	virtual void traverse(const int& allocate) = 0;
	nptr left = NULL;
	nptr right =NULL;
	vector<nptr> child;
	string type;
	string content;
};


class head_n: public p_node{
	void traverse(const int& allocate){
		for(int i=0;i<child.size();i++)
			child[i]->traverse(0);
	}

};

class func_n: public p_node{
public:

	void traverse(const int& allocate){
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
		left->traverse(allocat);
		tt = 0;
		right->traverse(allocat);
		cout T "move" T "$sp,$fp"<< endl;
		cout T "lw" T "$fp,"<< allocat - 4 <<"($sp)\n";
		cout T "addiu" T "$sp,$sp,"<< allocat << endl;
		cout T "j" T "$31\n";
		cout T "nop"<<"\n\n" T ".end" T content<<endl;
		cout T ".size" T content <<", .-" <<content <<endl;
		variable.clear();
	}

};

class para_n: public p_node{
public:
	void traverse(const int& allocate){
		for(int i=0;i<child.size();i++){
			if(i<4)cout T "sw" T "$"<<i+4<<","<< allocate +i*4 <<"($fp)" << endl;
			variable[child[i]->content] = allocate + i*4;
		}
	}

};
class vard_n: public p_node{
public:
	void traverse(const int& allocate){
		for(int i=0;i<child.size();i++) variable[child[i]->content] = 8+i*4;
	}
};

class line_n: public p_node{
public:
	void traverse(const int& allocate){
		for(int i=0;i<child.size();i++){
			child[i]->traverse(0);
			if(child[i]->content == "Return") i+=child.size();
		}
	}

};
class isco_n: public p_node{
public:
	void traverse(const int& allocate){
		left->traverse(allocate);
		right->traverse(allocate);
	}

};


class retn_n: public p_node{
public:
	void traverse(const int& allocate){
		child[0]->traverse(0);
	}
};
class asgn_n: public p_node{
public:
	asgn_n(string c){content = c;}
	void traverse(const int& allocate){
		if (left->type != "IDENTIFIER") return;
		right->traverse(0);
		if(content == "=")
			cout T "sw" T "$"<< 2 << "," << variable[left->content] << "($fp)" << endl;
		else
		if(content == "+="){
			cout T "lw" T "$"<< 3 << "," << variable[left->content] << "($fp)" << endl;
			cout T "addu" T "$2,$2,$3\n";
			cout T "sw" T "$"<< 2 << "," << variable[left->content] << "($fp)" << endl;
		}
		else
		if(content == "-="){
			cout T "lw" T "$"<< 3 << "," << variable[left->content] << "($fp)" << endl;
			cout T "subu" T "$2,$3,$2\n";
			cout T "sw" T "$"<< 2 << "," << variable[left->content] << "($fp)" << endl;
		}
		else
		if(content == "*="){
			cout T "lw" T "$"<< 3 << "," << variable[left->content] << "($fp)" << endl;
			cout T "mul" T "$2,$2,$3\n";
			cout T "sw" T "$"<< 2 << "," << variable[left->content] << "($fp)" << endl;
		}
		else
		if(content == "/="){
			cout T "lw" T "$"<< 3 << "," << variable[left->content] << "($fp)" << endl;
			cout T "div" T "$2,$3,$2\n";
			cout T "sw" T "$"<< 2 << "," << variable[left->content] << "($fp)" << endl;
		}

	}

};
class addexpr_n: public p_node{
public:
	addexpr_n(nptr l,nptr r){left = l;right = r;}
	void traverse(const int& allocate){
		if(right->type =="CONSTANT"){
			left->traverse(1);
			cout T "addiu" T "$" << 2+allocate <<",$3,"<<right->content<<endl;
		}
		else if(left->type == "CONSTANT"){
			right->traverse(1);
			cout T "addiu" T "$" << 2+allocate <<",$3,"<<left->content<<endl;
		}else{
			right->traverse(0);
			if(left->type != yolo){
			cout T "mov" T "$" << 4+tt <<",$2\n";
			tt++;
			left->traverse(1);
			tt--;
			cout T "addu" T "$" << 2+allocate <<",$"<<4+tt<<",$3\n";
			}
			else{
			left->traverse(1);
			cout T "addu" T "$" << 2+allocate <<",$2,$3\n";
			}
		}
	}
};
class subexpr_n: public p_node{
public:
	subexpr_n(nptr l,nptr r){left = l;right = r;}
	void traverse(const int& allocate){
		if(right->type =="CONSTANT"){
			left->traverse(1);
			cout T "subiu" T "$"<< 2+allocate <<",$3,"<<right->content<<endl;
		}
		else{
			right->traverse(0);
			if(left->type != yolo){
			cout T "mov" T "$" << 4+tt <<",$2\n";
			tt++;
			left->traverse(1);
			tt--;
			cout T "subu" T "$" << 2+allocate <<",$"<<4+tt<<",$3\n";
			}
			else{
			left->traverse(1);
			cout T "subu" T "$"<< 2+allocate <<",$2,$3\n";
			}
			
		}
	}
};
class multexpr_n: public p_node{
public:
	multexpr_n(nptr l,nptr r){left = l;right = r;}
	void traverse(const int& allocate){
		if(left ->type == "CONSTANT" && right->type == "CONSTANT") 
			cout T "li" T "$"<<2+allocate<<"," << atoi(left->content.c_str()) * atoi(right->content.c_str()) << endl;
		else{
			right->traverse(0);
			if(left->type != "IDENTIFIER"&&left->type != "CONSTANT"){
			cout T "mov" T "$" << 4+tt <<",$2\n";
			tt++;
			left->traverse(1);
			tt--;
			cout T "mul" T "$" << 2+allocate <<",$"<<4+tt<<",$3\n";
			}
			else{
			left->traverse(1);
			cout T "mul" T "$" << 2+allocate <<",$2,$3\n";
			}
		}
	}
};
class divexpr_n: public p_node{
public:
	divexpr_n(nptr l,nptr r){left = l;right = r;}
	void traverse(const int& allocate){
		if(left ->type == "CONSTANT" && right->type == "CONSTANT") 
			cout T "li" T "$"<<2+allocate<<"," << int(atoi(left->content.c_str()) / atoi(right->content.c_str())) << endl;
		else{
			right->traverse(0);
			if(left->type != yolo){
			cout T "mov" T "$" << 4+tt <<",$2\n";
			tt++;
			left->traverse(1);
			tt--;
			cout T "div" T "$0,$"<<4+tt<<",$3\n";
			cout T "mflo" T "$" << 2+allocate<<endl;
			}
			else{
			left->traverse(1);
			cout T "div" T "$0,$2,$3\n";
			cout T "mflo" T "$" << 2+allocate<<endl;
			}
		}
	}
};

class low_n: public p_node{
public:
	low_n(string t,string c){type = t;content = c;}
	void traverse(const int& allocate){
		if(type == "IDENTIFIER") cout T "lw" T "$"<< 2 + allocate << "," << variable[content] << "($fp)\n";
		else cout T "li" T "$"<< 2 + allocate << "," << content  << endl;
	}
};



#endif
