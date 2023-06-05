"""Variables"""

NOMBRE_CURSO = "Ultimate python" # Cadena de texto, comillas simples o dobles
ALUMNOS = 5 # Numerico
PUBLICADO = True # Boleano
PUNTAJE = 11.2 # Decianl
DESCRIPCION = """
Esta es una descripcion
del curso de python
"""
# ==========================================================================
# CADENAS DE TEXTO
print(DESCRIPCION)
print(len(DESCRIPCION))
print(NOMBRE_CURSO[0]) # Acceder al indice de una cadena de texto
print(NOMBRE_CURSO[0:3]) # Indicar inicion y fin de extracion de cadena
print(NOMBRE_CURSO[2:])
print(NOMBRE_CURSO[:3])
print(NOMBRE_CURSO[:]) # Longitud completa

# ==========================================================================
# CONCATENACION
NOMRBES = "PAUL"
APELLIDOS = "ANTEZANA"

# NOMBRE_COMPLETO = NOMRBES + " " + APELLIDOS
NOMBRE_COMPLETO = f"{NOMRBES} {APELLIDOS} con edad {20 + 7}"
print(NOMBRE_COMPLETO)


# ==========================================================================
# Formatos para los strings
ANIMAL = "   ChanCHITO   feliz   "
print(ANIMAL.upper())
print(ANIMAL.lower())
print(ANIMAL.capitalize())
print(ANIMAL.title())
print(ANIMAL.strip()) # Quitar espacios al inicio y final
print(ANIMAL.strip().capitalize())
print(ANIMAL.rstrip()) # Quitar espacios a la derecha
print(ANIMAL.lstrip()) # Quitar espacios a la izquierda
print(ANIMAL.find("CH")) # Buscar una cadena dentro de otro cadena : devuelve el indice
print(ANIMAL.replace("feliz", "Triste")) # Remplazar
print("feliz" in ANIMAL) # Buscar una cadena dentro de otra cadena
print("feliz" not in ANIMAL) # Buscar

# Escape a caracteres
SEGUNDO_CURSO = "Nombre del curso es \"python\""
print(SEGUNDO_CURSO)
