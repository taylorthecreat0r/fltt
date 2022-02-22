%{
#define YYSTYPE int
#include <iostream>
#include <string>
#define P 1234577

using namespace std;

extern int yylex();
extern int yyparse();
int yyerror(string s);

int zp_sub(int a, int b);

int extended_euclid(int a, int b, int *x, int *y);
int zp_inv(int a);
int power_sub(int a, int b);
int zp_div(long int a, int b);

int zp_pow(long int a, int pow);

string error_msg = "";
string rpn = "";
%}

%token NUM
%token ERR
%left '+' '-'
%left '*' '/'
%precedence NEG
%nonassoc '^'

%%

input:
    %empty
    | input line
;
line: 
    expr '\n' { 
            cout << "RPN: " << rpn << endl;
            cout << "= " << $1 << endl; 
            rpn = "";
        }
    | error '\n' { 
            if (error_msg == "") 
                error_msg = "syntax problem";
            cout << "Error: " << error_msg << endl; 
            rpn = ""; 
            error_msg = "";
        }
;
expr: 
    number                          { rpn += to_string($1) + " "; $$ = $1; }
    | '(' expr ')'                  { $$ = $2; }
    | '-' '(' expr ')' %prec NEG    { rpn += "~ "; $$ = ((-$3 % P) + P) % P; }
    | expr '+' expr                 { rpn += "+ "; $$ = ($1 + $3) % P; }
    | expr '-' expr                 { rpn += "- "; $$ = zp_sub($1, $3); }
    | expr '*' expr                 { rpn += "* "; $$ = ($1 * $3) % P; }
    | expr '^' expr_in_power                 {rpn += " ^ "; $$ = zp_pow($1, ($3 + (P-1)) % (P-1)); }
    | expr '/' expr { 
            rpn += "/ "; 
            if ($3 == 0) { 
                error_msg = "dividing by 0"; 
                YYERROR; 
            } 
            else
                $$ = zp_div($1, $3); 
        }
;

expr_in_power:
        number_2                          { rpn += to_string($1) + " "; $$ = $1; }
    | '(' expr_in_power ')'                  { $$ = $2; }
    | '-' '(' expr_in_power ')' %prec NEG    { rpn += "~ "; $$ = ((-$3 % (P-1)) + (P-1)) % (P-1); }
    | expr_in_power '+' expr_in_power                 { rpn += "+ "; $$ = ($1 + $3) % (P-1); }
    | expr_in_power '-' expr_in_power                 { rpn += "- "; $$ = power_sub($1, $3); }
    | expr_in_power '*' expr_in_power                 { rpn += "* "; $$ = ($1 * $3) % (P-1); }
;

number:
    NUM                     { $$ = $1 % P;}
    | '-' number %prec NEG  { $$ = ((-$2 % P) + P) % P; }
;

number_2:
    NUM                     { $$ = $1 % (P-1);}
    | '-' number %prec NEG  { $$ = ((-$2 % (P-1)) + (P-1)) % (P-1); }

%%

int zp_sub(int a, int b) {
    int val = (a-b) % P;
    if (val < 0)
        val += P;
    return val;
}

int power_sub(int a, int b) {
    int val = (a-b) % (P-1);
    if (val < 0)
        val += (P-1);
    return val;
}

int extended_euclid(int a, int b, int *x, int *y) {
    if (a == 0) {
        *x = 0;
        *y = 1;
        return b;
    }
    int x1, y1;
    int d = extended_euclid(b%a, a, &x1, &y1);
    *x = y1 - (b/a)*x1;
    *y = x1;
    return d;
}

int zp_inv(int a) {
    int x, y;
    extended_euclid(a, P, &x, &y);
    return (x%P + P) % P;
}

int zp_div(long int a, int b) {
    long int inv = zp_inv(b);
    return (int)((a*inv) % P);
}

int zp_pow(long int a, int pow) {
    if (pow == 0)
        return 1;
    long int b = zp_pow(a, pow/2);
    if (pow % 2 == 0)
        return (int)((b*b) % P);
    else
        return (int)((a * b*b) % P);
}

int yyerror(string s) {	
    return 0;
}

int main()
{
    yyparse();
    return 0;
}