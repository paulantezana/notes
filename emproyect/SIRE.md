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
    , @DestinationTable = 'Financiero.SireTxtPropuesta'
  END

  IF @CodigoTipoProcesoSunatElectronico = 'DCL' -- DECLARADO
  BEGIN
    EXEC [Financiero].[usp_UpdateBulkTxtSunatElectronicoPeriodo]
      @IdCompania  = @IdCompania
    , @RutaCompletaArchivo = @RutaArchivo
    , @IdSunatElectronicoPeriodo = @IdSunatElectronicoPeriodo
    , @IdSunatElectronicoPeriodoVersion = @IdSunatElectronicoPeriodoVersion
    , @DestinationTable = 'Financiero.SireTxtDeclarado'
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
CREATE TABLE Financiero.SireTxtGenerado (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Codigo VARCHAR(12) NOT NULL,

    IdCompania INT NOT NULL,
    IdSunatElectronicoPeriodo INT,
    CodigoAnioPeriodo VARCHAR(12) NOT NULL,
    CampoClave VARCHAR(64) NOT NULL,

    TXT1 VARCHAR(MAX),   
    TXT2 VARCHAR(MAX),   
    TXT3 VARCHAR(MAX),   
    TXT4 VARCHAR(MAX),   
    TXT5 VARCHAR(MAX),   
    TXT6 VARCHAR(MAX),
    TXT7 VARCHAR(MAX),
    TXT8 VARCHAR(MAX),
    TXT9 VARCHAR(MAX),
    TXT10 VARCHAR(MAX),
    TXT11 VARCHAR(MAX),
    TXT12 VARCHAR(MAX),
    TXT13 VARCHAR(MAX),
    TXT14 VARCHAR(MAX),
    TXT15 VARCHAR(MAX),
    TXT16 VARCHAR(MAX),
    TXT17 VARCHAR(MAX),
    TXT18 VARCHAR(MAX),
    TXT19 VARCHAR(MAX),
    TXT20 VARCHAR(MAX),
    TXT21 VARCHAR(MAX),
    TXT22 VARCHAR(MAX),
    TXT23 VARCHAR(MAX),
    TXT24 VARCHAR(MAX),
    TXT25 VARCHAR(MAX),
    TXT26 VARCHAR(MAX),
    TXT27 VARCHAR(MAX),
    TXT28 VARCHAR(MAX),
    TXT29 VARCHAR(MAX),
    TXT30 VARCHAR(MAX),
    TXT31 VARCHAR(MAX),
    TXT32 VARCHAR(MAX),
    TXT33 VARCHAR(MAX),
    TXT34 VARCHAR(MAX),
    TXT35 VARCHAR(MAX),
    TXT36 VARCHAR(MAX),
    TXT37 VARCHAR(MAX),
    TXT38 VARCHAR(MAX),
    TXT39 VARCHAR(MAX),
    TXT40 VARCHAR(MAX),
    TXT41 VARCHAR(MAX),
    TXT42 VARCHAR(MAX),
    TXT43 VARCHAR(MAX),
    TXT44 VARCHAR(MAX),
    TXT45 VARCHAR(MAX),
    TXT46 VARCHAR(MAX),
    TXT47 VARCHAR(MAX),
    TXT48 VARCHAR(MAX),
    TXT49 VARCHAR(MAX),
    TXT50 VARCHAR(MAX),
    TXT51 VARCHAR(MAX),
    TXT52 VARCHAR(MAX),
    TXT53 VARCHAR(MAX),
    TXT54 VARCHAR(MAX),
    TXT55 VARCHAR(MAX),
    TXT56 VARCHAR(MAX),
    TXT57 VARCHAR(MAX),
    TXT58 VARCHAR(MAX),
    TXT59 VARCHAR(MAX),
    TXT60 VARCHAR(MAX),
    TXT61 VARCHAR(MAX),
    TXT62 VARCHAR(MAX),
    TXT63 VARCHAR(MAX),
    TXT64 VARCHAR(MAX),
    TXT65 VARCHAR(MAX),
    TXT66 VARCHAR(MAX),
    TXT67 VARCHAR(MAX),
    TXT68 VARCHAR(MAX),
    TXT69 VARCHAR(MAX),
    TXT70 VARCHAR(MAX),
    TXT71 VARCHAR(MAX),
    TXT72 VARCHAR(MAX),
    TXT73 VARCHAR(MAX),
    TXT74 VARCHAR(MAX),
    TXT75 VARCHAR(MAX),
    TXT76 VARCHAR(MAX),
    TXT77 VARCHAR(MAX),
    TXT78 VARCHAR(MAX),
    TXT79 VARCHAR(MAX),
    TXT80 VARCHAR(MAX),
    TXT81 VARCHAR(MAX),
    TXT82 VARCHAR(MAX),
    TXT83 VARCHAR(MAX),
    TXT84 VARCHAR(MAX),
    TXT85 VARCHAR(MAX),
    TXT86 VARCHAR(MAX),
    TXT87 VARCHAR(MAX),
    TXT88 VARCHAR(MAX),
    TXT89 VARCHAR(MAX),
    TXT90 VARCHAR(MAX),
    TXT91 VARCHAR(MAX),
    TXT92 VARCHAR(MAX),
    TXT93 VARCHAR(MAX),
    TXT94 VARCHAR(MAX),
    TXT95 VARCHAR(MAX),
    TXT96 VARCHAR(MAX),
    TXT97 VARCHAR(MAX),
    TXT98 VARCHAR(MAX),
    TXT99 VARCHAR(MAX),
    TXT100 VARCHAR(MAX)
)
```




```sql

-- SireTxtPropuesta
CREATE TABLE Financiero.SireTxtPropuesta (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Codigo VARCHAR(12) NOT NULL,

    IdCompania INT NOT NULL,
    IdSunatElectronicoPeriodo INT NOT NULL,
    IdSunatElectronicoPeriodoVersion INT NOT NULL,
    CodigoAnioPeriodoDeclarado VARCHAR(12) NOT NULL,
    CampoClave VARCHAR(64),

    Col1 VARCHAR(MAX),   
    Col2 VARCHAR(MAX),   
    Col3 VARCHAR(MAX),   
    Col4 VARCHAR(MAX),   
    Col5 VARCHAR(MAX),   
    Col6 VARCHAR(MAX),
    Col7 VARCHAR(MAX),
    Col8 VARCHAR(MAX),
    Col9 VARCHAR(MAX),
    Col10 VARCHAR(MAX),
    Col11 VARCHAR(MAX),
    Col12 VARCHAR(MAX),
    Col13 VARCHAR(MAX),
    Col14 VARCHAR(MAX),
    Col15 VARCHAR(MAX),
    Col16 VARCHAR(MAX),
    Col17 VARCHAR(MAX),
    Col18 VARCHAR(MAX),
    Col19 VARCHAR(MAX),
    Col20 VARCHAR(MAX),
    Col21 VARCHAR(MAX),
    Col22 VARCHAR(MAX),
    Col23 VARCHAR(MAX),
    Col24 VARCHAR(MAX),
    Col25 VARCHAR(MAX),
    Col26 VARCHAR(MAX),
    Col27 VARCHAR(MAX),
    Col28 VARCHAR(MAX),
    Col29 VARCHAR(MAX),
    Col30 VARCHAR(MAX),
    Col31 VARCHAR(MAX),
    Col32 VARCHAR(MAX),
    Col33 VARCHAR(MAX),
    Col34 VARCHAR(MAX),
    Col35 VARCHAR(MAX),
    Col36 VARCHAR(MAX),
    Col37 VARCHAR(MAX),
    Col38 VARCHAR(MAX),
    Col39 VARCHAR(MAX),
    Col40 VARCHAR(MAX),
    Col41 VARCHAR(MAX),
    Col42 VARCHAR(MAX),
    Col43 VARCHAR(MAX),
    Col44 VARCHAR(MAX),
    Col45 VARCHAR(MAX),
    Col46 VARCHAR(MAX),
    Col47 VARCHAR(MAX),
    Col48 VARCHAR(MAX),
    Col49 VARCHAR(MAX),
    Col50 VARCHAR(MAX),
    Col51 VARCHAR(MAX),
    Col52 VARCHAR(MAX),
    Col53 VARCHAR(MAX),
    Col54 VARCHAR(MAX),
    Col55 VARCHAR(MAX),
    Col56 VARCHAR(MAX),
    Col57 VARCHAR(MAX),
    Col58 VARCHAR(MAX),
    Col59 VARCHAR(MAX),
    Col60 VARCHAR(MAX),
    Col61 VARCHAR(MAX),
    Col62 VARCHAR(MAX),
    Col63 VARCHAR(MAX),
    Col64 VARCHAR(MAX),
    Col65 VARCHAR(MAX),
    Col66 VARCHAR(MAX),
    Col67 VARCHAR(MAX),
    Col68 VARCHAR(MAX),
    Col69 VARCHAR(MAX),
    Col70 VARCHAR(MAX),
    Col71 VARCHAR(MAX),
    Col72 VARCHAR(MAX),
    Col73 VARCHAR(MAX),
    Col74 VARCHAR(MAX),
    Col75 VARCHAR(MAX),
    Col76 VARCHAR(MAX),
    Col77 VARCHAR(MAX),
    Col78 VARCHAR(MAX),
    Col79 VARCHAR(MAX),
    Col80 VARCHAR(MAX),
    Col81 VARCHAR(MAX),
    Col82 VARCHAR(MAX),
    Col83 VARCHAR(MAX),
    Col84 VARCHAR(MAX),
    Col85 VARCHAR(MAX),
    Col86 VARCHAR(MAX),
    Col87 VARCHAR(MAX),
    Col88 VARCHAR(MAX),
    Col89 VARCHAR(MAX),
    Col90 VARCHAR(MAX),
    Col91 VARCHAR(MAX),
    Col92 VARCHAR(MAX),
    Col93 VARCHAR(MAX),
    Col94 VARCHAR(MAX),
    Col95 VARCHAR(MAX),
    Col96 VARCHAR(MAX),
    Col97 VARCHAR(MAX),
    Col98 VARCHAR(MAX),
    Col99 VARCHAR(MAX),
    Col100 VARCHAR(MAX)
)
```



  DECLARE @IdSunatElectronicoPeriodo INT = 91980;   
  DECLARE @PeriodoInicio VARCHAR(6) = '202201';
  DECLARE @Usuario VARCHAR(6) = 'Admin';
  DECLARE @SistemaOrigen VARCHAR(30) = 'CONCAR';  


    -- //   
  DECLARE @IdCompania INT;
  DECLARE @CodigoSunatElectronico VARCHAR(12);
  DECLARE @PeriodoInicioLocal VARCHAR(6);
  DECLARE @PeriodoFin VARCHAR(6);
  DECLARE @AnioInicio INT;
  DECLARE @AnioFin INT;

  -- //
  DECLARE @i INT = 0;
  DECLARE @QuerySQL NVARCHAR(MAX) = '';
  DECLARE @ColumnListSQL NVARCHAR(MAX) = '';
  DECLARE @NumeroColumnas INT;

  -- SET LOCAL VARS
  SET @PeriodoInicioLocal = @PeriodoInicio;

  SELECT   
    @IdCompania = IdCompania   
    , @CodigoSunatElectronico = CodigoSunatElectronico   
    , @PeriodoFin = CodigoAnioPeriodo   
    , @AnioFin = LEFT(CodigoAnioPeriodo,4)   
  FROM Financiero.ViewSunatElectronicoPeriodo WHERE Id = @IdSunatElectronicoPeriodo;   



  SELECT @NumeroColumnas = TxtDeclaradoNumCols FROM Configuracion.SunatElectronico WHERE Id = 27;


  -- ==================================================================
  -- G E N E R A     L A S     C O L U M N A S
  SET @i = 1;
  SET @ColumnListSQL = '';
  WHILE @i <= @NumeroColumnas
  BEGIN
      SET @ColumnListSQL += 'Col' + CAST(@i AS NVARCHAR(3));
      IF @i < @NumeroColumnas SET @ColumnListSQL += ', ';
      SET @i += 1;
  END

  -- ==================================================================
  -- C R E A R     T A B L A    D E C L A R A D O
  DROP TABLE IF EXISTS #SeDeclarado;
  CREATE TABLE #SeDeclarado (
    IdCompania INT NOT NULL,
    CodigoAnioPeriodoDeclarado VARCHAR(12) NOT NULL,
  )

  SET @i = 1;
  SET @QuerySQL = '';
  WHILE @i <= @NumeroColumnas
  BEGIN
      SET @QuerySQL += 'ALTER TABLE #SeDeclarado ADD Col' + CAST(@i AS NVARCHAR(3)) + ' NVARCHAR(4000);';
      SET @i += 1;
  END
  EXEC sp_executesql @QuerySQL;

  -- ==================================================================
  -- O B T E N E R         D A T O S       D E C L A R A D O S
  SET @QuerySQL = '
    INSERT INTO #SeDeclarado (IdCompania, CodigoAnioPeriodoDeclarado, ' + @ColumnListSQL + ')
    SELECT IdCompania, CodigoAnioPeriodoDeclarado, ' + @ColumnListSQL + ' FROM Financiero.SireTxtDeclarado 
    WHERE IdCompania = ' + CONVERT(varchar, @IdCompania) + '
      AND CodigoAnioPeriodoDeclarado >= ' + @PeriodoInicioLocal +'   
      AND CodigoAnioPeriodoDeclarado < ' + @PeriodoFin + '
  '
  EXEC sp_executesql @QuerySQL;



  -- ==================================================================
  -- C R E A R     T A B L A    C O R R E G I D O
  DROP TABLE IF EXISTS #SeCorregido;
  CREATE TABLE #SeCorregido (
    IdCompania INT NOT NULL,
    CodigoAnioPeriodoDeclarado VARCHAR(12) NOT NULL,
  )

  SET @i = 1;
  SET @QuerySQL = '';
  WHILE @i <= @NumeroColumnas
  BEGIN
      SET @QuerySQL += 'ALTER TABLE #SeCorregido ADD Col' + CAST(@i AS NVARCHAR(3)) + ' NVARCHAR(4000);';
      SET @i += 1;
  END
  EXEC sp_executesql @QuerySQL;

  -- ==================================================================
  -- G E N E R A R     C O R R E G I D O
  DECLARE @ColumnClaveListSQL VARCHAR(200) = 'Col1, Col2';
  DECLARE @ColumnPeriodoSQL VARCHAR(200) = 'Col1';

  SET @QuerySQL = '
    SELECT Fila, ' + @ColumnListSQL + '
    FROM (   
        SELECT
          Fila = ROW_NUMBER() OVER(PARTITION BY ' + @ColumnClaveListSQL + ' ORDER BY ' + @ColumnClaveListSQL + ', CodigoAnioPeriodoDeclarado DESC)   
          , ' + @ColumnListSQL + '
        FROM #SeCorregido  
        WHERE LEFT('+@ColumnPeriodoSQL+',6) BETWEEN @PeriodoInicioLocal AND @PeriodoFin
    ) t
    WHERE Fila = 1
  ';


  -- ==================================================================
  -- L I M P I A R   C O L U M N A S
    SET @i = 1;
  SET @QuerySQL = '';
  WHILE @i <= @NumeroColumnas
  BEGIN
      SET @QuerySQL += 'ALTER TABLE #SeDeclarado ADD Col' + CAST(@i AS NVARCHAR(3)) + ' NVARCHAR(4000);';
      SET @i += 1;
  END
  EXEC sp_executesql @QuerySQL;







  --WHERE IdCompania = @IdCompania
  --AND SistemaOrigen = @SistemaOrigen
  --;




--    SET @QuerySQL = '
--    INSERT INTO ' + @DestinationTable + ' (Codigo, IdCompania, IdSunatElectronicoPeriodo, IdSunatElectronicoPeriodoVersion, CodigoAnioPeriodoDeclarado, ' + @ColumnListSQL + ')
--    SELECT ''' + @CodigoSunatElectronico + ''', ' +CONVERT(varchar, @IdCompania) + ', ' + CONVERT(varchar, @IdSunatElectronicoPeriodo) + ', ' + CONVERT(varchar, @IdSunatElectronicoPeriodoVersion) + ', ''' + @CodigoAnioPeriodo + ''', ' + @ColumnListSQL + '
--    FROM #TempoTxtExtraido
--    ';







--Financiero.SireTxtDeclarado