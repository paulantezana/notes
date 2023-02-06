
CREATE TABLE habilidades(
    idHabilidad INT NOT NULL IDENTITY PRIMARY KEY,
    descripcion VARCHAR(64) NOT NULL
);

GO
CREATE TABLE competencias(
    idCompetencia INT NOT NULL IDENTITY PRIMARY KEY,
    descripcion VARCHAR(64) NOT NULL
);

GO
CREATE TABLE nivelDeEstudios(  
    idNivelDeEstudio INT NOT NULL IDENTITY PRIMARY KEY,
    descripcion VARCHAR(64) NOT NULL
);

GO
CREATE TABLE profeciones(
    idProfecion INT NOT NULL IDENTITY PRIMARY KEY,
    descripcion  VARCHAR(64) NOT NULL
);

GO
CREATE TABLE postulacionEstados(
    idPostulacionEstado  INT NOT NULL IDENTITY PRIMARY KEY,
    descripcion VARCHAR(64) NOT NULL,
    color VARCHAR(12) NOT NULL
);

GO
CREATE TABLE empresas(
    idEmpresa INT NOT NULL IDENTITY PRIMARY KEY,
    ruc VARCHAR(12) NOT NULL,
    rasonSocial VARCHAR(128) NOT NULL,
    rasonComercial VARCHAR(128) DEFAULT '',
    direccion VARCHAR(128) DEFAULT '',
    descripcion TEXT,
    urlLogo VARCHAR(128) DEFAULT '',
);

GO
CREATE TABLE paises(
    idPais INT NOT NULL IDENTITY PRIMARY KEY,
    descripcion VARCHAR(64) NOT NULL
);

GO
CREATE TABLE localidades (
    idLocalidad INT NOT NULL IDENTITY PRIMARY KEY,
    descripcion  VARCHAR(64) NOT NULL,
    idPais INT NOT NULL FOREIGN KEY REFERENCES paises(idPais),
    idLocalidadPadre INT DEFAULT NULL
);

GO
CREATE TABLE areas(
    idArea INT NOT NULL IDENTITY PRIMARY KEY,
    descripcion VARCHAR(64) NOT NULL
);

GO
CREATE TABLE cargos(
    idCargo  INT NOT NULL IDENTITY PRIMARY KEY,
    descripcion  VARCHAR(64) NOT NULL,
    idArea INT NOT NULL FOREIGN KEY REFERENCES areas(idArea)
);








GO
CREATE TABLE perfiles(
    idPerfil INT NOT NULL IDENTITY PRIMARY KEY,
    descripcion VARCHAR(64) NOT NULL,
);

GO
CREATE TABLE usuarios(
    idUsuario INT NOT NULL IDENTITY PRIMARY KEY,
    nombreUsuario VARCHAR(32) NOT NULL,
    correo  VARCHAR(64) NOT NULL,
    contraseña  VARCHAR(128) NOT NULL,
    urlCV  VARCHAR(128) DEFAULT '',

    dispoNibilidadViajar BIT DEFAULT 0,
    cambioRecidencia BIT DEFAULT 0,
    discapacidad BIT DEFAULT 0,
    licenciaDeConducir VARCHAR(32) DEFAULT '',
    pehiculoPropio BIT DEFAULT 0,

    idPerfil INT NOT NULL FOREIGN KEY REFERENCES perfiles(idPerfil)
);

GO
CREATE TABLE usuarioRecupera(
    idUsuarioRecupera INT NOT NULL IDENTITY PRIMARY KEY,
    fechaPeticion TIMESTAMP NOT NULL,
    fechaVencimiento TIMESTAMP NOT NULL,
    fechaRecuperacion  TIMESTAMP DEFAULT NULL,
    recuperado BIT DEFAULT 0,
    habilitado  BIT DEFAULT 1
);

GO
CREATE TABLE usuarioIdiomas(
    idIdioma
    idUsuario
);

GO
CREATE TABLE usuarioExperiencia(
    idUsuarioExperiencia INT NOT NULL IDENTITY PRIMARY KEY,
    NombreEmpresa
    desdeFecha
    hastaFecha
    funcionesLogros
    idUsuario
    idCargo
);

GO
CREATE TABLE usuarioEducacion(
    idUsuarioEducacion INT NOT NULL IDENTITY PRIMARY KEY,
    centroEducativo
    idUsuario
    idProfecion
    idNivelDeEstudio
    desdeFecha
    hastaFecha
);

GO
CREATE TABLE usuarioHabilidades(
    idHabilidad
    idUsuario
);

GO
CREATE TABLE usuarioCompetencia(
    idHabilidad
    idUsuario
);

GO-- ADMIN
CREATE TABLE usuarioCargo(
    idCargo
    idUsuario
);

GO
CREATE TABLE vacantes(
    idVacante INT NOT NULL IDENTITY PRIMARY KEY,
	titulo
	descripcion

    dispoNibilidadViajar
    cambioRecidencia
    discapacidad
    licenciaDeConducir
    pehiculoPropio

    salario
    experienciaMeses

    idIdiomaRequerido
	idArea
);

GO
CREATE TABLE vacanteHabilidades(
	idVacante
    idHabilidad
);

GO
CREATE TABLE vacanteCompetencias(
	idVacante
    idCompetencia
);

GO
CREATE TABLE vacanteIdiomas(
    idIdioma
    idVacante
);

GO
CREATE TABLE postulaciones(
    idPostulacion  INT NOT NULL IDENTITY PRIMARY KEY,
    idUsuario
    idVacante
    idPostulacionEstado
    postulacionFecha
);

GO
CREATE TABLE postulacionDetalle(
    idPostulacionDetalle INT NOT NULL IDENTITY PRIMARY KEY,
    idPostulacion
    idPostulacionEstado
    descripcion
    fechaAccion
    esUltimo
);

GO
CREATE TABLE programaciones(
    idProgramacion INT NOT NULL IDENTITY PRIMARY KEY,
    idPostulacion
    fecha
    observacion
    recordatorio
);

GO
CREATE TABLE ayudas(
    idAyuda INT NOT NULL IDENTITY PRIMARY KEY,
    pregunta
    respuesta
);

go
CREATE TABLE chatMensages(
    idChatMensage INT NOT NULL IDENTITY PRIMARY KEY,
    asunto
    cuerpo
    idRemitente
);

GO
CREATE TABLE chatMensageReceptores(
    idChatMensageReceptor INT NOT NULL IDENTITY PRIMARY KEY,
    fueLeido
    idChatMensage
    idDestinatario
);