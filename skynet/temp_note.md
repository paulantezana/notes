var aBuss=Datos["aBuss"]; // REQUIRED -> buscar otro  -> es par dibujar los asientos de manera estatica
var RouteScala=Datos["RouteScala"]; // no es necesario actualizar -> datos estaicos del combo
var Oficina=Datos["Oficina"]; // no es necesario actualizar -> datos estaicos del combo
var aDatItin=Datos["aDatItin"]; // no es necesario actualizar -> datos estaicos en la interfas
var Seatss=Datos["Seatss"]; // IMPORTANTE los asientos ocupados o reservados
var CantSeat=Datos["CantSeat"]; // IMPORTANTE imprime el numero de asientos vendidos y reservados
var SerieUser=Datos["SerieUser"]; // no es necesario actualizar -> datos estaticos para seleccion la serie por defecto asignada a un usuario



// Construir_BoletoViaje_Psje
// 1008				inst.getList_BoletoViaje_Psje(IdItin,IdSeat,IdOrig,IdDest,true);
// 


// inst.Construir_BoletoViaje_Psje(e,pIdItin,pIdNroSeat,pIdCOrigen,pIdCDestino,pCosto);


````sql
CREATE TABLE mante_cotizacion (
  IdCotizacion INT AUTO_INCREMENT NOT NULL,
	Serie varchar(6) DEFAULT '',
	Numero int(11) DEFAULT 0,
	FechaEmision date,
	Total double(11,2) NOT NULL,
	SubTotal double(11,2) DEFAULT 0.00,
	Exonerado double(11,2) DEFAULT 0.00,
	Igv double(11,2) DEFAULT 0.00,
	TotalEnLetra varchar(150) DEFAULT '',
	NumeroDoc varchar(15) DEFAULT '',
	FechaEntrega date DEFAULT NULL,
	Telefono varchar(32) DEFAULT '',
	RazonSocial varchar(150) DEFAULT '',
	Direccion varchar(150) DEFAULT '',
	Email varchar(150) DEFAULT '',
	Observacion varchar(150) DEFAULT '',
	IdComprobante int(3) DEFAULT 0,
	PlacaVehiculo varchar(64) DEFAULT '',

	IdAlmacen int(5) NOT NULL,
	IdEmpresa int(5) NOT NULL,
  IdCliente int DEFAULT 0,
	IdTipoDoc int(5) DEFAULT -1,
  IdUsuario INT,
  FechaCreacion DATETIME,
	Estado int(1) DEFAULT 1,
  CONSTRAINT pk_mante_cotizacion PRIMARY KEY (IdCotizacion)
);

CREATE TABLE mante_cotizacion_detalle (
  IdCotizacionDetalle INT AUTO_INCREMENT NOT NULL,
  Cantidad double(11,2) DEFAULT 0.00,
  Codigo varchar(50) DEFAULT '',
  Descripcion varchar(150) DEFAULT '',
  Precio double(11,2) DEFAULT 0.00,
  Importe double(11,2) DEFAULT 0.00,
  Unidad varchar(50) DEFAULT '',
  TipoIgv INT NOT NULL,

  IdAlmacen int(11) NOT NULL,
  IdEmpresa int(11) NOT NULL,
  IdProducto int(11) NOT NULL,
  IdTipoPrecio int(11) NOT NULL,
  IdUnidad int DEFAULT 0,
  IdCotizacion INT NOT NULL,
  CONSTRAINT pk_mante_cotizacion_detalle PRIMARY KEY (IdCotizacionDetalle)
);

-- INSERT INTO user_menu_sistema(IdForm, Enlace, Nombre, Estado, Nivel1, Nivel2, Menu, ColorFondo, ColorLetra, Permiso, Clase, Icono) 
-- 			VALUES ('220','index.php?action=ReporteCotizacion','R. Cotizacion','1','2','9','Reporte','#FFD812','','1','','fa fa-cart-arrow-down'),
-- 			       ('221','index.php?action=RegistroCotizacion','Cotizacion','1','5','18','Registro','#FF7814','','1','','');
````




```sql
CREATE TABLE mante_venta_nota_cre_deb (
  IdVentaNotaCreDeb INT AUTO_INCREMENT NOT NULL,
  NumeroDoc varchar(25) DEFAULT '',
  RasonSocial varchar(150) DEFAULT '',
  FechaEmision DATETIME,
  Direccion varchar(150) DEFAULT '',
  Email varchar(150) DEFAULT '',
  Total double(11,2) DEFAULT 0.00,
  Subtotal double(11,2) DEFAULT 0.00,
  Exonerado double(11,2) DEFAULT 0.00,
  Igv double(11,2) DEFAULT 0.00,
  Son varchar(150) DEFAULT '',
  IdCliente int(11) DEFAULT 0,
	Serie varchar(6) DEFAULT '',
	Numero int(11) DEFAULT 0,
  Contingencia TINYINT DEFAULT 0,
  Enlace varchar(200) DEFAULT '',
  ErrorSunat varchar(250) DEFAULT '',
  Formato varchar(32) DEFAULT '',

  IdEmpresa int(11) NOT NULL,
  IdAlmacen int(11) NOT NULL,
  IdComprobante int(11) NOT NULL,
  IdTipoDoc int(11) DEFAULT NULL,

  IdMotivoCreDeb int(2) DEFAULT NULL,
  SerieComprobanteAntiguo varchar(6) NOT NULL,
	NumeroComprobanteAntiguo int(11) NOT NULL,
  IdComprobanteAntiguo int(3) NOT NULL,
  IdVentaAntiguo int(3) NOT NULL,

  IdUsuario INT,
  FechaCreacion DATETIME,
	Estado int(1) DEFAULT 1,
  CONSTRAINT pk_mante_venta_nota_cre_deb PRIMARY KEY (IdVentaNotaCreDeb)
);

CREATE TABLE mante_venta_nota_cre_deb_detalle (
  IdVentaNotaCreDebDetalle int(11) AUTO_INCREMENT NOT NULL,
  Cantidad double(11,2) NOT NULL,
  Codigo varchar(50) DEFAULT  '',
  Producto varchar(150) DEFAULT '',
  Precio double(11,2) NOT NULL,
  Importe double(11,2) NOT NULL,
  Unidad varchar(50) DEFAULT '',
  TipoIgv INT NOT NULL, 

  IdEmpresa int(11) NOT NULL,
  IdAlmacen int(11) NOT NULL,
  IdProducto int(11) NOT NULL,
  IdUnidad int(11) DEFAULT 0,
  IdVentaNotaCreDeb INT NOT NULL,
  CONSTRAINT pk_mante_venta_nota_cre_deb_detalle PRIMARY KEY (IdVentaNotaCreDebDetalle)
);

CREATE TABLE `mante_notas_motivo` (
  `idComprobante` int(11) NOT NULL,
  `idMotivo` int(11) NOT NULL,
  `Nombre` varchar(150) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Estado` int(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
insert  into `mante_notas_motivo`(`idComprobante`,`idMotivo`,`Nombre`,`Estado`) values (3,1,'ANULACION DE LA OPERACION',1),(3,2,'ANULACION POR ERROR DE RUC',1),(3,3,'CORRECCION POR ERROR EN LA DESCRIPCION',1),(3,4,'DESCUENTO GLOBAL',1),(3,5,'DESCUENTO POR ITEM',1),(3,6,'DEVOLUCION TOTAL',1),(3,7,'DEVOLUCION POR ITEM',1),(3,8,'BONIFICACION',1),(4,1,'INTERESES POR MORA',1),(4,2,'AUMENTO DE VALOR',1),(4,3,'PENALIDADES',1);



DELIMITER $$
USE `db_zayber`$$
DROP FUNCTION IF EXISTS `fn_Serie_Numero_Simbolo_NC_ND`$$
CREATE FUNCTION `fn_Serie_Numero_Simbolo_NC_ND`(`pIdAlm` INT(5), `pIdComp` INT(3), `pContingencia` INT(1)) RETURNS VARCHAR(25) CHARSET utf8 COLLATE utf8_unicode_ci
    READS SQL DATA
    DETERMINISTIC
BEGIN
	DECLARE aResult VARCHAR(25);
	DECLARE aSerie INT(5);
	DECLARE aNumero INT(11);
	DECLARE aSimbolo VARCHAR(3);
	DECLARE aIdEmpresa INT(3);
	SET aSerie=1;SET aNumero=-1;SET aSimbolo='';
	
	SELECT IFNULL(Serie,1) INTO aSerie FROM `mante_almacen_serie` 
	WHERE IdComprobante=pIdComp AND IdAlmacen=pIdAlm AND Estado=1 AND `Contingencia` = pContingencia LIMIT 1;
	
	SELECT IFNULL(Simbolo,1) INTO aSimbolo FROM `mante_comprobante` WHERE IdComprobante=pIdComp LIMIT 1;
	
	SELECT IdEmpresa INTO aIdEmpresa FROM `mante_almacen_empresa` WHERE IdAlmacen=pIdAlm LIMIT 1;
	
	SELECT IFNULL(MAX(Numero+1),1) INTO aNumero FROM `mante_venta_nota_cre_deb` 
	WHERE IdComprobante=pIdComp AND Serie=aSerie AND IdEmpresa=aIdEmpresa AND `Contingencia` = pContingencia;
	
	SET aResult=CONCAT(aSimbolo,'/',aSerie,'/',aNumero);
	RETURN aResult;
END$$

DELIMITER ;
```
















## PLANTILLA
````sql
CREATE TABLE plantilla_importacion (
  idPlantillaImportacion INT AUTO_INCREMENT NOT NULL,
  marca VARCHAR(128) NOT NULL,
  modelo VARCHAR(128) NOT NULL,
  codigo VARCHAR(128) NOT NULL,
  descripcion VARCHAR(255) NOT NULL,

  precio_compra double(11,2) NOT NULL,
  precio_publico double(11,2) NOT NULL,
  precio_distribuido double(11,2) NOT NULL,
  precio_base double(11,2) NOT NULL,
  cantidad INT NOT NULL,

  observacion VARCHAR(255) DEFAULT '',
  fechaCreacion DATETIME,
  estado TINYINT DEFAULT TRUE,
  idUsuario INT NOT NULL,
  idAlmacen INT NOT NULL,
  CONSTRAINT pk_plantilla_importacion PRIMARY KEY (idPlantillaImportacion)
);
````



- 8
- 5
- 6