COMPARA ARCHIVOS: https://www.ddginc-usa.com/

181.224.226.108 // 192.168.33.206
aplicaciones
appEMMM$14

REPORTE
valorizador
Password$

= Parameters!DataBase.Value & ".Financiero.usp_rpt_CTB190_030300"

pAntezana@grupoValor.com
paan2021$


admin
123456

Frot
181.224.226.108:8080

FORTICLIENT
VPN: 181.224.226.106
PUERTO: 10443
USUARIO: AVargas
CLAVE: alva2018$
CLAVE: ]XsJC_hf9QSK

REMOTO: 192.168.33.206	


SELECT * FROM [Configuracion].[DiccionarioPantallaTabla]
SELECT * FROM [Configuracion].[DiccionarioPantallaCampo]
SELECT TOP 10 * FROM Auditoria.LogDeExcepciones ORDER BY Id DESC



6. Las pruebas serán realizadas con la empresa MINERCOBRE con ruc 20524561264.

-- Genera Diccionario
EXEC [Configuracion].[usp_GeneraDiccionario]


getEventListeners(window)

ACCESO CONCAR:
user: WPP
pass: WPP

CONCAR GRATIS
user: SIST
pass: NORTON

SUAGGER
http://192.168.33.206:8085/swagger/index.html


AHuaringa
123456


ACCESO --- VCM
user: ADMIN
pass: 290671


ACCESO --- MLC
user: ADMIN
pass: JAGUAR

IP:TOCHO
http://192.168.33.128:3911/

CLAVE -- SOL
20524561264
NTEMPARM
Mi27012021


RUTA REPORTE
\\192.168.33.206\ReportVisual

VER REPORTE:

http://192.168.33.206:8093/Report?id=CTB001&paramWhere=%28%28+%28Periodo+like+%27%25202307%25%27%29+and+%28Libro+%3D+%27OFICIAL%27%29+and+%28Moneda+%3D+%27PEN%27%29+%29%29&usuario=Admin&companias=27





EL MISMO SERVIDOR:


http://192.168.33.206/ReportServer/Pages/ReportViewer.aspx?%2fBackOffice%2fContabilidad%2fCTB001&rs:Command=Render




http://192.168.33.206/reports/browse/BackOffice/Contabilidad

Tengo lo siguiente datos:

Monto a pagar: 100 dolares

efectivo vale = 50%
tarjeta vale = 100%
cheque vale = 10%

Se pago
efectivo: 5 dolares
tarjeta: 100 dolares
cheque: 5 dolares

Como resultados tenemos
bueldo: 10 dolares
puntos acumulados segun el porcentaje: 95.5

Puedes predecir que operaciones se iso para que salga el resultado 95.5?




efectivo: 2.5
tarjeta: 100
cheque: 0.5

10
50%
+ 100% + 10%




INFORME
-- 030300: Query Correcto : hay 


CONCAR:
* DFECCOM2: Fecha Contable
* DFECVEN2: Fecha vencimiento
* DFECDOC2: Fecha documento

-- =========================================================================
-- CAJA    Y     BANCOS
✅ EXEC SP_GENERA_CAJA '0004', '2023', '04'
✅ [Reporte].[CTB190_010200]
-- Observacion:
    164-30008992 entidad axuliar Documento incorrecto en cuenta 104132

-- =========================================================================
-- INVENTARIO    Y     BALANCES
✅ EXEC [dbo].[PA_LE_BALANCE31] '0004', '2023', '04'
✅ EXEC [dbo].[PA_LE_BALANCE32] '0004', '2023', '04'
✅ EXEC [dbo].[PA_LE_BALANCE33] '0004', '2023', '04'
✅ EXEC [dbo].[PA_LE_BALANCE34] '0004', '2023', '04'
⚠️ EXEC [dbo].[PA_LE_BALANCE35] '0004', '2023', '04' -- EN BO falta actualizar TABLA - PLE Balance
⚠️ EXEC [dbo].[PA_LE_BALANCE36] '0004', '2023', '04' -- EN BO falta actualizar TABLA - PLE Balance
-- EXEC [dbo].[PA_LE_BALANCE37] '0004', '2023', '04' -- => EN Proviciones hay una tabla donde se almacena
-- EXEC [dbo].[PA_LE_BALANCE38] '0004', '2023', '04' -- => EN Proviciones hay una tabla donde se almacena
⚠️ EXEC [dbo].[PA_LE_BALANCE39] '0004', '2023', '04'
✅ EXEC [dbo].[PA_LE_BALANCE311] '0004', '2023', '04'
✅ EXEC [dbo].[PA_LE_BALANCE312] '0004', '2023', '04'
EXEC [dbo].[PA_LE_BALANCE313] '0004', '2023', '04'
EXEC [dbo].[PA_LE_BALANCE314] '0004', '2023', '04'

EXEC [dbo].[PA_LE_BALANCE315] '0004', '2023', '04'
EXEC [dbo].[PA_LE_BALANCE3161] '0004', '2023', '04'
EXEC [dbo].[PA_LE_BALANCE3162] '0004', '2023', '04'
EXEC [dbo].[PA_LE_BALANCE317] '0004', '2023', '04'
-- EXEC [dbo].[PA_LE_BALANCE318] '0004', '2023', '04' -- => otro metodo
-- EXEC [dbo].[PA_LE_BALANCE319] '0004', '2023', '04' -- => otro metodo
EXEC [dbo].[PA_LE_BALANCE320] '0004', '2023', '04'
-- EXEC [dbo].[PA_LE_BALANCE323] '0004', '2023', '04' -- => otro metodo
-- EXEC [dbo].[PA_LE_BALANCE324] '0004', '2023', '04' -- => otro metodo
-- EXEC [dbo].[PA_LE_BALANCE325] '0004', '2023', '04' -- => otro metodo


-- =========================================================================
-- DIARIO
EXEC SP_GENERA_DIARIO '0004', '2023', '01','01'
-- Detalle plan contable 

-- =========================================================================
-- MAYOR
EXEC SP_GENERA_DIARIO '0004', '2023', '01','01'


EXEC SP_REGISTRO_COMPRAS_REP '004','01','2023'
EXEC SP_GENERA_VENTAS '0004','2023','01'
EXEC SP_registroComprasNoDom_REP '0004','001','2023'


PA - boton apertura nuevo año
PA - (OK) revision de aprobaciones y alertas
<!-- PA - emitir PLE de 2023 y validarlo por el app PLE, menos RC RV -->
<!-- PA - revisar reporte de resumen de tesoreria -->
PA - (OK) Actualizar list de reporte, leer campo Configuracion.DiccionarioReporte.VistaOrden
PA - (OK) validar la creacion de un nuevo reporte personalizado para un nuevo usuario
PA - (OK) agregar en generadiccionario, script de insert o update de actualizacion de cuentas o cencos para los reportes 
PA - (OK) agregar campo con el nombre del reporte en - mantenimiento del configurador de cuentas


SELECT * FROM CT0032ANEX -- Anexos
SELECT * FROM CT0032CICA --
SELECT * FROM CT0032CIDE --
SELECT * FROM CT0032CONT21 --
SELECT * FROM CT0032DOCR -- Comprobante
SELECT * FROM CT0032PLEM -- Plan de cuentas
SELECT * FROM CT0032RUBM -- 
SELECT * FROM CT0032TAGE -- Tabla General
SELECT * FROM CT0032TRAE --
SELECT * FROM CTA04 -- Indice de tablas










