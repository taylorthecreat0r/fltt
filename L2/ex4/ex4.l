%{
#include <iostream>
#include <stack>
#include <cmath>
#include <string>

std::stack<int> stack;
std::string error_msg = "";
bool invalid_sign = false;


void clear_stack() {
  stack = std::stack<int>();
}

void set_err_msg(std::string msg) {
  error_msg = msg;
}

int add(int a, int b) {
   return a + b; 
}

int substract(int a, int b) { 
  return a - b; 
}

int multiply(int a, int b) { 
  return a * b;
}

int mod(int a, int b) { 
  if (b != 0) 
    return a % b;  
  else
    set_err_msg("Dzielenie przez 0!!!");
    clear_stack();
    return 0;
   
}

int power(int a, int b) { 
  return pow(a, b); 
}

int divide(int a, int b) {
  if (b != 0) 
    return a / b; 
  else 
    set_err_msg("Dzielenie przez 0!!!");
    clear_stack();
    return 0;
}

%}

%x ERROR

%%

\-?[0-9]+   {stack.push(std::stoi(yytext));}
\+          {
                if (stack.size() > 1) {
                    int a = stack.top();
                    stack.pop();
                    int b = stack.top();
                    stack.pop();
                    stack.push(add(b, a));
                } else if (!invalid_sign) {
                    set_err_msg("Za mała liczba argumentów!!!");
                    clear_stack();
                }
            }
\-          {
                if (stack.size() > 1) {
                    int a = stack.top();
                    stack.pop();
                    int b = stack.top();
                    stack.pop();
                    stack.push(substract(b, a));
                } else if (!invalid_sign) {
                    set_err_msg("Za mała liczba argumentów!!!");
                    clear_stack();
                }
            }
\*          {
                if (stack.size() > 1) {
                    int a = stack.top();
                    stack.pop();
                    int b = stack.top();
                    stack.pop();
                    stack.push(multiply(b, a));
                } else if (!invalid_sign) {
                    set_err_msg("Za mała liczba argumentów!!!");
                    clear_stack();
                }
            }
\/          {
                if (stack.size() > 1) {
                    int a = stack.top();
                    stack.pop();
                    int b = stack.top();
                    stack.pop();
                    stack.push(divide(b, a));
                } else if (!invalid_sign) {
                    set_err_msg("Za mała liczba argumentów!!!");
                    clear_stack();
                }
            }
\%          {
                if (stack.size() > 1) {
                    int a = stack.top();
                    stack.pop();
                    int b = stack.top();
                    stack.pop();
                    stack.push(mod(b, a));
                } else if (!invalid_sign) {
                    set_err_msg("Za mała liczba argumentów!!!");
                    clear_stack();
                }
            }
\^          {
                if (stack.size() > 1) {
                    int a = stack.top();
                    stack.pop();
                    int b = stack.top();
                    stack.pop();
                    stack.push(power(b, a));
                } else if (!invalid_sign) {
                    set_err_msg("Za mała liczba argumentów!!!");
                    clear_stack();
                }
            }
\n          {
                if (stack.size() > 1) {
                    set_err_msg("Za mała liczba operatorów!!!");
                    clear_stack();
                }
                if (stack.size() == 1 && error_msg == "") {
                    std::cout << "= " << stack.top() << std::endl;
                    stack.pop();
                } else {
                    std::cout << error_msg << std::endl;
                    set_err_msg("");
                    clear_stack();
                }
            }
" "         ;
.           { set_err_msg(std::string("Zły symbol!!! - ") + yytext); invalid_sign = true; clear_stack(); BEGIN(ERROR); }
<ERROR>{
  .|\n      BEGIN(0);
}
%%

int yywrap(){return 1;}

int main() {
  return yylex();
}