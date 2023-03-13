SELECT * FROM [Configuracion].[DiccionarioPantallaTabla]
SELECT * FROM [Configuracion].[DiccionarioPantallaCampo]
SELECT TOP 10 * FROM Auditoria.LogDeExcepciones ORDER BY Id DESC


# ARCHIVO COMPARTIDO
https://micosac.sharepoint.com/sites/DesarrolloBackOffice/Documentos%20compartidos/Forms/AllItems.aspx?id=%2Fsites%2FDesarrolloBackOffice%2FDocumentos%20compartidos%2FACTIVIDADES&p=true

# Logica
Se tiene que hacer por propuesta.
Al aceptar llamar un store procedure.
Imprimir mensaje u ruta del archivo


# Pendiende  de validacion
Descripcion anio peridodo esta mal 202200 deberia ser 202300
SELECT * FROM [Configuracion].[DiccionarioPantallaCampoPropuesta] WHERE Pantalla = 'AnioPeriodo'
SELECT * FROM [Configuracion].[DiccionarioPantallaCampo] WHERE Pantalla = 'AnioPeriodo'

SELECT * FROM [Configuracion].[DiccionarioPantallaCampoPropuesta] WHERE Pantalla = 'Anio'
SELECT * FROM [Configuracion].[DiccionarioPantallaCampo] WHERE Pantalla = 'Anio'