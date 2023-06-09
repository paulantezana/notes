# X = input("Ingresa el primer número: ")
# int() convert to int
# str() convert to string
# float() convert to float
# bool() convert to bolean // Se evalue como en javascript como falsy o truzi

print(bool(""))
print(bool("0"))
print(bool(None))
print(bool(" "))
print(bool(0))


print("============================================================")
print("Operadores de comparacion")

print(2 > 2)
print(2 == "2")

print("============================================================")
print("Condicionales")

if 4 > 2 and 5 > 1:
    print('SIIII')
else:
    print('NOOOO')

# If de una sola linea
COMPARACION = "es mayor" if 4 > 3 else "es menor"
print(COMPARACION)


print("============================================================")
print("Corto sircuito")

print("cuando hay puro AND en la comparacion: siel primero es false el resto se ignora")
print("cuando hay puro OR en la comparacion: siel primero es true el resto se ignora")

if 4 <= 5 <= 10:  # se esta indicando que "entra" cuando se encuentra entre 4 y 10
    print('entra')


print("============================================================")
print("For:")

for i in range(5):
    print(i)


print("---")
for i in range(3):
    print(i * 2)
    break
else:  # Se ejecuta cuando no hay un brack dentro de in for
    print('sss')


print("---")

NUMERO_LOOP = 1
while NUMERO_LOOP < 3:
    print(NUMERO_LOOP)
    NUMERO_LOOP += 1
