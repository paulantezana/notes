-- =================================================================================================
-- =================================== LOGS ===================================
-- =================================================================================================
-- SELECT * FROM [Configuracion].[DiccionarioPantallaTabla]
-- SELECT * FROM [Configuracion].[DiccionarioPantallaCampo]
-- SELECT TOP 10 * FROM Auditoria.LogDeExcepciones ORDER BY Id DESC

-- =================================================================================================
-- =================================== COLUMNAS AUDITORIA ===================================
-- =================================================================================================
/*
	ALTER TABLE Maestros.AlmacenArticulo  ADD
		AplicativoCreacion varchar(30) NULL,
		OpcionCreacion varchar(30) NULL,
		FechaCreacion datetime NULL,
		UsuarioCreacion varchar(30) NULL,
		AplicativoEdicion varchar(30) NULL,
		OpcionEdicion varchar(30) NULL,
		FechaEdicion datetime NULL,
		UsuarioEdicion varchar(30) NULL,
		TStamp timestamp NULL;
*/

/*
-- =================================================================================================
-- =================================== Get BY View Id ===================================
-- =================================================================================================
EXEC Maestros.usp_ObtenerViewById
@Table   = 'ViewDiccionarioReporteDetalle',  
@Id     = 78,  
@FieldId   = 'Id',  
@AdditionalFilter = '',  
@OrderSql  = ''

-- =================================================================================================
-- =================================== PAGINADO ===================================
-- =================================================================================================
EXEC [Maestros].[usp_ObtenerViewPaginado]
 @Filtro =   '',
 @Page   = 1,
 @Rows    =15,
 @OrderBy  = 'desc',
 @SortColumn =  'id'  ,  
 @Table    ='LoteTransaccionInventarioRecepcion'  ,
 @FiltrosAdicionales =''
 */
-- =================================================================================================
-- =================================== GENERA DICCIONARIO VISTAS ===================================
-- =================================================================================================
-- USE [BD_GRUPOVALOR_DESA]
-- EXEC [Configuracion].[usp_GeneraDiccionario]


-- =================================================================================================
-- =================================== INSERTAR MENU EN PANTALLA ===================================
-- =================================================================================================
-- USE [SeguridadTest]
/*
exec [dbo].[usp_InsertarMenuPantalla]
	@Nombre = 'Reporte de Trazabilidad',
	@UrlPantalla = '/Reportes/CTB230',
	@UrlHelp = '',
	@Orden = 124,
	@IsContenedor = 0,
	@IdMenuPadre = 161;

SELECT * FROM [dbo].[Menu];

EXEC [dbo].[usp_ObtenerMenuPermitido] 1, 2, 3 -- Obtener Lista Menu
*/

/*
 -- Inserta accion permiso ===================== POR (IdPantalla)

INSERT INTO [dbo].[AccionPantalla] ([IdAccion], [IdPantalla], [Activo], [FechaInactivo], [Eliminado], [UsuarioCrea], [FechaCrea], [UsuarioModifica], [FechaModifica], TipoPantalla)
							SELECT [IdAccion], 521 AS IdPantalla, [Activo], [FechaInactivo], [Eliminado], [UsuarioCrea], [FechaCrea], [UsuarioModifica], [FechaModifica], TipoPantalla
FROM [dbo].[AccionPantalla] WHERE IdPantalla = 520 AND TipoPantalla = 'List' AND IdAccion = 2022

SELECT * FROM [dbo].[Accion] WHERE Nombre LIKE '%libe%' -- 2022
SELECT * FROM [dbo].[Pantalla] WHERE Nombre LIKE '%Recepcion%' -- 370
SELECT * FROM [dbo].[Pantalla] WHERE Nombre LIKE '%Pagos%' -- 17
SELECT * FROM [dbo].[AccionPantalla] WHERE IdPantalla = 17 AND TipoPantalla = 'Form'
SELECT * FROM [dbo].[Accion] WHERE Id IN (SELECT IdAccion FROM [dbo].[AccionPantalla] WHERE IdPantalla = 370 AND TipoPantalla = 'Form' AND IdAccion = 2022)
SELECT * FROM [dbo].[Accion] WHERE Id IN (SELECT IdAccion FROM [dbo].[AccionPantalla] WHERE IdPantalla = 521 AND TipoPantalla = 'List' AND IdAccion = 2022)

*/


-- =================================================================================================
-- =================================== ELIMINAR MENU EN PANTALLA ===================================
-- =================================================================================================
/*
SELECT * FROM [dbo].[Menu] WHERE IdMenuPadre = 447
--
SELECT * FROM [dbo].[Menu] WHERE Id = 447
SELECT * FROM [dbo].[Pantalla] WHERE IdMenu = 447
SELECT * FROM dbo.Acceso WHERE IdPantalla = 484
SELECT * FROM [dbo].[AccionPantalla]  WHERE IdPantalla = 484



------------------------------------------------------------------------------------
-- Especificar MENU ID en cada una de ellas
-- ACTION PANTALLA
DELETE ap FROM [dbo].[AccionPantalla] AS ap
INNER JOIN [dbo].[Pantalla] as p ON ap.IdPantalla = p.Id
INNER JOIN [dbo].[Menu] as m ON p.IdMenu = m.Id
WHERE m.Id IN (452,453,455,456,457,459,462,464,465,466,467)

-- ACCESO
DELETE a FROM [dbo].[Acceso] AS a
INNER JOIN [dbo].[Pantalla] as p ON a.IdPantalla = p.Id
INNER JOIN [dbo].[Menu] as m ON p.IdMenu = m.Id
WHERE m.Id IN (452,453,455,456,457,459,462,464,465,466,467)

-- PANTALLA
DELETE p FROM [dbo].[Pantalla] as p
INNER JOIN [dbo].[Menu] as m ON p.IdMenu = m.Id
WHERE m.Id IN (452,453,455,456,457,459,462,464,465,466,467)

-- MENU
DELETE FROM [dbo].[Menu] WHERE Id IN (452,453,455,456,457,459,462,464,465,466,467)
*/





/*

-- =================================================================================================
-- ================================== COMPARATIVA RESULTADOS =======================================
-- =================================================================================================

-- =========================== COMPARA SALDOS
SELECT
	Cuenta = lot.Cuenta

	-- Saldo y Movimientos del mes
	, MovMes_Lote_SaldoDebe = lotm.SaldoDebe
	, MovMes_Lote_SaldoHaber = lotm.SaldoHaber
	, MovMes_Lote_Saldo = lotm.SaldoDebe + lotm.SaldoHaber

	, MovMes_Bala_SaldoDebe = bcom.MOVdeb
	, MovMes_Bala_SaldoHaber = bcom.MOVhab
	, MovMes_Bala_Saldo = bcom.MOVdeb + bcom.MOVhab

	, MovMes_Estado = IIF(lotm.SaldoDebe + lotm.SaldoHaber = bcom.MOVdeb + bcom.MOVhab, 'VERDADERO','FALSO')

	-- Saldos Hasta la fecha
	, Lote_SaldoDebe = lot.SaldoDebe
	, Lote_SaldoHaber = lot.SaldoHaber
	, Lote_Saldo = lot.SaldoDebe + lot.SaldoHaber

	, Bala_SaldoDebe = bcom.SaldoDebe
	, Bala_SaldoHaber = bcom.SaldoHaber
	, Bala_Saldo = bcom.SaldoDebe + bcom.SaldoHaber

	, Saldo_Estado = IIF(lot.SaldoDebe + lot.SaldoHaber = bcom.SaldoDebe + bcom.SaldoHaber, 'VERDADERO','FALSO')

	-- Otros aspectos
	--, Situ_SaldoDebe = 0
	--, Situ_SaldoHaber = 0
	--, Situ_Saldo = situ.Saldo

	--, Situ_Estado = IIF(lot.SaldoDebe + lot.SaldoHaber = situ.Saldo, 'VERDADERO','FALSO')

	--, Resu_SaldoDebe = 0
	--, Resu_SaldoHaber = 0
	--, Resu_Saldo = resu.Saldo

	--, Resu_Estado = IIF(lot.SaldoDebe + lot.SaldoHaber = resu.Saldo, 'VERDADERO','FALSO')
FROM
-- Lote Detalle Saldo Acumulado
(
	SELECT Cuenta = CodigoCuenta
			, SaldoDebe = IIF(SUM(DebeBase - HaberBase) > 0, SUM(DebeBase - HaberBase), 0)
			, SaldoHaber = IIF(SUM(DebeBase - HaberBase) < 0, SUM(DebeBase - HaberBase), 0)
	FROM Financiero.ViewLoteDetalle WHERE idCompania = 18
	AND DescripcionAnioPeriodo <= '202207'
	GROUP BY CodigoCuenta
) as lot

-- Lote Detalle Saldo MES
LEFT JOIN (
	SELECT Cuenta = CodigoCuenta
			, SaldoDebe = IIF(SUM(DebeBase - HaberBase) > 0, SUM(DebeBase - HaberBase), 0)
			, SaldoHaber = IIF(SUM(DebeBase - HaberBase) < 0, SUM(DebeBase - HaberBase), 0)
	FROM Financiero.ViewLoteDetalle WHERE idCompania = 18
	AND DescripcionAnioPeriodo = '202207'
	GROUP BY CodigoCuenta 
) as lotm ON lot.Cuenta = lotm.Cuenta

-- BALANCE DE COMPROBACION
LEFT JOIN (
	SELECT Cuenta,
			SaldoDebe = FINdeb,
			SaldoHaber = FINhab,
			MOVdeb,
			MOVhab,
			MESdeb,
			MEShab
	FROM Reporte.CTB100 WHERE IdCompania = 18
	AND Periodo = '202207'
	AND Libro = 'OFICIAL'
	AND Moneda = 'PEN'
	--ORDER BY Cuenta
) as bcom ON lot.Cuenta = bcom.Cuenta

-- SITUACION FINANCIERO
LEFT JOIN (
	SELECT Cuenta = CodigoCuenta, Saldo = SaldoAcumulado FROM Reporte.CTB105 WHERE IdCompania = 18
	AND Periodo = '202207'
	AND Libro = 'OFICIAL'
	AND Moneda = 'PEN'
	AND Tipo = 'SITUACION FINANCIERA - CONCAR'
) as situ ON lot.Cuenta = situ.Cuenta

LEFT JOIN (
	SELECT Cuenta = CodigoCuenta, Saldo = SUM(Acumulado) FROM Reporte.CTB112 WHERE IdCompania = 18
	AND Periodo = '202207'
	AND Libro = 'OFICIAL'
	AND Moneda = 'PEN'
	AND Tipo = 'ESTADO DE GANANCIAS Y PERDIDAS - CONCAR'
	GROUP BY CodigoCuenta
) as resu ON lot.Cuenta = resu.Cuenta

ORDER BY lot.Cuenta


*/




/*
-- CUENTAS POR LIBRO
* 1.2 = Cuenta 10: Solo las cuentas que no son de banco cuadraron en PCH
	Emproyect: 101101-107301

* 1.3 = Cuenta 12 y 13
	Emproyect: 121101-139102

* 1.4 = Cuenta 14
	Emproyect: 141101-149202

* 1.5 = Cuenta 16 y 17
	Emproyect: 161101-179102

* 1.6 = Cuenta 19
	Emproyect: 191101-195902

* 1.11 = Cuenta 41
	Emproyect: 411101-419104

* 1.12 = Cuenta 42 y 43 
	Emproyect: 421101-434102

* 1.13 = Cuenta 46 y 47
	Emproyect: 461101-479302

-- =====================================================================================================
-- ================================== COMPARATIVA SALDOS FINALES =======================================
-- =====================================================================================================
SELECT
	lot.CodigoCuenta
	, LoteDetalle_Soles = lot.SaldoSoles
	, LoteDetalle_Dolares = lot.SaldoDolares
	, SaldoAnioCuenta_Soles = bcom.SaldoSoles
	, SaldoAnioCuenta_Dolares = bcom.SaldoDolares
	, Compara_Soles = IIF(lot.SaldoSoles = bcom.SaldoSoles, 'VERDADERO','FALSO')
	, Compara_Dolares = IIF(lot.SaldoDolares = bcom.SaldoDolares, 'VERDADERO','FALSO')
FROM
-- LoteDetalle			===== Saldo Acumulado
(
	SELECT idCompania, CodigoCuenta
			, SaldoSoles = SUM(DebeBase - HaberBase)
			, SaldoDolares = SUM(DebeSistema - HaberSistema)
	FROM Financiero.ViewLoteDetalle WHERE
	DescripcionAnioPeriodo <= '202207'
	GROUP BY idCompania, CodigoCuenta
) as lot
-- ViewSaldoAnioCuenta ====== Saldo Acumulado
LEFT JOIN (
	SELECT
		IdCompania, CodigoCuenta
		, SaldoSoles = SUM(IIF(CodigoMoneda = 'PEN',Acumulado07,0))
		, SaldoDolares = SUM(IIF(CodigoMoneda = 'USD',Acumulado07,0))
	FROM Financiero.ViewSaldoAnioCuenta
	WHERE DescripcionLibro = 'OFICIAL' AND CodigoAnio = '2022'
	GROUP BY IdCompania, CodigoCuenta
) as bcom ON lot.CodigoCuenta = bcom.CodigoCuenta AND lot.idCompania = bcom.IdCompania
WHERE lot.idCompania = 18
ORDER BY 1
*/

/*
ALTER TABLE Financiero.LoteTransaccionInventario
ADD FOREIGN KEY (IdLote) REFERENCES Financiero.Lote (Id);
*/
