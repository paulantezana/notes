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

-- SireTxtPropuesta
-- SireTxtDeclarado
-- SireTxtGenerado
CREATE TABLE Financiero.SunatElectronicoTxtGenerado (
  Id INT IDENTITY(1,1) PRIMARY KEY,
  Codigo VARCHAR(12) NOT NULL,

  IdCompania INT NOT NULL,
  IdSunatElectronicoPeriodo INT,
  IdSunatElectronicoPeriodoVersion INT,
  CodigoAnioPeriodo VARCHAR(12) NOT NULL,

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
  DECLARE @IdSunatElectronicoPeriodo INT = 91980; -- 202312
  DECLARE @PeriodoInicio VARCHAR(6) = '202301';
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
  DECLARE @ColumnList NVARCHAR(MAX) = '';
  DECLARE @ColumnListA NVARCHAR(MAX) = '';
  DECLARE @ColumnListB NVARCHAR(MAX) = '';

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
  SELECT @ColumnList = '', @ColumnListA = '', @ColumnListB = '';
  WHILE @i <= @NumeroColumnas
  BEGIN
      SET @ColumnList += 'Col' + CAST(@i AS NVARCHAR(3));
      SET @ColumnListA += 'Col' + CAST(@i AS NVARCHAR(3)) + '_A';
      SET @ColumnListB += 'Col' + CAST(@i AS NVARCHAR(3)) + '_B';

      IF @i < @NumeroColumnas SELECT @ColumnList += ', ', @ColumnListA += ', ', @ColumnListB += ', ';
      SET @i += 1;
  END


  -- ==================================================================
  -- ==================================================================
  -- D A T A      D E C L A R A D O
  -- ==================================================================
  -- ==================================================================

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
      SET @QuerySQL += 'ALTER TABLE #SeDeclarado ADD Col' + CAST(@i AS NVARCHAR(3)) + '_A NVARCHAR(4000);';
      SET @i += 1;
  END
  EXEC sp_executesql @QuerySQL;

  -- ==================================================================
  -- O B T E N E R         D A T O S       D E C L A R A D O S
  SET @QuerySQL = '
    INSERT INTO #SeDeclarado (IdCompania, CodigoAnioPeriodoDeclarado, ' + @ColumnList + ')
    SELECT IdCompania, CodigoAnioPeriodoDeclarado, ' + @ColumnList + ' FROM Financiero.SireTxtDeclarado 
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
  DECLARE @ColumnPeriodo VARCHAR(200) = 'Col1';
  DECLARE @ColumnClaveList VARCHAR(200) = 'Col1, Col2';
  DECLARE @ColumnDetalleClaveList VARCHAR(200) = 'Col1, Col2, Col3';
  DECLARE @ColumnComparaList VARCHAR(200) = 'Col4, Col5, Col6, Col7, Col8, Col9, Col10, Col11, Col12, Col13, Col14, Col15, Col16, Col17, Col18';

  SET @QuerySQL = '
    INSERT INTO #SeCorregido (IdCompania, CodigoAnioPeriodoDeclarado, ' + @ColumnList + ')
    SELECT IdCompania, CodigoAnioPeriodoDeclarado, ' + @ColumnList + '
    FROM (
        SELECT
          Fila = ROW_NUMBER() OVER(PARTITION BY ' + @ColumnClaveList + ' ORDER BY ' + @ColumnClaveList + ', CodigoAnioPeriodoDeclarado DESC)   
          , IdCompania, CodigoAnioPeriodoDeclarado, ' + @ColumnList + '
        FROM #SeDeclarado 
        WHERE LEFT(' + @ColumnPeriodo + ',6) BETWEEN ' + @PeriodoInicioLocal + ' AND ' + @PeriodoFin + '
    ) t
    WHERE Fila = 1
  ';

  EXEC sp_executesql @QuerySQL;



  -- ==================================================================
  -- ==================================================================
  -- D A T A      E N     E L      S I S T E M A
  -- ==================================================================
  -- ==================================================================


  -- ==================================================================
  -- C R E A R     T A B L A    S I S T E M A
  DROP TABLE IF EXISTS #SeSistema;
  CREATE TABLE #SeSistema (
    IdCompania INT NOT NULL,
    CodigoAnioPeriodo VARCHAR(12) NOT NULL,
  )

  SET @i = 1;
  SET @QuerySQL = '';
  WHILE @i <= @NumeroColumnas
  BEGIN
      SET @QuerySQL += 'ALTER TABLE #SeSistema ADD Col' + CAST(@i AS NVARCHAR(3)) + ' NVARCHAR(4000);';
      SET @i += 1;
  END
  EXEC sp_executesql @QuerySQL;

  -- ==================================================================
  -- O B T E N E R         D A T O S       A C T U A L E S
  SET @QuerySQL = '
    INSERT INTO #SeSistema (IdCompania, CodigoAnioPeriodo, ' + @ColumnList + ')
    SELECT IdCompania, CodigoAnioPeriodo, ' + @ColumnList + ' FROM Financiero.SireTxtGenerado 
    WHERE IdCompania = ' + CONVERT(varchar, @IdCompania) + '
      AND CodigoAnioPeriodo >= ' + @PeriodoInicioLocal +'   
      AND CodigoAnioPeriodo < ' + @PeriodoFin + '
  '
  EXEC sp_executesql @QuerySQL;


  -- ==================================================================
  -- ==================================================================
  -- C O M P A R A
  -- ==================================================================
  -- ==================================================================

  DECLARE @FullJoinConditionSQL NVARCHAR(MAX) = '';
  DECLARE @FullJoinColumnCompareListSQL NVARCHAR(MAX) = '';
  DECLARE @FullJoinColumnClaveListSQL NVARCHAR(MAX) = '';
  DECLARE @FullJoinColumnASQL NVARCHAR(MAX) = '';
  DECLARE @FullJoinColumnBSQL NVARCHAR(MAX) = '';

  DECLARE @FullJoinColumnValidateSQL NVARCHAR(MAX) = '';

  -- Genera Full Join Condicion
  SELECT
    @FullJoinConditionSQL = @FullJoinConditionSQL +
              CASE WHEN @FullJoinConditionSQL = '' THEN '' ELSE ' AND ' END +
              'b.' + value + ' = a.' + value + CHAR(13) + CHAR(10)
  FROM STRING_SPLIT(@ColumnDetalleClaveList, ',')
  WHERE RTRIM(LTRIM(value)) <> '';


  -- Columnas - A
  SELECT
    @FullJoinColumnASQL = @FullJoinColumnASQL +
          CASE WHEN @FullJoinColumnASQL = '' THEN '' ELSE ', ' END +
          value + '_A = a.' + value + CHAR(13) + CHAR(10)
  FROM STRING_SPLIT(@ColumnComparaList, ',')
  WHERE RTRIM(LTRIM(value)) <> '';

  -- Columnas - B
  SELECT
    @FullJoinColumnBSQL = @FullJoinColumnBSQL +
          CASE WHEN @FullJoinColumnBSQL = '' THEN '' ELSE ', ' END +
          value + '_B = b.' + value + CHAR(13) + CHAR(10)
  FROM STRING_SPLIT(@ColumnComparaList, ',')
  WHERE RTRIM(LTRIM(value)) <> '';

  -- Genera Full Join Campos a comparar
  SELECT
    @FullJoinColumnCompareListSQL = @FullJoinColumnCompareListSQL +
          CASE WHEN @FullJoinColumnCompareListSQL = '' THEN '' ELSE ', ' END +
          value + '_Dif = IIF(a.' + value + ' != b.' + value + ', ''S'', ''N'')' + CHAR(13) + CHAR(10)
  FROM STRING_SPLIT(@ColumnComparaList, ',')
  WHERE RTRIM(LTRIM(value)) <> '';

  -- Genera Full Join Campos Clave
  SELECT
    @FullJoinColumnClaveListSQL = @FullJoinColumnClaveListSQL +
        CASE WHEN @FullJoinColumnClaveListSQL = '' THEN '' ELSE ', ' END +
        value + ' = ISNULL(a.' + value + ', b.' + value + ')' + CHAR(13) + CHAR(10)
  FROM STRING_SPLIT(@ColumnDetalleClaveList, ',')
  WHERE RTRIM(LTRIM(value)) <> '';


  -- Genera Full Validate Campos
  SELECT
    @FullJoinColumnValidateSQL = @FullJoinColumnValidateSQL +
        CASE WHEN @FullJoinColumnValidateSQL = '' THEN '' ELSE 'OR ' END +
        value + '_Dif = ''S''' + CHAR(13) + CHAR(10)
  FROM STRING_SPLIT(@ColumnComparaList, ',')
  WHERE RTRIM(LTRIM(value)) <> '';

  --IdCompania              = ISNULL(a.IdCompania, b.IdCompania)  
  

  -- //
  SET @QuerySQL = '
  SELECT   
    sec.*
    , Valido = IIF(' + @FullJoinColumnValidateSQL + ',''N'',''S'')
  FROM (   
    SELECT   
      ' + @FullJoinColumnASQL + '
      , ' + @FullJoinColumnBSQL + '
      , ' + @FullJoinColumnClaveListSQL + '
      , ' + @FullJoinColumnCompareListSQL + '

      , IdCompania              = ISNULL(a.IdCompania, b.IdCompania)
      , ExisteEnTxt             = IIF(a.IdCompania IS NOT NULL, ''S'', ''N'')
      , ExisteEnOrigen          = IIF(b.IdCompania IS NOT NULL, ''S'', ''N'')

    FROM #SeCorregido a   
    FULL JOIN #SeSistema b   
      on  b.IdCompania = a.IdCompania
      and ' + @FullJoinConditionSQL + '  
  ) AS sec 
    '
  PRINT(@QuerySQL);
  EXEC sp_executesql @QuerySQL;

