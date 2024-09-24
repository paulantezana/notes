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

-- SireTxtPropuesta
-- SireTxtDeclarado
-- SireTxtGenerado
CREATE TABLE Financiero.SunatElectronicoTxtPropuestaSunat (
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
  DECLARE @PeriodoInicio VARCHAR(6) = '201901';
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

  -- ==================================================================================================================
  -- ==================================================================================================================
  -- ------- G E N E R A R     T A B L A S     Y     C O L U M N A S
  -- ==================================================================================================================
  -- ==================================================================================================================
  DECLARE @ColumnPeriodo VARCHAR(200) = 'Col1';
  DECLARE @ColumnClaveList VARCHAR(200) = 'Col1, Col2';
  DECLARE @ColumnDetalleClaveList VARCHAR(200) = 'Col1, Col2, Col3';

  DECLARE @ColumnNumberComparaList VARCHAR(200) = 'Col18, Col19';
  DECLARE @ColumnTextComparaList VARCHAR(200) = 'Col4, Col5, Col6, Col7, Col8, Col9, Col10, Col13, Col14, Col15, Col17, Col20';
  DECLARE @ColumnDescriptionComparaList VARCHAR(200) = 'Col11, Col12, Col16';
  DECLARE @ColumnComparaList VARCHAR(200) = @ColumnNumberComparaList + ', ' + @ColumnTextComparaList + ', ' + @ColumnDescriptionComparaList;

  DECLARE @ColumnEstado VARCHAR(200) = 'Col21';
  DECLARE @PatronNoAlfanumerico varchar(52) = '!"#$%&''()*+,-./:;<=>?@[\]^_`{|}~áéíóúÁÉÍÓÚÑñ¿¡°¨§¬¥¢£€©®汉字' + char(9) + char(13) + char(10)


  DROP TABLE IF EXISTS #SeDeclarado;
  DROP TABLE IF EXISTS #SeCorregido;
  DROP TABLE IF EXISTS #SeSistema;

  CREATE TABLE #SeDeclarado (
    IdCompania INT NOT NULL,
    CodigoAnioPeriodo VARCHAR(12) NOT NULL,
  )
  CREATE TABLE #SeCorregido (
    IdCompania INT NOT NULL,
    CodigoAnioPeriodo VARCHAR(12) NOT NULL,
  )
  CREATE TABLE #SeSistema (
    IdCompania INT NOT NULL,
    CodigoAnioPeriodo VARCHAR(12) NOT NULL,
  )

  SELECT @QuerySQL = '';
  SELECT @ColumnList = '', @ColumnListA = '', @ColumnListB = '';

  SET @i = 1;
  WHILE @i <= @NumeroColumnas
  BEGIN
      SET @QuerySQL += 'ALTER TABLE #SeDeclarado ADD Col' + CAST(@i AS NVARCHAR(3)) + ' NVARCHAR(4000);';
      SET @QuerySQL += 'ALTER TABLE #SeCorregido ADD Col' + CAST(@i AS NVARCHAR(3)) + ' NVARCHAR(4000);';
      SET @QuerySQL += 'ALTER TABLE #SeSistema ADD Col' + CAST(@i AS NVARCHAR(3)) + ' NVARCHAR(4000);';

      SET @ColumnList += 'Col' + CAST(@i AS NVARCHAR(3));
      SET @ColumnListA += 'Col' + CAST(@i AS NVARCHAR(3)) + '_A';
      SET @ColumnListB += 'Col' + CAST(@i AS NVARCHAR(3)) + '_B';

      IF @i < @NumeroColumnas SELECT @ColumnList += ', ', @ColumnListA += ', ', @ColumnListB += ', ';

      SET @i += 1;
  END

  SELECT @QuerySQL = @QuerySQL
          + 'ALTER TABLE #SeDeclarado ADD ' + [value] + '_Aux NVARCHAR(4000);'
          + 'ALTER TABLE #SeCorregido ADD ' + [value] + '_Aux NVARCHAR(4000);'
          + 'ALTER TABLE #SeSistema ADD ' + [value] + '_Aux NVARCHAR(4000);'
  FROM STRING_SPLIT(@ColumnDescriptionComparaList, ',')
  WHERE RTRIM(LTRIM([value])) <> '';

  EXEC sp_executesql @QuerySQL;


  DECLARE @ColumnDescriptionComparaListAux VARCHAR(MAX) = '';
  DECLARE @ColumnDescriptionComparaListAuxClean VARCHAR(MAX) = '';
  SELECT
    @ColumnDescriptionComparaListAux = @ColumnDescriptionComparaListAux +
          CASE WHEN @ColumnDescriptionComparaListAux = '' THEN '' ELSE ', ' END +
          [value] + '_Aux' + CHAR(13) + CHAR(10),
    @ColumnDescriptionComparaListAuxClean = @ColumnDescriptionComparaListAuxClean +
          CASE WHEN @ColumnDescriptionComparaListAuxClean = '' THEN '' ELSE ', ' END +
          [value] + '_Aux = REPLACE(REPLACE(REPLACE('+
                            + 'TRANSLATE(' + [value] + ', ''' + REPLACE(@PatronNoAlfanumerico, '''', '''''') + ''', REPLICATE('' '', LEN(''' + REPLACE(@PatronNoAlfanumerico, '''', '''''') + '''))) ' +
                            + ', CHAR(32), ''<>''), ''><'',''''), ''<>'',CHAR(32))' + CHAR(13) + CHAR(10)
  FROM STRING_SPLIT(@ColumnDescriptionComparaList, ',')
  WHERE RTRIM(LTRIM([value])) <> '';

  -- ==================================================================================================================
  -- ==================================================================================================================
  -- ------- D A T A      D E C L A R A D O
  -- ==================================================================================================================
  -- ==================================================================================================================


  -- -----------------------------------------------------
  -- Obtener datos declarados
  SET @QuerySQL = '
    SELECT IdCompania, CodigoAnioPeriodo, ' + @ColumnList + ', ' + @ColumnDescriptionComparaListAuxClean + '
      INTO #SeDeclaradoData
    FROM Financiero.SunatElectronicoTxtDeclarado 
    WHERE IdCompania = ' + CONVERT(varchar, @IdCompania) + '
      AND Codigo = ''' + @CodigoSunatElectronico  + '''
      AND CodigoAnioPeriodo >= ' + @PeriodoInicioLocal +'   
      AND CodigoAnioPeriodo < ' + @PeriodoFin + ';

    SELECT IdCompania, CodigoAnioPeriodo, ' + @ColumnList + ', ' + @ColumnDescriptionComparaListAux + '
      INTO #SeCorregidoData
    FROM (
        SELECT
          Fila = ROW_NUMBER() OVER(PARTITION BY ' + @ColumnClaveList + ' ORDER BY ' + @ColumnClaveList + ', CodigoAnioPeriodo DESC)   
          , IdCompania, CodigoAnioPeriodo, ' + @ColumnList + ', ' + @ColumnDescriptionComparaListAux + '
        FROM #SeDeclaradoData 
        WHERE LEFT(' + @ColumnPeriodo + ',6) BETWEEN ' + @PeriodoInicioLocal + ' AND ' + @PeriodoFin + '
    ) t
    WHERE Fila = 1;

    INSERT INTO #SeCorregido (IdCompania, CodigoAnioPeriodo, ' + @ColumnList + ', ' + @ColumnDescriptionComparaListAux + ')
    SELECT IdCompania, CodigoAnioPeriodo, ' + @ColumnList + ', ' + @ColumnDescriptionComparaListAux + ' FROM #SeCorregidoData
  '

  SELECT @QuerySQL;
  EXEC sp_executesql @QuerySQL;

  -- ==================================================================================================================
  -- ==================================================================================================================
  -- ------- D A T A      E N     E L      S I S T E M A
  -- ==================================================================================================================
  -- ==================================================================================================================


  -- -----------------------------------------------------
  -- Obtener Datos actuales
  SET @QuerySQL = '
    INSERT INTO #SeSistema (IdCompania, CodigoAnioPeriodo, ' + @ColumnList + ')
    SELECT IdCompania, CodigoAnioPeriodo, ' + @ColumnList + ' FROM Financiero.SunatElectronicoTxtGenerado 
    WHERE IdCompania = ' + CONVERT(varchar, @IdCompania) + '
      AND Codigo = ''' + @CodigoSunatElectronico  + '''
      AND CodigoAnioPeriodo >= ' + @PeriodoInicioLocal +'   
      AND CodigoAnioPeriodo < ' + @PeriodoFin + '
  '
  EXEC sp_executesql @QuerySQL;


  -- ==================================================================================================================
  -- ==================================================================================================================
  -- ------- C O M P A R A
  -- ==================================================================================================================
  -- ==================================================================================================================
  DROP TABLE IF EXISTS #SeComparar;
  CREATE TABLE #SeComparar (
    IdCompania INT NOT NULL,
    CodigoAnioPeriodo VARCHAR(12) NOT NULL,
    Valido Char NOT NULL,
    ExisteEnTxt Char NOT NULL,
    ExisteEnOrigen Char NOT NULL,
  );

  DECLARE @FullJoinConditionSQL NVARCHAR(MAX) = '';
  DECLARE @FullJoinColumnCompareListSQL NVARCHAR(MAX) = '';
  DECLARE @FullJoinColumnClaveListSQL NVARCHAR(MAX) = '';
  DECLARE @FullJoinColumnASQL NVARCHAR(MAX) = '';
  DECLARE @FullJoinColumnBSQL NVARCHAR(MAX) = '';

  DECLARE @ComparaColumnASQL NVARCHAR(MAX) = '';
  DECLARE @ComparaColumnBSQL NVARCHAR(MAX) = '';
  DECLARE @ComparaColumnComparSQL NVARCHAR(MAX) = '';
  DECLARE @ComparaColumnClaveSQL NVARCHAR(MAX) = '';

  DECLARE @FullJoinColumnValidateSQL NVARCHAR(MAX) = '';

  DECLARE @TablaSeCompararColumnListSQL NVARCHAR(MAX) = '';


  -- Genera Full Join Condicion
  SELECT
    @FullJoinConditionSQL = @FullJoinConditionSQL +
              CASE WHEN @FullJoinConditionSQL = '' THEN '' ELSE ' AND ' END +
              'b.' + [value] + ' = a.' + [value] + CHAR(13) + CHAR(10)
  FROM STRING_SPLIT(@ColumnDetalleClaveList, ',')
  WHERE RTRIM(LTRIM([value])) <> '';

  -- Genera Full Join Campos Clave
  SELECT
    @FullJoinColumnClaveListSQL = @FullJoinColumnClaveListSQL +
        CASE WHEN @FullJoinColumnClaveListSQL = '' THEN '' ELSE ', ' END +
        [value] + ' = ISNULL(a.' + [value] + ', b.' + [value] + ')' + CHAR(13) + CHAR(10),

    @TablaSeCompararColumnListSQL = @TablaSeCompararColumnListSQL +
            'ALTER TABLE #SeComparar ADD ' + [value] + ' NVARCHAR(4000); ' + CHAR(13) + CHAR(10)
  FROM STRING_SPLIT(@ColumnDetalleClaveList, ',')
  WHERE RTRIM(LTRIM([value])) <> '';

  -- Columnas - A
  SELECT
    @FullJoinColumnASQL = @FullJoinColumnASQL +
          CASE WHEN @FullJoinColumnASQL = '' THEN '' ELSE ', ' END +
            [value] + '_A = a.' + [value] + CHAR(13) + CHAR(10),

    @ComparaColumnASQL = @ComparaColumnASQL +
          CASE WHEN @ComparaColumnASQL = '' THEN '' ELSE ', ' END +
            [value] + '_A' + CHAR(13) + CHAR(10),

    @TablaSeCompararColumnListSQL = @TablaSeCompararColumnListSQL +
            'ALTER TABLE #SeComparar ADD ' + [value] + '_A' + ' NVARCHAR(4000); ' + CHAR(13) + CHAR(10)

  FROM STRING_SPLIT(@ColumnList, ',')
  WHERE RTRIM(LTRIM([value])) <> '';


  

  -- Columnas - B
  SELECT
    @FullJoinColumnBSQL = @FullJoinColumnBSQL +
          CASE WHEN @FullJoinColumnBSQL = '' THEN '' ELSE ', ' END +
          [value] + '_B = b.' + [value] + CHAR(13) + CHAR(10),

    @ComparaColumnBSQL = @ComparaColumnBSQL +
          CASE WHEN @ComparaColumnBSQL = '' THEN '' ELSE ', ' END +
          [value] + '_B' + CHAR(13) + CHAR(10),

    @TablaSeCompararColumnListSQL = @TablaSeCompararColumnListSQL +
            'ALTER TABLE #SeComparar ADD ' + [value] + '_B' + ' NVARCHAR(4000); ' + CHAR(13) + CHAR(10)
  FROM STRING_SPLIT(@ColumnList, ',')
  WHERE RTRIM(LTRIM([value])) <> '';

  -- Genera Full Join Campos a comparar
  SELECT
    --@FullJoinColumnCompareListSQL = @FullJoinColumnCompareListSQL +
    --      CASE WHEN @FullJoinColumnCompareListSQL = '' THEN '' ELSE ', ' END +
    --      [value] + '_Dif = IIF(a.' + [value] + ' != b.' + [value] + ', ''S'', ''N'')' + CHAR(13) + CHAR(10),

    @ComparaColumnComparSQL = @ComparaColumnComparSQL +
          CASE WHEN @ComparaColumnComparSQL = '' THEN '' ELSE ', ' END +
          [value] + '_Dif' + CHAR(13) + CHAR(10),

    @TablaSeCompararColumnListSQL = @TablaSeCompararColumnListSQL +
            'ALTER TABLE #SeComparar ADD ' + [value] + '_Dif' + ' NVARCHAR(4000); ' + CHAR(13) + CHAR(10)
  FROM STRING_SPLIT(@ColumnComparaList, ',')
  WHERE RTRIM(LTRIM([value])) <> '';


  SELECT
    @FullJoinColumnCompareListSQL = @FullJoinColumnCompareListSQL +
          CASE WHEN @FullJoinColumnCompareListSQL = '' THEN '' ELSE ', ' END +
          [value] + '_Dif = IIF(a.' + [value] + ' != b.' + [value] + ', ''S'', ''N'')' + CHAR(13) + CHAR(10)
  FROM STRING_SPLIT(@ColumnTextComparaList, ',')
  WHERE RTRIM(LTRIM([value])) <> '';


  SELECT
      @FullJoinColumnCompareListSQL = @FullJoinColumnCompareListSQL +
          CASE WHEN @FullJoinColumnCompareListSQL = '' THEN '' ELSE ', ' END +
          [value] + '_Dif = IIF(a.' + [value] + ' != b.' + [value] + ', ''S'', ''N'')' + CHAR(13) + CHAR(10)

    --@FullJoinColumnCompareListSQL = @FullJoinColumnCompareListSQL +
    --      CASE WHEN @FullJoinColumnCompareListSQL = '' THEN '' ELSE ', ' END +
    --      [value] + '_Dif = IIF(
    --                            REPLACE(REPLACE(REPLACE(
    --                              TRANSLATE(a.' + [value] + ', ''' + REPLACE(@PatronNoAlfanumerico, '''', '''''') + ''', REPLICATE('' '', LEN(''' + REPLACE(@PatronNoAlfanumerico, '''', '''''') + ''')))
    --                            , CHAR(32), ''<>''), ''><'',''''), ''<>'',CHAR(32))

    --                            != 

    --                            REPLACE(REPLACE(REPLACE(
    --                              TRANSLATE(b.' + [value] + ', ''' + REPLACE(@PatronNoAlfanumerico, '''', '''''') + ''', REPLICATE('' '', LEN(''' + REPLACE(@PatronNoAlfanumerico, '''', '''''') + ''')))
    --                            , CHAR(32), ''<>''), ''><'',''''), ''<>'',CHAR(32))

    --                        , ''S''
    --                        , ''N''
    --                      )' + CHAR(13) + CHAR(10)
  FROM STRING_SPLIT(@ColumnDescriptionComparaList, ',')
  WHERE RTRIM(LTRIM([value])) <> '';

  --  DECLARE @CompareReplace VARCHAR(200) = '
  --  REPLACE(REPLACE(REPLACE(
  --                TRANSLATE(ddddddddddddddd, ''' + @PatronNoAlfanumerico + ''', REPLICATE('' '', LEN(''' + @PatronNoAlfanumerico + ''')))
  --  , CHAR(32), ''<>''), ''><'',''''), ''<>'',CHAR(32))
  --'

  SELECT
    @FullJoinColumnCompareListSQL = @FullJoinColumnCompareListSQL +
          CASE WHEN @FullJoinColumnCompareListSQL = '' THEN '' ELSE ', ' END +
          [value] + '_Dif = IIF(a.' + [value] + ' != b.' + [value] + ', ''S'', ''N'')' + CHAR(13) + CHAR(10)
  FROM STRING_SPLIT(@ColumnNumberComparaList, ',')
  WHERE RTRIM(LTRIM([value])) <> '';


  --DECLARE @ColumnNumberComparaList VARCHAR(200) = 'Col18, Col19';
  --DECLARE @ColumnTextComparaList VARCHAR(200) = 'Col4, Col5, Col6, Col7, Col8, Col9, Col10, Col13, Col14, Col15, Col17, Col20';
  --DECLARE @ColumnDescriptionComparaList VARCHAR(200) = 'Col11, Col12, Col16';
  --DECLARE @ColumnComparaList VARCHAR(200) = @ColumnNumberComparaList + ', ' + @ColumnTextComparaList + ', ' + @ColumnDescriptionComparaList;


  -- ----------------------------
  -- Genera Full Validate Campos
  SELECT
    @FullJoinColumnValidateSQL = @FullJoinColumnValidateSQL +
        CASE WHEN @FullJoinColumnValidateSQL = '' THEN '' ELSE 'OR ' END +
        value + '_Dif = ''S''' + CHAR(13) + CHAR(10)
  FROM STRING_SPLIT(@ColumnComparaList, ',')
  WHERE RTRIM(LTRIM([value])) <> '';


  -- Agregar Columnas;
  EXEC sp_executesql @TablaSeCompararColumnListSQL;

  -- //
  SET @QuerySQL = '
  INSERT INTO #SeComparar (
    IdCompania, CodigoAnioPeriodo, Valido
    , ExisteEnTxt, ExisteEnOrigen
    , ' + @ColumnDetalleClaveList + '

    , ' + @ComparaColumnASQL + '
    , ' + @ComparaColumnBSQL + '
    , ' + @ComparaColumnComparSQL + '
  )
  SELECT
    IdCompania, CodigoAnioPeriodo, Valido = IIF(' + @FullJoinColumnValidateSQL + ',''N'',''S'')
    , ExisteEnTxt, ExisteEnOrigen
    , ' + @ColumnDetalleClaveList + '

    , ' + @ComparaColumnASQL + '
    , ' + @ComparaColumnBSQL + '
    , ' + @ComparaColumnComparSQL + '
  FROM (   
    SELECT
      IdCompania              = ISNULL(a.IdCompania, b.IdCompania)
      , CodigoAnioPeriodo       = ISNULL(a.CodigoAnioPeriodo, b.CodigoAnioPeriodo)
      , ExisteEnTxt             = IIF(a.IdCompania IS NOT NULL, ''S'', ''N'')
      , ExisteEnOrigen          = IIF(b.IdCompania IS NOT NULL, ''S'', ''N'')
      , ' + @FullJoinColumnClaveListSQL + '

      , ' + @FullJoinColumnASQL + '
      , ' + @FullJoinColumnBSQL + '
      , ' + @FullJoinColumnCompareListSQL + '
    FROM #SeCorregido a   
    FULL JOIN #SeSistema b   
      on  b.IdCompania = a.IdCompania
      and ' + @FullJoinConditionSQL + '  
  ) AS sec'
  SELECT @QuerySQL;
  EXEC sp_executesql @QuerySQL;






  -- ==================================================================================================================
  -- ==================================================================================================================
  -- ------- G E N E R A      R E C T I F I C A T O R I A
  -- ==================================================================================================================
  -- ==================================================================================================================
  DROP TABLE IF EXISTS #SeRectifica;
  CREATE TABLE #SeRectifica (
    IdCompania INT NOT NULL,
    CodigoAnioPeriodo VARCHAR(12) NOT NULL,
    Descripcion VARCHAR(255) NOT NULL,
    PeriodoInicioRectifica VARCHAR(12) NOT NULL,
    PeriodoFinRectifica VARCHAR(12) NOT NULL,
    Valido Char NOT NULL,
    ExisteEnTxt Char NOT NULL,
    ExisteEnOrigen Char NOT NULL,
    Motivo VARCHAR(MAX) NOT NULL,
    De VARCHAR(MAX) NOT NULL,
    Por VARCHAR(MAX) NOT NULL,
  )

  SET @i = 1;
  SET @QuerySQL = '';
  WHILE @i <= @NumeroColumnas
  BEGIN
      SET @QuerySQL += 'ALTER TABLE #SeRectifica ADD Col' + CAST(@i AS NVARCHAR(3)) + ' NVARCHAR(4000);';
      SET @i += 1;
  END
  EXEC sp_executesql @QuerySQL;



  DECLARE @ColumnParteASQL NVARCHAR(MAX) = '';
  DECLARE @ColumnParteBSQL NVARCHAR(MAX) = '';
  DECLARE @ColumnEstadi8MotivoSQL NVARCHAR(MAX) = '';
  DECLARE @ColumnEstadi8DeSQL NVARCHAR(MAX) = '';
  DECLARE @ColumnEstadi8PorSQL NVARCHAR(MAX) = '';


  SET @ColumnList = REPLACE(REPLACE(@ColumnList , @ColumnEstado, ''), ', ,', ',');


  -- Columnas - Parte A
  SELECT
    @ColumnParteASQL = @ColumnParteASQL +
          CASE WHEN @ColumnParteASQL = '' THEN '' ELSE ', ' END +
          value + ' = ' + value + '_A ' + CHAR(13) + CHAR(10)
  FROM STRING_SPLIT(@ColumnList, ',')
  WHERE RTRIM(LTRIM(value)) <> '';

  -- Columnas - Parte B
  SELECT
    @ColumnParteBSQL = @ColumnParteBSQL +
          CASE WHEN @ColumnParteBSQL = '' THEN '' ELSE ', ' END +
          value + ' = ' + value + '_B ' + CHAR(13) + CHAR(10)
  FROM STRING_SPLIT(@ColumnList, ',')
  WHERE RTRIM(LTRIM(value)) <> '';



  SELECT
    @ColumnEstadi8MotivoSQL = @ColumnEstadi8MotivoSQL +
          CASE WHEN @ColumnEstadi8MotivoSQL = '' THEN '' ELSE ', ' END +
          'IIF(' + [value] + '_Dif = ''S'', '' | ' + [value] + ''', '''')' + CHAR(13) + CHAR(10),

    @ColumnEstadi8DeSQL = @ColumnEstadi8DeSQL +
          CASE WHEN @ColumnEstadi8DeSQL = '' THEN '' ELSE ', ' END +
          'IIF(' + [value] + '_Dif = ''S'', '' | '' + ' + [value] + '_A, '''')' + CHAR(13) + CHAR(10),

    @ColumnEstadi8PorSQL = @ColumnEstadi8PorSQL +
          CASE WHEN @ColumnEstadi8PorSQL = '' THEN '' ELSE ', ' END +
          'IIF(' + [value] + '_Dif = ''S'', '' | '' + ' + [value] + '_B, '''')' + CHAR(13) + CHAR(10)

  FROM STRING_SPLIT(@ColumnComparaList, ',')
  WHERE RTRIM(LTRIM([value])) <> '';


  --SELECT @ColumnEstadi8MotivoSQL, @ColumnEstadi8DeSQL, @ColumnEstadi8PorSQL

  --


  SET @QuerySQL = '
    INSERT INTO #SeRectifica (
      IdCompania
      , CodigoAnioPeriodo
      , Descripcion             
      , PeriodoInicioRectifica  
      , PeriodoFinRectifica     

      , Valido
      , ExisteEnTxt
      , ExisteEnOrigen
      , Motivo
      , De
      , Por

      , ' + @ColumnList + '
      , ' + @ColumnEstado + '
    )'

  SET @QuerySQL = @QuerySQL + '
    SELECT
      IdCompania
      , CodigoAnioPeriodo
      , Descripcion             = ''Rectificatoria desde ' + @PeriodoInicioLocal + ' hasta ' + @PeriodoFin + '''
      , PeriodoInicioRectifica  = ' + @PeriodoInicioLocal + '
      , PeriodoFinRectifica     = ' + @PeriodoFin + '

      , Valido
      , ExisteEnTxt
      , ExisteEnOrigen
      , Motivo                = ''Cambio en: '' + CONCAT(' + @ColumnEstadi8MotivoSQL + ') 
      , De                    = CONCAT(' + @ColumnEstadi8DeSQL + ') 
      , Por                   = CONCAT(' + @ColumnEstadi8PorSQL + ') 

      , ' + @ColumnParteBSQL + '
      , ' + @ColumnEstado + ' = 9
    FROM #SeComparar
    WHERE ExisteEnOrigen = ''S''
      AND ExisteEnTxt = ''S'' 
      AND Valido = ''N''
  '

  SET @QuerySQL = @QuerySQL + '

    UNION ALL

    SELECT
      IdCompania
      , CodigoAnioPeriodo
      , Descripcion             = ''Rectificatoria desde ' + @PeriodoInicioLocal + ' hasta ' + @PeriodoFin + '''
      , PeriodoInicioRectifica  = ' + @PeriodoInicioLocal + '
      , PeriodoFinRectifica     = ' + @PeriodoFin + '

      , Valido
      , ExisteEnTxt
      , ExisteEnOrigen
      , Motivo                = ''Modifica por CERO''
      , De                    = ''''
      , Por                   = ''''

      , ' + @ColumnParteASQL + '
      , ' + @ColumnEstado + ' = 9
    FROM #SeComparar
    WHERE ExisteEnOrigen = ''N''
  '

  SET @QuerySQL = @QuerySQL + '
    UNION ALL

    SELECT
      IdCompania
      , CodigoAnioPeriodo
      , Descripcion             = ''Rectificatoria desde ' + @PeriodoInicioLocal + ' hasta ' + @PeriodoFin + '''
      , PeriodoInicioRectifica  = ' + @PeriodoInicioLocal + '
      , PeriodoFinRectifica     = ' + @PeriodoFin + '

      , Valido
      , ExisteEnTxt
      , ExisteEnOrigen
      , Motivo                = ''Nuevo Registro''
      , De                    = ''''
      , Por                   = ''''

      , ' + @ColumnParteBSQL + '
      , ' + @ColumnEstado + ' = 8
    FROM #SeComparar
    WHERE ExisteEnTxt = ''N''
  '

  EXEC sp_executesql @QuerySQL;


  -- ==================================================================================================================
  -- ------- G E N E R A      R E P O R T E
  -- ==================================================================================================================
  DROP TABLE IF EXISTS #SunatElectronicoRangoPeriodo;

  DROP TABLE IF EXISTS #SeReporte;
  CREATE TABLE #SeReporte (
    Orden VARCHAR(32),
    Mensaje VARCHAR(255),
    CodigoAnioPeriodo VARCHAR(12) DEFAULT ''
  )
  
  -- Obtener Periodos
  SELECT   
    CodigoSunatElectronico = CodigoSunatElectronico   
    , CodigoAnioPeriodo = vap.CodigoAnioPeriodo   
    INTO #SunatElectronicoRangoPeriodo   
  FROM Financiero.ViewSunatElectronicoPeriodo AS vap (nolock)   
  WHERE vap.IdCompania = @IdCompania   
    AND vap.CodigoAnioPeriodo >= @PeriodoInicioLocal   
    AND vap.CodigoAnioPeriodo < @PeriodoFin   
    AND RIGHT(vap.CodigoAnioPeriodo,2) NOT IN ('00','13')   
    AND vap.CodigoSunatElectronico = @CodigoSunatElectronico   

  -- Generar Reporte
  INSERT INTO #SeReporte (Orden, Mensaje, CodigoAnioPeriodo) 
  SELECT 
    '10' + CONVERT(VARCHAR, p.CodigoAnioPeriodo) + '00000000'
    , p.CodigoAnioPeriodo -- + '|' +  IIF(txt.TXT_CodigoAnioPeriodo IS NULL, 'TXT No Existe', 'Existe')
    , p.CodigoAnioPeriodo
  FROM #SunatElectronicoRangoPeriodo AS p
  -- LEFT JOIN #diferencias_TXT_VS_XPLE AS txt ON p.CodigoAnioPeriodo = txt.CodigoAnioPeriodo
  -- LEFT JOIN (SELECT DISTINCT CodigoAnioPeriodo FROM #ple050100TXTdeclarado) AS pl5 ON p.CodigoAnioPeriodo = pl5.CodigoAnioPeriodo
  ORDER BY p.CodigoAnioPeriodo


  -- Total Cantidad Procesados
  SET @QuerySQL = '
    SELECT ''2000000000000000000''
      , ''Procesado |'' + CONVERT(VARCHAR(8), COUNT(1)) + '' Reg.procesados''   
    FROM #SeComparar; 
  '
  INSERT INTO #SeReporte (Orden, Mensaje) 
  EXEC sp_executesql @QuerySQL;


  -- Reporte Rectificado
  SET @QuerySQL = '
    SELECT   
      ''3000000000000000000'' + ROW_NUMBER() OVER (ORDER BY IdCompania, CodigoAnioPeriodo, ' + @ColumnEstado + ')   
      , ''Rectifica periodo '' + ISNULL(CodigoAnioPeriodo, '''') + ''|'' + CONVERT(varchar(8), COUNT(1)) + '' Reg.con Estado ('' + ISNULL(' + @ColumnEstado + ', '''') + '')''
    FROM #SeRectifica
    GROUP BY IdCompania, CodigoAnioPeriodo, ' + @ColumnEstado + '
  '
  INSERT INTO #SeReporte (Orden, Mensaje) 
  EXEC sp_executesql @QuerySQL;


  -- Resumen Totales
  SET @QuerySQL = '
    SELECT   
      ''4000000000000000000'' + ROW_NUMBER() OVER (ORDER BY ' + @ColumnEstado + ')   
      , ''Total rectifica con Estado ('' + ISNULL(' + @ColumnEstado + ', '''') + '')|'' + CONVERT(varchar(8), COUNT(1)) + '' registros ''
    FROM #SeRectifica
    GROUP BY ' + @ColumnEstado + '
  '
  INSERT INTO #SeReporte (Orden, Mensaje) 
  EXEC sp_executesql @QuerySQL;



  -- Mostrar reporte
  SELECT * FROM #SeReporte ORDER BY Orden;