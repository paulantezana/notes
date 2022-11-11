-- Fecha contable = fecha del asiento

-----------------------------------------------------------------------------------
-- GENERA PLE
-- ----

/*
1.- Revisar los ple que faltan
2.- Ver una mejor manera de consultar los ple que sea por view
3.- Analizar para reporte de tesoreria, Ver el funcionamiento de combranza

# OBSERVACIONES
   # Libro Diario
	- Existe una entidad con el numero documento vacio
	- Existen entidades con numero documento con "-" que no corresponde a un numero de documento valido
	- Existen operaciones de nota de credito, debito y otros tipos de documentos sin serie y/o numero.
   # Por Pagar
    - Numero de documentos no corresponde al tipo de documento
	- Las series en factura, nd y nd deben tener 3 digitos

# PENDIENTE
	- Actualizar fecha contable en: Libro diario, Libro Mayor, Libro Cajas y Bancos.


# Retenciones Back Office
	ANTES -> por contabilidad
	AHORA -> Provicion por pagar
		  -> porvision pagado

# Retencion.
	- https://pqs.pe/actualidad/economia/ejemplos-de-detracciones-retenciones-percepciones-de-igv/


# Duda ALEXIS: Resuelto
 - Libro 8.1
	- Campo 36
	- Falta el contenido de ISC, ISBR, Contrato, Error,1,2,3,4
 - Libro 8.2
	- Falata, Campo 11(Doc Aduana), Campo 14 (Serie adua), Campos: 22,23,24 (Beneficiario pago), Campo 35 (Ley IGV ART76)


# Reporte a alexis: No es necesario
	- Para crear tipo asiento
		- Solo permite DXP = documento por pagar

# Continuar en
	- https://docs.microsoft.com/es-es/sql/t-sql/queries/select-over-clause-transact-sql?view=sql-server-ver15
	- https://docs.microsoft.com/es-es/sql/relational-databases/collations/collation-and-unicode-support?view=sql-server-ver15
*/

EXEC [Financiero].[usp_rpt_CTB191] '( (Periodo like ''%202112%'') and (codigo like ''%010100%'') )','','14'
EXEC [Financiero].[usp_rpt_CTB191] '( (Periodo like ''%202112%'') and (codigo like ''%010200%'') )','','14'

EXEC [Financiero].[usp_rpt_CTB191] '( (Periodo like ''%202112%'') and (codigo like ''%030100%'') )','','14'
EXEC [Financiero].[usp_rpt_CTB191] '( (Periodo like ''%202112%'') and (codigo like ''%030200%'') )','','14'
EXEC [Financiero].[usp_rpt_CTB191] '( (Periodo like ''%202112%'') and (codigo like ''%030300%'') )','','14'
EXEC [Financiero].[usp_rpt_CTB191] '( (Periodo like ''%202112%'') and (codigo like ''%030400%'') )','','14'
EXEC [Financiero].[usp_rpt_CTB191] '( (Periodo like ''%202112%'') and (codigo like ''%030500%'') )','','14'
EXEC [Financiero].[usp_rpt_CTB191] '( (Periodo like ''%202112%'') and (codigo like ''%030600%'') )','','14'
EXEC [Financiero].[usp_rpt_CTB191] '( (Periodo like ''%202112%'') and (codigo like ''%030700%'') )','','14'
--EXEC [Financiero].[usp_rpt_CTB191] '( (Periodo like ''%202112%'') and (codigo like ''%030800%'') )','','14'
--EXEC [Financiero].[usp_rpt_CTB191] '( (Periodo like ''%202112%'') and (codigo like ''%030900%'') )','','14'

EXEC [Financiero].[usp_rpt_CTB191] '( (Periodo like ''%202112%'') and (codigo like ''%031100%'') )','','14'
EXEC [Financiero].[usp_rpt_CTB191] '( (Periodo like ''%202112%'') and (codigo like ''%031200%'') )','','14'
EXEC [Financiero].[usp_rpt_CTB191] '( (Periodo like ''%202112%'') and (codigo like ''%031300%'') )','','14'

EXEC [Financiero].[usp_rpt_CTB191] '( (Periodo like ''%202112%'') and (codigo like ''%031500%'') )','','14'

EXEC [Financiero].[usp_rpt_CTB191] '( (Periodo like ''%202112%'') and (codigo like ''%031700%'') )','','14'

EXEC [Financiero].[usp_rpt_CTB191] '( (Periodo like ''%202112%'') and (codigo like ''%040100%'') )','','14'

-- Libro diario, mayor y plan contable
EXEC [Financiero].[usp_rpt_CTB191] '( (Periodo like ''%202112%'') and (codigo like ''%050100%'') )','','14'
EXEC [Financiero].[usp_rpt_CTB191] '( (Periodo like ''%202112%'') and (codigo like ''%050300%'') )','','14'
EXEC [Financiero].[usp_rpt_CTB191] '( (Periodo like ''%202112%'') and (codigo like ''%060100%'') )','','14'
-- Libro simplificado
--EXEC [Financiero].[usp_rpt_CTB191] '( (Periodo like ''%202112%'') and (codigo like ''%050200%'') )','','14'
--EXEC [Financiero].[usp_rpt_CTB191] '( (Periodo like ''%202112%'') and (codigo like ''%050400%'') )','','14'

-- Compra - venta
EXEC [Financiero].[usp_rpt_CTB191] '( (Periodo like ''%202112%'') and (codigo like ''%080100%'') )','','14' --15 = 20518915119
EXEC [Financiero].[usp_rpt_CTB191] '( (Periodo like ''%202112%'') and (codigo like ''%080200%'') )','','14'
EXEC [Financiero].[usp_rpt_CTB191] '( (Periodo like ''%202112%'') and (codigo like ''%140100%'') )','','14'
-- Compra - venta : Simplificado
--EXEC [Financiero].[usp_rpt_CTB191] '( (Periodo like ''%202112%'') and (codigo like ''%080300%'') )','','14'
--EXEC [Financiero].[usp_rpt_CTB191] '( (Periodo like ''%202112%'') and (codigo like ''%140200%'') )','','14'







-- CREADO ====================================================================================
SELECT d.DebeHaber, d.TotalMonedaBase, d.ImpuestoMonedaBase, IdCategoriaImpuesto, IdImpuesto
	, d.IdLoteTrazable, D.IdLoteTransaccionTrazable, D.IdLoteTransaccionDetalleTrazable
	, p.TotalMonedaBase
FROM Financiero.LoteTransaccionPorPagar as p
INNER JOIN Financiero.LoteTransaccionPorPagarDetalle as d ON p.Id = d.IdTransaccion
WHERE p.IdLote = 2180082;
--
SELECT * FROM Reporte.CTB190_080100 WHERE Cuo = 2180082;


-- LIBERADO ====================================================================================
SELECT * FROM Financiero.ViewLoteDetalle WHERE IdLote IN (2180082);
--
SELECT * FROM Financiero.SaldoDocumento sd (nolock) WHERE IdLote = 2180082;


-- PROGRAMADO ====================================================================================
SELECT Descripcion, OpcionCreacion, Id, * FROM Financiero.ViewLoteTransaccionPagado
WHERE IdCompania = 16 AND IdEstadoLote = 1 AND OpcionCreacion = 'FI.CP.002' -- Listado de programados
--
SELECT * FROM Financiero.ViewLoteTransaccionPagadoDetalle WHERE IdTransaccion = 5334 -- Listado de docs programados


-- PAGOS ====================================================================================
SELECT Id, * FROM Financiero.ViewLoteTransaccionPagado
WHERE IdCompania = 16 AND IdEstadoLote = 1 AND OpcionCreacion = 'FI.CP.003'
--
SELECT * FROM Financiero.ViewPagoIndividualYMasivoParaPagar WHERE idTransaccion = 3637


-- FINAL
SELECT
    LTP.IdLoteTransaccionTrazable, LTP.IdLoteTrazable, ltp.Id, ltp.UsuarioCreacion, ltp.Descripcion, ltp.IdLote, L.IdEstadoLote,
    '|||' as M, dd.Id, dd.IdLoteTransaccionDetalleTrazable, dd.IdLoteTransaccionTrazable, dd.IdLoteTrazable
FROM
    Financiero.LoteTransaccionPagado AS LTP
    LEFT JOIN Financiero.Lote AS L WITH (NOLOCK) ON L.Id = LTP.IdLote
    --LEFT JOIN Financiero.AnioPeriodo AS P ON L.IdPeriodo = P.Id
    --LEFT JOIN Financiero.Anio ON P.IdAnio = Financiero.Anio.Id
    LEFT JOIN Financiero.LoteTransaccionPagadoDetalle as dd ON LTP.Id = dd.IdTransaccion
WHERE
    dd.IdLoteTrazable = 2180082


SELECT LTP.*, dd.* FROM Financiero.LoteTransaccionPagado AS LTP
LEFT JOIN Financiero.Lote AS L WITH (NOLOCK) ON L.Id = LTP.IdLote
LEFT JOIN Financiero.LoteTransaccionPagadoDetalle as dd ON LTP.Id = dd.IdTransaccion
WHERE dd.IdLoteTrazable = 2180082

--
SELECT * FROM Configuracion.EstadoLote
SELECT IdCuentaBancariaBeneficiario, IdEntidadBeneficiario, *
FROM Financiero.LoteTransaccionPagadoDetalle WHERE IdTransaccion IN (3636,3637,3638)
-- // 
-- SELECT * FROM Financiero.ViewPagoIndividualYMasivoParaPagar
-- SELECT * FROM Configuracion.ViewTablaPLE WHERE Reporte = 'ESTADO DE GANANCIAS Y PERDIDAS - PLE'







-- // ************************************************************************************************
-- // ****************************************** CONSULTAS *******************************************
SELECT
	Periodo = RTRIM('202112' + '31'),
	Cuo = RTRIM(vld.Lote),
	Correlativo = 'M' + RTRIM(vld.Detalle),
	TipoDocumento = vld.TipoDocumentoID,
	NumeroDocumento = vld.CodigoEntidad,
	NombreRazonSocial = vld.DescripcionEntidad,
	FechaEmision = CONVERT(VARCHAR, vld.FechaDocumento, 103),
	Saldo = vld.Saldo,
	Estado = '1',
	vld.IdCompania
FROM
(
	SELECT vld.*
		, Saldo = SUM(DebeBase - HaberBase) OVER (PARTITION BY vld.idCompania, vld.idCuenta, vld.idEntidadOficial, vld.Documento)
		, LoteMin = MIN(vld.idlote) OVER (PARTITION BY vld.idCompania, vld.idCuenta, vld.idEntidadOficial, vld.Documento)
	FROM [Financiero].[ViewLoteDetalle] as vld
	WHERE (LEFT(vld.CodigoCuenta,2) = '12' OR LEFT(vld.CodigoCuenta,2) = '13')
		AND vld.DescripcionAnioPeriodo <= ('202112')
		AND vld.idCompania in (16)
) AS vld 
WHERE vld.LoteMin = vld.Lote
-- ORDER BY vld.CodigoCuenta, vld.idEntidadOficial, vld.Documento

-- // --
-- // --

SELECT
	--Periodo = RTRIM(lds.DescripcionAnioPeriodo + '31'),
	Cuo = RTRIM(ld.Lote),
	Correlativo = 'M' + RTRIM(ld.Detalle),
	TipoDocumento = ld.TipoDocumentoID,
	NumeroDocumento = ld.CodigoEntidad,
	NombreRazonSocial = ld.DescripcionEntidad,
	FechaEmision = CONVERT(VARCHAR, ld.FechaDocumento, 103),
	--Saldo = lds.Saldo,
	Estado = '1',
	ld.IdCompania
FROM
(
	SELECT 
		vld.*
		--, Saldo = SUM(DebeBase - HaberBase) OVER (PARTITION BY vld.idCompania, vld.idCuenta, vld.idEntidadOficial, vld.Documento
		--											ORDER BY vld.DescripcionAnioPeriodo ASC)
		, Fila = ROW_NUMBER() OVER (PARTITION BY vld.idCompania, vld.idCuenta, vld.idEntidadOficial, vld.Documento
													ORDER BY vld.DescripcionAnioPeriodo ASC)
	FROM [Financiero].[ViewLoteDetalle] as vld
	WHERE (LEFT(vld.CodigoCuenta,2) = '12' OR LEFT(vld.CodigoCuenta,2) = '13')
) AS ld 

--INNER JOIN (
--	SELECT 
--		vld.*
--		, Saldo = SUM(DebeBase - HaberBase) OVER (PARTITION BY vld.idCompania, vld.idCuenta, vld.idEntidadOficial, vld.Documento
--													ORDER BY vld.DescripcionAnioPeriodo ASC)
--	FROM [Financiero].[ViewLoteDetalle] as vld
--	WHERE (LEFT(vld.CodigoCuenta,2) = '12' OR LEFT(vld.CodigoCuenta,2) = '13')
--) AS lds ON ld.idCompania = lds.idCompania
--	AND ld.idCuenta = lds.idCuenta
--	AND ld.idEntidadOficial = lds.idEntidadOficial
--	AND ld.Documento = lds.Documento

WHERE ld.Fila = 1
	AND ld.idCompania = 16
	AND ld.DescripcionAnioPeriodo <= '202112'
	-- AND lds.DescripcionAnioPeriodo = ('202112')
	-- AND lds.Saldo != 0



SELECT 
	vld.*
	, Saldo = SUM(DebeBase - HaberBase) OVER (PARTITION BY vld.idCompania, vld.idCuenta, vld.idEntidadOficial, vld.Documento
												ORDER BY vld.DescripcionAnioPeriodo ASC)
	, Fila = ROW_NUMBER() OVER (PARTITION BY vld.idCompania, vld.idCuenta, vld.idEntidadOficial, vld.Documento
												ORDER BY vld.DescripcionAnioPeriodo ASC)
FROM [Financiero].[ViewLoteDetalle] as vld
WHERE (LEFT(vld.CodigoCuenta,2) = '12' OR LEFT(vld.CodigoCuenta,2) = '13')
	AND vld.idCompania = 16
	AND vld.DescripcionAnioPeriodo <= '202112'


/*************************************************************************************************/
/***************************************** CONTA *************************************************/
/*************************************************************************************************/
select 
			Tipo						
		,	DescripcionCompania		
		,	DescripcionAnioPeriodo = max(DescripcionAnioPeriodo)
		,	CodigoCuenta				
		,	DescripcionCuenta			
		,	DescripcionMoneda			
		,	CodigoNivel1				
		,	CodigoNivel2				
		,	CodigoNivel3				
		,	CodigoNivel4				
		,	DescripcionNivel1			
		,	DescripcionNivel2			
		,	DescripcionNivel3			
		,	DescripcionNivel4			
		,	CodigoSunat				
		,	m01 = sum(m01)
		,	m02 = sum(m02)
		,	m03 = sum(m03)
		,	m04 = sum(m04)
		,	m05 = sum(m05)
		,	m06 = sum(m06)
		,	m07 = sum(m07)
		,	m08 = sum(m08)
		,	m09 = sum(m09)
		,	m10 = sum(m10)
		,	m11 = sum(m11)
		,	m12 = sum(m12)
		,	IdCompania
		,	Libro				
		,	Moneda				
		,	Compania			
		,	Periodo = max(Periodo)
		,	IdLibro
from Reporte.CTB108 
where DescripcionNivel4 not in (
			'Ventas netas                           -'
		,'Total Costo de Ventas                  -'
		,'UTILIDAD DE OPERACION                  -'
		,'RESULTADO ANTES DE IMPTO RENTA         -'
		,'UTILIDAD BRUTA                         -'
		,'RESULTADO DEL EJERCICIO                -')
	and IdCompania in (15)  and ( (Periodo <= '202112') and (Periodo like '%2021%') and (Moneda like '%PEN%') )
	
group by Tipo						
		,	DescripcionCompania		
		,	CodigoCuenta				
		,	DescripcionCuenta			
		,	DescripcionMoneda			
		,	CodigoNivel1				
		,	CodigoNivel2				
		,	CodigoNivel3				
		,	CodigoNivel4				
		,	DescripcionNivel1			
		,	DescripcionNivel2			
		,	DescripcionNivel3			
		,	DescripcionNivel4			
		,	CodigoSunat				
		,	IdCompania
		,	Libro				
		,	Moneda				
		,	Compania			
		,	IdLibro
order by 1,2,3,4,5,6 

SELECT DISTINCT Reporte FROM Configuracion.ViewTablaPLE;
SELECT * FROM Configuracion.ViewTablaPLE WHERE Reporte = 'ESTADO DE FLUJOS EFECTIVO - PLE';

-- SELECT FORMAT(DATEADD(month, -1, '20210801'), 'MM') AS Result;



/*

	SELECT
			ctbl.DescripcionCompania		
			,	ctbl.CodigoCuenta				
			,	ctbl.DescripcionCuenta			
			,	ctbl.DescripcionMoneda			
			,	ctbl.CodigoNivel1				
			,	ctbl.CodigoNivel2				
			,	ctbl.CodigoNivel3				
			,	ctbl.CodigoNivel4				
			,	ctbl.DescripcionNivel1			
			,	ctbl.DescripcionNivel2			
			,	ctbl.DescripcionNivel3			
			,	ctbl.DescripcionNivel4			
			,	ctbl.CodigoSunat				
			,	ctbl.IdCompania
			,	ctbl.Libro				
			,	ctbl.Moneda				
			,	ctbl.Compania			
			,	ctbl.IdLibro
			,	m01 = sum(m01)
			,	m02 = sum(m02)
			,	m03 = sum(m03)
			,	m04 = sum(m04)
			,	m05 = sum(m05)
			,	m06 = sum(m06)
			,	m07 = sum(m07)
			,	m08 = sum(m08)
			,	m09 = sum(m09)
			,	m10 = sum(m10)
			,	m11 = sum(m11)
			,	m12 = sum(m12)			
			
			,	Periodo = max(Periodo)
	FROM (
		SELECT Tipo      = tp.Reporte  
		  ,DescripcionCompania  = ec.Descripcion  
		  ,DescripcionAnioPeriodo  = ap.Descripcion  
		  ,CodigoCuenta    = tp.n5Codigo  
		  ,DescripcionCuenta   = c.Descripcion  
		  ,DescripcionMoneda   = mo.CodigoISO  
		  ,CodigoNivel1    = tp.n1Codigo  
		  ,CodigoNivel2    = tp.n2Codigo  
		  ,CodigoNivel3    = tp.n3Codigo  
		  ,CodigoNivel4    = tp.n4Codigo  
		  ,DescripcionNivel1   = tp.n1Descripcion  
		  ,DescripcionNivel2   = tp.n2Descripcion  
		  ,DescripcionNivel3   = tp.n3Descripcion  
		  ,DescripcionNivel4   = tp.n4Descripcion  
		  ,CodigoSunat    = ''  
  
		  --,SaldoMes     = sacp.MesSaldo  
		  --,SaldoAcumulado    = sacp.FinalSaldo  
  
		  ,m01 = sum( iif( right(ap.Descripcion,2) = '01' , sacp.MesSaldo , 0.00 ) )  
		  ,m02 = sum( iif( right(ap.Descripcion,2) = '02' , sacp.MesSaldo , 0.00 ) )  
		  ,m03 = sum( iif( right(ap.Descripcion,2) = '03' , sacp.MesSaldo , 0.00 ) )  
		  ,m04 = sum( iif( right(ap.Descripcion,2) = '04' , sacp.MesSaldo , 0.00 ) )  
		  ,m05 = sum( iif( right(ap.Descripcion,2) = '05' , sacp.MesSaldo , 0.00 ) )  
		  ,m06 = sum( iif( right(ap.Descripcion,2) = '06' , sacp.MesSaldo , 0.00 ) )  
		  ,m07 = sum( iif( right(ap.Descripcion,2) = '07' , sacp.MesSaldo , 0.00 ) )  
		  ,m08 = sum( iif( right(ap.Descripcion,2) = '08' , sacp.MesSaldo , 0.00 ) )  
		  ,m09 = sum( iif( right(ap.Descripcion,2) = '09' , sacp.MesSaldo , 0.00 ) )  
		  ,m10 = sum( iif( right(ap.Descripcion,2) = '10' , sacp.MesSaldo , 0.00 ) )  
		  ,m11 = sum( iif( right(ap.Descripcion,2) = '11' , sacp.MesSaldo , 0.00 ) )  
		  ,m12 = sum( iif( right(ap.Descripcion,2) = '12' , sacp.MesSaldo , 0.00 ) )  

		  ,	MesAnterior = sum( iif( right(ap.Descripcion,2) = FORMAT(DATEADD(month, -1, CONCAT(ap.Descripcion,'01')), 'MM') , sacp.MesSaldo , 0.00 ))
		  , DelMes = SUM(sacp.MesSaldo)
  
		  ,sacp.IdCompania  
  
		  ,Libro    = l.Descripcion  
		  ,Moneda    = mo.CodigoISO  
		  ,Compania   = ec.Descripcion  
		  ,Periodo   = ap.Descripcion  
		  ,sacp.IdLibro  
  
		from Configuracion.viewTablaPLE tp  
		  inner join Financiero.Cuenta c  
		  on c.codigo = tp.n5Codigo  
		  inner join Financiero.ViewSaldoAnioCuentaxPeriodo sacp  
			left join Maestros.EntidadCompania ec  
			on ec.Id = sacp.IdCompania  
			left join Financiero.AnioPeriodo ap  
			on ap.Id = sacp.IdAnioPeriodo  
			left join Maestros.Moneda mo  
			on mo.IdMoneda = sacp.IdMoneda  
			left join Configuracion.Libro l  
			on l.id = sacp.IdLibro  
		  on sacp.IdCuenta = c.Id  
		  --and (sacp.MesSaldo != 0 or sacp.FinalSaldo != 0)  
		where   
		  tp.Reporte = 'ESTADO DE GANANCIAS Y PERDIDAS - CONCAR'  
		group by  
		   tp.Reporte  
		  ,ec.Descripcion  
		  ,ap.Descripcion  
		  ,tp.n5Codigo  
		  ,c.Descripcion  
		  ,mo.CodigoISO  
		  ,tp.n1Codigo  
		  ,tp.n2Codigo  
		  ,tp.n3Codigo  
		  ,tp.n4Codigo  
		  ,tp.n1Descripcion  
		  ,tp.n2Descripcion  
		  ,tp.n3Descripcion  
		  ,tp.n4Descripcion  
		  ,sacp.IdCompania  
		  ,l.Descripcion  
		  ,mo.CodigoISO  
		  ,ec.Descripcion  
		  ,ap.Descripcion  
		  ,sacp.IdLibro  
	) as ctbl
	where ctbl.DescripcionNivel4 not in (
				'Ventas netas                           -'
			,'Total Costo de Ventas                  -'
			,'UTILIDAD DE OPERACION                  -'
			,'RESULTADO ANTES DE IMPTO RENTA         -'
			,'UTILIDAD BRUTA                         -'
			,'RESULTADO DEL EJERCICIO                -')
		and ctbl.IdCompania in (15)  and ( (ctbl.Periodo <= '202112') and (ctbl.Moneda like '%PEN%') )
		
	group by ctbl.Tipo						
			,	ctbl.DescripcionCompania		
			,	ctbl.CodigoCuenta				
			,	ctbl.DescripcionCuenta			
			,	ctbl.DescripcionMoneda			
			,	ctbl.CodigoNivel1				
			,	ctbl.CodigoNivel2				
			,	ctbl.CodigoNivel3				
			,	ctbl.CodigoNivel4				
			,	ctbl.DescripcionNivel1			
			,	ctbl.DescripcionNivel2			
			,	ctbl.DescripcionNivel3			
			,	ctbl.DescripcionNivel4			
			,	ctbl.CodigoSunat				
			,	ctbl.IdCompania
			,	ctbl.Libro				
			,	ctbl.Moneda				
			,	ctbl.Compania			
			,	ctbl.IdLibro
*/


-- EXEC [Financiero].[usp_rpt_CTB112] '( (Periodo = ''202112'') )','Admin',15


-- Financiero.usp_rpt_CTB112
-- ( (Periodo = '202112') )



-- =================================================================================================
-- =================================== BALANCE COMPROBACION SOLES DOLARES ==========================
-- =================================================================================================
/*
SELECT * FROM (
	SELECT
		mn.Compania
		, mn.Periodo
		, mn.Libro
		, mn.Cuenta
		, mn.DescripcionCuenta
		, mn.RucCompania

		, IniMn = mn.INIdeb + mn.INIhab
		, MesMn = mn.MESdeb + mn.MEShab
		, FinMn = mn.FINdeb + mn.FINhab

		, IniMe = me.INIdeb + me.INIhab
		, MesMe = me.MESdeb + me.MEShab
		, FinMe = me.FINdeb + me.FINhab

		,	mn.IdCompania
		,	mn.IdAnio
		,	mn.IdAnioPeriodo
		,	mn.IdLibro
		,	mn.IdCuenta

	FROM Reporte.CTB100 as mn (nolock)
	LEFT JOIN Reporte.CTB100 as me (nolock)
		ON mn.IdCompania = me.IdCompania
		AND mn.IdLibro = me.IdLibro
		AND mn.IdAnio = me.IdAnio
		AND mn.IdAnioPeriodo = me.IdAnioPeriodo
		AND mn.IdCuenta = me.IdCuenta
		AND me.Moneda = 'USD'
	WHERE mn.Moneda = 'PEN'
) as ctb

WHERE ( (Periodo like '%202203%') and (Libro like '%OFICIAL%')) AND IdCompania = 18
*/











-- ===============================================================================================
-- I N G R E S O
-- ===============================================================================================
-- 1.1.	INGRESOS DEL MES - DISPONIBLE
SELECT
	vld.idCompania
	, vld.DescripcionCompania
	, Ingreso = SUM(vld.DebeBase)
FROM Financiero.ViewLoteDetalle as vld
WHERE LEFT(vld.CodigoCuenta,3) IN ('101','102','104') AND vld.CodigoAnio = '2022'
GROUP BY vld.idCompania, vld.DescripcionCompania

-- 1.2.	INGRESO COMERCIAL  - DETALLE POR CLIENTE  - MES ACTUAL VS MES AÑO ANTERIOR
SELECT vld.idCompania, vld.DescripcionCompania, SUM(vld.DebeBase) FROM Financiero.ViewLoteDetalle as vld
WHERE LEFT(vld.CodigoCuenta,2) = '104' AND vld.CodigoAnio <= '202211'
GROUP BY vld.idCompania, vld.DescripcionCompania

SELECT IdCompania, * FROM Financiero.ViewDimension WHERE IdTipoDimension = 2
AND Descripcion LIKE '%back%'

SELECT IdCompania, * FROM Financiero.ViewDimension WHERE IdTipoDimension = 1
AND Descripcion LIKE '%back%'
SELECT IdLote, CodigoModulo, * FROM Financiero.ViewLoteDetalle WHERE CodigoCuenta LIKE '79%' AND idCompania = 18
SELECT DISTINCT idCompania FROM Financiero.ViewLoteDetalle

SELECT idCompania, CodigoModulo, IdLote, CodigoCuenta, DescripcionCuenta, DebeBase, HaberBase, Descripcion, FechaContable, FechaDocumento, FechaVencimiento FROM Financiero.ViewLoteDetalle
WHERE IdLote IN (SELECT IdLote FROM Financiero.ViewLoteDetalle WHERE CodigoCuenta LIKE '59%')


-- ==========================================================================================================
-- 3:        P O S I S I O N       C A J A       D I S P O N I B L E
-- ==========================================================================================================
/*SELECT
			Diario = md.DSUBDIA
			, Compro = md.DCOMPRO
			, Secuencia = md.DSECUE
			, Periodo = md.DFECCOM
			, Cuenta = md.DCUENTA
			, Anexo = md.DCODANE
			, md.DCENCOS
			, Moneda = md.DCODMON
			, DH = md.DDH
			, Importe = md.DIMPORT
			, TipoDocumento = md.DTIPDOC
			, NumeroDocumento = md.DNUMDOC
			, FechaDocumento = md.DFECDOC
			, FechaVencimiento = md.DFECVEN
			, Area = md.DAREA
			, md.DFLAG
			, md.DDATE
			, Glosa = md.DXGLOSA
			, ImporteUSA = md.DUSIMPOR
			, ImportePEN = md.DMNIMPOR
		FROM rsconcar.[dbo].[CT0082COMD21] as md*/
-- ===================================================================
-- 3.1 SALDO EN CUENTAS CORRIENTES - DOLARES
	-- BACKOFFICE
		-- Reporte.CTB270_03010
	-- CONCAR
		SELECT
			Empresa = CASE WHEN md.empresa = '0084' THEN 'PCH' WHEN md.empresa = '0001' THEN 'MINEX' WHEN md.empresa = '0002' THEN 'ENPROYEC' WHEN md.empresa = '0003' THEN 'MINCORP' WHEN md.empresa = '0004' THEN 'MINERCOBRE' ELSE '' END
			, EmpresaCodigo = md.empresa
			, Cuenta = DCUENTA
			, Banco = ban.ct_cnomban
			-- , SaldoSoles = SUM(IIF(DDH = 'D', DMNIMPOR, DMNIMPOR * -1))
			, SaldoDolares = SUM(IIF(DDH = 'D', DUSIMPOR, DUSIMPOR * -1))
		FROM produccion.enproyecdb.dbo.asientos_det as md
		LEFT JOIN produccion.enproyecdb.dbo.view_bancos_cuentas AS ban ON ban.empresa = md.empresa AND md.DCUENTA = ban.ct_ccuenta
		WHERE md.DCUENTA LIKE '104%'
		AND md.empresa IN ('0084','0001','0002','0003', '0004')
		AND md.PERIODO_DET = '2022' 
		AND LEFT(md.DCOMPRO, 2) <= '06'
		AND ban.ct_ccodmon = 'US'
		GROUP BY md.empresa, md.DCUENTA, ban.ct_cnomban
		ORDER BY 1,3 -- EN DOLARES

		-- BANOCS         E N P R O Y E C
		-- 104112 -- BCP LIMA		-- US
		-- 104118 -- BCP RP			-- US
		-- 104122 -- BBVA			-- US
		-- 104132 -- INTERBANCK		-- US
		-- 104142 -- BANBIF			-- US
		-- 104152 -- SANTANDER		-- US

		SELECT
			Empresa = CASE WHEN md.empresa = '0084' THEN 'PCH' WHEN md.empresa = '0001' THEN 'MINEX' WHEN md.empresa = '0002' THEN 'ENPROYEC' WHEN md.empresa = '0003' THEN 'MINCORP' WHEN md.empresa = '0004' THEN 'MINERCOBRE' ELSE '' END
			, EmpresaCodigo = md.empresa
			, Cuenta = DCUENTA
			, Banco = ban.ct_cnomban
			, SaldoSoles = SUM(IIF(DDH = 'D', DMNIMPOR, DMNIMPOR * -1))
			-- , SaldoDolares = SUM(IIF(DDH = 'D', DUSIMPOR, DUSIMPOR * -1))
		FROM produccion.enproyecdb.dbo.asientos_det as md
		LEFT JOIN produccion.enproyecdb.dbo.view_bancos_cuentas AS ban ON ban.empresa = md.empresa AND md.DCUENTA = ban.ct_ccuenta
		WHERE md.DCUENTA LIKE '104%'
		AND md.empresa IN ('0084','0001','0002','0003','0004')
		AND md.PERIODO_DET = '2022' 
		AND LEFT(md.DCOMPRO, 2) <= '06'
		AND ban.ct_ccodmon = 'MN'
		GROUP BY md.empresa, md.DCUENTA, ban.ct_cnomban
		ORDER BY 1,3 -- EN SOLES

-- ===================================================================
-- 3.3 DEPOSITOS A PLAZO
	-- BACKOFFICE
		-- [Financiero].[usp_rpt_CTB270_0303]

	-- CONCAR:
		SELECT DIMPORT, DXGLOSA, * FROM rsconcar.[dbo].[CT0082COMD21]
		WHERE DCUENTA LIKE '106%' 
		AND DFECCOM LIKE '2101%'
		AND DSUBDIA != '00'
		AND DCODMON = 'US'
		AND DDH = 'D'

		SELECT
			Empresa = CASE WHEN md.empresa = '0084' THEN 'PCH' WHEN md.empresa = '0001' THEN 'MINEX' WHEN md.empresa = '0002' THEN 'ENPROYEC' WHEN md.empresa = '0003' THEN 'MINCORP' WHEN md.empresa = '0004' THEN 'MINERCOBRE' ELSE '' END
			, EmpresaCodigo = md.empresa
			, Cuenta = DCUENTA
			, md.DIMPORT
			, md.DUSIMPOR
			, md.DMNIMPOR
			, DSUBDIA
			, DCOMPRO
		FROM produccion.enproyecdb.dbo.asientos_det as md
		-- LEFT JOIN produccion.enproyecdb.dbo.view_bancos_cuentas AS ban ON ban.empresa = md.empresa AND md.DCUENTA = ban.ct_ccuenta
		WHERE md.DCUENTA LIKE '106%'
		AND md.empresa IN ('0084','0001','0002','0003','0004')
		AND md.PERIODO_DET = '2021' 
		AND LEFT(md.DCOMPRO, 2) = '01'
		AND DSUBDIA != '00'
		AND md.DDH = 'D'
		AND DCODMON = 'US'
		-- AND ban.ct_ccodmon = 'US'

-- ===================================================================
-- 3.4 FINANCIAMIENTOS BANCARIOS DEL MES
	-- BACKOFFICE
		-- [Financiero].[usp_rpt_CTB270_03040]  
		-- EXEC [Financiero].[usp_rpt_CTB270_03040]   '', '',''
	-- CONCAR:
		SELECT DIMPORT, DXGLOSA, * FROM rsconcar.[dbo].[CT0082COMD21]
		WHERE DCUENTA LIKE '451%' -- AND DIMPORT = '1000000'
		AND DFECCOM LIKE '2101%'
		--AND DSUBDIA != '00'
		AND DCODMON = 'US'
		AND DSUBDIA = '21'

		SELECT
			Empresa = CASE WHEN md.empresa = '0084' THEN 'PCH' WHEN md.empresa = '0001' THEN 'MINEX' WHEN md.empresa = '0002' THEN 'ENPROYEC' WHEN md.empresa = '0003' THEN 'MINCORP' WHEN md.empresa = '0004' THEN 'MINERCOBRE' ELSE '' END
			, EmpresaCodigo = md.empresa
			, Cuenta = DCUENTA
			, md.DIMPORT
			, md.DUSIMPOR
			, md.DMNIMPOR
			, md.DXGLOSA
		FROM produccion.enproyecdb.dbo.asientos_det as md
		WHERE md.DCUENTA LIKE '451%'
		AND md.empresa IN ('0084','0001','0002','0003','0004')
		AND md.PERIODO_DET = '2022' 
		AND LEFT(md.DCOMPRO, 2) = '06'
		-- AND DSUBDIA != '00'
		AND DSUBDIA = '21'



-- ===============================================================================================
--  4:      D E T R A C C I O N
-- ===============================================================================================



-- ===================================================================
-- 4.1.	SALDO DE CUENTAS CORRIENTES - BANCO DE LA NACION   ---------------------------- O J O --  AUN NO CUADRA CON MINEX
	-- BACKOFFICE
		-- Financiero.usp_rpt_CTB270_04010

	-- CONCAR
		-- SALDO ANTERIOR
		SELECT
			Empresa = CASE WHEN md.empresa = '0084' THEN 'PCH' WHEN md.empresa = '0001' THEN 'MINEX' WHEN md.empresa = '0002' THEN 'ENPROYEC' WHEN md.empresa = '0003' THEN 'MINCORP' WHEN md.empresa = '0004' THEN 'MINERCOBRE' ELSE '' END
			, EmpresaCodigo = md.empresa
			-- , Cuenta = DCUENTA
			, SaldoInicialSoles = SUM(IIF(DDH = 'D', DMNIMPOR, DMNIMPOR * -1))
		FROM produccion.enproyecdb.dbo.asientos_det as md
		WHERE md.DCUENTA LIKE '107301%'
		AND md.empresa IN ('0084','0001','0002','0003','0004')
		AND md.PERIODO_DET = '2022' 
		AND LEFT(md.DCOMPRO, 2) < '06'
		-- AND md.DSUBDIA = '00'
		GROUP BY md.empresa

		-- INGRESO - EGRESO
		SELECT
			Empresa = CASE WHEN md.empresa = '0084' THEN 'PCH' WHEN md.empresa = '0001' THEN 'MINEX' WHEN md.empresa = '0002' THEN 'ENPROYEC' WHEN md.empresa = '0003' THEN 'MINCORP' WHEN md.empresa = '0004' THEN 'MINERCOBRE' ELSE '' END
			-- , EmpresaCodigo = md.empresa
			-- , Cuenta = DCUENTA
			, Ingreso = SUM(IIF(md.DDH ='D', DMNIMPOR, 0))
			, Egreso = SUM(IIF(md.DDH ='H', DMNIMPOR, 0))
		FROM produccion.enproyecdb.dbo.asientos_det as md
		WHERE md.DCUENTA LIKE '107301%'
		AND md.empresa IN ('0084','0001','0002','0003','0004')
		AND md.PERIODO_DET = '2022' 
		AND LEFT(md.DCOMPRO, 2) = '06'
		AND md.DSUBDIA != '00'
		GROUP BY md.empresa	


-- ===================================================================
-- 4.2.	INGRESOS DEL MES - DETALLE
	-- BACKOFFICE
		-- 
			-- POR MODULO EFECTIVO, AUTODETRACCION
			-- COBRANZA:    -- CLIENTE    Y    VINCULADA

	-- CONCAR
	-- IO8,IE8                      Cliente
	-- VI8     Vinculada
		SELECT
			Empresa = CASE WHEN md.empresa = '0084' THEN 'PCH' WHEN md.empresa = '0001' THEN 'MINEX' WHEN md.empresa = '0002' THEN 'ENPROYEC' WHEN md.empresa = '0003' THEN 'MINCORP' WHEN md.empresa = '0004' THEN 'MINERCOBRE' ELSE '' END
			, EmpresaCodigo = md.empresa
			-- , Cuenta = DCUENTA
			, md.DNUMDO2
			, Ingreso = SUM(IIF(md.DDH ='D', DMNIMPOR, 0))
			, Cliente = SUM(IIF(TRIM(md.DNUMDO2) IN ('IO8','IE8'),IIF(md.DDH ='D', DMNIMPOR, 0), 0))
			, Vinculada = SUM(IIF(TRIM(md.DNUMDO2) IN ('VI8'),IIF(md.DDH ='D', DMNIMPOR, 0), 0))
			, AutoDetraccion = SUM(IIF(TRIM(md.DNUMDO2) NOT IN ('IO8','IE8','VI8'),IIF(md.DDH ='D', DMNIMPOR, 0), 0))
			-- , Egreso = SUM(IIF(md.DDH ='H', DMNIMPOR, 0))
		FROM produccion.enproyecdb.dbo.asientos_det as md
		WHERE md.DCUENTA LIKE '107301%'
		AND md.empresa IN ('0084','0001','0002','0003','0004')
		AND md.PERIODO_DET = '2022' 
		AND LEFT(md.DCOMPRO, 2) = '06'
		AND md.DSUBDIA != '00'
		GROUP BY md.empresa, md.DNUMDO2	
		ORDER BY 1,2



-- ===================================================================
-- 4.2.	INGRESOS DEL MES - DETALLE
	-- BACKOFFICE
	-- CONCAR

-- ===================================================================
-- 4.3.	EGRESOS DEL MES - DETALLE
	-- BACKOFFICE
	-- CONCAR

-- ===================================================================
-- 4.4.	RECUPERACION DE DETRACCIONES - MES ACTUAL VS MES AÑO ANTERIOR
	-- BACKOFFICE
	-- CONCAR


		-- EGRESO POR = LIBERACION - PAGO IMPUESTOS
		-- Cuando Su contrapartida es la 104 = Liberacion de fondos
		-- Cuando su contrapartida es la 40 pago de impuesto
		SELECT DXGLOSA, DIMPORT, DNUMDO2,  * FROM rsconcar.[dbo].[CT0082COMD21] WHERE DCUENTA LIKE '107%' AND DSUBDIA != '00' AND DDH = 'H' AND DFECCOM LIKE '2101%' AND DCODMON = 'MN'
		GROUP BY DNUMDO2




--  18636 
--	18645.74
/*
SELECT 
	-- Egreso = SUM(DUSIMPOR)
	*
FROM produccion.enproyecdb.dbo.asientos_det AS md (NOLOCK)
WHERE (DSUBDIA + DCOMPRO) IN (SELECT DSUBDIA + DCOMPRO FROM produccion.enproyecdb.dbo.asientos_det WITH (NOLOCK) WHERE empresa = '0004' AND DCUENTA LIKE '104%')
-- AND md.DCUENTA LIKE '107301%'
AND md.empresa = '0004'
AND md.PERIODO_DET = '2021' 
AND LEFT(md.DCOMPRO, 2) = '01'
AND md.DSUBDIA != '00'
--
AND md.DCUENTA NOT LIKE '104%'
AND md.DCUENTA LIKE '421220%'
AND md.DTIPDOC = 'DR'
AND md.DDH = 'D'
*/


/*
'0084' => 'PCH'
'0001' => 'MINEX'
'0002' => 'ENPROYEC'
'0003' => 'MINCORP'
'0004' => 'MINERCOBRE'
*/
-- // 18636 // 18638.00

-- ===============================================================================================
--  2:      E G R E S O S
-- ===============================================================================================



-- ===================================================================
-- 2.3.	PAGO DE DETRACCIONES TERCEROS - MES ACTUAL VS MES AÑO ANTERIOR
	-- BACKOFFICE
		-- [Financiero].[usp_rpt_CTB270_02030]

	-- CONCAR
		SELECT 
			Egreso = SUM(DUSIMPOR)
			-- *
		FROM produccion.enproyecdb.dbo.asientos_det AS md (NOLOCK)
		WHERE (DSUBDIA + DCOMPRO) IN (SELECT DSUBDIA + DCOMPRO FROM produccion.enproyecdb.dbo.asientos_det WITH (NOLOCK) WHERE empresa = '0003' AND DCUENTA LIKE '104%')
		AND md.empresa = '0003'
		AND md.PERIODO_DET = '2022' 
		AND LEFT(md.DCOMPRO, 2) = '06'
		-- AND md.DSUBDIA != '00'
		AND md.DCUENTA NOT LIKE '104%'
		-- AND md.DCUENTA LIKE '421220%'
		AND md.DTIPDOC = 'DR'
		AND md.DDH = 'D'
		AND md.DSUBDIA = '22'
		-- 
		AND md.DCODANE NOT IN ('20100030595','00517031624','10175243661','10105132846','10455751646','10439568467','10453766247','10453880414','10013181379','10463794567','10447489231','20604033404','20604033536','20330791170','20517031624','20518915119','20524561264','10072781193','20602345573','10062823581','20517347184','20545870585','20554452907','20554397299')



-- ===================================================================
-- 2.4.	PLANILLA DE SUELDOS - MES AACTUAL VS MES AÑO ANTERIOR
	-- BACKOFFICE
		-- EXEC [Financiero].[usp_rpt_CTB270_02040] '','',''
	-- CONCAR
		SELECT 
			Egreso = SUM(DUSIMPOR)
			-- *
		FROM produccion.enproyecdb.dbo.asientos_det AS md (NOLOCK)
		WHERE (DSUBDIA + DCOMPRO) IN (SELECT DSUBDIA + DCOMPRO FROM produccion.enproyecdb.dbo.asientos_det WITH (NOLOCK) WHERE empresa = '0003' AND DCUENTA LIKE '104%')
		AND md.empresa = '0003'
		AND md.PERIODO_DET = '2022' 
		AND LEFT(md.DCOMPRO, 2) = '06'
		-- AND md.DSUBDIA != '00'
		AND md.DCUENTA NOT LIKE '104%'
		AND md.DCUENTA LIKE '411101%'
		AND md.DDH = 'D'
		AND md.DSUBDIA = '22'
		-- 



