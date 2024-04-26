COMPARA ARCHIVOS: https://www.ddginc-usa.com/

181.224.226.108 // 192.168.33.206
aplicaciones
appEMMM$14

REPORTE
valorizador
Password$


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




-- =========================================================================
-- CAJA    Y     BANCOS
EXEC SP_GENERA_CAJA '0004', '2023', '04'

-- =========================================================================
-- INVENTARIO    Y     BALANCES
EXEC [dbo].[PA_LE_BALANCE31] '0004', '2023', '04'
EXEC [dbo].[PA_LE_BALANCE32] '0004', '2023', '04'
EXEC [dbo].[PA_LE_BALANCE33] '0004', '2023', '04'
EXEC [dbo].[PA_LE_BALANCE34] '0004', '2023', '04'
EXEC [dbo].[PA_LE_BALANCE35] '0004', '2023', '04'
EXEC [dbo].[PA_LE_BALANCE36] '0004', '2023', '04'
-- EXEC [dbo].[PA_LE_BALANCE37] '0004', '2023', '04' -- => otro metodo
-- EXEC [dbo].[PA_LE_BALANCE38] '0004', '2023', '04' -- => otro metodo
EXEC [dbo].[PA_LE_BALANCE39] '0004', '2023', '04'
EXEC [dbo].[PA_LE_BALANCE311] '0004', '2023', '04'
EXEC [dbo].[PA_LE_BALANCE312] '0004', '2023', '04'
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
PA - (OK) revision de pivot no funciona el hipervinculo de consulta
PA - (OK) revision de distribucoin de costos
PA - (OK) revision de aprobaciones y alertas
PA - reporte dataset para desa y test
PA - (OK) desarrollar conexion pivot a pivot
PA - emitir PLE de 2023 y validarlo por el app PLE, menos RC RV
PA - (OK) cambiar formato de valores numericos de miles(.)decimales(,)















DROP TABLE Configuracion.SunatElectronico;
DROP TABLE Configuracion.TipoSunatElectronico;

GO

CREATE TABLE Configuracion.TipoProcesoSunatElectronico(
    Id int IDENTITY(1,1) PRIMARY KEY NOT NULL,
    Codigo varchar(12) NULL,
    Descripcion varchar(200) NULL,
    UbicacionArchivo  varchar(200) NULL,

    AplicativoCreacion varchar(30) NULL,
    OpcionCreacion varchar(30) NULL,
    FechaCreacion datetime NULL,
    UsuarioCreacion varchar(30) NULL,
    AplicativoEdicion varchar(30) NULL,
    OpcionEdicion varchar(30) NULL,
    FechaEdicion datetime NULL,
    UsuarioEdicion varchar(30) NULL,
    IdNota int NULL,
    TStamp timestamp NOT NULL,
)

GO
CREATE TABLE Configuracion.TipoSunatElectronico(
    Id int IDENTITY(1,1) PRIMARY KEY NOT NULL,
    Codigo varchar(12) NULL,
    Descripcion varchar(200) NULL,
    UbicacionPropuesta varchar(200) NULL,
    UbicacionDeclarado varchar(200) NULL,
    UbicacionGenerado varchar(200) NULL,

    AplicativoCreacion varchar(30) NULL,
    OpcionCreacion varchar(30) NULL,
    FechaCreacion datetime NULL,
    UsuarioCreacion varchar(30) NULL,
    AplicativoEdicion varchar(30) NULL,
    OpcionEdicion varchar(30) NULL,
    FechaEdicion datetime NULL,
    UsuarioEdicion varchar(30) NULL,
    IdNota int NULL,
    TStamp timestamp NOT NULL,
);

GO

INSERT INTO Configuracion.TipoSunatElectronico
(Codigo, Descripcion, UbicacionPropuesta, UbicacionDeclarado, UbicacionGenerado)
VALUES ('PLE', 'Programa de Libros Electrónicos', '', '', '')
, ('SIRE', 'Sistema Integrado de Registros Electrónicos', '', '', '');

GO

CREATE TABLE Configuracion.SunatElectronico (
    Id int IDENTITY(1,1) PRIMARY KEY NOT NULL,
    Codigo varchar(12) NULL,
    Descripcion varchar(200) NULL,
    RDL VARCHAR(32) NULL,
    OportunidadPresentacion CHAR NULL,

    IdTipoSunatElectronico INT NOT NULL,

    AplicativoCreacion varchar(30) NULL,
    OpcionCreacion varchar(30) NULL,
    FechaCreacion datetime NULL,
    UsuarioCreacion varchar(30) NULL,
    AplicativoEdicion varchar(30) NULL,
    OpcionEdicion varchar(30) NULL,
    FechaEdicion datetime NULL,
    UsuarioEdicion varchar(30) NULL,
    IdNota int NULL,
    TStamp timestamp NOT NULL,

    FOREIGN KEY (IdTipoSunatElectronico) REFERENCES Configuracion.TipoSunatElectronico(Id)
)
GO
INSERT INTO Configuracion.SunatElectronico (Codigo, Descripcion, RDL, OportunidadPresentacion, IdTipoSunatElectronico)
SELECT Codigo, Descripcion, Reporte, Tipo, IIF(Destino = 'SIRE', 2, 1) FROM Financiero.Ple
GO

CREATE TABLE Financiero.SunatElectronicoPeriodo (
    Id int IDENTITY(1,1) PRIMARY KEY NOT NULL,

    IdSunatElectronico INT NOT NULL,
    IdAnioPeriodo INT NOT NULL,

    FechaUltimoPropuesta DATETIME NULL,
    UsuarioUltimoPropuesta varchar(30) NULL,
    ArchivoUltimoPropuesta varchar(200) NULL,

    FechaUltimoDeclarado DATETIME NULL,
    UsuarioUltimoDeclarado varchar(30) NULL,
    ArchivoUltimoDeclarado varchar(200) NULL,

    FechaUltimoProcesado DATETIME NULL,
    UsuarioUltimoProcesado varchar(30) NULL,
    Observacion varchar(500) NULL,


    FechaUltimoGenerado DATETIME NULL,
    UsuarioUltimoGenerado varchar(30) NULL,
    ArchivoUltimoGenerado varchar(500) NULL,

    AplicativoCreacion varchar(30) NULL,
    OpcionCreacion varchar(30) NULL,
    FechaCreacion datetime NULL,
    UsuarioCreacion varchar(30) NULL,
    AplicativoEdicion varchar(30) NULL,
    OpcionEdicion varchar(30) NULL,
    FechaEdicion datetime NULL,
    UsuarioEdicion varchar(30) NULL,
    IdNota int NULL,
    TStamp timestamp NOT NULL,

    FOREIGN KEY (IdSunatElectronico) REFERENCES Configuracion.SunatElectronico(Id),
    FOREIGN KEY (IdAnioPeriodo) REFERENCES Financiero.AnioPeriodo(Id)
);

GO

INSERT INTO Financiero.SunatElectronicoPeriodo (IdSunatElectronico, IdAnioPeriodo)
SELECT IdSunatElectronico, IdAnioPeriodo FROM (
    SELECT
        CodigoAnioPeriodo = ap.Codigo
        , se.Codigo
        , se.Descripcion
        , ap.IdCompania
        , ap.DescripcionCompania
        , IdSunatElectronico = se.Id
        , IdAnioPeriodo = ap.Id
    FROM Configuracion.SunatElectronico as se
    INNER JOIN Configuracion.TipoSunatElectronico as tse ON se.IdTipoSunatElectronico = tse.id
    CROSS JOIN Financiero.ViewAnioPeriodo as ap
    WHERE RIGHT(ap.Codigo, 2) NOT IN ('00','13') AND tse.Codigo = 'PLE'      
        AND NOT (      
            se.Codigo IN ('140100', '140200', '080100', '080200','080300')          
        ) 
) ps

GO

ALTER VIEW Financiero.ViewSunatElectronicoPeriodo AS 
SELECT
    sep.Id
    , se.Codigo
    , se.Descripcion

    , Reporte = se.RDL

    , vap.CodigoCompania
    , vap.DescripcionCompania

    , CodigoAnioPeriodo = vap.Codigo
    , DescripcionAnioPeriodo = vap.Descripcion

    , CodigoSunatElectronico = se.Codigo
    , DescripcionSunatElectronico = se.Descripcion

    , CodigoTipoSunatElectronico = tse.Codigo
    , DescripcionTipoSunatElectronico = tse.Descripcion

    , sep.FechaUltimoPropuesta
    , sep.UsuarioUltimoPropuesta
    , sep.ArchivoUltimoPropuesta

    , sep.FechaUltimoDeclarado
    , sep.UsuarioUltimoDeclarado
    , sep.ArchivoUltimoDeclarado

    , sep.FechaUltimoProcesado
    , sep.UsuarioUltimoProcesado
    , sep.Observacion

    , sep.FechaUltimoGenerado
    , sep.UsuarioUltimoGenerado
    , sep.ArchivoUltimoGenerado

    , sep.IdSunatElectronico
    , sep.IdAnioPeriodo
    , vap.IdCompania

FROM Financiero.SunatElectronicoPeriodo AS sep (NOLOCK)
INNER JOIN Financiero.ViewAnioPeriodo AS vap (NOLOCK) ON sep.IdAnioPeriodo = vap.Id
INNER JOIN Configuracion.SunatElectronico AS se (NOLOCK) ON sep.IdSunatElectronico = se.Id
INNER JOIN Configuracion.TipoSunatElectronico AS tse (NOLOCK) ON se.IdTipoSunatElectronico = tse.Id
GO

GO

CREATE TABLE Financiero.SunatElectronicoPeriodoVersion (
    Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    
    NumeroProceso INT NULL,
    Fecha datetime NULL,
    Usuario varchar(30) NULL,
    Archivo varchar(200) NULL,
    Observacion varchar(500) NULL,

    IdTipoProcesoSunatElectronico INT NOT NULL,
    IdSunatElectronicoPeriodo INT NOT NULL,

    AplicativoCreacion varchar(30) NULL,
    OpcionCreacion varchar(30) NULL,
    FechaCreacion datetime NULL,
    UsuarioCreacion varchar(30) NULL,
    AplicativoEdicion varchar(30) NULL,
    OpcionEdicion varchar(30) NULL,
    FechaEdicion datetime NULL,
    UsuarioEdicion varchar(30) NULL,
    IdNota int NULL,
    TStamp timestamp NOT NULL,

    FOREIGN KEY (IdTipoProcesoSunatElectronico) REFERENCES Configuracion.TipoProcesoSunatElectronico(Id),
    FOREIGN KEY (IdSunatElectronicoPeriodo) REFERENCES Financiero.SunatElectronicoPeriodo(Id)
)

GO

