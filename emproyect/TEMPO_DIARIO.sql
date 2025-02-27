USE [ENPROYECDB]
GO
/****** Object:  StoredProcedure [dbo].[SP_GENERA_DIARIO]    Script Date: 2/12/2024 16:40:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************/                                                              
--- Creado Por     : Carlos Julca Acosta                                                              
--- Fecha Creación : 19/09/2013                                                              
--  Descripción    : Reporte DIARIO                                                              
--                   Libro Electronico                                                               
/*****************************************/                                                              
ALTER PROCEDURE [dbo].[SP_GENERA_DIARIO]  @AS_EMPRESA CHAR(4), @ANIO CHAR(4) ,@MES CHAR(2),@MES2 CHAR(2)=@MES                                                             
AS                                                              
                                
 --declare @AS_EMPRESA CHAR(4), @ANIO CHAR(4) ,@MES CHAR(2)  ,@MES2 CHAR(2)                              
 --select @AS_EMPRESA='0003',@ANIO='2024',@MES='08'  ,@MES2='08'                              
                                                              
DECLARE @XEMPCON CHAR(2),@XYY CHAR(2), @LS_SELECT1 VARCHAR(8000),@ls_select2  VARCHAR(8000)='' ,@ABREVIADO VARCHAR(10),@LS_FECHA_INI VARCHAR(10),@AS_PERIODO CHAR(8)                                                          
DECLARE @PER CHAR(6),@DBCONCAR VARCHAR(50) ,@XPLAN CHAR(2),@DBCONCARTRIB VARCHAR(50)                                
                          
SET  @LS_FECHA_INI='01/'+RTRIM(@MES)+'/'+CONVERT(CHAR(4),@ANIO)                                                      
SET    @XYY=SUBSTRING(@ANIO,3,2)                                   
                      
                      
/*BD CONCAR*/                                                
SELECT @DBCONCAR    =LTRIM(RTRIM(DESCRIPCION)) FROM TB_TABLAS_GEN WITH (NOLOCK) WHERE CLAVE='65' AND codigo='01'                           
SELECT @DBCONCARTRIB=LTRIM(RTRIM(DESCRIPCION)) FROM TB_TABLAS_GEN WITH (NOLOCK) WHERE CLAVE='65' AND codigo='02'                           
                                   
--SELECT @XEMPCON=Case when  @AS_EMPRESA='0001' then CASE WHEN @XYY<='13' THEN '04' ELSE Case when @XYY<='16' then '14' else emp_concar End End                          
--    Else   emp_concar End ,                          
--@ABREVIADO=ABREVIADO ,@AS_PERIODO=RTRIM(CONVERT(CHAR(4),@ANIO)+@MES+'00' ), @PER=RTRIM(CONVERT(CHAR(4),@ANIO)+@MES)                                                        
--FROM EMPRESAS WITH (NOLOCK) WHERE empresa=@AS_EMPRESA                            
                  
/*Para Relaciones Comunitaarias*/                  
SELECT @XEMPCON = E.EMP_CONCAR   ,                      
@ABREVIADO=ABREVIADO ,@AS_PERIODO=RTRIM(CONVERT(CHAR(4),@ANIO)+@MES+'00' ), @PER=RTRIM(CONVERT(CHAR(4),@ANIO)+@MES) , @XPLAN=E.emp_plan                  
FROM   EMPRESAS E WITH (NOLOCK)                                    
WHERE IND_EMPRESA_GRUPO=2 AND E.EMPRESA=@AS_EMPRESA                      
                  
                      
SELECT @XEMPCON = H.EMP_CONCAR   ,                      
@ABREVIADO=ABREVIADO ,@AS_PERIODO=RTRIM(CONVERT(CHAR(4),@ANIO)+@MES+'00' ), @PER=RTRIM(CONVERT(CHAR(4),@ANIO)+@MES) , @XPLAN=h.emp_plancta                   
FROM   EMPRESAS E WITH (NOLOCK)                                    
INNER JOIN TB_EMPRESA_HIST H WITH (NOLOCK) ON H.EMPRESA=E.EMPRESA AND @XYY BETWEEN RIGHT(CONVERT(VARCHAR(4),FECHA_INI,112),2) AND RIGHT(CONVERT(VARCHAR(4),FECHA_FIN,112),2)                                    
WHERE IND_EMPRESA_GRUPO=1 AND E.EMPRESA=@AS_EMPRESA                      
    
    
DECLARE @SQLEXISTE VARCHAR(800),@EXISTE INT =0    
DECLARE @TABLE TABLE (EXISTE INT)    
 SET @SQLEXISTE='SELECT EXISTE=COUNT(*) FROM '+@DBCONCARTRIB+'..SYSOBJECTS WHERE XTYPE=''U'' AND NAME='''+'CT00'+@XEMPCON+'COMD'+@XYY+''''    
    
    
INSERT @TABLE (EXISTE)    
EXECUTE  (@SQLEXISTE)    
    
SELECT @EXISTE=EXISTE FROM @TABLE        
    
                                                      
/*CUENTAS PARA NUEVO PLAN 2017*/                          
--SELECT @XEMPCON= CASE  @AS_EMPRESA WHEN '0001' THEN '54' WHEN '0002' THEN '52' WHEN '0003' THEN '56' WHEN '0004' THEN '60'  END                        
/**/                         
                          
--SELECT @ABREVIADO,@ANIO,@AS_EMPRESA,@XEMPCON,@XYY,@MES,@MES2                          
                                                           
 IF @AS_EMPRESA <>'0000'       
 BEGIN                                                              
                            
   SET @ls_select1=' SELECT '''+@ABREVIADO+''',PERIODO='''+@ANIO+'''+SUBSTRING(DCOMPRO,1,2)+''00'',TPLAN=''01'', DSUBDIA, '+ CHAR(13)+                                                              
    'DCOMPRO,'+     CHAR(13)+                                                             
    'DSECUE,'+     CHAR(13)+                                         
    'MES=SUBSTRING(DCOMPRO,1,2), '+        CHAR(13)+                               
    'DFECCOM,'+   CHAR(13)+                                                             
    'MCUENTA=SUBSTRING(DCUENTA,1,2), '+  CHAR(13)+                                                                 
    'DCUENTA,'+       CHAR(13)+                                                          
    'CUENTA=(SELECT TOP 1 PDESCRI FROM RSCONCAR..CT00'+@XPLAN+'PLEM WITH (NOLOCK) WHERE PCUENTA=DCUENTA ) ,'+    CHAR(13)+                                                              
    'CASE WHEN ISNULL(DCODANE,'''')='''' THEN ''NA'' ELSE REPLACE(replace(replace(REPLACE(DCODANE,'' '',''''),''.'',''''),''/'',''''),''-'','''') END DCODANE ,'+  CHAR(13)+                                                                
    'ANEXO=(SELECT TOP 1 ADESANE FROM RSCONCAR..CT00'+@XPLAN+'ANEX WITH (NOLOCK) WHERE ACODANE=DCODANE ) ,'+  CHAR(13)+                                                                
    'DCENCOS,'+   CHAR(13)+                                                               
    'DCENCOST=isnull((SELECT TDESCRI FROM  RSCONCAR..CT00'+@XPLAN+'TAGE WITH (NOLOCK) WHERE TCOD=''05'' AND TCLAVE=DCENCOS ),''''),'+  CHAR(13)+                                                                
    'DCODMON,'+   CHAR(13)+                                                               
    'DDH,'+  CHAR(13)+                                                                
    'SOLES  =DMNIMPOR ,'+  CHAR(13)+                                                                
    'DOLARES=DUSIMPOR ,'+  CHAR(13)+                                                                
    'DIMPORT,'+      CHAR(13)+                                                            
    'CASE WHEN ISNUMERIC(CASE WHEN ISNULL(CASE WHEN CHARINDEX(''-'',DNUMDOC)>0 THEN REPLACE(SUBSTRING(DNUMDOC, CHARINDEX(''-'',DNUMDOC)+1,15),''/'','''') '+  CHAR(13)+                                
    'ELSE REPLACE(DNUMDOC,''/'','''') END,'''')='''' THEN ''NA'' ELSE CASE WHEN CHARINDEX(''-'',DNUMDOC)>0 THEN REPLACE(SUBSTRING(DNUMDOC, CHARINDEX(''-'',DNUMDOC)+1,15),''/'','''') '+  CHAR(13)+                                
    'ELSE replace(DNUMDOC,''/'','''') END END)=1 THEN ISNULL(D.COD_SUNAT,''00'') ELSE ''00'' END DTIPDOC,'+   CHAR(13)+                                                               
    'upper(REPLACE(DNUMDOC,''/'','''')) DNUMDOC, '+  CHAR(13)+                                                                
    'CASE WHEN isnull(DFECDOC,'''')='''' THEN DFECCOM ELSE CASE WHEN CONVERT(VARCHAR(6),DFECDOC2,112)>'''+CONVERT(CHAR(4),@ANIO)+'''+SUBSTRING(DCOMPRO,1,2) THEN DFECCOM ELSE DFECDOC END END  DFECDOC,'+  CHAR(13)+                                           
    'DFECVEN,'+  CHAR(13)+                                                                
    'DAREA,'+ CHAR(13)+                                                                
    'GLOSA=replace(CASE WHEN LEN(RTRIM(DXGLOSA))>0 THEN RTRIM(LTRIM(DXGLOSA))+REPLICATE('' '',30 - LEN(RTRIM(LTRIM(DXGLOSA)))) ELSE RTRIM(LTRIM(CGLOSA))+REPLICATE('' '',40 - LEN(RTRIM(LTRIM(CGLOSA)))) END,''/'','''') ,'+   CHAR(13)+                       
    'DUSIMPOR,'+   CHAR(13)+                                                               
    'DMNIMPOR,'+  CHAR(13)+                                                                
    'DCODARC,'+    CHAR(13)+                                                              
    'DFECCOM2,'+    CHAR(13)+                                                              
    'CASE WHEN isnull(DFECDOC2,'''')='''' THEN DFECCOM2 ELSE CASE WHEN CONVERT(VARCHAR(6),DFECDOC2,112)>'''+CONVERT(CHAR(4),@ANIO)+'''+SUBSTRING(DCOMPRO,1,2) THEN DFECCOM2 ELSE DFECDOC2 END  END DFECDOC2 ,'+  CHAR(13)+                
    'isnull(DFECVEN2,'''') DFECVEN2,'+  CHAR(13)+                                                                
    'DVANEXO,'+   CHAR(13)+                                       
    'DCTAORI,'+  CHAR(13)+                                                                
    'DTIPDOR,'+   CHAR(13)+                
    'DNUMDOR,'+   CHAR(13)+                                                               
    'CASE WHEN isnull(DFECDOC2,'''')='''' THEN DFECCOM2 ELSE CASE WHEN CONVERT(VARCHAR(6),DFECDOC2,112)>'''+CONVERT(CHAR(4),@ANIO)+'''+SUBSTRING(DCOMPRO,1,2) THEN DFECCOM2 ELSE DFECDOC2 END  END ,'+  CHAR(13)+                                              
  
    'FECHA_OPERA=CASE WHEN DSUBDIA IN (''11'',''12'',''13'',''15'') THEN  '+  CHAR(13)+                                                  
    'CASE WHEN DATEDIFF(MM,CONVERT(DATETIME,DFECDOC2,103),CONVERT(DATETIME,'''+'01/''+SUBSTRING(DCOMPRO,1,2)+''/'+CONVERT(CHAR(4),@ANIO)+''',103))>0 THEN DFECDOC2 ELSE DFECCOM2 END ELSE DFECCOM2  END, '+  CHAR(13)+                                         
  
    'ESTADO =''1'' ,'+  CHAR(13)+                                         
    'UNIDADOPERA='''',' +   CHAR(13)+                                       
    'G.COD_SUNAT MONEDA_SUNAT ,' +  CHAR(13)+                                    
    'TIPODOCID=case when ISNUMERIC(A.DCODANE)=0  THEN ''0'' ELSE CASE WHEN CONVERT(NUMERIC(20),A.DCODANE)=0 THEN ''0'' '+ CHAR(13)+                                 
    'ELSE CASE  LEN(RTRIM(A.DCODANE)) WHEN 8 THEN ''1'' WHEN 11 THEN CASE WHEN DBO.FN_VALIDARUC(RTRIM(A.DCODANE))=1 THEN ''6'' ELSE ''0'' END ELSE ''0'' END END END , '+ CHAR(13)+                                         
    'SERIE=REPLACE(upper(RTRIM(CASE WHEN CHARINDEX(''-'',DNUMDOC)>0 THEN CASE WHEN isnumeric(RTRIM(SUBSTRING(DNUMDOC,1, CHARINDEX(''-'',DNUMDOC)-1)))=1 THEN CASE WHEN '+   CHAR(13)+                     
    ' RTRIM(DTIPDOC)=''BA'' THEN RTRIM(SUBSTRING(DNUMDOC,1, CHARINDEX(''-'',DNUMDOC)-1)) ELSE RIGHT(''0''+RTRIM(SUBSTRING(DNUMDOC,1, CHARINDEX(''-'',DNUMDOC)-1)),4) END '+  CHAR(13)+                                 
    ' ELSE CASE WHEN SUBSTRING(RTRIM(SUBSTRING(DNUMDOC,1, CHARINDEX(''-'',DNUMDOC)-1)),1,2) IN (''LS'',''BL'')  THEN ''0001''   ELSE RTRIM(SUBSTRING(DNUMDOC,1, CHARINDEX(''-'',DNUMDOC)-1)) END  END ELSE ''0001'' END) ),''/'',''''),'+  CHAR(13)+           
   
    ' NUMERO=REPLACE(CASE WHEN ISNULL(CASE WHEN CHARINDEX(''-'',DNUMDOC)>0 THEN REPLACE(SUBSTRING(DNUMDOC, CHARINDEX(''-'',DNUMDOC)+1,15),''/'','''') ELSE REPLACE(DNUMDOC,''/'','''') END,'''')='''' THEN ''NA'' '+  CHAR(13)+                                
    ' ELSE CASE WHEN CHARINDEX(''-'',DNUMDOC)>0 THEN REPLACE(SUBSTRING(DNUMDOC, CHARINDEX(''-'',DNUMDOC)+1,15),''/'','''') ELSE iif(dtipdoc=''PB'',right(''000000000000000''+replace(DNUMDOC,''/'',''''),15) ,replace(DNUMDOC,''/'','''') ) END END,''°'','''')  , '+   CHAR(13)+                                  
    ' GLOSAADIC='''','+    CHAR(13)+                                      
    '  CASE WHEN DSUBDIA IN (''11'',''12'',''13'',''18'') AND DCUENTA IN (''421201'',''421202'',''431201'',''431202'') AND ( (dtipdoc=''NA'' and DDH=''D'') or (dtipdoc<>''NA'' and DDH=''H'')) '+   CHAR(13)+                                       
    '             AND ISNULL(PE.TIPODOC_IDENT,'''')=''OTR'' THEN ''080200''+''&''+'''+CONVERT(CHAR(4),@ANIO)+'''+SUBSTRING(DCOMPRO,1,2)+''00'''+'+''&''+Rtrim(dsubdia)+ Rtrim(dcompro) + Rtrim(dsecue)+''&''+''M''+Rtrim(dsubdia)+Rtrim(dcompro)'+  CHAR(13)+  
  
    
      
    '    WHEN  DSUBDIA IN (''11'',''12'',''13'',''18'') AND DCUENTA IN (''421201'',''421202'',''431201'',''431202'') AND ( (dtipdoc=''NA'' and DDH=''D'') or (dtipdoc<>''NA'' and DDH=''H'')) '+  CHAR(13)+                                        
    '             AND ISNULL(PE.TIPODOC_IDENT,'''') <>''OTR'' THEN ''080100''+''&''+'''+CONVERT(CHAR(4),@ANIO)+'''+SUBSTRING(DCOMPRO,1,2)+''00'''+'+''&''+Rtrim(dsubdia)+ Rtrim(dcompro) + Rtrim(dsecue)+''&''+''M''+Rtrim(dsubdia)+Rtrim(dcompro)'+  CHAR(13)+
  
    
      
    '    WHEN DSUBDIA in (''05'',''06'') AND A.DDH=CASE WHEN DTIPDOC=''NA'' THEN ''H'' ELSE ''D'' END  AND SUBSTRING(DCUENTA,1,3) IN (''121'',''131'',''165'') '+ CHAR(13)+                            
    '       THEN ''140100''+''&''+'''+CONVERT(CHAR(4),@ANIO)+'''+SUBSTRING(DCOMPRO,1,2)+''00'''+'+''&''+Rtrim(dsubdia)+ Rtrim(dcompro) + Rtrim(dsecue)+''&''+''M''+Rtrim(dsubdia)+Rtrim(dcompro)'+  CHAR(13)+                                        
    ' ELSE '''''+   CHAR(13)+                                       
    ' END  ESTRUCTURA, '+  CHAR(13)+   
    ' UPPER(B.CUSER) USUARIO, '+  CHAR(13)+   
	'  P.CT_CENTFIN entidadFinanciera, '+  CHAR(13)+   
	'  p.cuentaEmpresa, '+  CHAR(13)+   
	'  p.medioPago, '+  CHAR(13)+   
	'  p.beneficiario, '+  CHAR(13)+   
	'  p.nroTransfer'+  CHAR(13)+   
    ' FROM  '+@DBCONCAR+'..CT00'+@XEMPCON+'COMD'+@XYY+' A WITH (NOLOCK) '+ CHAR(13)+                                   
 ' INNER JOIN '+@DBCONCAR+'..CT00'+@XEMPCON+'COMC'+@XYY+' B WITH (NOLOCK) ON A.DSUBDIA=B.CSUBDIA AND A.DCOMPRO=B.CCOMPRO '+   CHAR(13)+      
    ' INNER JOIN GENERALES G WITH (NOLOCK) ON G.CLAVE=''006'' AND G.CODIGO=A.DCODMON '+  CHAR(13)+                                     
    ' LEFT  JOIN GENERALES D WITH (NOLOCK) ON D.CLAVE=''011'' AND D.CODIGO=CASE WHEN A.DTIPDOC=''BV'' AND (A.DCUENTA=''631121'' OR A.DCTAORI=''631121'') THEN ''BVE'' ELSE A.DTIPDOC END '+  CHAR(13)+                                 
    ' LEFT  JOIN PUB_PERSONAS PE WITH (NOLOCK) ON PE.IDPERSONA=DCODANE '+   CHAR(13)+
	' LEFT JOIN (SELECT EMPRESA,SUBDIA_CONTAB,COMPR_CONTAB,YEAR(FCH_PROGPAGO) PERIODO,e.CT_CENTFIN, anx_bco cuentaEmpresa,'+ CHAR(13)+
    ' CASE  TIPO_PAGO WHEN ''TR'' THEN ''001'' WHEN ''CH'' THEN ''007'' ELSE ''999'' END MEDIOPAGO, '+   CHAR(13)+
	'       IIF( ISNULL(BENEF_ABREV,'''')='''',P.PROV_ABREV,P.BENEF_ABREV) BENEFICIARIO, '+   CHAR(13)+
	'		CASE  TIPO_PAGO WHEN ''CH'' THEN p.NRO_CHEQUE ELSE replace(P.NRO_TRANSF,''/'','''') END NROTRANSFER '+   CHAR(13)+
    '       FROM OPAGO P (NOLOCK) '+  CHAR(13)+
	'		LEFT JOIN RSCONCAR.DBO.CP0032CUBA E ON E.CT_CNUMCTA=P.ANX_BCO '+ CHAR(13)+
	'		WHERE CTA_EGRESO LIKE ''104%'' AND ESTADO=''S'' AND ESTADO_CTB=''C''' +   CHAR(13)+
    '       ) P ON P.EMPRESA='''+@AS_EMPRESA+''' AND P.SUBDIA_CONTAB=A.DSUBDIA AND P.COMPR_CONTAB=A.DCOMPRO AND P.PERIODO='+@ANIO 
    
 IF @EXISTE >0     
  BEGIN    
      SET @ls_select1=@ls_select1 +' WHERE  A.DSUBDIA NOT IN (''99'') AND SUBSTRING(DCOMPRO,1,2) BETWEEN '''+@MES+''' AND '''+@MES2+''''+CHAR(13) ---- AND DMNIMPOR >0.00' COMENTADO acv           
           
    /**ASIENTO DE CIERRE SD -99  TOMAR DEL CONCAR FINANCIERO PORQUE NO TIENE SD-38*/          
    SET @ls_select2=' SELECT '''+@ABREVIADO+''',PERIODO='''+@ANIO+'''+SUBSTRING(DCOMPRO,1,2)+''00'',TPLAN=''01'', DSUBDIA, '+ CHAR(13)+                                                              
   'DCOMPRO,'+     CHAR(13)+                                                             
   'DSECUE,'+     CHAR(13)+                                         
   'MES=SUBSTRING(DCOMPRO,1,2), '+        CHAR(13)+                               
   'DFECCOM,'+   CHAR(13)+                                                             
   'MCUENTA=SUBSTRING(DCUENTA,1,2), '+  CHAR(13)+                                                                 
   'DCUENTA,'+       CHAR(13)+                                                          
   'CUENTA=(SELECT TOP 1 PDESCRI FROM RSCONCAR..CT00'+@XPLAN+'PLEM WITH (NOLOCK) WHERE PCUENTA=DCUENTA ) ,'+    CHAR(13)+                                                              
   'CASE WHEN ISNULL(DCODANE,'''')='''' THEN ''NA'' ELSE REPLACE(replace(replace(REPLACE(DCODANE,'' '',''''),''.'',''''),''/'',''''),''-'','''') END DCODANE ,'+  CHAR(13)+                                                                
   'ANEXO=(SELECT TOP 1 ADESANE FROM RSCONCAR..CT00'+@XPLAN+'ANEX WITH (NOLOCK) WHERE ACODANE=DCODANE ) ,'+  CHAR(13)+                                                                
   'DCENCOS,'+   CHAR(13)+                                                               
   'DCENCOST=isnull((SELECT TDESCRI FROM  RSCONCAR..CT00'+@XPLAN+'TAGE WITH (NOLOCK) WHERE TCOD=''05'' AND TCLAVE=DCENCOS ),''''),'+  CHAR(13)+                                                                
   'DCODMON,'+   CHAR(13)+                  
   'DDH,'+  CHAR(13)+                                                                
   'SOLES  =DMNIMPOR ,'+  CHAR(13)+                                                                
   'DOLARES=DUSIMPOR ,'+  CHAR(13)+                                                                
   'DIMPORT,'+      CHAR(13)+                                                    
   'CASE WHEN ISNUMERIC(CASE WHEN ISNULL(CASE WHEN CHARINDEX(''-'',DNUMDOC)>0 THEN REPLACE(SUBSTRING(DNUMDOC, CHARINDEX(''-'',DNUMDOC)+1,15),''/'','''') '+  CHAR(13)+                                
   'ELSE REPLACE(DNUMDOC,''/'','''') END,'''')='''' THEN ''NA'' ELSE CASE WHEN CHARINDEX(''-'',DNUMDOC)>0 THEN REPLACE(SUBSTRING(DNUMDOC, CHARINDEX(''-'',DNUMDOC)+1,15),''/'','''') '+  CHAR(13)+                                
   'ELSE replace(DNUMDOC,''/'','''') END END)=1 THEN ISNULL(D.COD_SUNAT,''00'') ELSE ''00'' END DTIPDOC,'+   CHAR(13)+                                                               
   'upper(REPLACE(DNUMDOC,''/'','''')) DNUMDOC, '+  CHAR(13)+                                                                
   'CASE WHEN isnull(DFECDOC,'''')='''' THEN DFECCOM ELSE CASE WHEN CONVERT(VARCHAR(6),DFECDOC2,112)>'''+CONVERT(CHAR(4),@ANIO)+'''+SUBSTRING(DCOMPRO,1,2) THEN DFECCOM ELSE DFECDOC END END  DFECDOC,'+  CHAR(13)+                                           
  
   
   'DFECVEN,'+  CHAR(13)+                                                                
   'DAREA,'+ CHAR(13)+                                                                
   'GLOSA=replace(CASE WHEN LEN(RTRIM(DXGLOSA))>0 THEN RTRIM(LTRIM(DXGLOSA))+REPLICATE('' '',30 - LEN(RTRIM(LTRIM(DXGLOSA)))) ELSE RTRIM(LTRIM(CGLOSA))+REPLICATE('' '',40 - LEN(RTRIM(LTRIM(CGLOSA)))) END,''/'','''') ,'+   CHAR(13)+                        
  
   
      
   'DUSIMPOR,'+   CHAR(13)+                                                               
   'DMNIMPOR,'+  CHAR(13)+                                                                
   'DCODARC,'+    CHAR(13)+                                                              
   'DFECCOM2,'+    CHAR(13)+                                                              
   'CASE WHEN isnull(DFECDOC2,'''')='''' THEN DFECCOM2 ELSE CASE WHEN CONVERT(VARCHAR(6),DFECDOC2,112)>'''+CONVERT(CHAR(4),@ANIO)+'''+SUBSTRING(DCOMPRO,1,2) THEN DFECCOM2 ELSE DFECDOC2 END  END DFECDOC2 ,'+  CHAR(13)+                                      
  
   
      
   'isnull(DFECVEN2,'''') DFECVEN2,'+  CHAR(13)+                                                                
   'DVANEXO,'+   CHAR(13)+                                                             
   'DCTAORI,'+  CHAR(13)+                                                                
   'DTIPDOR,'+   CHAR(13)+                
   'DNUMDOR,'+   CHAR(13)+                                                               
   'CASE WHEN isnull(DFECDOC2,'''')='''' THEN DFECCOM2 ELSE CASE WHEN CONVERT(VARCHAR(6),DFECDOC2,112)>'''+CONVERT(CHAR(4),@ANIO)+'''+SUBSTRING(DCOMPRO,1,2) THEN DFECCOM2 ELSE DFECDOC2 END  END ,'+  CHAR(13)+                                               
  
   
      
   'FECHA_OPERA=CASE WHEN DSUBDIA IN (''11'',''12'',''13'',''15'') THEN  '+  CHAR(13)+                                                  
   'CASE WHEN DATEDIFF(MM,CONVERT(DATETIME,DFECDOC2,103),CONVERT(DATETIME,'''+'01/''+SUBSTRING(DCOMPRO,1,2)+''/'+CONVERT(CHAR(4),@ANIO)+''',103))>0 THEN DFECDOC2 ELSE DFECCOM2 END ELSE DFECCOM2  END, '+  CHAR(13)+                                          
  
   
      
   'ESTADO =''1'' ,'+  CHAR(13)+                                         
   'UNIDADOPERA='''',' +   CHAR(13)+                                       
   'G.COD_SUNAT MONEDA_SUNAT ,' +  CHAR(13)+                                    
   'TIPODOCID=case when ISNUMERIC(A.DCODANE)=0  THEN ''0'' ELSE CASE WHEN CONVERT(NUMERIC(20),A.DCODANE)=0 THEN ''0'' '+ CHAR(13)+                                 
   'ELSE CASE  LEN(RTRIM(A.DCODANE)) WHEN 8 THEN ''1'' WHEN 11 THEN CASE WHEN DBO.FN_VALIDARUC(RTRIM(A.DCODANE))=1 THEN ''6'' ELSE ''0'' END ELSE ''0'' END END END , '+ CHAR(13)+                                         
   'SERIE=upper(RTRIM(CASE WHEN CHARINDEX(''-'',DNUMDOC)>0 THEN CASE WHEN isnumeric(RTRIM(SUBSTRING(DNUMDOC,1, CHARINDEX(''-'',DNUMDOC)-1)))=1 THEN CASE WHEN '+   CHAR(13)+                     
   ' RTRIM(DTIPDOC)=''BA'' THEN RTRIM(SUBSTRING(DNUMDOC,1, CHARINDEX(''-'',DNUMDOC)-1)) ELSE RIGHT(''0''+RTRIM(SUBSTRING(DNUMDOC,1, CHARINDEX(''-'',DNUMDOC)-1)),4) END '+  CHAR(13)+                                 
   ' ELSE CASE WHEN SUBSTRING(RTRIM(SUBSTRING(DNUMDOC,1, CHARINDEX(''-'',DNUMDOC)-1)),1,2) IN (''LS'',''BL'')  THEN ''0001''   ELSE RTRIM(SUBSTRING(DNUMDOC,1, CHARINDEX(''-'',DNUMDOC)-1)) END  END ELSE ''0001'' END) ),'+  CHAR(13)+                        
  
   
      
   ' NUMERO=REPLACE(CASE WHEN ISNULL(CASE WHEN CHARINDEX(''-'',DNUMDOC)>0 THEN REPLACE(SUBSTRING(DNUMDOC, CHARINDEX(''-'',DNUMDOC)+1,15),''/'','''') ELSE REPLACE(DNUMDOC,''/'','''') END,'''')='''' THEN ''NA'' '+  CHAR(13)+                                
   ' ELSE CASE WHEN CHARINDEX(''-'',DNUMDOC)>0 THEN REPLACE(SUBSTRING(DNUMDOC, CHARINDEX(''-'',DNUMDOC)+1,15),''/'','''') ELSE iif(dtipdoc=''PB'',right(''000000000000000''+replace(DNUMDOC,''/'',''''),15) ,replace(DNUMDOC,''/'','''') ) END END,''°'','''')  , '+   CHAR(13)+                                  
   ' GLOSAADIC='''','+    CHAR(13)+                                      
   '  CASE WHEN DSUBDIA IN (''11'',''12'',''13'',''18'') AND DCUENTA IN (''421201'',''421202'',''431201'',''431202'') AND ( (dtipdoc=''NA'' and DDH=''D'') or (dtipdoc<>''NA'' and DDH=''H'')) '+   CHAR(13)+                                       
   '             AND ISNULL(PE.TIPODOC_IDENT,'''')=''OTR'' THEN ''080200''+''&''+'''+CONVERT(CHAR(4),@ANIO)+'''+SUBSTRING(DCOMPRO,1,2)+''00'''+'+''&''+Rtrim(dsubdia)+ Rtrim(dcompro) + Rtrim(dsecue)+''&''+''M''+Rtrim(dsubdia)+Rtrim(dcompro)'+  CHAR(13)+   
  
   
      
   '    WHEN  DSUBDIA IN (''11'',''12'',''13'',''18'') AND DCUENTA IN (''421201'',''421202'',''431201'',''431202'') AND ( (dtipdoc=''NA'' and DDH=''D'') or (dtipdoc<>''NA'' and DDH=''H'')) '+  CHAR(13)+                                        
   '             AND ISNULL(PE.TIPODOC_IDENT,'''') <>''OTR'' THEN ''080100''+''&''+'''+CONVERT(CHAR(4),@ANIO)+'''+SUBSTRING(DCOMPRO,1,2)+''00'''+'+''&''+Rtrim(dsubdia)+ Rtrim(dcompro) + Rtrim(dsecue)+''&''+''M''+Rtrim(dsubdia)+Rtrim(dcompro)'+  CHAR(13)+ 
  
   
      
   '    WHEN DSUBDIA in (''05'',''06'') AND A.DDH=CASE WHEN DTIPDOC=''NA'' THEN ''H'' ELSE ''D'' END  AND SUBSTRING(DCUENTA,1,3) IN (''121'',''131'',''165'') '+ CHAR(13)+                                         
   '       THEN ''140100''+''&''+'''+CONVERT(CHAR(4),@ANIO)+'''+SUBSTRING(DCOMPRO,1,2)+''00'''+'+''&''+Rtrim(dsubdia)+ Rtrim(dcompro) + Rtrim(dsecue)+''&''+''M''+Rtrim(dsubdia)+Rtrim(dcompro)'+  CHAR(13)+                                        
   ' ELSE '''''+   CHAR(13)+                                       
   ' END  ESTRUCTURA, '+  CHAR(13)+      
   ' UPPER(B.CUSER) USUARIO, '+  CHAR(13)+  
   	'  P.CT_CENTFIN entidadFinanciera, '+  CHAR(13)+   
	'  p.cuentaEmpresa, '+  CHAR(13)+   
	'  p.medioPago, '+  CHAR(13)+   
	'  p.beneficiario, '+  CHAR(13)+   
	'  p.nroTransfer'+  CHAR(13)+ 
   ' FROM  '+@DBCONCARTRIB+'..CT00'+@XEMPCON+'COMD'+@XYY+' A WITH (NOLOCK) '+ CHAR(13)+                                       
     ' INNER JOIN '+@DBCONCARTRIB+'..CT00'+@XEMPCON+'COMC'+@XYY+' B WITH (NOLOCK) ON A.DSUBDIA=B.CSUBDIA AND A.DCOMPRO=B.CCOMPRO '+   CHAR(13)+      
   ' INNER JOIN GENERALES G WITH (NOLOCK) ON G.CLAVE=''006'' AND G.CODIGO=A.DCODMON '+  CHAR(13)+                                     
   ' LEFT  JOIN GENERALES D WITH (NOLOCK) ON D.CLAVE=''011'' AND D.CODIGO=CASE WHEN A.DTIPDOC=''BV'' AND (A.DCUENTA=''631121'' OR A.DCTAORI=''631121'') THEN ''BVE'' ELSE A.DTIPDOC END '+  CHAR(13)+                                 
   ' LEFT JOIN PUB_PERSONAS PE WITH (NOLOCK) ON PE.IDPERSONA=DCODANE '+   CHAR(13)+                                       
	' LEFT JOIN (SELECT EMPRESA,SUBDIA_CONTAB,COMPR_CONTAB,YEAR(FCH_PROGPAGO) PERIODO,e.CT_CENTFIN, anx_bco cuentaEmpresa,'+ CHAR(13)+
    ' CASE  TIPO_PAGO WHEN ''TR'' THEN ''001'' WHEN ''CH'' THEN ''007'' ELSE ''999'' END MEDIOPAGO, '+   CHAR(13)+
	'       IIF( ISNULL(BENEF_ABREV,'''')='''',P.PROV_ABREV,P.BENEF_ABREV) BENEFICIARIO, '+   CHAR(13)+
	'		CASE  TIPO_PAGO WHEN ''CH'' THEN p.NRO_CHEQUE ELSE replace(P.NRO_TRANSF,''/'','''') END NROTRANSFER '+   CHAR(13)+
    '       FROM OPAGO P (NOLOCK) '+  CHAR(13)+
	'		LEFT JOIN RSCONCAR.DBO.CP0032CUBA E ON E.CT_CNUMCTA=P.ANX_BCO '+ CHAR(13)+
	'		WHERE CTA_EGRESO LIKE ''104%'' AND ESTADO=''S'' AND ESTADO_CTB=''C''' +   CHAR(13)+
    '       ) P ON P.EMPRESA='''+@AS_EMPRESA+''' AND P.SUBDIA_CONTAB=A.DSUBDIA AND P.COMPR_CONTAB=A.DCOMPRO AND P.PERIODO='+@ANIO +char(13)+
    ' WHERE A.DSUBDIA IN (''99'') AND SUBSTRING(DCOMPRO,1,2) BETWEEN '''+@MES+''' AND '''+@MES2+'''  AND '''+@MES+'''=''12'''  +CHAR(13)+          
    ' UNION ALL ' +CHAR(13)     
    END     
  ELSE    
   SET @ls_select1=@ls_select1 +' WHERE  SUBSTRING(DCOMPRO,1,2) BETWEEN '''+@MES+''' AND '''+@MES2+''''+CHAR(13) ---- AND DMNIMPOR >0.00' COMENTADO acv           
           
  --  PRINT @ls_select1                          
  --" ORDER BY DSUBDIA,DCOMPRO,DSECUE"                                                              
   END                                                      
                                      
 ELSE                                                          
  BEGIN                
                                                             
  SET @ls_select1=' '                                                          
        DECLARE CUR_EMPRE CURSOR FOR                                           
        SELECT Case when  @AS_EMPRESA='0001' then CASE WHEN @XYY<='13' THEN '04' ELSE Case when @XYY<='16' then '14' else emp_concar End End                          
        Else   emp_concar End                          
        ,EMPRESA,ABREVIADO FROM EMPRESAS WITH (NOLOCK) WHERE IND_EMPRESA_GRUPO in ('1','2') --AND EMPRESA<'0010'                                                          
        OPEN CUR_EMPRE                                                    
  FETCH  NEXT FROM CUR_EMPRE INTO @XEMPCON,@AS_EMPRESA,@ABREVIADO                                                          
                                                                                        
  WHILE @@FETCH_STATUS=0                                                                                          
   BEGIN                                                        
                                                             
  --SELECT   @XEMPCON=CASE WHEN @XYY<='13' THEN '04' ELSE '14' END  WHERE @AS_EMPRESA='0001'                                  
                          
                                                             
      IF LEN(RTRIM(LTRIM(@ls_select1))) >0                                                           
         SET @ls_select1=@ls_select1 + ' UNION ALL '                                                
                                                 
       IF LEN(RTRIM(LTRIM(@LS_SELECT1)))>=5998 and LEN(rtrim(@ls_select2))=0                                            
        BEGIN                                          
          SET @LS_SELECT2=@LS_SELECT1                        
          SET @LS_SELECT1=' '                                          
        END                                             
                                                           
         SELECT @ls_select1=@ls_select1 + ' SELECT '''+@ABREVIADO+''', TPLAN=''01'', DSUBDIA, '+ CHAR(13)+                                                              
       'DCOMPRO,'+  CHAR(13)+                                                             
       'DSECUE,'+    CHAR(13)+                                                           
       'MES=SUBSTRING(DCOMPRO,1,2), '+  CHAR(13)+                                                             
       'DFECCOM,'+     CHAR(13)+                                                        
       'MCUENTA=SUBSTRING(DCUENTA,1,2), '+ CHAR(13)+                                                               
       'DCUENTA,'+    CHAR(13)+                                                           
       'CUENTA=(SELECT TOP 1 PDESCRI FROM RSCONCAR..CT00'+@XPLAN+'PLEM WITH (NOLOCK) WHERE PCUENTA=DCUENTA ) ,'+   CHAR(13)+                                                         
       'CASE WHEN ISNULL(DCODANE,'''')='''' THEN ''NA'' ELSE REPLACE(replace(replace(REPLACE(DCODANE,'' '',''''),''.'',''''),''/'',''''),''-'','''') END  DCODANE , '+ CHAR(13)+                                                              
       'ANEXO=(SELECT TOP 1 ADESANE FROM RSCONCAR..CT00'+@XPLAN+'ANEX WITH (NOLOCK) WHERE ACODANE=DCODANE ) ,'+ CHAR(13)+                                              
       'DCENCOS,'+ CHAR(13)+                                                              
       'DCENCOST=(SELECT TDESCRI FROM  RSCONCAR..CT00'+@XPLAN+'TAGE WITH (NOLOCK) WHERE TCOD=''05'' AND TCLAVE=DCENCOS ),'+CHAR(13)+                                                               
       'DCODMON,'+  CHAR(13)+                                                  
       'DDH,'+    CHAR(13)+                                                           
       'SOLES  =DMNIMPOR, '+  CHAR(13)+                                                             
       'DOLARES=DUSIMPOR, '+  CHAR(13)+                                                             
       'DIMPORT,'+   CHAR(13)+                               
       'CASE WHEN ISNUMERIC(CASE WHEN ISNULL(CASE WHEN CHARINDEX(''-'',DNUMDOC)>0 THEN REPLACE(SUBSTRING(DNUMDOC, CHARINDEX(''-'',DNUMDOC)+1,15),''/'','''') '+CHAR(13)+                               
       'ELSE REPLACE(DNUMDOC,''/'','''') END,'''')='''' THEN ''NA'' ELSE CASE WHEN CHARINDEX(''-'',DNUMDOC)>0 THEN REPLACE(SUBSTRING(DNUMDOC, CHARINDEX(''-'',DNUMDOC)+1,15),''/'','''') '+ CHAR(13)+                               
       ' ELSE replace(DNUMDOC,''/'','''') END END)=1 THEN ISNULL(D.COD_SUNAT,''00'') ELSE ''00'' END DTIPDOC,'+ CHAR(13)+                                                              
       'upper(REPLACE(DNUMDOC,''/'','''')) DNUMDOC,'+  CHAR(13)+                                                             
       'CASE WHEN isnull(DFECDOC,'''')='''' THEN DFECCOM ELSE CASE WHEN CONVERT(VARCHAR(6),DFECDOC2,112)>'''+@PER+''' THEN DFECCOM ELSE DFECDOC END END  DFECDOC,'+ CHAR(13)+                                                              
       'DFECVEN,'+ CHAR(13)+                                                              
       'DAREA,'+  CHAR(13)+                                                             
       'GLOSA=replace(CASE WHEN LEN(RTRIM(DXGLOSA))>0 THEN RTRIM(LTRIM(DXGLOSA))+REPLICATE('' '',30 - LEN(RTRIM(LTRIM(DXGLOSA)))) ELSE RTRIM(LTRIM(CGLOSA))+REPLICATE('' '',40 - LEN(RTRIM(LTRIM(CGLOSA)))) END,''/'','''') ,'+ CHAR(13)+                     
  
  
       'DUSIMPOR,'+  CHAR(13)+                                                             
       'DMNIMPOR,'+ CHAR(13)+                                                              
       'DCODARC,'+   CHAR(13)+                                        
       'DFECCOM2,'+  CHAR(13)+                                                             
       'CASE WHEN isnull(DFECDOC2,'''')='''' THEN DFECCOM2 ELSE CASE WHEN CONVERT(VARCHAR(6),DFECDOC2,112)>'''+@PER+''' THEN DFECCOM2 ELSE DFECDOC2 END  END DFECDOC2 ,'+  CHAR(13)+                                                             
       'DFECVEN2,'+ CHAR(13)+                                                              
       'DVANEXO,'+ CHAR(13)+                                                              
       'DCTAORI,'+  CHAR(13)+                                           
       'DTIPDOR,'+  CHAR(13)+                                                             
       'DNUMDOR,'+   CHAR(13)+                                                            
    'CASE WHEN isnull(DFECDOC2,'''')='''' THEN DFECCOM2 ELSE CASE WHEN CONVERT(VARCHAR(6),DFECDOC2,112)>'''+@PER+''' THEN DFECCOM2 ELSE DFECDOC2 END  END DFECDOC2 ,'+ CHAR(13)+                                                              
    'FECHA_OPERA=CASE WHEN DSUBDIA IN (''11'',''12'',''13'',''15'') THEN  '+  CHAR(13)+                                               
    'CASE WHEN DATEDIFF(MM,CONVERT(DATETIME,DFECDOC2,103),CONVERT(DATETIME,'''+@LS_FECHA_INI+''',103))>0 THEN DFECDOC2 ELSE DFECCOM2 END ELSE DFECCOM2  END ,'+CHAR(13)+                                                       
    ' ESTADO=''1'','+   CHAR(13)+                                    
    'UNIDADOPERA='''',' +   CHAR(13)+                                    
    'G.COD_SUNAT MONEDA_SUNAT ,'+  CHAR(13)+                                     
    'TIPODOCID=case when ISNUMERIC(A.DCODANE)=0  THEN ''0'' ELSE CASE WHEN CONVERT(NUMERIC(20),A.DCODANE)=0 THEN ''0'' '+ CHAR(13)+                              
    ' ELSE CASE  LEN(RTRIM(A.DCODANE)) WHEN 8 THEN ''1'' WHEN 11 THEN CASE WHEN DBO.FN_VALIDARUC(RTRIM(A.DCODANE))=1 THEN ''6'' ELSE ''0'' END ELSE ''0'' END END END , '+CHAR(13)+                                       
    'SERIE=LEFT(RTRIM(CASE WHEN CHARINDEX(''-'',DNUMDOC)>0 THEN CASE WHEN isnumeric(RTRIM(SUBSTRING(DNUMDOC,1, CHARINDEX(''-'',DNUMDOC)-1)))=1 THEN RIGHT(''0000''+RTRIM(SUBSTRING(DNUMDOC,1, CHARINDEX(''-'',DNUMDOC)-1)),4) '+ CHAR(13)+                     
    ' ELSE CASE WHEN SUBSTRING(RTRIM(SUBSTRING(DNUMDOC,1, CHARINDEX(''-'',DNUMDOC)-1)),1,2) IN (''LS'',''BL'')  THEN ''0001''   ELSE RTRIM(SUBSTRING(DNUMDOC,1, CHARINDEX(''-'',DNUMDOC)-1)) END  END ELSE ''0001'' END)+''0000'',4) ,'+ CHAR(13)+             
    'NUMERO=REPLACE(CASE WHEN ISNULL(CASE WHEN CHARINDEX(''-'',DNUMDOC)>0 THEN REPLACE(SUBSTRING(DNUMDOC, CHARINDEX(''-'',DNUMDOC)+1,15),''/'','''') ELSE REPLACE(DNUMDOC,''/'','''') END,'''')='''' THEN ''NA'''+ CHAR(13)+                  
    ' ELSE CASE WHEN CHARINDEX(''-'',DNUMDOC)>0 THEN REPLACE(SUBSTRING (DNUMDOC, CHARINDEX(''-'',DNUMDOC)+1,15),''/'','''') ELSE replace(DNUMDOC,''/'','''') END END,''°'','''') , '+ + CHAR(13)+                                                   
 ' GLOSAADIC='''','+  + CHAR(13)+                            
 '  CASE WHEN DSUBDIA IN (''11'',''12'',''13'',''18'') AND DCUENTA IN (''421201'',''421202'',''431201'',''431202'') AND ( (dtipdoc=''NA'' and DDH=''D'') or (dtipdoc<>''NA'' and DDH=''H'')) '+ CHAR(13)+                                     
 '             AND ISNULL(PE.TIPODOC_IDENT,'''')=''OTR'' THEN ''080200''+''&''+'''+@AS_PERIODO+'''+''&''+Rtrim(dsubdia)+ Rtrim(dcompro) + Rtrim(dsecue)+''&''+''M''+Rtrim(dsubdia)+Rtrim(dcompro)'+  CHAR(13)+                                     
 '    WHEN  DSUBDIA IN (''11'',''12'',''13'',''18'') AND DCUENTA IN (''421201'',''421202'',''431201'',''431202'') AND ( (dtipdoc=''NA'' and DDH=''D'') or (dtipdoc<>''NA'' and DDH=''H'')) '+  CHAR(13)+                                     
 '             AND ISNULL(PE.TIPODOC_IDENT,'''') <>''OTR'' THEN ''080100''+''&''+'''+@AS_PERIODO+'''+''&''+Rtrim(dsubdia)+ Rtrim(dcompro) + Rtrim(dsecue)+''&''+''M''+Rtrim(dsubdia)+Rtrim(dcompro)'+ CHAR(13)+                                     
 '    WHEN DSUBDIA in (''05'',''06'') AND A.DDH=CASE WHEN DTIPDOC=''NA'' THEN ''H'' ELSE ''D'' END  AND SUBSTRING(DCUENTA,1,3) IN (''121'',''131'',''165'') '+  CHAR(13)+                                     
 '       THEN ''140100''+''&''+'''+@AS_PERIODO+'''+''&''+Rtrim(dsubdia)+ Rtrim(dcompro) + Rtrim(dsecue)+''&''+''M''+Rtrim(dsubdia)+Rtrim(dcompro)'+  CHAR(13)+                                     
 ' ELSE '''''+   CHAR(13)+                                    
 ' END  ESTRUCTURA, '+   CHAR(13)+       
 ' UPPER(B.CUSER) USUARIO '+  CHAR(13)+   
 ' FROM  '+@DBCONCAR+'..CT00'+@XEMPCON+'COMD'+@XYY+' A WITH (NOLOCK) '+   CHAR(13)+                                      
 ' INNER JOIN '+@DBCONCAR+'..CT00'+@XEMPCON+'COMC'+@XYY+' B WITH (NOLOCK) ON A.DSUBDIA=B.CSUBDIA AND A.DCOMPRO=B.CCOMPRO '+   CHAR(13)+                                        
 ' INNER JOIN GENERALES G WITH (NOLOCK) ON G.CLAVE=''006'' AND G.CODIGO=DCODMON '+  CHAR(13)+                                 
 ' LEFT  JOIN GENERALES D WITH (NOLOCK) ON D.CLAVE=''011'' AND D.CODIGO=CASE WHEN A.DTIPDOC=''BV'' AND (A.DCUENTA=''631121'' OR A.DCTAORI=''631121'') THEN ''BVE'' ELSE A.DTIPDOC END '+   CHAR(13)+                                     
 ' LEFT JOIN PUB_PERSONAS PE WITH (NOLOCK) ON PE.IDPERSONA=DCODANE '+   CHAR(13)+                                    
 ' WHERE SUBSTRING(DCOMPRO,1,2)='''+@MES+''''----- AND DMNIMPOR >0.00' comentado acv                                           
                                                           
                                                          
    FETCH  NEXT FROM CUR_EMPRE INTO @XEMPCON,@AS_EMPRESA,@ABREVIADO                                                          
                    
   END                              
   CLOSE CUR_EMPRE                                                       
   DEALLOCATE CUR_EMPRE                                                          
                                                             
   END                                                             
          
    SET  @ls_select1=@ls_select1 + ' ORDER BY 1,DSUBDIA,DCOMPRO,DSECUE,DCUENTA,DFECCOM2'                                                      
                              
   -- PRINT       @ls_select1                              
   -- PRINT        @ls_select2                                             
                                                                  
    EXECUTE(@ls_select2+@ls_select1)                                                              
    --SELECT  @ls_select1                                     
   -- print @ls_select2                                
   -- print @ls_select1 