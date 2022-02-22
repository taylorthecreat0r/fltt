#Knuth Morris Prath algorithm for pattern searching

from sys import argv

# Mając funkcję pi porównujemy pattern z tekstem, 
# a w przypadku niezgodności lub końca przechodzimy do najbliższego stanu akceptującego dotychczasowy input 

def knuth_morris_pratt_matcher(input: str, π, pattern: str):
    m = len(pattern)
    n = len(input)
    q = 0
    occurences = 0

    for i in range(n):
        while q > 0 and pattern[q] != input[i]:
            q = π[q-1]

        if pattern[q] == input[i]:
            q += 1

        if q == m:
            s = i - m + 1
            occurences += 1
            print('Wzorzec pojawia się na ', s, 'indeksie')
            #print(input[s:s+len(pattern)])
            q = π[q-1]

    print("Liczba wystąpień: ", occurences)

# Porównujemy pattern z samym sobą:
# dla danego q pi(q) = długość najdłuższego prefiksu będącego najdłuższym sufiksem właściwym prefiksu P_q (= P[:q])

def compute_prefix_function(pattern: str):
    m = len(pattern)
    π = {}
    π[0] = 0
    k = 0

    for q in range(1, m):
        while k > 0 and pattern[k] != pattern[q]:
            k = π[k-1]

        if pattern[k] == pattern[q]:
            k += 1

        π[q] = k

    return π

if __name__ == '__main__':
    if len(argv) != 3:
        exit(1)

    pattern = argv[1]
    text = open(argv[2], 'r').read()
    knuth_morris_pratt_matcher(text, π := (compute_prefix_function(pattern)), pattern)
    #print(π)