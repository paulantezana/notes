"""diccionarios"""

PUNTO = {'x': 25, 'y': 50}

print(PUNTO)
print(PUNTO['x'])
print(PUNTO['y'])

if 'name' in PUNTO:
    print(PUNTO['name'])

print(PUNTO.get('x'))
print(PUNTO.get('name', 'default value'))

del PUNTO['x']

print(PUNTO)

PUNTO['x'] = 85

print(PUNTO)


for llave, valor in PUNTO.items():
    print(llave, valor)


# USUARIOS = [
#     {
#         "id":1,
#         "id":1,
#     }
# ]

print((8 / 2) + 4 * 8)


primso = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17]

print(primso[3:10:3])


print(4 != 10)
