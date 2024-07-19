--ALTER PROCEDURE [dbo].[SP_REGISTRO_COMPRAS_REP_PAUL] --'0084','01','2024'                                                                        
--@PARAM_EMPRESA CHAR(4),@PARAM_MES CHAR(2),@PARAM_ANIO NUMERIC(4)                                                                                                                                                                           
                                                                                                                                                                 
--AS                                                                                                                                                                       
----DROP TABLE #TABLA1 
--DROP TABLE #tempo_parte_1
-- VARIABLES LOCALES
--DECLARE @AS_EMPRESA CHAR(4)= @PARAM_EMPRESA;
--DECLARE @AS_MES CHAR(2)= @PARAM_MES;
--DECLARE @AS_ANIO NUMERIC(4)= @PARAM_ANIO;

DECLARE @AS_EMPRESA CHAR(4)= '0003';
DECLARE @AS_MES CHAR(2)= '12';
DECLARE @AS_ANIO NUMERIC(4)= '2023';
  
    
      
        
                                                                                                                                                             
DECLARE @XEMP CHAR(2), @XPER CHAR(2),@ITEM NUMERIC(18) ,@AS_SDCANC VARCHAR(2),@AS_CMCANC CHAR(6)  ,@AS_MONEDA CHAR(2) ,@AS_PERIODO CHAR(8)                      
                             
DECLARE @AS_SERIE VARCHAR(15),@AS_SERIE_INI VARCHAR(15)='', @AS_NUMERO VARCHAR(20),@AS_RUC VARCHAR(15),@NUM_CERTI VARCHAR(10),@LS_FECHA_INI VARCHAR(10),@AS_SECUE CHAR(4)                      
                      
DECLARE @AS_TDOC_ORIG CHAR(5)='',@AS_NDOC_ORIG CHAR(15)='',@ADT_DOC_ORIG DATETIME ,@AS_FECHA_DOC_ORIG VARCHAR(10),@AS_TIPO_DOC CHAR(2),@FLG_RETENCION CHAR(1)                      
DECLARE @AS_COD_DTR CHAR(5),@AS_TASADETRA NUMERIC(12,2),@PERIODOCONT CHAR(4) ,@LS_FECHA_FINAL VARCHAR(10),@XPERANT CHAR(2),@XEMPDETRA CHAR(2),@XPLAN CHAR(2)                      
       ,@PORCIGV NUMERIC(12,2),@PORCIGVCH NUMERIC(12,2),@IGV NUMERIC(12,2), @FECHAIGV CHAR(6),@fecha_doc varchar(6),@PERIODO VARCHAR(6)                      
                      
/***CAMPOS AGREGADOS******/ --SE GUARDA EN UNA TABLA LA SUBCONSULTA                                                                            
                                                                         
CREATE TABLE #TABLA1 (FCH_PROVISION VARCHAR(10), IMP_TOTAL_MN NUMERIC(15,2), PROVEEDOR VARCHAR(11) index idx_proveedor , COD_SUNAT VARCHAR(2),                       
FACTURA VARCHAR(20), DETALLE VARCHAR(250), SERIE VARCHAR(10), NUMERO VARCHAR(15))                       
                      
INSERT INTO #TABLA1                       
   SELECT CONVERT(VARCHAR(10),TC.FECH_PROVI, 103) AS FCH_PROVISION, TC.IMP_TOTAL_MN, TC.PROVEEDOR, G.cod_sunat, TC.FACTURA, TC.DETALLE,                       
    SUBSTRING(TC.FACTURA,1,(CHARINDEX('-',TC.FACTURA)-1)) SERIE, SUBSTRING(TC.FACTURA,(CHARINDEX('-',TC.FACTURA)+1),10) NUMERO                       
   FROM enproyecdb.dbo.TB_PROVI_CAB TC with (nolock)                       
   INNER JOIN enproyecdb.dbo.GENERALES G with (nolock) ON (G.codigo = TC.TIPO_COMPR) AND G.clave='011'                       
   WHERE CHARINDEX('-',TC.FACTURA)>0 AND TC.TIPO='E' AND ISNULL(TC.ESTADO,'') NOT IN ('X','A') AND TC.EMPRESA=@AS_EMPRESA                       
                                        
   --select COUNT(1) from #TABLA1                                                                            
                                                                                     
/*PORC_IGV*/                       
SET @FECHAIGV=CONVERT(CHAR(4),@AS_ANIO)+@AS_MES                       
SELECT @IGV=PORC_IGV FROM enproyecdb.dbo.TB_IGV_HIST (NOLOCK) WHERE @FECHAIGV                       
        BETWEEN CONVERT(VARCHAR(6),FECHA_INI,112) AND CONVERT(VARCHAR(6),FECHA_FIN,112) AND enproyecdb.dbo.TB_IGV_HIST.PORC_IGV >10                       
                       
DECLARE @DETRATER VARCHAR(12), @DETRAVINMN VARCHAR(12),@DETRAVINUS VARCHAR(12)                       
SELECT @DETRATER  =rtrim(obs) FROM enproyecdb.dbo.TB_TABLAS_GEN WITH (NOLOCK) WHERE CLAVE='139' AND CODIGO ='01'                       
SELECT @DETRAVINMN=rtrim(obs) FROM enproyecdb.dbo.TB_TABLAS_GEN WITH (NOLOCK) WHERE CLAVE='139' AND CODIGO ='02'                 
SELECT @DETRAVINUS=rtrim(obs) FROM enproyecdb.dbo.TB_TABLAS_GEN WITH (NOLOCK) WHERE CLAVE='139' AND CODIGO ='03'                       
                      
--SELECT @XEMP='06',@XPER='13',@AS_EMPRESA='0003', @AS_MES='06',@AS_ANIO=2013                       
                      
SELECT @XEMP=RTRIM(EMP_CONCAR), @XPER=SUBSTRING(CONVERT(CHAR(4),@AS_ANIO),3,2),@AS_PERIODO=RTRIM(CONVERT(CHAR(4),@AS_ANIO)+@AS_MES+'00' ),                       
       @LS_FECHA_FINAL=CONVERT(VARCHAR(10),DATEADD(DD,-1,CONVERT(DATETIME,'01/'+RTRIM(CASE WHEN @AS_MES='12' THEN '01'                       
  ELSE CONVERT(CHAR(2),CONVERT(NUMERIC(12),@AS_MES)+1) END )+'/'+CONVERT(CHAR(4),                       
       CASE WHEN @AS_MES='12' THEN CONVERT(CHAR(4),CONVERT(NUMERIC(4),@AS_ANIO)+1) ELSE @AS_ANIO END ),103)  ),112 ) ,                       
    @LS_FECHA_INI='01/'+RTRIM(@AS_MES)+'/'+CONVERT(CHAR(4),@AS_ANIO) , @FLG_RETENCION=RETENCION ,                       
  @PERIODOCONT=RTRIM(SUBSTRING(CONVERT(CHAR(4),@AS_ANIO),3,2)+@AS_MES) ,                       
  @PERIODO=CONVERT(VARCHAR(4),@AS_ANIO)+@AS_MES,                       
  @XPLAN =EMP_PLAN                       
FROM enproyecdb.dbo.EMPRESAS WITH(NOLOCK) WHERE EMPRESA=@AS_EMPRESA                       
                       
DECLARE @MYTABLE TABLE (IMPORTE NUMERIC(12,2), SECUE CHAR(4), TIPODOC CHAR(2), NRODOC VARCHAR(20), FECHA DATETIME,FECHA_TXT VARCHAR(10))                       
                       
--SELECT   @XEMP=CASE WHEN @XPER<='13' THEN '04' ELSE '14' END  WHERE @AS_EMPRESA='0001'                                                      
SET @XPERANT='16'--RTRIM(CONVERT(CHAR(2),CONVERT(NUMERIC(2),@XPER) - 1) )                                                                                                                                                
                                                                                        
SELECT @XEMP = H.EMP_CONCAR                       
FROM   enproyecdb.dbo.EMPRESAS E WITH (NOLOCK)                       
INNER JOIN enproyecdb.dbo.TB_EMPRESA_HIST H WITH (NOLOCK) ON H.EMPRESA=E.EMPRESA AND @XPER BETWEEN RIGHT(CONVERT(VARCHAR(4),FECHA_INI,112),2) AND RIGHT(CONVERT(VARCHAR(4),FECHA_FIN,112),2)                       
WHERE IND_EMPRESA_GRUPO=1 AND E.EMPRESA=@AS_EMPRESA                       
                       
SELECT @XEMPDETRA = H.EMP_CONCAR                       
FROM   enproyecdb.dbo.EMPRESAS E WITH (NOLOCK)                       
INNER JOIN enproyecdb.dbo.TB_EMPRESA_HIST H WITH (NOLOCK) ON H.EMPRESA=E.EMPRESA AND @XPERANT BETWEEN RIGHT(CONVERT(VARCHAR(4),FECHA_INI,112),2) AND RIGHT(CONVERT(VARCHAR(4),FECHA_FIN,112),2)                       
WHERE IND_EMPRESA_GRUPO=1 AND E.EMPRESA=@AS_EMPRESA                       
                       
DECLARE @AS_SUBDIA CHAR(2),@AS_COMPRO CHAR(6),@mySql varchar(8000),@AS_TRANSFER VARCHAR(20),@ADT_DETRA DATETIME                       
                      
DELETE TMP_REGCOMPRAS                       
                       
/*ACTUALIZA GLOSA DE ER*/                                                                                                                                
SET @MYSQL=' UPDATE A SET A.CGLOSA=B.DXGLOSA '+CHAR(13)+                                                                                                                                
            ' FROM RSCONCAR..CT00'+@XEMP+'COMC'+@XPER+' A '+CHAR(13)+                                                                                                                                
   ' INNER JOIN RSCONCAR..CT00'+@XEMP+'COMD'+@XPER+' B ON A.CSUBDIA=B.DSUBDIA AND A.CCOMPRO=B.DCOMPRO ' +CHAR(13)+                                                                   
   ' WHERE CSUBDIA=''12'' AND A.CGLOSA =''IGV - CUENTA PROPIA'' AND ( LEFT(DCUENTA,1)=''6''  OR (LEFT(DCUENTA,2)=''42'' AND DDH=''D'')  ) '+char(13)+                                    
' and left(dcompro,2)='''+@AS_MES+''''                                                                                    
 --print @MYSQL                        
 EXECUTE (@MySql)                                                              
 /**/                                      
--SELECT * FROM TB_PROVI_CAB WHERE NRO_PROVI='0060150'                                                           
                                              
 SET @MYSQL=' INSERT TMP_REGCOMPRAS (PERIODO,SUBCOMPR,DSUBDIA,DCOMPRO,FECH_COMP,FECHA_PAGO,DTIPDOC,SERIE,DUA,NUMERO,REF1,TIPPER,RUC,PROV_ABRE,BASE,IGV,'+char(13)+                                                                                            
          
  ' REF2,REF3,REF4,REF5,EXONERADO,ISC,IRET,OTR_TRIB,TOTAL,SUJ_NOT,CONST_DETRA,FECHA_DETRA,DETRA_ORIG,'+char(13)+                                                                                                                    
  ' FE_DETRA_ORIG,MONEDA,DSECUE,MONEDA24,TIPOBIEN,PROYECTO,ERROR_1,ERROR_2,ERROR_3,ERROR_4,MEDIOPAGO, ESTADO,SALDO,PERIODOEMI,SERIE_INI,FLG_ADELA,MONTO_ORIG,'+char(13)+ 
  ' TCAMBIO, RETENCION,usuarioProvi,DXGLOSA,COD_DETRA,DES_DETRA )'+char(13)+
  ' SELECT PERIODO='''+@AS_PERIODO+''',SUBCOMPR=RTRIM(DSUBDIA)+RTRIM(DCOMPRO),DSUBDIA,DCOMPRO,'+char(13)+
  ' DFECDOC2=CASE WHEN DFECDOC2 IS NULL THEN ''01/01/0001'' ELSE RIGHT(''00''+RTRIM(CONVERT(CHAR(2),DAY(DFECDOC2))),2)+''/'''+char(13)+ 
  ' +RIGHT(''00''+RTRIM(CONVERT(CHAR(2),MONTH(DFECDOC2))),2)+''/''+RTRIM(CONVERT(CHAR(4),YEAR(DFECDOC2)))  END ,'+char(13)+
  ' DFECVEN2=CASE WHEN DFECVEN2 IS NULL or DTIPDOC<>''RC'' THEN ''01/01/0001'' ELSE RIGHT(''00''+RTRIM(CONVERT(CHAR(2),DAY(DFECVEN2))),2)+''/'' ' +char(13)+ 
  ' +RIGHT(''00''+RTRIM(CONVERT(CHAR(2),MONTH(DFECVEN2))),2)+''/''+RTRIM(CONVERT(CHAR(4),YEAR(DFECVEN2)))  END ,'+char(13)+ 
  ' TIPODOC=ISNULL(T.COD_SUNAT,DTIPDOC)/*CASE DTIPDOC WHEN ''FT'' THEN ''01'' WHEN ''ND'' THEN ''08'' WHEN ''RC'' THEN ''14'' WHEN ''TK'' THEN ' +char(13)+ 
  ' ''12'' WHEN ''NA'' THEN ''07'' ELSE DTIPDOC END*/,'+char(13)+ 
  ' SERIE=CASE WHEN CHARINDEX(''-'',DNUMDOC)>0 THEN CASE WHEN isnumeric(RTRIM(SUBSTRING(DNUMDOC,1, CHARINDEX(''-'',DNUMDOC)-1)))=1 THEN ' + CHAR(13)+
  ' CASE WHEN DTIPDOC in (''BA'',''50'') THEN SUBSTRING(DNUMDOC,1, CHARINDEX(''-'',DNUMDOC)-1)  ELSE RIGHT(''0000''+RTRIM(SUBSTRING(DNUMDOC,1, CHARINDEX(''-'',DNUMDOC)-1)),4) END '+char(13)+ 
  ' ELSE RTRIM(SUBSTRING(DNUMDOC,1, CHARINDEX(''-'',DNUMDOC)-1)) END ELSE '''' END ,'+ char(13)+
  ' DUA=Case when dtipdoc in (''R9'',''50'') then '''+/*substring(@AS_PERIODO,1,4)*/+'''  else '''' end,NUMERO=CASE WHEN CHARINDEX(''-'',DNUMDOC)>0 THEN '+ char(13)+
  ' SUBSTRING(DNUMDOC, CHARINDEX(''-'',DNUMDOC)+1,15) ELSE DNUMDOC END ,'+ char(13)+ 
  ' REF1='''',TIPPER=isnull(RTRIM(TI.COD_SUNAT),''6'')/*CASE WHEN LEN(RTRIM(DCODANE))=11 THEN ''6'' ELSE ''1'' END*/, '+ char(13)+ 
  ' RUC=DCODANE, PROV_ABRE=(SELECT TOP 1 ADESANE FROM RSCONCAR..CT00'+@XPLAN+'ANEX WHERE ACODANE=DCODANE),'+char(13)+
  ' BASE     =0.00,'+char(13)+
  ' IGV   =0.00,'+char(13)+
  ' REF2=0.00,REF3=0.00,REF4=0.00,REF5=0.00,'+ char(13)+
  ' EXONEDADO=0.00,ISC=0.00,IRET=0.00,OTR_TRIB=0.00,'+ char(13)+
  ' TOTAL  =DMNIMPOR,SUJ_NOT=''-'','+ char(13)+
  ' CONST_DETRA=NULL,'+char(13)+
  ' FECHA_DETRA=NULL,'+char(13)+
  ' DETRA_ORIG =NULL,'+char(13)+
  ' FE_DETRA_ORIG=NULL,'+char(13)+
  ' FE_DETRA_ORIG=DCODMON,'+char(13)+
  ' DSECUE ,'+char(13)+
  ' G.COD_SUNAT MONEDA24,'+ char(13)+
  ' CASE WHEN (DSUBDIA=''12''  and isnull(Y.CUENTAGAS,'''') not in (''634303'',''634304'')) OR (DSUBDIA=''16'' AND ISNULL(P.TIPOBIENSERV,'''')='''' ) OR '+ CHAR(13)+ 
  ' DCUENTA_ORIG IN (''609111'',''631121'',''631122'',''631401'',''659902'',''631111'',''631301'',''635201'',''659904'',''656103x'',''637301'') THEN ''5'' WHEN D.COPERACION ' + char(13)+ 
  ' IN (''045'',''010'') or (DCUENTA_ORIG =''656103'') THEN ''1''  WHEN  Y.CUENTAGAS in (''634304'')  '+char(13)+
  ' and ( (DSUBDIA=''12'') OR (DSUBDIA=''11'' AND ISNULL(P.TIPOBIENSERV,'''')='''') ) THEN ''4''  ELSE ISNULL(P.TIPOBIENSERV,'' '') END TIPOBIEN, '' '' CONTRATO, '+char(13)+                        
  ' Case when dtipdoc <>''RC'' then  Case When right(convert(varchar(6),dfecdoc2,112),4) <>'''+@PERIODOCONT+''' then ''1'' else '''' End Else Case When Substring(DFECVEN,1,4) <>'''+@PERIODOCONT+''' then ''1'' else '''' End  End  ERROR_1,'+char(13)+
  ' '''' Error_2,'+char(13)+                                   
  ' '''' Error_3,'+char(13)+                                    
  ' '''' Error_4,'+char(13)+                                                                                          
  ' CASE WHEN (SELECT COUNT(1) FROM enproyecdb.dbo.GENERALES TP WITH (NOLOCK) WHERE CLAVE=''004'' AND CODIGO=O.TIPO_PAGO )>0 THEN ''1'' ELSE '''' END MEDIO_PAGO, '+char(13)+
  ' ESTADO =CASE WHEN DTIPDOC=''BV'' THEN ''0'' ELSE  Case when dtipdoc in (/*''RC'',*/''R9''/*,''50''*/) THEN CASE WHEN DATEDIFF(MM,CONVERT(VARCHAR(10),DFECVEN2,112) '+char(13)+
  ','''+@LS_FECHA_FINAL+''')>12 THEN ''7''  ELSE  CASE WHEN DATEDIFF(MM,CONVERT(VARCHAR(10),DFECVEN2,112),'''+@LS_FECHA_FINAL+''')'+char(13)+
  ' BETWEEN 1 AND 12 THEN ''6'' ELSE ''1'' END  END   ELSE CASE WHEN right(convert(varchar(6),dfecdoc2,112),4) < substring('''+@as_periodo+''',3,4) '+char(13)+
  ' THEN CASE WHEN DATEDIFF(MM,CONVERT(VARCHAR(10),DFECDOC2,112),'''+@LS_FECHA_FINAL+''')<=12 THEN ''6'' ELSE ''7'' END ELSE ''1'' END END  END, '+char(13)+
  ' SALDO  =(Select sum(case when right(rtrim(s.dcuenta),2)=''02'' then dusimpor else dmnimpor end * case when ddh=''D'' then case when (dtipdoc=''NA'' or dtipdoc=''87'' ) '+char(13)+
  ' then 1 else -1 end else case when (dtipdoc=''NA'' or dtipdoc=''87'' ) then -1 else 1 end end)'+char(13)+
  ' From rsconcar..ct00'+@XEMP+'comd'+@XPER+' S WITH (NOLOCK) Where s.dcuenta=A.DCUENTA and s.dcodane=A.DCODANE and s.dnumdoc=a.dnumdoc '+char(13)+
  ' and CONVERT(VARCHAR(10),s.dfeccom2,112) <='''+@LS_FECHA_FINAL+''' and s.dsubdia not in (''20'') )  , '+ char(13)+
  ' periodoEmi=convert(varchar(6),dfecdoc2,112), '+ char(13)+
  ' SERIE_ORIG=CASE WHEN CHARINDEX(''-'',DNUMDOC)>0 THEN CASE WHEN isnumeric(RTRIM(SUBSTRING(DNUMDOC,1, CHARINDEX(''-'',DNUMDOC)-1)))=1 THEN '+char(13)+ 
  ' RTRIM(SUBSTRING(DNUMDOC,1, CHARINDEX(''-'',DNUMDOC)-1)) '+char(13)+ 
 ' ELSE RTRIM(SUBSTRING(DNUMDOC,1, CHARINDEX(''-'',DNUMDOC)-1)) END ELSE '''' END , '+char(13)+ 
 ' ADELA=ISNULL((Select COUNT(1) FROM rsconcar..ct00'+@XEMP+'comd'+@XPER+' AD WITH (NOLOCK) Where AD.DSUBDIA=A.DSUBDIA AND AD.DCOMPRO=A.DCOMPRO AND AD.DCUENTA=''422104'' AND AD.DDH=''D'' ),0) ,'+ char(13)+
 ' A.DIMPORT MONTO_ORIG , D.CTIPCAM , CASE WHEN ISNULL(P.FLG_RETENCION,0)=1 THEN ''1'' ELSE '''' END, D.CUSER, '+char(13)+
 ' CASE WHEN OP.C_C_OPERACION IN (''045'',''010'') THEN RTRIM(OP.C_T_OPERACION)+''/''+RTRIM(D.CGLOSA) ELSE D.CGLOSA END , '+ char(13)+  
 ' P.COD_DETRA,TS.DESCRIPCION '+CHAR(13)+
 ' FROM RSCONCAR..CT00'+@XEMP+'COMD'+@XPER+' A WITH (NOLOCK) '+ char(13)+ 
 ' INNER JOIN RSCONCAR..CT00'+@XEMP+'COMC'+@XPER+' D WITH (NOLOCK) ON D.CSUBDIA=A.DSUBDIA AND D.CCOMPRO=A.DCOMPRO '+ char(13)+
 ' LEFT JOIN enproyecdb.dbo.TB_OPERACION OP (NOLOCK) ON OP.C_C_OPERACION=D.COPERACION '+ char(13)+
 ' LEFT JOIN (SELECT max(DCUENTA) CUENTAGAS, DSUBDIA DSUBDIAGAS,DCOMPRO DCOMPROGAS FROM RSCONCAR..CT00'+@XEMP+'COMD'+@XPER+' D WITH (NOLOCK) WHERE D.DCUENTA in (''634303'',''634304'')  GROUP BY D.DSUBDIA,D.DCOMPRO ) Y ON '+ char(13)+
 ' Y.DSUBDIAGAS=A.DSUBDIA AND Y.DCOMPROGAS=A.DCOMPRO '+ char(13)+
 ' LEFT JOIN PUB_PERSONAS PR WITH (NOLOCK) ON PR.IDPERSONA=A.DCODANE '+ char(13)+ 
 ' LEFT JOIN PUB_TIPODOC_IDENTIDAD TI  WITH (NOLOCK) ON TI.TIPODOC_IDENT=PR.TIPODOC_IDENT '+ char(13)+
 ' INNER JOIN enproyecdb.dbo.GENERALES G WITH (NOLOCK) ON G.CLAVE=''006'' AND G.CODIGO=DCODMON '+char(13)+
 ' INNER JOIN enproyecdb.dbo.GENERALES T WITH (NOLOCK) ON T.CLAVE=''011'' AND T.CODIGO=A.DTIPDOC '+char(13)+
 ' LEFT JOIN TB_PROVI_CAB P WITH (NOLOCK) ON P.EMPRESA='''+@AS_EMPRESA+''' AND  P.PROVEEDOR=DCODANE AND P.FACTURA=DNUMDOC AND P.TIPO_COMPR=DTIPDOC AND '+CHAR(13)+
 ' P.SUBDIA_CONTAB=A.DSUBDIA AND P.COMPR_CONTAB=A.DCOMPRO AND P.TIPO=''E'' AND ISNULL(P.ESTADO,'''')<>''X'' '+ char(13)+
 ' LEFT JOIN TASAS TS ON TS.TIPO=''28'' AND TS.CLAVE=P.COD_DETRA AND TS.EMPRESA=P.EMPRESA '+CHAR(13)+  
 ' LEFT JOIN (SELECT MAX(A.TIPO_PAGO) TIPO_PAGO,A.PROVEEDOR,B.NUM_COMPR,A.EMPRESA FROM OPAGO A  WITH (NOLOCK),OPAGO_DETALLES B  WITH (NOLOCK)'+ char(13)+
 ' WHERE A.EMPRESA=B.EMPRESA AND A.TIPO_OP=B.TIPO_OP AND A.NRO_OP=B.NRO_OP and A.ESTADO=''S'' GROUP BY A.EMPRESA, A.PROVEEDOR,B.NUM_COMPR ) O ON '+char(13)+ 
 ' O.PROVEEDOR=DCODANE AND O.NUM_COMPR=DNUMDOC AND O.EMPRESA='''+@AS_EMPRESA+''''+ char(13)+ 
 ' LEFT JOIN (SELECT MAX(DCUENTA) DCUENTA_ORIG, DSUBDIA DSUBDIA_ORIG ,DCOMPRO DCOMPRO_ORIG FROM RSCONCAR..CT00'+@XEMP+'COMD'+@XPER+' G WHERE ' +CHAR(13)+
 ' G.DCUENTA IN (''609111'',''631121'',''631122'',''631401'',''659902'',''631111'',''631301'',''635201'',''659904'',''656103'') GROUP BY DSUBDIA,DCOMPRO ) N ON '+char(13)+ 
 '   N.DSUBDIA_ORIG=A.DSUBDIA AND N.DCOMPRO_ORIG=A.DCOMPRO '+char(13)+
 ' WHERE ( ( ISNULL(PR.TIPODOC_IDENT,'''') <>''OTR'' and a.dtipdoc not in (''VR'' ,''BV'') ) or ( (ISNULL(PR.TIPODOC_IDENT,'''') =''OTR'') and (a.dtipdoc=''21'')) or (a.dtipdoc=''BV'' and pr.AFECTORUS=''S'') )  '+char(13)+
 ' AND DSUBDIA IN (''11'',''12'',''13'',''18'',''16'') AND SUBSTRING(DCOMPRO,1,2)='''+@AS_MES+'''   '+char(13)+ 
 ' AND DCUENTA IN (''42101'',''42102'',''421201'',''421202'',''421206'',''421406'',''431201'',''431202'',''421204'',''471303'',''471304'',''471305'','+char(13)+
 ' ''471306'',''455115'',''455116'',''465401'',''465402'',''479102'',''471109'',''471110'',''471108'',''471104'',''471107'') '+char(13)+
 ' AND ( ( (dtipdoc=''NA'' or dtipdoc=''87'' ) and DDH=''D'') or ( (dtipdoc<>''NA'' and dtipdoc<>''87'') and DDH=''H''))    ORDER BY DSUBDIA,DCOMPRO' 
 
    print   @MySql                                                                       
    EXECUTE (@MySql)                                                                 
  --print   @MySql                                                                                                          
                                                                             
  --select * from GENERALES G WITH (NOLOCK) where G.CLAVE='011'                                                                                                      
                                                                                                  
                                                               
 DECLARE CUR_COMP CURSOR  FOR                                                                                            
    SELECT DSUBDIA,DCOMPRO,ITEM,MONEDA,RTRIM(SERIE),RTRIM(NUMERO),RTRIM(RUC) , RTRIM(DTIPDOC),RTRIM(SERIE_INI),                                                                                          
           SUBSTRING(FECH_COMP,7,4)+SUBSTRING(FECH_COMP,4,2)                                                                       
  FROM TMP_REGCOMPRAS  WITH (NOLOCK)  -- WHERE DSUBDIA='11' AND DCOMPRO='120029'  OPEN  CUR_COMP                                                 
                      
    OPEN  CUR_COMP                                                                             
     FETCH NEXT FROM CUR_COMP INTO @AS_SUBDIA, @AS_COMPRO,@ITEM ,@AS_MONEDA,@AS_SERIE,@AS_NUMERO,@AS_RUC, @AS_TIPO_DOC,@AS_SERIE_INI,@fecha_doc                                                                                                             
     WHILE @@FETCH_STATUS = 0                                                                                                                                                                                          
     BEGIN                                                                                   
                                                                    
  If @AS_SUBDIA='11' and @AS_COMPRO='020008' and @AS_EMPRESA='0003' and @AS_MES='02' and  @As_anio='2023'                                                                  
  begin                                           
    update TMP_REGCOMPRAS set TIPOBIEN='5' where item =@ITEM                                                                  
  end                                                                  
                                                                                     
    SET @PORCIGVCH=0                                                                                            
    SELECT @PORCIGVCH=PORC_IGV FROM ENPROYECDB.DBO.TB_CAJA_CHICA_REG (NOLOCK)  C                                                              
    INNER JOIN TB_CAJA_CHICA A ON  c.empresa=A.empresa and A.NUM_CAJA=c.NUM_CAJA                                                              
    WHERE DSUBDIA_PROV=@AS_SUBDIA AND DCOMPRO_PROV=@AS_COMPRO                                             
    AND ( YEAR(FECHA_MOV)=@AS_ANIO or YEAR(FECHA_LIQUIDA)=@AS_ANIO     )                                                           
  --YEAR(FECHA_LIQUIDA)=@AS_ANIO                       
     and  NUM_COMPR = trim(@AS_SERIE) +'-'+ trim(@AS_NUMERO)   AND C.EMPRESA=@AS_EMPRESA   and c.DESTINO= @AS_RUC                                                 
                                                                          
 SET @PORCIGV=IIF(ISNULL(@PORCIGVCH,0)=0,@IGV,@PORCIGVCH)                                                                                          
                                                                        
 IF (ISNULL(@PORCIGVCH,0)=0)                                                                    
  SELECT @PORCIGV=10.00  FROM ENPROYECDB.DBO.V_RUCIGV10 WHERE RUC= @AS_RUC  and @fecha_doc>='202308'                                                                                        
                                                                                    
     SELECT @AS_TRANSFER=NULL,@ADT_DETRA=NULL ,@AS_SDCANC=NULL,@AS_CMCANC=NULL,@AS_COD_DTR=null,@AS_TASADETRA=0.00,@NUM_CERTI=''                                                                                                                  
     DELETE  @MYTABLE                                                                        
                                                                                                                              
  /*OBTENER IGV*/                                                                                                              
    SET @MYSQL=' SELECT SUM(DMNIMPOR) FROM RSCONCAR..CT00'+@XEMP+'COMD'+@XPER+' WITH (NOLOCK) WHERE DSUBDIA='''+@AS_SUBDIA+''' AND  DCOMPRO='''+@AS_COMPRO+''' AND DCUENTA IN (''401111'',''40101'') '
                                                                        
    INSERT @MYTABLE (IMPORTE)                                                                                                                                    
     EXECUTE (@MySql)                                                                                 
                                                                                           
   UPDATE  R SET IGV=T.IMPORTE                                                                                   
   FROM  TMP_REGCOMPRAS R,                                                                           
    @MYTABLE T                                                                                                                                                            
     WHERE ITEM=@ITEM                                                                                                         
                                                                                        
  /*OBTENER IMPUESTO BOLSA*/                                                                              
     DELETE @MYTABLE                                                                                                                                              
     SET @MYSQL=' SELECT SUM(DMNIMPOR) FROM RSCONCAR..CT00'+@XEMP+'COMD'+@XPER+' WITH (NOLOCK) WHERE DSUBDIA='''+@AS_SUBDIA+''' AND  DCOMPRO='''+@AS_COMPRO+''' AND DCUENTA IN (''641902'') ' 
                
    INSERT @MYTABLE (IMPORTE)                                                                                                                                    
     EXECUTE (@MySql)                                                                        
                                                                                                          
     UPDATE  R SET IMPBOLSA =isnull(T.IMPORTE,0)                                                                                                                                                                         
     FROM  TMP_REGCOMPRAS R,                                                                                              
    @MYTABLE T                                                       
     WHERE ITEM=@ITEM                                                                                                                                                              
  /**/                                                                       
                                                                       
  /*OBTENER IMPUESTO FISE*/                                                                                     
     DELETE @MYTABLE                                            
     SET @MYSQL=' SELECT SUM(DMNIMPOR) FROM RSCONCAR..CT00'+@XEMP+'COMD'+@XPER+' WITH (NOLOCK) WHERE DSUBDIA='''+@AS_SUBDIA+''' AND  DCOMPRO='''+@AS_COMPRO+''' AND DCUENTA IN (''641901'') ' 
    INSERT @MYTABLE (IMPORTE)                                                                                                                                                                   
     EXECUTE (@MySql)                                                                                                                                                                 
                                                                                                               
     UPDATE  R SET IMPFISE =isnull(T.IMPORTE,0)                                                                                                       
             
     FROM  TMP_REGCOMPRAS R,                                                                                                                                                                            
  @MYTABLE T                                                                                                                                                                                                                         
     WHERE ITEM=@ITEM                                                                                   
  /**/                                                                                                     
                                                        
     /*OBTENER INAFECTO*/                                                                                         
   SET @MYSQL=' SELECT SUM(DMNIMPOR) FROM RSCONCAR..CT00'+@XEMP+'COMD'+@XPER+' WITH (NOLOCK) WHERE DSUBDIA='''+@AS_SUBDIA+''' AND DCOMPRO='''+@AS_COMPRO+''' AND DCUENTA in (''18903'',''65998'',''659911'',''659907'') '
                                       
   DELETE @MYTABLE                                                                  
   INSERT @MYTABLE (IMPORTE)                                                                                                                                             
   EXECUTE (@MySql)                                                                                                                                     
                             
     /*OBTENER INAFECTO 2*/                                            
                                                                                                
    If (select isnull(IMPORTE,0) from @MYTABLE)=0                                                                                                                                                           
   Begin                                                                                                                         
     SET @MYSQL=' SELECT ISNULL(Case when (SELECT SUM(DMNIMPOR) FROM RSCONCAR..CT00'+@XEMP+'COMD'+@XPER+' WITH (NOLOCK) WHERE DSUBDIA='''+@AS_SUBDIA+''' AND ' 
     SET @MYSQL=@MYSQL+ ' DCOMPRO='''+@AS_COMPRO+''' AND DCUENTA=''141901''  AND NOT EXISTS (SELECT 1 FROM RSCONCAR..CT00'+@XEMP+'COMD'+@XPER+' WITH (NOLOCK) '
     SET @MYSQL=@MYSQL+ ' WHERE DSUBDIA='''+@AS_SUBDIA+''' AND DCOMPRO='''+@AS_COMPRO+''' AND DCUENTA IN(''18903''))) >0 then  (SELECT SUM(DMNIMPOR) FROM RSCONCAR..CT00'+@XEMP+'COMD'+@XPER+' WITH (NOLOCK) WHERE DSUBDIA='''+@AS_SUBDIA+''' AND '
                                                       
     SET @MYSQL=@MYSQL+ ' DCOMPRO='''+@AS_COMPRO+''' AND DCUENTA=''141901''  AND NOT EXISTS (SELECT 1 FROM RSCONCAR..CT00'+@XEMP+'COMD'+@XPER+' WITH (NOLOCK) '
     SET @MYSQL=@MYSQL+ ' WHERE DSUBDIA='''+@AS_SUBDIA+''' AND DCOMPRO='''+@AS_COMPRO+''' AND DCUENTA IN(''18903'') ) ) end,0)'
                                           
     DELETE @MYTABLE                                                                                                                                                                                                    
     INSERT @MYTABLE(IMPORTE)                                                                                         
     EXECUTE (@MySql)                                                                                                                                                               
                                                                                         
     end                                                                                                                                                                     
                                                                                                                  
     UPDATE R SET EXONERADO=CASE WHEN ISNULL(IGV,0) =0.00 and ISNULL(TOTAL,0.00)>0.20  THEN ISNULL(TOTAL,0.00) ELSE ISNULL(T.IMPORTE,0) END                                                                                                       
     FROM TMP_REGCOMPRAS R,                                              
     @MYTABLE T                                                                                          
     WHERE R.ITEM=@ITEM                                                                                                              
                                                                                               
   /*FIN INAFECTO*/                                                                            
                                                               
     /*OBTENER BASE */                                                              
   UPDATE TMP_REGCOMPRAS SET BASE = CASE WHEN ISNULL(IGV,0) >0 or (ISNULL(IGV,0)=0 and ISNULL(TOTAL,0)< 0.20) THEN  ISNULL(TOTAL,0) - ISNULL(IGV,0) - ISNULL(EXONERADO,0) -ISNULL(IMPBOLSA,0) -ISNULL(IMPFISE,0) ELSE 0.00 END   WHERE ITEM=@ITEM              
                                            
   /*Se comento para FT. que se emitieron mal el IGV*/                                                  
  UPDATE TMP_REGCOMPRAS SET BASE = CASE WHEN ABS(ROUND(IGV*100.00/@PORCIGV,2) - BASE) >0.85                                                                      
                        THEN round(IGV*100.00/@PORCIGV,2)  ELSE BASE END                                                                                    
  WHERE ITEM=@ITEM                                                            
  and not ( SUBCOMPR in ('12030012','12030006') and periodo='20220300' and serie='F005' and NUMERO in ('3483','3443')  )                                                                                                                
  and not ( SUBCOMPR in  ('12050036','12050151','12050191','12050452') and periodo='20220500' and ruc='20601779553')        
  and not ( SUBCOMPR in  ('11100425') and periodo='20221000' and ruc='20131312955')                                                              
  and not ( SUBCOMPR in  ('11120593') and periodo='20221200' and ruc='20131312955')    -- pedido de rut                                                                                                                     
  --and not ( SUBCOMPR in  ('11080267') and periodo='20230800' and ruc='20414955020')    -- pedido de rut    ----AJUSTE EN CENTIMOS DE IGV NO CUADRA                                                                                                           
       
                                      
  /*EXONERADO*/                 /*cambiar decimales para exonerado*/                                                                                                                                                              
   UPDATE TMP_REGCOMPRAS                                                                                                                    
   SET EXONERADO=CASE WHEN ABS(ROUND(IGV*100.00/@PORCIGV,2) - BASE) >0.85 THEN ISNULL(BASE,0) - round(IGV*100.00/@PORCIGV,2) ELSE ISNULL(EXONERADO,0) END                                                                                                    
                                                               
   WHERE ITEM=@ITEM                                                                          
   /*aGREAGADO 14-05-19*/                                                                 
   AND   ISNULL(EXONERADO,0)=0                                                                                            
                           
   /*AJUSTAR BASE*/                                                                                                                                                                                          
   /*1*/                                                                             
   UPDATE TMP_REGCOMPRAS                                                                                                                         
   SET EXONERADO=CASE WHEN ROUND((ISNULL(BASE,0)+ISNULL(EXONERADO,0))*@PORCIGV/100.00,2)=IGV THEN 0 ELSE EXONERADO END,                                                                                                                                   
           BASE =CASE WHEN ROUND((ISNULL(BASE,0)+ISNULL(EXONERADO,0))*@PORCIGV/100.00,2)=IGV THEN (ISNULL(BASE,0)+ISNULL(EXONERADO,0)) ELSE BASE END                                                                                     
   WHERE ITEM=@ITEM                                                                                                                   
                                                                                                                                                                          
   /*ASIGNAR */                  
   UPDATE TMP_REGCOMPRAS                                                                                                                                    
   SET EXONERADO=CASE WHEN ABS( ROUND(TOTAL/((100.00+@PORCIGV)/100.00),2) - (ISNULL(BASE,0)+ISNULL(EXONERADO,0) )) >0.01 THEN EXONERADO ELSE 0.00  END,                                            
   BASE = CASE WHEN ABS( ROUND(TOTAL/((100.00+@PORCIGV)/100.00),2) - (ISNULL(BASE,0)+ISNULL(EXONERADO,0) )) >0.01 THEN BASE  ELSE ISNULL(BASE,0)+ISNULL(EXONERADO,0)  END                                                                                 
               
           
   WHERE ITEM=@ITEM                                                                   
                                                                                                                                       
   /*SOLO PARA LOS DE SUBDIARIO 18 */                                                                                                                                                                                               
   UPDATE TMP_REGCOMPRAS SET BASE  =round(IGV*100.00/@PORCIGV,2) WHERE DSUBDIA='18'                                                                                                             
   UPDATE TMP_REGCOMPRAS SET TOTAL =ISNULL(IGV,0)+ISNULL(BASE,0) WHERE DSUBDIA='18'                                                                                                 
 /*exonerado CJ 16-12-2014*/                           
                                            
  /*FISE*/                                                                                                            
  UPDATE TMP_REGCOMPRAS                                                                                 
  SET  OTR_TRIB= ISNULL(IMPFISE,0)                                                                                
  WHERE ITEM=@ITEM -- AND ISNULL(EXONERADO,0)=0                                                                                                                                   
                                                                                                                
  /*EXONERADO*/                                                                                                                                  
    UPDATE TMP_REGCOMPRAS SET EXONERADO=ISNULL(TOTAL,0) - ISNULL(BASE,0) - ISNULL(IGV,0)  - ISNULL(IMPBOLSA,0) - ISNULL(IMPFISE,0)                                      
    WHERE ITEM=@ITEM -- AND ISNULL(EXONERADO,0)=0                                                                                                       
  /*exonerado CJ 16-12-2014*/                                                                                                                   
                             
  --     SELECT * FROM TMP_REGCOMPRAS                                                                                                                
                                                                                                                                                                                                                       
 IF  @AS_TIPO_DOC='07'  OR @AS_TIPO_DOC='08'   OR @AS_TIPO_DOC='87' OR @AS_TIPO_DOC='88'       --- NOTA DE CREDITO / NOTA DEBITO / ESPECIAL NC o ND                                                                                                           
BEGIN                                                                                                
                    
    SET @mySql='INSERT RSCONCAR..CT00'+@XEMP+'DOCF'+@XPER+'(DF_CSUBDIA,DF_CCOMPRO,DF_CSECCOM,DF_CSECREF,DF_CTIPDOC,DF_CSERDOC,DF_CNUMDOC,DF_DFECDOC,DF_NBASIMN,DF_NBASIUS,DF_NIGVMN,DF_NIGVUS)'+char(13)+
    ' SELECT DSUBDIA,DCOMPRO,DSECUE,''01'','+char(13)+
    ' TIPO_DOC=(SELECT TOP 1 TIP_COMPR_ORIG FROM FINANCIANDO_CIE WITH (NOLOCK) WHERE TIPO_COMPR=DTIPDOC AND NUM_COMPR=DNUMDOC AND PROVEEDOR=DCODANE AND EMPRESA='''+@AS_EMPRESA+''' ),'+char(13)+ 
    ' SERDOC  ='' '','+char(13)+
    ' NRO_DOC =(SELECT TOP 1 NUM_COMPR_ORIG FROM FINANCIANDO_CIE WITH (NOLOCK)  WHERE TIPO_COMPR=DTIPDOC AND NUM_COMPR=DNUMDOC AND PROVEEDOR=DCODANE AND EMPRESA='''+@AS_EMPRESA+''' ),'+char(13)+
	' FECHA_DOC =(SELECT TOP 1 FECH_COMPR_ORIG FROM FINANCIANDO_CIE WITH (NOLOCK) WHERE TIPO_COMPR=DTIPDOC AND NUM_COMPR=DNUMDOC AND PROVEEDOR=DCODANE AND EMPRESA='''+@AS_EMPRESA+''' ),'+char(13)+
	' NBASIMN=0.00, NBASIUS=0.00,NIGVMN=0.00,NIGVUS=0.00 '+char(13)+
    ' FROM RSCONCAR..CT00'+@XEMP+'COMD'+@XPER+' WHERE DSUBDIA='''+@AS_SUBDIA+''' AND DCOMPRO='''+@AS_COMPRO+''' AND '+char(13)+
    ' DCUENTA IN (''421201'',''421202'',''421406'',''431201'',''431202'',''421206'',''421204'',''471303'',''471304'',''471305'',''471306'',''455115'',''455116'',''465401'',''465402'', '+char(13)+  
	' ''479102'',''471109'',''471110'',''471108'',''471104'',''471107'') '+char(13)+   
    ' AND ( ( (dtipdoc=''NA'' OR dtipdoc=''87'') and DDH=''D'') or ( (dtipdoc<>''NA'' and dtipdoc<>''87'' ) and DDH=''H'')) AND '+char(13)+
    ' (SELECT TOP 1 TIPO_COMPR FROM FINANCIANDO_CIE WITH (NOLOCK)  WHERE TIPO_COMPR=DTIPDOC AND NUM_COMPR=DNUMDOC AND PROVEEDOR=DCODANE AND EMPRESA='''+@AS_EMPRESA+''' ) IS NOT NULL AND '+char(13)+                                            
    ' NOT EXISTS (SELECT 1 FROM RSCONCAR..CT00'+@XEMP+'DOCF'+@XPER+' WITH (NOLOCK) WHERE DF_CSUBDIA=RSCONCAR..CT00'+@XEMP+'COMD'+@XPER+'.DSUBDIA AND '+char(13)+
    ' DF_CCOMPRO=RSCONCAR..CT00'+@XEMP+'COMD'+@XPER+'.DCOMPRO AND DF_CSECCOM=RSCONCAR..CT00'+@XEMP+'COMD'+@XPER+'.DSECUE )'  +char(13)+
    ' AND ISNULL((SELECT TOP 1 TIP_COMPR_ORIG FROM FINANCIANDO_CIE WITH (NOLOCK) WHERE TIPO_COMPR=DTIPDOC AND NUM_COMPR=DNUMDOC AND PROVEEDOR=DCODANE AND EMPRESA='''+@AS_EMPRESA+''' ),'''')<>'''''                                            
                                            
       --  print '6.1 '+@MySql                                                                                                                                                                              
    EXECUTE (@MySql)                            
                                                                                 
   SET @mySql='INSERT RSCONCAR..CT00'+@XEMP+'DOCF'+@XPER+'(DF_CSUBDIA,DF_CCOMPRO,DF_CSECCOM,DF_CSECREF,DF_CTIPDOC,DF_CSERDOC,DF_CNUMDOC,DF_DFECDOC,DF_NBASIMN,DF_NBASIUS,DF_NIGVMN,DF_NIGVUS)'+char(13)+ 
   ' SELECT DSUBDIA,DCOMPRO,DSECUE,''01'','+char(13)+ 
   ' TIPO_DOC=(SELECT TOP 1 TIPO_DOC_ORIG FROM TB_PROVI_CAB WITH (NOLOCK) WHERE TIPO_COMPR=DTIPDOC AND FACTURA=DNUMDOC AND PROVEEDOR=DCODANE AND EMPRESA='''+@AS_EMPRESA+''' ),'+char(13)+ 
   ' SERDOC  ='' '','+char(13)+ 
   ' NRO_DOC =(SELECT TOP 1 NRO_DOC_ORIG FROM TB_PROVI_CAB WITH (NOLOCK) WHERE TIPO_COMPR=DTIPDOC AND FACTURA=DNUMDOC AND PROVEEDOR=DCODANE AND EMPRESA='''+@AS_EMPRESA+''' ),'+char(13)+ 
   ' FECHA_DOC =(SELECT TOP 1 FECHA_DOC_ORIG FROM TB_PROVI_CAB WITH (NOLOCK) WHERE TIPO_COMPR=DTIPDOC AND FACTURA=DNUMDOC AND PROVEEDOR=DCODANE AND EMPRESA='''+@AS_EMPRESA+''' ),'+char(13)+ 
   ' NBASIMN=0.00, NBASIUS=0.00,NIGVMN=0.00,NIGVUS=0.00 '+char(13)+ 
   ' FROM RSCONCAR..CT00'+@XEMP+'COMD'+@XPER+' WHERE DSUBDIA='''+@AS_SUBDIA+''' AND DCOMPRO='''+@AS_COMPRO+''' AND '+char(13)+ 
   ' DCUENTA IN (''421201'',''421202'',''421406'',''431201'',''431202'',''421206'',''421204'',''471303'',''471304'',''471305'',''471306'',''455115'',''455116'',''465401'',''465402'',''479102'','+char(13)+ 
   ' ''471109'',''471110'',''471108'',''471104'',''471107'') AND '+char(13)+ 
   ' ( ( (dtipdoc=''NA'' OR dtipdoc=''87'' ) and DDH=''D'') or ( (dtipdoc<>''NA'' and dtipdoc<>''87'' ) and DDH=''H'')) AND '+char(13)+ 
   ' (SELECT TOP 1 TIPO_COMPR FROM TB_PROVI_CAB WITH (NOLOCK)  WHERE TIPO_COMPR=DTIPDOC AND FACTURA=DNUMDOC AND PROVEEDOR=DCODANE AND EMPRESA='''+@AS_EMPRESA+''' ) IS NOT NULL AND '+char(13)+ 
   ' NOT EXISTS (SELECT 1 FROM RSCONCAR..CT00'+@XEMP+'DOCF'+@XPER+' WITH (NOLOCK) WHERE DF_CSUBDIA=RSCONCAR..CT00'+@XEMP+'COMD'+@XPER+'.DSUBDIA AND '+char(13)+ 
   ' DF_CCOMPRO=RSCONCAR..CT00'+@XEMP+'COMD'+@XPER+'.DCOMPRO AND DF_CSECCOM=RSCONCAR..CT00'+@XEMP+'COMD'+@XPER+'.DSECUE )' +char(13)+ 
   ' AND ISNULL((SELECT TOP 1 TIPO_DOC_ORIG FROM TB_PROVI_CAB WITH (NOLOCK) WHERE TIPO_COMPR=DTIPDOC AND FACTURA=DNUMDOC AND PROVEEDOR=DCODANE AND EMPRESA='''+@AS_EMPRESA+''' ),'''')<>'''''                                            
                                                      
    print '6.1.1 '+@MySql                                                                                                                                                     
    EXECUTE (@MySql)                                               
                             
    /**DOC. ORGINAL**/                                                                              
    SET @MYSQL=' SELECT TOP 1 DSECUE FROM RSCONCAR..CT00'+@XEMP+'COMD'+@XPER+' WHERE DSUBDIA='''+@AS_SUBDIA+''' AND DCOMPRO='''+@AS_COMPRO+
		''' AND LEFT(DCUENTA,2) in (''42'',''43'',''46'') AND DTIPDOC !=''DR'' AND ( ( (dtipdoc=''NA'' OR dtipdoc=''87'' ) and DDH=''D'') or ( (dtipdoc<>''NA'' and dtipdoc<>''87'' ) and '+
       ' DDH=''H'' and DCUENTA NOT IN (''432106'',''422104'') )) ' 
                    
    DELETE @MYTABLE                                                                                                                                                                                                                
    INSERT @MYTABLE (SECUE)                                                      
    EXECUTE (@MySql)                                                                                                                
                             
   SELECT @AS_SECUE=SECUE FROM @MYTABLE                                                                                            
                                                                                                                                                      
   /*TIPO, NRO. DOC Y FECHA ORIGINAL*/                                                                                                                        
   SET @MYSQL=' SELECT top 1 DF_CTIPDOC,DF_CNUMDOC,DF_DFECDOC FROM RSCONCAR..CT00'+@XEMP+'DOCF'+@XPER+' WHERE DF_CSUBDIA='''+@AS_SUBDIA+''' AND DF_CCOMPRO='''+@AS_COMPRO+''' AND DF_CSECCOM='''+@AS_SECUE+''''
        
          
	  DELETE @MYTABLE                                                                                   
	  INSERT @MYTABLE(TIPODOC,NRODOC,FECHA)                
	  EXECUTE (@MySql)                                         
  --PRINT @MySql                                                        
/*FECHA DOC ORIGINAL*/                                                                                                                                                                
                                                                
     UPDATE @MYTABLE SET  TIPODOC=CASE RTRIM(TIPODOC) WHEN 'FT' THEN '01' WHEN 'ND' THEN '08' WHEN 'RC' THEN '14' WHEN 'TK' THEN '12' WHEN 'NA' THEN '07' WHEN 'DA' THEN '13'  ELSE RTRIM(TIPODOC) END,
     FECHA_TXT=RIGHT('00'+RTRIM(CONVERT(CHAR(2),DAY(FECHA))),2)+'/'+RIGHT('00'+RTRIM(CONVERT(CHAR(2),MONTH(FECHA))),2)+'/'+RTRIM(CONVERT(CHAR(4),YEAR(FECHA)))                                                                           
          
  END                                                                                                                                             
                                                                             
 UPDATE R                                                                 
	SET                                                                                         
		 FECH_DOC_ORI  =CASE WHEN R.DTIPDOC='07' OR R.DTIPDOC='08' OR R.DTIPDOC='87' OR R.DTIPDOC='88'  THEN T.FECHA_TXT ELSE '01/01/0001' END,                                                                                                    
		 TIPO_DOC_ORIG =CASE WHEN R.DTIPDOC NOT IN ('07','08','87','88') THEN ' ' ELSE T.TIPODOC END, 
		 SERIE_ORIG    =CASE WHEN R.DTIPDOC NOT IN ('07','08','87','88') THEN ' ' ELSE  CASE WHEN  CHARINDEX('-',T.NRODOC) >0  THEN SUBSTRING(T.NRODOC,1, CHARINDEX('-',rtrim(T.NRODOC)) -1 ) ELSE ' ' END  END, 
		 NUM_ORIG      =CASE WHEN R.DTIPDOC NOT IN ('07','08','87','88') THEN ' ' ELSE  CASE WHEN  CHARINDEX('-',T.NRODOC) >0  THEN SUBSTRING(T.NRODOC,CHARINDEX('-',rtrim(ltrim(T.NRODOC)))+1,15 ) ELSE T.NRODOC END END
			 --,RETENCION    =''                                                                                              
    FROM TMP_REGCOMPRAS R, @MYTABLE  T                             
    WHERE ITEM=@ITEM                                                                            
                                                                         
   DELETE @MYTABLE                                                                                                                                                   
   IF   @FLG_RETENCION='S'  --- NRODOC SI QUE TIENE NC o ND  SINO   NRODOC IS NULL                                                                                                                                                                             
   BEGIN                                                                     
    /*RETENCION*/                                                                                                                                                                                      
       SET @MYSQL=' SELECT TOP 1 RD_CNUMCER FROM RSCONCAR..CT00'+@XEMPDETRA+'RETD11 WHERE RD_CCODANE='''+@AS_RUC+''' AND  RD_CSERDOC='''+@AS_SERIE+''' AND RD_CNUMDOC='''+@AS_NUMERO+''' '                                                                     
                                                                                            
       INSERT  @MYTABLE (NRODOC)                                                                                                                            
       EXECUTE (@MySql)                                                                        
   END                                                                                                                                                                                              
  -- PRINT @FLG_RETENCION                                                                                                                 
  -- PRINT @MYSQL                                                                                      
   --select * from @MYTABLE                                                                                                                                                                                                                                   
  --      /**/                                                                              
                                                                                                        
   UPDATE R         --- R.DTIPDOC='07' ES NC                  
   SET NUM_CERTI=T.NRODOC,                                                                                                                      
    RETENCION=CASE WHEN R.DTIPDOC='07' THEN '' ELSE CASE WHEN ISNULL(T.NRODOC,'')='' THEN RETENCION ELSE '1' END END,                                                                                                                                          
  
    
     
    PERIODO_DEC=CASE WHEN DATEDIFF(MM,CONVERT(DATETIME,FECH_COMP,103),CONVERT(DATETIME,@LS_FECHA_INI,103)) >12                                                                                                                                               
     THEN '7' WHEN DATEDIFF(MM,CONVERT(DATETIME,FECH_COMP,103),CONVERT(DATETIME,@LS_FECHA_INI,103))>0 THEN '6' ELSE '1' END                                        
                                                                     
     FROM TMP_REGCOMPRAS R,                                                                                       
    @MYTABLE T                                                                                 
   WHERE  ITEM=@ITEM                                                                                                  
                                                                                                    
   /*SI ES NA. MOSTRAR EN NEGATIVO*/                                                 
   UPDATE   TMP_REGCOMPRAS                                          
   SET BASE=BASE *(CASE WHEN DTIPDOC IN ('07','87') THEN -1 ELSE 1 END) ,                                                                                                                                                                                      
  
    
      
       
          
    IGV=IGV *(CASE WHEN DTIPDOC IN ('07','87') THEN -1 ELSE 1 END),                                                                                                                                             
    EXONERADO=EXONERADO *(CASE WHEN DTIPDOC IN ('07','87') THEN -1 ELSE 1 END),                                                                                                             
    TOTAL    =TOTAL *(CASE WHEN DTIPDOC IN ('07','87') THEN -1 ELSE 1 END)    ,                                                                                                
 OTR_TRIB = OTR_TRIB *(CASE WHEN DTIPDOC IN ('07','87') THEN -1 ELSE 1 END),                                                                                                    
    PORCIGV=@PORCIGV                                                                   
      WHERE  ITEM=@ITEM                                                                                                                                                         
                                                   
   /**/                            
                                                                                                                                                                               
       FETCH NEXT FROM CUR_COMP INTO @AS_SUBDIA, @AS_COMPRO ,@ITEM,@AS_MONEDA,@AS_SERIE,@AS_NUMERO,@AS_RUC ,@AS_TIPO_DOC,@AS_SERIE_INI,@fecha_doc                                             
      END                                                                                                                                
    CLOSE CUR_COMP                                                                                                                                        
    DEALLOCATE CUR_COMP                                                                                      
                                                                                                                                                                                                                 
 /*******************************************************RETORNAR DATOS *********************************************/                                                                        
  --SELECT * FROM TMP_REGCOMPRAS                   
  --SELECT * FROM TB_CONSTANCIAS_DETRA WHERE  RucProveedor='20524561264' AND SERIECOMPR='F001' AND nroCompr IN ('305','301','304') ORDER BY NROCOMPR                                                        
SELECT '1', GETDATE();
-- ================================================================================================================
-- PARET 1

SELECT
    d.rucProveedor
    , d.tipoCompr
    , d.serieCompr
    , d.nroCompr
    , d.montoDeposito
    , d.fechaPago
    , d.comp_SUNAT
    INTO #tempo_TB_CONSTANCIAS_DETRA
FROM enproyecdb.dbo.TB_CONSTANCIAS_DETRA AS d
WHERE d.rucProveedor IN (SELECT ruc FROM TMP_REGCOMPRAS)

-- // --
SELECT
  M.ITEM,
  CASE WHEN M.DTIPDOC IN ('07','87') THEN                                                                                                                                                                                                               
    (select isnull(tc_venta,'0.00') from enproyecdb.dbo.tt_tipo_cambio with(nolock) where tc_fecha= SUBSTRING(FECH_DOC_ORI,1,2)+ SUBSTRING(FECH_DOC_ORI,4,2)+ SUBSTRING(FECH_DOC_ORI,7,4))
  ELSE                     
    (select isnull(tc_venta,'0.00') from enproyecdb.dbo.tt_tipo_cambio with(nolock) where tc_fecha= SUBSTRING(FECH_COMP,1,2)+ SUBSTRING(FECH_COMP,4,2)+ SUBSTRING(FECH_COMP,7,4))
  END TPO_CAMBIO_SUNAT,

  PP.CONDICION_CONT AS CONDICION_CONT,                                                               
  PP.ESTADO_CONT AS ESTADO_CONT,

  (select COUNT(1) from enproyecdb.dbo.PROVEEDORES_RET with (nolock) where RUC=M.RUC) CANT_TIPO_PADRON,  -- DATO ADICIONAL

  CASE WHEN @AS_ANIO>2020 THEN (SELECT TOP(1) FCH_EMISION_XML FROM enproyecdb.dbo.REG_FACTURASERECIBIDAS_X_ANIO_TEMP with (nolock) WHERE EMPRESA =@AS_EMPRESA AND RUC = M.RUC                                                                                    
  AND TIPODOC = (select TOP 1 g.codigo from enproyecdb.dbo.GENERALES g with (nolock) where g.clave='011' and g.codigo<> '0' and g.cod_sunat=DTIPDOC) AND NUM_COMPR=M.SERIE+'-'+M.NUMERO)
  ELSE '-' END AS FCH_EMISION_XML,

  CASE WHEN @AS_ANIO>2020 THEN (SELECT COUNT(1)/*proveedor_xml+''+comprobante_xml*/ FROM enproyecdb.dbo.temp_datos_xml_comparar WITH (NOLOCK)
  
  where compania_orig=@AS_EMPRESA and proveedor_orig = M.RUC and tipo_doc_orig = (select TOP 1 codigo from enproyecdb.dbo.GENERALES g with (nolock) where g.clave='011'
  and g.codigo<> '0' and g.cod_sunat=DTIPDOC) and Comprobante_orig = (M.SERIE+'-'+M.NUMERO))  ELSE 0 END dato,
                                                                                                       
  (select COUNT(1) from enproyecdb.dbo.TMP_REGCOMPRAS B with (nolock) where b.DTIPDOC=M.DTIPDOC and b.SERIE = M.SERIE and b.NUMERO=M.NUMERO and b.RUC = M.RUC  ) Repetidos                                                                                      

  INTO #tempo_parte_1
FROM TMP_REGCOMPRAS M with (nolock)
LEFT JOIN enproyecdb.dbo.PUB_PERSONAS AS PP (NOLOCK) ON PP.IDPERSONA = M.RUC

SELECT '1.1', GETDATE();
-- ================================================================================================================
 SELECT distinct(DSUBDIA), DCOMPRO, FECH_COMP, FECHA_PAGO, DTIPDOC, M.SERIE, M.NUMERO, TIPPER, M.RUC, PROV_ABRE, BASE, IGV, EXONERADO, TOTAL,                                                     
                
 CONST_DETRA, FECHA_DETRA,                                                      
                                                   
/*DETRA_ORIG, FE_DETRA_ORIG,*/                                            
                                          
 Case when abs(total) >=3.5 Then                          
 isnull(( Case when dtipdoc='08' then                                                                                                                      
  ( CASE when (Select top 1 comp_SUNAT From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.rucProveedor=m.ruc  and                                                                                                                               
   
   
       
       
         
           d.tipoCompr = m.tipo_doc_orig and  d.serieCompr=right('0000'+rtrim(m.serie_orig),4) and d.nroCompr=m.num_orig                                                                                 
    and round(montoDeposito*100/M.total,0) >=4  AND CONVERT(VARCHAR(6),CONVERT(DATETIME,fechaPago,103),112)=@PERIODO  ) IS NULL Then                                                                
   (Select top 1 nroconstancia From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.rucProveedor=m.ruc  and                                                                                                                                        
  
    
      
        
          
            
              
                
                  
                    
                      
                        
                          
                            
                              
      d.tipoCompr = m.tipo_doc_orig and  d.serieCompr=right('0000'+rtrim(m.serie_orig),4) and d.nroCompr=m.num_orig                                            
      and ( round(montoDeposito*100/M.total,0) >=4 or (montoDeposito=0.00 and Comp_SUNAT='ND') ) --AND CONVERT(VARCHAR(6),CONVERT(DATETIME,fechaPago,103),112)=@PERIODO                                            
    order by LEN(nroConstancia),periodo desc,convert(date,fechaPago,103) desc, tipoCompr, nroConstancia desc )                                            
                                                             
   ELSE                                                 
                                                        
 CASE when (Select top 1 comp_SUNAT From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.rucProveedor=m.ruc  and                                                                                                                                   
  
    
      
        
          
            
              
                
                  
                    
                      
                        
                          
                            
                              
                               
  d.tipoCompr = m.tipo_doc_orig and  d.serieCompr=right('0000'+rtrim(m.serie_orig),4) and d.nroCompr=m.num_orig                                                                                                                         
 and round(montoDeposito*100/M.total,0) >=4 ORDER BY PERIODO DESC ) = 'C'                                         
    THEN                                                                                                                 
     (Select top 1 d.dato_adicional From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.rucProveedor=m.ruc  and                                                   
      d.tipoCompr = m.tipo_doc_orig and  d.serieCompr=right('0000'+rtrim(m.serie_orig),4) and d.nroCompr=m.num_orig                                            
        and round(montoDeposito*100/M.total,0) >=4 AND comp_SUNAT ='C')                                                                                                                                         
    ELSE                                  
     (Select top 1 nroconstancia From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.rucProveedor=m.ruc  and  ---------- top acv                                            
      d.tipoCompr = m.tipo_doc_orig and  d.serieCompr=right('0000'+rtrim(m.serie_orig),4) and d.nroCompr=m.num_orig                                                                                                                       
    and round(montoDeposito*100/M.total,0) >=4 AND comp_SUNAT ='ND' AND D.dato_adicional=RTRIM(DSUBDIA)+RTRIM(DCOMPRO))                                           
    END                                                                                                                                        
                                                            
 END )                                                              
                                                                                                                                                                       
Else                                
  (CASE when (Select top 1 comp_SUNAT From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.rucProveedor=m.ruc  and                                                                                                                                 
 
     
      
        
         
             
              
                
                 
                    
                  
                         
                          
                           
                              
                               
   d.tipoCompr = m.dtipdoc and d.serieCompr=m.serie and d.nroCompr=m.numero and comp_SUNAT='C') IS NULL Then                                                                                                                                                 
                                                                            
   (Select top 1 nroconstancia From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.rucProveedor=m.ruc  and                                                
   d.tipoCompr = m.dtipdoc and  d.serieCompr=m.serie and d.nroCompr=m.numero                                                   
   order by periodo asc,convert(date,fechaPago,103) asc, tipoCompr, nroConstancia asc )                          
                                                                                                                                                
   ELSE                                                            
                                   
  CASE when (Select top 1 comp_SUNAT From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.rucProveedor=m.ruc  and                                                                                                                                 
   
    
      
        
          
            
              
                
                  
                    
                      
                       
                           
                            
                              
                               
  d.tipoCompr = m.dtipdoc and d.serieCompr=m.serie and d.nroCompr=m.numero and comp_SUNAT='C' ) = 'C' Then                                                                   
    
  (Select top 1 d.dato_adicional From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.rucProveedor=m.ruc  and                                                                                                                       
 d.tipoCompr = m.dtipdoc and  d.serieCompr=m.serie and d.nroCompr=m.numero AND comp_SUNAT ='C')                                                                                                                                                 
  ELSE                    
   (Select top 1 nroconstancia  From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.rucProveedor=m.ruc  and   ---------- top acv                                                                         
                                                                
   d.tipoCompr = m.dtipdoc and  d.serieCompr=m.serie and d.nroCompr=m.numero AND comp_SUNAT ='FT') End  End)                                                             
                                                               
   End) ,' '                  
                                                               
   ) Else ' ' end nroconstancia,                                             
                                                          
                                                                                                           
 Case when abs(total) >=3.5 Then                                                                                                                                                                                                   
 isnull(( Case when dtipdoc='08' then                                                                                                                               
 (CASE when (Select top 1 comp_SUNAT From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.rucProveedor=m.ruc  and                                                           
   d.tipoCompr = m.tipo_doc_orig and  d.serieCompr=right('0000'+rtrim(m.serie_orig),4) and d.nroCompr=m.num_orig                                                                                                                                
           
            
              
                
                 
                    
   and round(montoDeposito*100/M.total,0) >=4 AND CONVERT(VARCHAR(6),CONVERT(DATETIME,fechaPago,103),112)=@PERIODO ) IS NULL Then                                                                                            
                                                               
 (Select top 1 fechapago From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.rucProveedor=m.ruc  and                                                                                                             
     d.tipoCompr = m.tipo_doc_orig and  d.serieCompr=right('0000'+rtrim(m.serie_orig),4) and d.nroCompr=m.num_orig                                                                                                                                  
    and ( round(montoDeposito*100/M.total,0) >=4 or (montoDeposito=0.00 and Comp_SUNAT='ND') )--AND CONVERT(VARCHAR(6),CONVERT(DATETIME,fechaPago,103),112)=@PERIODO                                                                                           
  
   
      
         
          
            
              
                
                  
                    
                     
                         
                         
                             
                              
                                
                                  
                                   
    order by LEN(nroConstancia),periodo desc,convert(date,fechaPago,103) desc, tipoCompr, nroConstancia desc )                                                     
                                                               
   ELSE                                                                        
      
    CASE when (Select top 1 comp_SUNAT From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.rucProveedor=m.ruc  and                                                                                                                                
  
    
      
        
          
            
              
                
                 
    d.tipoCompr = m.tipo_doc_orig and  d.serieCompr=right('0000'+rtrim(m.serie_orig),4) and d.nroCompr=m.num_orig                                                                                                        
                                               
                                                   
    and round(montoDeposito*100/M.total,0) >=4) = 'C'       Then            
                                                   
   (Select top 1 fechapago From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.nroConstancia=                                                                                                                                                     
  
    
      
       
           
            
              
                
                  
                    
                      
        
   (Select top 1 d.dato_adicional From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.rucProveedor=m.ruc  and                                                                                                                                     
  
    
      
        
          
            
              
                
                  
                    
                      
                        
                          
                            
                              
                               
                                 
                                      
                                       
                                          
                                            
                                            
   d.tipoCompr = m.tipo_doc_orig and  d.serieCompr=right('0000'+rtrim(m.serie_orig),4) and d.nroCompr=m.num_orig                                                                            
      and round(montoDeposito*100/M.total,0) >=4 AND comp_SUNAT ='C'))                                                                  
  ELSE                                                                                                                 
                                                                     
    (Select top 1 fechapago From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.rucProveedor=m.ruc  and    ----- top acv                                                                                       
                                                            
      d.tipoCompr = m.tipo_doc_orig and  d.serieCompr=right('0000'+rtrim(m.serie_orig),4) and d.nroCompr=m.num_orig                                                                                             
       and round(montoDeposito*100/M.total,0) >=4 AND comp_SUNAT ='ND' AND D.dato_adicional=RTRIM(DSUBDIA)+RTRIM(DCOMPRO))  END                                               
                                        
                                          
                                       
                                                         
  END )                                                                                                                                                       
Else                                                                                                                                                                         
  (CASE when (Select top 1 comp_SUNAT From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.rucProveedor=m.ruc  and                                                                                                                                
   
    
      
        
          
            
              
                
                 
                    
                       
                        
                         
                            
               
                                
   d.tipoCompr = m.dtipdoc and  d.serieCompr=m.serie and d.nroCompr=m.numero and comp_SUNAT='C' ) IS NULL Then                                                                                                                    
                                   
   (Select top 1 fechapago From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.rucProveedor=m.ruc  and                                                                                                                                            
  
    
      
        
          
            
              
                
                  
                    
                      
                        
                          
                           
   d.tipoCompr = m.dtipdoc and  d.serieCompr=m.serie and d.nroCompr=m.numero                                                                                                                                            
   order by periodo asc,convert(date,fechaPago,103) asc, tipoCompr, nroConstancia asc )                                        
                         
  ELSE                                                                                                                                                        
    CASE when (Select top 1 comp_SUNAT From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.rucProveedor=m.ruc  and                                                                                                                                
  
    
      
       
           
            
              
                
                  
                    
                      
                       
                           
                            
                              
                               
     d.tipoCompr = m.dtipdoc and d.serieCompr=m.serie and d.nroCompr=m.numero and comp_SUNAT='C') = 'C' Then                                                                                                   
                                                                                                                                                
     (Select fechaPago From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.nroConstancia=                                                                                   
     (Select top 1 d.dato_adicional From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.rucProveedor=m.ruc  and                                                                                                           
     d.tipoCompr = m.dtipdoc  and d.serieCompr=m.serie and d.nroCompr=m.numero AND comp_SUNAT ='C'))                                                                                                                      
                                    
 ELSE                                                                  
      (Select top 1 fechapago From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.rucProveedor=m.ruc  and     --------- top acv                                                                            
      d.tipoCompr = m.dtipdoc and  d.serieCompr=m.serie and d.nroCompr=m.numero AND comp_SUNAT ='FT')                                                             
     End                                                             
  End )                                                             
  End) ,' ') Else ' ' end fechapago,                                                              
                                                               
          M.ITEM, COMPR_CANC, TCAMBIO, M.MONEDA, PERIODO, SUBCOMPR, DUA, REF1, REF2, REF3, REF4,                                                                                                                                  
          REF5, ISC, isnull(IMPBOLSA,0) IMPBOLSA  ,IRET, OTR_TRIB, SUJ_NOT, SD_CANC_DETRA, FECH_DOC_ORI, TIPO_DOC_ORIG,                                                                                                                                        
  
    
     
         
         
            
             
                
                 
                     
                      
                        
                          
                            
                              
                                             
                                     
                                      
                                        
                                         
       SERIE_ORIG =case when len(SERIE_ORIG) >0 then RIGHT('0000'+rtrim(SERIE_ORIG),4) else '' end ,                                                                                                                                                           
  
    
      
        
          
            
              
          /*CASE WHEN abs(total)>700 THEN NUM_ORIG ELSE ' ' END*/NUM_ORIG NUM_ORIG,                                                                                                                                                                            
  
    
      
        
          
            
              
                
                  
                    
                      
                        
                          
                            
                              
                                
                                  
                                    
                                      
                                        
                                          
                                            
             
 case when len(rtrim(  Case when abs(total) >=3.5 Then                                                       
  Isnull( Case when dtipdoc='08' then                                                                                      
      (Select top 1 nroconstancia From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.rucProveedor=m.ruc  and                                                                                                                                     
  
    
      
       
           
            
              
                
      d.tipoCompr = m.tipo_doc_orig and  d.serieCompr=right('0000'+rtrim(m.serie_orig),4) and d.nroCompr=m.num_orig                                                    
      and round(montoDeposito*100/M.total,0) >=4 AND CONVERT(VARCHAR(6),CONVERT(DATETIME,fechaPago,103),112)=@PERIODO                                                                                                                                          
  
    
      
        
          
            
              
                
                  
                    
                      
                       
                           
                            
                              
                                
                                  
                                    
                                      
                 
                                          
                                            
           
      order by LEN(nroConstancia),periodo desc,convert(date,fechaPago,103) desc)                                     
    Else                                            
 (Select top 1 nroconstancia From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with                                            
 (nolock) Where d.rucProveedor=m.ruc  and                                                                                                                         
       d.tipoCompr = m.dtipdoc and  d.serieCompr=m.serie and d.nroCompr=m.numero                                                           
   order by LEN(nroConstancia),periodo asc,convert(date,fechaPago,103) asc )                                                     
                                                                                                                        
     End,' ') else ' ' end)) >0                                                                                                                                                 
    then  '' else RETENCION end RETENCION,                                             
    NUM_CERTI, PERIODO_DEC,                                                                                        
          DSECUE, COD_DTR, TASADETRA, M.ESTADO, MONEDA24, M.TIPOBIEN, PROYECTO, ERROR_1, ERROR_2, ERROR_3, ERROR_4, MEDIOPAGO,SALDO,PERIODOEMI ,                                                                                              
          FLG_ADELA, ISNULL(LIBRE,'') ,                                                                              
                              
Case when abs(total) >=3.5 Then                                                                                                                                                                                       
 isnull(( Case when dtipdoc='08' then                                                                                                                  
                                                                                                                                              
  (CASE when (Select top 1 comp_SUNAT From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.rucProveedor=m.ruc  and                                                                                                                  
   d.tipoCompr = m.tipo_doc_orig and  d.serieCompr=right('0000'+rtrim(m.serie_orig),4) and d.nroCompr=m.num_orig                                                   
        
          
           
               
                
                                                           
   and round(montoDeposito*100/M.total,0) >=4 AND CONVERT(VARCHAR(6),CONVERT(DATETIME,fechaPago,103),112)=@PERIODO ) IS NULL Then                                                           
                                                             
   (Select top 1 MontoDeposito From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.rucProveedor=m.ruc  and                                                                                                                                        
 
    
       
        
          
            
              
                
                 
    d.tipoCompr = m.tipo_doc_orig and  d.serieCompr=right('0000'+rtrim(m.serie_orig),4) and d.nroCompr=m.num_orig                                                               
                                   
                                    
                                     
                                        
                                           
                                           
                                            
    and round(montoDeposito*100/M.total,0) >=4 --AND CONVERT(VARCHAR(6),CONVERT(DATETIME,fechaPago,103),112)=@PERIODO                                                  
    
      
        
          
            
              
                
                 
                    
                       
             
                         
                            
                              
                                 
                                  
                                    
                                      
                                        
                                          
                                            
                                              
    order by LEN(nroConstancia),periodo desc,convert(date,fechaPago,103) desc, tipoCompr, nroConstancia desc )                                                                                                                                                
   
    
      
        
          
            
              
                
                  
                    
                      
                        
                          
                            
                              
                                
                                  
                                    
                                      
              
                                          
                                            
                                     
                                                
                                   
   ELSE                                                                                                                                                                           
                                                          
     CASE when (Select top 1 comp_SUNAT From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.rucProveedor=m.ruc  and                                                                                                                               
  
    
      
        
          
            
              
                
                  
                    
                      
                        
                          
                            
                              
                                
                                  
                                    
                                      
                                        
                                         
   d.tipoCompr = m.tipo_doc_orig and  d.serieCompr=right('0000'+rtrim(m.serie_orig),4) and d.nroCompr=m.num_orig                                                                                                                                               
  
    
      
        
          
            
              
               
  and round(montoDeposito*100/M.total,0) >=4) = 'C' Then                                                                                                                                
                                               
     (Select top 1 MontoDeposito From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.nroConstancia=                                                                                
     (Select top 1 d.dato_adicional From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.rucProveedor=m.ruc  and                                                                                                                                   
  
   
       
        
          
            
             
                 
                  
                    
                      
                        
                          
                            
                              
                                
                 
                                    
                                  
                                        
                                          
                                           
                                            
     d.tipoCompr = m.tipo_doc_orig and  d.serieCompr=right('0000'+rtrim(m.serie_orig),4) and d.nroCompr=m.num_orig                                  
                        
                          
                            
                              
                               
     and round(montoDeposito*100/M.total,0) >=4 AND comp_SUNAT ='C'))                                                                                                                          
  ELSE                                                                                                                                                                                        
    (Select top 1 MontoDeposito From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.rucProveedor=m.ruc  and         --------- top acv                                                         
  d.tipoCompr = m.tipo_doc_orig and  d.serieCompr=right('0000'+rtrim(m.serie_orig),4) and d.nroCompr=m.num_orig                                                                                                                                                
  
    
     
         
          
            
              
                
                  
                   
                       
                        
                          
                           
                               
                                
                                  
                                    
                                      
                                        
                            
                                          
  and round(montoDeposito*100/M.total,0) >=4 AND comp_SUNAT ='ND' AND D.dato_adicional=RTRIM(DSUBDIA)+RTRIM(DCOMPRO) )  END                                                                                  
  END )                                                                                                                                                                                        
Else                                            
  (CASE when (Select top 1 comp_SUNAT From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.rucProveedor=m.ruc  and                                                                      
                                                                    
                                                     
   d.tipoCompr = m.dtipdoc and  d.serieCompr=m.serie and d.nroCompr=m.numero) IS NULL Then                                                                                                                                                                     
  
    
      
        
         
             
              
                
                  
                    
                      
                        
                          
                            
                             
                                
   (Select top 1 MontoDeposito From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.rucProveedor=m.ruc and                                                                                         
                                                                            
                                                                            
   d.tipoCompr = m.dtipdoc and  d.serieCompr=m.serie and d.nroCompr=m.numero                                                                                                                                                          
        
          
            
              
                
   order by periodo asc,convert(date,fechaPago,103) asc, tipoCompr, nroConstancia asc )                                                               
  ELSE                                                                        
   CASE when (Select top 1 comp_SUNAT From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.rucProveedor=m.ruc  and                                                                                                                                 
  
   
       
        
          
    
             
                 
                  
                    
                      
                        
                          
                            
                              
                               
                                   
                
                                      
                                        
                                          
                                            
                                            
  d.tipoCompr = m.dtipdoc and d.serieCompr=m.serie and d.nroCompr=m.numero) = 'C' Then                                                                                                   
                                                                                                                                                  
  (Select top 1 MontoDeposito From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.nroConstancia=          --------- top acv                                                                        
    (Select top 1 d.dato_adicional From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.rucProveedor=m.ruc  and                    
   d.tipoCompr = m.dtipdoc  and  d.serieCompr=m.serie and d.nroCompr=m.numero AND comp_SUNAT ='C'))                                   
 ELSE                                                                                                                                                
   (Select top 1 MontoDeposito From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.rucProveedor=m.ruc  and     ------- top acv                                              
                                                                            
   d.tipoCompr = m.dtipdoc and  d.serieCompr=m.serie and d.nroCompr=m.numero AND comp_SUNAT ='FT') End End) End) ,0)                                                           
                                                             
   Else 0 end MontoDeposito,                                                    
                                                                                                                                         
    M.MONTO_ORIG,                                                                               
    substring(FECH_COMP,4,2) MES_COMPR,                                                            
(CASE WHEN @FLG_RETENCION = 'S' THEN                                                                                                                                                                                                                    
  (CASE WHEN (select COUNT(1) from enproyecdb.dbo.PROVEEDORES_RET with (nolock) where RUC=M.RUC)=1 THEN                                                                                                                                                        
 
   
                                                   
   (SELECT G.DESCRIPCION  FROM enproyecdb.dbo.PROVEEDORES_RET PRE with (nolock) INNER JOIN enproyecdb.dbo.GENERALES G WITH (NOLOCK) ON (G.codigo = PRE.CODIGO) AND G.clave=114 WHERE RUC=M.RUC)                                                                
  
    
     
         
         
             
              
               
                   
                   
                      
                       
                                  
                                    
                                      
                                        
                                
                                            
                                            
  WHEN (select COUNT(1) from enproyecdb.dbo.PROVEEDORES_RET with (nolock) where RUC=M.RUC)>1 THEN                                                                                                                
 (CASE WHEN (SELECT COUNT(1) from enproyecdb.dbo.PROVEEDORES_RET with (nolock) where RUC=M.RUC AND CODIGO='BC')=1 THEN 'BUEN CONTRIBUYENTE'                                                                    
    
      
        
          
            
              
                
                  
                    
                     
                       
                           
                    
                             
                                 
                                  
                                    
                                      
                                        
                                          
                                            
                                            
      WHEN (SELECT COUNT(1) from enproyecdb.dbo.PROVEEDORES_RET with (nolock) where RUC=M.RUC AND CODIGO='AR')=1 THEN 'AGENTE RETENCIÓN'                                                                                                                
WHEN (SELECT COUNT(1) from enproyecdb.dbo.PROVEEDORES_RET with (nolock) where RUC=M.RUC AND CODIGO='AP')=1 THEN 'AGENTE PERSEPCIÓN'                                                                                                                           
   
    
      
        
          
            
              
                
                  
                    
                      
                        
                          
                            
                              
                                
                                  
                                    
                                      
                                        
                                          
                                         
                                             
    ELSE 'AGENTE PERSEPCIÓN Ven. Int.' END)                                                                       
 ELSE '' END )                                                                                                                                         
 ELSE NULL END)  TIPO_PADRON,                                                                                                    
                                           
                                           
Case when abs(total) >=3.5 Then                                                          
isnull( Case when dtipdoc='08' /* and abs(total)>700*/ then                                  
                                          
                               
    (case when (Select top 1 MontoDeposito From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.rucProveedor=m.ruc  and                                                                                   
    d.tipoCompr = m.tipo_doc_orig and  d.serieCompr=right('0000'+rtrim(m.serie_orig),4) and d.nroCompr=m.num_orig                                                 
    and round(montoDeposito*100/M.total,0) >=4                                                                                                         
    order by LEN(nroConstancia),periodo desc,convert(date,fechaPago,103) desc, tipoCompr, nroConstancia desc ) > M.MONTO_ORIG then                                                                                                                             
 
     
      
        
          
            
              
                
                  
                                
                                  
                                    
                                     
                                        
                                           
                                                         
  (select TOP 1 IMP_DETRA_MN from enproyecdb.dbo.TB_PROVI_CAB with (nolock)                                                                                
   where PROVEEDOR=m.ruc and empresa=@AS_EMPRESA and FACTURA=m.SERIE+'-'+m.NUMERO  and TIPO_COMPR='ND' AND TIPO='E' AND ESTADO<>'X')                                                                                                         
                                                              
 Else                                                                                                                                                                                                                                       
                                          
  (CASE when (Select top 1 comp_SUNAT From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.rucProveedor=m.ruc  and                                                                                                                                 
  
    
      
        
          
           
                                                           
    d.tipoCompr = m.tipo_doc_orig and  d.serieCompr=right('0000'+rtrim(m.serie_orig),4) and d.nroCompr=m.num_orig                                                                                                                              
   and round(montoDeposito*100/M.total,0) >=4 AND CONVERT(VARCHAR(6),CONVERT(DATETIME,fechaPago,103),112)=@PERIODO) IS NULL Then                                                                                                        
   (Select top 1 MontoDeposito From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.rucProveedor=m.ruc  and                                                
                      
                        
                           
                           
                               
                                
                                  
                                    
                                      
                                        
                                            
    d.tipoCompr = m.tipo_doc_orig and  d.serieCompr=right('0000'+rtrim(m.serie_orig),4) and d.nroCompr=m.num_orig                                              
          
            
                            
                 
                     
                      
                        
                          
                            
                              
                                
                                  
                                    
                                      
                                        
                                         
    and round(montoDeposito*100/M.total,0) >=4                                                                     
    order by LEN(nroConstancia),periodo desc,convert(date,fechaPago,103) desc, tipoCompr, nroConstancia desc )                                                                           
                                                              
   ELSE                                                                                                                       
    (Select top 1 MontoDeposito From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.rucProveedor=m.ruc  and     -------- top acv                                                                            
     d.tipoCompr = m.tipo_doc_orig and  d.serieCompr=right('0000'+rtrim(m.serie_orig),4) and d.nroCompr=m.num_orig                                                                              
     and round(montoDeposito*100/M.total,0) >=4 AND comp_SUNAT ='ND' AND D.dato_adicional=RTRIM(DSUBDIA)+RTRIM(DCOMPRO))                                                                                                                                       
  
    
     
         
          
            
              
                
                  
                    
                      
                        
                          
                            
                              
                                
              
                                   
                                       
                                        
                                         
     END)                                          
                                             
    end)                                                       
   ELSE  --- EN CASO QUE SEA FACTURA U OTRO DISTINTO A NC                                                       
    (CASE when (Select top 1 comp_SUNAT From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.rucProveedor=m.ruc  and                                                   
     d.tipoCompr = m.dtipdoc and  d.serieCompr=m.serie and d.nroCompr=m.numero) IS NULL Then                                                                  
     (Select top 1 MontoDeposito From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.rucProveedor=m.ruc  and                                       
     d.tipoCompr = m.dtipdoc and  d.serieCompr=m.serie and d.nroCompr=m.numero                                                                                                                                                                                 
  
  order by periodo asc,convert(date,fechaPago,103) asc, tipoCompr, nroConstancia asc  )                                                                                                                                                 
                                                                                                                                                    
    ELSE                                                                               
    CASE when (Select top 1 comp_SUNAT From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.rucProveedor=m.ruc  and                                                                                                                                
  
    
      
        
          
           
             
               
                   
                   
    d.tipoCompr = m.dtipdoc and d.serieCompr=m.serie and d.nroCompr=m.numero) = 'C' Then                                                                                                                   
    (Select top 1 MontoDeposito From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.nroConstancia=    ---------- top acv          
          
            
              
                
                  
                   
    (Select top 1 d.dato_adicional From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.rucProveedor=m.ruc  and                                                                                                                                    
  
    
     
         
          
            
              
                
                  
                    
                      
                        
                         
                            
                               
                                
                                 
                                     
                                      
                                       
                                          
    d.tipoCompr = m.dtipdoc  and  d.serieCompr=m.serie and d.nroCompr=m.numero AND comp_SUNAT ='C'))                                          
                                                                                                                                                
ELSE                                                                                                                                                                                                  
      (Select top 1 MontoDeposito From enproyecdb.dbo.TB_CONSTANCIAS_DETRA d with (nolock) Where d.rucProveedor=m.ruc  and     ---------- top acv                                                                            
      d.tipoCompr = m.dtipdoc and  d.serieCompr=m.serie and d.nroCompr=m.numero AND comp_SUNAT ='FT')  End                                                                                                   
                                        
     END )                                                                                                                                                                                              
End , 0)                                                                                    
   Else 0 end    MontoDepositoCorreg,                                           
                                          
      
--CASE WHEN M.DTIPDOC IN ('07','87') THEN
-- (select isnull(tc_venta,'0.00') from enproyecdb.dbo.tt_tipo_cambio with(nolock) where tc_fecha= SUBSTRING(FECH_DOC_ORI,1,2)+ SUBSTRING(FECH_DOC_ORI,4,2)+ SUBSTRING(FECH_DOC_ORI,7,4))
--ELSE                                                                                                                                                                                                        
--  (select isnull(tc_venta,'0.00') from enproyecdb.dbo.tt_tipo_cambio with(nolock) where tc_fecha= SUBSTRING(FECH_COMP,1,2)+ SUBSTRING(FECH_COMP,4,2)+ SUBSTRING(FECH_COMP,7,4))
--END TPO_CAMBIO_SUNAT,
tp1.TPO_CAMBIO_SUNAT,
--PP.CONDICION_CONT, PP.ESTADO_CONT,                                                           
--(SELECT PP.CONDICION_CONT FROM enproyecdb.dbo.PUB_PERSONAS PP WITH (NOLOCK) WHERE PP.IDPERSONA = M.RUC) CONDICION_CONT,                                                               
--(SELECT PP.ESTADO_CONT FROM enproyecdb.dbo.PUB_PERSONAS PP WITH (NOLOCK) WHERE PP.IDPERSONA = M.RUC) ESTADO_CONT,                                                                            
tp1.CONDICION_CONT,
tp1.ESTADO_CONT,

--(select COUNT(1) from enproyecdb.dbo.PROVEEDORES_RET with (nolock) where RUC=M.RUC) CANT_TIPO_PADRON,  -- DATO ADICIONAL                                                                                              
tp1.CANT_TIPO_PADRON,
/***************************************AGREGADO POSTERIOR***********************************************/                                                                                                   
                                                                                                       
/************GRUPO 1*************/                                                                                                                                                              
P.FCH_PROVISION, (CASE WHEN M.DTIPDOC IN ('07','87') THEN -1 ELSE 1 END) * isnull(P.IMP_TOTAL_MN,0) AS MONTO_PROVISION,                                                                          
                                                                       
/*****************************/                                                                                                                    
                      
/* COMENTARIO ACV                                                                                                                                                          
(CASE WHEN DTIPDOC IN ('07','87') THEN                                                                                                 
 (SELECT top(1) G1.descripcion FROM enproyecdb.dbo.FINANCIANDO_CIE FCIE with (nolock)                                                                             
 INNER JOIN enproyecdb.dbo.GENERALES G with (nolock) ON (G.codigo = FCIE.TIPO_COMPR) AND G.clave='011'                                                                                                                                                         
  
   
       
        
         
             
              
                
                  
                    
                     
 INNER JOIN enproyecdb.dbo.GENERALES G1 with (nolock) ON (G1.codigo = FCIE.ESTADO_OPAGO)  AND G1.clave='115'                                                                                                                                         
 WHERE FCIE.FLG_PROVI=1 AND FCIE.ESTADOPROVI='V' AND FCIE.PROVEEDOR = M.RUC                   
 AND CHARINDEX('-',NUM_COMPR)>0 AND G.cod_sunat=M.TIPO_DOC_ORIG AND SUBSTRING(NUM_COMPR,1,(CHARINDEX('-',NUM_COMPR)-1))=M.SERIE_ORIG                       
 and SUBSTRING(NUM_COMPR,(CHARINDEX('-',NUM_COMPR)+1),10)=M.NUM_ORIG )                                                                                   
ELSE                                                                                         
 (SELECT top(1) G1.descripcion FROM enproyecdb.dbo.FINANCIANDO_CIE FCIE with (nolock)                                                                           
 INNER JOIN enproyecdb.dbo.GENERALES G with (nolock) ON (G.codigo = FCIE.TIPO_COMPR) AND G.clave='011'                           
 INNER JOIN enproyecdb.dbo.GENERALES G1 with (nolock) ON (G1.codigo = FCIE.ESTADO_OPAGO)  AND G1.clave='115'                                                                             
 WHERE FCIE.FLG_PROVI=1 AND FCIE.ESTADOPROVI='V' AND FCIE.PROVEEDOR = M.RUC                                                                                                                                                                                    
 
     
      
       
           
           
 AND CHARINDEX('-',NUM_COMPR)>0 AND G.cod_sunat=M.DTIPDOC AND SUBSTRING(NUM_COMPR,1,(CHARINDEX('-',NUM_COMPR)-1))=M.SERIE                        
 and SUBSTRING(NUM_COMPR,(CHARINDEX('-',NUM_COMPR)+1),10)=M.NUMERO) --- * poner top(1) si presenta mas 1                                                                                  
END ) ESTADO_GENERAR_OPAGO, */ '' ESTADO_GENERAR_OPAGO,                       
                                                                                                               
/*************GRUPO 2***************/                                                                                                                                                          
/***acv                                                                                              
----ISNULL(S.TOTAL_FACT,0.00) AS MONTO_GENERAR_OPAGO,                                                               
----ISNULL(S.MONEDA,'') AS MONEDA_GENERAR_OPAGO,                                                                                                  
******/                                                        
0 MONTO_GENERAR_OPAGO,                      
'-' MONEDA_GENERAR_OPAGO,                      
/***********GRUPO 3*****************/                                                                                                             
                        /*******acv                      
(SELECT SUM(OP.MONTO_TOTAL) FROM enproyecdb.dbo.FINANCIANDO_CIE FCIE with (nolock)                                                                                                                                                                             
  
    
      
INNER JOIN enproyecdb.dbo.opago OP With(nolock) on (OP.ITEM_LIQUIDACION = FCIE.ITEM)                                                                                                                               
WHERE FCIE.FLG_PROVI=1 AND FCIE.ESTADOPROVI='V' AND FCIE.PROVEEDOR = M.RUC AND OP.ITEM_LIQUIDACION= (                                                                                                                                      
 select top(1) FCIE.ITEM from enproyecdb.dbo.FINANCIANDO_CIE  FCIE WITH (NOLOCK)                                                                                               
 INNER JOIN enproyecdb.dbo.GENERALES G with (nolock) ON (G.codigo = FCIE.TIPO_COMPR) AND G.clave='011'                                                                                                                                                         
  
   
 WHERE CHARINDEX('-',NUM_COMPR)>0 AND FLG_PROVI=1 AND ESTADOPROVI='V' AND G.cod_sunat=M.DTIPDOC AND SUBSTRING(NUM_COMPR,1,(CHARINDEX('-',NUM_COMPR)-1))=M.SERIE and SUBSTRING(NUM_COMPR,(CHARINDEX('-',NUM_COMPR)+1),10)=M.NUMERO                              
  
    
      
        
         
            
               
                
                  
                    
                      
AND PROVEEDOR= M.RUC) AND OP.TIPO_EGRESO IN (@DETRATER, @DETRAVINUS,@DETRAVINMN) AND OP.ESTADO='S' ) TOTAL_OPAGO_DETRAC,  ----GENERALES.clave = '001'  --'42213' cuenta de detraccion                                            
                    
                     
************/                      
0 TOTAL_OPAGO_DETRAC,                       
/********************************************************/                                                                                                                     
/*******acv                      
(SELECT SUM(OP.MONTO_TOTAL) FROM enproyecdb.dbo.FINANCIANDO_CIE FCIE with (nolock)                                                                                              
INNER JOIN opago OP With(nolock) on (OP.ITEM_LIQUIDACION = FCIE.ITEM)                                                                                                                                                                
WHERE FCIE.EMPRESA=@AS_EMPRESA AND FCIE.FLG_PROVI=1 AND FCIE.ESTADOPROVI='V' AND FCIE.PROVEEDOR = M.RUC AND OP.ITEM_LIQUIDACION= (                                                                                                                             
  
    
      
        
          
            
              
               
                   
                    
                      
select top(1) FCIE.ITEM from enproyecdb.dbo.FINANCIANDO_CIE  FCIE WITH (NOLOCK)                                                                                                                                                                                
  
    
      
        
          
            
              
                
                  
                    
                      
INNER JOIN GENERALES G with (nolock) ON (G.codigo = FCIE.TIPO_COMPR) AND G.clave='011'                                                                                                      
WHERE FCIE.EMPRESA=@AS_EMPRESA AND CHARINDEX('-',NUM_COMPR)>0 AND FLG_PROVI=1 AND ESTADOPROVI='V' AND G.cod_sunat=M.DTIPDOC AND SUBSTRING(NUM_COMPR,1,(CHARINDEX('-',NUM_COMPR)-1))=M.SERIE and SUBSTRING(NUM_COMPR,(CHARINDEX('-',NUM_COMPR)+1),10)=M.NUMERO  
  
    
      
        
          
            
              
                
                  
                    
                      
AND PROVEEDOR= M.RUC) AND OP.TIPO_EGRESO IN ('421201','421202','421406','431201','431202','421204','471303','471304','471305','471306','455115','455116') AND OP.ESTADO='S' ) TOTAL_OPAGO,  ----GENERALES.clave = '001'                                        
  
    
      
        
          
            
              
                
                  
                    
                      
*****************/                      
0 TOTAL_OPAGO,                      
                       
 /***********acv                      
(SELECT COUNT(1) FROM enproyecdb.dbo.FINANCIANDO_CIE FCIE with (nolock)                                                                                                        
INNER JOIN enproyecdb.dbo.opago OP With(nolock) on (OP.ITEM_LIQUIDACION = FCIE.ITEM)                                                                    
WHERE FCIE.EMPRESA=@AS_EMPRESA AND FCIE.FLG_PROVI=1 AND FCIE.ESTADOPROVI='V' AND FCIE.PROVEEDOR = M.RUC AND OP.ITEM_LIQUIDACION= (                                                                                                                             
  
    
      
        
          
            
              
                
                 
                     
                      
select top(1) FCIE.ITEM from enproyecdb.dbo.FINANCIANDO_CIE  FCIE WITH (NOLOCK)                                                                                       
INNER JOIN enproyecdb.dbo.GENERALES G with (nolock) ON (G.codigo = FCIE.TIPO_COMPR) AND G.clave='011'                                                                                                                                                         
WHERE FCIE.EMPRESA=@AS_EMPRESA AND CHARINDEX('-',NUM_COMPR)>0 AND FLG_PROVI=1 AND ESTADOPROVI='V' AND G.cod_sunat=M.DTIPDOC AND SUBSTRING(NUM_COMPR,1,(CHARINDEX('-',NUM_COMPR)-1))=M.SERIE and SUBSTRING(NUM_COMPR,(CHARINDEX('-',NUM_COMPR)+1),10)=M.NUMERO  
  
    
      
        
          
            
              
                
                  
                    
                      
AND PROVEEDOR= M.RUC) AND OP.ESTADO='S' ) CANT_ITEM_OPAGO  ----GENERALES.clave = '001'                                                                                                   
**************/                      
0 CANT_ITEM_OPAGO                      
                      
,CODIGORESP, DESRESP                          
/*** acv                      
--,ISNULL(E.COD_DETR,Q.COD_DETRA) AS COD_DETRA                                                                                                                          
--,ISNULL(E.TDESCRI, Q.TDESCRI) AS TDESCRI                         
*****/                      
, M.COD_DETRA COD_DETRA                      
, M.DES_DETRA TDESCRI                      
,M.usuarioProvi AS USER_DETR                                                 
,M.DXGLOSA AS GLOSA,                                                                                                                            
                          
--CASE WHEN @AS_ANIO>2020 THEN (SELECT TOP(1) FCH_EMISION_XML FROM enproyecdb.dbo.REG_FACTURASERECIBIDAS_X_ANIO_TEMP with (nolock) WHERE EMPRESA =@AS_EMPRESA AND RUC = M.RUC                                                                                    
 
     
      
        
         
--AND TIPODOC = (select TOP 1 g.codigo from enproyecdb.dbo.GENERALES g with (nolock) where g.clave='011' and g.codigo<> '0' and g.cod_sunat=DTIPDOC) AND NUM_COMPR=M.SERIE+'-'+M.NUMERO)                                                                         
 
--ELSE '-' END AS FCH_EMISION_XML, 
tp1.FCH_EMISION_XML,
                                                                                                    
--CASE WHEN @AS_ANIO>2020 THEN (SELECT COUNT(1)/*proveedor_xml+''+comprobante_xml*/ FROM enproyecdb.dbo.temp_datos_xml_comparar WITH (NOLOCK)                                                                                                                    
  
--where compania_orig=@AS_EMPRESA and proveedor_orig = M.RUC and tipo_doc_orig = (select TOP 1 codigo from enproyecdb.dbo.GENERALES g with (nolock) where g.clave='011'                                                        
--and g.codigo<> '0' and g.cod_sunat=DTIPDOC) and Comprobante_orig = (M.SERIE+'-'+M.NUMERO))  ELSE 0 END dato,
tp1.dato,
                                                                                                       
--(select COUNT(1) from enproyecdb.dbo.TMP_REGCOMPRAS B with (nolock) where b.DTIPDOC=M.DTIPDOC and b.SERIE = M.SERIE and b.NUMERO=M.NUMERO and b.RUC = M.RUC  ) Repetidos,                                                                                      
tp1.Repetidos,
    
     
         
        
                      
PORCIGV= round(PORCIGV/100.00,2),                                                                              
 ''  CAMPO1, '' CAMPOP2, '' CAMPO3                                             
FROM TMP_REGCOMPRAS  M    with (nolock)                                                    
LEFT JOIN #tempo_parte_1 as tp1 ON M.ITEM = tp1.ITEM
--------LEFT JOIN PROVEEDORES_RET PR WITH (NOLOCK) ON M.RUC = PR.RUC AND PR.FECHA_INI <= CONVERT(DATETIME,FECH_COMP,103) AND CONVERT(DATETIME,FECH_COMP,103) <= GETDATE()                                                                                  
                      
                       
--LEFT JOIN PUB_PERSONAS PP WITH (NOLOCK) ON  (PP.IDPERSONA = M.RUC)                                                                    
                                                                            
--LEFT JOIN (SELECT CONVERT(VARCHAR(10),TC.FECH_PROVI, 103) AS FCH_PROVISION, TC.IMP_TOTAL_MN, TC.PROVEEDOR, G.cod_sunat, TC.FACTURA, TC.DETALLE                                                                                        
--   FROM TB_PROVI_CAB TC with (nolock)                                                                                                                                                           
--   INNER JOIN GENERALES G with (nolock) ON (G.codigo = TC.TIPO_COMPR) AND G.clave='011'                                                                                                                                                         
--   WHERE CHARINDEX('-',TC.FACTURA)>0 AND TC.TIPO='E' AND ISNULL(TC.ESTADO,'') NOT IN ('X','A') AND TC.EMPRESA=@AS_EMPRESA ) P                                                                          
--   ON (P.PROVEEDOR=M.RUC) AND P.cod_sunat=M.DTIPDOC AND SUBSTRING(P.FACTURA,1,(CHARINDEX('-',P.FACTURA)-1))=M.SERIE and SUBSTRING(P.FACTURA,(CHARINDEX('-',P.FACTURA)+1),10)=M.NUMERO                                              
                                                                                                
LEFT JOIN #TABLA1 P ON (P.PROVEEDOR COLLATE Modern_Spanish_CI_AS = M.RUC) AND P.cod_sunat COLLATE Modern_Spanish_CI_AS = M.DTIPDOC AND P.SERIE COLLATE Modern_Spanish_CI_AS = M.SERIE                                                                          
 
    
and P.NUMERO COLLATE Modern_Spanish_CI_AS = M.NUMERO                   
                      
/********acv                                                                
--LEFT JOIN ( SELECT FCIE.TOTAL_FACT, FCIE.MONEDA, FCIE.PROVEEDOR, FCIE.NUM_COMPR, G.COD_SUNAT, FCIE.EMPRESA, FCIE.TIPO_COMPR                                                                    
--   FROM enproyecdb.dbo.FINANCIANDO_CIE FCIE with (nolock)                                                                                                                                                                                                    
  
--   INNER JOIN enproyecdb.dbo.GENERALES G with (nolock) ON (G.codigo = FCIE.TIPO_COMPR) AND G.clave='011'                                                                                                                                 
--   WHERE FCIE.FLG_PROVI=1 AND FCIE.ESTADOPROVI='V' AND CHARINDEX('-',FCIE.NUM_COMPR)>0 AND LEN(FCIE.MONEDA)>0  and ISNULL(FCIE.ESTADO_OPAGO,'') <>'X'                                                                            
--   AND  FCIE.EMPRESA=@AS_EMPRESA                                                                            
--   ) AS S                                                                                
--   ON (S.PROVEEDOR = M.RUC) AND S.COD_SUNAT=M.DTIPDOC  AND                                                                                                
--   SUBSTRING(S.NUM_COMPR,1,(CHARINDEX('-',S.NUM_COMPR)-1))=M.SERIE AND SUBSTRING(S.NUM_COMPR,(CHARINDEX('-',S.NUM_COMPR)+1),10)=M.NUMERO --AND S.EMPRESA=M.E                                                                                    
*************/                                                                                                         
                      
LEFT JOIN (SELECT TB.COD_DETRA, CT.TDESCRI, TB.PROVEEDOR, TB.TIPO_COMPR, TB.FACTURA, CT2.TPO_DOC, TB.ESTADO, TB.USER_PROVI, TB.DETALLE                                                         
           FROM enproyecdb.dbo.TB_PROVI_CAB TB with (nolock)                                                                                                                                 
     LEFT JOIN rsconcar..CT0032TAGE CT with (nolock) ON (CT.TCLAVE=TB.COD_DETRA) AND  CT.TCOD='28'                                                                            
  INNER JOIN (SELECT TCLAVE, TDESCRI, RIGHT(TDESCRI,2) TPO_DOC FROM rsconcar..CT0032TAGE with (nolock) WHERE TCOD='06') CT2 ON (CT2.TCLAVE = TB.TIPO_COMPR)                                                                                                    
  
                     
     WHERE CHARINDEX('-',TB.FACTURA)> 0 /*AND CT.TCOD='28'*/ AND ISNULL(TB.ESTADO,'')<>'X' AND TB.TIPO='E' AND TB.EMPRESA=@AS_EMPRESA ) AS Q                                                                  
     ON (LTRIM(RTRIM(Q.PROVEEDOR))= LTRIM(RTRIM(M.RUC))) AND                                                            
     Q.TPO_DOC= M.DTIPDOC AND  /*SI SERIE DE FT ES NUMERICA VALIDAR SIN LOS CEROS */                                                                                                                                
   IIF( ISNUMERIC( SUBSTRING(Q.FACTURA,1, CHARINDEX('-',Q.FACTURA)-1 ))=1 ,CONVERT(CHAR(4),CONVERT(NUMERIC(4),SUBSTRING(Q.FACTURA,1, CHARINDEX('-',Q.FACTURA)-1 ))), SUBSTRING(Q.FACTURA,1, CHARINDEX('-',Q.FACTURA)-1 )     )                       
  =IIF(ISNUMERIC(M.SERIE)=1,CONVERT(CHAR(4),CONVERT(NUMERIC(12),M.SERIE)),M.SERIE)--M.SERIE                                                                                                                                 
  AND SUBSTRING(Q.FACTURA,(CHARINDEX('-',Q.FACTURA)+1),10)=M.NUMERO                                                                     
                                                                                                                                      
/**acv                      
--LEFT JOIN (SELECT DISTINCT(B.COD_DETR), B.PROVEEDOR, A.NUM_COMPR, A.CUENTA,                                                                              
-- ROW_NUMBER() OVER (PARTITION BY B.PROVEEDOR, A.NUM_COMPR ORDER BY B.PROVEEDOR DESC) AS Fila, X.TDESCRI, B.GENERADOR, B.GLOSA                                                                                                   
-- FROM  enproyecdb.dbo.OPAGO_DETALLES A with (nolock)  ----distinct(B.COD_DETR)                                                        
-- INNER JOIN enproyecdb.dbo.OPAGO B with (nolock) ON (B.NRO_OP = A.NRO_OP)                             
-- INNER JOIN (SELECT TCLAVE, TDESCRI FROM rsconcar..CT0032TAGE with (nolock) WHERE TCOD='28') X ON (X.TCLAVE=B.COD_DETR)                                                                                     
--WHERE A.EMPRESA=@AS_EMPRESA  AND CHARINDEX('-',A.NUM_COMPR)>0 AND B.ESTADO='S' AND B.COD_DETR IS NOT NULL          
-- AND A.CUENTA IN (@DETRATER, @DETRAVINUS,@DETRAVINMN)) AS E                                                                                                                                                         
-- ON (E.PROVEEDOR=M.RUC) AND SUBSTRING(E.NUM_COMPR,1,(CHARINDEX('-',E.NUM_COMPR)-1))=M.SERIE                                                                                                                       
-- and SUBSTRING(E.NUM_COMPR,(CHARINDEX('-',E.NUM_COMPR)+1),10)=M.NUMERO                                                                                        
-- AND E.FILA=1                                                                                                                   
*****/                                                                                    
order by  M.PERIODO DESC, 1,2 

SELECT '2', GETDATE();