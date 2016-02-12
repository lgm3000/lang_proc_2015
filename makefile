bin/c_lexer : src/tokenizer.cpp
	g++ src/tokenizer.cpp -o bin/c_lexer

clean :
	rm bin/c_lexer

