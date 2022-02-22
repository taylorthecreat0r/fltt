%{
#include<stdio.h>
int yylex();
int yywrap();
%}

%x COMMENT
 
%%
"<!--"     { BEGIN(COMMENT); }
<COMMENT>{
   "-->"   { BEGIN(0); }
   [^-]+   ;
   .|\n    ;
}
\"(.|\n)*\" {ECHO;}
\<!\[CDATA\[(.|\n)*\]\]\> {ECHO;}
\<!--[^-->]*--.*--\> {ECHO;}
%%
int yywrap(void) {return 1;}


int main(int argc, char* argv[]) {
    remove("result.xml");
    yyin = fopen(argv[1], "r");
    yyout = fopen("result.xml", "w");
    return yylex();
    // \<![^--]*\<!--.*-->\> {ECHO;}

}