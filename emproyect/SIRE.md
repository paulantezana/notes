[Financiero].[usp_InsertarSunatElectronicoPeriodoVersion]

Financiero.usp_cargarTxtSunatElectronicoPeriodoVersion



# Actualiza Numero de columnas
Actualiza numero de columnas de TXT declarados y propuesta en la base de datos en la tabla Configuracion.SunatElectronico
```sql
DECLARE @IdSunatElectronico INT;
DECLARE @CodigoTipoProcesoSunatElectronico VARCHAR(32);
DECLARE @RutaArchivo NVARCHAR(800);
DECLARE @ResultTable TABLE (Output NVARCHAR(4000));

DROP TABLE IF EXISTS #TablaData;
SELECT IdSunatElectronico, CodigoTipoProcesoSunatElectronico, RutaArchivo = MAX(RutaArchivo) INTO #TablaData FROM (
  SELECT
    IdSunatElectronico = se.IdSunatElectronico
    , CodigoTipoProcesoSunatElectronico
    , RutaArchivo = '\\192.168.33.206' + REPLACE('/BACKOFFICE-DOCUMENTOS-WEB/' + UbicacionArchivo + Archivo, '/','\')
  FROM (
    SELECT *, MaximoNumeroProceso = MAX(NumeroProceso) OVER(PARTITION BY IdSunatElectronicoPeriodo)
    FROM Financiero.ViewSunatElectronicoPeriodoVersion
    WHERE CodigoTipoProcesoSunatElectronico IN ('PPT', 'DCL') AND SistemaOrigen = 'CONCAR'
  ) AS vs
  INNER JOIN Financiero.SunatElectronicoPeriodo as se ON vs.IdSunatElectronicoPeriodo =  se.Id
  WHERE MaximoNumeroProceso = NumeroProceso
) AS ctb
GROUP BY IdSunatElectronico, CodigoTipoProcesoSunatElectronico

DECLARE Cursor_SunatElectronicoPeriodo CURSOR FOR
SELECT IdSunatElectronico, RutaArchivo, CodigoTipoProcesoSunatElectronico FROM #TablaData;

OPEN Cursor_SunatElectronicoPeriodo                                                  
FETCH NEXT FROM Cursor_SunatElectronicoPeriodo INTO @IdSunatElectronico, @RutaArchivo, @CodigoTipoProcesoSunatElectronico;
    
WHILE @@FETCH_STATUS = 0                                     
BEGIN

  DECLARE @NumeroColumnas INT;
  DECLARE @cmd VARCHAR(8000);

  DELETE FROM @ResultTable;

  SET @cmd = 'powershell -command "(Get-Content ''' + @RutaArchivo + ''' -First 1) | ForEach-Object {($_ -split ''\|'').Length}"';
  INSERT INTO @ResultTable (Output)
  EXEC xp_cmdshell @cmd;
 
  SELECT TOP 1 @NumeroColumnas = CAST(Output AS INT) FROM @ResultTable WHERE Output IS NOT NULL;

  IF @CodigoTipoProcesoSunatElectronico = 'PPT' -- PROPUESTA
    UPDATE Configuracion.SunatElectronico SET  TxtPropuestaNumCols = @NumeroColumnas, TxtPropuestaTieneEncabezado = 'S' WHERE Id = @IdSunatElectronico
  IF @CodigoTipoProcesoSunatElectronico = 'DCL' -- DECLARADO
    UPDATE Configuracion.SunatElectronico SET  TxtDeclaradoNumCols = @NumeroColumnas, TxtDeclaradoTieneEncabezado = 'N' WHERE Id = @IdSunatElectronico
  -- NEXT  
  FETCH NEXT FROM Cursor_SunatElectronicoPeriodo INTO @IdSunatElectronico, @RutaArchivo, @CodigoTipoProcesoSunatElectronico;
END

CLOSE Cursor_SunatElectronicoPeriodo;                                                    
DEALLOCATE Cursor_SunatElectronicoPeriodo;
```


# Importar Data De TXT
Importar la data desde los archivos TXT
```sql
DECLARE @IdCompania INT;
DECLARE @RutaArchivo NVARCHAR(800);
DECLARE @IdSunatElectronicoPeriodo INT;
DECLARE @IdSunatElectronicoPeriodoVersion INT;
DECLARE @CodigoTipoProcesoSunatElectronico VARCHAR(32)

DROP TABLE IF EXISTS #TablaData;
SELECT
  CodigoTipoProcesoSunatElectronico
  , se.IdCompania
  , se.CodigoAnioPeriodo
  , se.CodigoSunatElectronico
  , vs.IdSunatElectronicoPeriodo
  , IdSunatElectronicoPeriodoVersion = vs.Id
  , RutaArchivo = '\\192.168.33.206' + REPLACE('/BACKOFFICE-DOCUMENTOS-WEB/' + UbicacionArchivo + Archivo, '/','\')
  INTO #TablaData
FROM (
  SELECT *, MaximoNumeroProceso = MAX(NumeroProceso) OVER(PARTITION BY IdSunatElectronicoPeriodo)
  FROM Financiero.ViewSunatElectronicoPeriodoVersion
  WHERE CodigoTipoProcesoSunatElectronico IN ('PPT', 'DCL') AND SistemaOrigen = 'CONCAR'
) AS vs
INNER JOIN Financiero.ViewSunatElectronicoPeriodo as se ON vs.IdSunatElectronicoPeriodo =  se.Id
WHERE MaximoNumeroProceso = NumeroProceso


DECLARE Cursor_SunatElectronicoPeriodoImportar CURSOR FOR
SELECT IdCompania, RutaArchivo, IdSunatElectronicoPeriodo, IdSunatElectronicoPeriodoVersion, CodigoTipoProcesoSunatElectronico FROM #TablaData;

OPEN Cursor_SunatElectronicoPeriodoImportar                                                  
FETCH NEXT FROM Cursor_SunatElectronicoPeriodoImportar INTO @IdCompania, @RutaArchivo, @IdSunatElectronicoPeriodo, @IdSunatElectronicoPeriodoVersion, @CodigoTipoProcesoSunatElectronico;


WHILE @@FETCH_STATUS = 0                                     
BEGIN

  IF @CodigoTipoProcesoSunatElectronico = 'PPT' -- PROPUESTA
  BEGIN
    EXEC [Financiero].[usp_UpdateBulkTxtSunatElectronicoPeriodo]
      @IdCompania  = @IdCompania
    , @RutaCompletaArchivo = @RutaArchivo
    , @IdSunatElectronicoPeriodo = @IdSunatElectronicoPeriodo
    , @IdSunatElectronicoPeriodoVersion = @IdSunatElectronicoPeriodoVersion
    , @DestinationTable = 'Financiero.SunatElectronicoTxtPropuestaSunat'
  END

  IF @CodigoTipoProcesoSunatElectronico = 'DCL' -- DECLARADO
  BEGIN
    EXEC [Financiero].[usp_UpdateBulkTxtSunatElectronicoPeriodo]
      @IdCompania  = @IdCompania
    , @RutaCompletaArchivo = @RutaArchivo
    , @IdSunatElectronicoPeriodo = @IdSunatElectronicoPeriodo
    , @IdSunatElectronicoPeriodoVersion = @IdSunatElectronicoPeriodoVersion
    , @DestinationTable = 'Financiero.SunatElectronicoTxtDeclarado'
  END

  -- NEXT  
  FETCH NEXT FROM Cursor_SunatElectronicoPeriodoImportar INTO @IdCompania, @RutaArchivo, @IdSunatElectronicoPeriodo, @IdSunatElectronicoPeriodoVersion, @CodigoTipoProcesoSunatElectronico;
END

CLOSE Cursor_SunatElectronicoPeriodoImportar;                                                    
DEALLOCATE Cursor_SunatElectronicoPeriodoImportar;
```


<!-- # Se descarga manualmente o por la API
Financiero.SE_txt_propuesta


# Se Cargar con sotre procedure o subiendo TXT
Financiero.SE_txt_generado


# Se suben los archivos
Financiero.SE_txt_declarado
Financiero.SE_xple_declarado


# Rectificatoria Corregido Con estados ultimos  correctos
Financiero.SE_txt_rectifica_corregido
Financiero.SE_txt_rectifica_reporte


# Propuesta 
Financiero.SE_txt_propuesta_reporte -->




```sql

-- Financiero.SunatElectronicoTxtDeclarado
-- Financiero.SunatElectronicoTxtGenerado
-- Financiero.SunatElectronicoTxtPropuestaSunat
CREATE TABLE Financiero.SunatElectronicoTxtCargado (
  Id INT IDENTITY(1,1) PRIMARY KEY,
  Codigo VARCHAR(12) NOT NULL,

  IdCompania INT NOT NULL,
  IdSunatElectronico INT,
  IdSunatElectronicoPeriodo INT,
  CodigoAnioPeriodo VARCHAR(12) NOT NULL,

  Col1 VARCHAR(255),   
  Col2 VARCHAR(255),   
  Col3 VARCHAR(255),   
  Col4 VARCHAR(255),   
  Col5 VARCHAR(255),   
  Col6 VARCHAR(255),
  Col7 VARCHAR(255),
  Col8 VARCHAR(255),
  Col9 VARCHAR(255),
  Col10 VARCHAR(255),
  Col11 VARCHAR(255),
  Col12 VARCHAR(255),
  Col13 VARCHAR(255),
  Col14 VARCHAR(255),
  Col15 VARCHAR(255),
  Col16 VARCHAR(255),
  Col17 VARCHAR(255),
  Col18 VARCHAR(255),
  Col19 VARCHAR(255),
  Col20 VARCHAR(255),
  Col21 VARCHAR(255),
  Col22 VARCHAR(255),
  Col23 VARCHAR(255),
  Col24 VARCHAR(255),
  Col25 VARCHAR(255),
  Col26 VARCHAR(255),
  Col27 VARCHAR(255),
  Col28 VARCHAR(255),
  Col29 VARCHAR(255),
  Col30 VARCHAR(255),
  Col31 VARCHAR(255),
  Col32 VARCHAR(255),
  Col33 VARCHAR(255),
  Col34 VARCHAR(255),
  Col35 VARCHAR(255),
  Col36 VARCHAR(255),
  Col37 VARCHAR(255),
  Col38 VARCHAR(255),
  Col39 VARCHAR(255),
  Col40 VARCHAR(255),
  Col41 VARCHAR(255),
  Col42 VARCHAR(255),
  Col43 VARCHAR(255),
  Col44 VARCHAR(255),
  Col45 VARCHAR(255),
  Col46 VARCHAR(255),
  Col47 VARCHAR(255),
  Col48 VARCHAR(255),
  Col49 VARCHAR(255),
  Col50 VARCHAR(255),
  Col51 VARCHAR(255),
  Col52 VARCHAR(255),
  Col53 VARCHAR(255),
  Col54 VARCHAR(255),
  Col55 VARCHAR(255),
  Col56 VARCHAR(255),
  Col57 VARCHAR(255),
  Col58 VARCHAR(255),
  Col59 VARCHAR(255),
  Col60 VARCHAR(255),
  Col61 VARCHAR(255),
  Col62 VARCHAR(255),
  Col63 VARCHAR(255),
  Col64 VARCHAR(255),
  Col65 VARCHAR(255),
  Col66 VARCHAR(255),
  Col67 VARCHAR(255),
  Col68 VARCHAR(255),
  Col69 VARCHAR(255),
  Col70 VARCHAR(255),
  Col71 VARCHAR(255),
  Col72 VARCHAR(255),
  Col73 VARCHAR(255),
  Col74 VARCHAR(255),
  Col75 VARCHAR(255),
  Col76 VARCHAR(255),
  Col77 VARCHAR(255),
  Col78 VARCHAR(255),
  Col79 VARCHAR(255),
  Col80 VARCHAR(255),
  Col81 VARCHAR(255),
  Col82 VARCHAR(255),
  Col83 VARCHAR(255),
  Col84 VARCHAR(255),
  Col85 VARCHAR(255),
  Col86 VARCHAR(255),
  Col87 VARCHAR(255),
  Col88 VARCHAR(255),
  Col89 VARCHAR(255),
  Col90 VARCHAR(255),
  Col91 VARCHAR(255),
  Col92 VARCHAR(255),
  Col93 VARCHAR(255),
  Col94 VARCHAR(255),
  Col95 VARCHAR(255),
  Col96 VARCHAR(255),
  Col97 VARCHAR(255),
  Col98 VARCHAR(255),
  Col99 VARCHAR(255),
  Col100 VARCHAR(255),

  Fila INT NOT NULL,
  Txt VARCHAR(2000),

  CONSTRAINT FK_SunatElectronicoTxtCargado_EntidadCompania FOREIGN KEY (IdCompania) 
    REFERENCES Maestros.EntidadCompania (Id),

  CONSTRAINT FK_SunatElectronicoTxtCargado_SunatElectronico FOREIGN KEY (IdSunatElectronico) 
    REFERENCES Configuracion.SunatElectronico (Id),

  CONSTRAINT FK_SunatElectronicoTxtCargado_SunatElectronicoPeriodo FOREIGN KEY (IdSunatElectronicoPeriodo) 
    REFERENCES Financiero.SunatElectronicoPeriodo (Id)
)
```



DATA
```
SET @ColumnListIsNull +=       'Col' + CAST(@i AS NVARCHAR(3)) + ' = ISNULL(TRIM(REPLACE(REPLACE(REPLACE(' +
    'TRANSLATE(Col' + CAST(@i AS NVARCHAR(3)) + ', ''' + @CaracteresDeTipoEspacio + ''', REPLICATE(CHAR(32), LEN(''' + @CaracteresDeTipoEspacio + ''')))' +
  ', CHAR(32), ''<>''), ''><'', ''''), ''<>'', CHAR(32))), '''')';
```