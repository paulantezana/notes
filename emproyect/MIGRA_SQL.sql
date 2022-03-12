USE [BD_GRUPOVALOR_DESA]
GO
    /****** Object:  StoredProcedure [dbo].[MIGRAMOVI]    Script Date: 25/01/2022 6:36:24 ******/
SET
    ANSI_NULLS ON
GO
SET
    QUOTED_IDENTIFIER ON
GO
    ----exec MIGRAmovi '0004',3                      
    ALTER PROCEDURE [dbo].[MIGRAMOVI] @empresaMig varchar(4),
    @idModulo int,
    @fechamigra varchar(8) AS --@IdModulo :  1=CT, 2=CxP , 3=CxC , 4=PAGOS , 5=COBROS            
    --  declare @fechamigra varchar(8)='20213009', Contable='20210101'                      
    BEGIN -- drop table #asientos_det          
    --DECLARE @empresaMig varchar(4)='0002' ,@idModulo int=2 , @fechamigra varchar(8)='20210930'              
    DECLARE @EMPRESA VARCHAR(4),
    @PROVEEDOR VARCHAR(11),
    @TIPO_COMPR VARCHAR(3),
    @NUM_COMPR VARCHAR(20),
    @CUENTA VARCHAR(15),
    @DOLAR NUMERIC(12, 2),
    @SOLES NUMERIC(12, 2),
    @MONEDA CHAR(2),
    @ITEM NUMERIC(12),
    @Id int,
    @IdTransa INT,
    @FECHADOC DATETIME,
    @FECHACOM DATETIME,
    @FECHATCAM DATETIME,
    @fvencimiento datetime DECLARE @DSUBDIA varchar(2),
    @DCOMPRO VARCHAR(6),
    @FECHA_CONTAB datetime,
    @DCOMPRO_ESTIMA VARCHAR(10),
    @DCOMPRO_EXT VARCHAR(10),
    @FECHA_DOC datetime DECLARE @MONEDAORIG CHAR(2),
    @PERIODOCONTAB DATETIME,
    @FLG_DETRA CHAR(1),
    @FLG_RETEN CHAR(1),
    @OPERACION CHAR(3),
    @TIPO CHAR(3),
    @ORDEN VARCHAR(15),
    @DETALLE VARCHAR(200) DECLARE @TIPOBIEN VARCHAR(2),
    @idarticulo int,
    @cantidad numeric(12, 2),
    @precio_u numeric(12, 2),
    @valorNeto numeric(12, 2),
    @igv numeric(12, 2),
    @total numeric(12, 2),
    @unidad VARCHAR(12) DECLARE @PunitBase NUMERIC(12, 2),
    @TotalMonedaBase NUMERIC(12, 2),
    @DH CHAR(1),
    @ImpuestoMonedaBase NUMERIC(12, 2),
    @Descripcion VARCHAR(200),
    @IdTipoTransaccionSistema INT DECLARE @IdDimensionBase INT,
    @IdDimensionOperativa INT,
    /*@idModulo int,*/
    @estadoLote int = 1,
    @usuario varchar(10) = 'ADMIN',
    @validado varchar(100),
    @ABREVIADO VARCHAR(10) DECLARE @periodo varchar(4),
    @mes char(2),
    @fechacorte datetime
    /*PARA OBTENER MENSAJE EN VALIDACIONPREPROCCES*/
    DECLARE @MENSAJE TABLE (MENSAJE VARCHAR(100))
SELECT
    @PERIODO = SUBSTRING(@fechamigra, 1, 4),
    @MES = SUBSTRING(@fechamigra, 5, 2),
    @fechacorte = convert(datetime, @fechamigra, 103)
SELECT
    @ABREVIADO = abreviado
FROM
    [PRODUCCION].ENPROYECDB.DBO.EMPRESAS
WHERE
    IND_EMPRESA_GRUPO = 1
    AND EMPRESA = @empresaMig
select
    * into #asientos_det From [PRODUCCION].ENPROYECDB.DBO.ASIENTOS_DET A (nolock) where A.PERIODO_DET=@periodo AND  A.DCODARC !='AT' AND  A.empresa=@empresaMig          
    and left(a.dcompro, 2) <= @MES
    and (
        (
            a.dSUBDIA not IN ('00')
            and @idModulo = 1
        )
        or (
            @idModulo != 1
            and 1 = 1
        )
    )
select
    * into #empresas from  [PRODUCCION].ENPROYECDB.DBO.EMPRESAS      
    /*Eliminar Tabla Temporal*/
    DELETE [PRODUCCION].ENPROYECDB.DBO.SALDOXCOBRAR
    /*inserta Tabla Base*/
    If @idModulo = 1
    /*CTB*/
    Begin
    /*Separar asientos de Detraccion*/
Select
    h.empresa,
    h.PERIODO_DET,
    h.dsubdia,
    h.dcompro,
    h.DSECUE Into #detracciones          
From
    #asientos_det h          
where
    h.PERIODO_DET = @periodo
    and h.empresa = @empresaMig
    and h.dsubdia in ('11', '16')
    and h.dcuenta = '421220'
    and LEFT(H.DCOMPRO, 2) <= @mes
union
all
Select
    d.empresa,
    d.PERIODO_DET,
    d.dsubdia,
    d.dcompro,
    D.DSECUE
From
    #asientos_det h          
    inner join #asientos_det d on  h.empresa=d.empresa and d.ddh <> h.ddh and  h.dcodane=d.DCODANE and h.DIMPORT=d.DIMPORT and h.dsubdia=d.dsubdia and h.dcompro=d.dcompro          
where
    h.PERIODO_DET = @periodo
    and h.empresa = @empresaMig
    and h.dsubdia in ('11', '16')
    and h.dcuenta = '421220'
    and LEFT(H.DCOMPRO, 2) <= @mes
order by
    3,
    4,
    5
    /***********/
    --Select h.empresa,h.PERIODO_DET,h.dsubdia,h.dcompro,h.DSECUE ,ddh          
    --From #asientos_det h          
    --where h.PERIODO_DET='2021' and h.empresa='0001' and h.dsubdia in ('11','16') and h.dcuenta='421220'  and  LEFT(H.DCOMPRO,2)<='09' and h.DSUBDIA='11' and h.DCOMPRO='090068'  
    --Select d.empresa,d.PERIODO_DET,d.dsubdia,d.dcompro,D.DSECUE ,d.ddh   
    --From #asientos_det h          
    --inner join #asientos_det d on  h.empresa=d.empresa and d.ddh <>h.ddh/*case when h.DTIPDOC='NA' then 'H' else 'D' End */ and  h.dcodane=d.DCODANE and h.DIMPORT=d.DIMPORT and h.dsubdia=d.dsubdia and h.dcompro=d.dcompro          
    --where h.PERIODO_DET='2021' and h.empresa='0001' and h.dsubdia in ('11','16') and h.dcuenta='421220'   and  LEFT(H.DCOMPRO,2)<='09' and h.DSUBDIA='11' and h.DCOMPRO='090068'      
    --select * from #detracciones where DSUBDIA='11' and dcompro='090068'  
    /**********/
    /*OBTENER LOS REGISTROS CON DIFERENCIAS*/
select
    sum(a.DMNIMPOR * iif(a.ddh = 'H', 1, -1)) dif,
    a.dsubdia,
    a.dcompro INTO #DIF    
from
    #detracciones d     
    inner join #asientos_det a on a.DSUBDIA=d.DSUBDIA and a.DCOMPRO=d.DCOMPRO and a.DSECUE=d.DSECUE    
group by
    a.dsubdia,
    a.dcompro
having
    sum(a.DMNIMPOR * iif(a.ddh = 'H', 1, -1)) <> 0
    /*ACTUALIZA LOS SOLES DESCUADRADOS DE DETRACCIONES*/
UPDATE
    A
SET
    DMNIMPOR = DMNIMPOR + B.DIF
FROM
    #asientos_det A    
    INNER JOIN #detracciones d  on a.DSUBDIA=d.DSUBDIA and a.DCOMPRO=d.DCOMPRO and a.DSECUE=d.DSECUE    
    INNER JOIN #DIF B ON A.DSUBDIA=B.DSUBDIA AND A.DCOMPRO=B.DCOMPRO     
WHERE
    DDH = 'D'
    /**/
INSERT
    [PRODUCCION].ENPROYECDB.DBO.SALDOXCOBRAR (
        EMPRESA,
        TIPO_COMPR,
        NUM_COMPR,
        PROVEEDOR,
        MONEDA,
        DOLAR,
        SOLES,
        FECHA,
        FECHA_CIERRE,
        FECHA_VENCE,
        FECHA_VENCIMIENTO,
        VALOR,
        IGV,
        TOTAL,
        c_c_operacion,
        CUENTA,
        IMPORTETRANSA,
        DDH,
        VALORSOLES,
        VALORDOLAR,
        IGVSOLES,
        IGVDOLAR,
        TIPOTRANSACCION,
        DSUBDIA,
        DCOMPRO,
        RUC_EMPRESA,
        COMPRA,
        VENTA,
        TDOC_SUNAT,
        DCENCOS
    )
SELECT
    A.EMPRESA,
case
        when left(A.DCUENTA, 2) = '10' then 'VR'
        else A.DTIPDOC
    end,
case
        when left(A.DCUENTA, 2) = '10' then A.DCODANE
        else rtrim(A.DNUMDOC)
    end,
case
        when left(A.DCUENTA, 2) = '10'
        AND ISNULL(
            (
                case
                    A.DCODANE
                    when 'SCOTIABANK ME' then '09'
                    when '104132' then '03'
                    when '104131' then '03'
                    when '104102' then '02'
                    when 'BCO CREDITO ME' then '02'
                    when 'BCO. CREDITO M.E.' then '02'
                    when 'BACP ME 1' then '02'
                    when 'BCP MN 1' then '02'
                    when 'BCO CREDITO MN' then '02'
                    when 'BCO CREDITO MN - P' then '02'
                    when 'BCO CREDITO PROV' then '02'
                    when 'BCO. CREDITO M.N.' then '02'
                    when '104101' then '02'
                    when 'BCP PROV MN' then '02'
                    when 'BCO. DE LA NACION' then '18'
                    when '0000-5107458' then '18'
                    when 'BNP' then '18'
                    when 'BANCO NACION' then '18'
                    when '20100053455' then '03'
                    else b.CT_CENTFIN
                end
            ),
            ''
        ) != '' then ENFI.IdEntidadFinanciera collate Modern_Spanish_CI_AS
        else A.DCODANE
    end DCODANE,
    A.DCODMON,
    A.DUSIMPOR,
    A.DMNIMPOR,
    A.DFECCOM2 FECHACOMPRO,
    CONVERT(DATETIME, a.DFECDOC, 103) FECHAEMISION,
    A.DFECDOC2,
    a.DFECDOC2 FECHA_VENCIMIENTO,
    0.00 PAGO_NETO,
    0.00 IGV,
    0.00 PAGO_TOTAL,
    ' ' C_C_OPERACION,
    A.DCUENTA,
    CASE
        WHEN A.DCODMON = 'MN' THEN A.DMNIMPOR
        ELSE A.DUSIMPOR
    END IMPORTETRANSA,
    A.DDH,
    A.DMNIMPOR VALORSOLES,
    A.DUSIMPOR VALORDOLAR,
    0.00 IGVSOLES,
    0.00 IGVDOLAR,
    CASE
        a.DTIPDOC
        WHEN 'FT' THEN 1
        WHEN 'NA' THEN 2
        WHEN 'ND' THEN 3
        Else 1
    END TIPOTRANSACCION,
    A.DSUBDIA,
    A.DCOMPRO,
    E.RUC,
    V.COMPRA,
    V.VENTA,
    IIF(
        ISNUMERIC(RIGHT(RTRIM(T.TDESCRI), 2)) = 1,
        CONVERT(VARCHAR(2), RIGHT(RTRIM(T.TDESCRI), 2)),
        '00'
    ) TDOC_SUNAT --, AP.ID            
,
    A.DCENCOS
FROM
    #asientos_det A (NOLOCK)  --WHERE PERIODO_DET='2021' AND EMPRESA='0004'                
    -- INNER JOIN [PRODUCCION].ENPROYECDB.DBO.ASIENTOS_CAB D ON D.EMPRESA=A.EMPRESA AND D.PERIODO=A.PERIODO_DET AND A.DSUBDIA=D.CSUBDIA AND A.DCOMPRO=D.CCOMPRO            
    LEFT JOIN RSCONCAR..CP0032CUBA B (NOLOCK) ON B.CT_CNUMCTA = A.DCODANE
    LEFT JOIN sunat.t03entidadfinanciera ENFI (NOLOCK) on ENFI.codigo = (
        case
            A.DCODANE
            when 'SCOTIABANK ME' then '09'
            when '104132' then '03'
            when '104131' then '03'
            when '104102' then '02'
            when 'BCO CREDITO ME' then '02'
            when 'BCO. CREDITO M.E.' then '02'
            when 'BACP ME 1' then '02'
            when 'BCP MN 1' then '02'
            when 'BCO CREDITO MN' then '02'
            when 'BCO CREDITO MN - P' then '02'
            when 'BCO CREDITO PROV' then '02'
            when 'BCO. CREDITO M.N.' then '02'
            when '104101' then '02'
            when 'BCP PROV MN' then '02'
            when 'BCO. DE LA NACION' then '18'
            when '0000-5107458' then '18'
            when 'BNP' then '18'
            when 'BANCO NACION' then '18'
            when '20100053455' then '03'
            else b.CT_CENTFIN
        end
    ) collate Modern_Spanish_CI_AS
    INNER JOIN [PRODUCCION].ENPROYECDB.DBO.EMPRESAS E (NOLOCK) ON E.EMPRESA = A.EMPRESA --LEFT JOIN [PRODUCCION].ENPROYECDB.DBO.PUB_PERSONAS Px (NOLOCK) ON P.IDPERSONA=A.DCODANE                      
    LEFT JOIN [PRODUCCION].ENPROYECDB.DBO.VIEW_TCAMBIO V (NOLOCK) ON V.XCODMON = 'US'
    AND V.XFECCAM2 = A.DFECCOM2
    LEFT JOIN [PRODUCCION].RSCONCAR.DBO.CT0032TAGE T (NOLOCK) ON T.TCOD = '06'
    AND T.TCLAVE =case
        when left(A.DCUENTA, 2) = '10' then 'VR'
        else A.DTIPDOC
    end
WHERE
    A.PERIODO_DET = @periodo
    AND LEFT(A.DCOMPRO, 2) <= @mes
    AND A.DCODARC != 'AT'
    AND A.empresa = @empresaMig
    and a.dSUBDIA NOT IN ('00', '11', '16') --  Order by A.dcodane,A.dtipdoc,A.dnumdoc                
union
all
SELECT
    A.EMPRESA,
case
        when left(A.DCUENTA, 2) = '10' then 'VR'
        else A.DTIPDOC
    end,
case
        when left(A.DCUENTA, 2) = '10' then A.DCODANE
        else rtrim(A.DNUMDOC)
    end,
case
        when left(A.DCUENTA, 2) = '10'
        AND ISNULL(
            (
                case
                    A.DCODANE
                    when 'SCOTIABANK ME' then '09'
                    when '104132' then '03'
                    when '104131' then '03'
                    when '104102' then '02'
                    when 'BCO CREDITO ME' then '02'
                    when 'BCO. CREDITO M.E.' then '02'
                    when 'BACP ME 1' then '02'
                    when 'BCP MN 1' then '02'
                    when 'BCO CREDITO MN' then '02'
                    when 'BCO CREDITO MN - P' then '02'
                    when 'BCO CREDITO PROV' then '02'
                    when 'BCO. CREDITO M.N.' then '02'
                    when '104101' then '02'
                    when 'BCP PROV MN' then '02'
                    when 'BCO. DE LA NACION' then '18'
                    when '0000-5107458' then '18'
                    when 'BNP' then '18'
                    when 'BANCO NACION' then '18'
                    when '20100053455' then '03'
                    else b.CT_CENTFIN
                end
            ),
            ''
        ) != '' then ENFI.IdEntidadFinanciera collate Modern_Spanish_CI_AS
        else A.DCODANE
    end DCODANE,
    A.DCODMON,
    A.DUSIMPOR,
    A.DMNIMPOR,
    A.DFECCOM2 FECHACOMPRO,
    CONVERT(DATETIME, a.DFECDOC, 103) FECHAEMISION,
    a.DFECDOC2,
    a.DFECDOC2 FECHA_VENCIMIENTO,
    0.00 PAGO_NETO,
    0.00 IGV,
    0.00 PAGO_TOTAL,
    ' ' C_C_OPERACION,
    A.DCUENTA,
    CASE
        WHEN A.DCODMON = 'MN' THEN A.DMNIMPOR
        ELSE A.DUSIMPOR
    END IMPORTETRANSA,
    A.DDH,
    A.DMNIMPOR VALORSOLES,
    A.DUSIMPOR VALORDOLAR,
    0.00 IGVSOLES,
    0.00 IGVDOLAR,
    CASE
        a.DTIPDOC
        WHEN 'FT' THEN 1
        WHEN 'NA' THEN 2
        WHEN 'ND' THEN 3
        Else 1
    END TIPOTRANSACCION,
    A.DSUBDIA,
    A.DCOMPRO,
    E.RUC,
    V.COMPRA,
    V.VENTA,
    IIF(
        ISNUMERIC(RIGHT(RTRIM(T.TDESCRI), 2)) = 1,
        CONVERT(VARCHAR(2), RIGHT(RTRIM(T.TDESCRI), 2)),
        '00'
    ) TDOC_SUNAT --, AP.ID            
,
    A.DCENCOS
FROM
    #asientos_det A (NOLOCK)  --WHERE PERIODO_DET='2021' AND EMPRESA='0004'                
    -- INNER JOIN [PRODUCCION].ENPROYECDB.DBO.ASIENTOS_CAB D ON D.EMPRESA=A.EMPRESA AND D.PERIODO=A.PERIODO_DET AND A.DSUBDIA=D.CSUBDIA AND A.DCOMPRO=D.CCOMPRO            
    LEFT JOIN RSCONCAR..CP0032CUBA B (NOLOCK) ON B.CT_CNUMCTA = A.DCODANE
    LEFT JOIN sunat.t03entidadfinanciera ENFI (NOLOCK) on ENFI.codigo = (
        case
            A.DCODANE
            when 'SCOTIABANK ME' then '09'
            when '104132' then '03'
            when '104131' then '03'
            when '104102' then '02'
            when 'BCO CREDITO ME' then '02'
            when 'BCO. CREDITO M.E.' then '02'
            when 'BACP ME 1' then '02'
            when 'BCP MN 1' then '02'
            when 'BCO CREDITO MN' then '02'
            when 'BCO CREDITO MN - P' then '02'
            when 'BCO CREDITO PROV' then '02'
            when 'BCO. CREDITO M.N.' then '02'
            when '104101' then '02'
            when 'BCP PROV MN' then '02'
            when 'BCO. DE LA NACION' then '18'
            when '0000-5107458' then '18'
            when 'BNP' then '18'
            when 'BANCO NACION' then '18'
            when '20100053455' then '03'
            else b.CT_CENTFIN
        end
    ) collate Modern_Spanish_CI_AS
    INNER JOIN [PRODUCCION].ENPROYECDB.DBO.EMPRESAS E (NOLOCK) ON E.EMPRESA = A.EMPRESA
    LEFT JOIN [PRODUCCION].ENPROYECDB.DBO.VIEW_TCAMBIO V (NOLOCK) ON V.XCODMON = 'US'
    AND V.XFECCAM2 = A.DFECCOM2
    LEFT JOIN [PRODUCCION].RSCONCAR.DBO.CT0032TAGE T (NOLOCK) ON T.TCOD = '06'
    AND T.TCLAVE =case
        when left(A.DCUENTA, 2) = '10' then 'VR'
        else A.DTIPDOC
    end
    LEFT JOIN #detracciones DT ON DT.EMPRESA=A.EMPRESA AND DT.PERIODO_DET=A.PERIODO_DET AND DT.DSUBDIA=A.DSUBDIA AND DT.DCOMPRO=A.DCOMPRO AND DT.DSECUE=A.DSECUE          
WHERE
    A.PERIODO_DET = @periodo
    AND LEFT(A.DCOMPRO, 2) <= @mes
    AND A.DCODARC != 'AT'
    AND A.empresa = @empresaMig
    and a.dSUBDIA IN ('11', '16')
    AND DT.DCOMPRO IS NULL
UNION
ALL
SELECT
    A.EMPRESA,
case
        when left(A.DCUENTA, 2) = '10' then 'VR'
        else A.DTIPDOC
    end,
case
        when left(A.DCUENTA, 2) = '10' then A.DCODANE
        else rtrim(A.DNUMDOC)
    end,
case
        when left(A.DCUENTA, 2) = '10'
        AND ISNULL(
            (
                case
                    A.DCODANE
                    when 'SCOTIABANK ME' then '09'
                    when '104132' then '03'
                    when '104131' then '03'
                    when '104102' then '02'
                    when 'BCO CREDITO ME' then '02'
                    when 'BCO. CREDITO M.E.' then '02'
                    when 'BACP ME 1' then '02'
                    when 'BCP MN 1' then '02'
                    when 'BCO CREDITO MN' then '02'
                    when 'BCO CREDITO MN - P' then '02'
                    when 'BCO CREDITO PROV' then '02'
                    when 'BCO. CREDITO M.N.' then '02'
                    when '104101' then '02'
                    when 'BCP PROV MN' then '02'
                    when 'BCO. DE LA NACION' then '18'
                    when '0000-5107458' then '18'
                    when 'BNP' then '18'
                    when 'BANCO NACION' then '18'
                    when '20100053455' then '03'
                    else b.CT_CENTFIN
                end
            ),
            ''
        ) != '' then ENFI.IdEntidadFinanciera collate Modern_Spanish_CI_AS
        else A.DCODANE
    end DCODANE,
    'MN' MONEDA,
    A.DUSIMPOR,
    A.DMNIMPOR,
    A.DFECCOM2 FECHACOMPRO,
    CONVERT(DATETIME, a.DFECDOC, 103) FECHAEMISION,
    A.DFECDOC2,
    a.DFECDOC2 FECHA_VENCIMIENTO,
    0.00 PAGO_NETO,
    0.00 IGV,
    0.00 PAGO_TOTAL,
    ' ' C_C_OPERACION,
    A.DCUENTA,
    A.DMNIMPOR IMPORTETRANSA,
    A.DDH,
    A.DMNIMPOR VALORSOLES,
    A.DUSIMPOR VALORDOLAR,
    0.00 IGVSOLES,
    0.00 IGVDOLAR,
    CASE
        a.DTIPDOC
        WHEN 'FT' THEN 1
        WHEN 'NA' THEN 2
        WHEN 'ND' THEN 3
        Else 1
    END TIPOTRANSACCION,
    A.DSUBDIA,
    A.DCOMPRO + 'D',
    E.RUC,
    V.COMPRA,
    V.VENTA,
    IIF(
        ISNUMERIC(RIGHT(RTRIM(T.TDESCRI), 2)) = 1,
        CONVERT(VARCHAR(2), RIGHT(RTRIM(T.TDESCRI), 2)),
        '00'
    ) TDOC_SUNAT --, AP.ID            
,
    A.DCENCOS
FROM
    #asientos_det A (NOLOCK)  --WHERE PERIODO_DET='2021' AND EMPRESA='0004'                
    -- INNER JOIN [PRODUCCION].ENPROYECDB.DBO.ASIENTOS_CAB D ON D.EMPRESA=A.EMPRESA AND D.PERIODO=A.PERIODO_DET AND A.DSUBDIA=D.CSUBDIA AND A.DCOMPRO=D.CCOMPRO            
    LEFT JOIN RSCONCAR..CP0032CUBA B (NOLOCK) ON B.CT_CNUMCTA = A.DCODANE
    LEFT JOIN sunat.t03entidadfinanciera ENFI (NOLOCK) on ENFI.codigo = (
        case
            A.DCODANE
            when 'SCOTIABANK ME' then '09'
            when '104132' then '03'
            when '104131' then '03'
            when '104102' then '02'
            when 'BCO CREDITO ME' then '02'
            when 'BCO. CREDITO M.E.' then '02'
            when 'BACP ME 1' then '02'
            when 'BCP MN 1' then '02'
            when 'BCO CREDITO MN' then '02'
            when 'BCO CREDITO MN - P' then '02'
            when 'BCO CREDITO PROV' then '02'
            when 'BCO. CREDITO M.N.' then '02'
            when '104101' then '02'
            when 'BCP PROV MN' then '02'
            when 'BCO. DE LA NACION' then '18'
            when '0000-5107458' then '18'
            when 'BNP' then '18'
            when 'BANCO NACION' then '18'
            when '20100053455' then '03'
            else b.CT_CENTFIN
        end
    ) collate Modern_Spanish_CI_AS
    INNER JOIN [PRODUCCION].ENPROYECDB.DBO.EMPRESAS E (NOLOCK) ON E.EMPRESA = A.EMPRESA
    LEFT JOIN [PRODUCCION].ENPROYECDB.DBO.VIEW_TCAMBIO V (NOLOCK) ON V.XCODMON = 'US'
    AND V.XFECCAM2 = A.DFECCOM2
    LEFT JOIN [PRODUCCION].RSCONCAR.DBO.CT0032TAGE T (NOLOCK) ON T.TCOD = '06'
    AND T.TCLAVE =case
        when left(A.DCUENTA, 2) = '10' then 'VR'
        else A.DTIPDOC
    end
    LEFT JOIN #detracciones DT ON DT.EMPRESA=A.EMPRESA AND DT.PERIODO_DET=A.PERIODO_DET AND DT.DSUBDIA=A.DSUBDIA AND DT.DCOMPRO=A.DCOMPRO AND DT.DSECUE=A.DSECUE          
WHERE
    A.PERIODO_DET = @periodo
    AND LEFT(A.DCOMPRO, 2) <= @mes
    AND A.DCODARC != 'AT'
    AND A.empresa = @empresaMig
    and a.dSUBDIA IN ('11', '16')
    AND DT.DCOMPRO IS NOT NULL
Order by
    4,
    2,
    3 --A.dcodane,A.dtipdoc,A.dnumdoc                
    print '[PRODUCCION].ENPROYECDB.DBO.SALDOXCOBRAR'
End If @idModulo = 2
/*CxP*/
Begin
INSERT
    [PRODUCCION].ENPROYECDB.DBO.SALDOXCOBRAR (
        EMPRESA,
        TIPO_COMPR,
        NUM_COMPR,
        PROVEEDOR,
        MONEDA,
        DOLAR,
        SOLES,
        FECHA,
        FECHA_CIERRE,
        FECHA_VENCE,
        FECHA_VENCIMIENTO,
        VALOR,
        IGV,
        TOTAL,
        c_c_operacion,
        CUENTA,
        IMPORTETRANSA,
        DDH,
        VALORSOLES,
        VALORDOLAR,
        IGVSOLES,
        IGVDOLAR,
        TIPOTRANSACCION,
        DSUBDIA,
        DCOMPRO,
        RUC_EMPRESA,
        COMPRA,
        VENTA,
        TDOC_SUNAT,
        DCENCOS,
        TIPO_COMPR_ORIG,
        NUM_COMPR_ORIG
    )
SELECT
    K.EMPRESA,
    K.DTIPDOC,
    rtrim(K.DNUMDOC),
    K.DCODANE,
    MONEDA,
    ABS(DOLARES),
    ABS(SOLES),
    @fechacorte,
    FECHA,
    @fechacorte,
    @fechacorte,
    0.00 VALOR,
    0.00 IGV,
    ABS(
        CASE
            WHEN MONEDA = 'MN' THEN SOLES
            ELSE DOLARES
        END
    ) TOTAL,
    '020' C_C_OPERACION,
    DCUENTA,
    ABS(
        CASE
            WHEN MONEDA = 'MN' THEN SOLES
            ELSE DOLARES
        END
    ) IMPORTETRANSA,
    IIF(IIF(MONEDA = 'MN', SOLES, DOLARES) < 0, 'H', 'D') DDH,
    0.00 VALORSOLES,
    0.00 VALORDOLAR,
    0.00 IGVSOLES,
    0.00 IGVDOLAR,
    CASE
        K.DTIPDOC
        WHEN 'FT' THEN 1
        WHEN 'NA' THEN 2
        WHEN 'ND' THEN 3
        Else 1
    END TIPOTRANSACCION,
    '11' DSUBDIA,
    '' DCOMPRO,
    RUC_EMPRESA,
    V.COMPRA,
    V.VENTA,
    IIF(
        ISNUMERIC(RIGHT(RTRIM(T.TDESCRI), 2)) = 1,
        CONVERT(VARCHAR(2), RIGHT(RTRIM(T.TDESCRI), 2)),
        '00'
    ) TDOC_SUNAT,
    DCENCOS,
    R.DF_CTIPDOC TIPODOC_ORIG,
    R.DF_CNUMDOC NRODOC_ORIG
FROM
    (
        SELECT
            M.EMPRESA,
            DCUENTA,
            C.PMONREF MONEDA,
            DCODANE,
            DTIPDOC,
            DNUMDOC,
            SUM(DUSIMPOR * IIF(DDH = 'D', 1, -1)) DOLARES,
            SUM(DMNIMPOR * IIF(DDH = 'D', 1, -1)) SOLES,
            MAX(M.DFECDOC2) FECHA,
            E.RUC RUC_EMPRESA,
            M.DCENCOS
        FROM
            #asientos_det M (NOLOCK)          
            INNER JOIN [PRODUCCION].RSCONCAR.DBO.CT0032PLEM C (NOLOCK) ON C.PCUENTA = M.DCUENTA
            INNER JOIN [PRODUCCION].ENPROYECDB.DBO.EMPRESAS E (NOLOCK) ON E.EMPRESA = M.EMPRESA
        WHERE
            PERIODO_DET = @periodo
            AND M.EMPRESA = @empresaMig
            AND LEFT(DCOMPRO, 2) <= @mes
            AND LEFT(DCUENTA, 2) IN ('42', '43')
            AND LEFT(DCUENTA, 4) NOT IN ('4211', '4311')
            AND LEFT(DCUENTA, 3) NOT IN ('422', '423', '432', '433')
        GROUP BY
            M.EMPRESA,
            E.RUC,
            DCUENTA,
            C.PMONREF,
            DCODANE,
            DTIPDOC,
            DNUMDOC,
            M.DCENCOS
    ) K
    LEFT JOIN [PRODUCCION].ENPROYECDB.DBO.VIEW_TCAMBIO V (NOLOCK) ON V.XCODMON = 'US'
    AND V.XFECCAM2 = K.FECHA
    LEFT JOIN [PRODUCCION].RSCONCAR.DBO.CT0032TAGE T (NOLOCK) ON T.TCOD = '06'
    AND T.TCLAVE = K.DTIPDOC
    LEFT JOIN [PRODUCCION].ENPROYECDB.DBO.NOTASFTORIG R (NOLOCK) ON R.EMPRESA = K.EMPRESA
    AND R.DCODANE = K.DCODANE
    AND R.DTIPDOC = K.DTIPDOC
    AND R.DNUMDOC = K.DNUMDOC
WHERE
    CASE
        WHEN MONEDA = 'MN' THEN SOLES
        ELSE DOLARES
    END <> 0
End If @idModulo = 3
/*CxC*/
Begin
INSERT
    [PRODUCCION].ENPROYECDB.DBO.SALDOXCOBRAR (
        EMPRESA,
        TIPO_COMPR,
        NUM_COMPR,
        PROVEEDOR,
        MONEDA,
        DOLAR,
        SOLES,
        FECHA,
        FECHA_CIERRE,
        FECHA_VENCE,
        FECHA_VENCIMIENTO,
        VALOR,
        IGV,
        TOTAL,
        c_c_operacion,
        CUENTA,
        IMPORTETRANSA,
        DDH,
        VALORSOLES,
        VALORDOLAR,
        IGVSOLES,
        IGVDOLAR,
        TIPOTRANSACCION,
        DSUBDIA,
        DCOMPRO,
        RUC_EMPRESA,
        COMPRA,
        VENTA,
        TDOC_SUNAT,
        DCENCOS,
        TIPO_COMPR_ORIG,
        NUM_COMPR_ORIG
    )
SELECT
    K.EMPRESA,
    K.DTIPDOC,
    rtrim(K.DNUMDOC),
    K.DCODANE,
    MONEDA,
    ABS(DOLARES),
    ABS(SOLES),
    @fechacorte,
    FECHA,
    @fechacorte,
    @fechacorte,
    0.00 VALOR,
    0.00 IGV,
    ABS(
        CASE
            WHEN MONEDA = 'MN' THEN SOLES
            ELSE DOLARES
        END
    ) TOTAL,
    '048' C_C_OPERACION,
    DCUENTA,
    ABS(
        CASE
            WHEN MONEDA = 'MN' THEN SOLES
            ELSE DOLARES
        END
    ) IMPORTETRANSA,
    IIF(IIF(MONEDA = 'MN', SOLES, DOLARES) < 0, 'D', 'H') DDH,
    0.00 VALORSOLES,
    0.00 VALORDOLAR,
    0.00 IGVSOLES,
    0.00 IGVDOLAR,
    CASE
        K.DTIPDOC
        WHEN 'FT' THEN 1
        WHEN 'NA' THEN 2
        WHEN 'ND' THEN 3
        Else 1
    END TIPOTRANSACCION,
    '05' DSUBDIA,
    '' DCOMPRO,
    RUC_EMPRESA,
    V.COMPRA,
    V.VENTA,
    IIF(
        ISNUMERIC(RIGHT(RTRIM(T.TDESCRI), 2)) = 1,
        CONVERT(VARCHAR(2), RIGHT(RTRIM(T.TDESCRI), 2)),
        '00'
    ) TDOC_SUNAT,
    DCENCOS,
    R.DF_CTIPDOC TIPODOC_ORIG,
    R.DF_CNUMDOC NRODOC_ORIG
FROM
    (
        SELECT
            M.EMPRESA,
            DCUENTA,
            C.PMONREF MONEDA,
            DCODANE,
            DTIPDOC,
            DNUMDOC,
            SUM(DUSIMPOR * IIF(DDH = 'D', 1, -1)) DOLARES,
            SUM(DMNIMPOR * IIF(DDH = 'D', 1, -1)) SOLES,
            MAX(M.DFECDOC2) FECHA,
            E.RUC RUC_EMPRESA,
            M.DCENCOS
        FROM
            #asientos_det M (NOLOCK)          
            INNER JOIN [PRODUCCION].RSCONCAR.DBO.CT0032PLEM C (NOLOCK) ON C.PCUENTA = M.DCUENTA
            INNER JOIN [PRODUCCION].ENPROYECDB.DBO.EMPRESAS E (NOLOCK) ON E.EMPRESA = M.EMPRESA
        WHERE
            PERIODO_DET = @periodo
            AND M.EMPRESA = @empresaMig
            AND LEFT(DCOMPRO, 2) <= @mes
            AND LEFT(DCUENTA, 2) IN ('12', '13')
            AND LEFT(DCUENTA, 4) NOT IN ('1211', '1311')
            AND LEFT(DCUENTA, 3) NOT IN ('129', '139', '149', '123', '133')
        GROUP BY
            M.EMPRESA,
            E.RUC,
            DCUENTA,
            C.PMONREF,
            DCODANE,
            DTIPDOC,
            DNUMDOC,
            M.DCENCOS
    ) K
    LEFT JOIN [PRODUCCION].ENPROYECDB.DBO.VIEW_TCAMBIO V (NOLOCK) ON V.XCODMON = 'US'
    AND V.XFECCAM2 = K.FECHA
    LEFT JOIN [PRODUCCION].RSCONCAR.DBO.CT0032TAGE T (NOLOCK) ON T.TCOD = '06'
    AND T.TCLAVE = K.DTIPDOC
    LEFT JOIN [PRODUCCION].ENPROYECDB.DBO.NOTASFTORIG R (NOLOCK) ON R.EMPRESA = K.EMPRESA
    AND R.DCODANE = K.DCODANE
    AND R.DTIPDOC = K.DTIPDOC
    AND R.DNUMDOC = K.DNUMDOC
WHERE
    CASE
        WHEN MONEDA = 'MN' THEN SOLES
        ELSE DOLARES
    END <> 0
End
select
    * into #saldo from  [PRODUCCION].ENPROYECDB.DBO.SALDOXCOBRAR      
    /*Actualiza el periodo Contable para comparar con el LOTE (dcompro+periodo)*/
update
    E
set
    idperiodo = ap.id
FROM
    #saldo E (NOLOCK)            
    INNER JOIN Maestros.EntidadCompania Ec (NOLOCK) ON Ec.IDENTIDAD = E.RUC_EMPRESA COLLATE SQL_Latin1_General_CP1_CI_AS --48761            
    INNER JOIN FINANCIERO.Anio An (NOLOCK) ON AN.IdCompania = eC.ID
    AND @fechamigra BETWEEN DESDE
    AND HASTA
    INNER JOIN FINANCIERO.AnioPeriodo Ap (NOLOCK) ON Ap.IdAnio = aN.ID
    AND AP.Codigo = right('00' + rtrim(convert(varchar(2), month(E.fecha))), 2)
Select
    *,
    convert(varchar(30), dsubdia + '-' + dcompro) collate SQL_Latin1_General_CP1_CI_AS campovalida into #SALDOXCOBRAR From #saldo--[PRODUCCION].ENPROYECDB.DBO.SALDOXCOBRAR            
    print 'pasaron los datos a migrar a temporal #'
    /**********/
    /*Maestros desde Pub_personas*/
Insert
    Maestros.Entidad(
        IdEntidad,
        IdTipoEntidad,
        NroFiscal,
        NombreRazonSocial,
        Domiciliado,
        Estado,
        IdClaseEntidad,
        UsuarioCreacion,
        FechaCreacion,
        FechaEdicion,
        IdPais,
        Direccion1,
        Direccion2,
        Ciudad,
        CodigoPostal,
        IdUbigeo,
        PaginaWeb,
        UsuarioEdicion
    )
Select
    ISNULL(E.IDPERSONA, P.IDPERSONA),
    Case
        tipodoc_ident
        When 'RUC' then 6
        when 'DNI' then 1
        when 'OTR' THEN '0'
    end,
    ISNULL(E.IDPERSONA, P.IDPERSONA) NroFiscal,
    P.RAZON_SOCIAL,
    'S' Domiciliado,
    'A' Estado,
    'A4P' IdClaseEntidad,
    @usuario,
    getdate() FechaCreacion,
    getdate() FechaEdicion,
    '002' IdPais,
    isnull(SUBSTRING(p.DIRECCION, 1, 80), '-') Direccion1,
    isnull(SUBSTRING(p.DOMICILIO_FISCAL, 1, 80), '-') Direccion2,
    '-',
    '-',
    '-',
    '-',
    @usuario
FROM
    [PRODUCCION].ENPROYECDB.DBO.PUB_PERSONAS P
    INNER JOIN (
        SELECT
            DISTINCT PROVEEDOR COLLATE SQL_Latin1_General_CP1_CI_AS PROVEEDOR
        From
            #SALDOXCOBRAR  M                       
        WHERE
            NOT EXISTS (
                SELECT
                    1
                FROM
                    Maestros.Entidad E
                WHERE
                    E.IdEntidad = M.PROVEEDOR COLLATE SQL_Latin1_General_CP1_CI_AS
            )
    ) K ON K.PROVEEDOR = P.IDPERSONA
    LEFT JOIN (
        SELECT
            IDPERSONAORIG,
            IDPERSONA
        FROM
            AnexosEquivalente
    ) E ON E.IDPERSONAORIG = P.IDPERSONA COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE
    NOT EXISTS (
        SELECT
            1
        FROM
            Maestros.Entidad G
        Where
            G.IdEntidad = ISNULL(E.IDPERSONA, P.IDPERSONA)
    )
    and len(k.proveedor) <= 12
    /*Inserta a tabla Equivalente de Entidad con mas de 12 caracteres*/
Insert
    Maestros.Entidad(
        IdEntidad,
        IdTipoEntidad,
        NroFiscal,
        NombreRazonSocial,
        Domiciliado,
        Estado,
        IdClaseEntidad,
        UsuarioCreacion,
        FechaCreacion,
        FechaEdicion,
        IdPais,
        Direccion1,
        Direccion2,
        Ciudad,
        CodigoPostal,
        IdUbigeo,
        PaginaWeb,
        UsuarioEdicion
    )
Select
    ISNULL(E.IDPERSONA, P.IDPERSONA),
    --substring(replace(k.proveedor,'-',''),1,12),            
    Case
        tipodoc_ident
        When 'RUC' then 6
        when 'DNI' then 1
        when 'OTR' THEN '0'
    end,
    substring(replace(k.proveedor, '-', ''), 1, 12) NroFiscal,
    P.RAZON_SOCIAL,
    'S' Domiciliado,
    'A' Estado,
    'A4P' IdClaseEntidad,
    @usuario,
    getdate() FechaCreacion,
    getdate() FechaEdicion,
    '002' IdPais,
    isnull(SUBSTRING(p.DIRECCION, 1, 80), '-') Direccion1,
    isnull(SUBSTRING(p.DOMICILIO_FISCAL, 1, 80), '-') Direccion2,
    '-',
    '-',
    '-',
    '-',
    @usuario
FROM
    [PRODUCCION].ENPROYECDB.DBO.PUB_PERSONAS P
    INNER JOIN (
        SELECT
            DISTINCT PROVEEDOR COLLATE SQL_Latin1_General_CP1_CI_AS PROVEEDOR
        From
            #SALDOXCOBRAR  M                       
        WHERE
            NOT EXISTS (
                SELECT
                    1
                FROM
                    Maestros.Entidad E
                WHERE
                    E.IdEntidad = M.PROVEEDOR COLLATE SQL_Latin1_General_CP1_CI_AS
            )
    ) K ON K.PROVEEDOR = P.IDPERSONA
    LEFT JOIN (
        SELECT
            IDPERSONAORIG,
            IDPERSONA
        FROM
            AnexosEquivalente
    ) E ON E.IDPERSONAORIG = P.IDPERSONA COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE
    NOT EXISTS (
        SELECT
            1
        FROM
            Maestros.Entidad G
        Where
            G.IdEntidad = ISNULL(E.IDPERSONA, P.IDPERSONA)
    )
    and len(k.proveedor) > 12
    /*ANEXOS*/
Insert
    Maestros.Entidad(
        IdEntidad,
        IdTipoEntidad,
        NroFiscal,
        NombreRazonSocial,
        Domiciliado,
        Estado,
        IdClaseEntidad,
        UsuarioCreacion,
        FechaCreacion,
        FechaEdicion,
        IdPais,
        Direccion1,
        Direccion2,
        Ciudad,
        CodigoPostal,
        IdUbigeo,
        PaginaWeb,
        UsuarioEdicion
    )
Select
    DISTINCT ISNULL(E.IDPERSONA, P.ANEXO),
case
        when ISNULL(ADOCIDE, '') = '' then 0
        else ADOCIDE
    end idTipoEntidad,
    ISNULL(E.IDPERSONA, P.ANEXO) NroFiscal,
    P.DESCRIPCION,
    'S' Domiciliado,
    'A' Estado,
    'A4P' IdClaseEntidad,
    @usuario,
    getdate() FechaCreacion,
    getdate() FechaEdicion,
    '002' IdPais,
    '-' Direccion1,
    '-' Direccion2,
    '-',
    '-',
    '-',
    '-',
    @usuario
FROM
    [PRODUCCION].ENPROYECDB.DBO.anexosMigra P
    INNER JOIN (
        SELECT
            DISTINCT PROVEEDOR COLLATE SQL_Latin1_General_CP1_CI_AS PROVEEDOR
        From
            #SALDOXCOBRAR  M    (NOLOCK)                
        WHERE
            NOT EXISTS (
                SELECT
                    1
                FROM
                    Maestros.Entidad E (NOLOCK)
                WHERE
                    E.IdEntidad = M.PROVEEDOR COLLATE SQL_Latin1_General_CP1_CI_AS
            )
    ) K ON K.PROVEEDOR = P.ANEXO
    LEFT JOIN (
        SELECT
            IDPERSONAORIG,
            IDPERSONA
        FROM
            AnexosEquivalente (NOLOCK)
    ) E ON E.IDPERSONAORIG = P.ANEXO COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE
    NOT EXISTS (
        SELECT
            1
        FROM
            Maestros.Entidad (NOLOCK)
        WHERE
            ISNULL(E.IDPERSONA, P.ANEXO) = Maestros.Entidad.IdEntidad
    )
    /*ENTIDAD NO EXISTE EN PB_PERSIONAS NI EN ANEXOS CONCAR*/
Insert
    Maestros.Entidad(
        IdEntidad,
        IdTipoEntidad,
        NroFiscal,
        NombreRazonSocial,
        Domiciliado,
        Estado,
        IdClaseEntidad,
        UsuarioCreacion,
        FechaCreacion,
        FechaEdicion,
        UsuarioEdicion,
        IdPais,
        Direccion1,
        Direccion2,
        Ciudad,
        CodigoPostal,
        IdUbigeo,
        PaginaWeb
    )
SELECT
    PROVEEDOR,
    6,
    PROVEEDOR,
    'SIN RAZON SOCIAL',
    'S',
    'A',
    'A4P' IdClaseEntidad,
    @usuario,
    GETDATE(),
    GETDATE(),
    @usuario,
    '002',
    '',
    '',
    '',
    '',
    '-',
    ''
FROM
    #SALDOXCOBRAR M (NOLOCK) WHERE not exists (select 1 from Maestros.Entidad E where e.IdEntidad=m.PROVEEDOR collate SQL_Latin1_General_CP1_CI_AS )            
    and not exists (
        select
            1
        from
            [PRODUCCION].ENPROYECDB.DBO.PUB_PERSONAS P (NOLOCK)
        WHERE
            P.IDPERSONA = M.PROVEEDOR
    )
    and not exists (
        select
            1
        from
            [PRODUCCION].RSCONCAR.DBO.CT0032ANEX A (NOLOCK)
        WHERE
            A.ACODANE = M.PROVEEDOR
    ) If @idModulo = 1
    /*CTB*/
    Begin
    /*LOTE*/
    --DECLARE @empresaMig varchar(4)='0004' ,@idModulo int=1 , @fechamigra varchar(8)='20210930' ,@estadoLote int=1,@usuario varchar(10)='ADMIN'           
INSERT
    FINANCIERO.LOTE (
        IdLibro,
        IdEstadoLote,
        IdDiario,
        IdPeriodo,
        NumeroTransacciones,
        IdTipoLote,
        IdModulo,
        EliminadoSN,
        FechaCreacion,
        UsuarioCreacion,
        dcompro
    )
SELECT
    case
        when d.codigo = '38' then 5
        else 1
    end IdLibro,
    @estadoLote IdEstadoLote,
    d.Id IdDiario,
    p.Id IdPeriodo,
    1 NumeroTransacciones,
    2 idTipoLote,
    @idModulo IdModulo,
    'N' EliminadoSN,
    GETDATE(),
    @usuario,
    m.campovalida
FROM
    #SALDOXCOBRAR M                      
    INNER JOIN #empresas R ON R.EMPRESA=M.EMPRESA               
    INNER JOIN FINANCIERO.Diario d (nolock) on d.codigo = m.dsubdia COLLATE SQL_Latin1_General_CP1_CI_AS
    INNER JOIN Maestros.EntidadCompania E ON E.IDENTIDAD = R.RUC COLLATE SQL_Latin1_General_CP1_CI_AS
    INNER JOIN FINANCIERO.Anio A ON A.IdCompania = E.Id
    AND @fechamigra BETWEEN DESDE
    AND HASTA
    INNER JOIN FINANCIERO.AnioPeriodo P ON P.IdAnio = A.Id
    AND P.Codigo = right('00' + rtrim(convert(varchar(2), month(fecha))), 2) -- WHERE M.DSUBDIA='77' AND DCOMPRO='010006'          
GROUP BY
    D.ID,
    p.Id,
    m.FECHA,
    m.dsubdia,
    m.campovalida,
    d.codigo
order by
    p.Id,
    m.FECHA,
    case
        m.dsubdia
        when '05' then 1
        when '06' then 2
        when '11' then 3
        when '12' then 4
        when '15' then 5
        when '55' then 98
        when '56' then 99
        else 6
    end
    /*LOTETRANSACCIONCONTABLE*/
    --DECLARE @empresaMig varchar(4)='0004' ,@idModulo int=1 , @fechamigra varchar(8)='20210930' ,@estadoLote int=1,@usuario varchar(10)='ADMIN'           
Insert
    Financiero.LoteTransaccionContable(
        IdLote,
        IdEstadoTransaccion,
        IdAnioTipoAsiento,
        TotalMonedaTransaccion,
        TotalMonedaBase,
        FechaTipoCambio,
        IdTipoCambio,
        ImporteCambio,
        MultDiv,
        IdMonedaBase,
        IdMonedaTransaccion,
        Descripcion,
        AplicativoCreacion,
        OpcionCreacion,
        FechaCreacion,
        UsuarioCreacion,
        TotalDebeMonedaTransaccion,
        TotalHaberMonedaTransaccion,
        TotalDebeMonedaBase,
        TotalHaberMonedaBase,
        idMonedaSistema
    )
SELECT
    L.ID,
    3 IdEstadoTransaccion,
    ATS.Id IdAnioTipoAsiento,
    ABS(SUM(M.IMPORTETRANSA * IIF(DDH = 'D', 1, 0))),
    ABS(SUM(M.SOLES * IIF(DDH = 'D', 1, 0))),
    MAX(FECHA) FechaTipoCambio,
    1 idTipoCambio,
    case
        when ABS(SUM(M.DOLAR * IIF(DDH = 'D', 1, 0))) > 0
        and abs(SUM(M.SOLES * IIF(DDH = 'D', 1, 0))) > 0 then IIf(
            ROUND(
                SUM(M.SOLES * IIF(DDH = 'D', 1, 0)) / SUM(M.DOLAR * IIF(DDH = 'D', 1, 0)),
                10
            ) > 0,
            ROUND(
                SUM(M.SOLES * IIF(DDH = 'D', 1, 0)) / SUM(M.DOLAR * IIF(DDH = 'D', 1, 0)),
                10
            ),
            max(M.VENTA)
        )
        Else MAX(M.VENTA)
    end ImporteCambio,
    'M' MultDiv,
    '001' IdMonedaBase,
    case
        m.moneda
        when 'MN' THEN '001'
        ELSE '002'
    end IdMonedaTransaccion,
    DR.DESCRIPCION,
    3 AplicativoCreacion,
    1 OpcionCreacion,
    GETDATE() FechaCreacion,
    @usuario UsuarioCreacion,
    SUM(M.IMPORTETRANSA * IIF(DDH = 'D', 1, 0)) TotalDebeMonedaTransaccion,
    SUM(M.IMPORTETRANSA * IIF(DDH = 'H', 1, 0)) TotalHaberMonedaTransaccion,
    SUM(M.SOLES * IIF(DDH = 'D', 1, 0)) TotalDebeMonedaBase,
    SUM(M.SOLES * IIF(DDH = 'D', 1, 0)) TotalHaberMonedaBase,
    '001'
FROM
    #SALDOXCOBRAR M (Nolock)            
    INNER JOIN financiero.lote L (nolock) ON L.DCOMPRO = m.campovalida
    AND L.IdPeriodo = M.IDPERIODO
    INNER JOIN FINANCIERO.Diario DR (nolock) on DR.CODIGO = M.DSUBDIA COLLATE SQL_Latin1_General_CP1_CI_AS
    inner join Financiero.AnioPeriodo AP (nolock) on ap.id = l.IdPeriodo
    AND AP.Codigo = right('00' + rtrim(convert(varchar(2), month(m.fecha))), 2)
    INNER JOIN Maestros.EntidadCompania E (nolock) ON E.IDENTIDAD = M.RUC_EMPRESA COLLATE SQL_Latin1_General_CP1_CI_AS
    INNER JOIN FINANCIERO.Anio A (nolock) ON A.IdCompania = E.Id
    AND @fechamigra BETWEEN DESDE
    AND HASTA
    INNER JOIN FINANCIERO.ANIOTIPOASIENTO ATS (nolock) ON ATS.IDANIO = A.ID
    AND ATS.DESCRIPCION = 'GENERAL' --WHERE M.DSUBDIA='77' AND M.DCOMPRO='010006'           
GROUP BY
    L.ID,
    ATS.Id,
    M.DSUBDIA,
    M.DCOMPRO,
    M.MONEDA,
    DR.DESCRIPCION --select * into #lote from Financiero.Lote where convert(varchar(8),FechaCreacion,112)='20211108' and IdEstadoLote=1 and idperiodo <>405          
    print 'pasaron inserto LoteTransaccionContable'
    /*LoteTransaccionContableDetalle*/
    /*CUENTA DIARIO*/
    -- DECLARE @empresaMig varchar(4)='0004' ,@idModulo int=1 , @fechamigra varchar(8)='20210930' ,@estadoLote int=1,@usuario varchar(10)='ADMIN'                       
INSERT
    FINANCIERO.LOTETRANSACCIONCONTABLEDETALLE (
        IDTRANSACCION,
        DEBEMONEDATRANSACCION,
        DEBEMONEDABASE,
        SERIE,
        NUMERO,
        HABERMONEDATRANSACCION,
        HABERMONEDABASE,
        DESCRIPCION,
        IDT10TIPOCOMPROBANTE,
        FECHADOCUMENTO,
        FECHAVENCIMIENTO,
        IDTIPOTRANSACCIONSISTEMA,
        IDTIPOTRANSACCIONDOCUMENTO,
        IDCUENTA,
        IDDIMENSIONBASE,
        IDDIMENSIONOPERATIVA,
        IDENTIDADOFICIAL,
        IDENTIDADAUXILIAR,
        IDTIPOITEM,
        CANTIDAD,
        APLICATIVOCREACION,
        OPCIONCREACION,
        FECHACREACION,
        USUARIOCREACION,
        IDLOTETRAZABLE,
        DEBEMONEDASISTEMA,
        HABERMONEDASISTEMA
    )
SELECT
    LC.ID IdTransaccion,
    CASE
        WHEN M.DDH = 'D' THEN M.IMPORTETRANSA
        ELSE 0.00
    END TotalDebeMonedaTransaccion,
CASE
        WHEN M.DDH = 'D' THEN M.SOLES
        ELSE 0.00
    END TotalDebeMonedaBase,
case
        when charindex('-', num_compr) > 0 then substring(num_compr, 1, charindex('-', num_compr) -1)
        else ''
    end serie,
case
        when charindex('-', num_compr) > 0 then substring(num_compr, charindex('-', num_compr) + 1, 10)
        else num_compr
    end Numero,
CASE
        WHEN M.DDH = 'H' THEN M.IMPORTETRANSA
        ELSE 0.00
    END TotalHaberMonedaTransaccion,
    CASE
        WHEN M.DDH = 'H' THEN M.SOLES
        ELSE 0.00
    END TotalHaberMonedaBase,
    C.Descripcion,
    ISNULL(T.ID, 1) idT10TipoComprobante,
    M.FECHA FechaDocumento,
    ISNULL(M.Fecha_Vencimiento, M.Fecha),
    28 IdTipoTransaccionSistema,
    M.TIPOTRANSACCION IdTipoTransaccionDocumento,
    C.ID Cuenta,
    S.Id IdDimensionBase,
    isnull(H.ID, Hn.Id) IdDimensionOperativa,
    ISNULL(Q.IDPERSONA, M.PROVEEDOR) IdEntidadOficial,
    ISNULL(Q.IDPERSONA, M.PROVEEDOR) IdEntidadAuxiliar,
    1 IdTipoItem,
    1,
    3 AplicativoCreacion,
    1 OpcionCreacion,
    GETDATE() FechaCreacion,
    @usuario UsuarioCreacion,
    L.ID,
    CASE
        WHEN M.DDH = 'D' THEN M.DOLAR
        ELSE 0.00
    END,
    CASE
        WHEN M.DDH = 'H' THEN M.DOLAR
        ELSE 0.00
    END
FROM
    #SALDOXCOBRAR M              
    INNER JOIN FINANCIERO.Diario DR (nolock) on DR.CODIGO = M.DSUBDIA COLLATE SQL_Latin1_General_CP1_CI_AS
    INNER JOIN Financiero.Lote L ON L.DCOMPRO = M.dsubdia + '-' + M.DCOMPRO COLLATE SQL_Latin1_General_CP1_CI_AS
    AND L.IdPeriodo = M.IDPERIODO
    INNER JOIN Financiero.LoteTransaccionContable LC ON LC.idlote = L.ID
    LEFT JOIN AnexosEquivalente Q ON M.PROVEEDOR = Q.IDPERSONAORIG COLLATE Modern_Spanish_CI_AS
    INNER JOIN Maestros.EntidadCompania E ON E.IDENTIDAD = M.RUC_EMPRESA COLLATE SQL_Latin1_General_CP1_CI_AS
    LEFT JOIN SUNAT.T10TipoComprobante T ON T.CODIGO = M.TDOC_SUNAT COLLATE SQL_Latin1_General_CP1_CI_AS --RIGHT(RTRIM(D.TDESCRI),2)                       
    LEFT JOIN FINANCIERO.CUENTA C ON C.IDCOMPANIA = E.ID
    AND C.CODIGO = M.CUENTA COLLATE MODERN_SPANISH_CI_AS
    INNER JOIN [FINANCIERO].Dimension S on S.DESCRIPCION LIKE '%OTROS-NO DIS-LIMA-OPERAC%'
    AND S.IdCompania = E.ID
    LEFT JOIN [FINANCIERO].Dimension H on
    /* H.DESCRIPCION LIKE '%000000-SPR%' AND*/
    H.IdCompania = E.ID
    AND H.IdTipoDimension = 2
    AND LEFT(H.CODIGO, 6) = m.dcencos COLLATE SQL_Latin1_General_CP1_CI_AS
    LEFT JOIN [FINANCIERO].Dimension Hn on Hn.DESCRIPCION LIKE '%000000-SPR%'
    AND Hn.IdCompania = E.ID
    AND Hn.IdTipoDimension = 2 --where m.DSUBDIA='11' and m.DCOMPRO='090068'  
    print 'pasaron inserto LoteTransaccionContableDetalle'






    
    /*****RELACIONA NA/ND CON FT ***********/
    /*Actualiza con FT. canceladas */
update
    lpd
set
    idLoteTrazable = lc.IdLote --select lpd.idcuenta,lc.IdLote,lpd.idLoteTrazable, lc.idlote, lpd.IdCuenta,c.codigo, lpo.IdCuenta, m.PROVEEDOR,m.TIPO_COMPR, m.NUM_COMPR,m.tipo_compr_orig, m.num_compr_orig ,lpo.serie,lpo.numero,lp.IdCuenta, lpo.IdTransaccion,lpo.IdEntidadOficial ,lpo.IdLoteTrazable,c.codigo
    --select *
From
    FINANCIERO.LOTETRANSACCIONCONTABLEDETALLE lpd
    inner join FINANCIERO.LOTETRANSACCIONCONTABLE lp on lp.Id = lpd.IdTransaccion
    inner join #SALDOXCOBRAR M on Case M.TIPO_COMPR when 'NA' then 8 when 'ND' then 9 end =lpd.IdT10TipoComprobante  
    and case
        when charindex('-', m.num_compr) > 0 then substring(m.num_compr, 1, charindex('-', m.num_compr) -1)
        else ''
    end = lpd.serie collate SQL_Latin1_General_CP1_CI_AS
    and case
        when charindex('-', m.num_compr) > 0 then substring(num_compr, charindex('-', num_compr) + 1, 10)
        else num_compr
    end = lpd.Numero collate database_default
    and m.PROVEEDOR = lpd.IdEntidadOficial collate database_default
    inner join FINANCIERO.LoteTransaccionContableDetalle lpo on Case
        M.TIPO_COMPR_ORIG
        when 'FT' then 2
        when 'BV' then 4
    end = lpo.IdT10TipoComprobante
    and case
        when charindex('-', m.num_compr_orig) > 0 then substring(
            m.num_compr_orig,
            1,
            charindex('-', m.num_compr_orig) -1
        )
        else ''
    end = lpo.serie collate database_default
    and case
        when charindex('-', m.num_compr_orig) > 0 then substring(
            m.num_compr_orig,
            charindex('-', m.num_compr_orig) + 1,
            10
        )
        else m.num_compr_orig
    end = lpo.Numero collate database_default
    and m.PROVEEDOR = lpo.IdEntidadOficial collate database_default
    and lpd.IdCuenta = lpo.IdCuenta
    inner join FINANCIERO.LoteTransaccionContable lc on lc.id = lpo.IdTransaccion
    inner join FINANCIERO.Lote l on l.id = lc.IdLote
    inner join Financiero.Diario d on d.id = l.IdDiario
    and d.codigo in ('11', '12', '13', '16')
    inner join Financiero.Cuenta c on lpo.IdCuenta = c.id --and c.codigo=m.CUENTA collate database_default
Where
    lpd.IdT10TipoComprobante in (8, 9)
    and c.codigo in ('121201','121202','131201','131202','421201','421202','431201','431202') --and lp.serie='F002' and lp.numero='107' 
    /*****FIN RELACIONA NA/ND CON FT ***********/
































End If @idModulo = 2
/*CXP*/
Begin --DECLARE @empresaMig varchar(4)='0002' ,@idModulo int=2 , @fechamigra varchar(8)='20210930' ,@estadoLote int=1,@usuario varchar(10)='ADMIN'           
INSERT
    FINANCIERO.LOTE (
        IdLibro,
        IdEstadoLote,
        IdDiario,
        IdPeriodo,
        NumeroTransacciones,
        IdTipoLote,
        IdModulo,
        EliminadoSN,
        FechaCreacion,
        UsuarioCreacion,
        dcompro
    )
SELECT
    1 IdLibro,
    @estadoLote IdEstadoLote,
    d.Id IdDiario,
    p.Id IdPeriodo,
    1 NumeroTransacciones,
    2 idTipoLote,
    @idModulo IdModulo,
    'N' EliminadoSN,
    GETDATE(),
    @usuario,
    convert(varchar(12), M.id)
FROM
    #SALDOXCOBRAR M                      
    INNER JOIN [PRODUCCION].ENPROYECDB.DBO.EMPRESAS R ON R.EMPRESA = M.EMPRESA
    INNER JOIN FINANCIERO.Diario d (nolock) on d.codigo = m.dsubdia COLLATE SQL_Latin1_General_CP1_CI_AS
    INNER JOIN Maestros.EntidadCompania E ON E.IDENTIDAD = R.RUC COLLATE SQL_Latin1_General_CP1_CI_AS
    INNER JOIN FINANCIERO.Anio A ON A.IdCompania = E.Id
    AND @fechamigra BETWEEN DESDE
    AND HASTA
    INNER JOIN FINANCIERO.AnioPeriodo P ON P.IdAnio = A.Id
    AND P.Codigo = right('00' + rtrim(convert(varchar(2), month(fecha))), 2)
GROUP BY
    D.ID,
    p.Id,
    m.dsubdia,
    M.ID
order by
    p.Id,
case
        m.dsubdia
        when '05' then 1
        when '06' then 2
        when '11' then 3
        when '12' then 4
        when '15' then 5
        when '55' then 98
        when '56' then 99
        else 6
    end --DECLARE @empresaMig varchar(4)='0002' ,@idModulo int=2 , @fechamigra varchar(8)='20210930' ,@estadoLote int=1,@usuario varchar(10)='ADMIN'           
INSERT
    FINANCIERO.LOTETRANSACCIONPORPAGAR (
        idLote,
        IdEstadoTransaccion,
        IdLoteTransaccionTrazable,
        serie,
        Numero,
        TotalMonedaTransaccion,
        TotalMonedaBase,
        SaldoMonedaTransaccion,
        IdTipoCambio,
        FechaTipoCambio,
        IdAnioTipoAsiento,
        SaldoMonedaBase,
        IdT10TipoComprobante,
        FechaDocumento,
        FechaVencimiento,
        MultDiv,
        ImporteCambio,
        IdMonedaBase,
        IdMonedaTransaccion,
        IdTipoTransaccionDocumento,
        IdRegimen,
        IdCuenta,
        IdDimensionBase,
        IdDimensionOperativa,
        IdEntidadOficial,
        IdEntidadAuxiliar,
        Descripcion,
        IdT25ConvenioTributacion,
        IdT27TipoVinculacion,
        IdT30ClasificacionBienServicio,
        IdT31TipoRenta,
        IdT32ModalidadNoDomiciliado,
        IdT33ExoneracionNoDomiciliado,
        IdT11CodigoAduana,
        IdFormaPago,
        AnioEmisionDuaDsi,
        ConstanciaDetraccion,
        FechaConstanciaDetraccion,
        AplicativoCreacion,
        OpcionCreacion,
        FechaCreacion,
        UsuarioCreacion,
        PorPagarMonedaBase,
        porPagarMonedaTransaccion
    )
SELECT
    L.ID,
    3 IdEstadoTransaccion,
    0 IdLoteTransaccionTrazable,
    case
        when charindex('-', num_compr) > 0 then substring(num_compr, 1, charindex('-', num_compr) -1)
        else ''
    end serie,
    case
        when charindex('-', num_compr) > 0 then substring(num_compr, charindex('-', num_compr) + 1, 10)
        else num_compr
    end Numero,
    M.IMPORTETRANSA TotalMonedaTransaccion,
    M.SOLES TotalMonedaBase,
    M.IMPORTETRANSA SaldoTotalMonedaTransaccion,
case
        when tct.Codigo = 'PAS' then 1
        else 2
    end idTipoCambio,
    M.FECHA FechaTipoCambio,
    ATS.Id IdAnioTipoAsiento,
    M.SOLES SaldoMonedaBase,
    ISNULL(T.ID, 1) idT10TipoComprobante,
    M.FECHA FechaDocumento,
    M.FECHA_VENCE FechaVencimiento,
    'M' MultDiv,
    case
        when M.DOLAR > 0
        and M.SOLES > 0 then ROUND(M.SOLES / M.DOLAR, 10)
        Else Case
            when tct.Codigo = 'PAS' then M.VENTA
            else M.COMPRA
        end
    end ImporteCambio,
    '001' IdMonedaBase,
case
        m.moneda
        when 'MN' THEN '001'
        ELSE '002'
    END IdMonedaTransaccion,
    M.TIPOTRANSACCION IdTipoTransaccionDocumento,
    5 IdRegimen,
    C.ID,
    S.Id IdDimensionBase,
    H.ID IdDimensionOperativa,
    M.PROVEEDOR IdEntidadOficial,
    M.PROVEEDOR IdEntidadAuxiliar,
    C.DESCRIPCION,
    1 IdT25ConvenioTributacion,
    1 IdT27TipoVinculacion,
    5 IdT30ClasificacionBienServicio,
    1 IdT31TipoRenta,
    1 IdT32ModalidadNoDomiciliado,
    NULL IdT33ExoneracionNoDomiciliado,
    NULL IdT11CodigoAduana,
    1 IdFormaPago,
    2020 AnioEmisionDuaDsi,
    NULL ConstanciaDetraccion,
    NULL FechaConstanciaDetraccion,
    3 AplicativoCreacion,
    1 OpcionCreacion,
    GETDATE() FechaCreacion,
    @usuario UsuarioCreacion,
    M.SOLES,
    M.IMPORTETRANSA
FROM
    #SALDOXCOBRAR M                    
    INNER JOIN [PRODUCCION].ENPROYECDB.DBO.EMPRESAS R ON R.EMPRESA = M.EMPRESA
    INNER JOIN Maestros.EntidadCompania E ON E.IDENTIDAD = R.RUC COLLATE SQL_Latin1_General_CP1_CI_AS
    INNER JOIN Financiero.Lote L ON L.DCOMPRO = convert(varchar(12), m.id)
    AND L.IdPeriodo = M.IDPERIODO
    INNER JOIN FINANCIERO.Anio A ON A.IdCompania = E.Id
    AND @fechamigra BETWEEN DESDE
    AND HASTA
    INNER JOIN FINANCIERO.ANIOTIPOASIENTO ATS ON ATS.IDANIO = A.ID
    AND ATS.DESCRIPCION = 'GENERAL'
    INNER JOIN [PRODUCCION].RSCONCAR.DBO.CT0032TAGE D ON D.TCOD = '06'
    AND D.TCLAVE = M.TIPO_COMPR
    LEFT JOIN SUNAT.T10TipoComprobante T ON T.CODIGO = RIGHT(RTRIM(D.TDESCRI), 2) COLLATE SQL_Latin1_General_CP1_CI_AS
    LEFT JOIN Sunat.T10TipoComprobante F ON F.CODIGO =CASE
        WHEN ISNUMERIC(RIGHT(RTRIM(D.TDESCRI), 2)) = 1 THEN RIGHT(RTRIM(D.TDESCRI), 2)
        ELSE '00'
    END COLLATE SQL_Latin1_General_CP1_CI_AS
    LEFT JOIN FINANCIERO.CUENTA C ON C.IDCOMPANIA = E.ID
    AND C.CODIGO = M.CUENTA COLLATE MODERN_SPANISH_CI_AS
    LEFT JOIN Configuracion.TipoCuentaContable TCT ON TCT.Id = c.IdTipoCuentaContable
    inner JOIN [FINANCIERO].Dimension S on S.DESCRIPCION LIKE '%OTROS-NO DIS-LIMA-OPERAC%'
    AND S.IdCompania = E.ID
    inner JOIN [FINANCIERO].Dimension H on H.DESCRIPCION LIKE '%000000-SPR%'
    AND H.IdCompania = E.ID
    /*LoteTransaccionPorPagarDetalle*/
    --   DECLARE @empresaMig varchar(4)='0002' ,@idModulo int=2 , @fechamigra varchar(8)='20210930' ,@estadoLote int=1,@usuario varchar(10)='ADMIN'           
INSERT
    FINANCIERO.LoteTransaccionPorPagarDetalle (
        Cantidad,
        UnitarioMonedaTransaccion,
        TotalMonedaTransaccion,
        UnitarioMonedaBase,
        TotalMonedaBase,
        DebeHaber,
        ImpuestoMonedaTransaccion,
        ImpuestoMonedaBase,
        Descripcion,
        idCategoriaImpuesto,
        IdImpuesto,
        IdTipoTransaccionSistema,
        IdTransaccion,
        IdCuenta,
        IdDimensionBase,
        IdDimensionOperativa,
        IdLoteTransaccionDetalleTrazable,
        IdLoteTransaccionAPagar,
        AplicativoCreacion,
        OpcionCreacion,
        FechaCreacion,
        UsuarioCreacion,
        idLoteTrazable
    )
SELECT
    1,
    M.IMPORTETRANSA,
    M.IMPORTETRANSA,
    M.SOLES,
    M.SOLES,
    M.DDH,
    M.IGV,
    M.IGVSOLES,
    C.Descripcion,
    /*CASE WHEN ISNULL(M.IGV,0) >0 THEN 8 ELSE NULL END*/
    3,
    /*CASE WHEN ISNULL(M.igv,0) >0 THEN 1 ELSE NULL END*/
    2 IdImpuesto,
    M.TIPOTRANSACCION IdTipoTransaccionSistema,
    LC.id,
    C.ID CUENTA,
    S.ID IdDimensionBase,
    h.Id IdDimensionOperativa,
    NULL,
    LC.ID,
    3 AplicativoCreacion,
    1 OpcionCreacion,
    GETDATE() OpcionCreacion,
    @usuario UsuarioCreacion,
    L.ID
FROM
    #SALDOXCOBRAR M                    
    INNER JOIN [PRODUCCION].ENPROYECDB.DBO.EMPRESAS R ON R.EMPRESA = M.EMPRESA
    INNER JOIN Maestros.EntidadCompania E ON E.IDENTIDAD = R.RUC COLLATE SQL_Latin1_General_CP1_CI_AS
    INNER JOIN Financiero.Lote L ON L.DCOMPRO = convert(varchar(12), m.id)
    AND L.IdPeriodo = M.IDPERIODO
    INNER JOIN Financiero.LOTETRANSACCIONPORPAGAR LC ON LC.idlote = L.ID
    LEFT JOIN FINANCIERO.CUENTA C ON C.IDCOMPANIA = E.ID
    AND C.CODIGO = M.CUENTA COLLATE MODERN_SPANISH_CI_AS
    INNER JOIN [FINANCIERO].Dimension S on S.DESCRIPCION LIKE '%OTROS-NO DIS-LIMA-OPERAC%'
    AND S.IdCompania = E.ID
    INNER JOIN [FINANCIERO].Dimension H on H.DESCRIPCION LIKE '%000000-SPR%'
    AND H.IdCompania = E.ID





    /*****RELACIONA NA/ND CON FT ***********/
    /*Actualiza con FT. canceladas */
update
    lpd
set
    idLoteTrazable = lc.IdLote --select lpd.idcuenta,lc.IdLote,lpd.idLoteTrazable, lc.idlote, lpd.IdCuenta,c.codigo, lpo.IdCuenta, m.PROVEEDOR,m.TIPO_COMPR, m.NUM_COMPR,m.tipo_compr_orig, m.num_compr_orig ,lpo.serie,lpo.numero,lp.IdCuenta, lpo.IdTransaccion,lpo.IdEntidadOficial ,lpo.IdLoteTrazable,c.codigo
From
    FINANCIERO.LoteTransaccionPorPagarDetalle lpd
    inner join FINANCIERO.LoteTransaccionPorPagar lp on lp.Id = lpd.IdTransaccion
    inner join #SALDOXCOBRAR M on Case M.TIPO_COMPR when 'NA' then 8 when 'ND' then 9 end =lp.IdT10TipoComprobante  
    and case
        when charindex('-', m.num_compr) > 0 then substring(m.num_compr, 1, charindex('-', m.num_compr) -1)
        else ''
    end = lp.serie collate SQL_Latin1_General_CP1_CI_AS
    and case
        when charindex('-', m.num_compr) > 0 then substring(num_compr, charindex('-', num_compr) + 1, 10)
        else num_compr
    end = lp.Numero collate database_default
    and m.PROVEEDOR = lp.IdEntidadOficial collate database_default

    
    inner join FINANCIERO.LoteTransaccionContableDetalle lpo on Case
        M.TIPO_COMPR_ORIG
        when 'FT' then 2
        when 'BV' then 4
    end = lpo.IdT10TipoComprobante
    and case
        when charindex('-', m.num_compr_orig) > 0 then substring(
            m.num_compr_orig,
            1,
            charindex('-', m.num_compr_orig) -1
        )
        else ''
    end = lpo.serie collate database_default
    and case
        when charindex('-', m.num_compr_orig) > 0 then substring(
            m.num_compr_orig,
            charindex('-', m.num_compr_orig) + 1,
            10
        )
        else m.num_compr_orig
    end = lpo.Numero collate database_default
    and m.PROVEEDOR = lpo.IdEntidadOficial collate database_default
    and lpd.IdCuenta = lpo.IdCuenta
    
    inner join FINANCIERO.LoteTransaccionContable lc on lc.id = lpo.IdTransaccion
    inner join FINANCIERO.Lote l on l.id = lc.IdLote
    inner join Financiero.Diario d on d.id = l.IdDiario
    and d.codigo in ('11', '12', '13', '16')
    inner join Financiero.Cuenta c on lpo.IdCuenta = c.id --and c.codigo=m.CUENTA collate database_default
Where
    lp.IdT10TipoComprobante in (8, 9)
    and c.codigo in ('421201', '421202', '431201', '431202') --and lp.serie='F002' and lp.numero='107' 
    










/*Actualiza con FT. pendientes - NO están en LOteTransaccionContable */
update
    lpd
set
    idLoteTrazable = lpo.IdLote --select * lpd.idcuenta,lc.IdLote,lpd.idLoteTrazable, lc.idlote, lpd.IdCuenta,c.codigo, lpo.IdCuenta, m.PROVEEDOR,m.TIPO_COMPR, m.NUM_COMPR,m.tipo_compr_orig, m.num_compr_orig ,lpo.serie,lpo.numero,lp.IdCuenta, lpo.IdTransaccion,lpo.IdEntidadOficial ,lpo.IdLoteTrazable,c.codigo
From
    FINANCIERO.LoteTransaccionPorPagarDetalle lpd
    inner join FINANCIERO.LoteTransaccionPorPagar lp on lp.Id = lpd.IdTransaccion
    inner join #SALDOXCOBRAR M on Case M.TIPO_COMPR when 'NA' then 8 when 'ND' then 9 end =lp.IdT10TipoComprobante  
    and case
        when charindex('-', m.num_compr) > 0 then substring(m.num_compr, 1, charindex('-', m.num_compr) -1)
        else ''
    end = lp.serie collate SQL_Latin1_General_CP1_CI_AS
    and case
        when charindex('-', m.num_compr) > 0 then substring(num_compr, charindex('-', num_compr) + 1, 10)
        else num_compr
    end = lp.Numero collate database_default
    and m.PROVEEDOR = lp.IdEntidadOficial collate database_default

    inner join FINANCIERO.LoteTransaccionPorPagar lpo on Case
        M.TIPO_COMPR_ORIG
        when 'FT' then 2
        when 'BV' then 4
    end = lpo.IdT10TipoComprobante
    and case
        when charindex('-', m.num_compr_orig) > 0 then substring(
            m.num_compr_orig,
            1,
            charindex('-', m.num_compr_orig) -1
        )
        else ''
    end = lpo.serie collate database_default
    and case
        when charindex('-', m.num_compr_orig) > 0 then substring(
            m.num_compr_orig,
            charindex('-', m.num_compr_orig) + 1,
            10
        )
        else m.num_compr_orig
    end = lpo.Numero collate database_default

    and m.PROVEEDOR = lpo.IdEntidadOficial collate database_default
    inner join FINANCIERO.Lote l on l.id = lpo.IdLote
    inner join Financiero.Diario d on d.id = l.IdDiario
    and d.codigo in ('11', '12', '13', '16')
    inner join Financiero.Cuenta c on lpo.IdCuenta = c.id --and c.codigo=m.CUENTA collate database_default
Where
    lp.IdT10TipoComprobante in (8, 9)
    and c.codigo in ('421201', '421202', '431201', '431202') --and lp.serie='F002' and lp.numero='107' 
    /*****FIN RELACIONA NA/ND CON FT ***********/



























End If @idModulo = 3
/*CXC*/
Begin
/*LOTE*/
--DECLARE @empresaMig varchar(4)='0004' ,@idModulo int=1 , @fechamigra varchar(8)='20210930' ,@estadoLote int=1,@usuario varchar(10)='ADMIN'           
INSERT
    FINANCIERO.LOTE (
        IdLibro,
        IdEstadoLote,
        IdDiario,
        IdPeriodo,
        NumeroTransacciones,
        IdTipoLote,
        IdModulo,
        EliminadoSN,
        FechaCreacion,
        UsuarioCreacion,
        dcompro
    )
SELECT
    1 IdLibro,
    @estadoLote IdEstadoLote,
    d.Id IdDiario,
    p.Id IdPeriodo,
    1 NumeroTransacciones,
    2 idTipoLote,
    @idModulo IdModulo,
    'N' EliminadoSN,
    GETDATE(),
    @usuario,
    convert(varchar(12), M.id)
FROM
    #SALDOXCOBRAR M                      
    INNER JOIN [PRODUCCION].ENPROYECDB.DBO.EMPRESAS R ON R.EMPRESA = M.EMPRESA
    INNER JOIN FINANCIERO.Diario d (nolock) on d.codigo = m.dsubdia COLLATE SQL_Latin1_General_CP1_CI_AS
    INNER JOIN Maestros.EntidadCompania E ON E.IDENTIDAD = R.RUC COLLATE SQL_Latin1_General_CP1_CI_AS
    INNER JOIN FINANCIERO.Anio A ON A.IdCompania = E.Id
    AND @fechamigra BETWEEN DESDE
    AND HASTA
    INNER JOIN FINANCIERO.AnioPeriodo P ON P.IdAnio = A.Id
    AND P.Codigo = right('00' + rtrim(convert(varchar(2), month(fecha))), 2)
GROUP BY
    D.ID,
    p.Id,
    m.dsubdia,
    m.id
order by
    p.Id,
case
        m.dsubdia
        when '05' then 1
        when '06' then 2
        when '11' then 3
        when '12' then 4
        when '15' then 5
        when '55' then 98
        when '56' then 99
        else 6
    end
    /*LOTE TRANSACCIONPORCOBRAR*/
    --  DECLARE @empresaMig varchar(4)='0004' ,@idModulo int=3 , @fechamigra varchar(8)='20210930' ,@estadoLote int=1,@usuario varchar(10)='ADMIN'       
INSERT
    [FINANCIERO].LoteTransaccionPorCobrar(
        IdLote,
        IdEstadoTransaccion,
        IdAnioTipoAsiento,
        TransaccionOrigen,
        LoteOrigen,
        Serie,
        Numero,
        TotalMonedaTransaccion,
        TotalMonedaBase,
        SaldoMonedaTransaccion,
        SaldoMonedaBase,
        IdTipoCambio,
        FechaTipoCambio,
        IdEstadoAdjunto,
        IdT10TipoComprobante,
        FechaDocumento,
        FechaVencimiento,
        MultDiv,
        ImporteCambio,
        IdMonedaBase,
        IdMonedaTransaccion,
        IdTipoTransaccionDocumento,
        IdCuenta,
        IdDimensionBase,
        IdDimensionOperativa,
        IdEntidadOficial,
        IdEntidadAuxiliar,
        Descripcion,
        IdFormaPago,
        AplicativoCreacion,
        OpcionCreacion,
        FechaCreacion,
        UsuarioCreacion
    )
SELECT
    L.id,
    1 IdEstadoTransaccion,
    ats.Id IdAnioTipoAsiento,
    NULL TransaccionOrigen,
    NULL LoteOrigen,
    case
        when charindex('-', num_compr) > 0 then substring(num_compr, 1, charindex('-', num_compr) -1)
        else ''
    end serie,
    case
        when charindex('-', num_compr) > 0 then substring(num_compr, charindex('-', num_compr) + 1, 10)
        else num_compr
    end Numero,
    M.IMPORTETRANSA TotalMonedaTransaccion,
    M.SOLES TotalMonedaBase,
    M.IMPORTETRANSA SaldoMonedaTransaccion,
    M.soles SaldoMonedaBase,
    case
        when tct.Codigo = 'PAS' then 1
        else 2
    end idTipoCambio,
    M.FECHA FechaTipoCambio,
    3 IdEstadoAdjunto,
    ISNULL(T.ID, 1) idT10TipoComprobante,
    M.fecha FechaDocumento,
    M.FECHA_VENCE FechaVencimiento,
    'M' MultDiv,
    case
        when M.DOLAR > 0
        and M.SOLES > 0 then ROUND(M.SOLES / M.DOLAR, 10)
        Else Case
            when tct.Codigo = 'PAS' then M.VENTA
            else M.COMPRA
        end
    end ImporteCambio,
    '001' IdMonedaBase,
case
        m.moneda
        when 'MN' THEN '001'
        ELSE '002'
    END IdMonedaTransaccion,
    M.TIPOTRANSACCION IdTipoTransaccionDocumento,
    C.ID,
    S.Id IdDimensionBase,
    H.ID IdDimensionOperativa,
    M.PROVEEDOR IdEntidadOficial,
    M.PROVEEDOR IdEntidadAuxiliar,
    C.DESCRIPCION,
    1 IdFormaPago,
    3 AplicativoCreacion,
    1 OpcionCreacion,
    GETDATE() FechaCreacion,
    @usuario UsuarioCreacion
FROM
    [PRODUCCION].ENPROYECDB.DBO.SALDOXCOBRAR M --    INNER JOIN [produccion].ENPROYECDB.DBO.VIEW_TCAMBIO TC ON CONVERT(VARCHAR(8),TC.XFECCAM2,112)=CONVERT(VARCHAR(8),M.FECHA,112) and tc.XCODMON='US'          
    INNER JOIN [PRODUCCION].ENPROYECDB.DBO.EMPRESAS R ON R.EMPRESA = M.EMPRESA
    INNER JOIN Maestros.EntidadCompania E ON E.IDENTIDAD = R.RUC COLLATE SQL_Latin1_General_CP1_CI_AS
    INNER JOIN Financiero.Lote L ON L.DCOMPRO = convert(varchar(12), m.id)
    AND L.IdPeriodo = M.IDPERIODO
    INNER JOIN FINANCIERO.Anio A ON A.IdCompania = E.Id
    AND @fechamigra BETWEEN DESDE
    AND HASTA
    INNER JOIN FINANCIERO.ANIOTIPOASIENTO ATS ON ATS.IDANIO = A.ID
    AND ATS.DESCRIPCION = 'GENERAL'
    INNER JOIN [PRODUCCION].RSCONCAR.DBO.CT0032TAGE D ON D.TCOD = '06'
    AND D.TCLAVE = M.TIPO_COMPR
    LEFT JOIN SUNAT.T10TipoComprobante T ON T.CODIGO = RIGHT(RTRIM(D.TDESCRI), 2) COLLATE SQL_Latin1_General_CP1_CI_AS
    LEFT JOIN FINANCIERO.CUENTA C ON C.IDCOMPANIA = E.ID
    AND C.CODIGO = M.CUENTA COLLATE MODERN_SPANISH_CI_AS
    LEFT JOIN Configuracion.TipoCuentaContable TCT ON TCT.Id = c.IdTipoCuentaContable
    INNER JOIN [FINANCIERO].Dimension S on S.DESCRIPCION LIKE '%OTROS-NO DIS-LIMA-OPERAC%'
    AND S.IdCompania = E.ID
    INNER JOIN [FINANCIERO].Dimension H on H.DESCRIPCION LIKE '%000000-SPR%'
    AND H.IdCompania = E.ID
    /*LoteTransaccionPorCobrarDetalle*/
    --DECLARE @empresaMig varchar(4)='0004' ,@idModulo int=3 , @fechamigra varchar(8)='20210930' ,@estadoLote int=1,@usuario varchar(10)='ADMIN'                
INSERT
    FINANCIERO.LoteTransaccionPorCobrarDetalle (
        IdTransaccion,
        TransaccionRelacionada,
        LoteRelacionado,
        Cantidad,
        UnitarioMonedaTransaccion,
        TotalMonedaTransaccion,
        UnitarioMonedaBase,
        TotalMonedaBase,
        DebeHaber,
        ImpuestoMonedaTransaccion,
        ImpuestoMonedaBase,
        Descripcion,
        DiferenciaCambio,
        IdCategoriaImpuesto,
        IdImpuesto,
        IdTipoTransaccionSistema,
        IdCuenta,
        IdDimensionBase,
        IdDimensionOperativa,
        IdTipoItem,
        AplicativoCreacion,
        OpcionCreacion,
        FechaCreacion,
        UsuarioCreacion,
        idLoteTrazable
    )
SELECT
    LC.ID IdTransaccion,
    null TransaccionRelacionada,
    L.ID LoteRelacionado,
    1 cantidad,
    M.IMPORTETRANSA UnitarioMonedaTransaccion,
    M.IMPORTETRANSA TotalMonedaTransaccion,
    M.SOLES UnitarioMonedaBase,
    M.SOLES TotalMonedaBase,
    M.DDH DebeHaber,
    M.IGV ImpuestoMonedaTransaccion,
    M.IGVSOLES ImpuestoMonedaBase,
    C.Descripcion,
    NULL DiferenciaCambio,
    3 IdCategoriaImpuesto,
    2 IdImpuesto,
    M.TIPOTRANSACCION IdTipoTransaccionSistema,
    C.ID IdCuenta,
    S.ID IdDimensionBase,
    h.Id IdDimensionOperativa,
    1 IdTipoItem,
    3 AplicativoCreacion,
    1 OpcionCreacion,
    GETDATE() OpcionCreacion,
    @usuario UsuarioCreacion,
    L.ID
FROM
    [PRODUCCION].ENPROYECDB.DBO.SALDOXCOBRAR M
    INNER JOIN [PRODUCCION].ENPROYECDB.DBO.EMPRESAS R ON R.EMPRESA = M.EMPRESA
    INNER JOIN Maestros.EntidadCompania E ON E.IDENTIDAD = R.RUC COLLATE SQL_Latin1_General_CP1_CI_AS
    INNER JOIN Financiero.Lote L ON L.DCOMPRO = convert(varchar(12), m.id)
    AND L.IdPeriodo = M.IDPERIODO
    INNER JOIN Financiero.LoteTransaccionPorCobrar LC ON LC.idlote = L.ID
    LEFT JOIN FINANCIERO.CUENTA C ON C.IDCOMPANIA = E.ID
    AND C.CODIGO = M.CUENTA COLLATE MODERN_SPANISH_CI_AS
    INNER JOIN [FINANCIERO].Dimension S on S.DESCRIPCION LIKE '%OTROS-NO DIS-LIMA-OPERAC%'
    AND S.IdCompania = E.ID
    INNER JOIN [FINANCIERO].Dimension H on H.DESCRIPCION LIKE '%000000-SPR%'
    AND H.IdCompania = E.ID
    /*****RELACIONA NA/ND CON FT ***********/
    /*Actualiza con FT. canceladas */
update
    lpd
set
    idLoteTrazable = lc.IdLote --select lpd.idcuenta,lc.IdLote,lpd.idLoteTrazable, lc.idlote, lpd.IdCuenta,c.codigo, lpo.IdCuenta, m.PROVEEDOR,m.TIPO_COMPR, m.NUM_COMPR,m.tipo_compr_orig, m.num_compr_orig ,lpo.serie,lpo.numero,lp.IdCuenta, lpo.IdTransaccion,lpo.IdEntidadOficial ,lpo.IdLoteTrazable,c.codigo
From
    FINANCIERO.LoteTransaccionPorCobrarDetalle lpd
    inner join FINANCIERO.LoteTransaccionPorCobrar lp on lp.Id = lpd.IdTransaccion
    inner join #SALDOXCOBRAR M on Case M.TIPO_COMPR when 'NA' then 8 when 'ND' then 9 end =lp.IdT10TipoComprobante  
    and case
        when charindex('-', m.num_compr) > 0 then substring(m.num_compr, 1, charindex('-', m.num_compr) -1)
        else ''
    end = lp.serie collate SQL_Latin1_General_CP1_CI_AS
    and case
        when charindex('-', m.num_compr) > 0 then substring(num_compr, charindex('-', num_compr) + 1, 10)
        else num_compr
    end = lp.Numero collate database_default
    and m.PROVEEDOR = lp.IdEntidadOficial collate database_default
    inner join FINANCIERO.LoteTransaccionContableDetalle lpo on Case
        M.TIPO_COMPR_ORIG
        when 'FT' then 2
        when 'BV' then 4
    end = lpo.IdT10TipoComprobante
    and case
        when charindex('-', m.num_compr_orig) > 0 then substring(
            m.num_compr_orig,
            1,
            charindex('-', m.num_compr_orig) -1
        )
        else ''
    end = lpo.serie collate database_default
    and case
        when charindex('-', m.num_compr_orig) > 0 then substring(
            m.num_compr_orig,
            charindex('-', m.num_compr_orig) + 1,
            10
        )
        else m.num_compr_orig
    end = lpo.Numero collate database_default
    and m.PROVEEDOR = lpo.IdEntidadOficial collate database_default
    and lpd.IdCuenta = lpo.IdCuenta
    inner join FINANCIERO.LoteTransaccionContable lc on lc.id = lpo.IdTransaccion
    inner join FINANCIERO.Lote l on l.id = lc.IdLote
    inner join Financiero.Diario d on d.id = l.IdDiario
    and d.codigo in ('11', '12', '13', '16')
    inner join Financiero.Cuenta c on lpo.IdCuenta = c.id --and c.codigo=m.CUENTA collate database_default
Where
    lp.IdT10TipoComprobante in (8, 9)
    and c.codigo in ('121201', '121202', '131201', '131202') --and lp.serie='F002' and lp.numero='107' 
    /*Actualiza con FT. pendientes - NO están en LOteTransaccionContable */
update
    lpd
set
    idLoteTrazable = lpo.IdLote --select * lpd.idcuenta,lc.IdLote,lpd.idLoteTrazable, lc.idlote, lpd.IdCuenta,c.codigo, lpo.IdCuenta, m.PROVEEDOR,m.TIPO_COMPR, m.NUM_COMPR,m.tipo_compr_orig, m.num_compr_orig ,lpo.serie,lpo.numero,lp.IdCuenta, lpo.IdTransaccion,lpo.IdEntidadOficial ,lpo.IdLoteTrazable,c.codigo
From
    FINANCIERO.LoteTransaccionPorCobrarDetalle lpd
    inner join FINANCIERO.LoteTransaccionPorCobrar lp on lp.Id = lpd.IdTransaccion
    inner join #SALDOXCOBRAR M on Case M.TIPO_COMPR when 'NA' then 8 when 'ND' then 9 end =lp.IdT10TipoComprobante  
    and case
        when charindex('-', m.num_compr) > 0 then substring(m.num_compr, 1, charindex('-', m.num_compr) -1)
        else ''
    end = lp.serie collate SQL_Latin1_General_CP1_CI_AS
    and case
        when charindex('-', m.num_compr) > 0 then substring(num_compr, charindex('-', num_compr) + 1, 10)
        else num_compr
    end = lp.Numero collate database_default
    and m.PROVEEDOR = lp.IdEntidadOficial collate database_default
    inner join FINANCIERO.LoteTransaccionPorPagar lpo on Case
        M.TIPO_COMPR_ORIG
        when 'FT' then 2
        when 'BV' then 4
    end = lpo.IdT10TipoComprobante
    and case
        when charindex('-', m.num_compr_orig) > 0 then substring(
            m.num_compr_orig,
            1,
            charindex('-', m.num_compr_orig) -1
        )
        else ''
    end = lpo.serie collate database_default
    and case
        when charindex('-', m.num_compr_orig) > 0 then substring(
            m.num_compr_orig,
            charindex('-', m.num_compr_orig) + 1,
            10
        )
        else m.num_compr_orig
    end = lpo.Numero collate database_default
    and m.PROVEEDOR = lpo.IdEntidadOficial collate database_default
    inner join FINANCIERO.Lote l on l.id = lpo.IdLote
    inner join Financiero.Diario d on d.id = l.IdDiario
    and d.codigo in ('11', '12', '13', '16')
    inner join Financiero.Cuenta c on lpo.IdCuenta = c.id --and c.codigo=m.CUENTA collate database_default
Where
    lp.IdT10TipoComprobante in (8, 9)
    and c.codigo in ('121201', '121202', '131201', '131202') --and lp.serie='F002' and lp.numero='107' 
    /*****FIN RELACIONA NA/ND CON FT ***********/
End
END