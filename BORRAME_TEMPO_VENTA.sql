ALTER PROCEDURE [Financiero].[usp_generaRectificatoriaPLEVenta]  
    @IdSunatElectronicoPeriodo INT  
    , @PeriodoInicio VARCHAR(6)  
    , @Usuario VARCHAR(30) 
    , @SistemaOrigen VARCHAR(30)
AS    
BEGIN    
  --DECLARE @IdSunatElectronicoPeriodo INT = 109312;   
  --DECLARE @PeriodoInicio VARCHAR(6) = '202311';   
  --DECLARE @Usuario VARCHAR(6) = 'Admin';   
  --DECLARE @SistemaOrigen VARCHAR(30) = 'CONCAR';   

  DECLARE @NumeroProceso INT;   
   
  -- //   
  DECLARE @IdCompania INT;   
  DECLARE @CodigoLE VARCHAR(8);   
  DECLARE @PeriodoInicioLocal VARCHAR(6);   
  DECLARE @PeriodoFin VARCHAR(6);   
  DECLARE @AnioInicio INT;   
  DECLARE @AnioFin INT;   
   
  -- //   
  DECLARE @BaseApli           VARCHAR(100) = DB_NAME();   
  DECLARE @Servidor           VARCHAR(100) = '192.168.33.206';   
  DECLARE @RutaCarpeta        VARCHAR(600);   
  DECLARE @RutaArchivo        VARCHAR(200);   
  DECLARE @InicioEjecucion DATETIME = GETDATE();   
   
   
  --   
  DECLARE @Codigo VARCHAR(8) = '';   
  DECLARE @CodigoAnioPeriodo VARCHAR(8) = '';   
  DECLARE @Sql NVARCHAR(MAX) = '';
  DECLARE @Message varchar(max) = '';   
  DECLARE @Reporte TABLE (Orden VARCHAR(32), Resultado INT, [Message] VARCHAR(255), CompaniaPeriodo VARCHAR(12) DEFAULT '');   
  DECLARE @CodigosLE TABLE (Codigo NVARCHAR(50))   
  --   
  DECLARE @CantidadRegistros INT;   
  DECLARE @RucEmpresa VARCHAR(11);   
  DECLARE @RazonSocialEmpresa VARCHAR(200);   
  DECLARE @FechaInicioSire VARCHAR(8);   
  DECLARE @CodigoEnproyecdb  VARCHAR(8);   
   
  -- //   
  SET @PeriodoInicioLocal = @PeriodoInicio;   
  SET @AnioInicio = LEFT(@PeriodoInicioLocal,4);   
   

  -- ========================================================================================================   
  -- OBTENER C12_Numero PROCESO   
  SELECT @NumeroProceso = ISNULL(MAX(NumeroProceso), 0) + 1 FROM Financiero.SunatElectronicoPeriodoVersion  
    WHERE IdSunatElectronicoPeriodo = @IdSunatElectronicoPeriodo   
    AND IdTipoProcesoSunatElectronico   
    IN (SELECT TOP 1 Id FROM Configuracion.TipoProcesoSunatElectronico WHERE Codigo = 'PCS')   
   
  -- //   
  SELECT   
    @IdCompania = IdCompania   
    , @CodigoLE = Codigo   
    , @PeriodoFin = CodigoAnioPeriodo   
    , @AnioFin = LEFT(CodigoAnioPeriodo,4)   
  FROM Financiero.ViewSunatElectronicoPeriodo WHERE Id = @idSunatElectronicoPeriodo;   
   
  -- //   
  SELECT   
    @RazonSocialEmpresa = e.NombreRazonSocial   
    , @RucEmpresa = ec.IdEntidad   
    , @FechaInicioSire = CONVERT(varchar(8), ec.FechaInicioSire, 112)   
    , @CodigoEnproyecdb = Enproyecdb   
  FROM Maestros.EntidadCompania AS ec (nolock)   
  INNER JOIN Maestros.Entidad AS e (nolock) ON ec.IdEntidad = e.IdEntidad   
  WHERE ec.Id = @IdCompania;  
  
  -- //    
  IF @CodigoLE IN ('140100', '14040004')
  BEGIN    
        IF EXISTS(SELECT * FROM sys.all_objects where name = 'PLE_140100_rectifica_reporte') drop table Financiero.PLE_140100_rectifica_reporte;    
        IF EXISTS(SELECT * FROM sys.all_objects where name = 'PLE_140100_txt_extraido') drop table Financiero.PLE_140100_txt_extraido;    
   
    
        IF EXISTS(SELECT * FROM sys.all_objects where name = 'PLE_140100_txt_declarado') drop table Financiero.PLE_140100_txt_declarado;    
            
        IF EXISTS(SELECT * FROM sys.all_objects where name = 'SIRE_14040004') drop table Financiero.SIRE_14040004;    
    
        CREATE TABLE Financiero.PLE_140100_txt_extraido(    
            PeriodoLE VARCHAR(MAX),    
            Cuo VARCHAR(MAX),    
            Correlativo VARCHAR(MAX),    
            FechaEmision VARCHAR(MAX),    
            FechaVen VARCHAR(MAX),    
            TipoDoc VARCHAR(MAX),    
            Serie VARCHAR(MAX),    
            Numero VARCHAR(MAX),    
            NumeroFinal VARCHAR(MAX),    
            TipoDocIdentidad VARCHAR(MAX),    
            NroDocIdentidad VARCHAR(MAX),    
            NombresRazonSocial VARCHAR(MAX),    
            Exportacion decimal(20,2),    
            BIGravada decimal(20,2),    
            DsctoBI decimal(20,2),    
            IGV decimal(20,2),    
            DsctoIGV decimal(20,2),    
            Exonerado decimal(20,2),    
            Inafecto decimal(20,2),    
            ISC decimal(20,2),    
            BIGravIVAP decimal(20,2),    
            IVAP decimal(20,2),    
            ICBPER decimal(20,2),    
            OtrosTributos decimal(20,2),    
            Total decimal(20,2),    
            Moneda VARCHAR(MAX),    
            TipoCambio VARCHAR(MAX),    
            FechaEmisionMod VARCHAR(MAX),    
            TipoDocMod VARCHAR(MAX),    
            SerieMod VARCHAR(MAX),    
            NumeroMod VARCHAR(MAX),    
            IDProyecto VARCHAR(MAX),    
            Error1 VARCHAR(MAX),    
            MedioPago VARCHAR(MAX),    
            Estado VARCHAR(MAX),    
    
            Compania VARCHAR(MAX)    
        );    
        CREATE TABLE Financiero.PLE_14040004_txt_extraido(    
            PeriodoLE VARCHAR(MAX),    
            Cuo VARCHAR(MAX),    
            Correlativo VARCHAR(MAX),    
            FechaEmision VARCHAR(MAX),    
            FechaVen VARCHAR(MAX),    
            TipoDoc VARCHAR(MAX),    
            Serie VARCHAR(MAX),    
            Numero VARCHAR(MAX),    
            NumeroFinal VARCHAR(MAX),    
            TipoDocIdentidad VARCHAR(MAX),    
            NroDocIdentidad VARCHAR(MAX),    
            NombresRazonSocial VARCHAR(MAX),    
            Exportacion decimal(20,2),    
            BIGravada decimal(20,2),    
            DsctoBI decimal(20,2),    
            IGV decimal(20,2),    
            DsctoIGV decimal(20,2),    
            Exonerado decimal(20,2),    
            Inafecto decimal(20,2),    
            ISC decimal(20,2),    
            BIGravIVAP decimal(20,2),    
            IVAP decimal(20,2),    
            ICBPER decimal(20,2),    
            OtrosTributos decimal(20,2),    
            Total decimal(20,2),    
            Moneda VARCHAR(MAX),    
            TipoCambio VARCHAR(MAX),    
            FechaEmisionMod VARCHAR(MAX),    
            TipoDocMod VARCHAR(MAX),    
            SerieMod VARCHAR(MAX),    
            NumeroMod VARCHAR(MAX),    
            IDProyecto VARCHAR(MAX),    
            Error1 VARCHAR(MAX),    
            MedioPago VARCHAR(MAX),    
            Estado VARCHAR(MAX),    
    
            Compania VARCHAR(MAX)    
        );    
    
        INSERT INTO @CodigosLE (Codigo) VALUES ('140100'), ('14040004');    
    END    
    
    IF @CodigoLE = '14040002'    
    BEGIN    
        IF EXISTS(SELECT * FROM sys.all_objects where name = 'SIRE_14040002_rectifica_reporte') drop table Financiero.SIRE_14040002_rectifica_reporte;    
        IF EXISTS(SELECT * FROM sys.all_objects where name = 'PLE_14040002_txt_extraido') drop table Financiero.PLE_14040002_txt_extraido;    
        IF EXISTS(SELECT * FROM sys.all_objects where name = 'PLE_14040003_txt_extraido') drop table Financiero.PLE_14040003_txt_extraido;    
    
        IF EXISTS(SELECT * FROM sys.all_objects where name = 'SIRE_14040003') drop table Financiero.SIRE_14040003;    
    
        CREATE TABLE Financiero.PLE_14040002_txt_extraido(    
            Ruc VARCHAR(MAX),    
            IdRasonSocial VARCHAR(MAX),    
            PeriodoLE VARCHAR(MAX),    
            CarSunat VARCHAR(MAX),    
            FechaEmision VARCHAR(MAX),    
            FechaVen VARCHAR(MAX),    
            TipoDoc VARCHAR(MAX),    
            Serie VARCHAR(MAX),    
            Numero VARCHAR(MAX),    
            NumeroFinal VARCHAR(MAX),    
            TipoDocIdentidad VARCHAR(MAX),    
            NroDocIdentidad VARCHAR(MAX),    
            NombresRazonSocial VARCHAR(MAX),    
            Exportacion decimal(20,2),    
            BIGravada decimal(20,2),    
            DsctoBI decimal(20,2),    
            IGV decimal(20,2),    
            DsctoIGV decimal(20,2),    
            Exonerado decimal(20,2),    
            Inafecto decimal(20,2),    
            ISC decimal(20,2),    
            BIGravIVAP decimal(20,2),    
            IVAP decimal(20,2),    
            ICBPER decimal(20,2),    
            OtrosTributos decimal(20,2),    
            Total decimal(20,2),    
            Moneda VARCHAR(MAX),    
            TipoCambio VARCHAR(MAX),    
            FechaEmisionMod VARCHAR(MAX),    
            TipoDocMod VARCHAR(MAX),    
            SerieMod VARCHAR(MAX),    
            NumeroMod VARCHAR(MAX),    
            IDProyecto VARCHAR(MAX),    
    
            Compania VARCHAR(MAX)    
        );    
        CREATE TABLE Financiero.PLE_14040003_txt_extraido(    
            Ruc VARCHAR(MAX),    
            IdRasonSocial VARCHAR(MAX),    
            PeriodoLE VARCHAR(MAX),    
            CarSunat VARCHAR(MAX),    
            FechaEmision VARCHAR(MAX),    
            FechaVen VARCHAR(MAX),    
            TipoDoc VARCHAR(MAX),    
            Serie VARCHAR(MAX),    
            Numero VARCHAR(MAX),    
            NumeroFinal VARCHAR(MAX),    
            TipoDocIdentidad VARCHAR(MAX),    
            NroDocIdentidad VARCHAR(MAX),    
            NombresRazonSocial VARCHAR(MAX),    
            Exportacion decimal(20,2),    
            BIGravada decimal(20,2),    
            DsctoBI decimal(20,2),    
            IGV decimal(20,2),    
            DsctoIGV decimal(20,2),    
            Exonerado decimal(20,2),    
            Inafecto decimal(20,2),    
            ISC decimal(20,2),    
            BIGravIVAP decimal(20,2),    
            IVAP decimal(20,2),    
            ICBPER decimal(20,2),    
            OtrosTributos decimal(20,2),    
            Total decimal(20,2),    
            Moneda VARCHAR(MAX),    
            TipoCambio VARCHAR(MAX),    
            FechaEmisionMod VARCHAR(MAX),    
            TipoDocMod VARCHAR(MAX),    
            SerieMod VARCHAR(MAX),    
            NumeroMod VARCHAR(MAX),    
            IDProyecto VARCHAR(MAX),    
    
            Compania VARCHAR(MAX)    
        );    
    
        INSERT INTO @CodigosLE (Codigo) VALUES ('14040002'), ('14040003');    
    END    
  
    SELECT    
        CodigoSunatElectronico = CodigoSunatElectronico    
        , CodigoAnioPeriodo = vap.CodigoAnioPeriodo    
        , Ubicacion = ISNULL(sv.UbicacionArchivo, '')    
        , Archivo = ISNULL(sv.Archivo, '')    
        INTO #SunatElectronicoRangoPeriodo    
    FROM Financiero.ViewSunatElectronicoPeriodo AS vap (nolock)    
    LEFT JOIN (    
        SELECT    
            Fila = ROW_NUMBER() OVER (PARTITION BY IdSunatElectronicoPeriodo ORDER BY NumeroProceso DESC)    
            , UbicacionArchivo = '/BACKOFFICE-DOCUMENTOS-WEB/' + UbicacionArchivo    
            , NumeroProceso, Archivo, IdSunatElectronicoPeriodo    
        FROM Financiero.ViewSunatElectronicoPeriodoVersion    
        WHERE CodigoTipoProcesoSunatElectronico = 'DCL' AND SistemaOrigen = 'CONCAR'     
    ) as sv ON    
        sv.IdSunatElectronicoPeriodo = vap.Id AND Fila = 1    
    WHERE vap.IdCompania = @IdCompania    
        AND vap.CodigoAnioPeriodo >= @PeriodoInicioLocal    
        AND vap.CodigoAnioPeriodo < @PeriodoFin    
        AND RIGHT(vap.CodigoAnioPeriodo,2) NOT IN ('00','13')    
        AND vap.CodigoSunatElectronico IN (SELECT Codigo FROM @CodigosLE)  
    ORDER BY vap.CodigoAnioPeriodo   
  
    -- CURSORES    
    DECLARE SunatElectronicoPeriodoVersion_Cursor CURSOR FOR    
    SELECT Codigo = CodigoSunatElectronico, CodigoAnioPeriodo, Ubicacion, Archivo FROM #SunatElectronicoRangoPeriodo  
    
    -- OPEN CURSOR    
    OPEN SunatElectronicoPeriodoVersion_Cursor     
    FETCH NEXT FROM SunatElectronicoPeriodoVersion_Cursor into @Codigo, @CodigoAnioPeriodo, @Ubicacion, @Archivo    
    WHILE @@fetch_status = 0    
    BEGIN    
        -- ========================================================================================================    
        -- C A R G A R        D A T A    
        IF (@CodigoLE = '140100' AND @CodigoAnioPeriodo < LEFT(@FechaInicioSire,6))    
            OR (@CodigoLE = '14040002' AND @CodigoAnioPeriodo >= LEFT(@FechaInicioSire,6))    
        BEGIN    
            EXEC [Financiero].[usp_cargarDataPleSire] @IdCompania, @CodigoLE, @CodigoAnioPeriodo;    
        END    
    
        -- ==============================================================================    
        -- V A L I D A C I O N       S I       E X I S T E      A R C H I V O    
        SET @RutaCarpeta = SUBSTRING(@Ubicacion, CHARINDEX(@Servidor, @Ubicacion) + LEN(@Servidor), LEN(@Ubicacion))    
        SET @RutaCarpeta = REPLACE(@RutaCarpeta, '/','\')    
        SET @RutaCarpeta = IIF(LEFT(@RutaCarpeta, 1) = '\', SUBSTRING(@RutaCarpeta, 2, LEN(@RutaCarpeta)), @RutaCarpeta);    
        SET @RutaCarpeta = IIF(RIGHT(@RutaCarpeta, 1) = '\', LEFT(@RutaCarpeta, LEN(@RutaCarpeta) - 1), @RutaCarpeta);    
        SET @RutaArchivo = '\\' + rtrim(@Servidor) + '\' + @RutaCarpeta + '\' + @archivo;    
    
    
        SELECT @Sql = 'declare @existe int = 0;'    
        SELECT @Sql = @Sql + 'exec master.dbo.xp_fileexist ''' + @RutaArchivo + ''', @existe OUT;'    
        SELECT @Sql = @sql + 'select @existe'    
        DELETE FROM @Result    
        INSERT INTO @Result exec(@Sql);    
    
    
        IF LEN(@Archivo) >= 39    
            SET @CorrelativoArchivo = LEFT(RIGHT(@Archivo,6),2);    
        ELSE    
            SET @CorrelativoArchivo = '00'    
    
        -- ==============================================================================    
        -- E X T R A E R     I N F R O M A C I O N    
        SELECT TOP 1 @Existe = existe FROM @Result;    
        IF @Existe = 1    
        BEGIN    
            SET @Sql = 'BULK INSERT Financiero.PLE_' + @Codigo + '_txt_extraido FROM ''' + @rutaArchivo + '''    
                    WITH (    
                        CODEPAGE = ''65001''    
                        , DATAFILETYPE = ''char''    
                        , FIELDTERMINATOR = ''|''    
                        , ROWTERMINATOR = ''0x0a''    
                        , FIRSTROW = 1    
                    );    
    
                    UPDATE Financiero.PLE_' + @Codigo + '_txt_extraido SET Compania = ''' + CONVERT(varchar, @IdCompania) + @CodigoAnioPeriodo + @CorrelativoArchivo + ''' WHERE LEN(ISNULL(Compania,'''')) < 2    
                    ';    
            --print(@Sql);    
            EXEC (@Sql);    
    
            INSERT INTO @Reporte (Orden, Resultado, [Message])    
            SELECT 1 + @CodigoAnioPeriodo, 1, 'LE...' + @Codigo + '...' + IIF(LEN(@Archivo) >= 39, LEFT(RIGHT(@Archivo,6),2),'') + '.TXT - ' + @CodigoAnioPeriodo + '|' + ' TXT extraido';    
        END    
        ELSE    
        BEGIN    
            INSERT INTO @Reporte (Orden, Resultado, [Message])    
            SELECT 1 + @CodigoAnioPeriodo, 0, 'LE...' + @Codigo + '...' + IIF(LEN(@Archivo) >= 39, LEFT(RIGHT(@Archivo,6),2),'') + '.TXT - ' + @CodigoAnioPeriodo + '|' + ' No existe TXT ' + @Archivo + char(13);    
        END    
    
        FETCH NEXT FROM SunatElectronicoPeriodoVersion_Cursor into @Codigo, @CodigoAnioPeriodo, @Ubicacion, @Archivo;    
    END    
    
    CLOSE SunatElectronicoPeriodoVersion_Cursor;    
    DEALLOCATE SunatElectronicoPeriodoVersion_Cursor;    
    
    DROP TABLE #SunatElectronicoRangoPeriodo;    
  
    ---- =======================================================================================================    
    ---- REGISTRAR ULTIMO PROCESO    
    --UPDATE  Financiero.PleAdjunto SET FechaUltimoProceso = GETDATE()    
    --WHERE IdCompania = @IdCompania    
    --    AND Tipo = 'declarado'    
    --    AND Codigo IN (SELECT Codigo FROM @CodigosLE)    
    --    AND Periodo >= @PeriodoInicioLocal    
    --    AND Periodo < @PeriodoFinLocal    
    ---- --    
    ---- =======================================================================================================    
    
    IF @CodigoLE = '140100'    
    BEGIN    
        -- =======================================================================================================    
        -- TODA LAS TRANSACCIONES     
        -- =======================================================================================================    
        SELECT    
            * INTO Financiero.PLE_140100_txt_declarado    
        FROM Financiero.PLE_140100_txt_extraido    
        UNION ALL    
        SELECT * FROM Financiero.PLE_14040004_txt_extraido;    
    
        -- =======================================================================================================    
        -- ULTIMA MODIFICACION    
        -- =======================================================================================================    
        SELECT * INTO #temp140100_txt_Estado9     
        FROM (    
            SELECT *    
                , Fila = ROW_NUMBER()  OVER (    
                                                PARTITION BY SUBSTRING(Compania, 1, 2), Cuo    
                                                ORDER BY SUBSTRING(Compania, 1, 2), Cuo, SUBSTRING(Compania, 3, 6), SUBSTRING(Compania, 9, 2) DESC    
                                            )     
            FROM    
                Financiero.PLE_140100_txt_declarado     
            WHERE    
                Estado = '9'    
        ) t    
        WHERE Fila = 1    
            
        -- =======================================================================================================    
        -- COMBINAR REGISTROS MODIFICADOS    
        -- =======================================================================================================    
        SELECT    
            PeriodoLE                 = IIF(t9.Compania IS NULL, t1.PeriodoLE           , t9.PeriodoLE)    
            , Cuo                     = IIF(t9.Compania IS NULL, t1.Cuo                 , t9.Cuo)    
            , Correlativo             = IIF(t9.Compania IS NULL, t1.Correlativo         , t9.Correlativo)    
            , FechaEmision            = IIF(t9.Compania IS NULL, t1.FechaEmision        , t9.FechaEmision)    
            , FechaVen                = IIF(t9.Compania IS NULL, t1.FechaVen            , t9.FechaVen)    
            , TipoDoc                 = IIF(t9.Compania IS NULL, t1.TipoDoc             , t9.TipoDoc)    
            , Serie                   = IIF(t9.Compania IS NULL, t1.Serie               , t9.Serie)    
            , Numero                  = IIF(t9.Compania IS NULL, t1.Numero              , t9.Numero)    
            , NumeroFinal             = IIF(t9.Compania IS NULL, t1.NumeroFinal         , t9.NumeroFinal)    
            , TipoDocIdentidad        = IIF(t9.Compania IS NULL, t1.TipoDocIdentidad    , t9.TipoDocIdentidad)    
            , NroDocIdentidad         = IIF(t9.Compania IS NULL, t1.NroDocIdentidad     , t9.NroDocIdentidad)    
            , NombresRazonSocial      = IIF(t9.Compania IS NULL, t1.NombresRazonSocial  , t9.NombresRazonSocial)    
            , Exportacion             = IIF(t9.Compania IS NULL, t1.Exportacion         , t9.Exportacion)    
            , BIGravada               = IIF(t9.Compania IS NULL, t1.BIGravada           , t9.BIGravada)    
            , DsctoBI                 = IIF(t9.Compania IS NULL, t1.DsctoBI             , t9.DsctoBI)    
            , IGV                     = IIF(t9.Compania IS NULL, t1.IGV                 , t9.IGV)    
            , DsctoIGV                = IIF(t9.Compania IS NULL, t1.DsctoIGV            , t9.DsctoIGV)    
            , Exonerado               = IIF(t9.Compania IS NULL, t1.Exonerado           , t9.Exonerado)    
            , Inafecto                = IIF(t9.Compania IS NULL, t1.Inafecto            , t9.Inafecto)    
            , ISC                     = IIF(t9.Compania IS NULL, t1.ISC                 , t9.ISC)    
            , BIGravIVAP              = IIF(t9.Compania IS NULL, t1.BIGravIVAP          , t9.BIGravIVAP)    
            , IVAP                    = IIF(t9.Compania IS NULL, t1.IVAP                , t9.IVAP)    
            , ICBPER        = IIF(t9.Compania IS NULL, t1.ICBPER              , t9.ICBPER)    
            , OtrosTributos           = IIF(t9.Compania IS NULL, t1.OtrosTributos       , t9.OtrosTributos)    
            , Total                   = IIF(t9.Compania IS NULL, t1.Total               , t9.Total)    
            , Moneda                  = IIF(t9.Compania IS NULL, t1.Moneda              , t9.Moneda)    
            , TipoCambio              = IIF(t9.Compania IS NULL, t1.TipoCambio          , t9.TipoCambio)    
            , FechaEmisionMod         = IIF(t9.Compania IS NULL, t1.FechaEmisionMod     , t9.FechaEmisionMod)    
            , TipoDocMod              = IIF(t9.Compania IS NULL, t1.TipoDocMod          , t9.TipoDocMod)    
            , SerieMod                = IIF(t9.Compania IS NULL, t1.SerieMod            , t9.SerieMod)    
            , NumeroMod               = IIF(t9.Compania IS NULL, t1.NumeroMod           , t9.NumeroMod)    
            , IDProyecto              = IIF(t9.Compania IS NULL, t1.IDProyecto          , t9.IDProyecto)    
            , Error1                  = IIF(t9.Compania IS NULL, t1.Error1              , t9.Error1)    
            , MedioPago               = IIF(t9.Compania IS NULL, t1.MedioPago           , t9.MedioPago)    
            , Estado                  = IIF(t9.Compania IS NULL, t1.Estado              , t9.Estado)    
    
            , IdCompania              = SUBSTRING(t1.Compania, 1, 2)    
            , CodigoAnioPeriodo       = SUBSTRING(t1.Compania, 3, 6)    
    
            INTO #ple140100_txt    
        FROM Financiero.PLE_140100_txt_declarado as t1    
            LEFT JOIN #temp140100_txt_Estado9 as t9 ON SUBSTRING(t9.Compania, 1, 2) = SUBSTRING(t1.Compania, 1, 2)    
                AND t9.PeriodoLE = t1.PeriodoLE    
                AND t9.Cuo = t1.Cuo    
                AND t9.Correlativo = t1.Correlativo    
                AND t9.Estado = '9'    
        WHERE     
            t1.Estado IN ('0','1','2','8')    
                
        -- =======================================================================================================    
        -- TRANSFORMAR  ORIGEN PARA COMPARAR    
        -- =======================================================================================================    
        SELECT    
            * INTO #ple140100_origen    
        FROM Financiero.PLE_140100    
        WHERE IdCompania = @IdCompania    
            AND CodigoAnioPeriodo >= @PeriodoInicioLocal    
            AND CodigoAnioPeriodo < @PeriodoFin    
                
        -- =======================================================================================================    
        -- TRANSFORMAR  TXT PARA COMPARAR    
        -- =======================================================================================================    
    
    
        -- =======================================================================================================    
        -- REALIZAR COMPARATIVA ORIGEN VS TXT    
        -- =======================================================================================================    
        SELECT    
            pl3.*    
            , Valido = IIF(    
                C_Exportacion != 0    
                OR C_BIGravada != 0    
                OR C_DsctoBI != 0    
                OR C_IGV != 0    
                OR C_DsctoIGV != 0    
                OR C_Exonerado != 0    
                OR C_Inafecto != 0    
                OR C_ISC != 0    
                OR C_BIGravIVAP != 0    
                OR C_IVAP != 0    
                OR C_ICBPER != 0    
                OR C_OtrosTributos != 0    
                OR C_Total != 0    
                OR C_TipoCambio != 0    
                OR C_FechaEmisionMod = 'S'    
                OR C_TipoDocMod = 'S'    
                OR C_SerieMod = 'S'    
                OR C_NumeroMod = 'S'    
                ,'N','S'    
            )    
            INTO Financiero.PLE_140100_rectifica_reporte    
        FROM (    
SELECT    
                A_Cuo                   = a.Cuo    
                , A_Correlativo         = a.Correlativo    
                , A_FechaEmision        = a.FechaEmision    
                , A_FechaPago           = a.FechaVen    
                , A_TipoDoc             = a.TipoDoc    
                , A_Serie               = a.Serie    
                , A_Numero              = a.Numero    
                , A_NumeroFinal         = a.NumeroFinal    
                , A_TipoDocIdentidad    = a.TipoDocIdentidad    
                , A_NroDocIdentidad     = a.NroDocIdentidad    
                , A_NombresRazonSocial  = a.NombresRazonSocial    
                , A_Exportacion         = a.Exportacion    
                , A_BIGravada           = a.BIGravada    
                , A_DsctoBI             = a.DsctoBI    
                , A_DIGV                = a.IGV    
                , A_DsctoIGV            = a.DsctoIGV    
                , A_Exonerado           = a.Exonerado    
                , A_Inafecto            = a.Inafecto    
                , A_ISC                 = a.ISC    
                , A_BIGravIVAP          = a.BIGravIVAP    
                , A_IVAP                = a.IVAP    
                , A_ICBPER              = a.ICBPER    
                , A_OtrosTributos       = a.OtrosTributos    
                , A_Total               = a.Total    
                , A_Moneda              = a.Moneda    
                , A_TipoCambio          = a.TipoCambio    
                , A_FechaEmisionMod     = a.FechaEmisionMod    
                , A_TipoDocMod          = a.TipoDocMod    
                , A_SerieMod            = a.SerieMod    
                , A_NumeroMod           = a.NumeroMod    
                , A_Contrato            = a.IDProyecto    
                , A_Error1              = a.Error1    
                , A_MedioPago           = a.MedioPago    
                , A_Estado              = a.Estado    
    
                , B_Cuo                 = b.Cuo    
                , B_Correlativo         = b.Correlativo    
                , B_FechaEmision        = b.FechaEmision    
                , B_FechaPago           = b.FechaPago    
                , B_TipoDoc             = b.TipoDoc    
                , B_Serie               = b.Serie    
                , B_Numero              = b.Numero    
                , B_NumeroFinal         = b.NumeroFinal    
                , B_TipoDocIdentidad    = b.TipoDocIdentidad    
                , B_NroDocIdentidad     = b.NroDocIdentidad    
                , B_NombresRazonSocial  = b.NombresRazonSocial    
                , B_Exportacion         = b.Exportacion    
                , B_BIGravada           = b.BIGravada    
                , B_DsctoBI             = b.DsctoBI    
                , B_DIGV                = b.DIGV    
                , B_DsctoIGV            = b.DsctoIGV    
                , B_Exonerado           = b.Exonerado    
                , B_Inafecto            = b.Inafecto    
                , B_ISC                = b.ISC    
                , B_BIGravIVAP          = b.BIGravIVAP    
                , B_IVAP                = b.IVAP    
                , B_ICBPER              = b.ICBPER    
                , B_OtrosTributos       = b.OtrosTributos    
                , B_Total               = b.Total    
                , B_Moneda              = b.Moneda    
                , B_TipoCambio          = b.TipoCambio    
                , B_FechaEmisionMod     = b.FechaEmisionMod    
                , B_TipoDocMod          = b.TipoDocMod    
                , B_SerieMod            = b.SerieMod    
                , B_NumeroMod           = b.NumeroMod    
                , B_Contrato            = b.Contrato    
                , B_Error1              = b.Error1    
                , B_MedioPago           = b.MedioPago    
                , B_Estado              = b.Estado    
    
                , C_Exportacion         = ISNULL(a.Exportacion, 0)     - ISNULL(b.Exportacion, 0)    
                , C_BIGravada           = ISNULL(a.BIGravada, 0)       - ISNULL(b.BIGravada, 0)    
                , C_DsctoBI             = ISNULL(a.DsctoBI, 0)         - ISNULL(b.DsctoBI, 0)    
                , C_IGV                 = ISNULL(a.IGV, 0)             - ISNULL(b.DIGV, 0)    
                , C_DsctoIGV            = ISNULL(a.DsctoIGV, 0)        - ISNULL(b.DsctoIGV, 0)    
                , C_Exonerado           = ISNULL(a.Exonerado, 0)       - ISNULL(b.Exonerado, 0)    
                , C_Inafecto            = ISNULL(a.INAFECTO, 0)        - ISNULL(b.Inafecto, 0)    
                , C_ISC                 = ISNULL(a.ISC, 0)             - ISNULL(b.ISC, 0)    
                , C_BIGravIVAP          = ISNULL(a.BIGravIVAP, 0)      - ISNULL(b.BIGravIVAP, 0)    
                , C_IVAP                = ISNULL(a.IVAP, 0)            - ISNULL(b.IVAP, 0)    
                , C_ICBPER              = ISNULL(a.ICBPER, 0)          - ISNULL(b.ICBPER, 0)    
                , C_OtrosTributos       = ISNULL(a.OtrosTributos, 0)   - ISNULL(b.OtrosTributos, 0)    
                , C_Total               = ISNULL(a.Total, 0)           - ISNULL(b.Total, 0)    
                , C_TipoCambio          = ISNULL(a.TipoCambio, 0)      - ISNULL(b.TipoCambio, 0)    
                , C_FechaEmisionMod     = IIF(a.FechaEmisionMod != b.FechaEmisionMod, 'S', 'N')    
                , C_TipoDocMod          = IIF(a.TipoDocMod != b.TipoDocMod, 'S', 'N')    
                , C_SerieMod            = IIF(a.SerieMod != b.SerieMod, 'S', 'N')    
                , C_NumeroMod           = IIF(a.NumeroMod != b.NumeroMod, 'S', 'N')    
    
                , IdCompania            = ISNULL(a.IdCompania, b.IdCompania)    
                , PeriodoLE             = ISNULL(a.PeriodoLE, b.PeriodoLE)    
                , ExisteEnTxt           = IIF(a.IdCompania IS NOT NULL, 'S', 'N')    
                , ExisteEnOrigen        = IIF(b.IdCompania IS NOT NULL, 'S', 'N')    
    
            FROM #ple140100_txt  as a    
            FULL JOIN #ple140100_origen as b ON b.IdCompania = a.IdCompania    
                AND b.PeriodoLE = a.PeriodoLE    
                AND b.Cuo = a.Cuo    
                AND b.Correlativo = a.Correlativo    
        ) as pl3    
    
        -- =======================================================================================================    
        -- GUARDAR PARA TXT DE RECTIFICATORIA    
        -- =======================================================================================================    
     
    
        -- --------------------------------------------------------------    
        -- ESTADO 9 Que Modifica    
        SELECT    
            IdCompania    
            , Reporte               = 'Rectificatoria desde ' + @PeriodoInicioLocal + ' hasta ' + @PeriodoFin    
            , Periodo               = LEFT(PeriodoLE,6)    
            , PeriodoLE             = PeriodoLE    
            , Cuo                   = B_Cuo                     
            , Correlativo           = B_Correlativo             
            , FechaEmision          = B_FechaEmision            
            , FechaPago             = ISNULL(B_FechaPago,'')               
            , TipoDoc               = B_TipoDoc    
            , Serie                 = B_Serie    
            , Numero                = B_Numero    
            , NumeroFinal           = ISNULL(B_NumeroFinal,'')    
            , TipoDocIdentidad      = B_TipoDocIdentidad        
            , NroDocIdentidad       = B_NroDocIdentidad         
            , NombresRazonSocial    = B_NombresRazonSocial      
            , Exportacion           = B_Exportacion             
            , BIGravada             = B_BIGravada               
            , DsctoBI               = B_DsctoBI                 
            , DIGV                  = B_DIGV                    
            , DsctoIGV              = B_DsctoIGV                
            , Exonerado             = B_Exonerado               
            , Inafecto              = B_Inafecto                
            , ISC                   = B_ISC                     
            , BIGravIVAP            = B_BIGravIVAP              
            , IVAP                  = B_IVAP                    
            , ICBPER                = B_ICBPER                  
            , OtrosTributos         = B_OtrosTributos           
            , Total                 = B_Total    
            , Moneda                = B_Moneda    
            , TipoCambio            = B_TipoCambio    
            , FechaEmisionMod       = B_FechaEmisionMod    
            , TipoDocMod            = B_TipoDocMod    
            , SerieMod              = B_SerieMod    
            , NumeroMod             = B_NumeroMod    
            , Contrato              = ISNULL(B_Contrato,'')                
            , Error1                = ISNULL(B_Error1,'')    
            , MedioPago             = ISNULL(B_MedioPago,'')    
            , Estado                = '9'    
            , ExisteEnOrigen    
            , ExisteEnTxt    
            , Valido    
            , Motivo                = 'Cambio en: ' + TRIM('/ ' FROM CONCAT(    
                                        IIF(C_Exportacion != 0, ' / Exportacion', '')    
                                        , IIF(C_BIGravada != 0, ' / BIGravada', '')    
                                        , IIF(C_DsctoBI != 0, ' / DsctoBI', '')    
                                        , IIF(C_IGV != 0, ' / IGV', '')    
                                        , IIF(C_DsctoIGV != 0, ' / DsctoIGV', '')    
                                        , IIF(C_Exonerado != 0, ' / Exonerado', '')    
                                        , IIF(C_Inafecto != 0, ' / Inafecto', '')    
                                        , IIF(C_ISC != 0, ' / ISC', '')    
                                        , IIF(C_BIGravIVAP != 0, ' / BIGravIVAP', '')    
                                        , IIF(C_IVAP != 0, ' / IVAP', '')    
                                        , IIF(C_ICBPER != 0, ' / ICBPER', '')    
                                        , IIF(C_OtrosTributos != 0, ' / OtrosTributos', '')    
                                        , IIF(C_Total != 0, ' / Total', '')    
                                        , IIF(C_TipoCambio != 0, ' / Tipo cambio', '')    
                                        , IIF(C_FechaEmisionMod = 'S', ' / Fecha de emisión modifica','')    
                                        , IIF(C_TipoDocMod = 'S', ' / Tipo documento modifica','')    
                                        , IIF(C_SerieMod = 'S', ' / Serie modifica','')    
                                        , IIF(C_NumeroMod = 'S', ' / Numero modifica','')    
                                    ))    
            , De                    = TRIM('/ ' FROM CONCAT(    
                                        IIF(C_Exportacion != 0, ' / ' + CONVERT(varchar, A_Exportacion), '')    
                                        , IIF(C_BIGravada != 0, ' / ' + CONVERT(varchar, A_BIGravada), '')    
                                        , IIF(C_DsctoBI != 0, ' / ' + CONVERT(varchar, A_DsctoBI), '')    
                                        , IIF(C_IGV != 0, ' / ' + CONVERT(varchar, A_DIGV), '')    
                                        , IIF(C_DsctoIGV != 0, ' / ' + CONVERT(varchar, A_DsctoIGV), '')    
                                        , IIF(C_Exonerado != 0, ' / ' + CONVERT(varchar, A_Exonerado), '')    
                                        , IIF(C_Inafecto != 0, ' / ' + CONVERT(varchar, A_Inafecto), '')    
                                        , IIF(C_ISC != 0, ' / ' + CONVERT(varchar, A_ISC), '')    
                                        , IIF(C_BIGravIVAP != 0, ' / ' + CONVERT(varchar, A_BIGravIVAP), '')    
                                        , IIF(C_IVAP != 0, ' / ' + CONVERT(varchar, A_IVAP), '')    
                                        , IIF(C_ICBPER != 0, ' / ' + CONVERT(varchar, A_ICBPER), '')    
    , IIF(C_OtrosTributos != 0, ' / ' + CONVERT(varchar, A_OtrosTributos), '')    
                                        , IIF(C_Total != 0, ' / ' + CONVERT(varchar, A_Total), '')    
                                        , IIF(C_TipoCambio != 0, ' / ' + CONVERT(varchar, A_TipoCambio), '')    
                                        , IIF(C_FechaEmisionMod = 'S', ' / ' + A_FechaEmisionMod,'')    
                                        , IIF(C_TipoDocMod = 'S', ' / ' + A_TipoDocMod,'')    
                                        , IIF(C_SerieMod = 'S', ' / ' + A_SerieMod,'')    
                                        , IIF(C_NumeroMod = 'S', ' / ' + A_NumeroMod,'')    
                                    ))    
            , Por                    = TRIM('/ ' FROM CONCAT(    
                                        IIF(C_Exportacion != 0, ' / ' + CONVERT(varchar, B_Exportacion), '')    
                                        , IIF(C_BIGravada != 0, ' / ' + CONVERT(varchar, B_BIGravada), '')    
                                        , IIF(C_DsctoBI != 0, ' / ' + CONVERT(varchar, B_DsctoBI), '')    
                                        , IIF(C_IGV != 0, ' / ' + CONVERT(varchar, B_DIGV), '')    
                                        , IIF(C_DsctoIGV != 0, ' / ' + CONVERT(varchar, B_DsctoIGV), '')    
                                        , IIF(C_Exonerado != 0, ' / ' + CONVERT(varchar, B_Exonerado), '')    
                                        , IIF(C_Inafecto != 0, ' / ' + CONVERT(varchar, B_Inafecto), '')    
                                        , IIF(C_ISC != 0, ' / ' + CONVERT(varchar, B_ISC), '')    
                                        , IIF(C_BIGravIVAP != 0, ' / ' + CONVERT(varchar, B_BIGravIVAP), '')    
                                        , IIF(C_IVAP != 0, ' / ' + CONVERT(varchar, B_IVAP), '')    
                                        , IIF(C_ICBPER != 0, ' / ' + CONVERT(varchar, B_ICBPER), '')    
                                        , IIF(C_OtrosTributos != 0, ' / ' + CONVERT(varchar, B_OtrosTributos), '')    
                                        , IIF(C_Total != 0, ' / ' + CONVERT(varchar, B_Total), '')    
                                        , IIF(C_TipoCambio != 0, ' / ' + CONVERT(varchar, B_TipoCambio), '')    
                                        , IIF(C_FechaEmisionMod = 'S', ' / ' + B_FechaEmisionMod,'')    
                                        , IIF(C_TipoDocMod = 'S', ' / ' + B_TipoDocMod,'')    
                                        , IIF(C_SerieMod = 'S', ' / ' + B_SerieMod,'')    
                                        , IIF(C_NumeroMod = 'S', ' / ' + B_NumeroMod,'')    
                                    ))    
            --, Observacion    
            , TXT                   = space(500)    
    
            INTO Financiero.SIRE_14040004    
    
        FROM Financiero.PLE_140100_rectifica_reporte    
        WHERE ExisteEnOrigen = 'S'    
            AND ExisteEnTxt = 'S'    
            AND Valido = 'N'    
    
        UNION ALL    
    
        -- --------------------------------------------------------------    
        -- ESTADO 9 Que Modifica con valores 0    
        SELECT     
            IdCompania    
            , Reporte               = 'Rectificatoria desde ' + @PeriodoInicioLocal + ' hasta ' + @PeriodoFin    
            , Periodo               = LEFT(PeriodoLE,6)              , PeriodoLE             = PeriodoLE    
            , Cuo                   = A_Cuo    
            , Correlativo           = A_Correlativo    
            , FechaEmision          = A_FechaEmision    
            , FechaPago             = ISNULL(A_FechaPago,'')    
            , TipoDoc               = A_TipoDoc    
            , Serie                 = A_Serie    
            , Numero                = A_Numero    
            , NumeroFinal           = ISNULL(A_NumeroFinal, '')    
            , TipoDocIdentidad      = A_TipoDocIdentidad    
            , NroDocIdentidad       = A_NroDocIdentidad    
            , NombresRazonSocial    = A_NombresRazonSocial    
            , Exportacion           = A_Exportacion    
            , BIGravada             = A_BIGravada    
            , DsctoBI               = A_DsctoBI    
            , DIGV                  = A_DIGV    
            , DsctoIGV              = A_DsctoIGV    
            , Exonerado             = A_Exonerado    
            , Inafecto              = A_Inafecto    
            , ISC                   = A_ISC    
            , BIGravIVAP            = A_BIGravIVAP    
            , IVAP                  = A_IVAP    
            , ICBPER                = A_ICBPER    
            , OtrosTributos         = A_OtrosTributos    
            , Total                 = 0.00    
            , Moneda                = A_Moneda    
            , TipoCambio            = A_TipoCambio    
            , FechaEmisionMod       = A_FechaEmisionMod    
            , TipoDocMod            = A_TipoDocMod    
            , SerieMod              = A_SerieMod    
            , NumeroMod             = A_NumeroMod    
            , Contrato              = ISNULL(A_Contrato, '')    
            , Error1                = ISNULL(A_Error1, '')    
            , MedioPago             = ISNULL(A_MedioPago, '')    
            , Estado                = '9'    
            , ExisteEnOrigen    
            , ExisteEnTxt    
            , Valido    
            , Motivo                = 'Modifica por CERO'    
            , De                    = ''    
            , Por                   = ''    
            , TXT                   = space(500)    
        FROM Financiero.PLE_140100_rectifica_reporte    
        WHERE ExisteEnOrigen = 'N'    
          
        UNION ALL    
        -- --------------------------------------------------------------    
        -- ESTADO 8 Nuevos registros    
        SELECT    
            IdCompania    
            , Reporte               = 'Rectificatoria desde ' + @PeriodoInicioLocal + ' hasta ' + @PeriodoFin    
            , Periodo               = LEFT(PeriodoLE,6)    
            , PeriodoLE             = PeriodoLE    
            , Cuo                   = B_Cuo                     
            , Correlativo           = B_Correlativo             
            , FechaEmision          = B_FechaEmision            
            , FechaPago             = B_FechaPago               
            , TipoDoc               = B_TipoDoc                 
            , Serie                 = B_Serie                   
            , Numero                = B_Numero                  
            , NumeroFinal           = B_NumeroFinal             
            , TipoDocIdentidad      = B_TipoDocIdentidad        
            , NroDocIdentidad       = B_NroDocIdentidad         
            , NombresRazonSocial    = B_NombresRazonSocial      
            , Exportacion           = B_Exportacion             
            , BIGravada             = B_BIGravada               
            , DsctoBI               = B_DsctoBI                 
            , DIGV                  = B_DIGV                    
            , DsctoIGV              = B_DsctoIGV                
            , Exonerado             = B_Exonerado               
            , Inafecto              = B_Inafecto                
            , ISC                   = B_ISC                     
            , BIGravIVAP            = B_BIGravIVAP              
            , IVAP                  = B_IVAP                    
            , ICBPER                = B_ICBPER                  
            , OtrosTributos      = B_OtrosTributos           
            , Total                 = B_Total    
            , Moneda                = B_Moneda    
            , TipoCambio            = B_TipoCambio    
            , FechaEmisionMod       = B_FechaEmisionMod    
            , TipoDocMod            = B_TipoDocMod    
            , SerieMod              = B_SerieMod    
            , NumeroMod             = B_NumeroMod    
            , Contrato              = B_Contrato    
            , Error1                = B_Error1    
            , MedioPago             = B_MedioPago    
            , Estado                = '8'    
    
            , ExisteEnOrigen    
            , ExisteEnTxt    
            , Valido    
            , Motivo                = 'Nuevo Registro'    
            , De                    = ''    
            , Por                   = ''    
            , TXT                   = space(500)    
        FROM Financiero.PLE_140100_rectifica_reporte    
        WHERE ExisteEnTxt = 'N'    
        
        -- --------------------------------------------------------------    
        -- TXT GENERA SIRE    
        UPDATE Financiero.SIRE_14040004    
            SET TXT = PeriodoLE    
                + '|' + Cuo    
                + '|' + Correlativo    
                + '|' + FechaEmision    
                + '|' + FechaPago    
                + '|' + TipoDoc    
                + '|' + Serie    
                + '|' + Numero    
                + '|' + NumeroFinal    
                + '|' + TipoDocIdentidad    
                + '|' + NroDocIdentidad    
                + '|' + NombresRazonSocial    
                + '|' + CONVERT(VARCHAR, Exportacion)    
                + '|' + CONVERT(VARCHAR, BIGravada)    
                + '|' + CONVERT(VARCHAR, DsctoBI)    
                + '|' + CONVERT(VARCHAR, DIGV)    
                + '|' + CONVERT(VARCHAR, DsctoIGV)    
                + '|' + CONVERT(VARCHAR, Exonerado)    
                + '|' + CONVERT(VARCHAR, Inafecto)    
                + '|' + CONVERT(VARCHAR, ISC)    
                + '|' + CONVERT(VARCHAR, BIGravIVAP)    
                + '|' + CONVERT(VARCHAR, IVAP)    
                + '|' + CONVERT(VARCHAR, ICBPER)    
                + '|' + CONVERT(VARCHAR, OtrosTributos)    
                + '|' + CONVERT(VARCHAR, Total)    
                + '|' + Moneda    
                + '|' + CONVERT(VARCHAR, TipoCambio)    
                + '|' + FechaEmisionMod    
                + '|' + TipoDocMod    
                + '|' + SerieMod    
                + '|' + NumeroMod    
                + '|' + Contrato    
                + '|' + Error1    
                + '|' + MedioPago    
                + '|' + Estado    
                + '|';    
    
        -- =======================================================================================================    
        -- REPORTES    
        -- =======================================================================================================    
        -- --------------------------------------------------------------    
        -- Resumen registros procesados    
        INSERT INTO @Reporte (Orden, Resultado, [Message])    
        SELECT 2000000, 1, 'Procesado |' + CONVERT(VARCHAR(8), COUNT(1)) + ' Registros procesados'    
        FROM Financiero.PLE_140100_txt_declarado;    
        
        -- --------------------------------------------------------------    
        -- Resumen rectificados    
        INSERT INTO @Reporte (Orden, Resultado, [Message])    
        SELECT  
            3000000 + ROW_NUMBER() OVER (ORDER BY s14.IdCompania, s14.Periodo, s14.Estado)    
            , 1    
            , 'Rectificatoria 050100 del periodo ' + ISNULL(s14.Periodo, '') + '|' + CONVERT(varchar(8), COUNT(1)) + ' registros con estado (' + ISNULL(s14.Estado, '') + ')'  
        FROM Financiero.SIRE_14040004  as s14     
        GROUP BY s14.IdCompania, s14.Periodo, s14.Estado   
  
    
        -- Clear    
        DROP TABLE #ple140100_txt;    
        DROP TABLE #temp140100_txt_Estado9;    
        DROP TABLE #ple140100_origen;    
    
        IF EXISTS(SELECT * FROM sys.all_objects where name = 'PLE_140100_txt_extraido') drop table Financiero.PLE_140100_txt_extraido;    
        IF EXISTS(SELECT * FROM sys.all_objects where name = 'PLE_14040004_txt_extraido') drop table Financiero.PLE_14040004_txt_extraido;    
    END    
    
    IF @CodigoLE = '14040002'    
    BEGIN    
        -- =======================================================================================================    
        -- ULTIMA MODIFICACION    
        -- =======================================================================================================    
        SELECT * INTO #temp14040002_txt_ultimo    
        FROM (    
            SELECT *    
                , Fila = ROW_NUMBER()  OVER (    
                                                PARTITION BY SUBSTRING(Compania, 1, 2), TipoDoc, Serie, Numero    
                                                ORDER BY SUBSTRING(Compania, 1, 2), TipoDoc, Serie, Numero, SUBSTRING(Compania, 3, 6), SUBSTRING(Compania, 9, 2) DESC    
                                            )     
            FROM    
                Financiero.PLE_14040003_txt_extraido     
        ) t    
        WHERE Fila = 1    
    
        -- =======================================================================================================    
        -- COMBINAR REGISTROS MODIFICADOS    
        -- =======================================================================================================    
        SELECT    
            PeriodoLE                 = IIF(t3.Compania IS NULL, t1.PeriodoLE           , t3.PeriodoLE)    
            , FechaEmision            = IIF(t3.Compania IS NULL, t1.FechaEmision        , t3.FechaEmision)    
            , FechaVen                = IIF(t3.Compania IS NULL, t1.FechaVen            , t3.FechaVen)    
            , TipoDoc                 = IIF(t3.Compania IS NULL, t1.TipoDoc             , t3.TipoDoc)    
            , Serie                   = IIF(t3.Compania IS NULL, t1.Serie               , t3.Serie)    
            , Numero                  = IIF(t3.Compania IS NULL, t1.Numero              , t3.Numero)    
            , NumeroFinal             = IIF(t3.Compania IS NULL, t1.NumeroFinal         , t3.NumeroFinal)    
            , TipoDocIdentidad        = IIF(t3.Compania IS NULL, t1.TipoDocIdentidad    , t3.TipoDocIdentidad)    
            , NroDocIdentidad         = IIF(t3.Compania IS NULL, t1.NroDocIdentidad     , t3.NroDocIdentidad)    
            , NombresRazonSocial      = IIF(t3.Compania IS NULL, t1.NombresRazonSocial  , t3.NombresRazonSocial)    
            , Exportacion             = IIF(t3.Compania IS NULL, t1.Exportacion         , t3.Exportacion)    
            , BIGravada               = IIF(t3.Compania IS NULL, t1.BIGravada           , t3.BIGravada)    
            , DsctoBI                 = IIF(t3.Compania IS NULL, t1.DsctoBI             , t3.DsctoBI)    
            , IGV                     = IIF(t3.Compania IS NULL, t1.IGV                 , t3.IGV)    
            , DsctoIGV                = IIF(t3.Compania IS NULL, t1.DsctoIGV            , t3.DsctoIGV)    
            , Exonerado               = IIF(t3.Compania IS NULL, t1.Exonerado           , t3.Exonerado)    
            , Inafecto                = IIF(t3.Compania IS NULL, t1.Inafecto            , t3.Inafecto)    
            , ISC                     = IIF(t3.Compania IS NULL, t1.ISC                 , t3.ISC)    
            , BIGravIVAP              = IIF(t3.Compania IS NULL, t1.BIGravIVAP          , t3.BIGravIVAP)    
            , IVAP                    = IIF(t3.Compania IS NULL, t1.IVAP                , t3.IVAP)    
            , ICBPER                  = IIF(t3.Compania IS NULL, t1.ICBPER              , t3.ICBPER)    
            , OtrosTributos           = IIF(t3.Compania IS NULL, t1.OtrosTributos       , t3.OtrosTributos)    
            , Total                   = IIF(t3.Compania IS NULL, t1.Total               , t3.Total)    
            , Moneda                  = IIF(t3.Compania IS NULL, t1.Moneda              , t3.Moneda)    
            , TipoCambio              = IIF(t3.Compania IS NULL, t1.TipoCambio          , t3.TipoCambio)    
            , FechaEmisionMod         = IIF(t3.Compania IS NULL, t1.FechaEmisionMod     , t3.FechaEmisionMod)    
   , TipoDocMod   = IIF(t3.Compania IS NULL, t1.TipoDocMod          , t3.TipoDocMod)    
            , SerieMod                = IIF(t3.Compania IS NULL, t1.SerieMod            , t3.SerieMod)    
            , NumeroMod               = IIF(t3.Compania IS NULL, t1.NumeroMod           , t3.NumeroMod)    
            , IDProyecto              = IIF(t3.Compania IS NULL, t1.IDProyecto          , t3.IDProyecto)    
    
            , IdCompania              = IIF(t3.Compania IS NULL, SUBSTRING(t1.Compania, 1, 2), SUBSTRING(t3.Compania, 1, 2))    
            , CodigoAnioPeriodo       = IIF(t3.Compania IS NULL, SUBSTRING(t1.Compania, 3, 6), SUBSTRING(t3.Compania, 3, 6))    
            , EsAjustePosterior       = IIF(t3.Compania IS NULL, 'N', 'S')    
            INTO #sire14010002_txt    
        FROM Financiero.PLE_14040002_txt_extraido as t1    
            FULL JOIN #temp14040002_txt_ultimo as t3 ON SUBSTRING(t3.Compania, 1, 2) = SUBSTRING(t1.Compania, 1, 2)    
                AND t3.PeriodoLE = t1.PeriodoLE    
                AND t3.TipoDoc = t1.TipoDoc    
                AND t3.Serie = t1.Serie    
                AND t3.Numero = t1.Numero;    
              
        -- =======================================================================================================    
        -- TRANSFORMAR  TXT  PARA COMPARAR    
        -- =======================================================================================================    
        DELETE FROM #sire14010002_txt WHERE Total = 0 AND EsAjustePosterior = 'S'; -- Eliminar registros anulados de ajustes    
    
        -- =======================================================================================================    
        -- TRANSFORMAR  ORIGEN PARA COMPARAR    
        -- =======================================================================================================    
        SELECT    
            * INTO #sire14010002_origen    
        FROM Financiero.SIRE_14040002    
        WHERE IdCompania = @IdCompania    
            AND CodigoAnioPeriodo >= @PeriodoInicioLocal    
            AND CodigoAnioPeriodo < @PeriodoFin    
    
        -- =======================================================================================================    
        -- REALIZAR COMPARATIVA ORIGEN VS TXT    
        -- =======================================================================================================    
        SELECT    
            pl3.*    
            , Valido = IIF(    
                C_Exportacion != 0    
                OR C_BIGravada != 0    
                OR C_DsctoBI != 0    
                OR C_IGV != 0    
                OR C_DsctoIGV != 0    
                OR C_Exonerado != 0    
                OR C_Inafecto != 0    
                OR C_ISC != 0    
                OR C_BIGravIVAP != 0    
                OR C_IVAP != 0    
                OR C_ICBPER != 0    
                OR C_OtrosTributos != 0    
                OR C_Total != 0    
                OR C_TipoCambio != 0    
                OR C_FechaEmisionMod = 'S'    
                OR C_TipoDocMod = 'S'    
                OR C_SerieMod = 'S'    
                OR C_NumeroMod = 'S'    
                ,'N','S'    
            )    
            --, Observacion = CONCAT(    
            --    IIF(C_Exportacion != 0, 'Exportacion no cuadra', '')    
            --    , IIF(C_BIGravada != 0, ', BIGravada no cuadra', '')    
            --    , IIF(C_DsctoBI != 0, ', DsctoBI no cuadra', '')    
            --    , IIF(C_IGV != 0, ', IGV no cuadra', '')    
            --    , IIF(C_DsctoIGV != 0, ', DsctoIGV no cuadra', '')    
            --    , IIF(C_Exonerado != 0, ', Exonerado no cuadra', '')    
            --    , IIF(C_Inafecto != 0, ', Inafecto no cuadra', '')    
            --    , IIF(C_ISC != 0, ', ISC no cuadra', '')    
            --    , IIF(C_BIGravIVAP != 0, ', BIGravIVAP no cuadra', '')    
--    , IIF(C_IVAP != 0, ', IVAP no cuadra', '')    
            --    , IIF(C_ICBPER != 0, ', ICBPER no cuadra', '')    
            --    , IIF(C_OtrosTributos != 0, ', OtrosTributos no cuadra', '')    
            --    , IIF(C_Total != 0, ', Total no cuadra', '')    
        --    , IIF(C_TipoCambio != 0, ', Tipo cambio no cuadra', '')    
            --    , IIF(C_FechaEmisionMod = 'S', ', Fecha de emisión modifica no coincide','')    
            --    , IIF(C_TipoDocMod = 'S', ', Tipo documento modifica no coincide','')    
            --    , IIF(C_SerieMod = 'S', ', Serie modifica no coincide','')    
            --    , IIF(C_NumeroMod = 'S', ', Numero modifica no coincide','')    
            --)    
            INTO Financiero.SIRE_14040002_rectifica_reporte    
        FROM (    
            SELECT    
                --A_Cuo                   = a.Cuo    
                --, A_Correlativo         = a.Correlativo    
                A_FechaEmision        = a.FechaEmision    
                , A_FechaPago           = a.FechaVen    
                , A_TipoDoc             = a.TipoDoc    
                , A_Serie               = a.Serie    
                , A_Numero              = a.Numero    
                , A_NumeroFinal         = a.NumeroFinal    
                , A_TipoDocIdentidad    = a.TipoDocIdentidad    
                , A_NroDocIdentidad     = a.NroDocIdentidad    
                , A_NombresRazonSocial  = a.NombresRazonSocial    
                , A_Exportacion         = a.Exportacion    
                , A_BIGravada           = a.BIGravada    
                , A_DsctoBI             = a.DsctoBI    
                , A_DIGV                = a.IGV    
                , A_DsctoIGV            = a.DsctoIGV    
                , A_Exonerado           = a.Exonerado    
                , A_Inafecto            = a.Inafecto    
                , A_ISC                 = a.ISC    
                , A_BIGravIVAP          = a.BIGravIVAP    
                , A_IVAP                = a.IVAP    
                , A_ICBPER              = a.ICBPER    
                , A_OtrosTributos       = a.OtrosTributos    
                , A_Total               = a.Total    
                , A_Moneda              = a.Moneda    
                , A_TipoCambio          = a.TipoCambio    
                , A_FechaEmisionMod     = a.FechaEmisionMod    
                , A_TipoDocMod          = a.TipoDocMod    
                , A_SerieMod            = a.SerieMod    
                , A_NumeroMod           = a.NumeroMod    
                , A_Contrato            = a.IDProyecto    
                --, A_Error1              = a.Error1    
                --, A_MedioPago           = a.MedioPago    
                --, A_Estado              = a.Estado    
    
                --, B_Cuo                 = b.Cuo    
                --, B_Correlativo         = b.Correlativo    
                , B_FechaEmision        = b.FechaEmision    
                , B_FechaPago           = b.FechaPago    
                , B_TipoDoc             = b.TipoDoc    
                , B_Serie               = b.Serie    
                , B_Numero              = b.Numero    
                , B_NumeroFinal         = b.NumeroFinal    
                , B_TipoDocIdentidad    = b.TipoDocIdentidad    
                , B_NroDocIdentidad     = b.NroDocIdentidad    
                , B_NombresRazonSocial  = b.NombresRazonSocial    
                , B_Exportacion         = b.Exportacion    
                , B_BIGravada           = b.BIGravada    
                , B_DsctoBI             = b.DsctoBI    
                , B_DIGV                = b.DIGV    
                , B_DsctoIGV            = b.DsctoIGV    
                , B_Exonerado           = b.Exonerado    
                , B_Inafecto            = b.Inafecto    
                , B_ISC                 = b.ISC    
                , B_BIGravIVAP          = b.BIGravIVAP    
                , B_IVAP                = b.IVAP    
                , B_ICBPER              = b.ICBPER    
                , B_OtrosTributos       = b.OtrosTributos    
                , B_Total               = b.Total    
                , B_Moneda              = b.Moneda    
                , B_TipoCambio          = b.TipoCambio    
                , B_FechaEmisionMod     = b.FechaEmisionMod    
                , B_TipoDocMod          = b.TipoDocMod    
                , B_SerieMod            = b.SerieMod    
                , B_NumeroMod           = b.NumeroMod    
                , B_Contrato            = b.Contrato    
                --, B_Error1              = b.Error1    
                --, B_MedioPago           = b.MedioPago    
                --, B_Estado              = b.Estado    
    
                , C_Exportacion         = ISNULL(a.Exportacion, 0)     - ISNULL(b.Exportacion, 0)    
                , C_BIGravada           = ISNULL(a.BIGravada, 0)       - ISNULL(b.BIGravada, 0)    
                , C_DsctoBI             = ISNULL(a.DsctoBI, 0)         - ISNULL(b.DsctoBI, 0)    
                , C_IGV                 = ISNULL(a.IGV, 0)             - ISNULL(b.DIGV, 0)    
                , C_DsctoIGV            = ISNULL(a.DsctoIGV, 0)        - ISNULL(b.DsctoIGV, 0)    
                , C_Exonerado           = ISNULL(a.Exonerado, 0)       - ISNULL(b.Exonerado, 0)    
                , C_Inafecto            = ISNULL(a.INAFECTO, 0)        - ISNULL(b.Inafecto, 0)    
                , C_ISC                 = ISNULL(a.ISC, 0)             - ISNULL(b.ISC, 0)    
                , C_BIGravIVAP          = ISNULL(a.BIGravIVAP, 0)      - ISNULL(b.BIGravIVAP, 0)    
                , C_IVAP                = ISNULL(a.IVAP, 0)            - ISNULL(b.IVAP, 0)    
                , C_ICBPER              = ISNULL(a.ICBPER, 0)          - ISNULL(b.ICBPER, 0)    
                , C_OtrosTributos       = ISNULL(a.OtrosTributos, 0)   - ISNULL(b.OtrosTributos, 0)    
                , C_Total               = ISNULL(a.TOTAL, 0)           - ISNULL(b.Total, 0)    
    
                , C_TipoCambio          = ISNULL(a.TipoCambio, 0)      - ISNULL(b.TipoCambio, 0)    
    
                , C_FechaEmisionMod     = IIF(a.FechaEmisionMod != b.FechaEmisionMod, 'S', 'N')    
                , C_TipoDocMod          = IIF(a.TipoDocMod != b.TipoDocMod, 'S', 'N')    
                , C_SerieMod            = IIF(a.SerieMod != b.SerieMod, 'S', 'N')    
                , C_NumeroMod           = IIF(a.NumeroMod != b.NumeroMod, 'S', 'N')    
    
                , IdCompania            = ISNULL(a.IdCompania, b.IdCompania)    
                , PeriodoLE             = ISNULL(a.PeriodoLE, b.PeriodoLE)    
                , TipoDoc               = ISNULL(a.TipoDoc, b.TipoDoc)    
                , Serie                 = ISNULL(a.Serie, b.Serie)    
                , Numero                = ISNULL(a.Numero, b.Numero)    
                , ExisteEnTxt           = IIF(a.IdCompania IS NOT NULL, 'S', 'N')    
                , ExisteEnOrigen        = IIF(b.IdCompania IS NOT NULL, 'S', 'N')    
    
            FROM #sire14010002_txt  as a    
            FULL JOIN #sire14010002_origen as b ON b.IdCompania = a.IdCompania    
                AND b.PeriodoLE = a.PeriodoLE    
                AND b.TipoDoc = a.TipoDoc    
                AND b.Serie = a.Serie    
                AND b.Numero = a.Numero    
        ) as pl3;    
    
    
        -- =======================================================================================================    
        -- GUARDAR PARA TXT DE RECTIFICATORIA    
        -- =======================================================================================================    
        -- Genera Para Sire - Anexo 4    
    
        -- --------------------------------------------------------------    
        -- ESTADO "MODIFICADO"    
        SELECT    
            IdCompania    
            , Reporte               = 'Rectificatoria desde ' + @PeriodoInicioLocal + ' hasta ' + @PeriodoFin    
            , Periodo               = LEFT(PeriodoLE,6)    
            , PeriodoLE             = PeriodoLE    
            --, Cuo                   = B_Cuo    
            --, Correlativo           = B_Correlativo    
            , FechaEmision          = B_FechaEmision    
            , FechaPago             = ISNULL(B_FechaPago,'')    
            , TipoDoc               = B_TipoDoc    
            , Serie                 = B_Serie    
            , Numero                = B_Numero    
            , NumeroFinal           = ISNULL(B_NumeroFinal,'')    
            , TipoDocIdentidad      = B_TipoDocIdentidad        
            , NroDocIdentidad       = B_NroDocIdentidad         
            , NombresRazonSocial    = B_NombresRazonSocial      
            , Exportacion           = B_Exportacion             
            , BIGravada             = B_BIGravada               
            , DsctoBI               = B_DsctoBI                 
            , DIGV                  = B_DIGV                    
            , DsctoIGV              = B_DsctoIGV                
            , Exonerado             = B_Exonerado               
            , Inafecto              = B_Inafecto                
            , ISC                   = B_ISC                     
            , BIGravIVAP            = B_BIGravIVAP              
            , IVAP                  = B_IVAP                    
            , ICBPER                = B_ICBPER                  
            , OtrosTributos         = B_OtrosTributos           
            , Total                 = B_Total    
            , Moneda                = B_Moneda    
            , TipoCambio            = B_TipoCambio    
            , FechaEmisionMod       = B_FechaEmisionMod    
            , TipoDocMod            = B_TipoDocMod    
            , SerieMod              = B_SerieMod    
            , NumeroMod             = B_NumeroMod    
            , Contrato              = ISNULL(B_Contrato,'')                
            --, Error1                = ISNULL(B_Error1,'')    
            --, MedioPago             = ISNULL(B_MedioPago,'')    
            , Estado                = 'MODIFICADO'    
            , ExisteEnOrigen    
            , ExisteEnTxt    
            , Valido    
            , Motivo                = 'Cambio en: ' + TRIM('/ ' FROM CONCAT(    
                                        IIF(C_Exportacion != 0, ' / Exportacion', '')    
                                        , IIF(C_BIGravada != 0, ' / BIGravada', '')    
                                        , IIF(C_DsctoBI != 0, ' / DsctoBI', '')    
                                        , IIF(C_IGV != 0, ' / IGV', '')    
                                        , IIF(C_DsctoIGV != 0, ' / DsctoIGV', '')    
                                        , IIF(C_Exonerado != 0, ' / Exonerado', '')    
                                        , IIF(C_Inafecto != 0, ' / Inafecto', '')    
                                        , IIF(C_ISC != 0, ' / ISC', '')    
                                        , IIF(C_BIGravIVAP != 0, ' / BIGravIVAP', '')    
                                        , IIF(C_IVAP != 0, ' / IVAP', '')    
                                        , IIF(C_ICBPER != 0, ' / ICBPER', '')    
                                        , IIF(C_OtrosTributos != 0, ' / OtrosTributos', '')    
                                        , IIF(C_Total != 0, ' / Total', '')    
                                        , IIF(C_TipoCambio != 0, ' / Tipo cambio', '')    
                                        , IIF(C_FechaEmisionMod = 'S', ' / Fecha de emisión modifica','')    
                                        , IIF(C_TipoDocMod = 'S', ' / Tipo documento modifica','')    
                                        , IIF(C_SerieMod = 'S', ' / Serie modifica','')    
                                        , IIF(C_NumeroMod = 'S', ' / Numero modifica','')    
                                    ))    
            , De                    = TRIM('/ ' FROM CONCAT(    
                                        IIF(C_Exportacion != 0, ' / ' + CONVERT(varchar, A_Exportacion), '')    
                                        , IIF(C_BIGravada != 0, ' / ' + CONVERT(varchar, A_BIGravada), '')    
                                        , IIF(C_DsctoBI != 0, ' / ' + CONVERT(varchar, A_DsctoBI), '')    
, IIF(C_IGV != 0, ' / ' + CONVERT(varchar, A_DIGV), '')    
             , IIF(C_DsctoIGV != 0, ' / ' + CONVERT(varchar, A_DsctoIGV), '')    
                                        , IIF(C_Exonerado != 0, ' / ' + CONVERT(varchar, A_Exonerado), '')    
                                        , IIF(C_Inafecto != 0, ' / ' + CONVERT(varchar, A_Inafecto), '')    
                                        , IIF(C_ISC != 0, ' / ' + CONVERT(varchar, A_ISC), '')    
                                        , IIF(C_BIGravIVAP != 0, ' / ' + CONVERT(varchar, A_BIGravIVAP), '')    
                                        , IIF(C_IVAP != 0, ' / ' + CONVERT(varchar, A_IVAP), '')    
                                        , IIF(C_ICBPER != 0, ' / ' + CONVERT(varchar, A_ICBPER), '')    
                                        , IIF(C_OtrosTributos != 0, ' / ' + CONVERT(varchar, A_OtrosTributos), '')    
                                        , IIF(C_Total != 0, ' / ' + CONVERT(varchar, A_Total), '')    
                                        , IIF(C_TipoCambio != 0, ' / ' + CONVERT(varchar, A_TipoCambio), '')    
                                        , IIF(C_FechaEmisionMod = 'S', ' / ' + A_FechaEmisionMod,'')    
                                        , IIF(C_TipoDocMod = 'S', ' / ' + A_TipoDocMod,'')    
                                        , IIF(C_SerieMod = 'S', ' / ' + A_SerieMod,'')    
                                        , IIF(C_NumeroMod = 'S', ' / ' + A_NumeroMod,'')    
                                    ))    
            , Por                    = TRIM('/ ' FROM CONCAT(    
                                        IIF(C_Exportacion != 0, ' / ' + CONVERT(varchar, B_Exportacion), '')    
                                        , IIF(C_BIGravada != 0, ' / ' + CONVERT(varchar, B_BIGravada), '')    
                                        , IIF(C_DsctoBI != 0, ' / ' + CONVERT(varchar, B_DsctoBI), '')    
                                        , IIF(C_IGV != 0, ' / ' + CONVERT(varchar, B_DIGV), '')    
                                        , IIF(C_DsctoIGV != 0, ' / ' + CONVERT(varchar, B_DsctoIGV), '')    
                                        , IIF(C_Exonerado != 0, ' / ' + CONVERT(varchar, B_Exonerado), '')    
                                        , IIF(C_Inafecto != 0, ' / ' + CONVERT(varchar, B_Inafecto), '')    
                                        , IIF(C_ISC != 0, ' / ' + CONVERT(varchar, B_ISC), '')    
                                        , IIF(C_BIGravIVAP != 0, ' / ' + CONVERT(varchar, B_BIGravIVAP), '')    
                                        , IIF(C_IVAP != 0, ' / ' + CONVERT(varchar, B_IVAP), '')    
                                        , IIF(C_ICBPER != 0, ' / ' + CONVERT(varchar, B_ICBPER), '')    
                                        , IIF(C_OtrosTributos != 0, ' / ' + CONVERT(varchar, B_OtrosTributos), '')    
                                        , IIF(C_Total != 0, ' / ' + CONVERT(varchar, B_Total), '')    
                                        , IIF(C_TipoCambio != 0, ' / ' + CONVERT(varchar, B_TipoCambio), '')    
                                        , IIF(C_FechaEmisionMod = 'S', ' / ' + B_FechaEmisionMod,'')    
                                        , IIF(C_TipoDocMod = 'S', ' / ' + B_TipoDocMod,'')    
                                        , IIF(C_SerieMod = 'S', ' / ' + B_SerieMod,'')    
                                        , IIF(C_NumeroMod = 'S', ' / ' + B_NumeroMod,'')    
                                    ))    
            , TXT                   = space(500)    
    
            INTO Financiero.SIRE_14040003    
    
        FROM Financiero.SIRE_14040002_rectifica_reporte    
        WHERE ExisteEnOrigen = 'S'    
            AND ExisteEnTxt = 'S'    
            AND Valido = 'N'    
    
        UNION ALL    
    
        -- --------------------------------------------------------------    
        -- ESTADO "ANULADO" Que Modifica con valores 0    
        SELECT     
            IdCompania    
    , Reporte               = 'Rectificatoria desde ' + @PeriodoInicioLocal + ' hasta ' + @PeriodoFin    
            , Periodo               = LEFT(PeriodoLE,6)    
            , PeriodoLE             = PeriodoLE              --, Cuo                   = A_Cuo                     
            --, Correlativo           = A_Correlativo             
            , FechaEmision          = A_FechaEmision            
            , FechaPago             = ISNULL(A_FechaPago,'')    
            , TipoDoc               = A_TipoDoc    
            , Serie                 = A_Serie    
            , Numero                = A_Numero    
            , NumeroFinal           = ISNULL(A_NumeroFinal, '')    
            , TipoDocIdentidad      = A_TipoDocIdentidad    
            , NroDocIdentidad       = A_NroDocIdentidad    
            , NombresRazonSocial    = A_NombresRazonSocial    
            , Exportacion           = 0.00    
            , BIGravada             = 0.00    
            , DsctoBI               = 0.00    
            , DIGV                  = 0.00    
            , DsctoIGV              = 0.00    
            , Exonerado             = 0.00    
            , Inafecto              = 0.00    
            , ISC                   = 0.00    
            , BIGravIVAP            = 0.00    
            , IVAP                  = 0.00    
            , ICBPER                = 0.00    
            , OtrosTributos         = 0.00    
            , Total                 = 0.00    
            , Moneda                = A_Moneda    
            , TipoCambio            = A_TipoCambio    
            , FechaEmisionMod       = A_FechaEmisionMod    
            , TipoDocMod            = A_TipoDocMod    
            , SerieMod              = A_SerieMod    
            , NumeroMod             = A_NumeroMod    
            , Contrato              = ISNULL(A_Contrato, '')    
            --, Error1                = ISNULL(A_Error1, '')    
            --, MedioPago             = ISNULL(A_MedioPago, '')    
            , Estado                = 'ANULADO'    
            , ExisteEnOrigen    
            , ExisteEnTxt    
            , Valido    
            , Motivo                = 'Cambio por cero en: ' + TRIM('/ ' FROM CONCAT(    
                                        IIF(A_Exportacion != 0, ' / Exportacion', '')    
                                        , IIF(A_BIGravada != 0, ' / BIGravada', '')    
                                        , IIF(A_DsctoBI != 0, ' / DsctoBI', '')    
                                        , IIF(A_DIGV != 0, ' / IGV', '')    
                                        , IIF(A_DsctoIGV != 0, ' / DsctoIGV', '')    
                                        , IIF(A_Exonerado != 0, ' / Exonerado', '')    
                                        , IIF(A_Inafecto != 0, ' / Inafecto', '')    
                                        , IIF(A_ISC != 0, ' / ISC', '')    
                                        , IIF(A_BIGravIVAP != 0, ' / BIGravIVAP', '')    
                                        , IIF(A_IVAP != 0, ' / IVAP', '')    
                                        , IIF(A_ICBPER != 0, ' / ICBPER', '')    
                                        , IIF(A_OtrosTributos != 0, ' / OtrosTributos', '')    
                                        , IIF(A_Total != 0, ' / Total', '')    
                                    ))    
            , De                    = TRIM('/ ' FROM CONCAT(    
                                        IIF(A_Exportacion != 0, ' / ' + CONVERT(varchar, A_Exportacion), '')    
                                        , IIF(A_BIGravada != 0, ' / ' + CONVERT(varchar, A_BIGravada), '')    
                                        , IIF(A_DsctoBI != 0, ' / ' + CONVERT(varchar, A_DsctoBI), '')    
                                        , IIF(A_DIGV != 0, ' / ' + CONVERT(varchar, A_DIGV), '')    
                                        , IIF(A_DsctoIGV != 0, ' / ' + CONVERT(varchar, A_DsctoIGV), '')    
                                        , IIF(A_Exonerado != 0, ' / ' + CONVERT(varchar, A_Exonerado), '')    
                                        , IIF(A_Inafecto != 0, ' / ' + CONVERT(varchar, A_Inafecto), '')    
                                        , IIF(A_ISC != 0, ' / ' + CONVERT(varchar, A_ISC), '')    
                 , IIF(A_BIGravIVAP != 0, ' / ' + CONVERT(varchar, A_BIGravIVAP), '')    
                                        , IIF(A_IVAP != 0, ' / ' + CONVERT(varchar, A_IVAP), '')    
                                        , IIF(A_ICBPER != 0, ' / ' + CONVERT(varchar, A_ICBPER), '')    
                                        , IIF(A_OtrosTributos != 0, ' / ' + CONVERT(varchar, A_OtrosTributos), '')    
                                        , IIF(A_Total != 0, ' / ' + CONVERT(varchar, A_Total), '')    
                                    ))    
            , Por                    = TRIM('/ ' FROM CONCAT(    
                                        IIF(A_Exportacion != 0, ' / 0.00', '')    
                                        , IIF(A_BIGravada != 0, ' / 0.00', '')    
                                        , IIF(A_DsctoBI != 0, ' / 0.00', '')    
                                        , IIF(A_DIGV != 0, ' / 0.00', '')    
                                        , IIF(A_DsctoIGV != 0, ' / 0.00', '')    
                                        , IIF(A_Exonerado != 0, ' / 0.00', '')    
                                        , IIF(A_Inafecto != 0, ' / 0.00', '')    
                                        , IIF(A_ISC != 0, ' / 0.00', '')    
                                        , IIF(A_BIGravIVAP != 0, ' / 0.00', '')    
                                        , IIF(A_IVAP != 0, ' / 0.00', '')    
                                        , IIF(A_ICBPER != 0, ' / 0.00', '')    
                                        , IIF(A_OtrosTributos != 0, ' / 0.00', '')    
                                        , IIF(A_Total != 0, ' / 0.00', '')    
                                    ))    
            , TXT                   = space(500)    
        FROM Financiero.SIRE_14040002_rectifica_reporte    
        WHERE ExisteEnOrigen = 'N'    
          
        UNION ALL    
        -- --------------------------------------------------------------    
        -- ESTADO 8 Nuevos registros    
        SELECT    
            IdCompania    
            , Reporte               = 'Rectificatoria desde ' + @PeriodoInicioLocal + ' hasta ' + @PeriodoFin    
            , Periodo               = LEFT(PeriodoLE,6)    
            , PeriodoLE             = PeriodoLE    
            --, Cuo                   = B_Cuo    
            --, Correlativo           = B_Correlativo    
            , FechaEmision          = B_FechaEmision    
            , FechaPago             = B_FechaPago    
            , TipoDoc               = B_TipoDoc    
            , Serie                 = B_Serie    
            , Numero                = B_Numero    
            , NumeroFinal           = B_NumeroFinal    
            , TipoDocIdentidad      = B_TipoDocIdentidad    
            , NroDocIdentidad       = B_NroDocIdentidad    
            , NombresRazonSocial    = B_NombresRazonSocial    
            , Exportacion           = B_Exportacion    
            , BIGravada             = B_BIGravada    
            , DsctoBI               = B_DsctoBI    
            , DIGV                  = B_DIGV    
            , DsctoIGV              = B_DsctoIGV    
            , Exonerado             = B_Exonerado    
            , Inafecto              = B_Inafecto    
            , ISC                   = B_ISC    
            , BIGravIVAP            = B_BIGravIVAP    
            , IVAP                  = B_IVAP    
            , ICBPER                = B_ICBPER    
            , OtrosTributos         = B_OtrosTributos    
            , Total                 = B_Total    
            , Moneda                = B_Moneda    
            , TipoCambio            = B_TipoCambio    
            , FechaEmisionMod       = B_FechaEmisionMod    
            , TipoDocMod            = B_TipoDocMod    
            , SerieMod              = B_SerieMod    
            , NumeroMod             = B_NumeroMod    
            , Contrato              = B_Contrato    
            --, Error1                = A_Error1    
            --, MedioPago             = A_MedioPago    
            , Estado                = 'NUEVO'    
    
            , ExisteEnOrigen    
            , ExisteEnTxt    
            , Valido    
            , Motivo                = 'Nuevo Registro'              , De                    = ''    
            , Por                   = ''    
            , TXT                   = space(500)    
        FROM Financiero.SIRE_14040002_rectifica_reporte    
        WHERE ExisteEnTxt = 'N'    
        
        -- --------------------------------------------------------------    
        -- TXT GENERA SIRE    
        UPDATE Financiero.SIRE_14040003    
            SET TXT = @RucEmpresa    
                    + '|' + @RazonSocialEmpresa    
                    + '|' + PeriodoLE    
                    + '|' +     
                    + '|' + FechaEmision    
                    + '|' + FechaPago    
                    + '|' + TipoDoc    
                    + '|' + Serie    
                    + '|' + Numero    
                    + '|' + NumeroFinal    
                    + '|' + TipoDocIdentidad    
                    + '|' + NroDocIdentidad    
                    + '|' + NombresRazonSocial    
                    + '|' + CONVERT(VARCHAR, Exportacion)    
                    + '|' + CONVERT(VARCHAR, BIGravada)    
                    + '|' + CONVERT(VARCHAR, DsctoBI)    
                    + '|' + CONVERT(VARCHAR, DIGV)    
                    + '|' + CONVERT(VARCHAR, DsctoIGV)    
                    + '|' + CONVERT(VARCHAR, Exonerado)    
                    + '|' + CONVERT(VARCHAR, Inafecto)    
                    + '|' + CONVERT(VARCHAR, ISC)    
                    + '|' + CONVERT(VARCHAR, BIGravIVAP)    
                    + '|' + CONVERT(VARCHAR, IVAP)    
                    + '|' + CONVERT(VARCHAR, ICBPER)    
                    + '|' + CONVERT(VARCHAR, OtrosTributos)    
                    + '|' + CONVERT(VARCHAR, Total)    
                    + '|' + Moneda    
                    + '|' + CONVERT(VARCHAR, TipoCambio)    
                    + '|' + FechaEmisionMod    
                    + '|' + TipoDocMod    
                    + '|' + SerieMod    
                    + '|' + NumeroMod    
                    + '|' + Contrato    
                 + '|';    
    
    
        -- =======================================================================================================    
        -- REPORTES    
        -- =======================================================================================================    
        -- --------------------------------------------------------------    
        -- Resumen registros procesados    
        INSERT INTO @Reporte (Orden, Resultado, [Message])    
        SELECT 2000000, 1, 'Procesado |' + CONVERT(VARCHAR(8), COUNT(1)) + ' Registros procesados'    
        FROM Financiero.SIRE_14040002_rectifica_reporte;    
        
        -- --------------------------------------------------------------    
        -- Resumen rectificados    
        INSERT INTO @Reporte (Orden, Resultado, [Message])    
        SELECT    
            3000000 + ROW_NUMBER() OVER (ORDER BY s14.IdCompania, s14.Periodo, s14.Estado)    
            , 1    
            , 'Rectificatoria 14040003 del periodo ' + ISNULL(s14.Periodo, '') + '|' + CONVERT(varchar(8), COUNT(1)) + ' registros con estado (' + ISNULL(s14.Estado, '') + ')'    
        FROM  Financiero.SIRE_14040003 as s14    
        GROUP BY s14.IdCompania, s14.Periodo, s14.Estado;    
    
    
        -- Clear    
        DROP TABLE #temp14040002_txt_ultimo;    
        DROP TABLE #sire14010002_txt;    
        DROP TABLE #sire14010002_origen;    
    
        --IF EXISTS(SELECT * FROM sys.all_objects where name = 'PLE_14040002_txt_extraido') drop table Financiero.PLE_14040002_txt_extraido;    
        --IF EXISTS(SELECT * FROM sys.all_objects where name = 'PLE_14040003_txt_extraido') drop table Financiero.PLE_14040003_txt_extraido;    
    END    
    
    -- Resultado    
    SELECT Resultado, [Message] FROM @Reporte ORDER BY Orden;    
END    