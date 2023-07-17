import math

s = 3
p = .1
N = 5
ss = (s**2)*(N + 2*(N-1)*p + 2*(N-2)*p**2 + 2*(N-3)*p**3 + 2*p**4)
print(ss)
b = math.sqrt(ss)
print(b)
g = b*2.33
print(g)

