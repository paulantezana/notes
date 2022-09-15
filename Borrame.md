
CREATE TABLE Configuracion.DiccionarioPantallaTabla(
	Id int IDENTITY(1,1) NOT NULL,
	Pantalla varchar(100) NULL,
	Tabla varchar(100) NULL,
	Principal bit NULL,
	SPPreProcess varchar(50) NULL,
	SPPostProcess varchar(50) NULL,
	Vista varchar(100) NULL,
	RDLDocumento varchar(128) NULL,
	RDLAsiento varchar(128) NULL,
	IdTablaPadre int NULL,
	IdJsonPadre int NULL
)

CREATE TABLE Configuracion.DiccionarioPantallaCampo(
	Id int IDENTITY(1,1) NOT NULL,
	Pantalla varchar(100) NULL,
	Campo varchar(100) NULL,
	SP varchar(100) NULL,
	Descripciones varchar(256) NULL,
	TipoComponente varchar(100) NULL,
	SPToValidate varchar(100) NULL,
	Formulario varchar(100) NULL,
	CodigoPantalla varchar(10) NULL
)

CREATE TABLE Configuracion.DiccionarioPantallaCampoPropuesta(
	Id int IDENTITY(1,1) NOT NULL,
	Pantalla varchar(100) NULL,
	Campo varchar(100) NULL,
	SP varchar(100) NULL,
	Variante varchar(100) NULL,
	Formulario varchar(100) NULL,
	SPToValidate varchar(100) NULL
)

CREATE TABLE Configuracion.DiccionarioTabla(
	EsquemaVista varchar(100) NULL,
	Vista varchar(100) NULL,
	Id int NOT NULL,
	Pantalla varchar(100) NULL,
	EsquemaTabla varchar(100) NULL,
	Tabla varchar(100) NULL,
	AplicativoCreacion varchar(30) NULL,
	OpcionCreacion varchar(30) NULL,
	FechaCreacion datetime NULL,
	UsuarioCreacion varchar(30) NULL,
	AplicativoEdicion varchar(30) NULL,
	OpcionEdicion varchar(30) NULL,
	FechaEdicion datetime NULL,
	UsuarioEdicion varchar(30) NULL,
	IdNota int NULL,
	TStamp timestamp NOT NULL,
	IdComboGeneral varchar(100) NULL,
	ValorComboGeneral varchar(100) NULL,
	DescriptionComboGeneral varchar(100) NULL,
	DatoDescriptionExtraComboGeneral varchar(250) NULL,
	CampoEstado varchar(30) NULL
)

CREATE TABLE Configuracion.DiccionarioCampo(
	Campo varchar(100) NULL,
	Obligatorio varchar(1) NULL,
	Auditable varchar(1) NULL,
	Orden int NULL,
	Visible varchar(1) NULL,
	Id int NOT NULL,
	IdTabla int NOT NULL,
	Descripcion varchar(100) NULL,
	Titulo varchar(100) NULL,
	URL varchar(100) NULL,
	Tipo varchar(30) NULL,
	Longitud int NULL,
	AplicativoCreacion varchar(30) NULL,
	OpcionCreacion varchar(30) NULL,
	FechaCreacion datetime NULL,
	UsuarioCreacion varchar(30) NULL,
	AplicativoEdicion varchar(30) NULL,
	OpcionEdicion varchar(30) NULL,
	FechaEdicion datetime NULL,
	UsuarioEdicion varchar(30) NULL,
	IdNota int NULL,
	TStamp timestamp NOT NULL,
	Auditoria varchar(100) NULL,
	VerifyDiccionarioPantallaCampo varchar(1) NULL,
	ValorDefault varchar(50) NULL,
	editable bit NULL,
	width int NULL,
	sortable bit NULL,
	filterable bit NULL,
	type varchar(30) NULL
)






SET @row_number = 0;
SELECT
    cli.IdReserva,cli.IdCliente,cli.IdHabitacion,
    mc.IdTipoDocumento,mc.NroDocumento,mc.Nombres,mc.APaterno,mc.AMaterno,DATE_FORMAT(mc.FechaNac,'%d/%m/%Y') AS FechaNac,
    mc.Sexo,mc.Direccion,mc.IdNacionalidad,mc.IdCiudad,mc.Telefono,mc.Email,mc.Ruc,mc.RazonSocial,
    fn_RecuperarNombre('TA_TIPODOCUMENTO',mc.IdTipoDocumento) AS TipoDoc,fn_RecuperarNombre('TA_NACIONALIDAD',mc.IdNacionalidad) AS Nacio,
    fn_RecuperarNombre('TA_CIUDAD',mc.IdCiudad) AS Ciudad,
    (@row_number:=@row_number + 1) AS row_num
FROM (
	SELECT DISTINCT IdReserva, IdHabitacion, IdCliente
	FROM ta_reserva_habitacion_cliente WHERE IdReserva='7614' AND IdHabitacion='1'
) AS cli
INNER JOIN ta_mantenimiento_cliente AS mc ON cli.IdCliente = mc.IdCliente
