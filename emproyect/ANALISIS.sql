SELECT * FROM [Configuracion].[DiccionarioTabla] WHERE Vista LIKE '%ViewLoteTransaccionPorPagar%' -- Lista de toda las tablas
-- Vista: Vista que reprecenta la tabla
-- Tabla: Nombre de la tabla
-- Pantalla: Nombre de la pantalla en la que se pinta
-- IdComboGeneral: ------
-- ValorComboGeneral: ------
-- DescripcionComboGeneral: ------

SELECT * FROM [Configuracion].[DiccionarioCampo] -- Lista de toda las columnas de una tabla
-- Obligatorio		:
-- Auditable		:
-- Orden			:
-- Visisble			: N -> Oculto, S -> Visible, E -> Excluido
-- Tipo: El tipo de dato que representa en frontend



-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
-- ANALISIS EXCEL
-----------------------------------------------------------------------------------

--  https://sqlspreads.com/			-> es una herramienta pagada. permite




-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
-- ANALISIS PIVOT CHART
-----------------------------------------------------------------------------------
-- 
-- https://github.com/ObservedObserver/pivot-chart
-- https://nnajm.github.io/orb/

-- https://rowsncolumns.github.io/grid/?path=/story/grid--base-grid
	-- Es una grilla parecido a excel, esta orientado mas para imitar el comportamiento de una cuadricula excel.
	-- Tiene agrupaciond e columnas, Editar en las celdas, incrustar graficos y formas
	-- Solo para REACT JS.
-- https://github.com/TanStack/react-table								: React Table V8
	-- Es una grilla para react muy basico: SOLO REACT
-- https://github.com/davidguttman/react-pivot							: React Pivot
	-- Es un pivot de tabla muy basico: SOLO REACT
-- https://github.com/erfangc/GigaGrid									: GigaGrid
	-- Es un tabla que permite agrupaciones y subtotales basico: SOLO REACT

-- REGULAR FREE
-- https://github.com/turnerniles/react-virtualized-pivot				: react-virtualized-pivot
	-- Permite agrupacion por columna fila y operaciones de agregacion 
	-- promedio, suma, maximo, minimo, contar, pero con una solo valor de calculo
	-- FALTA MUCHO POR MEJORAR.
-- https://nnajm.github.io/orb/index.html								: ORB JS
	-- Permite agrupacion por columna, fila, con filtros,
	-- valores, todo grag and drop: Le falta almacenamiento
	-- de la configuracion o cambiar el tipo de operacion a realizar SOLO REACT

-- BUENOS FREE
-- https://www.webdatarocks.com/                                        : webdatarocks
    -- Es una libreria que permite crear tablas pivot muy buenos pero solo de archivos, cvc, json: archivos plano.


-- PREMIUN
-- https://www.syncfusion.com/react-ui-components/react-pivot-table		: Syncfusion
-- https://www.ag-grid.com/												: Ag Grid
-- https://www.flexmonster.com/											: Flexmoster
-- https://www.gooddata.com/											: GoodData
-- https://www.grapecity.com/											: grapecity
-- https://www.jqwidgets.com/											: jqwidgets

SELECT dc.* FROM Configuracion.DiccionarioCampo as dc
INNER JOIN Configuracion.DiccionarioTabla as dt ON dc.IdTabla = dt.Id
WHERE IIf(Left('ViewLoteTransaccionPorPagar', 4) = 'View', dt.Vista, dt.Pantalla) = 'ViewLoteTransaccionPorPagar'



-- // COMO SIEMPRE
/*
------------------------------------
== CREACION DE TABLAS --------------

CREATE SCHEMA Setting;

CREATE TABLE Setting.TableDiconaries (
  id         BIGINT NOT NULL IDENTITY PRIMARY KEY,
  ViewName   VARCHAR(100) DEFAULT '',
  TableName  VARCHAR(100) DEFAULT '',
);



*/






-- ***********************************************************************************************
-- Situacion Financiera
-- ***********************************************************************************************
-- CTB105: Situacion Financiera
	-- CTB105 --// CTB105/15/(%20(Periodo%20like%20'%25202111%25')%20) // Peridodo 202111
		-- CTB200: An�lisis de Cuenta


-- ***********************************************************************************************
-- CTB105: Situacion Financiera

SELECT
    ctb.CodigoCuenta,
    ctb.DescripcionCuenta,
    ctb.SaldoAcumulado
FROM
    (
        select
            Tipo = tp.Reporte,
            DescripcionCompania = ec.Descripcion,
            DescripcionAnioPeriodo = ap.Descripcion,
            CodigoCuenta = tp.n5Codigo,
            DescripcionCuenta = c.Descripcion,
            DescripcionMoneda = mo.CodigoISO,
            CodigoNivel1 = tp.n1Codigo,
            CodigoNivel2 = tp.n2Codigo,
            CodigoNivel3 = tp.n3Codigo,
            CodigoNivel4 = tp.n4Codigo,
            DescripcionNivel1 = tp.n1Descripcion,
            DescripcionNivel2 = tp.n2Descripcion,
            DescripcionNivel3 = tp.n3Descripcion,
            DescripcionNivel4 = tp.n4Descripcion,
            CodigoSunat = '',
            SaldoMes = sacp.MesSaldo,
            SaldoAcumulado = sacp.FinalSaldo,
            sacp.IdCompania,
            Libro = l.Descripcion,
            Moneda = mo.CodigoISO,
            Compania = ec.Descripcion,
            Periodo = ap.Descripcion,
            sacp.IdLibro
        from
            Configuracion.viewTablaPLE tp
            inner join Financiero.Cuenta c on c.codigo = tp.n5Codigo
            inner join Financiero.ViewSaldoAnioCuentaxPeriodo sacp
            left join Maestros.EntidadCompania ec on ec.Id = sacp.IdCompania
            left join Financiero.AnioPeriodo ap on ap.Id = sacp.IdAnioPeriodo
            left join Maestros.Moneda mo on mo.IdMoneda = sacp.IdMoneda
            left join Configuracion.Libro l on l.id = sacp.IdLibro on sacp.IdCuenta = c.Id --and (sacp.MesSaldo != 0 or sacp.FinalSaldo != 0)  
        where
            tp.Reporte = 'SITUACION FINANCIERA - CONCAR'
    ) as ctb
WHERE
    ctb.IdCompania = 15
    AND ctb.Periodo = '202111'
    AND ctb.Moneda = 'PEN' -- AND ctb.DescripcionNivel2 = 'ACTIVO

-- ***********************************************************************************************
-- CTB200: An�lisis de Cuenta
SELECT
    SUM(DebeBase),
    SUM(HaberBase),
    SUM(DebeBase - HaberBase)
FROM
    (
        select
            PeriodoInicio = '',
            PeriodoFin = '',
            Tipo = 'MO',
            SaldoDocumentoBase = 0,
            SaldoDocumentoSistema = 0,
            ld.CodigoCompania,
            ld.DescripcionCompania,
            ld.CodigoCuenta,
            ld.DescripcionCuenta,
            ld.CodigoEntidad,
            ld.DescripcionEntidad,
            ld.Documento,
            ld.CodigoModulo,
            ld.Lote,
            ld.Transaccion,
            ld.FechaDocumento,
            ld.FechaVencimiento,
            ld.Descripcion,
            ld.CodigoMonedaTransaccion,
            ld.DebeBase,
            ld.HaberBase,
            ld.DebeSistema,
            ld.HaberSistema,
            ld.DescripcionAnioPeriodo,
            ld.idCompania,
            ld.Estado,
            ld.CodigoDiario,
            ld.CodigoLibro,
            ld.DescripcionLibro,
            Periodo = p.Descripcion
        from
            Financiero.ViewLoteDetalle ld
            INNER JOIN Financiero.Anio a (NOLOCK) on a.IdCompania = ld.IdCompania
            AND a.id = ld.IdAnio
            INNER JOIN Financiero.AnioPeriodo p (NOLOCK) on p.idAnio = ld.IdAnio
            AND p.id = ld.IdAnioPeriodo
        WHERE
            ld.CodigoCuenta like '104112%'
            AND ld.idCompania = 15
            AND p.Descripcion <= '202111'
    ) as consutlaReporte



-- ***********************************************************************************************
/*
https://businesscentral.dynamics.com

https://docs.microsoft.com/es-es/learn/

-- // Analizar
[Reporte].[CTB100]
[Reporte].[CTB104]
Financiero.ViewLoteDetalleBalanceComprobacion

-- // Para otros fines
[Reporte].[CTB107]
Financiero.ViewSaldoAnioCuenta  

-- ==
 * Empresa
	* Libro
		* Anio
			* Periodo
				* Cuenta
					* Moneda
						- Mes1, Acumulado1


						SELECT * FROM Financiero.Ple
SELECT
 SUM(Saldo) as resultado
FROM (
SELECT 
		TXT = RTRIM(a.codigo) + RTRIM(p.Codigo) + CONVERT(VARCHAR, day(dateadd(dd,-1,convert(DATE, a.codigo + CASE WHEN p.codigo < '12' THEN right('00' + rtrim(convert(NUMERIC(2), p.Codigo) + 1),2) ELSE '01' END + '01', 112 ))))
		+ '|' + RTRIM(vlde.detalle)
		+ '|' + 'M' + RTRIM(vlde.detalle)
		+ '|' + RTRIM(c.Codigo)
		+ '|' + RTRIM(e.IdTipoEntidad)
		+ '|' + RTRIM(e.IdEntidad)
		+ '|' + RTRIM(e.IdEntidad)
		+ '|' + RTRIM(e.NombreRazonSocial)
		+ '|' + CONVERT(VARCHAR,CONVERT(decimal(14,2), vlde.Saldo))
		+ '|' + '1' + '|'

	, Periodo = RTRIM(a.codigo) + RTRIM(p.Codigo) + CONVERT(VARCHAR, day(dateadd(dd,-1,convert(DATE, a.codigo + CASE WHEN p.codigo < '12' THEN right('00' + rtrim(convert(NUMERIC(2), p.Codigo) + 1),2) ELSE '01' END + '01', 112 ))))
	, Cuo = RTRIM(vlde.detalle)
	, Correlativo = 'M' + RTRIM(vlde.detalle)
	, c.Codigo
	, TipoDocumento = e.IdTipoEntidad
	, e.IdTipoEntidad
	, CodigoTrabajador = e.IdTipoEntidad
	, e.NombreRazonSocial
	, Saldo = CONVERT(decimal(14,2), vlde.Saldo)
	, Estado = 1
	, Compania = ec.Descripcion
	, vlde.IdCompania
		
FROM Financiero.ViewLoteDetalleEntidadxPeriodo as vlde
INNER JOIN Financiero.Cuenta c (NOLOCK) ON c.IdCompania = vlde.IdCompania AND c.id = vlde.IdCuenta
INNER JOIN Financiero.Anio a (NOLOCK) ON a.IdCompania = vlde.IdCompania AND a.id = vlde.IdAnio
INNER JOIN Financiero.AnioPeriodo p (NOLOCK) ON p.idAnio = vlde.IdAnio AND p.id = vlde.IdAnioPeriodo
--
INNER JOIN Maestros.Entidad e (NOLOCK) ON e.IdEntidad = vlde.CodigoEntidad
INNER JOIN Maestros.EntidadCompania ec on ec.Id = vlde.IdCompania
-- Condicional - tests
WHERE vlde.IdCompania = 15 AND p.Descripcion = '202112' AND c.Codigo LIKE '41%'

) as ctb

*/