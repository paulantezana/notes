NUMEROS = [1, 2, 3, 4, 5, 6]

for n in NUMEROS:
    print(n)


CEROS = [0] * 10

print(CEROS)


# ====================================================000
# TUPLAS
# las tuplas son lo mismo que las listas con la diferencia de que no se pueden modificar
MI_TUPLA = (1, 2, 3, 4)
TUPLA_DESDE_LISTA = tuple([1,2,3])
print(MI_TUPLA)

# ====================================================000
# SET
# son lo mismo que los listas con la diferencia de que no acepta duplicados

MI_SET = {1, 2, 4, 4, 5}
SET_DESDE_LISTA = set([5,11,11,11,12])

print(MI_SET)

print('Operaciones con sets')
print(MI_SET | SET_DESDE_LISTA) # Union
print(MI_SET & SET_DESDE_LISTA) # Interseccion
print(MI_SET - SET_DESDE_LISTA) # Diferencia : quita elementos de segundo que esten en el primero
print(MI_SET ^ SET_DESDE_LISTA) # Diferencia simetrica: Inversa a intersession
