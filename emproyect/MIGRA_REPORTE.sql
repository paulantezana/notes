-- =========================================================================
-- BALANCE
-- =========================================================================
SELECT
    Codigo = '0' + LEFT(TCLAVE,1) + '.0' + SUBSTRING(TCLAVE,2,1) + '.' + RIGHT(RTRIM(TCLAVE),2)
    , Descripcion = CASE LTRIM(RTRIM(TCLAVE))
                        WHEN '1100' THEN 'ACTIVO DISPONIBLE Y EXIGIBLE'
                        WHEN '1300' THEN 'ACTIVO INMOVILIZADO'
                        ELSE TDESCRI
                    END
    , Clave = LTRIM(RTRIM(TCLAVE))
    , TDESCRI
    INTO #bal_n2
FROM produccion.rsconcar.dbo.ct0032tage WHERE TCOD = '10'
AND RTRIM(TCLAVE) NOT IN (
    '1199','1299','1399','1999','2199','2299','3899','3999',
    '1309','1310')
UNION ALL
SELECT Codigo = '01.02.00', Descripcion = 'ACTIVO REALIZABLE', Clave = '1200', TDESCRI = ''
UNION ALL
SELECT Codigo = '03.01.00', Descripcion = 'PATRIMONIO', Clave = '1300', TDESCRI = ''

-- Insert
--INSERT INTO Configuracion.TablaPLE(Codigo, Descripcion, IdParent, Texto0)
SELECT ct.Codigo, ct.Descripcion, IdParent = 1, Clave
FROM #bal_n2 as ct
LEFT JOIN Configuracion.ViewTablaPLE as c ON
    LTRIM(RTRIM(ct.Clave)) = LTRIM(RTRIM(c.Texto0)) COLLATE Modern_Spanish_CI_AS
    AND c.Reporte = 'SITUACION FINANCIERA - CONCAR'
    AND c.Nivel = 2
WHERE c.Id IS NULL

DROP TABLE #bal_n2;

-- //

SELECT 
    Codigo = P.PCUENTA
    ,Descripcion = P.PDESCRI
    ,CodigoParent = P.PFORBAL
    ,DescripcionParent = a.TDESCRI
    INTO #bal_n3
FROM produccion.rsconcar.dbo.ct0032tage a
INNER JOIN produccion.RSCONCAR.dbo.ct0032plem p ON LTRIM(RTRIM(p.PFORBAL)) =  LTRIM(RTRIM(a.TCLAVE))
LEFT JOIN Configuracion.ViewTablaPLE vp WITH (NOLOCK) ON RTRIM(vp.Codigo) = RTRIM(P.PCUENTA) COLLATE Modern_Spanish_CI_AS AND Reporte = 'SITUACION FINANCIERA - CONCAR'
WHERE a.TCOD = '10' AND vp.Id IS NULL

INSERT INTO Configuracion.TablaPLE(Codigo, Descripcion, IdParent, Texto0)
SELECT n.Codigo, n.Descripcion, tp.Id, '' FROM #bal_n3 n
INNER JOIN Configuracion.ViewTablaPLE tp ON LTRIM(RTRIM(tp.Texto0)) = LTRIM(RTRIM(n.CodigoParent)) COLLATE Modern_Spanish_CI_AS AND Nivel = 3
AND tp.Reporte = 'SITUACION FINANCIERA - CONCAR'

DROP TABLE #bal_n3

-- //
-- //
-- //

SELECT
    Codigo = '04.0' + SUBSTRING(TCLAVE,2,1) + '.' + RIGHT(RTRIM(TCLAVE),2)
    , Descripcion = TDESCRI
    , Clave = LTRIM(RTRIM(TCLAVE))
    , TDESCRI
    INTO #gyp_n2
FROM produccion.rsconcar.dbo.ct0032tage WHERE TCOD = '11'
AND LTRIM(RTRIM(TCLAVE)) NOT LIKE '%F'

-- Insert
--INSERT INTO Configuracion.TablaPLE(Codigo, Descripcion, IdParent, Texto0)
SELECT ct.Codigo, ct.Descripcion, IdParent = 3832, Clave, c.*
FROM #gyp_n2 as ct
LEFT JOIN Configuracion.ViewTablaPLE as c ON
    LTRIM(RTRIM(ct.Clave)) = LTRIM(RTRIM(c.Texto0)) COLLATE Modern_Spanish_CI_AS
    AND c.Reporte = 'ESTADO DE GANANCIAS Y PERDIDAS - CONCAR'
    AND c.Nivel = 2
WHERE c.Id IS NULL

DROP TABLE #gyp_n2;

-- ///

SELECT 
    Codigo = P.PCUENTA
    , Descripcion = P.PDESCRI
    , CodigoParent = p.PFORGYP
    , DescripcionParent = a.TDESCRI
    INTO #gyp_n3
FROM produccion.rsconcar.dbo.ct0032tage a
INNER JOIN produccion.RSCONCAR.dbo.ct0032plem p ON LTRIM(RTRIM(p.PFORGYP)) =  LTRIM(RTRIM(a.TCLAVE))
LEFT JOIN Configuracion.ViewTablaPLE vp WITH (NOLOCK) ON RTRIM(vp.Codigo) = RTRIM(P.PCUENTA) COLLATE Modern_Spanish_CI_AS AND Reporte = 'ESTADO DE GANANCIAS Y PERDIDAS - CONCAR'
WHERE a.TCOD = '11' AND vp.Id IS NULL

-- INSERT INTO Configuracion.TablaPLE(Codigo, Descripcion, IdParent, Texto0)
SELECT n.Codigo, n.Descripcion, tp.Id, '' FROM #gyp_n3 n
INNER JOIN Configuracion.ViewTablaPLE tp ON
    LTRIM(RTRIM(tp.Texto0)) = LTRIM(RTRIM(n.CodigoParent)) COLLATE Modern_Spanish_CI_AS
    AND Reporte = 'ESTADO DE GANANCIAS Y PERDIDAS - CONCAR'
    AND Nivel = 2