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
CREATE FUNCTION `fn_Serie_Numero_Simbolo_NC_ND`(`pIdAlm` INT(5), `pIdComp` INT(3), `pIdCompAntiguo` INT(3), `pContingencia` INT(1)) RETURNS VARCHAR(25) CHARSET utf8 COLLATE utf8_unicode_ci
    READS SQL DATA
    DETERMINISTIC
BEGIN
	DECLARE aResult VARCHAR(25);
	DECLARE aSerie INT(5);
	DECLARE aNumero INT(11);
	DECLARE aSimbolo VARCHAR(3);
	DECLARE aIdEmpresa INT(3);
	SET aSerie=0;SET aNumero=-1;SET aSimbolo='';
	
	SELECT IFNULL(Serie,0) INTO aSerie FROM `mante_almacen_serie` 
	WHERE IdComprobante=pIdComp AND IdAlmacen=pIdAlm AND Estado=1 AND `Contingencia` = pContingencia LIMIT 1;
	
	SELECT IFNULL(Simbolo,'') INTO aSimbolo FROM `mante_comprobante` WHERE IdComprobante=pIdComp LIMIT 1;
	
	SELECT IdEmpresa INTO aIdEmpresa FROM `mante_almacen_empresa` WHERE IdAlmacen=pIdAlm LIMIT 1;
	
	SELECT IFNULL(MAX(Numero+1),1) INTO aNumero FROM `mante_venta_nota_cre_deb` 
	WHERE IdComprobanteAntiguo=pIdCompAntiguo AND IdComprobante = pIdComp AND Serie=aSerie AND IdEmpresa=aIdEmpresa AND `Contingencia` = pContingencia;
	
	SET aResult=CONCAT(aSimbolo,'/',aSerie,'/',aNumero);
	RETURN aResult;
END$$

DELIMITER ;
```
















## PLANTILLA
```sql

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










DELIMITER $$

DROP FUNCTION IF EXISTS `fn_Save_marca_importP`$$

CREATE  FUNCTION `fn_Save_marca_importP`(`pMarca` VARCHAR(100)) RETURNS INT(2)
    READS SQL DATA
    DETERMINISTIC
BEGIN
	DECLARE aId INT(5);
	SET aId=0;
	
	SELECT IdMarca INTO aId FROM mante_marca WHERE Marca=pMarca;
	IF(aId=0)THEN
		SELECT IFNULL(MAX(IdMarca+1),1) INTO aId FROM `mante_marca`;
		INSERT INTO mante_marca VALUES(aId,pMarca,'',1);
	END IF;
		
	RETURN aId;
END$$

DELIMITER ;











DELIMITER $$

DROP FUNCTION IF EXISTS `fn_Save_modelo_importP`$$

CREATE  FUNCTION `fn_Save_modelo_importP`(`pModelo` VARCHAR(100)) RETURNS INT(2)
    READS SQL DATA
    DETERMINISTIC
BEGIN
	DECLARE aId INT(5);
	SET aId=0;
	
	SELECT IdCategoria INTO aId FROM `mante_categoria` WHERE Categoria=pModelo;
	IF(aId=0)THEN
		SELECT IFNULL(MAX(IdCategoria+1),1) INTO aId FROM `mante_categoria`;
		INSERT INTO `mante_categoria` VALUES(aId,pModelo,'',1);
	END IF;
		
	RETURN aId;
END$$

DELIMITER ;














DELIMITER $$

DROP FUNCTION IF EXISTS `fn_Save_Productos_importP`$$

CREATE  FUNCTION `fn_Save_Productos_importP`(`pCod` VARCHAR(50), `pDescrip` VARCHAR(200), `pIdMarca` INT(5), `pIdModelo` INT(5), `pCompra` DOUBLE(11,2), `pMayor` DOUBLE(11,2), `pMenor` DOUBLE(11,2), `pPublico` DOUBLE(11,2), `pIdAlm` INT(3)) RETURNS INT(2)
    READS SQL DATA
    DETERMINISTIC
BEGIN
        DECLARE aCont INT(5);
        DECLARE aId INT(11);
        SET aCont=0;SET aId=1;
        
        SELECT IFNULL(COUNT(*),0) INTO aCont FROM `mante_producto` WHERE Codigo=pCod AND `Producto` = pDescrip AND IdMarca=pIdMarca AND IdCategoria=pIdModelo ;
        IF(aCont>0)THEN
            SELECT IFNULL(IdProducto,0) INTO aId FROM `mante_producto` WHERE Codigo=pCod AND `Producto` = pDescrip AND IdMarca=pIdMarca AND IdCategoria=pIdModelo LIMIT 1;
            UPDATE `mante_producto` SET Producto=pDescrip,IdMarca=pIdMarca,IdCategoria=pIdModelo
            WHERE IdProducto=aId AND Codigo=pCod;
            SET aCont=0;
            SELECT IFNULL(COUNT(*),0) INTO  aCont FROM `mante_producto_almacen` WHERE IdAlmacen=pIdAlm AND IdProducto=aId;
            IF(aCont>0)THEN
                UPDATE `mante_producto_almacen` SET PrecioCompra=pCompra,PrecioBase=pMenor,PrecioDistribuido=pMayor,
                    PrecioPublico=pPublico
                WHERE IdAlmacen=pIdAlm AND IdProducto=aId;
            ELSE
                INSERT INTO mante_producto_almacen VALUES(pIdAlm,aId,1,1,0,pCompra,pMenor,pMayor,pPublico,1,1);
            END IF;
        ELSE
            SELECT IFNULL(MAX(IdProducto+1),1) INTO aId FROM `mante_producto`;
            INSERT INTO `mante_producto` VALUES(aId,pCod,pDescrip,pIdMarca,pIdModelo,1);
            INSERT INTO mante_producto_almacen VALUES(pIdAlm,aId,1,1,0,pCompra,pMenor,pMayor,pPublico,1,1);
        END IF;
            
        RETURN aId;
    END$$

DELIMITER ;




```















-- ##
--  - Salones
--   - Espacios / 
--   - Reservaciones


```sql
CREATE TABLE salon (
  id_salon INT AUTO_INCREMENT NOT NULL,
  nombre VARCHAR(128) NOT NULL,
  descripcion VARCHAR(255) DEFAULT '',
  n_fila INT NOT NULL,
  n_columna INT NOT NULL,
  observacion VARCHAR(255) DEFAULT '',

  fecha_creacion DATETIME,
  id_usuario INT NOT NULL,
  estado TINYINT DEFAULT 1,
  CONSTRAINT pk_salon PRIMARY KEY (id_salon)
);

CREATE TABLE salon_sesion (
  id_salon_sesion INT AUTO_INCREMENT NOT NULL,
  id_salon INT NOT NULL,

  fecha_inicio DATETIME NOT NULL,
  responsable VARCHAR(12) DEFAULT '',

  fecha_creacion DATETIME,
  id_usuario INT NOT NULL,
  estado SMALLINT DEFAULT 1,
  CONSTRAINT pk_salon_sesion PRIMARY KEY (id_salon_sesion)
);

CREATE TABLE salon_espacio(
  id_salon_espacio INT AUTO_INCREMENT NOT NULL,
  denominacion VARCHAR(32) NOT NULL,
  fila INT NOT NULL,
  columna INT NOT NULL,
  abarcar_fila INT NOT NULL,
  abarcar_columna INT NOT NULL,
  tipo enum('1','2','3'),
  estado enum('LIBRE','OCUPADO','RESERVADO','DESACTIVADO'),
  motivo_estado VARCHAR(12) DEFAULT '',

  id_salon INT NOT NULL,
  fecha_creacion DATETIME,
  id_usuario INT NOT NULL,
  CONSTRAINT pk_salon_espacio PRIMARY KEY (id_salon_espacio)
);

CREATE TABLE salon_espacio_atencion(
  id_salon_espacio_atencion INT AUTO_INCREMENT NOT NULL,
  fecha_ingreso DATETIME NOT NULL,
  fecha_salida DATETIME NOT NULL,
  observacion VARCHAR(255) DEFAULT '',

  id_salon_espacio INT NOT NULL,
  id_cliente INT NOT NULL,
  fecha_creacion DATETIME,
  id_usuario INT NOT NULL,
  estado TINYINT DEFAULT 1,
  CONSTRAINT pk_salon_espacio_atencion PRIMARY KEY (id_salon_espacio_atencion)
);



INSERT INTO user_menu_sistema(IdForm, Enlace, Nombre, Estado, Nivel1, Nivel2, Menu, ColorFondo, ColorLetra, Permiso, Clase, Icono) 
			VALUES ('216','index.php?action=ReporteGimnacio','R. Gimnacio','1','5','15','Reporte','#FFD812','','1','claRsva',''),
			       ('112','index.php?action=ProcesoGimnacio','Gimnacio','1','1','6','Principal','#FF7814','','1','claRsva','fas fa-dumbbell');

INSERT INTO salon(nombre, descripcion, n_fila, n_columna, observacion, fecha_creacion, id_usuario, estado) 
          VALUES 
            ('FUll BODY','','10','18','','2020-03-11 17:01:44','1','1'),
            ('FUll BODY 2','','10','18','','2020-03-11 17:01:44','1','1'),
            ('X BOX','','10','19','','2020-03-11 17:01:44','1','1'),
            ('BAILE','','10','19','','2020-03-11 17:01:44','1','1');

INSERT INTO salon_espacio(denominacion, fila, columna, abarcar_fila, abarcar_columna, tipo, estado, id_salon)
  VALUES 
    ('1',1,4,1,1,1,'LIBRE',1),
    ('2',1,14,1,1,1,'LIBRE',1),
    ('3',1,16,1,1,1,'LIBRE',1),
    ('4',2,3,1,1,1,'LIBRE',1),
    ('5',2,5,1,1,1,'LIBRE',1),
    ('6',2,7,1,1,1,'LIBRE',1),
    ('7',2,9,1,1,1,'LIBRE',1),
    ('8',2,11,1,1,1,'LIBRE',1),
    ('9',2,13,1,1,1,'LIBRE',1),
    ('10',2,15,1,1,1,'LIBRE',1),
    ('11',3,4,1,1,1,'LIBRE',1),
    ('12',3,6,1,1,1,'LIBRE',1),
    ('13',3,8,1,1,1,'LIBRE',1),
    ('14',3,10,1,1,1,'LIBRE',1),
    ('15',3,12,1,1,1,'LIBRE',1),
    ('16',3,14,1,1,1,'LIBRE',1),
    ('17',4,3,1,1,1,'LIBRE',1),
    ('18',4,5,1,1,1,'LIBRE',1),
    ('19',4,7,1,1,1,'LIBRE',1),
    ('20',4,9,1,1,1,'LIBRE',1),
    ('21',4,11,1,1,1,'LIBRE',1),
    ('22',4,13,1,1,1,'LIBRE',1),
    ('23',5,4,1,1,1,'LIBRE',1),
    ('24',5,6,1,1,1,'LIBRE',1),
    ('25',5,8,1,1,1,'LIBRE',1),
    ('26',5,10,1,1,1,'LIBRE',1),
    ('27',5,12,1,1,1,'LIBRE',1),
    ('28',5,14,1,1,1,'LIBRE',1),
    ('29',6,3,1,1,1,'LIBRE',1),
    ('30',6,5,1,1,1,'LIBRE',1),
    ('31',6,7,1,1,1,'LIBRE',1),
    ('32',6,9,1,1,1,'LIBRE',1),
    ('33',6,11,1,1,1,'LIBRE',1),
    ('34',6,13,1,1,1,'LIBRE',1),
    ('35',6,15,1,1,1,'LIBRE',1),
    ('36',7,4,1,1,1,'LIBRE',1),
    ('37',7,6,1,1,1,'LIBRE',1),
    ('38',7,8,1,1,1,'LIBRE',1),
    ('39',7,10,1,1,1,'LIBRE',1),
    ('40',7,12,1,1,1,'LIBRE',1),
    ('41',7,14,1,1,1,'LIBRE',1),
    ('42',8,4,1,1,1,'LIBRE',1),
    ('43',8,6,1,1,1,'LIBRE',1),
    ('44',8,8,1,1,1,'LIBRE',1),
    ('45',8,10,1,1,1,'LIBRE',1),
    ('46',8,12,1,1,1,'LIBRE',1),
    ('47',9,4,1,1,1,'LIBRE',1),
    ('48',9,6,1,1,1,'LIBRE',1),
    ('49',9,8,1,1,1,'LIBRE',1),
    ('50',9,10,1,1,1,'LIBRE',1),
    ('51',9,12,1,1,1,'LIBRE',1),
    ('52',9,14,1,1,1,'LIBRE',1),
    ('53',10,4,1,1,1,'LIBRE',1),
    ('54',10,6,1,1,1,'LIBRE',1),
    ('55',10,8,1,1,1,'LIBRE',1),
    ('56',10,10,1,1,1,'LIBRE',1),
    ('57',10,12,1,1,1,'LIBRE',1),
    ('58',10,14,1,1,1,'LIBRE',1),
    ('59',10,16,1,1,1,'LIBRE',1),

    ('A',1,1,1,1,3,'LIBRE',1),
    ('B',2,1,1,1,3,'LIBRE',1),
    ('C',3,1,1,1,3,'LIBRE',1),
    ('D',4,1,1,1,3,'LIBRE',1),
    ('E',5,1,1,1,3,'LIBRE',1),
    ('F',6,1,1,1,3,'LIBRE',1),
    ('G',7,1,1,1,3,'LIBRE',1),
    ('H',8,1,1,1,3,'LIBRE',1),
    ('I',9,1,1,1,3,'LIBRE',1),
    ('J',10,1,1,1,3,'LIBRE',1),

    ('A',1,18,1,1,3,'LIBRE',1),
    ('B',2,18,1,1,3,'LIBRE',1),
    ('C',3,18,1,1,3,'LIBRE',1),
    ('D',4,18,1,1,3,'LIBRE',1),
    ('E',5,18,1,1,3,'LIBRE',1),
    ('F',6,18,1,1,3,'LIBRE',1),
    ('G',7,18,1,1,3,'LIBRE',1),
    ('H',8,18,1,1,3,'LIBRE',1),
    ('I',9,18,1,1,3,'LIBRE',1),
    ('J',10,18,1,1,3,'LIBRE',1),

    ('FULL BODY',1,6,1,7,2,'LIBRE',1);

INSERT INTO salon_espacio(denominacion, fila, columna, abarcar_fila, abarcar_columna, tipo, estado, id_salon)
  VALUES 
    ('1',1,4,1,1,1,'LIBRE',2),
    ('2',1,14,1,1,1,'LIBRE',2),
    ('3',1,16,1,1,1,'LIBRE',2),
    ('4',2,3,1,1,1,'LIBRE',2),
    ('5',2,5,1,1,1,'LIBRE',2),
    ('6',2,7,1,1,1,'LIBRE',2),
    ('7',2,9,1,1,1,'LIBRE',2),
    ('8',2,11,1,1,1,'LIBRE',2),
    ('9',2,13,1,1,1,'LIBRE',2),
    ('10',2,15,1,1,1,'LIBRE',2),
    ('11',3,4,1,1,1,'LIBRE',2),
    ('12',3,6,1,1,1,'LIBRE',2),
    ('13',3,8,1,1,1,'LIBRE',2),
    ('14',3,10,1,1,1,'LIBRE',2),
    ('15',3,12,1,1,1,'LIBRE',2),
    ('16',3,14,1,1,1,'LIBRE',2),
    ('17',4,3,1,1,1,'LIBRE',2),
    ('18',4,5,1,1,1,'LIBRE',2),
    ('19',4,7,1,1,1,'LIBRE',2),
    ('20',4,9,1,1,1,'LIBRE',2),
    ('21',4,11,1,1,1,'LIBRE',2),
    ('22',4,13,1,1,1,'LIBRE',2),
    ('23',5,4,1,1,1,'LIBRE',2),
    ('24',5,6,1,1,1,'LIBRE',2),
    ('25',5,8,1,1,1,'LIBRE',2),
    ('26',5,10,1,1,1,'LIBRE',2),
    ('27',5,12,1,1,1,'LIBRE',2),
    ('28',5,14,1,1,1,'LIBRE',2),
    ('29',6,3,1,1,1,'LIBRE',2),
    ('30',6,5,1,1,1,'LIBRE',2),
    ('31',6,7,1,1,1,'LIBRE',2),
    ('32',6,9,1,1,1,'LIBRE',2),
    ('33',6,11,1,1,1,'LIBRE',2),
    ('34',6,13,1,1,1,'LIBRE',2),
    ('35',6,15,1,1,1,'LIBRE',2),
    ('36',7,4,1,1,1,'LIBRE',2),
    ('37',7,6,1,1,1,'LIBRE',2),
    ('38',7,8,1,1,1,'LIBRE',2),
    ('39',7,10,1,1,1,'LIBRE',2),
    ('40',7,12,1,1,1,'LIBRE',2),
    ('41',7,14,1,1,1,'LIBRE',2),
    ('42',8,4,1,1,1,'LIBRE',2),
    ('43',8,6,1,1,1,'LIBRE',2),
    ('44',8,8,1,1,1,'LIBRE',2),
    ('45',8,10,1,1,1,'LIBRE',2),
    ('46',8,12,1,1,1,'LIBRE',2),
    ('47',9,4,1,1,1,'LIBRE',2),
    ('48',9,6,1,1,1,'LIBRE',2),
    ('49',9,8,1,1,1,'LIBRE',2),
    ('50',9,10,1,1,1,'LIBRE',2),
    ('51',9,12,1,1,1,'LIBRE',2),
    ('52',9,14,1,1,1,'LIBRE',2),
    ('53',10,4,1,1,1,'LIBRE',2),
    ('54',10,6,1,1,1,'LIBRE',2),
    ('55',10,8,1,1,1,'LIBRE',2),
    ('56',10,10,1,1,1,'LIBRE',2),
    ('57',10,12,1,1,1,'LIBRE',2),
    ('58',10,14,1,1,1,'LIBRE',2),
    ('59',10,16,1,1,1,'LIBRE',2),

    ('A',1,1,1,1,3,'LIBRE',2),
    ('B',2,1,1,1,3,'LIBRE',2),
    ('C',3,1,1,1,3,'LIBRE',2),
    ('D',4,1,1,1,3,'LIBRE',2),
    ('E',5,1,1,1,3,'LIBRE',2),
    ('F',6,1,1,1,3,'LIBRE',2),
    ('G',7,1,1,1,3,'LIBRE',2),
    ('H',8,1,1,1,3,'LIBRE',2),
    ('I',9,1,1,1,3,'LIBRE',2),
    ('J',10,1,1,1,3,'LIBRE',2),

    ('A',1,18,1,1,3,'LIBRE',2),
    ('B',2,18,1,1,3,'LIBRE',2),
    ('C',3,18,1,1,3,'LIBRE',2),
    ('D',4,18,1,1,3,'LIBRE',2),
    ('E',5,18,1,1,3,'LIBRE',2),
    ('F',6,18,1,1,3,'LIBRE',2),
    ('G',7,18,1,1,3,'LIBRE',2),
    ('H',8,18,1,1,3,'LIBRE',2),
    ('I',9,18,1,1,3,'LIBRE',2),
    ('J',10,18,1,1,3,'LIBRE',2),

    ('FULL BODY 2',1,6,1,7,2,'LIBRE',2);


INSERT INTO salon_espacio(denominacion, fila, columna, abarcar_fila, abarcar_columna, tipo, estado, id_salon)
  VALUES 
    ('1',1,4,1,1,1,'LIBRE',3),
    ('2',1,14,1,1,1,'LIBRE',3),
    ('3',1,16,1,1,1,'LIBRE',3),
    ('4',2,3,1,1,1,'LIBRE',3),
    ('5',2,5,1,1,1,'LIBRE',3),
    ('6',2,7,1,1,1,'LIBRE',3),
    ('7',2,9,1,1,1,'LIBRE',3),
    ('8',2,11,1,1,1,'LIBRE',3),
    ('9',2,13,1,1,1,'LIBRE',3),
    ('10',2,15,1,1,1,'LIBRE',3),
    ('11',3,4,1,1,1,'LIBRE',3),
    ('12',3,6,1,1,1,'LIBRE',3),
    ('13',3,8,1,1,1,'LIBRE',3),
    ('14',3,10,1,1,1,'LIBRE',3),
    ('15',3,12,1,1,1,'LIBRE',3),
    ('16',3,14,1,1,1,'LIBRE',3),
    ('17',3,16,1,1,1,'LIBRE',3),
    ('18',4,3,1,1,1,'LIBRE',3),
    ('19',4,5,1,1,1,'LIBRE',3),
    ('20',4,7,1,1,1,'LIBRE',3),
    ('21',4,9,1,1,1,'LIBRE',3),
    ('22',4,11,1,1,1,'LIBRE',3),
    ('23',4,13,1,1,1,'LIBRE',3),
    ('24',4,15,1,1,1,'LIBRE',3),
    ('25',5,3,1,1,1,'LIBRE',3),
    ('26',5,5,1,1,1,'LIBRE',3),
    ('27',5,7,1,1,1,'LIBRE',3),
    ('28',5,9,1,1,1,'LIBRE',3),
    ('29',5,11,1,1,1,'LIBRE',3),
    ('30',5,13,1,1,1,'LIBRE',3),
    ('31',5,15,1,1,1,'LIBRE',3),
    ('32',5,17,1,1,1,'LIBRE',3),
    ('33',6,3,1,1,1,'LIBRE',3),
    ('34',6,5,1,1,1,'LIBRE',3),
    ('35',6,7,1,1,1,'LIBRE',3),
    ('36',6,9,1,1,1,'LIBRE',3),
    ('37',6,11,1,1,1,'LIBRE',3),
    ('38',6,13,1,1,1,'LIBRE',3),
    ('39',6,15,1,1,1,'LIBRE',3),
    ('40',7,3,1,1,1,'LIBRE',3),
    ('41',7,5,1,1,1,'LIBRE',3),
    ('42',7,7,1,1,1,'LIBRE',3),
    ('43',7,9,1,1,1,'LIBRE',3),
    ('44',7,11,1,1,1,'LIBRE',3),
    ('45',7,13,1,1,1,'LIBRE',3),
    ('46',7,15,1,1,1,'LIBRE',3),
    ('47',7,17,1,1,1,'LIBRE',3),
    ('48',8,4,1,1,1,'LIBRE',3),
    ('49',8,6,1,1,1,'LIBRE',3),
    ('50',8,8,1,1,1,'LIBRE',3),
    ('51',8,10,1,1,1,'LIBRE',3),
    ('52',8,12,1,1,1,'LIBRE',3),
    ('53',8,14,1,1,1,'LIBRE',3),
    ('54',8,16,1,1,1,'LIBRE',3),
    ('55',9,3,1,1,1,'LIBRE',3),
    ('56',9,5,1,1,1,'LIBRE',3),
    ('57',9,7,1,1,1,'LIBRE',3),
    ('58',9,9,1,1,1,'LIBRE',3),
    ('59',9,11,1,1,1,'LIBRE',3),
    ('60',9,13,1,1,1,'LIBRE',3),
    ('61',9,15,1,1,1,'LIBRE',3),
    ('62',9,17,1,1,1,'LIBRE',3),
    ('63',10,13,1,1,1,'LIBRE',3),
    ('64',10,15,1,1,1,'LIBRE',3),

    ('A',1,1,1,1,3,'LIBRE',3),
    ('B',2,1,1,1,3,'LIBRE',3),
    ('C',3,1,1,1,3,'LIBRE',3),
    ('D',4,1,1,1,3,'LIBRE',3),
    ('E',5,1,1,1,3,'LIBRE',3),
    ('F',6,1,1,1,3,'LIBRE',3),
    ('G',7,1,1,1,3,'LIBRE',3),
    ('H',8,1,1,1,3,'LIBRE',3),
    ('I',9,1,1,1,3,'LIBRE',3),
    ('J',10,1,1,1,3,'LIBRE',3),

    ('A',1,18,1,1,3,'LIBRE',3),
    ('B',2,18,1,1,3,'LIBRE',3),
    ('C',3,18,1,1,3,'LIBRE',3),
    ('D',4,18,1,1,3,'LIBRE',3),
    ('E',5,18,1,1,3,'LIBRE',3),
    ('F',6,18,1,1,3,'LIBRE',3),
    ('G',7,18,1,1,3,'LIBRE',3),
    ('H',8,18,1,1,3,'LIBRE',3),
    ('I',9,18,1,1,3,'LIBRE',3),
    ('J',10,18,1,1,3,'LIBRE',3),

    ('X-BOX',1,6,1,7,2,'LIBRE',3);


-- //
INSERT INTO salon_espacio(denominacion, fila, columna, abarcar_fila, abarcar_columna, tipo, estado, id_salon)
  VALUES 
    ('1',1,4,1,1,1,'LIBRE',4),
    ('2',1,14,1,1,1,'LIBRE',4),
    ('3',1,16,1,1,1,'LIBRE',4),
    ('4',2,3,1,1,1,'LIBRE',4),
    ('5',2,5,1,1,1,'LIBRE',4),
    ('6',2,7,1,1,1,'LIBRE',4),
    ('7',2,9,1,1,1,'LIBRE',4),
    ('8',2,11,1,1,1,'LIBRE',4),
    ('9',2,13,1,1,1,'LIBRE',4),
    ('10',2,15,1,1,1,'LIBRE',4),
    ('11',2,17,1,1,1,'LIBRE',4),

    ('12',3,4,1,1,1,'LIBRE',4),
    ('13',3,6,1,1,1,'LIBRE',4),
    ('14',3,8,1,1,1,'LIBRE',4),
    ('15',3,10,1,1,1,'LIBRE',4),
    ('16',3,12,1,1,1,'LIBRE',4),
    ('17',3,14,1,1,1,'LIBRE',4),
    ('18',3,16,1,1,1,'LIBRE',4),
    ('19',4,3,1,1,1,'LIBRE',4),
    ('20',4,5,1,1,1,'LIBRE',4),
    ('21',4,7,1,1,1,'LIBRE',4),
    ('22',4,9,1,1,1,'LIBRE',4),
    ('23',4,11,1,1,1,'LIBRE',4),
    ('24',4,13,1,1,1,'LIBRE',4),
    ('25',4,15,1,1,1,'LIBRE',4),
    ('26',5,3,1,1,1,'LIBRE',4),
    ('27',5,5,1,1,1,'LIBRE',4),
    ('28',5,7,1,1,1,'LIBRE',4),
    ('29',5,9,1,1,1,'LIBRE',4),
    ('30',5,11,1,1,1,'LIBRE',4),
    ('31',5,13,1,1,1,'LIBRE',4),
    ('32',5,15,1,1,1,'LIBRE',4),
    ('33',5,17,1,1,1,'LIBRE',4),
    ('34',6,4,1,1,1,'LIBRE',4),
    ('35',6,6,1,1,1,'LIBRE',4),
    ('36',6,8,1,1,1,'LIBRE',4),
    ('37',6,10,1,1,1,'LIBRE',4),
    ('38',6,12,1,1,1,'LIBRE',4),
    ('39',6,14,1,1,1,'LIBRE',4),
    ('40',6,16,1,1,1,'LIBRE',4),
    ('41',7,3,1,1,1,'LIBRE',4),
    ('42',7,5,1,1,1,'LIBRE',4),
    ('43',7,7,1,1,1,'LIBRE',4),
    ('44',7,9,1,1,1,'LIBRE',4),
    ('45',7,11,1,1,1,'LIBRE',4),
    ('46',7,13,1,1,1,'LIBRE',4),
    ('47',7,15,1,1,1,'LIBRE',4),
    ('48',7,17,1,1,1,'LIBRE',4),
    ('49',8,4,1,1,1,'LIBRE',4),
    ('50',8,6,1,1,1,'LIBRE',4),
    ('51',8,8,1,1,1,'LIBRE',4),
    ('52',8,10,1,1,1,'LIBRE',4),
    ('53',8,12,1,1,1,'LIBRE',4),
    ('54',8,14,1,1,1,'LIBRE',4),
    ('55',8,16,1,1,1,'LIBRE',4),
    ('56',9,3,1,1,1,'LIBRE',4),
    ('57',9,5,1,1,1,'LIBRE',4),
    ('58',9,7,1,1,1,'LIBRE',4),
    ('59',9,9,1,1,1,'LIBRE',4),
    ('60',9,11,1,1,1,'LIBRE',4),
    ('61',9,13,1,1,1,'LIBRE',4),
    ('62',9,15,1,1,1,'LIBRE',4),
    ('63',9,17,1,1,1,'LIBRE',4),
    ('64',10,4,1,1,1,'LIBRE',4),
    ('65',10,6,1,1,1,'LIBRE',4),
    ('66',10,8,1,1,1,'LIBRE',4),
    ('67',10,10,1,1,1,'LIBRE',4),
    ('68',10,12,1,1,1,'LIBRE',4),
    ('69',10,14,1,1,1,'LIBRE',4),
    ('70',10,16,1,1,1,'LIBRE',4),

    ('A',1,1,1,1,3,'LIBRE',4),
    ('B',2,1,1,1,3,'LIBRE',4),
    ('C',3,1,1,1,3,'LIBRE',4),
    ('D',4,1,1,1,3,'LIBRE',4),
    ('E',5,1,1,1,3,'LIBRE',4),
    ('F',6,1,1,1,3,'LIBRE',4),
    ('G',7,1,1,1,3,'LIBRE',4),
    ('H',8,1,1,1,3,'LIBRE',4),
    ('I',9,1,1,1,3,'LIBRE',4),
    ('J',10,1,1,1,3,'LIBRE',4),

    ('A',1,19,1,1,3,'LIBRE',4),
    ('B',2,19,1,1,3,'LIBRE',4),
    ('C',3,19,1,1,3,'LIBRE',4),
    ('D',4,19,1,1,3,'LIBRE',4),
    ('E',5,19,1,1,3,'LIBRE',4),
    ('F',6,19,1,1,3,'LIBRE',4),
    ('G',7,19,1,1,3,'LIBRE',4),
    ('H',8,19,1,1,3,'LIBRE',4),
    ('I',9,19,1,1,3,'LIBRE',4),
    ('J',10,19,1,1,3,'LIBRE',4),

    ('BAILE',1,6,1,7,2,'LIBRE',4);
```





Dos vecespor dia
11: Am.
10: Pm.

Finalizar Turno.