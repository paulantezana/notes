habilidades
    idHabilidad
    descripcion
    tipo : 'H' havilidad, 'C' Competencia
nivelDeEstudios
    idNivelDeEstudio
    descripcion
profeciones
    idProfecion
    descripcion




postulacionEstados
    idPostulacionEstado
    descripcion



empresas
    idEmpresa
    ruc
    rasonSocial
    rasonComercial
    direccion
    descripcion
    urlLogo




pais
    idPais
    descripcion
localidad
    idLocalidad
    descripcion
    idLocalidadPadre




area
    idAreas
    descripcion
cargo
    idCargo
    descripcion
    idArea





perfil
    idPerfil
    descripcion
usuario
    idUsuario
    nombreUsuario
    correo
    contraseña
    urlCV

    dispoNibilidadViajar
    cambioRecidencia
    discapacidad
    licenciaDeConducir
    pehiculoPropio

    idPerfil
usuarioRecupera
    idUsuarioRecupera
    fechaPeticion
    fechaVencimiento
    fechaRecuperacion
    recuperado
    habilitado
usuarioIdiomas
    idIdioma
    idUsuario
usuarioExperiencia
    idUsuarioExperiencia
    NombreEmpresa
    desdeFecha
    hastaFecha
    funcionesLogros
    idUsuario
    idCargo
usuarioEducacion
    idUsuarioEducacion
    centroEducativo
    idUsuario
    idProfecion
    idNivelDeEstudio
    desdeFecha
    hastaFecha
usuarioHabilidades
    idUsuarioHabilidad
    idHabilidad
    idUsuario

-- ADMIN
usuarioCargo
    idCargo
    idUsuario



vacantes
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
vacanteHabilidades
	idUsuarioHabilidad
	idVacante
    idHabilidad

vacanteIdiomas
    idIdioma
    idVacante




postulaciones
    idPostulacion
    idUsuario
    idVacante
    idPostulacionEstado
    postulacionFecha

postulacionDetalle
    idPostulacion
    idPostulacionEstado
    descripcion
    fechaAccion
    esUltimo


programaciones
    idPostulacion
    fecha
    observacion
    recordatorio

ayuda
    idAyuda
    pregunta
    respuesta


chatMensage
    asunto
    cuerpo
    idRemitente


chatMensageReceptor
    fueLeido
    idChatMensage
    idDestinatario