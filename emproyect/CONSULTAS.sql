select 
		TXT = rtrim(d.CodigoCuenta)
	+	'|'+ convert( varchar, isnull(d.idarticulo,'') )
	+	'|'+ convert( varchar, convert( decimal(16,3), sum(cantidad) ) )
	+	'|'+ convert( varchar, sum(DebeBase - HaberBase))

	,	d.CodigoCuenta
	,	d.idarticulo
	,	CantidadExistencia = sum(cantidad)
	,	CostoTotal = sum(DebeBase - HaberBase)
from
		Financiero.ViewLoteDetalle d
where	
		d.DescripcionAnioPeriodo <= '2021-09'
	and d.CodigoDiario not in ('00','99')
	and	left(d.CodigoCuenta,2) in ('20','21')
	--and	left(d.CodigoCuenta,2) in ('30')
	--and	left(d.CodigoCuenta,2) in ('34')
group by 
		d.CodigoCuenta
	,	d.idarticulo







-- *****************************************************************************************
-- *****************************************************************************************
-- 3.7
SELECT 
		-- TOP 100 
		TXT = RTRIM(a.Codigo) + RTRIM(p.Codigo) + RTRIM(day(dateadd(dd,-1,convert(date,a.codigo+case when p.codigo <'12' then right('00'+rtrim(convert(numeric(2),p.Codigo)+1),2) else '01' end +'01',112))))
			+ '|' + RTRIM(ce.Codigo)					-- campo 2
			+ '|' + '1'									-- campo 3
			+ '|' + RTRIM(ISNULL(ar.Codigo,''))			-- campo 4

			+ '|' + RTRIM(ce.Codigo)					-- campo 5
			+ '|' + RTRIM(ISNULL(ar.Codigo,''))			-- campo 6
			+ '|' + RTRIM(ISNULL(ar.Descripcion,''))	-- campo 7
			+ '|' + RTRIM(ISNULL(u.UnidadSunat,''))		-- campo 8
			+ '|' + '1'									-- campo 9 -- Promedio Ponderado
			+ '|' + CONVERT(varchar,convert(int,mp.CantidadExistencia))				-- campo 10
			+ '|' + CONVERT(varchar,convert(decimal(20,8),mp.CostoUnitario))		-- campo 11
			+ '|' + CONVERT(varchar,convert(decimal(20,8),mp.CostoTotal))			-- campo 12
			+ '|' + '1' + '|'
	, Periodo = RTRIM(a.Codigo) + RTRIM(p.Codigo) + RTRIM(day(dateadd(dd,-1,convert(date,a.codigo+case when p.codigo <'12' then right('00'+rtrim(convert(numeric(2),p.Codigo)+1),2) else '01' end +'01',112))))
	, CodigoCatalogo = ce.Codigo
	, TipoExistencia = '1'
	, CodigoArticulo = ar.Codigo
	, ar.Descripcion

	-- UNIDAD
	, u.UnidadSunat
	, MetodoValuacion = '1' -- Promedio Ponderado
	, mp.CantidadExistencia
	, mp.CostoUnitario
	, mp.CostoTotal
	, Estado = '1'
FROM Financiero.ViewLoteDetalleMercaderiaProductoxPeriodo mp
INNER JOIN Financiero.Cuenta c (NOLOCK) on c.IdCompania= mp.IdCompania and c.id = mp.IdCuenta   
INNER JOIN Financiero.Anio a (NOLOCK) on a.IdCompania = mp.IdCompania and a.id = mp.IdAnio
INNER JOIN Financiero.AnioPeriodo P (NOLOCK) on p.idAnio = mp.IdAnio and p.id = mp.IdAnioPeriodo
INNER JOIN Sunat.T13CatalogoExistencia ce (NOLOCK) on ce.Id = '1'
LEFT JOIN Maestros.Articulo ar (NOLOCK) on ar.Id = mp.IdArticulo
LEFT JOIN Maestros.UnidadMedida u (NOLOCK) on mp.IdUnidadMedida = u.IdUnidadMedida
LEFT JOIN Sunat.T06CodigoUnidadMedida cu (NOLOCK) on u.UnidadSunat = cu.Codigo
WHERE
	mp.CodigoDiario not in ('00','99') AND
	(mp.CodigoCuenta LIKE '20%' OR mp.CodigoCuenta LIKE '21%' )


-- *****************************************************************************************
-- *****************************************************************************************
-- 3.9    
SELECT
    TOP 1000
	TXT = RTRIM(a.codigo) + RTRIM(p.Codigo) + RTRIM(day(
        dateadd(
            dd,
            -1,
            convert(
                date,
                a.codigo +case
                    when p.codigo < '12' then right(
                        '00' + rtrim(convert(numeric(2), p.Codigo) + 1),
                        2
                    )
                    else '01'
                end + '01',
                112
            )
        )
    ))
	+'|'+ RTRIM(pp.Detalle)
	+'|'+ 'M' + RTRIM(pp.Detalle)
	+'|'+ RTRIM(FechaInicio)
	+'|'+ RTRIM(CodigoCuenta)
	+'|'+ RTRIM(ISNULL(ar.Descripcion,'ART'))
	+'|'+ CONVERT(varchar,CONVERT(decimal(12,2),Valor))
	+'|'+ CONVERT(varchar,CONVERT(decimal(12,2),Amortizacion))
	+'|'+ '8' + '|',
	Anio = a.codigo,
    Mes = p.Codigo,
    Dia = day(
        dateadd(
            dd,
            -1,
            convert(
                date,
                a.codigo +case
                    when p.codigo < '12' then right(
                        '00' + rtrim(convert(numeric(2), p.Codigo) + 1),
                        2
                    )
                    else '01'
                end + '01',
                112
            )
        )
    ),
    Cuo = RTRIM(Detalle),
    Correlativo = 'M' + RTRIM(Detalle),
    FechaInicio,
    CodigoCuenta,
    Intangible = ar.Descripcion,
    Valor,
	Amortizacion,
	Estado = '8'
FROM
    (
        SELECT
            vld.idCompania,
            vld.idLibro,
            vld.idAnio,
            vld.idAnioPeriodo,
            vld.idCuenta,
            vld.IdArticulo,
            vld.CodigoCuenta,
            Lote = max(vld.Lote),
            Detalle = max(vld.Detalle),
            FechaInicio = min(vld.FechaDocumento),
            Valor = sum(vld.DebeBase - vld.HaberBase),
            Amortizacion = 0
        FROM
            Financiero.ViewLoteDetalle vld
        WHERE
            vld.CodigoDiario not in ('00', '99')
        GROUP by
            vld.idCompania,
            vld.idLibro,
            vld.idAnio,
            vld.idAnioPeriodo,
            vld.idCuenta,
            vld.IdArticulo,
            vld.CodigoCuenta
    ) pp
    INNER JOIN Financiero.Cuenta c (NOLOCK) on c.IdCompania = pp.IdCompania
    and c.id = pp.IdCuenta
    INNER JOIN Financiero.Anio a (NOLOCK) on a.IdCompania = pp.IdCompania
    and a.id = pp.IdAnio
    INNER JOIN Financiero.AnioPeriodo P (NOLOCK) on p.idAnio = pp.IdAnio
    and p.id = pp.IdAnioPeriodo
    LEFT JOIN Maestros.Articulo ar (NOLOCK) on ar.Id = pp.IdArticulo


-- *****************************************************************************************
-- *****************************************************************************************
-- 3.11
SELECT TOP 10
	TXT = RTRIM(cc.anio) + RTRIM(cc.mes) + RTRIM(cc.dia)
	+'|'+ RTRIM(cc.detalle)
	+'|'+ 'M' + RTRIM(cc.detalle)
	+'|'+RTRIM(cc.cuenta)
	+'|'+RTRIM(t2.Codigo)
	+'|'+RTRIM(cc.codigoEntidad)
	+'|'+RTRIM(cc.codigoEntidad)
	+'|'+RTRIM(e.NombreRazonSocial)
	+'|'+CONVERT(varchar,CONVERT(decimal(12,2), SUM(cc.saldoDebe - cc.saldoHaber)))
	+'|'+'1'+'|'

	, Periodo = RTRIM(cc.anio) + RTRIM(cc.mes) + RTRIM(cc.dia)
	, Cuo = RTRIM(cc.detalle)
	, Correlativo = 'M' + RTRIM(cc.detalle)
	, cc.Cuenta
	, TipoDocumento = t2.Codigo
	, cc.CodigoEntidad
	, cc.CodigoEntidad
	, e.NombreRazonSocial
	, Saldo = CONVERT(varchar,CONVERT(decimal(12,2), SUM(cc.saldoDebe - cc.saldoHaber)))
	, Estado = 1
FROM
    (
        SELECT
            s.lote,
            s.detalle,
            a.codigo anio,
            p.Codigo mes,
            a.Descripcion,
            a.IdCompania,

            s.IdCuenta,
            c.codigo cuenta,
            s.codigoEntidad,
            s.debe debe,
            s.haber haber,
            SaldoDebe = case
                when sacp.FinalSaldo + (s.debe - s.haber) > 0 then sacp.FinalSaldo + (s.debe - s.haber)
                else 0
            end,
            SaldoHaber = case
                when sacp.FinalSaldo + (s.debe - s.haber) < 0 then sacp.FinalSaldo + (s.debe - s.haber)
                else 0
            end,
            day(
                dateadd(
                    dd,
                    -1,
                    convert(
                        date,
                        a.codigo +case
                            when p.codigo < '12' then right(
                                '00' + rtrim(convert(numeric(2), p.Codigo) + 1),
                                2
                            )
                            else '01'
                        end + '01',
                        112
                    )
                )
            ) dia
        From
            Financiero.ViewLoteDetalleEntidadxPeriodo s (NOLOCK)
            INNER JOIN Financiero.Cuenta c (NOLOCK) on c.IdCompania = s.IdCompania
            AND c.id = s.IdCuenta
            INNER JOIN Financiero.Anio a (NOLOCK) on a.IdCompania = s.IdCompania
            AND a.id = s.IdAnio
            INNER JOIN Financiero.AnioPeriodo p (NOLOCK) on p.idAnio = s.IdAnio
            AND p.id = s.IdAnioPeriodo
            INNER JOIN Sunat.T22CatalogoEstadoFinanciero F (NOLOCK) on F.Id = 1
            INNER JOIN financiero.viewSaldoAnioCuentaxPeriodo sacp (NOLOCK) on sacp.IdAnio = s.idAnio 
		WHERE c.codigo LIKE '41%'
    ) cc

INNER JOIN Maestros.Entidad e ON e.IdEntidad = cc.CodigoEntidad
INNER JOIN Sunat.T02TipoDocumentoIdentidad t2 ON e.IdTipoEntidad = t2.Id
GROUP BY
    cc.idcompania,
    cc.anio,
    cc.mes,
    cc.dia,
	cc.cuenta,
	cc.codigoEntidad,
	e.IdEntidad,
	e.NombreRazonSocial,
	cc.lote,
	cc.detalle,
	t2.Codigo

-- *****************************************************************************************
-- *****************************************************************************************
-- 3.14
SELECT TOP 10
	TXT = RTRIM(cc.anio) + RTRIM(cc.mes) + RTRIM(cc.dia)
	+'|'+ RTRIM(cc.detalle)
	+'|'+ 'M' + RTRIM(cc.detalle)
	+'|'+RTRIM(cc.cuenta)
	+'|'+RTRIM(t2.Codigo)
	+'|'+RTRIM(cc.codigoEntidad)
	+'|'+RTRIM(e.NombreRazonSocial)
	+'|'+CONVERT(varchar,CONVERT(decimal(12,2), SUM(cc.saldoDebe - cc.saldoHaber)))
	+'|'+'1'+'|'

	, Periodo = RTRIM(cc.anio) + RTRIM(cc.mes) + RTRIM(cc.dia)
	, Cuo = RTRIM(cc.detalle)
	, Correlativo = 'M' + RTRIM(cc.detalle)
	, cc.Cuenta
	, TipoDocumento = t2.Codigo
	, cc.CodigoEntidad
	, e.NombreRazonSocial
	, Saldo = CONVERT(varchar,CONVERT(decimal(12,2), SUM(cc.saldoDebe - cc.saldoHaber)))
	, Estado = 1
FROM
    (
        SELECT
            s.lote,
            s.detalle,
            a.codigo anio,
            p.Codigo mes,
            a.Descripcion,
            a.IdCompania,

            s.IdCuenta,
            c.codigo cuenta,
            s.codigoEntidad,
            s.debe debe,
            s.haber haber,
            SaldoDebe = case
                when sacp.FinalSaldo + (s.debe - s.haber) > 0 then sacp.FinalSaldo + (s.debe - s.haber)
                else 0
            end,
            SaldoHaber = case
                when sacp.FinalSaldo + (s.debe - s.haber) < 0 then sacp.FinalSaldo + (s.debe - s.haber)
                else 0
            end,
            day(
                dateadd(
                    dd,
                    -1,
                    convert(
                        date,
                        a.codigo +case
                            when p.codigo < '12' then right(
                                '00' + rtrim(convert(numeric(2), p.Codigo) + 1),
                                2
                            )
                            else '01'
                        end + '01',
                        112
                    )
                )
            ) dia
        From
            Financiero.ViewLoteDetalleEntidadxPeriodo s (NOLOCK)
            INNER JOIN Financiero.Cuenta c (NOLOCK) on c.IdCompania = s.IdCompania
            AND c.id = s.IdCuenta
            INNER JOIN Financiero.Anio a (NOLOCK) on a.IdCompania = s.IdCompania
            AND a.id = s.IdAnio
            INNER JOIN Financiero.AnioPeriodo p (NOLOCK) on p.idAnio = s.IdAnio
            AND p.id = s.IdAnioPeriodo
            INNER JOIN Sunat.T22CatalogoEstadoFinanciero F (NOLOCK) on F.Id = 1
            INNER JOIN financiero.viewSaldoAnioCuentaxPeriodo sacp (NOLOCK) on sacp.IdAnio = s.idAnio 
		WHERE c.codigo LIKE '47%'
    ) cc

INNER JOIN Maestros.Entidad e ON e.IdEntidad = cc.CodigoEntidad
INNER JOIN Sunat.T02TipoDocumentoIdentidad t2 ON e.IdTipoEntidad = t2.Id
GROUP BY
    cc.idcompania,
    cc.anio,
    cc.mes,
    cc.dia,
	cc.cuenta,
	cc.codigoEntidad,
	e.IdEntidad,
	e.NombreRazonSocial,
	cc.lote,
	cc.detalle,
	t2.Codigo


-- *****************************************************************************************
-- *****************************************************************************************
-- 3.15
SELECT 
	TXT = RTRIM(a.codigo) + RTRIM(p.Codigo) + RTRIM(CONVERT(varchar,DAY(CONVERT(date, vld.FechaDocumento,103))))
	 + '|' + RTRIM(vld.Detalle)
	 + '|' + 'M' + RTRIM(vld.Detalle)
	 + '|' + RTRIM(CONVERT(varchar,t10.Codigo))
	 + '|' + RTRIM(ISNULL(vld.Serie,''))
	 + '|' + RTRIM(ISNULL(vld.Numero,''))
	 + '|' + RTRIM(vld.CodigoCuenta)
	 + '|' + RTRIM(vld.Descripcion)
	 + '|' + '0'
	 + '|' + '0'
	 + '|' + '0'
	 + '|' + '1' + '|'

	 , Periodo = RTRIM(a.codigo) + RTRIM(p.Codigo) + RTRIM(CONVERT(varchar,DAY(CONVERT(date, vld.FechaDocumento,103))))
	, Cuo = RTRIM(vld.Detalle)
	, Correlativo = 'M' + RTRIM(vld.Detalle)
	, TipoComprobante = RTRIM(CONVERT(varchar,t10.Codigo))
	, Serie = RTRIM(vld.Serie)
	, Numero = RTRIM(vld.Numero)
	, Cuenta = RTRIM(vld.CodigoCuenta)
	, Descripcion = RTRIM(vld.Descripcion)
	, SaldoFinal = CONVERT(decimal(12,2), 0)
	, Adiciones = CONVERT(decimal(12,2), 0)
	, Deduciones = CONVERT(decimal(12,2), 0)
	, Estado = '1'
FROM Financiero.ViewLoteDetalle as vld
INNER JOIN Financiero.Cuenta c (NOLOCK) on c.IdCompania = vld.IdCompania
AND c.id = vld.IdCuenta
INNER JOIN Financiero.Anio a (NOLOCK) on a.IdCompania = vld.IdCompania
AND a.id = vld.IdAnio
INNER JOIN Financiero.AnioPeriodo p (NOLOCK) on p.idAnio = vld.IdAnio
AND p.id = vld.IdAnioPeriodo
INNER JOIN Sunat.T10TipoComprobante t10 (NOLOCK) ON  t10.Id = vld.IdT10TipoComprobante
WHERE vld.CodigoCuenta LIKE '37%' OR vld.CodigoCuenta LIKE '49%'


SELECT scp.* FROM Financiero.ViewLoteDetalle AS vld
INNER JOIN financiero.viewSaldoAnioCuentaxPeriodo AS scp ON vld.idCuenta = scp.IdCuenta AND vld.idCompania = scp.IdCompania
WHERE vld.CodigoCuenta LIKE '49%'

-- *****************************************************************************************
-- *****************************************************************************************
-- 6.1

SELECT
	TXT = RTRIM(a.codigo) + RTRIM(p.Codigo) + RTRIM(CONVERT(varchar,DAY(CONVERT(date, vld.FechaDocumento,103))))
		 + '|' + RTRIM(vld.Detalle)
		 + '|' + 'M' + RTRIM(vld.Detalle)
		 + '|' + RTRIM(vld.CodigoCuenta)
		 + '|' + ''
		 + '|' + ''
		 + '|' + RTRIM(vld.CodigoT04TipoMoneda)
		 + '|' + RTRIM(t2.Codigo)
		 + '|' + RTRIM(vld.CodigoEntidad)
		 + '|' + RTRIM(vld.CodigoTipoComprobante)
		 + '|' + RTRIM(vld.Serie)
		 + '|' + RTRIM(vld.Numero)
		 + '|' + RTRIM(vld.FechaDocumento)
		 + '|' + RTRIM(vld.FechaVencimiento)
		 + '|' + RTRIM(vld.FechaDocumento)
		 + '|' + RTRIM(vld.Descripcion)
		 + '|' + ''
		 + '|' + CONVERT(varchar, CONVERT(decimal(12,2),vld.DebeBase))
		 + '|' + CONVERT(varchar, CONVERT(decimal(12,2),vld.HaberBase))
		 + '|' + ''
		 + '|' + '1' + '|'

	, Periodo = RTRIM(a.codigo) + RTRIM(p.Codigo) + RTRIM(CONVERT(varchar,DAY(CONVERT(date, vld.FechaDocumento,103))))
	, Cuo = RTRIM(vld.Detalle)
	, Correlativo = 'M' + RTRIM(vld.Detalle)
	, Cuenta = RTRIM(vld.CodigoCuenta)
	, CodigoUnidad = ''
	, CodigoCentroCosto = ''
	, Moneda = RTRIM(vld.CodigoT04TipoMoneda)
	, TipoDocumento = RTRIM(t2.Codigo)
	, NumeroDocumento = RTRIM(vld.CodigoEntidad)
	, TipoComprobante = RTRIM(vld.CodigoTipoComprobante)
	, Serie = RTRIM(vld.Serie)
	, Numero = RTRIM(vld.Numero)
	, FechaContable = RTRIM(vld.FechaDocumento)
	, FechaVencimiento = RTRIM(vld.FechaVencimiento)
	, FechaOperacion = RTRIM(vld.FechaDocumento)
	, GlosaDescripcion = RTRIM(vld.Descripcion)
	, GlosaReferencial = ''
	, Debe = CONVERT(decimal(12,2),vld.DebeBase)
	, Haber = CONVERT(decimal(12,2),vld.HaberBase)
	, DatoEstructurado = ''
	, Estado = '1'
FROM Financiero.ViewLoteDetalle as vld
INNER JOIN Financiero.Cuenta c (NOLOCK) ON c.IdCompania = vld.IdCompania
AND c.id = vld.IdCuenta
INNER JOIN Financiero.Anio a (NOLOCK) ON a.IdCompania = vld.IdCompania
AND a.id = vld.IdAnio
INNER JOIN Financiero.AnioPeriodo p (NOLOCK) ON p.idAnio = vld.IdAnio
AND p.id = vld.IdAnioPeriodo
LEFT JOIN Maestros.Entidad as e (NOLOCK) ON e.IdEntidad = vld.CodigoEntidad
LEFT JOIN Sunat.T02TipoDocumentoIdentidad t2 ON e.IdTipoEntidad = t2.Id


/*
SELECT * FROM [Configuracion].[DiccionarioPantallaTabla]
*/


--Sp_helptext 'Financiero.ViewAnioTipoAsientoDetalle'


--SELECT DISTINCT Descripcion FROM Financiero.AnioPeriodo

--SELECT  * FROM Maestros.Moneda
--sp_helptext 'Financiero.ViewLoteDetalle'

/*
CREATE TABLE Sunat.LibroElectronico
(
	Id int IDENTITY(1,1),
	Descripcion VARCHAR(200) DEFAULT '',
	Codigo VARCHAR(12) NOT NULL,
	AplicativoCreacion VARCHAR(30),
	OpcionCreacion VARCHAR(30),
	FechaCreacion datetime,
	UsuarioCreacion VARCHAR(30),
	AplicativoEdicion VARCHAR(30),
	OpcionEdicion VARCHAR(30),
	FechaEdicion datetime,
	UsuarioEdicion VARCHAR(30),
	IdNota INT,
	TStamp timestamp,
	CONSTRAINT XPKSunat_LibroElectronico PRIMARY KEY(Id)
);


INSERT INTO Sunat.LibroElectronico (Descripcion, Codigo) VALUES ('LIBRO CAJA Y BANCOS - DETALLE DE LOS MOVIMIENTOS DEL EFECTIVO','010100'),
('LIBRO CAJA Y BANCOS - DETALLE DE LOS MOVIMIENTOS DE LA CUENTA CORRIENTE','010200'),
('LIBRO DE INVENTARIOS Y BALANCES - ESTADO DE SITUACI�N FINANCIERA','030100'),
('LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO DE LA CUENTA 10 EFECTIVO Y EQUIVALENTES DE EFECTIVO (2)','030200'),
('LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO DE LA CUENTA 12 CUENTAS POR COBRAR COMERCIALES � TERCEROS Y 13 CUENTAS POR COBRAR COMERCIALES � RELACIONADAS','030300'),
('LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO  DE LA CUENTA 14 CUENTAS POR COBRAR AL PERSONAL, A LOS ACCIONISTAS (SOCIOS), DIRECTORES Y GERENTES (2)','030400'),
('LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO  DE LA CUENTA 16 CUENTAS POR COBRAR DIVERSAS - TERCEROS O CUENTA 17 - CUENTAS POR COBRAR DIVERSAS - RELACIONADAS','030500'),
('LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO DE LA CUENTA 19 ESTIMACI�N DE CUENTAS DE COBRANZA DUDOSA','030600'),
('LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO DE LA CUENTA 20 - MERCADERIAS Y LA CUENTA 21 - PRODUCTOS TERMINADOS (2)','030700'),
('LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO DE LA CUENTA 30 INVERSIONES MOBILIARIAS  (2)','030800'),
('LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO DE LA CUENTA 34 - INTANGIBLES','030900'),
('LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO DE LA CUENTA 41 REMUNERACIONES Y PARTICIPACIONES POR PAGAR (2)','031100'),
('LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO DE LA CUENTA 42 CUENTAS POR PAGAR COMERCIALES � TERCEROS Y LA CUENTA 43 CUENTAS POR PAGAR COMERCIALES � RELACIONADAS ','031200'),
('LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO DE LA CUENTA 46 CUENTAS POR PAGAR DIVERSAS � TERCEROS Y DE LA CUENTA 47 CUENTAS POR PAGAR DIVERSAS � RELACIONADAS','031300'),
('LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO DE LA CUENTA 47 - BENEFICIOS SOCIALES DE LOS TRABAJADORES (PCGR) - NO APLICABLE PARA EL PCGE (2)','031400'),
('LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO DE LA CUENTA 37 ACTIVO DIFERIDO Y DE LA CUENTA 49 PASIVO DIFERIDO','031500'),
('LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO DE LA CUENTA 50 CAPITAL','031600'),
('3.16.1 DETALLE DEL SALDO DE LA CUENTA 50 - CAPITAL ',''),
('3.16.2 ESTRUCTURA DE LA PARTICIPACI�N ACCIONARIA O DE PARTICIPACIONES SOCIALES',''),
('LIBRO DE INVENTARIOS Y BALANCES - BALANCE DE COMPROBACI�N','031700'),
('LIBRO DE INVENTARIOS Y BALANCES - ESTADO DE FLUJOS DE EFECTIVO - M�TODO DIRECTO','031800'),
('LIBRO DE INVENTARIOS Y BALANCES - ESTADO DE CAMBIOS EN EL PATRIMONIO NETO','031900'),
('LIBRO DE INVENTARIOS Y BALANCES - ESTADO DE RESULTADOS','032000'),
('LIBRO DE INVENTARIOS Y BALANCES - NOTAS A LOS ESTADOS FINANCIEROS (3)','032300'),
('LIBRO DE INVENTARIOS Y BALANCES - ESTADO DE RESULTADOS INTEGRALES','032400'),
('LIBRO DE INVENTARIOS Y BALANCES - ESTADO DE FLUJOS DE EFECTIVO - M�TODO INDIRECTO','32500'),
('LIBRO DE RETENCIONES INCISO E) Y F) DEL ART. 34� DE LA LEY DEL IMPUESTO A LA RENTA','040100'),
('LIBRO DIARIO','050100'),
('LIBRO DIARIO - DETALLE DEL PLAN CONTABLE UTILIZADO','050300'),
('LIBRO DIARIO DE FORMATO SIMPLIFICADO','050200'),
('LIBRO DIARIO DE FORMATO SIMPLIFICADO - DETALLE DEL PLAN CONTABLE UTILIZADO','050400'),
('LIBRO MAYOR','060100'),
('REGISTRO DE ACTIVOS FIJOS - DETALLE DE LOS ACTIVOS FIJOS REVALUADOS Y NO REVALUADOS','070100'),
('REGISTRO DE ACTIVOS FIJOS - DETALLE DE LA DIFERENCIA DE CAMBIO','070300'),
('REGISTRO DE ACTIVOS FIJOS - DETALLE DE LOS ACTIVOS FIJOS BAJO LA MODALIDAD DE ARRENDAMIENTO FINANCIERO AL 31.12','070400'),
('REGISTRO DE COMPRAS','080100'),
('REGISTRO DE COMPRAS - INFORMACI�N DE OPERACIONES CON SUJETOS NO DOMICILIADOS','080200'),
('REGISTRO DE COMPRAS SIMPLIFICADO','080300'),
('REGISTRO DE CONSIGNACIONES - PARA EL CONSIGNADOR - CONTROL DE BIENES ENTREGADOS EN CONSIGNACI�N','090100'),
('REGISTRO DE CONSIGNACIONES - PARA EL CONSIGNATARIO - CONTROL DE BIENES RECIBIDOS EN CONSIGNACI�N','090200'),
('REGISTRO DE COSTOS - ESTADO DE COSTO DE VENTAS ANUAL','100100'),
('REGISTRO DE COSTOS - ELEMENTOS DEL COSTO MENSUAL','100200'),
('REGISTRO DE COSTOS - ESTADO DE COSTO DE PRODUCCION VALORIZADO ANUAL','100300'),
('REGISTRO DE COSTOS - CENTRO DE COSTOS','100400'),
('REGISTRO DEL INVENTARIO PERMANENTE EN UNIDADES F�SICAS - DETALLE DEL INVENTARIO PERMANENTE EN UNIDADES F�SICAS','120100'),
('REGISTRO DEL INVENTARIO PERMANENTE VALORIZADO - DETALLE DEL INVENTARIO VALORIZADO','130100'),
('REGISTRO DE VENTAS E INGRESOS','140100'),
('REGISTRO DE VENTAS E INGRESOS SIMPLIFICADO','140200');

*/







------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
-- SEGURIDAD MENU 1
/*
SELECT * FROM [SeguridadTest].[dbo].[Accion]
SELECT * FROM [SeguridadTest].[dbo].[Pantalla]
SELECT * FROM [SeguridadTest].[dbo].[AccionPantalla]
SELECT * FROM [SeguridadTest].[dbo].[Acceso]

--------------------------
INSERT INTO [SeguridadTest].[dbo].[AccionPantalla] (IdAccion, IdPantalla, Activo, Eliminado, UsuarioCrea, FechaCrea)
SELECT Id IdAccion, 490 IdPantalla, 1 Activo, 0  Eliminado, 1 UsuarioCrea, '2021-02-19 11:22:05.087' FechaCrea  FROM [dbo].[Accion] WHERE Id IN (1, 2, 3, 8, 9, 10, 2013, 2014, 2018, 2047)

INSERT INTO [SeguridadTest].[dbo].[Acceso] (IdTipoAcceso, IdUsuarioRol, IdPantalla, IdAccion, Activo, Eliminado, UsuarioCrea, FechaCrea)
SELECT 1 IdTipoAcceso, 2 IdUsuarioRol, 490 IdPantalla, Id IdAccion, 1 Activo, 0 Eliminado, 1 UsuarioCrea, '2020-01-01 00:00:00.000' FechaCrea
	FROM [dbo].[Accion] WHERE Id IN (1, 2, 3, 8, 9, 10, 2013, 2014, 2018, 2047) 
*/

------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
-- 8.1 REGISTRO DE COMPRAS
ALTER VIEW [Consulta].[CTB0300_0801] AS
SELECT
	TXT = RTRIM(a.codigo) + RTRIM(ap.codigo) + '00'
		+ '|' + RTRIM(ltp.Id)
		+ '|' + 'M' + RTRIM(ltp.Id)
		+ '|' + CONVERT(VARCHAR, ltp.FechaDocumento, 103)
		+ '|' + CONVERT(VARCHAR, ltp.FechaVencimiento, 103)
		+ '|' + CONVERT(VARCHAR, t10.Codigo)
		+ '|' + CONVERT(VARCHAR, CASE WHEN t10.Codigo IN ('50', '52') THEN ISNULL(t11.Codigo,'') ELSE ltp.Serie END)
		+ '|' + CONVERT(VARCHAR, ISNULL(ltp.AnioEmisionDuaDsi,''))
		+ '|' + CONVERT(varchar,ltp.Numero)
		+ '|' + CASE WHEN t10.Codigo IN ('00','03','05','06','07','08','11','12','13','14','15','16','18','19','23','26','28','30','34','35','36','37','55','56','87','88') THEN '0' ELSE '' END
		-- Proveedor
		+ '|' + RTRIM(e.IdTipoEntidad)
		+ '|' + RTRIM(e.NroFiscal)
		+ '|' + RTRIM(e.NombreRazonSocial)						-- COLUMNA 13
		-- Montos
		+ '|' + CONVERT(VARCHAR, CONVERT(DECIMAL(12,2), ltp.TotalMonedaBase))
		+ '|' + CONVERT(VARCHAR, CONVERT(DECIMAL(12,2), '0.00'))
		+ '|' + CONVERT(VARCHAR, CONVERT(DECIMAL(12,2), '0.00'))
		+ '|' + CONVERT(VARCHAR, CONVERT(DECIMAL(12,2), '0.00'))
		+ '|' + CONVERT(VARCHAR, CONVERT(DECIMAL(12,2), '0.00'))
		+ '|' + CONVERT(VARCHAR, CONVERT(DECIMAL(12,2), '0.00'))
		+ '|' + CONVERT(VARCHAR, CONVERT(DECIMAL(12,2), '0.00'))
		+ '|' + CONVERT(VARCHAR, CONVERT(DECIMAL(12,2), '0.00'))
		+ '|' + CASE WHEN t10.Codigo IN ('01','03','07','08','12','87','88') THEN '0.00' ELSE '' END
		+ '|' + CONVERT(VARCHAR, CONVERT(DECIMAL(12,2), '0.00'))
		+ '|' + CONVERT(VARCHAR, CONVERT(DECIMAL(12,2), ltp.TotalMonedaBase))
		-- Cambio
		+ '|' + m.CodigoISO
		+ '|' + CASE WHEN m.CodigoISO = 'PEN' THEN '1.000' ELSE CONVERT(VARCHAR, CONVERT(DECIMAL(12,3), ltp.ImporteCambio)) END -- COLUMNA 26
		-- NC / ND
		+ '|' + CASE WHEN t10.Codigo IN ('07','08','87','88','97','98') THEN CONVERT(VARCHAR, altp.FechaDocumento, 103) ELSE '' END
		+ '|' + CASE WHEN t10.Codigo IN ('07','08','87','88','97','98') THEN at10.Codigo ELSE '' END
		+ '|' + CASE WHEN t10.Codigo IN ('07','08','87','88','97','98') THEN altp.Serie ELSE '' END
		+ '|' + ISNULL(at11.Codigo,'')
		+ '|' + CASE WHEN t10.Codigo IN ('07','08','87','88','97','98') THEN altp.Numero ELSE '' END
		-- Detraccion
		+ '|' + CASE WHEN ltp.IdRegimen = 2 THEN ISNULL(CONVERT(VARCHAR, ltp.FechaConstanciaDetraccion, 103),'') ELSE '' END 
		+ '|' + CASE WHEN ltp.IdRegimen = 2 THEN ISNULL(ltp.ConstanciaDetraccion,'') ELSE '' END 
		-- Retencion
		+ '|' + CASE WHEN ltp.IdRegimen = 1 THEN '1' ELSE '' END
		+ '|' + at30.Codigo
		+ '|' + ''
		-- Error
		+ '|' + ''
		+ '|' + ''
		+ '|' + ''
		+ '|' + ''
		-- Ultimo
		+ '|' + CASE WHEN ltp.IdFormaPago = 1 THEN '1' ELSE '' END 
		+ '|' + '1' + '|'
	, Periodo = RTRIM(a.codigo) + RTRIM(ap.codigo) + '00'
	, Cuo = ltp.Id
	, Correlativo = 'M' + RTRIM(ltp.Id)
	, FechaEmision = CONVERT(VARCHAR, ltp.FechaDocumento, 103)
	, FechaVencimiento = CONVERT(VARCHAR, ltp.FechaVencimiento, 103)
	, TipoComprobante = t10.Codigo
	, Serie = CASE WHEN t10.Codigo IN ('50', '52') THEN ISNULL(t11.Codigo,'') ELSE ltp.Serie END
	, AnioEmisionDuaDsi = ISNULL(ltp.AnioEmisionDuaDsi,'')
	, ltp.Numero
	, ImporteTotalSinCreditoFiscal = CASE WHEN t10.Codigo IN ('00','03','05','06','07','08','11','12','13','14','15','16','18','19','23','26','28','30','34','35','36','37','55','56','87','88') THEN '0' ELSE '' END
	-- Proveedore
	, TipoDocumento = RTRIM(e.IdTipoEntidad)
	, NumeroDocumento = RTRIM(e.NroFiscal)
	, NombreRazonSocial = RTRIM(e.NombreRazonSocial)
	-- Montos
	, BaseImponible = CONVERT(VARCHAR, CONVERT(DECIMAL(12,2), ltp.TotalMonedaBase)) -- CAMPO 14
	, Impuesto = CONVERT(VARCHAR, CONVERT(DECIMAL(12,2), '0.00'))
	, BaseImponibleGravada = CONVERT(VARCHAR, CONVERT(DECIMAL(12,2), '0.00'))
	, ImpuestoGravada = CONVERT(VARCHAR, CONVERT(DECIMAL(12,2), '0.00'))
	, BaseImponibleExporta = CONVERT(VARCHAR, CONVERT(DECIMAL(12,2), '0.00'))
	, ImpuestoExporta = CONVERT(VARCHAR, CONVERT(DECIMAL(12,2), '0.00'))
	, ValorNoGravada = CONVERT(VARCHAR, CONVERT(DECIMAL(12,2), '0.00'))
	, ISC = CONVERT(VARCHAR, CONVERT(DECIMAL(12,2), '0.00'))
	, ICBP = CASE WHEN t10.Codigo IN ('01','03','07','08','12','87','88') THEN '0.00' ELSE '' END
	, OtrosTributos = CONVERT(VARCHAR, CONVERT(DECIMAL(12,2), '0.00'))
	, ImporteTotal = CONVERT(VARCHAR, CONVERT(DECIMAL(12,2), ltp.TotalMonedaBase))
	-- Cambio
	, CodigoMoneda = m.CodigoISO
	, TipoCambio = CASE WHEN m.CodigoISO = 'PEN' THEN '1.000' ELSE CONVERT(VARCHAR, CONVERT(DECIMAL(12,3), ltp.ImporteCambio)) END
	-- NC / ND
	, ModificaFechaEmision = CASE WHEN t10.Codigo IN ('07','08','87','88','97','98') THEN CONVERT(VARCHAR, altp.FechaDocumento, 103) ELSE '' END
	, ModificaTipoComprobante = CASE WHEN t10.Codigo IN ('07','08','87','88','97','98') THEN at10.Codigo ELSE '' END
	, ModificaSerie = CASE WHEN t10.Codigo IN ('07','08','87','88','97','98') THEN altp.Serie ELSE '' END
	, ModificaCodigoDependenciaAduana = ISNULL(at11.Codigo,'')
	, ModificaNumero = CASE WHEN t10.Codigo IN ('07','08','87','88','97','98') THEN altp.Numero ELSE '' END
	-- Detraccion
	, FechaConstanciaDetraccion = CASE WHEN ltp.IdRegimen = 2 THEN ISNULL(CONVERT(VARCHAR, ltp.FechaConstanciaDetraccion, 103),'') ELSE '' END 
	, ConstanciaDetraccion = CASE WHEN ltp.IdRegimen = 2 THEN ISNULL(ltp.ConstanciaDetraccion,'') ELSE '' END 
	-- Retencion
	, Retencion = CASE WHEN ltp.IdRegimen = 1 THEN '1' ELSE '' END
	, BienServicio = at30.Codigo
	, Contrato = ''
	-- Error
	, ErrorTipo1 = ''
	, ErrorTipo2 = ''
	, ErrorTipo3 = ''
	, ErrorTipo4 = ''
	-- Ultimo
	, IndicadorComprobante = CASE WHEN ltp.IdFormaPago = 1 THEN '1' ELSE '' END 
	, Estado = '1'

	-- Dependencia Aduanera
FROM Financiero.LoteTransaccionPorPagar AS ltp 
INNER JOIN Financiero.Lote AS l ON  ltp.IdLote = l.Id 
INNER JOIN Financiero.AnioPeriodo AS ap ON l.IdPeriodo = ap.id 
INNER JOIN Financiero.Anio AS a ON ap.IdAnio = a.Id
INNER JOIN Sunat.T10TipoComprobante AS t10 ON  ltp.IdT10TipoComprobante = t10.Id AND t10.Codigo NOT IN ('91','97','98')
LEFT JOIN Sunat.T11CodigoAduana AS t11 ON  ltp.IdT11CodigoAduana = t11.id
INNER JOIN Maestros.Entidad AS e ON e.IdEntidad = ltp.IdEntidadOficial
INNER JOIN Maestros.Moneda as m ON ltp.IdMonedaBase = m.IdMoneda

INNER JOIN Financiero.LoteTransaccionPorPagarDetalle AS ltpd ON ltp.Id = ltpd.IdTransaccion AND ltpd.IdLoteTrazable IS NOT NULL
INNER JOIN Financiero.LoteTransaccionPorPagar as altp ON ltpd.IdLoteTrazable = altp.IdLote
INNER JOIN Sunat.T10TipoComprobante AS at10 ON altp.IdT10TipoComprobante = at10.Id -- AND at10.Codigo NOT IN ('91','97','98')
LEFT JOIN Sunat.T11CodigoAduana AS at11 ON altp.IdT11CodigoAduana = at11.Id
LEFT JOIN Sunat.T30ClasificacionBienServicio AS at30 ON ltp.IdT30ClasificacionBienServicio = at30.Id



------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
-- 8.2 REGISTRO DE COMPRAS - INFORMACIÓN DE OPERACIONES CON SUJETOS NO DOMICILIADOS
SELECT 
	TXT = RTRIM(a.codigo) + RTRIM(ap.codigo) + '00'
		+ '|' + RTRIM(ltp.Id)
		+ '|' + 'M' + RTRIM(ltp.Id)
		+ '|' + CONVERT(VARCHAR, ltp.FechaDocumento, 103)
		+ '|' + CONVERT(varchar, t10.Codigo)
		+ '|' + RTRIM(ltp.Serie)
		+ '|' + CONVERT(varchar,ltp.Numero)
		-- Montos
		+ '|' + CONVERT(VARCHAR, CONVERT(DECIMAL(12,2), ltp.TotalMonedaBase))
		+ '|' + CONVERT(VARCHAR, CONVERT(DECIMAL(12,2), ltp.TotalMonedaBase))
		+ '|' + CONVERT(VARCHAR, CONVERT(DECIMAL(12,2), ltp.TotalMonedaBase))
		-- Conprobante vinculada
		+ '|' + ''
		+ '|' + ''
		+ '|' + ''
		+ '|' + ''

	, Periodo = RTRIM(a.codigo) + RTRIM(ap.codigo) + '00'
	, Cuo = ltp.Id
	, Correlativo = 'M' + RTRIM(ltp.Id)
	, FechaEmision = CONVERT(VARCHAR, ltp.FechaDocumento, 103)
	, TipoComprobante = t10.Codigo
	, Serie = ltp.Serie
	, ltp.Numero
	-- Montos
	, ValorAdquisision = CONVERT(VARCHAR, CONVERT(DECIMAL(12,2), ltp.TotalMonedaBase))
	, OtrosConceptos = CONVERT(VARCHAR, CONVERT(DECIMAL(12,2), ltp.TotalMonedaBase))
	, ImporteTotal = CONVERT(VARCHAR, CONVERT(DECIMAL(12,2), ltp.TotalMonedaBase))
	-- Conprobante vinculada
	, TipoComprobanteCF = ''
	, SerieComprobanteDUADSI = ''
	, AnoDua = ''
	, NumeroComprobanteCF = ''
	-- 
	, ImpuestoRetenido = ltp.RetencionMonedaBase
	, CodigoMoneda = m.CodigoISO
	, TipoCambio = CASE WHEN m.CodigoISO = 'PEN' THEN '1.000' ELSE CONVERT(VARCHAR, CONVERT(DECIMAL(12,3), ltp.ImporteCambio)) END
	-- Proveedore
	, CodigoPais = RTRIM(p.CodLibroElectronico)
	, Denominacion = RTRIM(e.NombreRazonSocial)
	, Domicilio = RTRIM(e.Direccion1)
	, NumeroDocumento = RTRIM(e.IdEntidad)
	, NumeroDocumentoFiscal = RTRIM(e.NroFiscal)
	, Beneficiario = ''
	, CodigoPaisBeneficiario = ''
	, TipoVinculacion = t27.Codigo
	-- , TipoDocumento = RTRIM(t02.Codigo)
	
	-- Otros
	, RentaBruta = ltp.NdRentaBruta
	, DeduccionCosto = ltp.NdDeduccionCostoEnajenacion
	, RentaNeta = ltp.NdRentaNeta
	, TasaRetencion = ltp.NdTasaRetencion
	, ImpuestoRetenido = ltp.NdImpuestoRetenido
	-- Convenidos
	, Convenio = t25.Codigo
	, Exoneracion = t33.Codigo
	, TipoRenta = t31.Codigo
	, ModalidadServicio = t32.Codigo
	, LeyImpuestoRenta = ''
	, Estado = '0'

FROM Financiero.LoteTransaccionPorPagar AS ltp 
INNER JOIN Financiero.Lote AS l ON  ltp.IdLote = l.Id 
INNER JOIN Financiero.AnioPeriodo AS ap ON l.IdPeriodo = ap.id 
INNER JOIN Financiero.Anio AS a ON ap.IdAnio = a.Id
INNER JOIN Sunat.T10TipoComprobante AS t10 ON  ltp.IdT10TipoComprobante = t10.Id AND t10.Codigo IN ('00','91','97','98')
LEFT JOIN Sunat.T11CodigoAduana AS t11 ON  ltp.IdT11CodigoAduana = t11.id
INNER JOIN Maestros.Moneda AS m ON ltp.IdMonedaBase = m.IdMoneda

INNER JOIN Maestros.Entidad AS e ON e.IdEntidad = ltp.IdEntidadOficial
INNER JOIN Sunat.T02TipoDocumentoIdentidad AS t02 ON e.IdTipoEntidad = t02.Id
INNER JOIN Maestros.Pais AS p ON e.IdPais = p.IdPais
INNER JOIN Sunat.T27TipoVinculacion AS t27 ON ltp.IdT27TipoVinculacion = t27.Id

INNER JOIN Sunat.T25ConvenioTributacion AS t25 ON ltp.IdT25ConvenioTributacion = t25.Id
INNER JOIN Sunat.T33ExoneracionNoDomiciliado AS t33 ON ltp.IdT33ExoneracionNoDomiciliado = t33.Id
INNER JOIN Sunat.T31TipoRenta AS t31 ON ltp.IdT31TipoRenta = t31.Id
INNER JOIN Sunat.T32ModalidadNoDomiciliado as t32 ON ltp.IdT32ModalidadNoDomiciliado = t32.Id



------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
-- 8.3 REGISTRO DE COMPRAS SIMPLIFICADO
SELECT TOP 100
	TXT = RTRIM(a.codigo) + RTRIM(ap.codigo) + '00'
		+ '|' + RTRIM(ltp.Id)
		+ '|' + 'M' + RTRIM(ltp.Id)
		+ '|' + CONVERT(VARCHAR, ltp.FechaDocumento, 103)
		+ '|' + CONVERT(VARCHAR, ltp.FechaVencimiento, 103)
		+ '|' + CONVERT(varchar,t10.Codigo)
		+ '|' + ISNULL(CASE WHEN t10.Codigo IN ('50', '52') THEN t11.Codigo ELSE ltp.Serie END,'')
		+ '|' + CONVERT(VARCHAR,ltp.Numero)
		+ '|' + CASE WHEN t10.Codigo IN ('00','03','05','06','11','12','13','14','15','16','18','19','23','26','28','30','36','37','55','56') THEN '0' ELSE '' END
        -- Proveedore
		+ '|' + RTRIM(e.IdTipoEntidad)
		+ '|' + RTRIM(e.NroFiscal)
		+ '|' + RTRIM(e.NombreRazonSocial)
		-- Montos
		+ '|' + '0'
		+ '|' + '0'
		+ '|' + CASE WHEN t10.Codigo IN ('01','03','07','08','12','87','88') THEN '0.00' ELSE '' END
		+ '|' + '0'
		+ '|' + CONVERT(VARCHAR, CONVERT(DECIMAL(12,2), ltp.TotalMonedaBase))
		-- Cambio
		+ '|' + m.CodigoISO				-- CAMPO 18
		+ '|' + CASE WHEN m.CodigoISO = 'PEN' THEN '1.000' ELSE CONVERT(VARCHAR, CONVERT(DECIMAL(12,3), ltp.ImporteCambio)) END
		-- NC / ND
		+ '|' + CASE WHEN t10.Codigo IN ('07','08','87','88') THEN CONVERT(VARCHAR, altp.FechaDocumento, 103) ELSE '' END
		+ '|' + CASE WHEN t10.Codigo IN ('07','08','87','88') THEN at10.Codigo ELSE '' END
		+ '|' + CASE WHEN t10.Codigo IN ('07','08','87','88') THEN altp.Serie ELSE '' END
		+ '|' + CASE WHEN t10.Codigo IN ('07','08','87','88') THEN altp.Numero ELSE '' END
		-- Detraccion
		+ '|' + CASE WHEN ltp.IdRegimen = 2 THEN ISNULL(CONVERT(VARCHAR, ltp.FechaConstanciaDetraccion, 103),'') ELSE '' END 
		+ '|' + CASE WHEN ltp.IdRegimen = 2 THEN ISNULL(ltp.ConstanciaDetraccion,'') ELSE '' END 
		-- Retencion
		+ '|' + CASE WHEN ltp.IdRegimen = 1 THEN '1' ELSE '' END
		+ '|' + t30.Codigo
		-- Error
		+ '|' + ''
		+ '|' + ''
		+ '|' + ''
		-- Ultimo
		+ '|' + CASE WHEN ltp.IdFormaPago = 1 THEN '1' ELSE '' END 
		+ '|' + '1' + '|'

	, Periodo = RTRIM(a.codigo) + RTRIM(ap.codigo) + '00'
	, Cuo = ltp.Id
	, Correlativo = 'M' + RTRIM(ltp.Id)
	, FechaEmision = CONVERT(VARCHAR, ltp.FechaDocumento, 103)
	, FechaVencimiento = CONVERT(VARCHAR, ltp.FechaVencimiento, 103)
	, TipoComprobante = t10.Codigo
	, Serie = CASE WHEN t10.Codigo IN ('50', '52') THEN t11.Codigo ELSE ltp.Serie END
	, ltp.Numero
	, ImporteTotalSinCreditoFiscal = 0
	, Numero2 = CASE WHEN t10.Codigo IN ('00','03','05','06','11','12','13','14','15','16','18','19','23','26','28','30','36','37','55','56') THEN '0' ELSE '' END
	-- Proveedore
	, TipoDocumento = RTRIM(e.IdTipoEntidad)
	, NumeroDocumento = RTRIM(e.NroFiscal)
	, NombreRazonSocial = RTRIM(e.NombreRazonSocial)
	-- Montos
	, BaseImponibleGravada = 0
	, ImpuestoGravada = 0
	, ICBP = CASE WHEN t10.Codigo IN ('01','03','07','08','12','87','88') THEN '0.00' ELSE '' END
	, OtrosTributos = '0.00'
	, ImporteTotal = CONVERT(VARCHAR, CONVERT(DECIMAL(12,2), ltp.TotalMonedaBase))
	-- Cambio
	, CodigoMoneda = m.CodigoISO
	, TipoCambio = CASE WHEN m.CodigoISO = 'PEN' THEN '1.000' ELSE CONVERT(VARCHAR, CONVERT(DECIMAL(12,3), ltp.ImporteCambio)) END
	-- NC / ND
	, ModificaFechaEmision = CASE WHEN t10.Codigo IN ('07','08','87','88') THEN CONVERT(VARCHAR, altp.FechaDocumento, 103) ELSE '' END --  '07' o '08' o '87' o '88'
	, ModificaTipoComprobante = CASE WHEN t10.Codigo IN ('07','08','87','88') THEN at10.Codigo ELSE '' END
	, ModificaSerie = CASE WHEN t10.Codigo IN ('07','08','87','88') THEN altp.Serie ELSE '' END
	, ModificaNumero = CASE WHEN t10.Codigo IN ('07','08','87','88') THEN altp.Numero ELSE '' END
	-- Detraccion
	, FechaConstanciaDetraccion = CASE WHEN ltp.IdRegimen = 2 THEN ISNULL(CONVERT(VARCHAR, ltp.FechaConstanciaDetraccion, 103),'') ELSE '' END 
	, ConstanciaDetraccion = CASE WHEN ltp.IdRegimen = 2 THEN ISNULL(ltp.ConstanciaDetraccion,'') ELSE '' END 
	-- Retencion
	, Retencion = CASE WHEN ltp.IdRegimen = 1 THEN '1' ELSE '' END
	, BienServicio = t30.Codigo
	-- Error
	, ErrorTipo1 = ''
	, ErrorTipo2 = ''
	, ErrorTipo3 = ''
	-- Ultimo
	, IndicadorComprobante = CASE WHEN ltp.IdFormaPago = 1 THEN '1' ELSE '' END 
	, CreditoFiscal = '1'
	, ltpd.IdLoteTrazable
FROM Financiero.LoteTransaccionPorPagar AS ltp 
INNER JOIN Financiero.Lote AS l ON  ltp.IdLote = l.Id 
INNER JOIN Financiero.AnioPeriodo AS ap ON l.IdPeriodo = ap.id 
INNER JOIN Financiero.Anio AS a ON ap.IdAnio = a.Id
INNER JOIN Sunat.T10TipoComprobante AS t10 ON  ltp.IdT10TipoComprobante = t10.Id
LEFT JOIN Sunat.T11CodigoAduana AS t11 ON  ltp.IdT11CodigoAduana = t11.id
INNER JOIN Maestros.Entidad AS e ON e.IdEntidad = ltp.IdEntidadOficial
-- INNER JOIN Sunat.T02TipoDocumentoIdentidad AS t02 ON e.IdTipoEntidad = t02.Codigo
INNER JOIN Maestros.Moneda as m ON ltp.IdMonedaBase = m.IdMoneda

INNER JOIN Financiero.LoteTransaccionPorPagarDetalle AS ltpd ON ltp.Id = ltpd.IdTransaccion AND ltpd.IdLoteTrazable IS NOT NULL 
INNER JOIN Financiero.LoteTransaccionPorPagar as altp ON ltpd.IdLoteTrazable = altp.IdLote
INNER JOIN Sunat.T10TipoComprobante AS at10 ON  altp.IdT10TipoComprobante = at10.Id

LEFT JOIN Sunat.T30ClasificacionBienServicio AS t30 ON ltp.IdT30ClasificacionBienServicio = t30.Id







------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
-- 14.1 REGISTRO DE VENTAS
SELECT
	TXT = RTRIM(a.codigo) + RTRIM(ap.codigo) + '00'
		+ '|' + CONVERT(VARCHAR,ltc.Id)
		+ '|' + 'M' + RTRIM(ltc.Id)
		+ '|' + CONVERT(VARCHAR, ltc.FechaDocumento, 103)
		+ '|' + CONVERT(VARCHAR, ltc.FechaVencimiento, 103)
        + '|' + CONVERT(varchar,ltc.Serie)
		+ '|' + CONVERT(varchar,ltc.Numero)
		+ '|' + ''
		-- Cliente
		+ '|' + RTRIM(t02.Codigo)
		+ '|' + RTRIM(e.NroFiscal)
		+ '|' + RTRIM(e.NombreRazonSocial)
		-- Montos
		+ '|' + '0'
		+ '|' + '0'
		+ '|' + '0'
		+ '|' + '0'
		+ '|' + '0'
		+ '|' + '0'
		+ '|' + '0'
		+ '|' + '0'
		+ '|' + '0'
		+ '|' + '0'
		+ '|' + '0'
		+ '|' + '0'
		-- Cambio
		+ '|' + m.CodigoISO
		+ '|' + ''
		-- NC / ND
		+ '|' + CASE WHEN t10.Codigo IN ('07','08','87','88') THEN CONVERT(VARCHAR, altc.FechaDocumento, 103) ELSE '' END --  '07' o '08' o '87' o '88'
	    + '|' + CASE WHEN t10.Codigo IN ('07','08','87','88') THEN at10.Codigo ELSE '' END
	    + '|' + CASE WHEN t10.Codigo IN ('07','08','87','88') THEN altc.Serie ELSE '' END
	    + '|' + CASE WHEN t10.Codigo IN ('07','08','87','88') THEN altc.Numero ELSE '' END
		-- Error
		+ '|' + ''
		+ '|' + ''
		-- Otros
		+ '|' +  CASE WHEN ltc.IdFormaPago = 1 THEN '1' ELSE '' END 
		+ '|' +  '0'

	, Periodo = RTRIM(a.codigo) + RTRIM(ap.codigo) + '00'
	, Cuo = ltc.Id
	, Correlativo = 'M' + RTRIM(ltc.Id)
	, FechaEmision =  CONVERT(VARCHAR, ltc.FechaDocumento, 103)
	, FechaVencimiento = CONVERT(VARCHAR, ltc.FechaVencimiento, 103)
	, TipoComprobante = t10.Codigo
	, ltc.Serie
	, ltc.Numero
	, Numero2 = ''
	-- Cliente
	, TipoDocumento = RTRIM(t02.Codigo)
	, NumeroDocumento = RTRIM(e.NroFiscal)
	, Denominacion = RTRIM(e.NombreRazonSocial)
	-- Montos
	, Exportacion = 0
	, Gravada = 0
	, BaseImponible = 0
	, ImpuestoGeneral = 0
	, DescuentoImpuesto = 0
	, TotalExonerada = 0
	, TotalInafecta = 0
	, ISC = 0
	, BaseImponibleArroz = 0
	, ImpuestoArroz = 0
	, OtroImpuesto = 0
	, Total = 0
	-- Cambio
	, CodigoMoneda = m.CodigoISO
	, TipoCambio = ''
	-- NC / ND
	, ModificaFechaEmision = CASE WHEN t10.Codigo IN ('07','08','87','88') THEN CONVERT(VARCHAR, altc.FechaDocumento, 103) ELSE '' END --  '07' o '08' o '87' o '88'
	, ModificaTipoComprobante = CASE WHEN t10.Codigo IN ('07','08','87','88') THEN at10.Codigo ELSE '' END
	, ModificaSerie = CASE WHEN t10.Codigo IN ('07','08','87','88') THEN altc.Serie ELSE '' END
	, ModificaNumero = CASE WHEN t10.Codigo IN ('07','08','87','88') THEN altc.Numero ELSE '' END
	-- Error
	, Contrato = ''
	, Error1 = ''
	-- Otros
    , IndicadorComprobante = CASE WHEN ltc.IdFormaPago = 1 THEN '1' ELSE '' END 
	, Estado = '0'

FROM Financiero.LoteTransaccionPorCobrar AS ltc
INNER JOIN Financiero.Lote AS l ON  ltc.IdLote = l.Id 
INNER JOIN Financiero.AnioPeriodo AS ap ON l.IdPeriodo = ap.id 
INNER JOIN Financiero.Anio AS a ON ap.IdAnio = a.Id
INNER JOIN Sunat.T10TipoComprobante as t10 ON  ltc.IdT10TipoComprobante = t10.Id
INNER JOIN Maestros.Entidad AS e ON e.IdEntidad = ltc.IdEntidadOficial
INNER JOIN Sunat.T02TipoDocumentoIdentidad AS t02 ON e.IdTipoEntidad = t02.Id
INNER JOIN Maestros.Moneda as m ON ltc.IdMonedaBase = m.IdMoneda

INNER JOIN Financiero.LoteTransaccionPorCobrarDetalle AS ltcd ON ltc.Id = ltcd.IdTransaccion AND  ltcd.IdLoteTrazable IS NOT NULL
INNER JOIN Financiero.LoteTransaccionPorCobrar AS altc ON ltcd.IdLoteTrazable = altc.IdLote
INNER JOIN Sunat.T10TipoComprobante AS at10 ON altc.IdT10TipoComprobante = at10.Id


------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
-- 14.2 REGISTRO DE VENTAS SIMPLIFICADO
SELECT
	TXT = RTRIM(a.codigo) + RTRIM(ap.codigo) + '00'
		+ '|' + CONVERT(VARCHAR,ltc.Id)
		+ '|' + 'M' + RTRIM(ltc.Id)
		+ '|' + CONVERT(VARCHAR, ltc.FechaDocumento, 103)
		+ '|' + CONVERT(VARCHAR, ltc.FechaVencimiento, 103)
        + '|' + CONVERT(varchar,ltc.Serie)
		+ '|' + CONVERT(varchar,ltc.Numero)
		+ '|' + ''
		-- Cliente
		+ '|' + RTRIM(t02.Codigo)
		+ '|' + RTRIM(e.NroFiscal)
		+ '|' + RTRIM(e.NombreRazonSocial)
		-- Montos
		+ '|' + '0'
		+ '|' + '0'
		+ '|' + '0'
		+ '|' + '0'
		-- Cambio
		+ '|' + m.CodigoISO
		+ '|' + ''
		-- NC / ND
		+ '|' + CASE WHEN t10.Codigo IN ('07','08') THEN CONVERT(VARCHAR, altc.FechaDocumento, 103) ELSE '' END --  '07' o '08' o '87' o '88'
	    + '|' + CASE WHEN t10.Codigo IN ('07','08') THEN at10.Codigo ELSE '' END
	    + '|' + CASE WHEN t10.Codigo IN ('07','08') THEN altc.Serie ELSE '' END
	    + '|' + CASE WHEN t10.Codigo IN ('07','08') THEN altc.Numero ELSE '' END
		-- Error
		+ '|' + ''
		-- Otros
		+ '|' +  CASE WHEN ltc.IdFormaPago = 1 THEN '1' ELSE '' END 
		+ '|' +  '0' + '|'

	, Periodo = RTRIM(a.codigo) + RTRIM(ap.codigo) + '00'
	, Cuo = ltc.Id
	, Correlativo = 'M' + RTRIM(ltc.Id)
	, FechaEmision =  CONVERT(VARCHAR, ltc.FechaDocumento, 103)
	, FechaVencimiento = CONVERT(VARCHAR, ltc.FechaVencimiento, 103)
	, TipoComprobante = t10.Codigo
	, ltc.Serie
	, ltc.Numero
	, Numero2 = ''
	-- Cliente
	, TipoDocumento = RTRIM(t02.Codigo)
	, NumeroDocumento = RTRIM(e.NroFiscal)
	, Denominacion = RTRIM(e.NombreRazonSocial)
	-- Montos
	, BaseImponible = 0
	, Impuesto = 0
	, OtroImpuesto = 0
	, Total = 0
	-- Cambio
	, CodigoMoneda = m.CodigoISO
	, TipoCambio = ''
	-- NC / ND
	, ModificaFechaEmision = CASE WHEN t10.Codigo IN ('07','08') THEN CONVERT(VARCHAR, altc.FechaDocumento, 103) ELSE '' END --  '07' o '08' o '87' o '88'
	, ModificaTipoComprobante = CASE WHEN t10.Codigo IN ('07','08') THEN at10.Codigo ELSE '' END
	, ModificaSerie = CASE WHEN t10.Codigo IN ('07','08') THEN altc.Serie ELSE '' END
	, ModificaNumero = CASE WHEN t10.Codigo IN ('07','08') THEN altc.Numero ELSE '' END
	-- Error
	, Error1 = ''
	-- Otros
    , IndicadorComprobante = CASE WHEN ltc.IdFormaPago = 1 THEN '1' ELSE '' END 
	, Estado = '0'

FROM Financiero.LoteTransaccionPorCobrar AS ltc
INNER JOIN Financiero.Lote AS l ON  ltc.IdLote = l.Id 
INNER JOIN Financiero.AnioPeriodo AS ap ON l.IdPeriodo = ap.id 
INNER JOIN Financiero.Anio AS a ON ap.IdAnio = a.Id
INNER JOIN Sunat.T10TipoComprobante as t10 ON  ltc.IdT10TipoComprobante = t10.Id
INNER JOIN Maestros.Entidad AS e ON e.IdEntidad = ltc.IdEntidadOficial
INNER JOIN Sunat.T02TipoDocumentoIdentidad AS t02 ON e.IdTipoEntidad = t02.Id
INNER JOIN Maestros.Moneda as m ON ltc.IdMonedaBase = m.IdMoneda

INNER JOIN Financiero.LoteTransaccionPorCobrarDetalle AS ltcd ON ltc.Id = ltcd.IdTransaccion AND  ltcd.IdLoteTrazable IS NOT NULL
INNER JOIN Financiero.LoteTransaccionPorCobrar AS altc ON ltcd.IdLoteTrazable = altc.IdLote
INNER JOIN Sunat.T10TipoComprobante AS at10 ON altc.IdT10TipoComprobante = at10.Id;

/*
sp_helptext 'Financiero.usp_GeneraPleTxt';

SELECT Vista, * FROM Configuracion.DiccionarioConsulta WHERE Id = 141
SELECT Codigo, * FROM Sunat.LibroElectronico WHERE Id  = 9

-- Id Consulta
-- Filtro Sql
-- Id Moneda
-- Periodo
-- Id Libro Electronico


sp_helptext '[Financiero].[usp_GeneraPleTxt]'

EXEC [Financiero].[usp_GeneraPleTxt] 141, '', 15, '001', '202101', 9        -- Libro 3.7
EXEC [Financiero].[usp_GeneraPleTxt] 146, '', 15, '001', '202101', 10        -- Libro 3.8
EXEC [Financiero].[usp_GeneraPleTxt] 142, '', 15, '001', '202101', 11        -- Libro 3.9
EXEC [Financiero].[usp_GeneraPleTxt] 143, '', 15, '001', '202101', 12        -- Libro 3.11
EXEC [Financiero].[usp_GeneraPleTxt] 141, '', 15, '001', '202101', 13        -- Libro 3.12
EXEC [Financiero].[usp_GeneraPleTxt] 141, '', 15, '001', '202101', 14        -- Libro 3.13
EXEC [Financiero].[usp_GeneraPleTxt] 144, '', 15, '001', '202101', 15        -- Libro 3.14
EXEC [Financiero].[usp_GeneraPleTxt] 145, '', 15, '001', '202101', 16        -- Libro 3.15

LE2052456126420220131030700011111.TXT

EXEC [Financiero].[usp_GeneraPleTxt] 148, '', 15, '001', '202109', 36        -- REGISTRO DE COMPRAS
EXEC [Financiero].[usp_GeneraPleTxt] 152, '', 15, '001', '202109', 37		-- REGISTRO DE COMPRAS NO DOMICILIADO
EXEC [Financiero].[usp_GeneraPleTxt] 149, '', 15, '001', '202109', 38        -- REGISTRO DE COMPRAS SIMPLIFICADO
EXEC [Financiero].[usp_GeneraPleTxt] 150, '', 15, '001', '202109', 47		-- REGISTRO DE VENTAS E INGRESOS
EXEC [Financiero].[usp_GeneraPleTxt] 151, '', 15, '001', '202109', 48		-- REGISTRO DE VENTAS E INGRESOS SIMPLIFICADO


*/

SELECT * FROM Maestros.Entidad
























-- // COBRAR
SELECT
	ltc.id, t10.Descripcion,ltc.Serie, ltc.Numero, ltc.IdLote, ltc.IdLoteTrazable, ltc.IdLoteTransaccionTrazable,
	de.IdLoteTrazable AS DE_IdLoteTrazable, de.IdLoteTransaccionTrazable as DE_IdLoteTransaccionTrazable,
	de.IdLoteTransaccionDetalleTrazable as DE_IdLoteTransaccionDetalleTrazable
FROM Financiero.LoteTransaccionPorCobrar as ltc
INNER JOIN Sunat.T10TipoComprobante as t10 ON  ltc.IdT10TipoComprobante = t10.Id
INNER JOIN Financiero.LoteTransaccionPorCobrarDetalle as de ON de.IdTransaccion = ltc.id
WHERE t10.Codigo IN ('01','02')
-- WHERE t10.Codigo IN ('07','08')

-- // PAGAR
SELECT
	ltp.id, t10.Descripcion,ltp.Serie, ltp.Numero, ltp.IdLote, ltp.IdLoteTrazable, ltp.IdLoteTransaccionTrazable,
	de.IdLoteTrazable AS DE_IdLoteTrazable, de.IdLoteTransaccionTrazable as DE_IdLoteTransaccionTrazable,
	de.IdLoteTransaccionDetalleTrazable as DE_IdLoteTransaccionDetalleTrazable
FROM Financiero.LoteTransaccionPorPagar as ltp
INNER JOIN Sunat.T10TipoComprobante as t10 ON  ltp.IdT10TipoComprobante = t10.Id
INNER JOIN Financiero.LoteTransaccionPorPagarDetalle as de ON de.IdTransaccion = ltp.id
--WHERE t10.Codigo IN ('01','02')
WHERE t10.Codigo IN ('07','08')
--WHERE ltp.IdLote IN (1457780,1465539,1457789,1468973,1469001)


SELECT TOP 10
	lt.TotalMonedaBase
	, lt.TotalMonedaSistema
	, lt.TotalMonedaTransaccion
	, SUM(ltd.TotalMonedaBase) AS D_TotalMonedaBase
	, SUM(ltd.TotalMonedaSistema) AS D_TotalMonedaSistema
	, SUM(ltd.TotalMonedaTransaccion) AS D_TotalMonedaTransaccion
	, SUM(ltd.ImpuestoMonedaBase) AS TotalImpuestoB
FROM Financiero.LoteTransaccionPorPagar as lt
INNER JOIN Financiero.LoteTransaccionPorPagarDetalle as ltd ON lt.id = ltd.IdTransaccion AND ltd.IdLoteTrazable IS NOT NULL
WHERE lt.Id = '5234'
GROUP BY lt.Id, lt.TotalMonedaBase, lt.TotalMonedaSistema, lt.TotalMonedaTransaccion










SELECT 
	lt.Id
	, lt.TotalMonedaBase
	, lt.TotalMonedaSistema
	, lt.TotalMonedaTransaccion
	, SUM(ltd.TotalMonedaBase + ltd.ImpuestoMonedaBase) AS D_TotalMonedaBase
	, SUM(ltd.TotalMonedaSistema) AS D_TotalMonedaSistema
	, SUM(ltd.TotalMonedaTransaccion) AS D_TotalMonedaTransaccion
	, SUM(ltd.ImpuestoMonedaBase) AS TotalImpuestoB
FROM Financiero.LoteTransaccionPorPagarDetalle as ltd
INNER JOIN Financiero.LoteTransaccionPorPagar as lt ON ltd.IdTransaccion = lt.Id
WHERE ltd.ImpuestoMonedaBase>0
GROUP BY lt.Id, lt.TotalMonedaBase, lt.TotalMonedaSistema, lt.TotalMonedaTransaccion










SELECT * FROM [Configuracion].[DiccionarioPantallaTabla] WHERE Pantalla LIKE '%Provision%Pagar%' 
sp_helptext 'Financiero.usp_PorPagar_insert_total'



SELECT ImpuestoMonedaBase, TotalMonedaBase FROM Financiero.LoteTransaccionPorPagarDetalle
WHERE CASE WHEN IdMonedaBase = IdMonedaTransaccion THEN 'Igual' ELSE 'NO' END = 'NO'
SELECT TOP  10 * FROM Financiero.ViewLoteTransaccionPorPagar
sp_helptext 'Financiero.ViewLoteTransaccionPorPagar'

SELECT TOP 10 * FROM Maestros.Moneda



------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
-- SABANA DE DIARIO
SELECT TOP 100
  vld.CodigoCompania
  ,vld.DescripcionCompania

  ,vld.CodigoLibro
  ,vld.DescripcionLibro

  ,vld.CodigoDiario
  ,vld.DescripcionDiario

  ,vld.CodigoModulo
  ,vld.DescripcionModulo

  ,vld.CodigoAnio
  ,vld.DescripcionAnio

  ,vld.CodigoAnioPeriodo
  ,vld.DescripcionAnioPeriodo

  ,vld.CodigoCuenta
  ,vld.DescripcionCuenta

  ,vld.CodigoDimensionBase
  ,vld.DescripcionDimensionBase

  ,vld.CodigoDimensionOperativa
  ,vld.DescripcionDimensionOperativa

  ,vld.CodigoEntidad
  ,vld.DescripcionEntidad

  ,vld.CodigoTipoCambio
  ,vld.CodigoMonedaTransaccion

  ,vld.DebeBase
  ,vld.HaberBase
  ,vld.SaldoBase
    
  ,vld.DebeSistema
  ,vld.HaberSistema
  ,vld.SaldoSistema

  ,vld.ImporteCambio    
      
  ,vld.Lote  
  ,vld.Transaccion
  ,vld.Detalle 
  ,vld.DetalleTrazable 
        
  ,vld.FechaDocumento 
  ,vld.FechaVencimiento 
      
  ,vld.Serie        
  ,vld.Numero  
  ,vld.CodigoTipoComprobante 
  ,vld.Documento 
        
  ,vld.IdMonedaBase        
  ,vld.IdMonedaTransaccion    
  ,vld.IdT04TipoMoneda        
  ,vld.IdTipoCuentaContable        
  ,vld.DebeTransacion 
  ,vld.HaberTransacion 
    
  ,vld.MonedaOrigen
  ,vld.CodigoT04TipoMoneda
  ,vld.TipoDocumentoID
  ,vld.TipoComprobante
  ,vld.Descripcion    
  ,vld.Estado 
  ,vld.IdT10TipoComprobante    
  ,vld.idtipotransaccionsistema    
  ,vld.idestadolote    
  ,vld.IdArticulo  
  ,vld.IdUnidadMedida   
  ,vld.Cantidad    
  ,vld.idlote 

FROM Financiero.ViewLoteDetalle AS vld

-- ////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////// TEST //////////////////////////////////////////

SELECT * FROM  [PRODUCCION].ENPROYECDB.DBO.SALDOXCOBRAR 