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
	IdAlmacen int(5) NOT NULL,
	Serie varchar(6) DEFAULT '',
	Numero int(11) DEFAULT 0,
	FechaEmision date,
	Total double(11,2) NOT NULL,
	SubTotal double(11,2) DEFAULT 0.00,
	Igv double(11,2) DEFAULT 0.00,
	TotalEnLetra varchar(150) DEFAULT '',
	IdTipoDoc int(5) DEFAULT -1,
	NumeroDoc varchar(15) DEFAULT '',
	FechaEntrega date DEFAULT NULL,
	Telefono varchar(32) DEFAULT '',
	RazonSocial varchar(150) DEFAULT '',
	Direccion varchar(150) DEFAULT '',
	Email varchar(150) DEFAULT '',
	Observacion varchar(150) DEFAULT '',
	IdComprobante int(3) DEFAULT 0,
	PlacaVehiculo varchar(64) DEFAULT '',
	IdUsuario int(11) DEFAULT NULL,

    FechaCreacion DATETIME,
    IdUsuarioCreacion INT,
	Estado int(1) DEFAULT 1,

    CONSTRAINT pk_mante_cotizacion PRIMARY KEY (IdCotizacion)
);

CREATE TABLE mante_cotizacion_detalle (
    IdCotizacionDetalle INT AUTO_INCREMENT NOT NULL,
    IdAlmacen int(11) DEFAULT NULL,
    Cantidad double(11,2) DEFAULT 0.00,
    Codigo varchar(50) DEFAULT '',
    Descripcion varchar(150) DEFAULT '',
    Precio double(11,2) DEFAULT 0.00,
    Importe double(11,2) DEFAULT 0.00,
    IdProducto int(11) DEFAULT 0,
    Unidad varchar(50) DEFAULT NULL,

    IdCotizacion INT NOT NULL,
    CONSTRAINT pk_mante_cotizacion_detalle PRIMARY KEY (IdCotizacionDetalle)
);

INSERT INTO user_menu_sistema(IdForm, Enlace, Nombre, Estado, Nivel1, Nivel2, Menu, ColorFondo, ColorLetra, Permiso, Clase, Icono) 
			VALUES ('220','index.php?action=ReporteCotizacion','R. Cotizacion','1','2','9','Reporte','#FFD812','','1','','fa fa-cart-arrow-down'),
			       ('221','index.php?action=RegistroCotizacion','Cotizacion','1','5','18','Registro','#FF7814','','1','','');

````




```sql
CREATE TABLE `mante_venta_nota_cre_deb` (
  `idVentaCreDeb` int(11) NOT NULL,
  `idVenta` int(11) DEFAULT NULL,
  `idEmpresa` int(11) DEFAULT NULL,
  `idComprobante` int(11) DEFAULT NULL,
  `FechaReg` datetime DEFAULT NULL,
  `IdUsuario` int(11) DEFAULT NULL,
  `idTipoDoc` int(11) DEFAULT NULL,
  `Ruc` varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL,
  `RasonSocial` varchar(150) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Direccion` varchar(150) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Total` double(11,2) DEFAULT 0.00,
  `Subtotal` double(11,2) DEFAULT 0.00,
  `Igv` double(11,2) DEFAULT 0.00,
  `son` varchar(150) COLLATE utf8_unicode_ci DEFAULT NULL,
  `motivoCreDeb` int(2) DEFAULT NULL,
  `idCliente` int(11) DEFAULT NULL,
  `Estado` int(2) DEFAULT NULL,
  `Serie` int(5) DEFAULT NULL,
  `Numero` int(11) DEFAULT NULL,
  `nroFactura` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `enlace` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `errorSunat` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `idComprobanteAntiguo` int(3) DEFAULT NULL,
  PRIMARY KEY (`idVentaCreDeb`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE `mante_venta_nota_cre_deb_detalle` (
  `IdEmpresa` int(11) NOT NULL,
  `IdAlmacen` int(11) NOT NULL,
  `IdVentaCredDeb` int(11) NOT NULL,
  `IdDetalle` int(11) NOT NULL,
  `Cantidad` double(11,2) DEFAULT NULL,
  `Codigo` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Producto` varchar(150) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Punitario` double(11,2) DEFAULT NULL,
  `Importe` double(11,2) DEFAULT NULL,
  `IdProducto` int(11) DEFAULT -1,
  `IdUnidad` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE `mante_notas_motivo` (
  `idComprobante` int(11) NOT NULL,
  `idMotivo` int(11) NOT NULL,
  `Nombre` varchar(150) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Estado` int(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
insert  into `mante_notas_motivo`(`idComprobante`,`idMotivo`,`Nombre`,`Estado`) values (3,1,'ANULACION DE LA OPERACION',1),(3,2,'ANULACION POR ERROR DE RUC',1),(3,3,'CORRECCION POR ERROR EN LA DESCRIPCION',1),(3,4,'DESCUENTO GLOBAL',1),(3,5,'DESCUENTO POR ITEM',1),(3,6,'DEVOLUCION TOTAL',1),(3,7,'DEVOLUCION POR ITEM',1),(3,8,'BONIFICACION',1),(4,1,'INTERESES POR MORA',1),(4,2,'AUMENTO DE VALOR',1),(4,3,'PENALIDADES',1);
```