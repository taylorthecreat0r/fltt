# Finite automata algorithm for pattern searching

from typing import Sequence
from sys import argv

# zgodnie z funkcją delta przechodzimy po kolejnych stanach. Jeśli trafiliśmy do stanu len(pattern), to znaleźliśmy wystąpienie wzorca.
def finite_automation_matcher(input: str, delta, pattern_length: int):
    n = len(input)
    q = 0
    occurences = 0
    for i in range(0, n):
        q = delta[q][input[i]]
    
        if q == pattern_length:
            s = i - pattern_length
            occurences += 1
            print('Wzorzec pojawia się na ', s+1, ' indeksie')
            #print(input[s+1:s+len(pattern)+1])
    
    print("Liczba wystąpień: ", occurences)


# tworzymy funkcję delta decydującą o zmianie dotychczasowego stanu, zgodnie z kolejną literą z inputu
# jaką otrzymamy. Algorytm jest prosty state = if nextchar(input) == nextchar(pattern) then nextstate(pattern) else 0
#najdluzszy prefiks patterny bedacy sufiksem obecnie rozpatrywanego ciagu
def compute_transition_function(pattern: str, alphabet: Sequence[str]):
    delta = {}
    m = len(pattern)

    for q in range(m+1):
        delta[q] = {}

        for a in alphabet:
            #największe sensowne k. Nie chcemy wyjsc poza zakres i jednoczesnie nie chcemy zbednych porownan z calym patternem
            k = min(m+1, q+2) - 1
            pattern_q = pattern[:q]
            pattern_q += a
            while not pattern_q.endswith(pattern[:k]):
                k -= 1
            delta[q][a] = k
    return delta

if __name__ == '__main__':
    if len(argv) != 3:
        exit(1)

    pattern = argv[1]
    text = open(argv[2], 'r').read()
    alphabet = set(text).union(set(pattern))
    alphabet = sorted(alphabet)
    finite_automation_matcher(text, x := (compute_transition_function(pattern, alphabet)), len(pattern))

    #print(x)