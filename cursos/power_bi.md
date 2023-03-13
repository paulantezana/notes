# Definición del ámbito de los requisitos de diseño del informe
## Publicao de power bi
https://learn.microsoft.com/es-es/training/modules/power-bi-effective-requirements/2-identify
Los tres grandes públicos de consumidores de informes son los siguientes:
* Ejecutivo: Los ejecutivos son responsables de que la empresa funcione sin problemas
* Analista: determinar la eficacia de las estrategias empresariales, desarrollar o mejorar procesos, o implementar cambios
* Trabajador de la información: Ejemplo: información actualizada sobre los niveles de existencias
## Tipos de informe
https://learn.microsoft.com/es-es/training/modules/power-bi-effective-requirements/3-determine
* Panel               | Dashboard         | Ejecutivo -> "¿Cómo lo estamos haciendo?" o "¿Ya llegamos?".
* Analíticos          | Analytical        | Especialmente para interactuar -> exploración en profundidad, la obtención de detalles y la información sobre herramientas.
un informe analítico es aquel que va más allá del tipo de pregunta "¿Cómo lo estamos haciendo?" para responder al tipo de preguntas "¿Por qué pasó eso?" o "¿Qué podría ocurrir después?".

* Operativos          | Operational       | Los informes operativos pueden incluir botones que permiten al consumidor del informe navegar por su interior y también más allá del informe para realizar acciones en sistemas externos
* Educativos          | Educational       | suponen que el consumidor del informe no está familiarizado con los datos o el contexto, todo descriptivo.

## Reporte de ejemplo en Power BI
https://msit.powerbi.com/view?r=eyJrIjoiMDc1NTk0ZjItZjUxMS00OGM1LTk0YTktN2U5ZGNkY2NlNzdlIiwidCI6IjcyZjk4OGJmLTg2ZjEtNDFhZi05MWFiLTJkN2NkMDExZGI0NyIsImMiOjV9&pageName=ReportSection



# Estructuración de diseños de informes analíticos en Power BI 
https://learn.microsoft.com/es-es/training/modules/power-bi-effective-structure/1-introduction



usa el lenguaje M
usa el lenguaje DAX

# Mode Import And Direact Query Limitaciones Y ventajas (comparacion)
https://spgeeks.devoworx.com/switch-import-to-directquery-mode-powerbi/#import-mode-limitations-in-power-bi


# Contextos
* Contexto de fila: ejemplo funcion SUMX
* contexto de filtro: ejemplo funcion SUM




# API REST POWER BI
https://learn.microsoft.com/es-es/rest/api/power-bi
https://community.powerbi.com/t5/Developer/Data-Refresh-by-using-API-Need-Steps/td-p/208928


# Buenas practicas de power bi
-- https://todobi.com/30-consejos-y-buenas-practicas-para-hacer-un-proyecto-de-power-bi-con-exito/

# Flujo de datos
-- https://learn.microsoft.com/es-es/power-bi/guidance/power-query-referenced-queries



# ¿QUE ES DATAMART?
Generalmente, los datos están estructurados en modelos estrellas o copo de nieve.
https://tableauperu.com/data-mart/


# DAX
## Contextos en power bi
### Contecto de filtro
### Contexto de fila




# CURSO 2
## MATRIZ
https://learn.microsoft.com/es-es/power-bi/visuals/desktop-matrix-visual


```sql
SELECT DISTINCT
	n1Codigo = CASE
						WHEN LEFT(rpt.TCLAVE,2) = '11' THEN '11'
						WHEN LEFT(rpt.TCLAVE,2) = '12' THEN '12'
						WHEN LEFT(rpt.TCLAVE,2) = '14' THEN '14'
						WHEN LEFT(rpt.TCLAVE,3) = '162' OR LEFT(rpt.TCLAVE,4) = '1619' THEN '16'
						WHEN LEFT(rpt.TCLAVE,4) IN ('1641', '1651') THEN '17'
						ELSE ''
					END,
	n1Descripcion = CASE
						WHEN LEFT(rpt.TCLAVE,2) = '11' THEN 'VENTAS'
						WHEN LEFT(rpt.TCLAVE,2) = '12' THEN 'COSTO DE VENTAS'
						WHEN LEFT(rpt.TCLAVE,2) = '14' THEN 'GASTOS'
						WHEN LEFT(rpt.TCLAVE,3) = '162' OR LEFT(rpt.TCLAVE,4) = '1619' THEN 'OTRO EGRESOS Y INGRESOS'
						WHEN LEFT(rpt.TCLAVE,4) IN ('1641', '1651') THEN 'IMPUESTOS'
						ELSE ''
					END
	, n2Codigo = TRIM(rpt.TCLAVE)
    , n2Descripcion = TRIM(rpt.TDESCRI)
	, CodigoCuenta = cta.PCUENTA
FROM produccion.rsconcar.dbo.CT0032TAGE as rpt
LEFT JOIN produccion.rsconcar.dbo.CT0032PLEM as cta ON cta.PFORGYP = rpt.TCLAVE
WHERE rpt.TCOD = '11' AND LEFT(rpt.TCLAVE,4) NOT IN ('1100','1199','1200','1299','1301','1301F','1501','1501F','1631','1631F','1999','1999F')
AND cta.PCUENTA IS NOT NULL
```