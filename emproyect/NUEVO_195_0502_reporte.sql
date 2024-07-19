DROP TABLE IF EXISTS #ple050100RectificaNuevoModifica0

DECLARE @Periodo VARCHAR(32) = '202407';
DECLARE @Companias VARCHAR(32) = '32';

SELECT    
    C1_Periodo      
    , C21_Estado            = COUNT(1)

    , IdCompania
    , CodigoAnioPeriodo = PeriodoFinRectifica  
    , Reporte = 'Modifica por CERO'
    , ExisteEnOrigen = 'N'
    , ExisteEnTxt = 'S'
    into #ple050100RectificaNuevoModifica0
FROM Financiero.PLE_050100_rectifica as pl (nolock)    
WHERE SistemaOrigen = 'CONCAR' AND ExisteEnOrigen = 'N'
AND PeriodoFinRectifica = @Periodo AND IdCompania IN (@Companias)
GROUP BY IdCompania, PeriodoFinRectifica, C1_Periodo

UNION ALL

SELECT
    C1_Periodo      
    , C21_Estado            = COUNT(1)

    , IdCompania
    , CodigoAnioPeriodo = PeriodoFinRectifica  
    , Reporte = 'Nuevo Registro'
    , ExisteEnOrigen = 'S'
    , ExisteEnTxt = 'N'
FROM Financiero.PLE_050100_rectifica as pl (nolock)    
WHERE SistemaOrigen = 'CONCAR' AND ExisteEnTxt = 'N'
AND PeriodoFinRectifica = @Periodo AND IdCompania IN (@Companias)
GROUP BY IdCompania, PeriodoFinRectifica, C1_Periodo


SELECT  
  TXT  
  , C1_Periodo          = C1_Periodo   
  , C2_Cuo              = Cuo  
  , C3_Correlativo      = Correlativo  
  , C4_Cuenta           = Cuenta  
  , C5_UnidadOperacion  = UnidadOperacion  
  , C6_CentroCosto      = CentroCosto  
  , C7_MonedaOrigen     = MonedaOrigen  
  , C8_TipoDocumento    = TipoDocIdentidad  
  , C9_NumeroDocumento  = NroDocIdentidad      
  , C10_TipoComprobante = TipoDocumento  
  , C11_Serie           = Serie      
  , C12_Numero          = Numero  
  , C13_FechaContable   = ISNULL(CONVERT(VARCHAR(10), FechaContable, 103), '')  
  , C14_FechaVencimiento = ISNULL(CONVERT(VARCHAR(10), FechaVencimiento, 103), '')   
  , C15_FechaDocumento  = ISNULL(CONVERT(VARCHAR(10), FechaOperacion, 103), '')   
  , C16_Glosa           = Glosa    
  , C17_GlosaReferencial= GlosaRef  
  , C18_Debe            = Debe  
  , C19_Haber           = Haber  
  , C20_Estructura      = DatoEstructura  
  , C21_Estado          = Estado  
  
  , IdCompania            
  , DescripcionCompania = ec.Descripcion   
  , IdT10TipoComprobante=''  
  , CodigoAnioPeriodo  = LEFT(C1_Periodo,6)  
    
  , Tipo = 1  
  , Reporte = ''    
  , ExisteEnOrigen = ''    
  , ExisteEnTxt = ''    
  , Motivo = ''    
  , De = ''    
  , Por = ''       

FROM Financiero.PLE_050100 pl (nolock)      
INNER JOIN Maestros.EntidadCompania as ec (nolock) ON pl.IdCompania = ec.Id      
WHERE DSUBDIA != 38 AND CodigoAnioPeriodo = @Periodo AND IdCompania = @Companias

UNION ALL

SELECT   
  TXT  
  , C1_Periodo    
  , C2_Cuo      
  , C3_Correlativo      
  , C4_Cuenta      
  , C5_UnidadOperacion      
  , C6_CentroCosto      
  , C7_MonedaOrigen      
  , C8_TipoDocumento      
  , C9_NumeroDocumento         
  , C10_TipoComprobante         
  , C11_Serie      
  , C12_Numero      
  , C13_FechaContable      
  , C14_FechaVencimiento      
  , C15_FechaDocumento      
  , C16_Glosa      
  , C17_GlosaReferencial        
  , C18_Debe    
  , C19_Haber    
  , C20_Estructura    
  , C21_Estado   
  
  , IdCompania    
  , DescripcionCompania = ec.Descripcion  
  , IdT10TipoComprobante = ''  
  , CodigoAnioPeriodo = pl.PeriodoFinRectifica  
    
  , Tipo = 1  
  , Reporte  
  , ExisteEnOrigen  
  , ExisteEnTxt  
  , Motivo    
  , De  
  , Por  

FROM Financiero.PLE_050100_rectifica AS pl (nolock)  
INNER JOIN Maestros.EntidadCompania AS ec (nolock) ON pl.IdCompania = ec.Id  
WHERE SistemaOrigen = 'CONCAR' AND pl.PeriodoFinRectifica = @Periodo AND IdCompania = @Companias

UNION ALL

SELECT    
    TXT = ''  
    , C1_Periodo      
    , C2_Cuo                = CONVERT(VARCHAR, SUM(IIF(Motivo LIKE '%C2_Cuo%', 1, 0)))    
    , C3_Correlativo        = CONVERT(VARCHAR, SUM(IIF(Motivo LIKE '%C3_Correlativo%', 1, 0)))    
    , C4_Cuenta             = CONVERT(VARCHAR, SUM(IIF(Motivo LIKE '%C4_Cuenta%', 1, 0)))    
    , C5_UnidadOperacion    = CONVERT(VARCHAR, SUM(IIF(Motivo LIKE '%C5_UnidadOperacion%', 1, 0)))    
    , C6_CentroCosto        = CONVERT(VARCHAR, SUM(IIF(Motivo LIKE '%C6_CentroCosto%', 1, 0)))    
    , C7_MonedaOrigen       = CONVERT(VARCHAR, SUM(IIF(Motivo LIKE '%C7_MonedaOrigen%', 1, 0)))    
    , C8_TipoDocumento      = CONVERT(VARCHAR, SUM(IIF(Motivo LIKE '%C8_TipoDocumento%', 1, 0)))    
    , C9_NumeroDocumento    = CONVERT(VARCHAR, SUM(IIF(Motivo LIKE '%C9_NumeroDocumento%', 1, 0)))    
    , C10_TipoComprobante   = CONVERT(VARCHAR, SUM(IIF(Motivo LIKE '%C10_TipoComprobante%', 1, 0)))    
    , C11_Serie             = CONVERT(VARCHAR, SUM(IIF(Motivo LIKE '%C11_Serie%', 1, 0)))    
    , C12_Numero            = CONVERT(VARCHAR, SUM(IIF(Motivo LIKE '%C12_Numero%', 1, 0)))    
    , C13_FechaContable     = CONVERT(VARCHAR, SUM(IIF(Motivo LIKE '%C13_FechaContable%', 1, 0)))    
    , C14_FechaVencimiento  = CONVERT(VARCHAR, SUM(IIF(Motivo LIKE '%C14_FechaVencimiento%', 1, 0)))    
    , C15_FechaDocumento    = CONVERT(VARCHAR, SUM(IIF(Motivo LIKE '%C15_FechaDocumento%', 1, 0)))    
    , C16_Glosa             = CONVERT(VARCHAR, SUM(IIF(Motivo LIKE '%C16_Glosa%', 1, 0)))    
    , C17_GlosaReferencial  = CONVERT(VARCHAR, SUM(IIF(Motivo LIKE '%C17_GlosaReferencial%', 1, 0)))    
    , C18_Debe              = SUM(IIF(Motivo LIKE '%C18_Debe%', 1, 0))    
    , C19_Haber             = SUM(IIF(Motivo LIKE '%C18_Debe%', 1, 0))
    , C20_Estructura        = CONVERT(VARCHAR, SUM(IIF(Motivo LIKE '%C20_Estructura%', 1, 0)))    
    , C21_Estado            = COUNT(1)

    , IdCompania      
    , DescripcionCompania = ''    
    , IdT10TipoComprobante = ''   
    , CodigoAnioPeriodo = PeriodoFinRectifica  
      
    , Tipo = 2  
    , Reporte = 'Rectificado'
    , ExisteEnOrigen = 'S'    
    , ExisteEnTxt = 'S'    
    , Motivo = ''    
    , De = ''    
    , Por = ''   
FROM Financiero.PLE_050100_rectifica as pl (nolock)    
WHERE SistemaOrigen = 'CONCAR' AND ExisteEnOrigen = 'S' AND ExisteEnTxt = 'S' AND C21_Estado = 9 
AND PeriodoFinRectifica = @Periodo AND IdCompania IN (@Companias)
GROUP BY IdCompania, PeriodoFinRectifica, C1_Periodo

UNION ALL

SELECT    
    TXT = ''  
    , C1_Periodo      
    , C2_Cuo                = '0'
    , C3_Correlativo        = '0'
    , C4_Cuenta             = '0'
    , C5_UnidadOperacion    = '0'
    , C6_CentroCosto        = '0'
    , C7_MonedaOrigen       = '0'
    , C8_TipoDocumento      = '0'
    , C9_NumeroDocumento    = '0'
    , C10_TipoComprobante   = '0'
    , C11_Serie             = '0'
    , C12_Numero            = '0'
    , C13_FechaContable     = '0'
    , C14_FechaVencimiento  = '0'
    , C15_FechaDocumento    = '0'
    , C16_Glosa             = '0'
    , C17_GlosaReferencial  = '0'
    , C18_Debe              = '0'
    , C19_Haber             = '0'
    , C20_Estructura        = '0'
    , C21_Estado            = C21_Estado

    , IdCompania      
    , DescripcionCompania = ''    
    , IdT10TipoComprobante = ''   
    , CodigoAnioPeriodo = CodigoAnioPeriodo  
      
    , Tipo = 2  
    , Reporte = Reporte
    , ExisteEnOrigen
    , ExisteEnTxt
    , Motivo = ''    
    , De = ''    
    , Por = ''   

FROM #ple050100RectificaNuevoModifica0 as pl

UNION ALL

SELECT
    TXT = ''  
    , C1_Periodo            = @Periodo
    , C2_Cuo                = ''
    , C3_Correlativo        = ''
    , C4_Cuenta             = ''
    , C5_UnidadOperacion    = ''
    , C6_CentroCosto        = ''
    , C7_MonedaOrigen       = ''
    , C8_TipoDocumento      = ''
    , C9_NumeroDocumento    = ''
    , C10_TipoComprobante   = ''
    , C11_Serie             = ''
    , C12_Numero            = ''
    , C13_FechaContable     = ''
    , C14_FechaVencimiento  = ''
    , C15_FechaDocumento    = ''
    , C16_Glosa             = ''
    , C17_GlosaReferencial  = ''
    , C18_Debe              = 0
    , C19_Haber             = 0
    , C20_Estructura        = ''
    , C21_Estado            = ''

    , IdCompania            = @Companias
    , DescripcionCompania   = ''    
    , IdT10TipoComprobante  = ''   
    , CodigoAnioPeriodo     = @Periodo
      
    , Tipo = 3 
    , Reporte = SUBSTRING([value], 1, CHARINDEX('|', [value]) - 1)
    , ExisteEnOrigen = ''    
    , ExisteEnTxt = ''    
    , Motivo = SUBSTRING([value], CHARINDEX('|', [value]) + 1, LEN([value]))
    , De = ''    
    , Por = ''   
FROM STRING_SPLIT((
    SELECT ObservacionUltimoProcesado
    FROM Financiero.ViewSunatElectronicoPeriodo (nolock)
    WHERE CodigoAnioPeriodo = @Periodo
      AND IdCompania = @Companias
      AND CodigoSunatElectronico = '050100'
  ), CHAR(10))