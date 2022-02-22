from lexrules import tokens, P


tokens = tokens[:-3]
rpn = ""
zero_div = False
precedence = (
    ('left', 'ADD', 'SUB'),
    ('left', 'MUL', 'DIV'),
    ('right', 'NEG'),
    ('nonassoc', 'POW')
)

def p_line_expr(p):
    'line : expr ENDL'
    global rpn, zero_div
    print("RPN:", rpn)
    print(f"= {p[1]}")
    rpn = ""
    zero_div = False

def p_line_error(p):
    'line : error ENDL'
    global rpn, zero_div
    if zero_div:
        print("Error: dividing by 0")
    else:
        print("Error: syntax problem")
    rpn = ""
    zero_div = False

def p_expr_number(p):
    'expr : number'
    global rpn
    rpn += f"{p[1]} "
    p[0] = p[1]

def p_expr_paren(p):
    'expr : LPAREN expr RPAREN'
    p[0] = p[2]

def p_expr_neg(p):
    'expr : SUB LPAREN expr RPAREN %prec NEG'
    global rpn
    rpn += "~ "
    p[0] = -p[3] % P

def p_expr_add(p):
    'expr : expr ADD expr'
    global rpn
    rpn += "+ "
    p[0] = (p[1] + p[3]) % P

def p_expr_sub(p):
    'expr : expr SUB expr'
    global rpn
    rpn += "- "
    p[0] = (p[1] - p[3]) % P

def p_expr_mul(p):
    'expr : expr MUL expr'
    global rpn
    rpn += "* "
    p[0] = (p[1] * p[3]) % P

def p_expr_pow(p):
    'expr : expr POW expr_in_power'
    global rpn
    rpn += " ^ "
    p[0] = pow(p[1], p[3] % (P-1)) % P

def p_expr_div(p):
    'expr : expr DIV expr'
    global rpn
    rpn += "/ "
    if p[3] == 0:
        global zero_div
        zero_div = True
        raise SyntaxError
    p[0] = (p[1] * pow(p[3], -1, P)) % P
    

def p_expr_in_exponent_number(p):
    'expr_in_power : number_in_power'
    global rpn
    rpn += f"{p[1]} "
    p[0] = p[1]

def p_expr_in_exponent_paren(p):
    'expr_in_power : LPAREN expr_in_power RPAREN'
    p[0] = p[2]

def p_expr_in_exponent_neg(p):
    'expr_in_power : SUB LPAREN expr_in_power RPAREN %prec NEG'
    global rpn
    rpn += "~ "
    p[0] = -p[3] % (P-1)

def p_expr_in_exponent_add(p):
    'expr_in_power : expr_in_power ADD expr_in_power'
    global rpn
    rpn += "+ "
    p[0] = (p[1] + p[3]) % (P-1)

def p_expr_in_exponent_sub(p):
    'expr_in_power : expr_in_power SUB expr_in_power'
    global rpn
    rpn += "- "
    p[0] = (p[1] - p[3]) % (P-1)

def p_expr_in_exponent_mul(p):
    'expr_in_power : expr_in_power MUL expr_in_power'
    global rpn
    rpn += "* "
    p[0] = (p[1] * p[3]) % (P-1)

def p_number_pos(p):
    'number : NUM'
    p[0] = p[1] % P

def p_number_neg(p):
    'number : SUB number %prec NEG'
    p[0] = -p[2] % P
    
def p_number_in_pow_pos(p):
    'number_in_power : NUM'
    p[0] = p[1] % (P-1)

def p_number_in_powewr_neg(p):
    'number_in_power : SUB number_in_power %prec NEG'
    p[0] = -p[2] % (P-1)    

def p_error(p):
    pass