
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


























-- CREATE TABLE habilidades(
--     idHabilidad INT PRIMARY KEY AUTO_INCREMENT,
--     descripcion VARCHAR(64) NOT NULL
-- );

-- CREATE TABLE competencias(
--     idCompetencia INT PRIMARY KEY AUTO_INCREMENT,
--     descripcion VARCHAR(64) NOT NULL
-- );

-- CREATE TABLE nivelDeEstudios(  
--     idNivelDeEstudio INT PRIMARY KEY AUTO_INCREMENT,
--     descripcion VARCHAR(64) NOT NULL
-- );

-- CREATE TABLE profeciones(
--     idProfecion INT PRIMARY KEY AUTO_INCREMENT,
--     descripcion  VARCHAR(64) NOT NULL
-- );

-- CREATE TABLE postulacionEstados(
--     idPostulacionEstado  INT PRIMARY KEY AUTO_INCREMENT,
--     descripcion VARCHAR(64) NOT NULL,
--     color VARCHAR(12) NOT NULL
-- );

-- CREATE TABLE empresas(
--     idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
--     ruc VARCHAR(12) NOT NULL,
--     rasonSocial VARCHAR(128) NOT NULL,
--     rasonComercial VARCHAR(128) DEFAULT '',
--     direccion VARCHAR(128) DEFAULT '',
--     descripcion TEXT,
--     urlLo VARCHAR(128) DEFAULT '',
-- );

-- CREATE TABLE paises(
--     idPais INT PRIMARY KEY AUTO_INCREMENT,
--     descripcion VARCHAR(64) NOT NULL
-- );

-- CREATE TABLE localidades (
--     idLocalidad INT PRIMARY KEY AUTO_INCREMENT,
--     descripcion  VARCHAR(64) NOT NULL,
--     idPais INT NOT NULL,
--     idLocalidadPadre INT DEFAULT NULL,
--     FOREIGN KEY (idPais) REFERENCES paises(idPais)
-- );

-- CREATE TABLE areas(
--     idArea INT PRIMARY KEY AUTO_INCREMENT,
--     descripcion VARCHAR(64) NOT NULL
-- );


-- CREATE TABLE cargos(
--     idCargo  INT PRIMARY KEY AUTO_INCREMENT,
--     descripcion  VARCHAR(64) NOT NULL,
--     idArea INT NOT NULL,
--     FOREIGN KEY (idArea) REFERENCES areas(idArea)
-- );


-- CREATE TABLE idiomas(
--     idIdioma  INT PRIMARY KEY AUTO_INCREMENT,
--     descripcion  VARCHAR(64) NOT NULL
-- );

-- CREATE TABLE perfiles(
--     idPerfil INT PRIMARY KEY AUTO_INCREMENT,
--     descripcion VARCHAR(64) NOT NULL
-- );


-- CREATE TABLE usuarios(
--     idUsuario INT PRIMARY KEY AUTO_INCREMENT,
--     nombreUsuario VARCHAR(32) NOT NULL,
--     correo  VARCHAR(64) NOT NULL,
--     contraseña  VARCHAR(128) NOT NULL,
--     urlCV  VARCHAR(128) DEFAULT '',

--     dispoNibilidadViajar BIT DEFAULT 0,
--     cambioRecidencia BIT DEFAULT 0,
--     discapacidad BIT DEFAULT 0,
--     licenciaDeConducir VARCHAR(32) DEFAULT '',
--     pehiculoPropio BIT DEFAULT 0,

--     idPerfil INT NOT NULL,
--     FOREIGN KEY (idPerfil) REFERENCES perfiles(idPerfil)
-- );


-- CREATE TABLE usuarioRecuperaciones(
--     idUsuarioRecupera INT PRIMARY KEY AUTO_INCREMENT,
--     fechaPeticion datetime NOT NULL,
--     fechaVencimiento datetime NOT NULL,
--     fechaRecuperacion  datetime DEFAULT NULL,
--     recuperado BIT DEFAULT 0,
--     habilitado  BIT DEFAULT 1,
--     idUsuario INT NOT NULL,
--     FOREIGN KEY (idUsuario) REFERENCES usuarios(idUsuario)
-- );


-- CREATE TABLE usuarioIdiomas(
--     idIdioma INT NOT NULL,
--     idUsuario INT NOT NULL,
--     FOREIGN KEY (idIdioma) REFERENCES idiomas(idIdioma),
--     FOREIGN KEY (idUsuario) REFERENCES usuarios(idUsuario)
-- );


-- CREATE TABLE usuarioExperiencias(
--     idUsuarioExperiencia INT PRIMARY KEY AUTO_INCREMENT,
--     nombreEmpresa VARCHAR(128) NOT NULL,
--     desdeFecha datetime NOT NULL,
--     hastaFecha datetime NOT NULL,
--     funcionesLogros VARCHAR(500) DEFAULT '',
--     idUsuario  INT NOT NULL,
--     idCargo  INT NOT NULL,
--     FOREIGN KEY (idUsuario) REFERENCES usuarios(idUsuario),
--     FOREIGN KEY (idCargo) REFERENCES cargos(idCargo)
-- );


-- CREATE TABLE usuarioEducaciones(
--     idUsuarioEducacion INT PRIMARY KEY AUTO_INCREMENT,
--     centroEducativo VARCHAR(128) NOT NULL,
--     idUsuario  INT NOT NULL,
--     idProfecion  INT NOT NULL,
--     idNivelDeEstudio  INT NOT NULL,
--     desdeFecha datetime NOT NULL,
--     hastaFecha datetime NOT NULL,
--     FOREIGN KEY (idUsuario) REFERENCES usuarios(idUsuario),
--     FOREIGN KEY (idProfecion) REFERENCES profeciones(idProfecion),
--     FOREIGN KEY (idNivelDeEstudio) REFERENCES nivelDeEstudios(idNivelDeEstudio)
-- );


-- CREATE TABLE usuarioHabilidades(
--     idHabilidad  INT NOT NULL,
--     idUsuario  INT NOT NULL,
--     FOREIGN KEY (idHabilidad) REFERENCES habilidades(idHabilidad),
--     FOREIGN KEY (idUsuario) REFERENCES usuarios(idUsuario)
-- );


-- CREATE TABLE usuarioCompetencias(
--     idCompetencia   INT NOT NULL,
--     idUsuario  INT NOT NULL,
--     FOREIGN KEY (idCompetencia) REFERENCES competencias(idCompetencia),
--     FOREIGN KEY (idUsuario) REFERENCES usuarios(idUsuario)
-- );

-- -- ADMIN
-- CREATE TABLE usuarioCargos(
--     idCargo  INT NOT NULL,
--     idUsuario  INT NOT NULL,
--      FOREIGN KEY (idCargo) REFERENCES cargos(idCargo),
--       FOREIGN KEY (idUsuario) REFERENCES usuarios(idUsuario)
-- );


-- CREATE TABLE vacantes(
--     idVacante INT PRIMARY KEY AUTO_INCREMENT,
-- 	titulo VARCHAR(128) DEFAULT '',
-- 	descripcion VARCHAR(128) DEFAULT '',

--     dispoNibilidadViajar BIT DEFAULT 0,
--     cambioRecidencia BIT DEFAULT 0,
--     discapacidad BIT DEFAULT 0,
--     licenciaDeConducir VARCHAR(32) DEFAULT '',
--     pehiculoPropio BIT DEFAULT 0,

--     salario DECIMAL NOT NULL,
--     experienciaMeses INT NOT NULL,

-- 	idArea INT NOT NULL,
--     FOREIGN KEY (idArea) REFERENCES areas(idArea)
-- );


-- CREATE TABLE vacanteHabilidades(
--     idHabilidad  INT NOT NULL,
--     idVacante  INT NOT NULL,
--     FOREIGN KEY (idHabilidad) REFERENCES habilidades(idHabilidad),
--     FOREIGN KEY (idVacante) REFERENCES vacantes(idVacante)
-- );


-- CREATE TABLE vacanteCompetencias(
--     idCompetencia   INT NOT NULL,
--     idVacante  INT NOT NULL,
--     FOREIGN KEY (idCompetencia) REFERENCES competencias(idCompetencia),
--     FOREIGN KEY (idVacante) REFERENCES vacantes(idVacante)
-- );


-- CREATE TABLE vacanteIdiomas(
--     idIdioma INT NOT NULL,
--     idVacante  INT NOT NULL,
--      FOREIGN KEY (idIdioma) REFERENCES idiomas(idIdioma),
--      FOREIGN KEY (idVacante) REFERENCES vacantes(idVacante)
-- );


-- CREATE TABLE postulaciones(
--     idPostulacion  INT PRIMARY KEY AUTO_INCREMENT,
--     idUsuario  INT NOT NULL,
--     idVacante  INT NOT NULL,
--     idPostulacionEstado  INT NOT NULL,
--     postulacionFecha datetime NOT NULL,
--     FOREIGN KEY (idUsuario) REFERENCES usuarios(idUsuario),
--     FOREIGN KEY (idVacante) REFERENCES vacantes(idVacante),
--     FOREIGN KEY (idPostulacionEstado) REFERENCES postulacionEstados(idPostulacionEstado)
-- );


-- CREATE TABLE postulacionDetalles(
--     idPostulacionDetalle INT PRIMARY KEY AUTO_INCREMENT,
--     idPostulacion INT NOT NULL,
--     idPostulacionEstado INT NOT NULL,
--     descripcion VARCHAR(128) DEFAULT '',
--     fechaAccion datetime NOT NULL,
--     esUltimo BIT DEFAULT 1,
--     FOREIGN KEY (idPostulacion) REFERENCES postulaciones(idPostulacion),
--     FOREIGN KEY (idPostulacionEstado) REFERENCES postulacionEstados(idPostulacionEstado)
-- );







-- CREATE TABLE programaciones(
--     idProgramacion INT PRIMARY KEY AUTO_INCREMENT,
--     idPostulacion  INT NOT NULL,
--     fecha datetime NOT NULL,
--     observacion VARCHAR(255) DEFAULT '',
--     recordatorio INT NOT NULL,
--     FOREIGN KEY (idPostulacion) REFERENCES postulaciones(idPostulacion)
-- );


-- CREATE TABLE ayudas(
--     idAyuda INT PRIMARY KEY AUTO_INCREMENT,
--     pregunta VARCHAR(128) NOT NULL,
--     respuesta TEXT
-- );


-- CREATE TABLE chatMensages(
--     idChatMensage INT PRIMARY KEY AUTO_INCREMENT,
--     asunto VARCHAR(128) DEFAULT '',
--     cuerpo VARCHAR(255) NOT NULL,
--     idRemitente INT NOT NULL,
--     FOREIGN KEY (idRemitente) REFERENCES usuarios(idUsuario)
-- );


-- CREATE TABLE chatMensageReceptores(
--     idChatMensageReceptor INT PRIMARY KEY AUTO_INCREMENT,
--     fueLeido BIT NOT NULL,
--     idChatMensage  INT NOT NULL,
--     idDestinatario INT NOT NULL,
--     FOREIGN KEY (idChatMensage) REFERENCES chatMensages(idChatMensage),
--     FOREIGN KEY (idDestinatario) REFERENCES usuarios(idUsuario)
-- );