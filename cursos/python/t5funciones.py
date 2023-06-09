def hola(nombre, apellido=''):
    print(f'Bienvenido {nombre} {apellido}')


hola('paul')
# se pasa con el nombre del parametro cuando no se conocer el orden
hola(apellido='antezana', nombre='paul')


print("============================================================")
print("Mas de un parametro:")


def suma(*numeros):  # cuando se pasa mas de un argumento y se resive en un solo variable
    resultado = 0
    for i in numeros:
        resultado += i
    print(resultado)


suma(1, 2, 3, 4, 5)

print("============================================================")
print("Diccionario:")


def get_product(**datos):  # Recibe un diccionario
    print(datos)
    print(f'el parametro id tiene el valor: {datos["id"]}')


get_product(id=1, name='papa')
