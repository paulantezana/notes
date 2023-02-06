
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
CREATE TABLE idiomas(
    idIdioma  INT NOT NULL IDENTITY PRIMARY KEY,
    descripcion  VARCHAR(64) NOT NULL
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
CREATE TABLE usuarioRecuperaciones(
    idUsuarioRecupera INT NOT NULL IDENTITY PRIMARY KEY,
    fechaPeticion datetime NOT NULL,
    fechaVencimiento datetime NOT NULL,
    fechaRecuperacion  datetime DEFAULT NULL,
    recuperado BIT DEFAULT 0,
    habilitado  BIT DEFAULT 1,
    idUsuario INT NOT NULL FOREIGN KEY REFERENCES usuarios(idUsuario)
);

GO
CREATE TABLE usuarioIdiomas(
    idIdioma INT NOT NULL FOREIGN KEY REFERENCES idiomas(idIdioma),
    idUsuario INT NOT NULL FOREIGN KEY REFERENCES usuarios(idUsuario)
);

GO
CREATE TABLE usuarioExperiencias(
    idUsuarioExperiencia INT NOT NULL IDENTITY PRIMARY KEY,
    nombreEmpresa VARCHAR(128) NOT NULL,
    desdeFecha datetime NOT NULL,
    hastaFecha datetime NOT NULL,
    funcionesLogros VARCHAR(500) DEFAULT '',
    idUsuario  INT NOT NULL FOREIGN KEY REFERENCES usuarios(idUsuario),
    idCargo  INT NOT NULL FOREIGN KEY REFERENCES cargos(idCargo)
);

GO
CREATE TABLE usuarioEducaciones(
    idUsuarioEducacion INT NOT NULL IDENTITY PRIMARY KEY,
    centroEducativo VARCHAR(128) NOT NULL,
    idUsuario  INT NOT NULL FOREIGN KEY REFERENCES usuarios(idUsuario),
    idProfecion  INT NOT NULL FOREIGN KEY REFERENCES profeciones(idProfecion),
    idNivelDeEstudio  INT NOT NULL FOREIGN KEY REFERENCES nivelDeEstudios(idNivelDeEstudio),
    desdeFecha datetime NOT NULL,
    hastaFecha datetime NOT NULL
);

GO
CREATE TABLE usuarioHabilidades(
    idHabilidad  INT NOT NULL FOREIGN KEY REFERENCES habilidades(idHabilidad),
    idUsuario  INT NOT NULL FOREIGN KEY REFERENCES usuarios(idUsuario)
);

GO
CREATE TABLE usuarioCompetencias(
    idCompetencia   INT NOT NULL FOREIGN KEY REFERENCES competencias(idCompetencia),
    idUsuario  INT NOT NULL FOREIGN KEY REFERENCES usuarios(idUsuario)
);

GO-- ADMIN
CREATE TABLE usuarioCargos(
    idCargo  INT NOT NULL FOREIGN KEY REFERENCES cargos(idCargo),
    idUsuario  INT NOT NULL FOREIGN KEY REFERENCES usuarios(idUsuario)
);

GO
CREATE TABLE vacantes(
    idVacante INT NOT NULL IDENTITY PRIMARY KEY,
	titulo VARCHAR(128) DEFAULT '',
	descripcion VARCHAR(128) DEFAULT '',

    dispoNibilidadViajar BIT DEFAULT 0,
    cambioRecidencia BIT DEFAULT 0,
    discapacidad BIT DEFAULT 0,
    licenciaDeConducir VARCHAR(32) DEFAULT '',
    pehiculoPropio BIT DEFAULT 0,

    salario DECIMAL NOT NULL,
    experienciaMeses INT NOT NULL,

	idArea INT NOT NULL FOREIGN KEY REFERENCES areas(idArea)
);

GO
CREATE TABLE vacanteHabilidades(
    idHabilidad  INT NOT NULL FOREIGN KEY REFERENCES habilidades(idHabilidad),
    idVacante  INT NOT NULL FOREIGN KEY REFERENCES vacantes(idVacante)
);

GO
CREATE TABLE vacanteCompetencias(
    idCompetencia   INT NOT NULL FOREIGN KEY REFERENCES competencias(idCompetencia),
    idVacante  INT NOT NULL FOREIGN KEY REFERENCES vacantes(idVacante)
);

GO
CREATE TABLE vacanteIdiomas(
    idIdioma INT NOT NULL FOREIGN KEY REFERENCES idiomas(idIdioma),
    idVacante  INT NOT NULL FOREIGN KEY REFERENCES vacantes(idVacante)
);

GO
CREATE TABLE postulaciones(
    idPostulacion  INT NOT NULL IDENTITY PRIMARY KEY,
    idUsuario  INT NOT NULL FOREIGN KEY REFERENCES usuarios(idUsuario),
    idVacante  INT NOT NULL FOREIGN KEY REFERENCES vacantes(idVacante),
    idPostulacionEstado  INT NOT NULL FOREIGN KEY REFERENCES postulacionEstados(idPostulacionEstado),
    postulacionFecha datetime NOT NULL
);

GO
CREATE TABLE postulacionDetalles(
    idPostulacionDetalle INT NOT NULL IDENTITY PRIMARY KEY,
    idPostulacion INT NOT NULL FOREIGN KEY REFERENCES postulaciones(idPostulacion),
    idPostulacionEstado INT NOT NULL FOREIGN KEY REFERENCES postulacionEstados(idPostulacionEstado),
    descripcion VARCHAR(128) DEFAULT '',
    fechaAccion datetime NOT NULL,
    esUltimo BIT DEFAULT 1
);






GO
CREATE TABLE programaciones(
    idProgramacion INT NOT NULL IDENTITY PRIMARY KEY,
    idPostulacion  INT NOT NULL FOREIGN KEY REFERENCES postulaciones(idPostulacion),
    fecha datetime NOT NULL,
    observacion VARCHAR(255) DEFAULT '',
    recordatorio INT NOT NULL
);

GO
CREATE TABLE ayudas(
    idAyuda INT NOT NULL IDENTITY PRIMARY KEY,
    pregunta VARCHAR(128) NOT NULL,
    respuesta TEXT
);

go
CREATE TABLE chatMensages(
    idChatMensage INT NOT NULL IDENTITY PRIMARY KEY,
    asunto VARCHAR(128) DEFAULT '',
    cuerpo VARCHAR(255) NOT NULL,
    idRemitente INT NOT NULL FOREIGN KEY REFERENCES usuarios(idUsuario)
);

GO
CREATE TABLE chatMensageReceptores(
    idChatMensageReceptor INT NOT NULL IDENTITY PRIMARY KEY,
    fueLeido BIT NOT NULL,
    idChatMensage  INT NOT NULL FOREIGN KEY REFERENCES chatMensages(idChatMensage),
    idDestinatario INT NOT NULL FOREIGN KEY REFERENCES usuarios(idUsuario)
);