-- ===================================================================================================
-- ===================================================================================================
-- C A R G A R       M A N U A L M E N T E      TXT
-- ===================================================================================================
-- ===================================================================================================
DECLARE @Codigo VARCHAR(8) = '';   
DECLARE @CodigoAnioPeriodo VARCHAR(8) = '';   
DECLARE @Ubicacion VARCHAR(200) = '';   
DECLARE @Archivo VARCHAR(200) = ''; 
DECLARE @IdSunatElectronicoPeriodoVersion INT = 0;

DROP TABLE IF EXISTS #SunatElectronicoRangoPeriodo;

SELECT   
  CodigoSunatElectronico = CodigoSunatElectronico   
  , CodigoAnioPeriodo = vap.CodigoAnioPeriodo   
  , Ubicacion = ISNULL(sv.UbicacionArchivo, '')   
  , Archivo = ISNULL(sv.Archivo, '')
  , IdSunatElectronicoPeriodoVersion = sv.Id
  INTO #SunatElectronicoRangoPeriodo   
FROM Financiero.ViewSunatElectronicoPeriodo AS vap (nolock)   
LEFT JOIN (   
  SELECT   
    Fila = ROW_NUMBER() OVER (PARTITION BY IdSunatElectronicoPeriodo ORDER BY NumeroProceso DESC)   
    , UbicacionArchivo = '/BACKOFFICE-DOCUMENTOS-WEB/' + UbicacionArchivo   
    , NumeroProceso, Archivo, IdSunatElectronicoPeriodo 
    , Id
  FROM Financiero.ViewSunatElectronicoPeriodoVersion   
  WHERE CodigoTipoProcesoSunatElectronico = 'DCL' AND SistemaOrigen = 'CONCAR'   
) as sv ON   
    sv.IdSunatElectronicoPeriodo = vap.Id AND Fila = 1   
WHERE vap.IdCompania = 32   
  AND vap.CodigoAnioPeriodo >= '201901'   
  AND vap.CodigoAnioPeriodo < '202407'   
  AND RIGHT(vap.CodigoAnioPeriodo,2) NOT IN ('00','13')   
  AND vap.CodigoSunatElectronico = '050100'   
ORDER BY vap.CodigoAnioPeriodo   
   
-- CURSORES   
DECLARE SunatElectronicoPeriodoVersion_Cursor CURSOR FOR   
SELECT Codigo = CodigoSunatElectronico, CodigoAnioPeriodo, Ubicacion, Archivo, IdSunatElectronicoPeriodoVersion FROM #SunatElectronicoRangoPeriodo   
   
-- OPEN CURSOR   
OPEN SunatElectronicoPeriodoVersion_Cursor   
FETCH NEXT FROM SunatElectronicoPeriodoVersion_Cursor into @Codigo, @CodigoAnioPeriodo, @Ubicacion, @Archivo, @IdSunatElectronicoPeriodoVersion   
WHILE @@fetch_status = 0   
BEGIN   
  DECLARE @CompaniaPeriodo VARCHAR(12);   

  --SELECT @Codigo, @CodigoAnioPeriodo, @Ubicacion, @Archivo, @IdSunatElectronicoPeriodoVersion
  EXEC [Financiero].[usp_cargarTxtSunatElectronicoPeriodoVersion] @IdSunatElectronicoPeriodoVersion, 'Admin', 'CONCAR' 
  FETCH NEXT FROM SunatElectronicoPeriodoVersion_Cursor into @Codigo, @CodigoAnioPeriodo, @Ubicacion, @Archivo, @IdSunatElectronicoPeriodoVersion;   
END 

CLOSE SunatElectronicoPeriodoVersion_Cursor;   
DEALLOCATE SunatElectronicoPeriodoVersion_Cursor;

-- ===================================================================================================
-- ===================================================================================================





-- ===================================================================================================
-- ===================================================================================================
-- C O M P A R A       T X T      V S       X P L E
-- ===================================================================================================
-- ===================================================================================================
DROP TABLE IF EXISTS #ResumenTXTDeclarado;
DROP TABLE IF EXISTS #ResumenXPLEDeclarado;

SELECT
  TXT_IdCompania    = LEFT(Compania,2)
  , TXT_CodigoAnioPeriodo = SUBSTRING(Compania,3,6)
  , TXT_SumaDebe    = SUM (CONVERT(decimal(20,2), TRIM(IIF(C21_Estado = '1', C18_Debe, '0'))) )
  , TXT_SumaHaber   = SUM (CONVERT(decimal(20,2), TRIM(IIF(C21_Estado = '1', C19_Haber, '0'))) )
  , TXT_CantidadE1  = SUM(IIF(C21_Estado = '1', 1, 0))
  , TXT_CantidadE8  = SUM(IIF(C21_Estado = '8', 1, 0))
  , TXT_CantidadE9  = SUM(IIF(C21_Estado = '9', 1, 0))
  , TXT_Cantidad    = COUNT(1)
  INTO #ResumenTXTDeclarado
FROM Financiero.PLE_050100_txt_declarado (nolock)
WHERE IdCompania = 31 AND CodigoAnioPeriodo LIKE '2019%'
GROUP BY Compania


SELECT
  XPLE_IdCompania = IdCompania
  , XPLE_CodigoAnioPeriodo = CodigoAnioPeriodo
  , XPLE_MontoDebeTotal = MontoDebeTotal
  , XPLE_MontoHaberTotal = MontoHaberTotal
  , XPLE_CantidadRegistrosE1 = CantidadRegistrosE1
  , XPLE_CantidadRegistrosE8 = CantidadRegistrosE8
  , XPLE_CantidadRegistrosE9 = CantidadRegistrosE9
  , XPLE_CantidadRegistrosDetalle = CantidadRegistrosDetalle
  , XPLE_CantidadRegistros = CantidadRegistros
  INTO #ResumenXPLEDeclarado
FROM Financiero.PLE_050100_xple_declarado (nolock) WHERE CodigoAnioPeriodo LIKE '2019%'
AND IdCompania = 31


SELECT
  *
   , Valido = IIF(   
        Dif_Debe           != 0   
        OR Dif_Haber       != 0    
        OR Dif_CantidadE1  != 0   
        OR Dif_CantidadE8  != 0   
        OR Dif_CantidadE9  != 0   
      ,'N','S'   
    )  
FROM (
  SELECT
    txt.*, xple.*
    , Dif_Debe        = txt.TXT_SumaDebe    - xple.XPLE_MontoDebeTotal
    , Dif_Haber       = txt.TXT_SumaHaber   - xple.XPLE_MontoHaberTotal
    , Dif_CantidadE1  = txt.TXT_CantidadE1  - xple.XPLE_CantidadRegistrosE1
    , Dif_CantidadE8  = txt.TXT_CantidadE8  - xple.XPLE_CantidadRegistrosE8
    , Dif_CantidadE9  = txt.TXT_CantidadE9  - xple.XPLE_CantidadRegistrosE9
  FROM #ResumenTXTDeclarado as txt
  FULL JOIN #ResumenXPLEDeclarado AS xple ON txt.TXT_IdCompania = xple.XPLE_IdCompania
      AND txt.TXT_CodigoAnioPeriodo = xple.XPLE_CodigoAnioPeriodo
) AS xp
ORDER BY 1, 2
