CREATE TABLE Financiero.SunatElectronicoSireTicket (
    Id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,

    Codigo VARCHAR(12) NULL, -- 01: rvie, rce

    MostrarReporteDescarga BIT NOT NULL,
    PeriodoTributario VARCHAR(12) NOT NULL,
    NumeroTicket VARCHAR(32),
    FechaCargaImportacion DATETIME,
    FechaInicioProceso DATETIME,


    CodigoProceso VARCHAR(2) NOT NULL,
    DescripcionProceso VARCHAR(255) NULL,
    CodigoEstadoProceso VARCHAR(32) NULL,
    DescripcionEstadoProceso VARCHAR(255) NULL,
    NombreArchivoImportacion VARCHAR(255) NULL,

    TicketNumero VARCHAR(32) NOT NULL,
    TicketFechaCargaImportacion DATETIME NOT NULL,
    TicketCodigoEstadoEnvio VARCHAR(2) NOT NULL,
    TicketDescripcionEstadoEnvio VARCHAR(255) NULL,
    TicketNombreArchivoReporte VARCHAR(255) NULL,
    TicketCantidadFilasValidada INT NULL,
    TicketCantidadCPError INT NULL,
    TicketCantidadCPInformados INT NULL,

    IdCompania INT NOT NULL,

    CONSTRAINT FK_SunatElectronicoSireTicket_EntidadCompania FOREIGN KEY (IdCompania) 
        REFERENCES Maestros.EntidadCompania (Id)
);

CREATE TABLE Financiero.SunatElectronicoSireTicketArchivo (
    Id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,

    CodigoTipoAchivoReporte VARCHAR(2) NULL,
    NombreArchivoReporte VARCHAR(255) NULL,
    NombreArchivoContenido VARCHAR(255) NULL,

    IdSunatElectronicoSireTicket INT NOT NULL,

    FOREIGN KEY (IdSunatElectronicoSireTicket)  REFERENCES Financiero.SunatElectronicoSireTicket (id)
);



GO




CREATE PROCEDURE Financiero.usp_GuardarSunatElectronicoSireTicket
    @Codigo VARCHAR(12) = NULL,
    @IdCompania INT,

    @MostrarReporteDescarga BIT,
    @PeriodoTributario VARCHAR(12),
    @NumeroTicket VARCHAR(32) = NULL,
    @FechaCargaImportacion DATETIME = NULL,
    @FechaInicioProceso DATETIME = NULL,
    @CodigoProceso VARCHAR(2),
    @DescripcionProceso VARCHAR(255) = NULL,
    @CodigoEstadoProceso VARCHAR(32) = NULL,
    @DescripcionEstadoProceso VARCHAR(255) = NULL,
    @NombreArchivoImportacion VARCHAR(255) = NULL,
    @TicketNumero VARCHAR(32),
    @TicketFechaCargaImportacion DATETIME,
    @TicketCodigoEstadoEnvio VARCHAR(2),
    @TicketDescripcionEstadoEnvio VARCHAR(255) = NULL,
    @TicketNombreArchivoReporte VARCHAR(255) = NULL,
    @TicketCantidadFilasValidada INT = NULL,
    @TicketCantidadCPError INT = NULL,
    @TicketCantidadCPInformados INT = NULL
AS
BEGIN
    DECLARE @Id INT = 0;

    SELECT @Id = Id FROM Financiero.SunatElectronicoSireTicket WITH (NOLOCK)
    WHERE IdCompania = @IdCompania AND Codigo = @Codigo AND (NumeroTicket = @NumeroTicket OR TicketNumero = @TicketNumero);

    IF @Id > 0
    BEGIN
        UPDATE Financiero.SunatElectronicoSireTicket
        SET 
            MostrarReporteDescarga = @MostrarReporteDescarga,
            PeriodoTributario = @PeriodoTributario,
            NumeroTicket = @NumeroTicket,
            FechaCargaImportacion = @FechaCargaImportacion,
            FechaInicioProceso = @FechaInicioProceso,
            CodigoProceso = @CodigoProceso,
            DescripcionProceso = @DescripcionProceso,
            CodigoEstadoProceso = @CodigoEstadoProceso,
            DescripcionEstadoProceso = @DescripcionEstadoProceso,
            NombreArchivoImportacion = @NombreArchivoImportacion,
            TicketNumero = @TicketNumero,
            TicketFechaCargaImportacion = @TicketFechaCargaImportacion,
            TicketCodigoEstadoEnvio = @TicketCodigoEstadoEnvio,
            TicketDescripcionEstadoEnvio = @TicketDescripcionEstadoEnvio,
            TicketNombreArchivoReporte = @TicketNombreArchivoReporte,
            TicketCantidadFilasValidada = @TicketCantidadFilasValidada,
            TicketCantidadCPError = @TicketCantidadCPError,
            TicketCantidadCPInformados = @TicketCantidadCPInformados
        WHERE Id = @Id;
    END
    ELSE
    BEGIN
        INSERT INTO Financiero.SunatElectronicoSireTicket
        (
            Codigo, IdCompania,
            MostrarReporteDescarga, PeriodoTributario, NumeroTicket, FechaCargaImportacion, FechaInicioProceso,
            CodigoProceso, DescripcionProceso, CodigoEstadoProceso, DescripcionEstadoProceso, NombreArchivoImportacion,
            TicketNumero, TicketFechaCargaImportacion, TicketCodigoEstadoEnvio, TicketDescripcionEstadoEnvio, TicketNombreArchivoReporte,
            TicketCantidadFilasValidada, TicketCantidadCPError, TicketCantidadCPInformados
        )
        VALUES
        (
            @Codigo, @IdCompania,
            @MostrarReporteDescarga, @PeriodoTributario, @NumeroTicket, @FechaCargaImportacion, @FechaInicioProceso,
            @CodigoProceso, @DescripcionProceso, @CodigoEstadoProceso, @DescripcionEstadoProceso, @NombreArchivoImportacion,
            @TicketNumero, @TicketFechaCargaImportacion, @TicketCodigoEstadoEnvio, @TicketDescripcionEstadoEnvio, @TicketNombreArchivoReporte,
            @TicketCantidadFilasValidada, @TicketCantidadCPError, @TicketCantidadCPInformados
        );
        SET @Id = SCOPE_IDENTITY();
    END
    
    SELECT * FROM Financiero.SunatElectronicoSireTicket
    WHERE Id = @Id;
END;

GO

CREATE PROCEDURE Financiero.usp_GuardarSunatElectronicoSireTicketArchivo
    @CodigoTipoAchivoReporte VARCHAR(2) = NULL,
    @NombreArchivoReporte VARCHAR(255) = NULL,
    @NombreArchivoContenido VARCHAR(255) = NULL,

    @IdSunatElectronicoSireTicket INT
AS
BEGIN
    -- Insertar registro
    INSERT INTO Financiero.SunatElectronicoSireTicketArchivo
    (
        CodigoTipoAchivoReporte, NombreArchivoReporte, NombreArchivoContenido,
        IdSunatElectronicoSireTicket
    )
    VALUES
    (
        @CodigoTipoAchivoReporte, @NombreArchivoReporte, @NombreArchivoContenido,
        @IdSunatElectronicoSireTicket
    );

    -- Obtener el Id recién insertado
    DECLARE @Id INT = SCOPE_IDENTITY();

    -- Consultar el registro insertado
    SELECT * FROM Financiero.SunatElectronicoSireTicketArchivo
    WHERE Id = @Id;
END;
