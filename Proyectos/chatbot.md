# Requerimientos no funcionales
- MySql
- NodeJs con TypeScript
- ReactJs con TypeScript
- Azure o Digital Ocean

# Requerimientos Funacionales
- Multiempresa (Misma arquitectura que el sistema de buses)
- Sistema de permisos similar a "Sistema de buses"
- Integracion con Wassap, Telegram, Facebook Mensenger
- Realizar un clon del ejemplo que ya se tiene

# Tiempos
1: Modelamiento de base de datos
2: Arquitectura Backend
3: Arquitectura Frontend
4: CRUD - mantenimiento
5: Chat Wassap                  =>  Lanzamiento al publico en general

# Futuros desarrollos
6: Chat Telegram
7: Chat Facebook


# Referencia Original  N O       C A M B I A R
```sql
/*
SQLyog Ultimate v11.11 (64 bit)
MySQL - 5.5.5-10.4.25-MariaDB : Database - bus
*********************************************************************
*/


/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
/*Table structure for table `app_actions` */

DROP TABLE IF EXISTS `app_actions`;

CREATE TABLE `app_actions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `icon` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `event_name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `parent_id` int(11) NOT NULL,
  `position` enum('TABLE','TOOLBAR','FILTER','FOOTER') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shape` enum('BUTTON','ICON') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `color` varchar(24) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `keyboard_key` varchar(12) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `state` tinyint(4) DEFAULT 1,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_user` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `updated_user` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `app_actions` */

insert  into `app_actions`(`id`,`title`,`description`,`icon`,`event_name`,`parent_id`,`position`,`shape`,`color`,`keyboard_key`,`state`,`updated_at`,`created_at`,`created_user`,`updated_user`) values (1,'Nuevo','Nuevo','fa-solid fa-plus','New',0,'TOOLBAR','BUTTON','primary','F3',1,NULL,NULL,'',''),(4,'Refrescar','Refrescar','fas fa-redo-alt','Reload',0,'TOOLBAR','ICON','','F5',1,NULL,NULL,'',''),(5,'Importar','Importar','fas fa-upload','Import',0,'TOOLBAR','ICON','','CTRL+U',1,NULL,NULL,'',''),(9,'Modificar','Modificar','fas fa-pen','Edit',0,'TABLE','ICON','','F4',1,NULL,NULL,'',''),(10,'Deshabilitar','Deshabilitar','far fa-minus-square','Disable',0,'TABLE','ICON','','',1,NULL,NULL,'',''),(11,'Eliminar','Eliminar','fas fa-trash-alt','Delete',0,'TABLE','ICON','','F6',1,NULL,NULL,'',''),(12,'Token nubefact','Token nubefact','fas fa-file-medical-alt','ShowModalNubefact',0,'TABLE','ICON','','',1,NULL,NULL,'',''),(13,'Permiso punto de venta','Permiso punto de venta','fas fa-street-view','ShowModalUserWareHouse',0,'TABLE','ICON','','',1,NULL,NULL,'',''),(14,'Cambiar contraseña','Cambiar contraseña','fas fa-key','ShowModalUpdatePassword',0,'TABLE','ICON','','',1,NULL,NULL,'',''),(15,'Imprimir','Imprimir','fas fa-print','Print',0,'TABLE','ICON','','',1,NULL,NULL,'',''),(16,'Anular','Anular','fas fa-ban','Cancel',0,'TABLE','ICON','','',1,NULL,NULL,'',''),(17,'Procesar','Procesar','fas fa-play','Process',0,'TOOLBAR','ICON','','',1,NULL,NULL,'',''),(21,'Detalles','Detalles','far fa-list-alt','Detail',0,'TABLE','ICON','','',1,NULL,NULL,'',''),(22,'Pagos','Pagos','fab fa-paypal','Pay',0,'TABLE','ICON','','',1,NULL,NULL,'',''),(23,'Reenviar','Reenviar','fas fa-paper-plane','Resend',0,'TABLE','ICON','','',1,NULL,NULL,'',''),(24,'Información','Informacón','fas fa-info','Info',0,'TABLE','ICON','','',1,NULL,NULL,'',''),(25,'Guardar','Guardar','fas fa-check','Save',0,'FOOTER','BUTTON','primary','',1,NULL,NULL,'',''),(26,'Ver permisos','Ver permisos','far fa-eye','ShowAuth',0,'TABLE','ICON','','',1,NULL,NULL,'',''),(27,'Listar','Listar','fas fa-list-ul','List',0,'TOOLBAR','BUTTON','','ALT+B',1,NULL,NULL,'',''),(28,'Movimiento de caja','Movimiento de caja','fas fa-cash-register','Movement',0,'TOOLBAR','ICON','','ALT+M',1,NULL,NULL,'',''),(30,'Dibujar','Dibujar','fas fa-bus','Draw',0,'TABLE','ICON','primary','',1,NULL,NULL,'',''),(31,'Cambiar cliente','Cambiar cliente','fas fa-user','ChangeCustomer',0,'TOOLBAR','ICON','','ALT+C',1,NULL,NULL,'',''),(32,'Exportar grafico a imagen PNG','Exportar grafico a imagen PNG','fas fa-image','ExportImage',0,'TOOLBAR','ICON','','ALT+I',1,NULL,NULL,'',''),(33,'Buscar documentos','Buscar documentos','fas fa-folder-open','SearchDocument',0,'TOOLBAR','BUTTON','','',1,NULL,NULL,'',''),(34,'Permiso caja','Permiso caja','fas fa-cash-register','ShowModalUserCashBox',0,'TABLE','ICON','','',1,NULL,NULL,'',''),(35,'Movimientos','Movimientos','fas fa-list-ul','ListMovement',0,'TABLE','ICON','','',1,NULL,NULL,'',''),(36,'Clonar','Clonar','far fa-clone','Clone',0,'TABLE','ICON','','',1,NULL,NULL,'',''),(37,'Precios','Precios','fas fa-dollar-sign','Price',0,'TABLE','ICON','','',1,NULL,NULL,'',''),(38,'Verificar','Verificar','fas fa-info','Verify',0,'TABLE','ICON','','',1,NULL,NULL,'',''),(39,'Permiso agencia','Permiso agencia','fa-solid fa-building-columns','ShowModalUserAgency',0,'TABLE','ICON','','',1,NULL,NULL,'',''),(40,'Filtro','Filtro','fa-solid fa-filter','Filter',0,'TOOLBAR','ICON','','',1,NULL,NULL,'',''),(41,'Entregar','Entregar','fa-solid fa-truck-ramp-box','Deliver',0,'TABLE','ICON','','',1,NULL,NULL,'',''),(42,'Exportar html','Exportar html','','TableToHtml',0,'TOOLBAR','ICON','','',1,NULL,NULL,'','');

/*Table structure for table `app_companies` */

DROP TABLE IF EXISTS `app_companies`;

CREATE TABLE `app_companies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `document_number` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `social_reason` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `commercial_reason` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `representative` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `logo` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `logo_large` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `url` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'inner url',
  `phone` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `telephone` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `email` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `fiscal_address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `url_web` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `production` tinyint(4) DEFAULT 0,
  `plan_id` int(11) NOT NULL,
  `contract_date_of_issue` date DEFAULT NULL,
  `payment_interval_id` int(11) NOT NULL,
  `sol_user` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `sol_password` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `cert_file_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `cert_password` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `theme` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `color` varchar(12) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `state` tinyint(4) DEFAULT 1,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_user` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `updated_user` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_company_url` (`url`),
  UNIQUE KEY `uk_company_document_number` (`document_number`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `app_companies` */

insert  into `app_companies`(`id`,`document_number`,`social_reason`,`commercial_reason`,`representative`,`logo`,`logo_large`,`url`,`phone`,`telephone`,`email`,`fiscal_address`,`url_web`,`production`,`plan_id`,`contract_date_of_issue`,`payment_interval_id`,`sol_user`,`sol_password`,`cert_file_path`,`cert_password`,`theme`,`color`,`state`,`updated_at`,`created_at`,`created_user`,`updated_user`) values (1,'20538856674','ARTROSCOPICTRAUMA S.A.C.','MER','','','','20538856674','','','admin@gmail.com','AV.GRAL.GARZONNRO. 2320URB.FUNDO OYAGUE','',0,3,'2022-12-05',1,'','','','',NULL,'',1,NULL,NULL,'',''),(2,'20527573557','EMPRESA DE TRANSPORTES INTERNACIONAL IGUAZU SOCIEDAD COMERCIAL DE RESPONSABILIDAD LIMITADA','iguazu','','','','20527573557','','','iguazu@gmail.com','----TERMINAL TERRESTRE-CUSCONRO. SNINT. 214GRU.CENTRO HISTORICO','',0,3,'2022-12-05',1,'','','','',NULL,'',1,NULL,NULL,'','');

/*Table structure for table `app_company_acounts` */

DROP TABLE IF EXISTS `app_company_acounts`;

CREATE TABLE `app_company_acounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(4) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `description` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `acount` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `password` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `merchant_id` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `phone` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `cci` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `owner` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `acount_type_id` int(11) NOT NULL,
  `company_id` int(11) NOT NULL,
  `currency_id` int(11) NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_user` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `updated_user` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `state` tinyint(4) DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `acount_type_id` (`acount_type_id`),
  KEY `company_id` (`company_id`),
  KEY `currency_id` (`currency_id`),
  CONSTRAINT `app_company_acounts_ibfk_1` FOREIGN KEY (`acount_type_id`) REFERENCES `setting_acount_types` (`id`),
  CONSTRAINT `app_company_acounts_ibfk_2` FOREIGN KEY (`company_id`) REFERENCES `app_companies` (`id`),
  CONSTRAINT `app_company_acounts_ibfk_3` FOREIGN KEY (`currency_id`) REFERENCES `sunat_currencies` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `app_company_acounts` */

/*Table structure for table `app_company_conditions` */

DROP TABLE IF EXISTS `app_company_conditions`;

CREATE TABLE `app_company_conditions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `content` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `company_id` int(11) NOT NULL,
  `content_type` enum('PAYMENT','GENERAL') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `state` tinyint(4) DEFAULT 1,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_user` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `updated_user` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `app_company_conditions` */

insert  into `app_company_conditions`(`id`,`title`,`content`,`company_id`,`content_type`,`state`,`updated_at`,`created_at`,`created_user`,`updated_user`) values (1,'Condiciones de pago','Condiciones de pago',1,'PAYMENT',1,NULL,NULL,'',''),(2,'Condiciones de pago','Condiciones de pago',2,'PAYMENT',1,NULL,NULL,'','');

/*Table structure for table `app_menu_favorites` */

DROP TABLE IF EXISTS `app_menu_favorites`;

CREATE TABLE `app_menu_favorites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `menu_id` int(11) NOT NULL,
  `state` tinyint(4) DEFAULT 1,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_user` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `updated_user` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `fk_app_menu_favorites_app_users` (`user_id`),
  KEY `fk_app_menu_favorites_app_menus` (`menu_id`),
  CONSTRAINT `fk_menu_favorites_menus` FOREIGN KEY (`menu_id`) REFERENCES `app_menus` (`id`),
  CONSTRAINT `fk_menu_favorites_users` FOREIGN KEY (`user_id`) REFERENCES `app_users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `app_menu_favorites` */

/*Table structure for table `app_menus` */

DROP TABLE IF EXISTS `app_menus`;

CREATE TABLE `app_menus` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `icon` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `url_path` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `parent_id` int(11) DEFAULT 0,
  `sort_order` int(11) NOT NULL,
  `state` tinyint(4) DEFAULT 1,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_user` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `updated_user` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `app_menus` */

insert  into `app_menus`(`id`,`title`,`description`,`icon`,`url_path`,`parent_id`,`sort_order`,`state`,`updated_at`,`created_at`,`created_user`,`updated_user`) values (1,'Venta pasaje','Venta pasaje','fas fa-tools','',0,1,1,NULL,NULL,'',''),(2,'Reportes','Reportes','fas fa-chart-pie','',0,5,1,NULL,NULL,'',''),(3,'Mantenimiento','Mantenimiento','fas fa-toolbox','',0,6,1,NULL,NULL,'',''),(5,'Itinerario','Itinerario','far fa-clock','/admin/processItinerary',1,1,1,NULL,NULL,'',''),(6,'Vender','Vender','fas fa-road','/admin/processSale',1,2,1,NULL,NULL,'',''),(7,'Manifiesto','Manifiesto','fas fa-route','/admin/processItineraryManifest',1,3,1,NULL,NULL,'',''),(12,'Movimiento','Movimiento','fa-solid fa-wallet','/admin/processMovement/query',42,1,1,NULL,NULL,'',''),(13,'Validacion','Validacion','fa-solid fa-check-double','/admin/processTravel/validate',1,5,1,NULL,NULL,'',''),(22,'Ruta','Ruta','fas fa-road','/admin/maintenanceTravelRoute',3,3,1,NULL,NULL,'',''),(23,'Personal','Personal','fas fa-users','/admin/maintenanceStaff',3,4,1,NULL,NULL,'',''),(24,'Bus','Bus','fas fa-bus','/admin/maintenanceBus',3,5,1,NULL,NULL,'',''),(25,'Tipo personal','Tipo personal','fas fa-users-cog','/admin/maintenanceStaffType',3,6,1,NULL,NULL,'',''),(26,'Punto venta','Punto venta','fas fa-street-view','/admin/maintenanceWareHouse',3,7,1,NULL,NULL,'',''),(28,'Usuario','Usuario','fas fa-user','/admin/appUser',3,8,1,NULL,NULL,'',''),(29,'Roles','Roles','fas fa-user-lock','/admin/appUserRole',3,9,1,NULL,NULL,'',''),(38,'Configuracion','Configuracion','fas fa-cog','',0,7,1,NULL,NULL,'',''),(39,'Empresa','Empresa','fas fa-building','/admin/appCompany',38,1,1,NULL,NULL,'',''),(40,'Operatividad','Operatividad','fas fa-tools','/admin/settingOperability',38,2,1,NULL,NULL,'',''),(42,'Financiero','Financiero','fa-solid fa-coins','',0,3,1,NULL,NULL,'',''),(49,'Encomiendas','Encomiendas','fas fa-server','',0,2,1,NULL,NULL,'',''),(52,'Corte de caja','Corte de caja','fas fa-cut','/admin/processCashCutout',42,2,1,NULL,NULL,'',''),(53,'Anulaciones','Anulaciones','fas fa-ban','/admin/processInvoiceAvoidance',2,2,1,NULL,NULL,'',''),(57,'Caja','Caja','fas fa-wallet','/admin/maintenanceCashBox',3,10,1,NULL,NULL,'',''),(59,'Generar','Generar','fas fa-boxes','/admin/processEntrust',49,1,1,NULL,NULL,'',''),(60,'Transporte','Transporte','fas fa-truck','/admin/processEntrustManifest',49,2,1,NULL,NULL,'',''),(61,'Entrega','Entrega','fas fa-dolly','/admin/processEntrust/delivery',49,4,1,NULL,NULL,'',''),(62,'Facturación','Facturación','fas fa-file-signature','/admin/processInvoice',2,1,1,NULL,NULL,'',''),(63,'Pago web','Pago web','fas fa-globe','/admin/processPayment',42,3,1,NULL,NULL,'',''),(64,'Resumen finan.','Resumen financiero','fab fa-gg','/admin/report/financialSummary',42,4,1,NULL,NULL,'',''),(65,'Agencia','Agencia','fa-solid fa-building-columns','/admin/maintenanceAgency',3,2,1,NULL,NULL,'',''),(66,'Categoria nivel','Categoria nivel','fa-solid fa-star-and-crescent','/admin/maintenanceCategoryLevel',3,1,1,NULL,NULL,'',''),(67,'Buscar pasaje','Buscar pasaje','fa-solid fa-magnifying-glass','/admin/processTravel/search',1,4,1,NULL,NULL,'',''),(68,'Corte Caja','Corte Caja','fa-solid fa-seedling','/admin/reportCashCutout/cashCutout',2,10,1,NULL,NULL,'',''),(69,'Pasaje x fecha','Pasaje x fecha','fa-solid fa-clock','/admin/reportTravel/analytics',2,3,1,NULL,NULL,'',''),(70,'Encom. x fecha','Encom. x fecha','fa-solid fa-clock','/admin/reportEntrust/analytics',2,4,1,NULL,NULL,'',''),(71,'Pasajeros','Pasajeros','fa-solid fa-chart-simple','/admin/reportTravel/itineraryPassenger',2,5,1,NULL,NULL,'',''),(72,'Encomiendas','Encomiendas','fa-solid fa-chart-gantt','/admin/reportEntrust/entrust',2,6,1,NULL,NULL,'',''),(73,'Pasaje movimi.','Pasaje movimi.','fa-solid fa-chart-simple','/admin/reportTravel/itineraryMovement',2,7,1,NULL,NULL,'',''),(74,'Pasaje Tripulación','Pasaje Tripulación','fa-solid fa-chart-simple','/admin/reportTravel/itineraryStaff',2,8,1,NULL,NULL,'',''),(75,'Movimientos Caja','Movimientos Caja','fa-solid fa-seedling','/admin/reportMovement/movement',2,9,1,NULL,NULL,'',''),(76,'Terminos y c','Terminos y c','fa-solid fa-scale-balanced','/admin/appCompanyCondition',38,3,1,NULL,NULL,'',''),(77,'Recepción','Recepción','fa-solid fa-boxes-stacked','/admin/processEntrust/reception',49,3,1,NULL,NULL,'',''),(78,'Servicio','Servicio','fa-solid fa-tape','/admin/maintenanceService',3,11,1,NULL,NULL,'',''),(79,'Tipo Servicio','Tipo Servicio','fa-brands fa-servicestack','/admin/maintenanceServiceType',3,12,1,NULL,NULL,'',''),(80,'Cuentas','Cuentas','fa-solid fa-building-columns','/admin/appCompanyAcount',38,4,1,NULL,NULL,'',''),(81,'Pasaje docs','Pasaje docs','fa-solid fa-chart-simple','/admin/reportTravel/itineraryDocument',2,5,1,NULL,NULL,'','');

/*Table structure for table `app_payment_intervals` */

DROP TABLE IF EXISTS `app_payment_intervals`;

CREATE TABLE `app_payment_intervals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `date_interval` varchar(3) COLLATE utf8mb4_unicode_ci DEFAULT 'M',
  `state` tinyint(4) DEFAULT 1,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_user` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `updated_user` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `app_payment_intervals` */

insert  into `app_payment_intervals`(`id`,`description`,`date_interval`,`state`,`updated_at`,`created_at`,`created_user`,`updated_user`) values (1,'Mensual','M',1,NULL,NULL,'',''),(2,'Trimestral','3M',1,NULL,NULL,'',''),(3,'Semestral','6M',1,NULL,NULL,'',''),(4,'Anual','Y',1,NULL,NULL,'','');

/*Table structure for table `app_payments` */

DROP TABLE IF EXISTS `app_payments`;

CREATE TABLE `app_payments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `date_time_of_issue` datetime NOT NULL,
  `reference` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `number` int(11) DEFAULT 0,
  `is_last` tinyint(4) DEFAULT 1,
  `canceled` tinyint(4) DEFAULT 0,
  `canceled_message` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `from_date_time` date NOT NULL,
  `to_date_time` date NOT NULL,
  `total` float(8,2) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `company_id` int(11) NOT NULL,
  `state` tinyint(4) DEFAULT 1,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_user` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `updated_user` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `fk_app_payments_app_users` (`user_id`),
  KEY `fk_app_payments_app_companies` (`company_id`),
  CONSTRAINT `fk_app_payments_app_companies` FOREIGN KEY (`company_id`) REFERENCES `app_companies` (`id`),
  CONSTRAINT `fk_app_payments_app_users` FOREIGN KEY (`user_id`) REFERENCES `app_users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `app_payments` */

insert  into `app_payments`(`id`,`description`,`date_time_of_issue`,`reference`,`number`,`is_last`,`canceled`,`canceled_message`,`from_date_time`,`to_date_time`,`total`,`user_id`,`company_id`,`state`,`updated_at`,`created_at`,`created_user`,`updated_user`) values (1,'Básico','2022-12-05 21:32:04','',1,1,0,'','2022-12-05','2024-07-05',79.00,1,1,1,NULL,'2022-12-05 21:32:04','developer@admin',''),(2,'Básico','2022-12-05 21:32:38','',1,1,0,'','2022-12-05','2024-11-05',79.00,1,2,1,NULL,'2022-12-05 21:32:38','developer@admin','');

/*Table structure for table `app_plan_intervals` */

DROP TABLE IF EXISTS `app_plan_intervals`;

CREATE TABLE `app_plan_intervals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `plan_id` int(11) NOT NULL,
  `payment_interval_id` int(11) NOT NULL,
  `price` double(11,2) DEFAULT 0.00,
  `state` tinyint(4) DEFAULT 1,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_user` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `updated_user` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `app_plan_intervals` */

insert  into `app_plan_intervals`(`id`,`plan_id`,`payment_interval_id`,`price`,`state`,`updated_at`,`created_at`,`created_user`,`updated_user`) values (1,1,1,20.00,1,'2022-03-17 15:59:24','2022-01-04 12:55:38','inner@admin','inner@admin'),(2,2,1,50.00,1,'2022-01-04 12:59:09','2022-01-04 12:55:54','inner@admin','inner@admin'),(3,3,1,79.00,1,'2022-01-04 12:58:45','2022-01-04 12:57:23','inner@admin','inner@admin'),(4,4,1,110.00,1,NULL,'2022-01-04 12:58:37','inner@admin',''),(5,5,1,200.00,1,NULL,'2022-01-04 12:59:40','inner@admin','');

/*Table structure for table `app_plans` */

DROP TABLE IF EXISTS `app_plans`;

CREATE TABLE `app_plans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `state` tinyint(4) DEFAULT 1,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_user` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `updated_user` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `app_plans` */

insert  into `app_plans`(`id`,`description`,`state`,`updated_at`,`created_at`,`created_user`,`updated_user`) values (1,'Especial',1,'2022-03-17 15:59:24','2021-10-31 10:00:01','inner@admin','inner@admin'),(2,'Simple',1,'2022-01-04 12:59:09','2022-01-04 12:55:54','inner@admin','inner@admin'),(3,'Básico',1,'2022-01-04 12:58:45','2022-01-04 12:57:23','inner@admin','inner@admin'),(4,'Plus',1,NULL,'2022-01-04 12:58:37','inner@admin',''),(5,'Business',1,NULL,'2022-01-04 12:59:40','inner@admin','');

/*Table structure for table `app_screen_action_roles` */

DROP TABLE IF EXISTS `app_screen_action_roles`;

CREATE TABLE `app_screen_action_roles` (
  `user_role_id` int(11) NOT NULL,
  `screen_action_id` int(11) NOT NULL,
  KEY `fk_app_menu_action_roles_app_user_roles` (`user_role_id`),
  KEY `fk_app_menu_action_roles_app_app_menu_actions` (`screen_action_id`),
  CONSTRAINT `fk_app_screen_action_roles_app_app_screen_actions` FOREIGN KEY (`screen_action_id`) REFERENCES `app_screen_actions` (`id`),
  CONSTRAINT `fk_app_screen_action_roles_app_user_roles` FOREIGN KEY (`user_role_id`) REFERENCES `app_user_roles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `app_screen_action_roles` */

insert  into `app_screen_action_roles`(`user_role_id`,`screen_action_id`) values (1,5),(1,49),(1,50),(1,57),(1,65),(1,73),(1,80),(1,87),(1,240),(1,249),(1,259),(1,269),(1,275),(1,307),(1,313),(1,325),(1,379),(1,389),(1,396),(1,405),(1,1),(1,8),(1,15),(1,37),(1,45),(1,53),(1,60),(1,68),(1,76),(1,83),(1,90),(1,218),(1,221),(1,244),(1,252),(1,265),(1,271),(1,277),(1,293),(1,297),(1,301),(1,310),(1,316),(1,328),(1,333),(1,337),(1,342),(1,346),(1,350),(1,354),(1,366),(1,370),(1,382),(1,392),(1,399),(1,406),(1,411),(1,7),(1,43),(1,51),(1,58),(1,66),(1,74),(1,81),(1,88),(1,247),(1,250),(1,276),(1,311),(1,317),(1,329),(1,380),(1,390),(1,397),(1,407),(1,4),(1,48),(1,56),(1,63),(1,64),(1,72),(1,79),(1,86),(1,248),(1,255),(1,312),(1,318),(1,330),(1,378),(1,388),(1,395),(1,408),(1,161),(1,162),(1,163),(1,268),(1,280),(1,306),(1,13),(1,270),(1,282),(1,385),(1,18),(1,274),(1,281),(1,283),(1,296),(1,300),(1,304),(1,412),(1,129),(1,141),(1,142),(1,144),(1,146),(1,149),(1,151),(1,153),(1,164),(1,165),(1,246),(1,256),(1,260),(1,320),(1,322),(1,323),(1,373),(1,402),(1,404),(1,409),(1,128),(1,140),(1,143),(1,145),(1,147),(1,148),(1,150),(1,152),(1,245),(1,257),(1,261),(1,290),(1,319),(1,321),(1,324),(1,384),(1,401),(1,403),(1,410),(1,168),(1,338),(1,343),(1,258),(1,262),(1,331),(1,305),(1,386),(1,413),(1,332),(1,372),(1,376),(2,5),(2,49),(2,50),(2,57),(2,65),(2,73),(2,80),(2,87),(2,240),(2,249),(2,259),(2,269),(2,275),(2,307),(2,313),(2,325),(2,379),(2,389),(2,396),(2,405),(2,1),(2,8),(2,15),(2,37),(2,45),(2,53),(2,60),(2,68),(2,76),(2,83),(2,90),(2,218),(2,221),(2,244),(2,252),(2,265),(2,271),(2,277),(2,293),(2,297),(2,301),(2,310),(2,316),(2,328),(2,333),(2,337),(2,342),(2,346),(2,350),(2,354),(2,366),(2,370),(2,382),(2,392),(2,399),(2,406),(2,411),(2,7),(2,43),(2,51),(2,58),(2,66),(2,74),(2,81),(2,88),(2,247),(2,250),(2,276),(2,311),(2,317),(2,329),(2,380),(2,390),(2,397),(2,407),(2,4),(2,48),(2,56),(2,63),(2,64),(2,72),(2,79),(2,86),(2,248),(2,255),(2,312),(2,318),(2,330),(2,378),(2,388),(2,395),(2,408),(2,161),(2,162),(2,163),(2,268),(2,280),(2,306),(2,13),(2,270),(2,282),(2,385),(2,18),(2,274),(2,281),(2,283),(2,296),(2,300),(2,304),(2,412),(2,129),(2,141),(2,142),(2,144),(2,146),(2,149),(2,151),(2,153),(2,164),(2,165),(2,246),(2,256),(2,260),(2,320),(2,322),(2,323),(2,373),(2,402),(2,404),(2,409),(2,128),(2,140),(2,143),(2,145),(2,147),(2,148),(2,150),(2,152),(2,245),(2,257),(2,261),(2,290),(2,319),(2,321),(2,324),(2,384),(2,401),(2,403),(2,410),(2,168),(2,338),(2,343),(2,258),(2,262),(2,331),(2,305),(2,386),(2,413),(2,332),(2,372),(2,376),(3,5),(3,49),(3,50),(3,57),(3,65),(3,73),(3,80),(3,87),(3,240),(3,249),(3,259),(3,269),(3,275),(3,307),(3,313),(3,325),(3,379),(3,389),(3,396),(3,405),(3,1),(3,8),(3,15),(3,37),(3,45),(3,53),(3,60),(3,68),(3,76),(3,83),(3,90),(3,218),(3,221),(3,244),(3,252),(3,265),(3,271),(3,277),(3,293),(3,297),(3,301),(3,310),(3,316),(3,328),(3,333),(3,337),(3,342),(3,346),(3,350),(3,354),(3,366),(3,370),(3,382),(3,392),(3,399),(3,406),(3,411),(3,7),(3,43),(3,51),(3,58),(3,66),(3,74),(3,81),(3,88),(3,247),(3,250),(3,276),(3,311),(3,317),(3,329),(3,380),(3,390),(3,397),(3,407),(3,4),(3,48),(3,56),(3,63),(3,64),(3,72),(3,79),(3,86),(3,248),(3,255),(3,312),(3,318),(3,330),(3,378),(3,388),(3,395),(3,408),(3,161),(3,162),(3,163),(3,268),(3,280),(3,306),(3,13),(3,270),(3,282),(3,385),(3,18),(3,274),(3,281),(3,283),(3,296),(3,300),(3,304),(3,412),(3,129),(3,141),(3,142),(3,144),(3,146),(3,149),(3,151),(3,153),(3,164),(3,165),(3,246),(3,256),(3,260),(3,320),(3,322),(3,323),(3,373),(3,402),(3,404),(3,409),(3,128),(3,140),(3,143),(3,145),(3,147),(3,148),(3,150),(3,152),(3,245),(3,257),(3,261),(3,290),(3,319),(3,321),(3,324),(3,384),(3,401),(3,403),(3,410),(3,168),(3,338),(3,343),(3,258),(3,262),(3,331),(3,305),(3,386),(3,413),(3,332),(3,372),(3,376);

/*Table structure for table `app_screen_actions` */

DROP TABLE IF EXISTS `app_screen_actions`;

CREATE TABLE `app_screen_actions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_id` int(11) NOT NULL,
  `screen_id` int(11) NOT NULL,
  `sort_order` int(11) DEFAULT 1,
  `state` tinyint(4) DEFAULT 1,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_user` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `updated_user` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `fk_app_menu_actions_app_actions` (`action_id`),
  KEY `fk_app_menu_actions_app_menus` (`screen_id`),
  CONSTRAINT `fk_app_screen_actions_app_actions` FOREIGN KEY (`action_id`) REFERENCES `app_actions` (`id`),
  CONSTRAINT `fk_app_screen_actions_app_screens` FOREIGN KEY (`screen_id`) REFERENCES `app_screens` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=414 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `app_screen_actions` */

insert  into `app_screen_actions`(`id`,`action_id`,`screen_id`,`sort_order`,`state`,`updated_at`,`created_at`,`created_user`,`updated_user`) values (1,4,1,1,1,NULL,NULL,'',''),(4,11,1,1,1,NULL,NULL,'',''),(5,1,1,1,1,NULL,NULL,'',''),(7,9,1,1,1,NULL,NULL,'',''),(8,4,2,1,1,NULL,NULL,'',''),(13,16,2,1,1,NULL,NULL,'',''),(15,4,3,1,1,NULL,NULL,'',''),(18,21,3,1,1,NULL,NULL,'',''),(37,4,6,1,1,NULL,NULL,'',''),(43,9,7,1,1,NULL,NULL,'',''),(45,4,7,1,1,NULL,NULL,'',''),(48,11,7,1,1,NULL,NULL,'',''),(49,1,7,1,1,NULL,NULL,'',''),(50,1,8,1,1,NULL,NULL,'',''),(51,9,8,1,1,NULL,NULL,'',''),(53,4,8,1,1,NULL,NULL,'',''),(56,11,8,1,1,NULL,NULL,'',''),(57,1,9,1,1,NULL,NULL,'',''),(58,9,9,1,1,NULL,NULL,'',''),(60,4,9,1,1,NULL,NULL,'',''),(63,11,9,1,1,NULL,NULL,'',''),(64,11,10,1,1,NULL,NULL,'',''),(65,1,10,1,1,NULL,NULL,'',''),(66,9,10,1,1,NULL,NULL,'',''),(68,4,10,1,1,NULL,NULL,'',''),(72,11,11,1,1,NULL,NULL,'',''),(73,1,11,1,1,NULL,NULL,'',''),(74,9,11,1,1,NULL,NULL,'',''),(76,4,11,1,1,NULL,NULL,'',''),(79,11,12,1,1,NULL,NULL,'',''),(80,1,12,1,1,NULL,NULL,'',''),(81,9,12,1,1,NULL,NULL,'',''),(83,4,12,1,1,NULL,NULL,'',''),(86,11,13,1,1,NULL,NULL,'',''),(87,1,13,1,1,NULL,NULL,'',''),(88,9,13,1,1,NULL,NULL,'',''),(90,4,13,1,1,NULL,NULL,'',''),(128,27,16,1,1,NULL,NULL,'',''),(129,25,16,1,1,NULL,NULL,'',''),(140,27,22,1,1,NULL,NULL,'',''),(141,25,22,1,1,NULL,NULL,'',''),(142,25,23,1,1,NULL,NULL,'',''),(143,27,23,1,1,NULL,NULL,'',''),(144,25,24,1,1,NULL,NULL,'',''),(145,27,24,1,1,NULL,NULL,'',''),(146,25,25,1,1,NULL,NULL,'',''),(147,27,25,1,1,NULL,NULL,'',''),(148,27,26,1,1,NULL,NULL,'',''),(149,25,26,1,1,NULL,NULL,'',''),(150,27,27,1,1,NULL,NULL,'',''),(151,25,27,1,1,NULL,NULL,'',''),(152,27,28,1,1,NULL,NULL,'',''),(153,25,28,1,1,NULL,NULL,'',''),(161,12,12,1,1,NULL,NULL,'',''),(162,13,13,1,1,NULL,NULL,'',''),(163,14,13,1,1,NULL,NULL,'',''),(164,25,31,1,1,NULL,NULL,'',''),(165,25,32,1,1,NULL,NULL,'',''),(168,30,10,1,1,NULL,NULL,'',''),(218,4,41,1,1,NULL,NULL,'',''),(221,4,42,1,1,NULL,NULL,'',''),(240,1,48,1,1,NULL,NULL,'',''),(244,4,48,1,1,NULL,NULL,'',''),(245,27,49,1,1,NULL,NULL,'',''),(246,25,49,1,1,NULL,NULL,'',''),(247,9,48,1,1,NULL,NULL,'',''),(248,11,48,1,1,NULL,NULL,'',''),(249,1,50,1,1,NULL,NULL,'',''),(250,9,50,1,1,NULL,NULL,'',''),(252,4,50,1,1,NULL,NULL,'',''),(255,11,50,1,1,NULL,NULL,'',''),(256,25,51,1,1,NULL,NULL,'',''),(257,27,51,1,1,NULL,NULL,'',''),(258,34,13,1,1,NULL,NULL,'',''),(259,1,41,1,1,NULL,NULL,'',''),(260,25,52,1,1,NULL,NULL,'',''),(261,27,52,1,1,NULL,NULL,'',''),(262,35,41,1,1,NULL,NULL,'',''),(265,4,53,1,1,NULL,NULL,'',''),(268,15,53,1,1,NULL,NULL,'',''),(269,1,53,1,1,NULL,NULL,'',''),(270,16,53,1,1,NULL,NULL,'',''),(271,4,55,1,1,NULL,NULL,'',''),(274,21,55,1,1,NULL,NULL,'',''),(275,1,55,1,1,NULL,NULL,'',''),(276,9,55,1,1,NULL,NULL,'',''),(277,4,56,1,1,NULL,NULL,'',''),(280,15,56,1,1,NULL,NULL,'',''),(281,21,56,1,1,NULL,NULL,'',''),(282,16,56,1,1,NULL,NULL,'',''),(283,21,53,1,1,NULL,NULL,'',''),(290,27,57,1,1,NULL,NULL,'',''),(293,4,58,1,1,NULL,NULL,'',''),(296,21,58,1,1,NULL,NULL,'',''),(297,4,59,1,1,NULL,NULL,'',''),(300,21,59,1,1,NULL,NULL,'',''),(301,4,60,1,1,NULL,NULL,'',''),(304,21,60,1,1,NULL,NULL,'',''),(305,38,2,1,1,NULL,NULL,'',''),(306,15,2,1,1,NULL,NULL,'',''),(307,1,61,1,1,NULL,NULL,'',''),(310,4,61,1,1,NULL,NULL,'',''),(311,9,61,1,1,NULL,NULL,'',''),(312,11,61,1,1,NULL,NULL,'',''),(313,1,63,1,1,NULL,NULL,'',''),(316,4,63,1,1,NULL,NULL,'',''),(317,9,63,1,1,NULL,NULL,'',''),(318,11,63,1,1,NULL,NULL,'',''),(319,27,62,1,1,NULL,NULL,'',''),(320,25,62,1,1,NULL,NULL,'',''),(321,27,64,1,1,NULL,NULL,'',''),(322,25,64,1,1,NULL,NULL,'',''),(323,25,65,1,1,NULL,NULL,'',''),(324,27,65,1,1,NULL,NULL,'',''),(325,1,66,1,1,NULL,NULL,'',''),(328,4,66,1,1,NULL,NULL,'',''),(329,9,66,1,1,NULL,NULL,'',''),(330,11,66,1,1,NULL,NULL,'',''),(331,37,8,1,1,NULL,NULL,'',''),(332,39,13,1,1,NULL,NULL,'',''),(333,4,67,1,1,NULL,NULL,'',''),(337,4,68,1,1,NULL,NULL,'',''),(338,32,68,1,1,NULL,NULL,'',''),(342,4,69,1,1,NULL,NULL,'',''),(343,32,69,1,1,NULL,NULL,'',''),(346,4,70,1,1,NULL,NULL,'',''),(350,4,71,1,1,NULL,NULL,'',''),(354,4,72,1,1,NULL,NULL,'',''),(366,4,73,1,1,NULL,NULL,'',''),(370,4,74,1,1,NULL,NULL,'',''),(372,40,68,1,1,NULL,NULL,'',''),(373,25,76,1,1,NULL,NULL,'',''),(376,41,56,1,1,NULL,NULL,'',''),(378,11,75,1,1,NULL,NULL,'',''),(379,1,75,1,1,NULL,NULL,'',''),(380,9,75,1,1,NULL,NULL,'',''),(382,4,75,1,1,NULL,NULL,'',''),(384,27,76,1,1,NULL,NULL,'',''),(385,16,58,1,1,NULL,NULL,'',''),(386,38,58,1,1,NULL,NULL,'',''),(388,11,77,1,1,NULL,NULL,'',''),(389,1,77,1,1,NULL,NULL,'',''),(390,9,77,1,1,NULL,NULL,'',''),(392,4,77,1,1,NULL,NULL,'',''),(395,11,78,1,1,NULL,NULL,'',''),(396,1,78,1,1,NULL,NULL,'',''),(397,9,78,1,1,NULL,NULL,'',''),(399,4,78,1,1,NULL,NULL,'',''),(401,27,79,1,1,NULL,NULL,'',''),(402,25,79,1,1,NULL,NULL,'',''),(403,27,80,1,1,NULL,NULL,'',''),(404,25,80,1,1,NULL,NULL,'',''),(405,1,81,1,1,NULL,NULL,'',''),(406,4,81,1,1,NULL,NULL,'',''),(407,9,81,1,1,NULL,NULL,'',''),(408,11,81,1,1,NULL,NULL,'',''),(409,25,82,1,1,NULL,NULL,'',''),(410,27,82,1,1,NULL,NULL,'',''),(411,4,83,1,1,NULL,NULL,'',''),(412,23,42,1,1,NULL,NULL,'',''),(413,38,42,1,1,NULL,NULL,'','');

/*Table structure for table `app_screens` */

DROP TABLE IF EXISTS `app_screens`;

CREATE TABLE `app_screens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `name` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `table_name` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `view_name` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `controller` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `menu_id` int(11) DEFAULT NULL,
  `principal` tinyint(4) NOT NULL DEFAULT 0,
  `help_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `state` tinyint(4) DEFAULT 1,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_user` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `updated_user` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `key_name` (`name`),
  KEY `fk_app_screens_app_menus` (`menu_id`),
  CONSTRAINT `fk_app_screens_app_menus` FOREIGN KEY (`menu_id`) REFERENCES `app_menus` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `app_screens` */

insert  into `app_screens`(`id`,`title`,`description`,`name`,`table_name`,`view_name`,`controller`,`menu_id`,`principal`,`help_url`,`state`,`updated_at`,`created_at`,`created_user`,`updated_user`) values (1,'Itinerario','Itinerario','itinerary','process_itineraries','view_process_itineraries','processItinerary',5,1,'',1,NULL,NULL,'',''),(2,'Vender','Vender','travel','','','processTravel',6,1,'',1,NULL,NULL,'',''),(3,'Manifiesto','Manifiesto','itineraryManifest','process_itinerary_manifests','view_process_itinerary_manifests','processItineraryManifest',7,1,'',1,NULL,NULL,'',''),(6,'Movimiento','Movimiento producto','movementQuery','process_movements','view_process_movements','',12,1,'',1,NULL,NULL,'',''),(7,'Guia remisión','Guia remisión','referralGuide','','','',13,1,'',1,NULL,NULL,'',''),(8,'Ruta','Ruta','travelRoute','maintenance_travel_routes','view_maintenance_travel_routes','maintenanceTravelRoute',22,1,'',1,NULL,NULL,'',''),(9,'Personal','Personal','staff','maintenance_staffs','view_maintenance_staffs','maintenanceStaff',23,1,'',1,NULL,NULL,'',''),(10,'Bus','Bus','bus','maintenance_buses','','maintenanceBus',24,1,'',1,NULL,NULL,'',''),(11,'Tipo personal','Tipo personal','staffType','maintenance_staff_types','','maintenanceStaffType',25,1,'',1,NULL,NULL,'',''),(12,'Punto venta','Punto venta','wareHouse','maintenance_ware_houses','view_maintenance_ware_houses','maintenanceWareHouse',26,1,'',1,NULL,NULL,'',''),(13,'Usuario','Usuario','user','app_users','view_app_users','appUser',28,1,'',1,NULL,NULL,'',''),(16,'Nuevo Itinerario','Nuevo Itinerario','itineraryNew','','','processItinerary',5,0,'',1,NULL,NULL,'',''),(21,'Nuevo Movimiento','Nuevo Movimiento producto','movementQueryNew','','','',12,0,'',1,NULL,NULL,'',''),(22,'Nuevo Guia remisión','Nuevo Guia remisión','referralGuideNew','','','',13,0,'',1,NULL,NULL,'',''),(23,'Nuevo Ruta','Nuevo Ruta','travelRouteNew','maintenance_travel_routes','view_maintenance_travel_routes','maintenanceTravelRoute',22,0,'',1,NULL,NULL,'',''),(24,'Nuevo Personal','Nuevo Personal','staffNew','maintenance_staffs','view_maintenance_staffs','maintenanceStaff',23,0,'',1,NULL,NULL,'',''),(25,'Nuevo Bus','Nuevo Bus','busNew','maintenance_buses','','maintenanceBus',24,0,'',1,NULL,NULL,'',''),(26,'Nuevo Tipo personal','Nuevo Tipo personal','staffTypeNew','maintenance_staff_types','','maintenanceStaffType',25,0,'',1,NULL,NULL,'',''),(27,'Nuevo Punto venta','Nuevo Punto venta','wareHouseNew','maintenance_ware_houses','view_maintenance_ware_houses','maintenanceWareHouse',26,0,'',1,NULL,NULL,'',''),(28,'Nuevo Usuario','Nuevo Usuario','userNew','app_users','view_app_users','appUser',28,0,'',1,NULL,NULL,'',''),(31,'Empresa','Empresa','company','app_companies','','appCompany',39,1,'',1,NULL,NULL,'',''),(32,'Operatividad','Operatividad','operability','','','settingOperability',40,0,'',1,NULL,NULL,'',''),(41,'Corte de caja','Corte de caja','cashCutout','','','processCashCutout',52,1,'',1,NULL,NULL,'',''),(42,'Anulaciones','Anulaciones','invoiceAvoidance','process_invoice_avoidances','view_process_invoice_avoidances','processInvoiceAvoidance',53,0,'',1,NULL,NULL,'',''),(48,'Roles','Roles','userRole','app_user_roles','view_app_user_roles','appUserRole',29,1,'',1,NULL,NULL,'',''),(49,'Nuevo Rol','Nuevo Rol','userRoleNew','app_user_roles','view_app_user_roles','appUserRole',29,0,'',1,NULL,NULL,'',''),(50,'Caja','Caja','cashBox','maintenance_cash_boxes','','maintenanceCashBox',57,1,'',1,NULL,NULL,'',''),(51,'Nuevo Caja','Nuevo Caja','cashBoxNew','maintenance_cash_boxes','','maintenanceCashBox',57,0,'',1,NULL,NULL,'',''),(52,'Nuevo Corte de caja','Nuevo Corte de caja','cashCutoutNew','','','processCashCutout',52,0,'',1,NULL,NULL,'',''),(53,'Encomienda','Encomienda','entrust','','','processEntrust',59,1,'',1,NULL,NULL,'',''),(54,'Nueva Encomienda','Nueva Encomienda','entrustNew','','','processEntrust',59,0,'',1,NULL,NULL,'',''),(55,'Manifiesto','Manifiesto','entrustManifest','','','processEntrustManifest',60,1,'',1,NULL,NULL,'',''),(56,'Entrega encomienda','Entrega encomienda','entrustDelivery','','','processEntrust',61,1,'',1,NULL,NULL,'',''),(57,'Nuevo Manifiesto','Nuevo Manifiesto','entrustManifestNew','','','processEntrustManifest',60,0,'',1,NULL,NULL,'',''),(58,'Facturación','Facturación','invoice','process_invoices','view_process_invoices','processInvoice',62,1,'',1,NULL,NULL,'',''),(59,'Pago web','Pago web','payment','','','processPayment',63,1,'',1,NULL,NULL,'',''),(60,'Resumen financiero','Resumen financiero','reportFinancialSummary','','','report',64,1,'',1,NULL,NULL,'',''),(61,'Agencia','Agencia','agency','maintenance_agencies','view_maintenance_agencies','maintenanceAgency',65,1,'',1,NULL,NULL,'',''),(62,'Agencia Nuevo','Agencia Nuevo','agencyNew','maintenance_agencies','view_maintenance_agencies','maintenanceAgency',65,0,'',1,NULL,NULL,'',''),(63,'Categoria Nivel','Categoria Nivel','categoryLevel','maintenance_category_levels','','maintenanceCategoryLevel',66,1,'',1,NULL,NULL,'',''),(64,'Categoria Nivel Nuevo','Categoria Nivel Nuevo','categoryLevelNew','maintenance_category_levels','','maintenanceCategoryLevel',66,0,'',1,NULL,NULL,'',''),(65,'Precios Nuevo','Precios Nuevo','ratePriceNew','','','processRatePrice',67,1,'',1,NULL,NULL,'',''),(66,'Precios','Precios','ratePrice','','','processRatePrice',67,0,'',1,NULL,NULL,'',''),(67,'Corte Caja','Corte Caja','reportCashCutout','process_cash_cutouts','view_rpt_process_cash_cutouts','processPivotReport',68,1,'',1,NULL,NULL,'',''),(68,'Travel Grid','Travel Grid','reportTravelAnalytics','','','reportTravel',69,1,'',1,NULL,NULL,'',''),(69,'Travel Pivot','Travel Pivot','reportTravelPivot','','','reportTravel',70,1,'',1,NULL,NULL,'',''),(70,'Pasajeros','Pasajeros','reportItineraryPassenger','process_itinerary_passengers','view_rpt_process_itinerary_passengers','reportTravel',71,1,'',1,NULL,NULL,'',''),(71,'Encomienda','Encomienda','reportEntrust','process_entrusts','view_rpt_process_entrusts','processPivotReport',72,1,'',1,NULL,NULL,'',''),(72,'Pasaje movimi.','Pasaje movimi.','reportItineraryMovement','process_itinerary_movements','view_rpt_process_itinerary_movements','reportTravel',73,1,'',1,NULL,NULL,'',''),(73,'Pasaje Trip','Pasaje Trip','reportItineraryStaff','process_itinerary_staffs','view_rpt_process_itinerary_staffs','reportTravel',74,1,'',1,NULL,NULL,'',''),(74,'Movimiento Caja','Movimiento Caja','reportMovement','process_movements','view_rpt_process_movements','processPivotReport',75,1,'',1,NULL,NULL,'',''),(75,'Terminos y condiciones','Terminos y condiciones','companyCondition','app_company_conditions','','appCompanyCondition',76,1,'',1,NULL,NULL,'',''),(76,'Nuevo termino y condicion','Nuevo termino y condicion','companyConditionNew','app_company_conditions','','appCompanyCondition',76,0,'',1,NULL,NULL,'',''),(77,'Servicio','Servicio','service','maintenance_services','view_maintenance_services','maintenanceService',78,1,'',1,NULL,NULL,'',''),(78,'Tipo Servicio','Tipo Servicio','serviceType','maintenance_service_types','','maintenanceServiceType',79,1,'',1,NULL,NULL,'',''),(79,'Nuevo Servicio','Nuevo Servicio','serviceNew','maintenance_services','view_maintenance_services','maintenanceService',78,0,'',1,NULL,NULL,'',''),(80,'Nuevo Tipo Servicio','Nuevo Tipo Servicio','serviceTypeNew','maintenance_service_types','','maintenanceServiceType',79,0,'',1,NULL,NULL,'',''),(81,'Cuenta','Cuenta','companyAcount','app_company_acounts','view_app_company_acounts','appCompanyAcount',80,1,'',1,NULL,NULL,'',''),(82,'Nuevo Cuenta','Nuevo Cuenta','companyAcountNew','app_company_acounts','view_app_company_acounts','appCompanyAcount',80,0,'',1,NULL,NULL,'',''),(83,'Pasaje documentos','Pasaje documentos','reportItineraryDocument','process_itinerary_documents','view_rpt_process_itinerary_documents','reportTravel',81,1,'',1,NULL,NULL,'','');

/*Table structure for table `app_user_companies` */

DROP TABLE IF EXISTS `app_user_companies`;

CREATE TABLE `app_user_companies` (
  `user_id` int(11) NOT NULL,
  `company_id` int(11) NOT NULL,
  KEY `fk_user_companies_users` (`user_id`),
  KEY `fk_user_companies_companies` (`company_id`),
  CONSTRAINT `fk_user_companies_companies` FOREIGN KEY (`company_id`) REFERENCES `app_companies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_user_companies_users` FOREIGN KEY (`user_id`) REFERENCES `app_users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `app_user_companies` */

insert  into `app_user_companies`(`user_id`,`company_id`) values (2,1),(1,1),(3,2),(1,2);

/*Table structure for table `app_user_forgots` */

DROP TABLE IF EXISTS `app_user_forgots`;

CREATE TABLE `app_user_forgots` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `secret_key` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_used` tinyint(4) DEFAULT 0,
  `state` tinyint(4) DEFAULT 1,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_user` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `updated_user` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `fk_app_user_forgots_app_users` (`user_id`),
  CONSTRAINT `fk_app_user_forgots_app_users` FOREIGN KEY (`user_id`) REFERENCES `app_users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `app_user_forgots` */

/*Table structure for table `app_user_role_companies` */

DROP TABLE IF EXISTS `app_user_role_companies`;

CREATE TABLE `app_user_role_companies` (
  `user_role_id` int(11) NOT NULL,
  `company_id` int(11) NOT NULL,
  KEY `fk_user_role_companies_users` (`user_role_id`),
  KEY `fk_user_role_companies_companies` (`company_id`),
  CONSTRAINT `fk_user_role_companies_companies` FOREIGN KEY (`company_id`) REFERENCES `app_companies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_user_role_companies_users` FOREIGN KEY (`user_role_id`) REFERENCES `app_user_roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `app_user_role_companies` */

insert  into `app_user_role_companies`(`user_role_id`,`company_id`) values (2,1),(1,1),(3,2),(1,2);

/*Table structure for table `app_user_roles` */

DROP TABLE IF EXISTS `app_user_roles`;

CREATE TABLE `app_user_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state` tinyint(4) DEFAULT 1,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_user` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `updated_user` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `app_user_roles` */

insert  into `app_user_roles`(`id`,`description`,`state`,`updated_at`,`created_at`,`created_user`,`updated_user`) values (1,'Developer',1,NULL,NULL,'',''),(2,'Administrador',1,NULL,NULL,'',''),(3,'Administrador',1,NULL,NULL,'','');

/*Table structure for table `app_users` */

DROP TABLE IF EXISTS `app_users`;

CREATE TABLE `app_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `full_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `gender` enum('0','1','2') COLLATE utf8mb4_unicode_ci DEFAULT '2',
  `avatar` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `email` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `identity_document_number` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `phone` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `is_verified` tinyint(4) DEFAULT 0,
  `date_verified` datetime DEFAULT NULL,
  `is_inner` tinyint(4) DEFAULT 0,
  `identity_document_id` int(11) NOT NULL,
  `user_role_id` int(11) DEFAULT NULL,
  `state` tinyint(4) DEFAULT 1,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_user` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `updated_user` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_name` (`user_name`),
  UNIQUE KEY `email` (`email`),
  KEY `fk_app_users_sunat_identity_document_types` (`identity_document_id`),
  CONSTRAINT `fk_app_users_sunat_identity_document_types` FOREIGN KEY (`identity_document_id`) REFERENCES `sunat_identity_document_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `app_users` */

insert  into `app_users`(`id`,`user_name`,`password`,`full_name`,`last_name`,`gender`,`avatar`,`email`,`identity_document_number`,`phone`,`is_verified`,`date_verified`,`is_inner`,`identity_document_id`,`user_role_id`,`state`,`updated_at`,`created_at`,`created_user`,`updated_user`) values (1,'developer@admin','$2y$10$AHqA.v5m6X9/b4gNwJH6CuIHbr/U.t5IKGxoS4ZfnLhASDO87duEu','','','2','','developer@dev.com','','',0,NULL,1,1,1,1,NULL,NULL,'',''),(2,'20538856674','$2y$10$.idPxO30uRlEHwgo79QYoOn67b3bFzMxUKTZkH7.rLiNli89oeMGa','ARTROSCOPICTRAUMA S.A.C.','','2','','admin@gmail.com','20538856674','',0,NULL,0,3,2,1,NULL,NULL,'',''),(3,'20527573557','$2y$10$mEA7Jm0CgNZJaoq0sIv8t.SJ4qCFLVcF.eFFPbtVwgZ7XVzo.T0C.','EMPRESA DE TRANSPORTES INTERNACIONAL IGUAZU SOCIEDAD COMERCIAL DE RESPONSABILIDAD LIMITADA','','2','','iguazu@gmail.com','20527573557','',0,NULL,0,3,3,1,NULL,NULL,'','');

/*Table structure for table `log_exceptions` */

DROP TABLE IF EXISTS `log_exceptions`;

CREATE TABLE `log_exceptions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `host` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `stack` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `message` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `state` tinyint(4) DEFAULT 1,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_user` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `updated_user` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `log_exceptions` */

insert  into `log_exceptions`(`id`,`content`,`host`,`path`,`stack`,`message`,`state`,`updated_at`,`created_at`,`created_user`,`updated_user`) values (1,'{\"POST\":{\"filter\":[{\"id\":\"671661\",\"logicalOperator\":\"or\",\"prefix\":\"DONDE\",\"eval\":[]},{\"id\":\"310616\",\"logicalOperator\":\"and\",\"prefix\":\"DONDE\",\"eval\":[]}],\"sorter\":{\"field\":\"id\",\"order\":\"desc\"},\"limit\":20,\"page\":1}}','http://localhost:80','/snbus/public/admin/reportTravel/itineraryExpenseTable','#0 D:\\local\\snbus\\app\\Core\\Model.php(36): PDO->query(\'SELECT COUNT(*)...\')\n#1 D:\\local\\snbus\\app\\Controllers\\admin\\ReportTravelController.php(124): Model->paginate(Array, \'view_rpt_\')\n#2 D:\\local\\snbus\\app\\route.php(112): ReportTravelController->itinerary','SQLSTATE[42S02]: Base table or view not found: 1146 Table \'bus.view_rpt_process_itinerary_movements\' doesn\'t exist',1,NULL,'2022-12-09 19:01:53','developer@admin',''),(2,'[]','http://localhost:80','/snbus/public/admin/reportTravel/itineraryMovement','#0 D:\\local\\snbus\\app\\Helpers\\Common.php(24): exceptions_error_handler(2, \'require(D:/loca...\', \'D:\\\\local\\\\snbus\\\\...\', 24, Array)\n#1 D:\\local\\snbus\\app\\Helpers\\Common.php(24): require()\n#2 D:\\local\\snbus\\app\\Core\\Controller.php(46): requireToVar(\'D:/loc','require(D:/local/snbus/public/../app/Views/admin/reportItineraryMovement.view.php): failed to open stream: No such file or directory',1,NULL,'2022-12-09 19:08:41','developer@admin',''),(3,'[]','http://localhost:80','/snbus/public/admin/reportTravel/itineraryMovement','#0 D:\\local\\snbus\\app\\Helpers\\Common.php(24): exceptions_error_handler(2, \'require(D:/loca...\', \'D:\\\\local\\\\snbus\\\\...\', 24, Array)\n#1 D:\\local\\snbus\\app\\Helpers\\Common.php(24): require()\n#2 D:\\local\\snbus\\app\\Core\\Controller.php(46): requireToVar(\'D:/loc','require(D:/local/snbus/public/../app/Views/admin/reportItineraryMovement.view.php): failed to open stream: No such file or directory',1,NULL,'2022-12-09 19:09:20','developer@admin',''),(4,'{\"POST\":{\"filter\":[{\"id\":\"067436\",\"logicalOperator\":\"or\",\"prefix\":\"DONDE\",\"eval\":[]},{\"id\":\"117224\",\"logicalOperator\":\"and\",\"prefix\":\"DONDE\",\"eval\":[]}],\"sorter\":{\"field\":\"id\",\"order\":\"desc\"},\"limit\":20,\"page\":1}}','http://localhost:80','/snbus/public/admin/reportTravel/itineraryMovementTable','#0 D:\\local\\snbus\\app\\Core\\Model.php(36): PDO->query(\'SELECT COUNT(*)...\')\n#1 D:\\local\\snbus\\app\\Controllers\\admin\\ReportTravelController.php(124): Model->paginate(Array, \'view_rpt_\')\n#2 D:\\local\\snbus\\app\\route.php(112): ReportTravelController->itinerary','SQLSTATE[42S02]: Base table or view not found: 1146 Table \'bus.view_rpt_process_itinerary_movements\' doesn\'t exist',1,NULL,'2022-12-09 19:22:22','developer@admin',''),(5,'{\"POST\":{\"filterable\":[{\"id\":\"613712\",\"logicalOperator\":\"or\",\"prefix\":\"DONDE\",\"eval\":[]}],\"entityName\":\"reportItineraryMovement\"}}','http://localhost:80','/snbus/public/admin/processPivotReport/data','#0 D:\\local\\snbus\\app\\Controllers\\admin\\ProcessPivotReportController.php(49): exceptions_error_handler(8, \'Undefined index...\', \'D:\\\\local\\\\snbus\\\\...\', 49, Array)\n#1 D:\\local\\snbus\\app\\route.php(112): ProcessPivotReportController->data(NULL)\n#2 D:\\local\\','Undefined index: filter',1,NULL,'2022-12-09 19:35:56','developer@admin',''),(6,'{\"POST\":{\"itineraryId\":\"10\",\"movement\":\"I\",\"paymentMethodId\":\"1\",\"description\":\"regristro de entrada por donacion\",\"refer\":\"donacon\",\"currencyId\":\"1\",\"amount\":\"15\"}}','http://localhost:80','/snbus/public/admin/processItineraryMovement/itineraryMovementCreate','#0 D:\\local\\snbus\\app\\Models\\ProcessItineraryMovement.php(41): PDOStatement->execute()\n#1 D:\\local\\snbus\\app\\Controllers\\admin\\ProcessItineraryMovementController.php(65): ProcessItineraryMovement->insrtPostProcess(\'8\')\n#2 D:\\local\\snbus\\app\\route.php(112)','SQLSTATE[21000]: Cardinality violation: 1222 The used SELECT statements have a different number of columns',1,NULL,'2022-12-10 06:14:58','developer@admin',''),(7,'{\"POST\":{\"itineraryId\":\"10\",\"movement\":\"I\",\"paymentMethodId\":\"1\",\"description\":\"regristro de entrada por donacion\",\"refer\":\"donacon\",\"currencyId\":\"1\",\"amount\":\"15\"}}','http://localhost:80','/snbus/public/admin/processItineraryMovement/itineraryMovementCreate','#0 D:\\local\\snbus\\app\\Models\\ProcessItineraryMovement.php(41): PDOStatement->execute()\n#1 D:\\local\\snbus\\app\\Controllers\\admin\\ProcessItineraryMovementController.php(65): ProcessItineraryMovement->insrtPostProcess(\'9\')\n#2 D:\\local\\snbus\\app\\route.php(112)','SQLSTATE[42S22]: Column not found: 1054 Unknown column \'pim.state\' in \'field list\'',1,NULL,'2022-12-10 06:18:14','developer@admin',''),(8,'{\"POST\":{\"itineraryId\":\"10\",\"movement\":\"I\",\"paymentMethodId\":\"1\",\"description\":\"regristro de entrada por donacion\",\"refer\":\"donacon\",\"currencyId\":\"1\",\"amount\":\"15\"}}','http://localhost:80','/snbus/public/admin/processItineraryMovement/itineraryMovementCreate','#0 D:\\local\\snbus\\app\\Models\\ProcessItineraryMovement.php(41): PDOStatement->execute()\n#1 D:\\local\\snbus\\app\\Controllers\\admin\\ProcessItineraryMovementController.php(65): ProcessItineraryMovement->insrtPostProcess(\'10\')\n#2 D:\\local\\snbus\\app\\route.php(112','SQLSTATE[23000]: Integrity constraint violation: 1052 Column \'id\' in where clause is ambiguous',1,NULL,'2022-12-10 06:19:22','developer@admin',''),(9,'{\"POST\":{\"date\":\"2022-12-10\"}}','http://localhost:80','/snbus/public/admin/report/financialSummaryData','#0 D:\\local\\snbus\\app\\Models\\ProcessItineraryMovement.php(19): PDOStatement->execute()\n#1 D:\\local\\snbus\\app\\Controllers\\admin\\ReportController.php(94): ProcessItineraryMovement->getAllDailySummary(\'1\', \'2022-12-10\', false)\n#2 D:\\local\\snbus\\app\\route.php','SQLSTATE[42S22]: Column not found: 1054 Unknown column \'cur.currency_id\' in \'on clause\'',1,NULL,'2022-12-10 06:57:11','developer@admin',''),(10,'{\"POST\":{\"date\":\"2022-12-10\"}}','http://localhost:80','/snbus/public/admin/report/financialSummaryData','#0 D:\\local\\snbus\\app\\Controllers\\admin\\ReportController.php(97): exceptions_error_handler(8, \'Undefined index...\', \'D:\\\\local\\\\snbus\\\\...\', 97, Array)\n#1 D:\\local\\snbus\\app\\route.php(112): ReportController->financialSummaryData(NULL)\n#2 D:\\local\\snbus\\pu','Undefined index: currencyId',1,NULL,'2022-12-10 08:53:23','developer@admin',''),(11,'{\"POST\":{\"date\":\"2022-12-10\",\"currencyId\":\"1\"}}','http://localhost:80','/snbus/public/admin/report/financialSummaryData','#0 D:\\local\\snbus\\app\\Models\\ProcessEntrust.php(68): PDOStatement->execute()\n#1 D:\\local\\snbus\\app\\Controllers\\admin\\ReportController.php(98): ProcessEntrust->getAllDailySummary(\'1\', \'2022-12-10\', \'1\', true)\n#2 D:\\local\\snbus\\app\\route.php(112): ReportCon','SQLSTATE[42000]: Syntax error or access violation: 1064 You have an error in your SQL syntax; check the manual that corresponds to your MariaDB server version for the right syntax to use near \'pe.currency_id = \'1\'\r\n            GROUP BY pe.id ORDER BY pe.id DESC\' at line 32',1,NULL,'2022-12-10 08:57:06','developer@admin',''),(12,'{\"POST\":{\"filterable\":[{\"id\":\"665981\",\"logicalOperator\":\"or\",\"prefix\":\"DONDE\",\"eval\":[{\"id\":\"612860\",\"logicalOperator\":\"or\",\"prefix\":\"DONDE\",\"operator\":\"se encuentra entre (incluye)\",\"field\":\"departure_date\",\"type\":\"date\",\"value1\":\"2022-12-11\",\"value2\":\"2023-01-11\"}]}],\"entityName\":\"itinerary\"}}','http://localhost:80','/snbus/public/admin/processPivotReport/data','#0 D:\\local\\snbus\\app\\Controllers\\admin\\ProcessPivotReportController.php(49): exceptions_error_handler(8, \'Undefined index...\', \'D:\\\\local\\\\snbus\\\\...\', 49, Array)\n#1 D:\\local\\snbus\\app\\route.php(112): ProcessPivotReportController->data(NULL)\n#2 D:\\local\\','Undefined index: filter',1,NULL,'2022-12-11 07:47:46','developer@admin',''),(13,'{\"POST\":{\"filterable\":[{\"id\":\"665981\",\"logicalOperator\":\"or\",\"prefix\":\"DONDE\",\"eval\":[{\"id\":\"612860\",\"logicalOperator\":\"or\",\"prefix\":\"DONDE\",\"operator\":\"se encuentra entre (incluye)\",\"field\":\"departure_date\",\"type\":\"date\",\"value1\":\"2022-12-11\",\"value2\":\"2023-01-11\"}]}],\"entityName\":\"itinerary\"}}','http://localhost:80','/snbus/public/admin/processPivotReport/data','#0 D:\\local\\snbus\\app\\Controllers\\admin\\ProcessPivotReportController.php(49): exceptions_error_handler(8, \'Undefined index...\', \'D:\\\\local\\\\snbus\\\\...\', 49, Array)\n#1 D:\\local\\snbus\\app\\route.php(112): ProcessPivotReportController->data(NULL)\n#2 D:\\local\\','Undefined index: filter',1,NULL,'2022-12-11 07:48:31','developer@admin',''),(14,'{\"POST\":{\"filterable\":[{\"id\":\"665981\",\"logicalOperator\":\"or\",\"prefix\":\"DONDE\",\"eval\":[{\"id\":\"612860\",\"logicalOperator\":\"or\",\"prefix\":\"DONDE\",\"operator\":\"se encuentra entre (incluye)\",\"field\":\"departure_date\",\"type\":\"date\",\"value1\":\"2022-12-11\",\"value2\":\"2023-01-11\"}]}],\"entityName\":\"itinerary\"}}','http://localhost:80','/snbus/public/admin/processPivotReport/data','#0 D:\\local\\snbus\\app\\Controllers\\admin\\ProcessPivotReportController.php(49): exceptions_error_handler(8, \'Undefined index...\', \'D:\\\\local\\\\snbus\\\\...\', 49, Array)\n#1 D:\\local\\snbus\\app\\route.php(112): ProcessPivotReportController->data(NULL)\n#2 D:\\local\\','Undefined index: filter',1,NULL,'2022-12-11 07:51:01','developer@admin',''),(15,'{\"POST\":{\"filterable\":[{\"id\":\"665981\",\"logicalOperator\":\"or\",\"prefix\":\"DONDE\",\"eval\":[{\"id\":\"612860\",\"logicalOperator\":\"or\",\"prefix\":\"DONDE\",\"operator\":\"se encuentra entre (incluye)\",\"field\":\"departure_date\",\"type\":\"date\",\"value1\":\"2022-12-11\",\"value2\":\"2023-01-11\"}]}],\"entityName\":\"itinerary\"}}','http://localhost:80','/snbus/public/admin/processPivotReport/data','#0 D:\\local\\snbus\\app\\Controllers\\admin\\ProcessPivotReportController.php(49): exceptions_error_handler(8, \'Undefined index...\', \'D:\\\\local\\\\snbus\\\\...\', 49, Array)\n#1 D:\\local\\snbus\\app\\route.php(112): ProcessPivotReportController->data(NULL)\n#2 D:\\local\\','Undefined index: filter',1,NULL,'2022-12-11 07:52:01','developer@admin',''),(16,'{\"POST\":{\"filter\":[{\"id\":\"665981\",\"logicalOperator\":\"or\",\"prefix\":\"DONDE\",\"eval\":[{\"id\":\"612860\",\"logicalOperator\":\"or\",\"prefix\":\"DONDE\",\"operator\":\"se encuentra entre (incluye)\",\"field\":\"departure_date\",\"type\":\"date\",\"value1\":\"2022-12-11\",\"value2\":\"2023-01-11\"}]}],\"entityName\":\"itinerary\"}}','http://localhost:80','/snbus/public/admin/processPivotReport/data','#0 D:\\local\\snbus\\app\\Models\\ProcessPivotReport.php(58): PDOStatement->execute()\n#1 D:\\local\\snbus\\app\\Models\\ProcessPivotReport.php(26): ProcessPivotReport->getTemplateByEntityNameToPivot(\'view_process_it...\')\n#2 D:\\local\\snbus\\app\\Controllers\\admin\\Proc','SQLSTATE[42000]: Syntax error or access violation: 1064 You have an error in your SQL syntax; check the manual that corresponds to your MariaDB server version for the right syntax to use near \'NO IN (\'updated_at\',\'created_at\',\'created_user\',\'updated_user\')\r\n            ...\' at line 3',1,NULL,'2022-12-11 09:09:26','developer@admin','');

/*Table structure for table `setting_operabilities` */

DROP TABLE IF EXISTS `setting_operabilities`;

CREATE TABLE `setting_operabilities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `seat_sale_document_type_id` tinyint(4) DEFAULT 0,
  `seat_sale_with_taxes` tinyint(4) DEFAULT 0,
  `currency_id` int(11) NOT NULL,
  `company_id` int(11) NOT NULL,
  `state` tinyint(4) DEFAULT 1,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_user` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `updated_user` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `fk_setting_operabilities_app_companies` (`company_id`),
  KEY `fk_setting_operabilities_sunat_currencies` (`currency_id`),
  CONSTRAINT `fk_setting_operabilities_app_companies` FOREIGN KEY (`company_id`) REFERENCES `app_companies` (`id`),
  CONSTRAINT `fk_setting_operabilities_sunat_currencies` FOREIGN KEY (`currency_id`) REFERENCES `sunat_currencies` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `setting_operabilities` */

insert  into `setting_operabilities`(`id`,`seat_sale_document_type_id`,`seat_sale_with_taxes`,`currency_id`,`company_id`,`state`,`updated_at`,`created_at`,`created_user`,`updated_user`) values (1,1,1,1,1,1,'2022-12-05 22:13:17',NULL,'','developer@admin'),(2,0,0,1,2,1,NULL,NULL,'','');

/*Table structure for table `setting_payment_methods` */

DROP TABLE IF EXISTS `setting_payment_methods`;

CREATE TABLE `setting_payment_methods` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nubefact_code` varchar(6) COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(6) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state` tinyint(4) DEFAULT 1,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_user` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `updated_user` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `setting_payment_methods` */

insert  into `setting_payment_methods`(`id`,`nubefact_code`,`code`,`description`,`state`,`updated_at`,`created_at`,`created_user`,`updated_user`) values (1,'','EFE','Efectivo',1,NULL,NULL,'',''),(2,'','TAR','Tarjeta',1,NULL,NULL,'',''),(3,'','VAL','Vale',1,NULL,NULL,'',''),(5,'','DEP','Deposito',1,NULL,NULL,'',''),(6,'','APP','App',1,NULL,NULL,'',''),(7,'','CRE','Credito',1,NULL,NULL,'',''),(8,'','POS','Post',1,NULL,NULL,'','');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;






































































































































/*
SQLyog Ultimate v11.11 (64 bit)
MySQL - 5.5.5-10.10.2-MariaDB-1:10.10.2+maria~ubu2204 : Database - whaticket
*********************************************************************
*/


/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
/*Table structure for table `ContactCustomFields` */

DROP TABLE IF EXISTS `ContactCustomFields`;

CREATE TABLE `ContactCustomFields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  `contactId` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `contactId` (`contactId`),
  CONSTRAINT `ContactCustomFields_ibfk_1` FOREIGN KEY (`contactId`) REFERENCES `Contacts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

/*Data for the table `ContactCustomFields` */

/*Table structure for table `Contacts` */

DROP TABLE IF EXISTS `Contacts`;

CREATE TABLE `Contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `number` varchar(255) NOT NULL,
  `profilePicUrl` varchar(255) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `email` varchar(255) NOT NULL DEFAULT '',
  `isGroup` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `number` (`number`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

/*Data for the table `Contacts` */

insert  into `Contacts`(`id`,`name`,`number`,`profilePicUrl`,`createdAt`,`updatedAt`,`email`,`isGroup`) values (1,'Sistemas Operativos ','120363045653037316','https://pps.whatsapp.net/v/t61.24694-24/309706988_807992887111700_5385826186737487758_n.jpg?ccb=11-4&oh=01_AdT3m9DHzvFVHF84s-2d21GT8S5Wn0FQRnXEmVARDNu4jA&oe=639F88AE','2022-12-08 21:18:07','2022-12-08 21:18:07','',1),(2,'Gerardo G.','51950764695',NULL,'2022-12-08 21:18:07','2022-12-08 21:18:07','',0),(3,'∆','51931621021',NULL,'2022-12-08 21:18:08','2022-12-08 21:18:08','',0),(4,'Nik_edu','51953091699','https://pps.whatsapp.net/v/t61.24694-24/56140567_325160358190923_8997028067809427456_n.jpg?ccb=11-4&oh=01_AdQ6slURtkJRb8kPNc4Avyi04Aa6YATeABI06nlXF2s84w&oe=639F812E','2022-12-08 21:18:09','2022-12-08 21:18:09','',0),(5,'Mundialito del por venir.','120363045509988445','https://pps.whatsapp.net/v/t61.24694-24/315278425_129339983273770_2587934786459477740_n.jpg?ccb=11-4&oh=01_AdRZZbgiUZZ0SxASui6LfDwI_Sx1N8eioObQQOwbPswdtw&oe=639F78BD','2022-12-08 21:18:16','2022-12-08 21:18:16','',1),(6,'Bruce','51986661151','https://pps.whatsapp.net/v/t61.24694-24/130284267_825231211367641_7041936648128796180_n.jpg?ccb=11-4&oh=01_AdTEMa3GCdvO-WydwLn-sHl6Hybe-8nWAcZzVipZyvr_4Q&oe=639F948E','2022-12-08 21:18:16','2022-12-08 21:18:16','',0),(7,'Gerson Flores','51947681529','https://pps.whatsapp.net/v/t61.24694-24/217850150_5618886161521204_3464000753054421036_n.jpg?ccb=11-4&oh=01_AdRHjif-O6hCs6-gWRknfgEZKh_x8EZ5-BoxE3XWHo6V4Q&oe=639F9C37','2022-12-08 21:18:17','2022-12-08 21:18:17','',0),(8,'Rich Maddox','51994662620','https://pps.whatsapp.net/v/t61.24694-24/163059185_222202940112525_8379448794065817528_n.jpg?ccb=11-4&oh=01_AdTcL-7sYDFX3zps0lGLn1Iqe-BxrbsYcqNMBlCdRWa7Ig&oe=639FA778','2022-12-08 21:18:18','2022-12-08 21:18:18','',0),(9,'Andree Guerrero Turin','51978882061','https://pps.whatsapp.net/v/t61.24694-24/307872419_160860389891056_8319082911592244096_n.jpg?ccb=11-4&oh=01_AdQP7gcC_G6d8sAiLneMFrWAqn_qEV5vMQ0XRdghYhF2hQ&oe=639F9551','2022-12-08 21:18:19','2022-12-08 21:18:19','',0),(10,'?ING. DE SISTEMAS E INFORMATICA.?️◽','51936548331-1590599355','https://pps.whatsapp.net/v/t61.24694-24/100386118_735740183837122_2381748117381097333_n.jpg?ccb=11-4&oh=01_AdSH0xKGhZjXneltXh2B2ou2cevqPu1Yqjv4QhAYCcRjwQ&oe=639F9A4F','2022-12-08 21:18:20','2022-12-08 21:18:20','',1),(11,'☯️','51966217697',NULL,'2022-12-08 21:18:20','2022-12-08 21:18:20','',0),(12,'?','51944416846','https://pps.whatsapp.net/v/t61.24694-24/286307951_171151468661592_9085998255253004387_n.jpg?ccb=11-4&oh=01_AdRrLDDW9Y6LDdBWl4nM1X6P2YHtX-rZrfpvlnPVsrDFzA&oe=639F8B87','2022-12-08 21:18:22','2022-12-08 21:18:22','',0),(13,'Linck','51943149732',NULL,'2022-12-08 21:18:23','2022-12-08 21:18:23','',0),(14,'Jose','51943900152','https://pps.whatsapp.net/v/t61.24694-24/138594419_327006738753695_5085807756603366816_n.jpg?ccb=11-4&oh=01_AdRSyjBBfhI_E0Ip-lrzGuuMggjwYf0cO3vBkzMDZDcafg&oe=639F848E','2022-12-08 21:18:26','2022-12-08 21:18:26','',0),(15,'Exitos','51953955562','https://pps.whatsapp.net/v/t61.24694-24/297690288_619107049551642_6120314112325620278_n.jpg?ccb=11-4&oh=01_AdTEFmfbc2d63EkyTj2UkMgpf4rjyaZjxE6_SaycYVIZQg&oe=639F7F31','2022-12-08 21:18:32','2022-12-08 21:18:32','',0),(16,'51997967721','51997967721',NULL,'2022-12-08 21:18:33','2022-12-08 21:18:33','',0),(17,'Dmaq','51973186792','https://pps.whatsapp.net/v/t61.24694-24/309182997_508269014076093_3714882504726833080_n.jpg?ccb=11-4&oh=01_AdTit8nlXTzBIEIcupNlGnjTjiYD7dogHF9GDW7wqstHNg&oe=639F8253','2022-12-08 21:18:35','2022-12-08 21:18:35','',0),(18,'MONICA?','51916913017',NULL,'2022-12-08 21:18:36','2022-12-08 21:18:36','',0),(19,'U Continental Sede Cusco','51932563027-1605816462','https://pps.whatsapp.net/v/t61.24694-24/125891730_690737041579712_5848069087485803193_n.jpg?ccb=11-4&oh=01_AdSa-g12Gra9FyRwSXfBuWZLysMLnG8FBDD3Dny3apv9BA&oe=639FA998','2022-12-08 21:18:38','2022-12-08 21:18:38','',1),(20,'A Beutifull ??','51956715492',NULL,'2022-12-08 21:18:38','2022-12-08 21:18:38','',0),(21,'?☺️?','51952661515','https://pps.whatsapp.net/v/t61.24694-24/267225239_3266675060251782_3781761277237161785_n.jpg?ccb=11-4&oh=01_AdSRtaQ9MPbmY3pS9nqeqcxUpBSZgNQJ4W25GyX7mIgbrg&oe=639F994E','2022-12-08 21:18:39','2022-12-08 21:18:39','',0),(22,'Fredy Huanca','51965671012','https://pps.whatsapp.net/v/t61.24694-24/296399394_5317240854996649_205344870091805190_n.jpg?ccb=11-4&oh=01_AdQgW3Cqs4rDDNBFQVaDU5G1gcBFhs7-4bSp6_EWydV2FQ&oe=639F7600','2022-12-08 21:18:40','2022-12-08 21:18:40','',0),(23,'RECLAMO PENSIÓN 2023','120363030464263355','https://pps.whatsapp.net/v/t61.24694-24/295696127_1726341164418159_3605778220895534349_n.jpg?ccb=11-4&oh=01_AdTBFmFEL5ECKm1MXuHJk8_oF2vsrBJa84aYNu4OvH-nIQ&oe=639F9A40','2022-12-08 21:18:41','2022-12-08 21:18:41','',1),(24,'51994182769','51994182769','https://pps.whatsapp.net/v/t61.24694-24/310927845_529037659045526_5945128797440505719_n.jpg?ccb=11-4&oh=01_AdSbD6RfufBLciyl5b1tjKHM7z_g4JfRW8HSfHiN2GFkPQ&oe=639F94F4','2022-12-08 21:18:41','2022-12-08 21:18:41','',0),(25,'Nuestra familia??','51972362599-1572610730','https://pps.whatsapp.net/v/t61.24694-24/73440080_228509291704168_1759266950321542576_n.jpg?ccb=11-4&oh=01_AdRbTvXc_tn9_L9t7ptn4KUtq_s5KJUP_PC-bXyVXe7-9w&oe=639FA89D','2022-12-08 21:18:42','2022-12-08 21:18:42','',1),(26,'Prima España','34686246753','https://pps.whatsapp.net/v/t61.24694-24/297500196_583290853278150_6964196172941830364_n.jpg?ccb=11-4&oh=01_AdTmetLcbCEAMNaZ5gl61JoyFNKRAytxBms9kArDG6wakA&oe=639FA88B','2022-12-08 21:18:43','2022-12-08 21:18:43','',0),(27,'???????','51985585851','https://pps.whatsapp.net/v/t61.24694-24/310994827_432002819142933_135798761098653861_n.jpg?ccb=11-4&oh=01_AdR1kBdLIuVoTxENSHx9bXkZv0vVCNjyn1_7IaL4rMwl7A&oe=639F7D04','2022-12-08 21:18:44','2022-12-08 21:18:44','',0),(28,'Estadística Aplicada','120363029959529100',NULL,'2022-12-08 21:18:45','2022-12-08 21:18:45','',1),(29,'Noe','51999918579','https://pps.whatsapp.net/v/t61.24694-24/128270855_228251088715419_259050930101316906_n.jpg?ccb=11-4&oh=01_AdSUJBzQB_lHQqOBbGCFHPnft8kZi7qPpKqGMmy9H4LYgg&oe=639F7CC0','2022-12-08 21:18:45','2022-12-08 21:18:45','',0),(30,'Payul','51989567245','https://pps.whatsapp.net/v/t61.24694-24/266728666_137126672018559_6120816446934470078_n.jpg?ccb=11-4&oh=01_AdQqS_Po0R1ydv6jXtQEsOuyAjgQB9io7Vn5Kipch_n26Q&oe=639F7C0F','2022-12-08 21:18:48','2022-12-08 21:18:48','',0),(31,'51948865548','51948865548','https://pps.whatsapp.net/v/t61.24694-24/311700787_207895984962912_778301003111022139_n.jpg?ccb=11-4&oh=01_AdSierwebgUK3rJGQB_qQL9hbu5JuTW7v-7tdK5rqwheIQ&oe=639F97D7','2022-12-08 21:18:52','2022-12-08 21:18:52','',0),(32,'Yarbys','51910475188','https://pps.whatsapp.net/v/t61.24694-24/207789725_325327555999200_6980143576597503017_n.jpg?ccb=11-4&oh=01_AdQGLYjOEc999eCT7hZw983xkAvMNhBKocx33ERGAzNuZg&oe=639F9262','2022-12-08 21:22:08','2022-12-08 21:22:08','',0),(33,'Sistemas','51947681529-1579955194',NULL,'2022-12-08 21:46:51','2022-12-08 21:46:51','',1),(34,'Martin Grupo Valor','51993993557',NULL,'2022-12-08 21:47:25','2022-12-08 21:47:25','',0);

/*Table structure for table `Messages` */

DROP TABLE IF EXISTS `Messages`;

CREATE TABLE `Messages` (
  `id` varchar(255) NOT NULL,
  `body` text NOT NULL,
  `ack` int(11) NOT NULL DEFAULT 0,
  `read` tinyint(1) NOT NULL DEFAULT 0,
  `mediaType` varchar(255) DEFAULT NULL,
  `mediaUrl` varchar(255) DEFAULT NULL,
  `ticketId` int(11) NOT NULL,
  `createdAt` datetime(6) NOT NULL,
  `updatedAt` datetime(6) NOT NULL,
  `fromMe` tinyint(1) NOT NULL DEFAULT 0,
  `isDeleted` tinyint(1) NOT NULL DEFAULT 0,
  `contactId` int(11) DEFAULT NULL,
  `quotedMsgId` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ticketId` (`ticketId`),
  KEY `Messages_contactId_foreign_idx` (`contactId`),
  KEY `Messages_quotedMsgId_foreign_idx` (`quotedMsgId`),
  CONSTRAINT `Messages_contactId_foreign_idx` FOREIGN KEY (`contactId`) REFERENCES `Contacts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Messages_ibfk_2` FOREIGN KEY (`ticketId`) REFERENCES `Tickets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Messages_quotedMsgId_foreign_idx` FOREIGN KEY (`quotedMsgId`) REFERENCES `Messages` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

/*Data for the table `Messages` */

insert  into `Messages`(`id`,`body`,`ack`,`read`,`mediaType`,`mediaUrl`,`ticketId`,`createdAt`,`updatedAt`,`fromMe`,`isDeleted`,`contactId`,`quotedMsgId`) values ('043542BDC964EF15F57AB6B1AB247513','Sobre ejemplos de líneas de comando en Linux y Windows',0,0,'chat',NULL,1,'2022-12-08 21:18:14.351000','2022-12-08 21:18:14.351000',0,0,2,NULL),('05EDCC493E3491C3A38068161FCA5A78','https://docs.google.com/forms/d/e/1FAIpQLSeQwt6jwx0bl8S0lXl4CzmHwtHtty5MXVaKibRrETDi93J4iQ/viewform?usp=sf_link',0,0,'chat',NULL,3,'2022-12-08 21:18:37.566000','2022-12-08 21:18:37.566000',0,0,11,NULL),('0BEE5106AA99156F68B54560F9344892','Esry rn covida',0,0,'chat',NULL,10,'2022-12-08 21:46:51.524000','2022-12-08 21:46:51.524000',0,0,8,NULL),('13F51158C64335A000517647EC613452','Será porque es feriado',0,0,'chat',NULL,1,'2022-12-08 21:18:09.529000','2022-12-08 21:18:09.529000',0,0,4,NULL),('1A28128D030963F7CEDB0DE7FC384C81','https://chat.whatsapp.com/LVr326eEQD59ityLFITYBd',0,0,'chat',NULL,3,'2022-12-08 21:18:25.673000','2022-12-08 21:18:25.673000',0,0,13,NULL),('1CB9E92591BC10C4B643EE3E40E0581F','Csnr',0,0,'chat',NULL,10,'2022-12-08 21:48:03.831000','2022-12-08 21:48:03.831000',0,0,8,NULL),('286172F0A187A5DCD19A283C072C23C6','Cagao',0,0,'chat',NULL,10,'2022-12-08 21:46:54.724000','2022-12-08 21:46:54.724000',0,0,8,NULL),('374296DF907BC5F5B15B5579776D3D15','hh',0,1,'chat',NULL,9,'2022-12-08 21:24:30.782000','2022-12-08 21:26:43.115000',0,0,32,NULL),('3772C6FA6153A70EE97B4B0D469BF192','1670545102048.jpeg',0,0,'image','1670545102048.jpeg',3,'2022-12-08 21:18:22.094000','2022-12-08 21:18:22.094000',0,0,11,NULL),('397A84B5B016FA8A1CABF98F7846809F','*C O M U N I C A D O*\n\n*?Estimados compañeros de la Universidad Continental, para la emisión del documento frente al incremento de la pensión; es necesario tener el respaldo de todos los estudiantes, para ello adjuntaremos al documento lo registrado en la encuesta. Esto nos permitirá reflejar la cantidad de los muchos estudiantes que estamos en desacuerdo con el incremento.*\n\n*?Se hace extensivo el registro del presente formulario con suma diligencia, gracias.?*\n\nhttps://forms.gle/J5ocnFaTxtjGxLr99',0,0,'chat',NULL,3,'2022-12-08 21:18:20.882000','2022-12-08 21:18:20.882000',0,0,11,NULL),('3A58B4DE1E8D89F82028','Precio ?',0,0,'chat',NULL,3,'2022-12-08 21:18:35.706000','2022-12-08 21:18:35.706000',0,0,17,NULL),('3AEBCEA0826B9F9E0FFF','No se olviden mandar sus resultados',0,0,'chat',NULL,2,'2022-12-08 21:18:17.608000','2022-12-08 21:18:17.608000',0,0,7,NULL),('3EB03F1691006E2711E3','*paul:*\nest es un respuesta repida',3,1,'chat',NULL,9,'2022-12-08 21:23:23.002000','2022-12-08 21:24:21.751000',1,0,NULL,NULL),('3EB066F4077FB5AF92CD','*paul:*\nya',3,1,'chat',NULL,9,'2022-12-08 21:23:24.190000','2022-12-08 21:24:21.750000',1,0,NULL,NULL),('3EB08ED356795367AF8D','*paul:*\n??',2,1,'chat',NULL,9,'2022-12-08 21:40:15.159000','2022-12-08 21:40:16.917000',1,0,NULL,NULL),('3EB095EF079AE5FA491B','*¡ULTIMAS VACANTES!*\n?¡Hola! Somos la *EPG Universidad Continental*.\n\nSoy Veronika Robles su asesora encargada en brindarle la información del curso de su interés:\n\n*DESARROLLO WEB PROFESSIONAL*\nInicio 22 de Octubre\n⌚ Lunes, Miércoles y Viernes de 7:30pm a \n   10:30pm\n⏳  12 semanas \n\nInversión regular: S/.775.00\n\nDescuento 20% al contado solo S/.625.00\nEn cuotas: 2 cuotas de S/.375.00\n\n*Inscripciones hasta el 18 de octubre*\n*Vacantes limitadas*\n\nSi se encuentra interesad@ en participar bríndenos su número de *DNI Y CORREO* y realizaremos su inscripción.',0,0,'chat',NULL,8,'2022-12-08 21:18:52.276000','2022-12-08 21:18:52.276000',0,0,31,NULL),('3EB096475E64B2BF36E3','*paul:*\nmi asignaicon',2,1,'chat',NULL,9,'2022-12-08 21:31:09.786000','2022-12-08 21:31:12.698000',1,0,NULL,NULL),('3EB0B5076A679302436A','*paul:*\nwelcome mas',3,1,'chat',NULL,9,'2022-12-08 21:22:56.483000','2022-12-08 21:22:57.340000',1,0,NULL,NULL),('3EB0BF8815BCE09C6BA5','*paul:*\nmas enviado',3,1,'chat',NULL,9,'2022-12-08 21:23:27.929000','2022-12-08 21:24:21.751000',1,0,NULL,NULL),('40B8CD4AABD844887093AF4855941F1B','Gracias paul',0,0,'chat',NULL,7,'2022-12-08 21:18:51.436000','2022-12-08 21:18:51.436000',0,0,29,NULL),('4228FF205659B0DFD958F9E8E04F661D','1670545111946.jpeg',0,0,'image','1670545111946.jpeg',3,'2022-12-08 21:18:31.952000','2022-12-08 21:18:31.952000',0,0,14,NULL),('4628311C301F903AFF2A87880A6BD173','Hola comapñeros ya dio nota de estadística no s eolviden por fa',0,0,'chat',NULL,7,'2022-12-08 21:18:45.364000','2022-12-08 21:18:45.364000',0,0,29,NULL),('527ECAAE8649787C9EC3DDFBEA651A23','Responder el correo con copia a mentoria y bienestar universitario, mostrando nuestra desconfrmidad',0,0,'chat',NULL,3,'2022-12-08 21:18:23.811000','2022-12-08 21:18:23.811000',0,0,13,NULL),('54B124B1F89B817C6D2A2EF2BFD9E7D4','1670545110984.jpeg',0,0,'image','1670545110984.jpeg',3,'2022-12-08 21:18:30.991000','2022-12-08 21:18:30.991000',0,0,14,NULL),('5C14951DED1E68F4963687FCCD95D392','Yo cocinando comida peruana para el abuelo y dice que está buenazo ???',0,0,'image','1670545123349.jpeg',6,'2022-12-08 21:18:43.356000','2022-12-08 21:18:43.356000',0,0,26,NULL),('6040E7E7DAB7407A038D7C67EC842821','Hola',0,1,'chat',NULL,9,'2022-12-08 21:22:08.176000','2022-12-08 21:22:14.165000',0,0,32,NULL),('63910C9A40E374B78D2D7FFC46E18E1F','Cada mes te da mano',0,0,'chat',NULL,10,'2022-12-08 21:47:25.206000','2022-12-08 21:47:25.206000',0,0,34,NULL),('6927CE37BCADEDFAEB5D524E7046B6A9','https://www.facebook.com/NacionalTvPeru/videos/678484580612627/?flite=scwspnss&mibextid=Jl6khPcKTGdu8IwI',0,0,'chat',NULL,4,'2022-12-08 21:18:40.333000','2022-12-08 21:18:40.333000',0,0,22,NULL),('693BEF93630DCA460F6C24F6EDE5C7E8','Sede huancayo',0,0,'chat',NULL,3,'2022-12-08 21:18:36.535000','2022-12-08 21:18:36.535000',0,0,18,'1A28128D030963F7CEDB0DE7FC384C81'),('6D89824EEA7B5132165006C6483CE040','Me esta cobrando 45',0,0,'chat',NULL,7,'2022-12-08 21:18:46.965000','2022-12-08 21:18:46.965000',0,0,29,NULL),('6F427DD062A38999F877A2EEB76650E4','Por el feriado',0,0,'chat',NULL,1,'2022-12-08 21:18:08.750000','2022-12-08 21:18:08.750000',0,0,3,NULL),('724C691D4EF28E69B648747572CA1667','Sisis ya te paso ahora',0,0,'chat',NULL,7,'2022-12-08 21:18:48.761000','2022-12-08 21:18:48.761000',0,0,30,NULL),('743896DFC4E8AE5B0DEB0B2766DBB203','Buen día compañeros me podrían porfavor brindar el número de la administradora del grupo de teoría general del proceso con el profesor witman armando salas',0,0,'chat',NULL,4,'2022-12-08 21:18:39.514000','2022-12-08 21:18:39.514000',0,0,21,NULL),('7616A77226D9D3C83D5663DA853DBB7A','1670545130644.jpeg',0,0,'image','1670545130644.jpeg',7,'2022-12-08 21:18:50.673000','2022-12-08 21:18:50.673000',0,0,30,NULL),('7AC97BB81F23B533F22A0B87FEFA95A7','.',0,0,'chat',NULL,2,'2022-12-08 21:18:18.589000','2022-12-08 21:18:18.589000',0,0,8,NULL),('7BE9300A2A658C51CA93A1C67642A55A','esta a la venta',0,0,'chat',NULL,3,'2022-12-08 21:18:34.608000','2022-12-08 21:18:34.608000',0,0,14,NULL),('7CEB99A778545D6E707865A19CD972F7','El profesor indico que instalemos ubuntu en un a máquina virtual',0,0,'chat',NULL,1,'2022-12-08 21:18:15.137000','2022-12-08 21:18:15.137000',0,0,2,NULL),('89F468F4F3BAB3BBDED34888312899E3','Cuando se recuperara',0,0,'chat',NULL,1,'2022-12-08 21:18:10.361000','2022-12-08 21:18:10.361000',0,0,3,NULL),('8CC73513E413C5ECA2AD26CB96653B51','Lo vendes o lo das en adopción',0,0,'chat',NULL,3,'2022-12-08 21:18:33.630000','2022-12-08 21:18:33.630000',0,0,16,'CCD34A28D6D1F3C623CEDBB9F3B81D80'),('8DC638EEF8463ABD92655B477AD41AAD','1670545124259.webp',0,0,'image','1670545124259.webp',6,'2022-12-08 21:18:44.276000','2022-12-08 21:18:44.276000',0,0,27,NULL),('8F8F8C299E581BC25297DCADA399F756','?',0,0,'chat',NULL,1,'2022-12-08 21:18:11.274000','2022-12-08 21:18:11.274000',0,0,4,NULL),('9020A9CE6090751282F3920B56B6B343','Gracias ?',0,0,'chat',NULL,7,'2022-12-08 21:18:49.767000','2022-12-08 21:18:49.767000',0,0,29,NULL),('941CFC43389F79A676348439AA6D91D2','Crocia 0 vs brasil 2\nHolanda 1 vs argentina 2\nMarruecos 0 portugal 1\nInglaterra 1 francia 1',0,0,'chat',NULL,2,'2022-12-08 21:18:16.538000','2022-12-08 21:18:16.538000',0,0,6,NULL),('A0CBF423096A21BF290C4C666C22F328','Y el exmn final?',0,0,'chat',NULL,1,'2022-12-08 21:18:12.851000','2022-12-08 21:18:12.851000',0,0,3,NULL),('A3B6A0DD7550FED5EB227C9AF9068918','??????',0,0,'chat',NULL,3,'2022-12-08 21:18:22.936000','2022-12-08 21:18:22.936000',0,0,12,NULL),('A87CB4A87A2156886F5250D6687321A5','*C O M U N I C A D O*\n\n*?Estimados compañeros de la Universidad Continental, para la emisión del documento frente al incremento de la pensión; es necesario tener el respaldo de todos los estudiantes, para ello adjuntaremos al documento lo registrado en la encuesta. Esto nos permitirá reflejar la cantidad de los muchos estudiantes que estamos en desacuerdo con el incremento.*\n\n*?Se hace extensivo el registro del presente formulario con suma diligencia, gracias.?*\n\nhttps://forms.gle/J5ocnFaTxtjGxLr99',0,0,'chat',NULL,4,'2022-12-08 21:18:38.637000','2022-12-08 21:18:38.637000',0,0,20,NULL),('ABB91B95D20DD66B7F29761FF4E4C900','1670545122127.jpeg',0,0,'image','1670545122127.jpeg',5,'2022-12-08 21:18:42.140000','2022-12-08 21:18:42.140000',0,0,24,NULL),('B62E70AA3697EE2CEDC0B9BB8D2D00E4','Cada uno 15',0,0,'chat',NULL,7,'2022-12-08 21:18:47.792000','2022-12-08 21:18:47.792000',0,0,29,NULL),('BBF0443044C1C3EEF58D867B39B7BCA0','Será un trabajo',0,0,'chat',NULL,1,'2022-12-08 21:18:13.584000','2022-12-08 21:18:13.584000',0,0,2,'A0CBF423096A21BF290C4C666C22F328'),('BEA1DB2727F7580F0FE8F5DA2C82E42E','Croacia 0 Brasil 2\nHolanda 0 argentina 2\nMarruecos 0 Portugal 2\nInglaterra 1 Francia 2',0,0,'chat',NULL,2,'2022-12-08 21:18:19.618000','2022-12-08 21:18:19.618000',0,0,9,NULL),('BF33AED2F65B7F2EAD','Compañeros, alguien sabe por que hoy  no hubo clases?',0,0,'chat',NULL,1,'2022-12-08 21:18:07.827000','2022-12-08 21:18:07.827000',0,0,2,NULL),('CCD34A28D6D1F3C623CEDBB9F3B81D80','Gente alguien quiere una perrita america bully?',0,0,'image','1670545106635.jpeg',3,'2022-12-08 21:18:26.644000','2022-12-08 21:18:26.644000',0,0,14,NULL),('D24B2AE0934ADDEBA24F5359D37B3922','Me gustaria',0,0,'chat',NULL,3,'2022-12-08 21:18:32.802000','2022-12-08 21:18:32.802000',0,0,15,'4228FF205659B0DFD958F9E8E04F661D'),('D58720EA953BC450F737AD48B8EB5989','No se wuirn m3 hs cpntagiafo',0,0,'chat',NULL,10,'2022-12-08 21:47:00.955000','2022-12-08 21:47:00.955000',0,0,8,NULL),('E17D047D248B981B61B417395AC6FBB8','La prensa transmisiones en vivo radios locales...',0,0,'chat',NULL,3,'2022-12-08 21:18:24.833000','2022-12-08 21:18:24.833000',0,0,13,'3772C6FA6153A70EE97B4B0D469BF192'),('F27B7C6ED21AEA81F7AAFEE130C370EC','No se olviden?',0,0,'chat',NULL,7,'2022-12-08 21:18:46.168000','2022-12-08 21:18:46.168000',0,0,29,NULL),('F600044CB6F488C2D1','supongo que nunca  ?',0,0,'chat',NULL,1,'2022-12-08 21:18:12.067000','2022-12-08 21:18:12.067000',0,0,2,'89F468F4F3BAB3BBDED34888312899E3');

/*Table structure for table `Queues` */

DROP TABLE IF EXISTS `Queues`;

CREATE TABLE `Queues` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `color` varchar(255) NOT NULL,
  `greetingMessage` text DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `color` (`color`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

/*Data for the table `Queues` */

insert  into `Queues`(`id`,`name`,`color`,`greetingMessage`,`createdAt`,`updatedAt`) values (1,'Cola 1','#eb9694','Cola 1 mensaje','2022-12-08 21:12:19','2022-12-08 21:12:19'),(2,'Cola 2','#e27300','Mas','2022-12-08 21:26:38','2022-12-08 21:26:38'),(3,'Recursos Humanos','#fcdc00','Binevenidos a la area de recursos humanos','2022-12-08 21:30:35','2022-12-08 21:30:35');

/*Table structure for table `QuickAnswers` */

DROP TABLE IF EXISTS `QuickAnswers`;

CREATE TABLE `QuickAnswers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `shortcut` text NOT NULL,
  `message` text NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

/*Data for the table `QuickAnswers` */

insert  into `QuickAnswers`(`id`,`shortcut`,`message`,`createdAt`,`updatedAt`) values (1,'hh','Hola hh, esta es una repuesta chistosa','2022-12-08 21:13:35','2022-12-08 21:13:35');

/*Table structure for table `SequelizeMeta` */

DROP TABLE IF EXISTS `SequelizeMeta`;

CREATE TABLE `SequelizeMeta` (
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

/*Data for the table `SequelizeMeta` */

insert  into `SequelizeMeta`(`name`) values ('20200717133438-create-users.js'),('20200717144403-create-contacts.js'),('20200717145643-create-tickets.js'),('20200717151645-create-messages.js'),('20200717170223-create-whatsapps.js'),('20200723200315-create-contacts-custom-fields.js'),('20200723202116-add-email-field-to-contacts.js'),('20200730153237-remove-user-association-from-messages.js'),('20200730153545-add-fromMe-to-messages.js'),('20200813114236-change-ticket-lastMessage-column-type.js'),('20200901235509-add-profile-column-to-users.js'),('20200903215941-create-settings.js'),('20200904220257-add-name-to-whatsapp.js'),('20200906122228-add-name-default-field-to-whatsapp.js'),('20200906155658-add-whatsapp-field-to-tickets.js'),('20200919124112-update-default-column-name-on-whatsappp.js'),('20200927220708-add-isDeleted-column-to-messages.js'),('20200929145451-add-user-tokenVersion-column.js'),('20200930162323-add-isGroup-column-to-tickets.js'),('20200930194808-add-isGroup-column-to-contacts.js'),('20201004150008-add-contactId-column-to-messages.js'),('20201004155719-add-vcardContactId-column-to-messages.js'),('20201004955719-remove-vcardContactId-column-to-messages.js'),('20201026215410-add-retries-to-whatsapps.js'),('20201028124427-add-quoted-msg-to-messages.js'),('20210108001431-add-unreadMessages-to-tickets.js'),('20210108164404-create-queues.js'),('20210108164504-add-queueId-to-tickets.js'),('20210108174594-associate-whatsapp-queue.js'),('20210108204708-associate-users-queue.js'),('20210109192513-add-greetingMessage-to-whatsapp.js'),('20210818102605-create-quickAnswers.js'),('20211016014719-add-farewellMessage-to-whatsapp.js'),('20220223095932-add-whatsapp-to-user.js');

/*Table structure for table `Settings` */

DROP TABLE IF EXISTS `Settings`;

CREATE TABLE `Settings` (
  `key` varchar(255) NOT NULL,
  `value` text NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

/*Data for the table `Settings` */

insert  into `Settings`(`key`,`value`,`createdAt`,`updatedAt`) values ('userApiToken','dcf98227-c06b-4112-a302-be5ad61165b2','2022-12-08 19:43:39','2022-12-08 19:43:39'),('userCreation','enabled','2022-12-08 19:43:39','2022-12-08 19:43:39');

/*Table structure for table `Tickets` */

DROP TABLE IF EXISTS `Tickets`;

CREATE TABLE `Tickets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` varchar(255) NOT NULL DEFAULT 'pending',
  `lastMessage` text DEFAULT NULL,
  `contactId` int(11) DEFAULT NULL,
  `userId` int(11) DEFAULT NULL,
  `createdAt` datetime(6) NOT NULL,
  `updatedAt` datetime(6) NOT NULL,
  `whatsappId` int(11) DEFAULT NULL,
  `isGroup` tinyint(1) NOT NULL DEFAULT 0,
  `unreadMessages` int(11) DEFAULT NULL,
  `queueId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `contactId` (`contactId`),
  KEY `userId` (`userId`),
  KEY `Tickets_whatsappId_foreign_idx` (`whatsappId`),
  KEY `Tickets_queueId_foreign_idx` (`queueId`),
  CONSTRAINT `Tickets_ibfk_1` FOREIGN KEY (`contactId`) REFERENCES `Contacts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Tickets_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `Users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Tickets_queueId_foreign_idx` FOREIGN KEY (`queueId`) REFERENCES `Queues` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Tickets_whatsappId_foreign_idx` FOREIGN KEY (`whatsappId`) REFERENCES `Whatsapps` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

/*Data for the table `Tickets` */

insert  into `Tickets`(`id`,`status`,`lastMessage`,`contactId`,`userId`,`createdAt`,`updatedAt`,`whatsappId`,`isGroup`,`unreadMessages`,`queueId`) values (1,'pending','El profesor indico que instalemos ubuntu en un a máquina virtual',1,NULL,'2022-12-08 21:18:07.000000','2022-12-08 21:18:15.000000',1,1,10,NULL),(2,'pending','Croacia 0 Brasil 2\nHolanda 0 argentina 2\nMarruecos 0 Portugal 2\nInglaterra 1 Francia 2',5,NULL,'2022-12-08 21:18:16.000000','2022-12-08 21:18:19.000000',1,1,4,NULL),(3,'pending','https://docs.google.com/forms/d/e/1FAIpQLSeQwt6jwx0bl8S0lXl4CzmHwtHtty5MXVaKibRrETDi93J4iQ/viewform?usp=sf_link',10,NULL,'2022-12-08 21:18:20.000000','2022-12-08 21:18:37.000000',1,1,15,NULL),(4,'pending','https://www.facebook.com/NacionalTvPeru/videos/678484580612627/?flite=scwspnss&mibextid=Jl6khPcKTGdu8IwI',19,NULL,'2022-12-08 21:18:38.000000','2022-12-08 21:18:40.000000',1,1,3,NULL),(5,'pending','1670545122127.jpeg',23,NULL,'2022-12-08 21:18:41.000000','2022-12-08 21:18:42.000000',1,1,1,NULL),(6,'pending','1670545124259.webp',25,NULL,'2022-12-08 21:18:43.000000','2022-12-08 21:18:44.000000',1,1,3,NULL),(7,'pending','Gracias paul',28,NULL,'2022-12-08 21:18:45.000000','2022-12-08 21:18:51.000000',1,1,8,NULL),(8,'pending','*¡ULTIMAS VACANTES!*\n?¡Hola! Somos la *EPG Universidad Continental*.\n\nSoy Veronika Robles su asesora encargada en brindarle la información del curso de su interés:\n\n*DESARROLLO WEB PROFESSIONAL*\nInicio 22 de Octubre\n⌚ Lunes, Miércoles y Viernes de 7:30pm a \n   10:30pm\n⏳  12 semanas \n\nInversión regular: S/.775.00\n\nDescuento 20% al contado solo S/.625.00\nEn cuotas: 2 cuotas de S/.375.00\n\n*Inscripciones hasta el 18 de octubre*\n*Vacantes limitadas*\n\nSi se encuentra interesad@ en participar bríndenos su número de *DNI Y CORREO* y realizaremos su inscripción.',31,NULL,'2022-12-08 21:18:52.000000','2022-12-08 21:18:52.000000',1,0,1,NULL),(9,'open','*paul:*\n??',32,2,'2022-12-08 21:22:08.000000','2022-12-08 21:40:14.000000',1,0,0,NULL),(10,'pending','Csnr',33,NULL,'2022-12-08 21:46:51.000000','2022-12-08 21:48:03.000000',1,1,4,NULL);

/*Table structure for table `UserQueues` */

DROP TABLE IF EXISTS `UserQueues`;

CREATE TABLE `UserQueues` (
  `userId` int(11) NOT NULL,
  `queueId` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`userId`,`queueId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

/*Data for the table `UserQueues` */

insert  into `UserQueues`(`userId`,`queueId`,`createdAt`,`updatedAt`) values (2,1,'2022-12-08 21:30:53','2022-12-08 21:30:53'),(2,3,'2022-12-08 21:30:53','2022-12-08 21:30:53');

/*Table structure for table `Users` */

DROP TABLE IF EXISTS `Users`;

CREATE TABLE `Users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `passwordHash` varchar(255) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `profile` varchar(255) NOT NULL DEFAULT 'admin',
  `tokenVersion` int(11) NOT NULL DEFAULT 0,
  `whatsappId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `Users_whatsappId_foreign_idx` (`whatsappId`),
  CONSTRAINT `Users_whatsappId_foreign_idx` FOREIGN KEY (`whatsappId`) REFERENCES `Whatsapps` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

/*Data for the table `Users` */

insert  into `Users`(`id`,`name`,`email`,`passwordHash`,`createdAt`,`updatedAt`,`profile`,`tokenVersion`,`whatsappId`) values (1,'Administrador','admin@whaticket.com','$2a$08$WaEmpmFDD/XkDqorkpQ42eUZozOqRCPkPcTkmHHMyuTGUOkI8dHsq','2022-12-08 19:43:39','2022-12-08 19:43:39','admin',0,NULL),(2,'paul','yoel.antezana@gmail.com','$2a$08$2nppQbZ5ohFexjLDqy1DB.1aJH.vwdlL1r8EmPUKHFLyhxSdu.CUK','2022-12-08 21:09:17','2022-12-08 21:30:53','admin',0,1);

/*Table structure for table `WhatsappQueues` */

DROP TABLE IF EXISTS `WhatsappQueues`;

CREATE TABLE `WhatsappQueues` (
  `whatsappId` int(11) NOT NULL,
  `queueId` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`whatsappId`,`queueId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

/*Data for the table `WhatsappQueues` */

insert  into `WhatsappQueues`(`whatsappId`,`queueId`,`createdAt`,`updatedAt`) values (1,1,'2022-12-08 21:33:08','2022-12-08 21:33:08'),(1,2,'2022-12-08 21:33:08','2022-12-08 21:33:08'),(1,3,'2022-12-08 21:33:08','2022-12-08 21:33:08');

/*Table structure for table `Whatsapps` */

DROP TABLE IF EXISTS `Whatsapps`;

CREATE TABLE `Whatsapps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session` text DEFAULT NULL,
  `qrcode` text DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `battery` varchar(255) DEFAULT NULL,
  `plugged` tinyint(1) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `name` varchar(255) NOT NULL,
  `isDefault` tinyint(1) NOT NULL DEFAULT 0,
  `retries` int(11) NOT NULL DEFAULT 0,
  `greetingMessage` text DEFAULT NULL,
  `farewellMessage` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

/*Data for the table `Whatsapps` */

insert  into `Whatsapps`(`id`,`session`,`qrcode`,`status`,`battery`,`plugged`,`createdAt`,`updatedAt`,`name`,`isDefault`,`retries`,`greetingMessage`,`farewellMessage`) values (1,NULL,'','CONNECTED',NULL,NULL,'2022-12-08 21:11:25','2022-12-08 21:17:00','Mi WSP',1,0,'Iniciando en wsp','caca');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


```