main: ex1.y ex1.l
	bison -d -o ex1y.cpp ex1.y
	flex -o ex1l.c ex1.l
	g++ -o ex1 ex1y.cpp ex1l.c

clean:
	rm ex1y.cpp ex1y.hpp ex1l.c ex1