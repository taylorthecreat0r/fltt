%{
#include<stdio.h>
int yylex();
int yywrap();
int num_of_words;
int num_of_lines;
%}

%%

^[[:blank:]]*\n*      ;
[[:blank:]]+$   ;
[[:blank:]]+    fprintf(yyout, " ");
\n              { ECHO; num_of_lines++; }
[0-9a-zA-Z]+       { num_of_words++; ECHO; } /* ECHO <-> printf ("%s", yytext).*/
%%

int yywrap(void) {return 1;}

int main(int argc, char* argv[]) {
    yyin = fopen(argv[1], "r");
    yyout = fopen("wynik.txt", "w");
    yylex();
    printf("\n num_of_words =  %d \n num_of_lines = %d\n", num_of_words, num_of_lines);

    return 0;
}