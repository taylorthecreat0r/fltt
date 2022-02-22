%{
#include<stdio.h>
#include <stdbool.h>
int yywrap();
int yylex();
bool DOC = false;
%}

%x MULTILINE_COMMENT

open_multiline \/\*(\n)?
open_multiline_doc \/\*(\*|!)(\n)?
close_multiline \*\/(\n)?
single_line \/\/.*(\n)
single_line_doc \/\/(\/|!).*(\n)

%%



(?# in string)
\".*\"	ECHO;

(?# in include)
#include[[:blank:]]*\<(.|\n)*> 	{ECHO;}


{open_multiline} BEGIN(MULTILINE_COMMENT);
<MULTILINE_COMMENT>{
.|\n    ;
{close_multiline}   { BEGIN(0); }
}

{open_multiline_doc} {if(DOC) ECHO; else BEGIN(MULTILINE_COMMENT);}

{single_line_doc} {if(DOC) ECHO; }

{single_line} ;


%%
int yywrap() {	return 1; }
int main(int argc, char **argv) {
	if(argc > 2) {
		DOC = true;
	}
    yyin = fopen(argv[1], "r");
    yyout = fopen("result.cpp", "w");
	return yylex();
}