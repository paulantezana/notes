DECLARE @CodigoEnproyecdb VARCHAR(12) = '0002';
DECLARE @PeriodoInicio VARCHAR(6) = '202201';
DECLARE @PeriodoFin VARCHAR(6) = '202311';
DECLARE @Usuario VARCHAR(6) = 'Admin';
DECLARE @SistemaOrigen VARCHAR(30) = 'CONCAR';  
DECLARE @IdCompania INT;

DECLARE @AnioInicio VARCHAR(12);
DECLARE @AnioFin VARCHAR(12);

SELECT @AnioInicio = LEFT(@PeriodoInicio, 4), @AnioFin = LEFT(@PeriodoFin, 4);
SELECT @IdCompania = Id FROM Maestros.EntidadCompania WHERE Enproyecdb = @CodigoEnproyecdb;

DROP TABLE IF EXISTS #fragmentoAnioConcar;
DROP TABLE IF EXISTS #fragmentoAnioConcar2;
DROP TABLE IF EXISTS #Generales11;
DROP TABLE IF EXISTS #PubPersonas;
DROP TABLE IF EXISTS #ple050100_origen;

SELECT d.*, c.CGLOSA INTO #fragmentoAnioConcar   
FROM produccion.enproyecdb.dbo.asientos_det_tribu d   
  LEFT JOIN produccion.enproyecdb.dbo.asientos_cab_tribu c   
  on c.empresa = d.empresa   
  and c.periodo = d.PERIODO_DET   
  and c.cSUBDIA = d.DSUBDIA   
  and c.cCOMPRO = d.DCOMPRO   
WHERE   
  d.empresa = @CodigoEnproyecdb   
  AND d.DSUBDIA != '38'   
  AND PERIODO_DET BETWEEN  @AnioInicio AND @AnioFin   
  OPTION (RECOMPILE);   

-- //
SELECT CODIGO, COD_SUNAT INTO #Generales11 FROM produccion.enproyecdb.dbo.GENERALES D (nolock) WHERE  D.CLAVE = '011';  
SELECT IDPERSONA,TIPODOC_IDENT INTO #PubPersonas FROM produccion.enproyecdb.dbo.PUB_PERSONAS AS p (nolock);  
   
SELECT 
  a.*, PE.TIPODOC_IDENT, D.COD_SUNAT   
INTO #fragmentoAnioConcar2   
FROM #fragmentoAnioConcar a   
LEFT JOIN #PubPersonas PE ON PE.IDPERSONA = DCODANE   
LEFT JOIN #Generales11 D  ON D.CODIGO = CASE  
      WHEN DTIPDOC = 'BV' AND (DCUENTA = '631121' OR DCTAORI = '631121') THEN 'BVE'  
      ELSE DTIPDOC  
    END
WHERE CONCAT(PERIODO_DET, left(DCOMPRO,2)) >= @PeriodoInicio   
      AND CONCAT(PERIODO_DET, left(DCOMPRO,2)) < @PeriodoFin;   
  
   
SELECT BC1_Periodo       = RTRIM(PERIODO_DET) + LEFT(DCOMPRO,2) + '00'   
  , BC2_Cuo              = RTRIM(DSUBDIA) + RTRIM(DCOMPRO) + RTRIM(DSECUE) COLLATE SQL_Latin1_General_CP1_CI_AS   
  , BC3_Correlativo      = CASE   
                            WHEN RTRIM(DSUBDIA)='00' THEN 'A'   
                            WHEN RTRIM(DSUBDIA)='99' THEN 'C'   
                        ELSE 'M' END + RTRIM(DSUBDIA) + RTRIM(DCOMPRO)  COLLATE SQL_Latin1_General_CP1_CI_AS   
  , BC4_Cuenta           = RTRIM(ISNULL(DCUENTA, ''))   
  , BC5_UnidadOperacion  = ''   
  , BC6_CentroCosto      = RTRIM(ISNULL(DCENCOS, ''))   
  , BC7_MonedaOrigen     = CASE DCODMON   
                            WHEN 'US' THEN 'USD'   
                            WHEN 'MN' THEN 'PEN'   
                          ELSE '' END   
  --, BC8_TipoDocumento = CASE   
  --           WHEN LEN(DCODANE) = 11 then
				--			CASE WHEN TipoDocumento IS NULL THEN IIF(LEFT(DCODANE,1) IN ('9','0') ,'0','6')
				--				ELSE TipoDocumento
				--			END
  --                         WHEN LEN(DCODANE) = 8  then '1'   
  --                       ELSE '0' END   


  , BC8_TipoDocumento = CASE
                            WHEN LEN(DCODANE) = 11 and isnull(r.RUC,'') != ''
						--AND DCODANE NOT LIKE '%[^0-9]%'  -- Verifica que sea numérico
    --                          AND SUBSTRING(DCODANE, 1, 2) IN ('10', '15', '17', '20')
    --                          AND (
    --                              (CAST(SUBSTRING(DCODANE, 1, 1) AS INT) IN (1, 2) AND SUBSTRING(DCODANE, 2, 1) = '0')
    --                              OR (CAST(SUBSTRING(DCODANE, 1, 1) AS INT) = 2 AND SUBSTRING(DCODANE, 2, 1) = '0')
    --                          ) -- Verifica el prefijo
    --                          AND (
    --                              11 - (
    --                                  (


    --                                      CAST(SUBSTRING(DCODANE, 1, 1) AS INT) * 5 +
    --                                      CAST(SUBSTRING(DCODANE, 2, 1) AS INT) * 4 +
    --                                      CAST(SUBSTRING(DCODANE, 3, 1) AS INT) * 3 +
    --                                      CAST(SUBSTRING(DCODANE, 4, 1) AS INT) * 2 +
    --                                      CAST(SUBSTRING(DCODANE, 5, 1) AS INT) * 7 +
    --                                      CAST(SUBSTRING(DCODANE, 6, 1) AS INT) * 6 +
    --                                      CAST(SUBSTRING(DCODANE, 7, 1) AS INT) * 5 +
    --                                      CAST(SUBSTRING(DCODANE, 8, 1) AS INT) * 4 +
    --                                      CAST(SUBSTRING(DCODANE, 9, 1) AS INT) * 3 +
    --                                      CAST(SUBSTRING(DCODANE, 10, 1) AS INT) * 2
    --                                  ) % 11
    --                              ) = CAST(SUBSTRING(DCODANE, 11, 1) AS INT)
    --                          ) -- Verifica el dígito verificador
                              THEN '6'

                              WHEN LEN(DCODANE) = 8  then '1' 
                              ELSE '0'
                          END
                          --IIF(Maestros.ufn_ValidaRuc(RTRIM(DCODANE)) = 1, '6', '0')      --   
  , BC9_NumeroDocumento  = iif(DCODANE='','NA',   
                  replace(   
                      replace(   
                          replace(replace(DCODANE,' ',''),'-','')   
                      ,'/','')   
                  ,'.','')   
                          )  
  , BC10_TipoComprobante   = CASE   
    WHEN ISNUMERIC( CASE WHEN ISNULL(CASE WHEN CHARINDEX('-',DNUMDOC)>0 THEN REPLACE(SUBSTRING(DNUMDOC, CHARINDEX('-',DNUMDOC)+1,15),'/','')   
            ELSE REPLACE(DNUMDOC,'/','') END,'')='' THEN 'NA' ELSE CASE WHEN CHARINDEX('-',DNUMDOC)>0 THEN REPLACE(SUBSTRING(DNUMDOC, CHARINDEX('-',DNUMDOC)+1,15),'/','')   
            ELSE replace(DNUMDOC,'/','') END END   
                      ) = 1 THEN ISNULL(COD_SUNAT, '00')  
    ELSE '00'  
    END  
    --    THEN '00'   
    --    WHEN d.DTIPDOC = 'BV' AND (d.DCUENTA = '631121' OR d.DCTAORI = '631121')   
    --                        THEN '16'   
    --    WHEN DTIPDOC = '0'   THEN '01'   
    --    WHEN DTIPDOC = '21'  THEN '21'   
    --    WHEN DTIPDOC = '46'  THEN '46'   
    --    WHEN DTIPDOC = '50'  THEN '50'   
    --    WHEN DTIPDOC = '51'  THEN '51'   
    --    WHEN DTIPDOC = '52'  THEN '52'   
    --    WHEN DTIPDOC = '53'  THEN '53'   
    --    WHEN DTIPDOC = '87'  THEN '87'   
    --    WHEN DTIPDOC = '88'  THEN '88'   
    --    WHEN DTIPDOC = '91'  THEN '91'   
    --    WHEN DTIPDOC = '97'  THEN '97'   
    --    WHEN DTIPDOC = '98'  THEN '98'   
    --    WHEN DTIPDOC = 'BA'  THEN '05'   
    --    WHEN DTIPDOC = 'BV'  THEN '03'   
    --    WHEN DTIPDOC = 'BVE' THEN '16'   
    --    WHEN DTIPDOC = 'CP'  THEN '56'   
    --    WHEN DTIPDOC = 'DA'  THEN '13'   
    --    WHEN DTIPDOC = 'DP'  THEN '18'   
    --    WHEN DTIPDOC = 'FT'  THEN '01'   
    --    WHEN DTIPDOC = 'GR'  THEN '09'   
    --    WHEN DTIPDOC = 'GT'  THEN '31'   
    --    WHEN DTIPDOC = 'LB'  THEN '13'   
    --    WHEN DTIPDOC = 'NA'  THEN '07'   
    --    WHEN DTIPDOC = 'ND'  THEN '08'   
    --    WHEN DTIPDOC = 'RC'  THEN '14'   
    --    WHEN DTIPDOC = 'RH'  THEN '02'   
    --    WHEN DTIPDOC = 'RL'  THEN '50'   
    --    WHEN DTIPDOC = 'TK'  THEN '12'   
    ----WHEN DTIPDOC = ''   THEN '00'   
    --ELSE '00' END   
              -- produccion.enproyecdb.dbo.GENERALES   
  , BC11_Serie = UPPER(RTRIM(   
                CASE   
                  WHEN CHARINDEX('-', DNUMDOC) > 0 THEN   
                    CASE WHEN isnumeric(RTRIM(SUBSTRING(DNUMDOC, 1, CHARINDEX('-', DNUMDOC) -1))) = 1 THEN   
                      CASE WHEN RTRIM(DTIPDOC) = 'BA' THEN RTRIM(SUBSTRING(DNUMDOC, 1, CHARINDEX('-', DNUMDOC) -1))   
            ELSE RIGHT('0' + RTRIM(SUBSTRING(DNUMDOC, 1, CHARINDEX('-', DNUMDOC) -1)), 4)   
                      END   
                    ELSE   
                      --CASE WHEN SUBSTRING(RTRIM(SUBSTRING(DNUMDOC, 1, CHARINDEX('-', DNUMDOC) -1)),1,2) IN ('LS', 'BL') THEN '0001'   
                      --ELSE 
                      RTRIM(SUBSTRING(DNUMDOC, 1, CHARINDEX('-', DNUMDOC) -1))   
                    --END   
                    END   
            ELSE '0001'   
                END   
              ))   
  , BC12_Numero = CASE   
                    WHEN ISNULL(   
                      CASE   
                        WHEN CHARINDEX('-', DNUMDOC) > 0 THEN REPLACE(SUBSTRING(DNUMDOC, CHARINDEX('-', DNUMDOC) + 1, 15),'/','') 
                        ELSE REPLACE(DNUMDOC, '/', '')   
                      END,   
                      ''   
                    ) = '' THEN 'NA'   
                    ELSE   
                      CASE   
                        WHEN CHARINDEX('-', DNUMDOC) > 0 THEN REPLACE(SUBSTRING(DNUMDOC, CHARINDEX('-', DNUMDOC) + 1, 15),'/','')   
                    ELSE REPLACE(DNUMDOC, '/', '')   
                      END   
                  END  
  --, BC11_Serie = case 
			--             when DNUMDOC = '' then '0000'
			--             else
			--                       iif( DTIPDOC in ('FT','ND','NC','NA') and charindex('-',DNUMDOC,1)>0 , substring( DNUMDOC , 1                          , charindex('-',DNUMDOC,1)-1 ) , '0001'  )
			--             end   
  --, BC12_Numero = iif( DNUMDOC = '', 'NA' ,
			--                 replace(  
			--                 replace(  
				--                     iif( DTIPDOC in ('FT','ND','NC','NA') and charindex('-',DNUMDOC,1)>0 , substring( DNUMDOC , charindex('-',DNUMDOC,1)+1 , 100                        ) , DNUMDOC ) 
			--                 ,'-','')
			--                 ,'/','')
			--                 )  
   
  , BC13_FechaContable      = ISNULL(CONVERT(VARCHAR(10), DFECCOM2, 103), '')   
  , BC14_FechaVencimiento   = ISNULL(-- CASE   
                                  --WHEN ISNULL(DFECVEN2, '') = '' THEN '01/01/1900'   
                                  --ELSE CONVERT(VARCHAR(10), DFECVEN2, 103)   
                                  -- ELSE   
                                  CONVERT(VARCHAR(10), ISNULL(DFECVEN2, ISNULL(DFECDOC2, DFECCOM2)), 103)   
                                  --END   
  , '')   
  , BC15_FechaDocumento     = ISNULL(CONVERT(VARCHAR(10), CASE   
                              WHEN ISNULL(DFECDOC2, '') = '' THEN DFECCOM2   
                                ELSE CASE   
                                  WHEN CONVERT(VARCHAR(6), DFECDOC2, 112) > CONVERT(VARCHAR(4), PERIODO_DET) + SUBSTRING(DCOMPRO, 1, 2) THEN DFECCOM2   
                                  ELSE DFECDOC2   
            END   
                              END, 103), '')   
  , BC16_Glosa_ParaComparar = IIF(RTRIM(d.DXGLOSA) = '', CGLOSA, d.DXGLOSA)
  , BC16_Glosa              = IIF(RTRIM(d.DXGLOSA) = '', CGLOSA, d.DXGLOSA)
  , BC18_Debe               = convert(varchar,iif( (ddh='D' AND DMNIMPOR>0) OR (ddh='H' AND DMNIMPOR<0) , abs(DMNIMPOR) ,0))   
  , BC19_Haber              = convert(varchar,iif( (ddh='H' AND DMNIMPOR>0) OR (ddh='D' AND DMNIMPOR<0) , abs(DMNIMPOR) ,0))   
  , BC20_Estructura     = CASE   
                  WHEN DSUBDIA IN ('11', '12', '13', '18')   
                    AND DCUENTA IN ('421201', '421202', '431201', '431202')   
                    AND (   
                      (   
                        dtipdoc = 'NA'   
                        and DDH = 'D'   
                      ) OR (                                                            dtipdoc <> 'NA'   
                        and DDH = 'H'   
                      )   
                    )   
                    AND ISNULL(TIPODOC_IDENT, '') = 'OTR' THEN '080200' + '&' + '2023' + SUBSTRING(DCOMPRO, 1, 2) + '00' + '&' + Rtrim(dsubdia) + Rtrim(dcompro) + Rtrim(dsecue) + '&' + 'M' + Rtrim(dsubdia) + Rtrim(dcompro)   
                    --AND ISNULL(DCODANE, '') = 'OTR' THEN '080200' + '&' + '2023' + SUBSTRING(DCOMPRO, 1, 2) + '00' + '&' + Rtrim(dsubdia) + Rtrim(dcompro) + Rtrim(dsecue) + '&' + 'M' + Rtrim(dsubdia) + Rtrim(dcompro)   
   
                WHEN DSUBDIA IN ('11', '12', '13', '18')   
                    AND DCUENTA IN ('421201', '421202', '431201', '431202')   
                    AND (   
                      (   
    dtipdoc = 'NA'   
                    and DDH = 'D'   
                      )   
                      or (   
                        dtipdoc <> 'NA'   
                        and DDH = 'H'   
                      )   
                    )   
                    AND ISNULL(TIPODOC_IDENT, '') <> 'OTR' THEN '080100' + '&' + '2023' + SUBSTRING(DCOMPRO, 1, 2) + '00' + '&' + Rtrim(dsubdia) + Rtrim(dcompro) + Rtrim(dsecue) + '&' + 'M' + Rtrim(dsubdia) + Rtrim(dcompro)   
   
                    --AND ISNULL(DCODANE, '') <> 'OTR' THEN '080100' + '&' + '2023' + SUBSTRING(DCOMPRO, 1, 2) + '00' + '&' + Rtrim(dsubdia) + Rtrim(dcompro) + Rtrim(dsecue) + '&' + 'M' + Rtrim(dsubdia) + Rtrim(dcompro)   
  
                WHEN DSUBDIA in ('05', '06')   
                    AND d.DDH =CASE   
                        WHEN DTIPDOC = 'NA' THEN 'H'   
                        ELSE 'D'   
                END   
                    AND SUBSTRING(DCUENTA, 1, 3) IN ('121', '131', '165') THEN '140100' + '&' + '2023' + SUBSTRING(DCOMPRO, 1, 2) + '00' + '&' + Rtrim(dsubdia) + Rtrim(dcompro) + Rtrim(dsecue) + '&' + 'M' + Rtrim(dsubdia) + Rtrim(dcompro)   
                ELSE ''   
            END   
   
  , B_Saldo              = iif( (ddh='D' AND DMNIMPOR>0) OR (ddh='H' AND DMNIMPOR<0) , abs(DMNIMPOR) ,0)   
                              - iif( (ddh='H' AND DMNIMPOR>0) OR (ddh='D' AND DMNIMPOR<0) , abs(DMNIMPOR) ,0)   
   
  , B_IdCompania            = @IdCompania   
  , B_CodigoAnioPeriodo     = CONCAT(PERIODO_DET, left(DCOMPRO,2))   
  , B_CodigoEnproyecdb      = d.empresa   
  INTO #ple050100_origen
FROM #fragmentoAnioConcar2 d
  LEFT JOIN BD_SERVICIO_TEST.Sunat.Padron_Reducido_Ruc r (nolock)
		ON r.RUC = DCODANE collate SQL_Latin1_General_CP1_CI_AS

  --  select getdate()   

  -- UPDATE GLOSA
  UPDATE #ple050100_origen SET BC16_Glosa_ParaComparar = TRANSLATE(BC16_Glosa_ParaComparar, char(9) + char(13) + char(10) + ':,¥ÑÍÁó|/¢Éø°', '                 ')
                                              WHERE PATINDEX('%'+ char(9)+'%', BC16_Glosa_ParaComparar) > 0
                                                OR PATINDEX('%'+ char(13)+'%', BC16_Glosa_ParaComparar) > 0
                                                OR PATINDEX('%'+ char(10)+'%', BC16_Glosa_ParaComparar) > 0
                                                OR PATINDEX('%:%', BC16_Glosa_ParaComparar) > 0
                                                OR PATINDEX('%,%', BC16_Glosa_ParaComparar) > 0
                                                OR PATINDEX('%¥%', BC16_Glosa_ParaComparar) > 0
                                                OR PATINDEX('%Ñ%', BC16_Glosa_ParaComparar) > 0
                                                OR PATINDEX('%Í%', BC16_Glosa_ParaComparar) > 0
                                                OR PATINDEX('%Á%', BC16_Glosa_ParaComparar) > 0
                                                OR PATINDEX('%ó%', BC16_Glosa_ParaComparar) > 0
                                                OR PATINDEX('%|%', BC16_Glosa_ParaComparar) > 0
                                                OR PATINDEX('%/%', BC16_Glosa_ParaComparar) > 0
                                                OR PATINDEX('%¢%', BC16_Glosa_ParaComparar) > 0
                                                OR PATINDEX('%É%', BC16_Glosa_ParaComparar) > 0
                                                OR PATINDEX('%ø%', BC16_Glosa_ParaComparar) > 0
                                                OR PATINDEX('%%', BC16_Glosa_ParaComparar) > 0
                                                OR PATINDEX('%°%', BC16_Glosa_ParaComparar) > 0;

  UPDATE #ple050100_origen SET BC11_Serie = REPLACE(BC11_Serie, '_','') WHERE PATINDEX('%_%', BC12_Numero) > 0;

  -- UPDATE NUMERO
  UPDATE #ple050100_origen SET BC12_Numero = TRANSLATE(BC12_Numero, '-*.°+Ó|<', '       O')
              WHERE PATINDEX('%-%', BC12_Numero) > 0
                OR PATINDEX('%*%', BC12_Numero) > 0
                OR PATINDEX('%.%', BC12_Numero) > 0
                OR PATINDEX('%°%', BC12_Numero) > 0
                OR PATINDEX('%+%', BC12_Numero) > 0
                OR PATINDEX('%Ó%', BC12_Numero) > 0
                OR PATINDEX('%|%', BC12_Numero) > 0
                OR PATINDEX('%<%', BC12_Numero) > 0

  UPDATE #ple050100_origen SET BC16_Glosa_ParaComparar = REPLACE(BC16_Glosa_ParaComparar, ' ', '')
                            , BC12_Numero = REPLACE(REPLACE(REPLACE(BC12_Numero, ' ', ''), char(13), ''), char(10), '');


DELETE FROM Financiero.SunatElectronicoTxtGenerado WHERE IdCompania = @IdCompania AND Codigo = '050100';

INSERT INTO Financiero.SunatElectronicoTxtGenerado (
  Codigo, IdCompania, CodigoAnioPeriodo,

  Col1, Col2, Col3, Col4, Col5, 
  Col6, Col7, Col8, Col9, Col10, 
  Col11, Col12, Col13, Col14, Col15, 
  Col16, Col17, Col18, Col19, Col20, 
  Col21, Fila
)
SELECT
'050100', @IdCompania, LEFT(BC1_Periodo, 6)
, BC1_Periodo, BC2_Cuo, BC3_Correlativo, BC4_Cuenta, BC5_UnidadOperacion
, BC6_CentroCosto, BC7_MonedaOrigen, BC8_TipoDocumento, BC9_NumeroDocumento, BC10_TipoComprobante
, BC11_Serie, BC12_Numero, BC13_FechaContable, BC14_FechaVencimiento, BC15_FechaDocumento 
, BC16_Glosa, '', BC18_Debe , BC19_Haber, BC20_Estructura
, '1', 1
FROM #ple050100_origen;