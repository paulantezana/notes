N1 = input("Ingresa el primer número: ")
N2 = input("Ingresa el segundo número: ")

N1 = int(N1)
N2 = int(N2)

SUMA = N1 + N2
RESTA = N1 - N2
MULTI = N1 * N2
DIV = N1 / N2

MENSAJE = f"""
Para los números {N1} y {N2}
el resultado de la suma es {SUMA}
el resultado de la resta es {RESTA}
el resultado de la multiplicacion es {MULTI}
el resultado de la divicion es {DIV}
"""

print(MENSAJE)
