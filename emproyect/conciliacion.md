```sql
CREATE TABLE Financiero.LoteTransaccionConciliacion(
    IdLote int NOT NULL,
    Id int IDENTITY(1,1) NOT NULL PRIMARY KEY,

    Numero VARCHAR(24) NULL,
    FechaConciliacion datetime NULL,
    ConciliadoSN varchar(1) NULL,
    Descripcion varchar(200) NULL,

    IdEntidad VARCHAR(12) NOT NULL,
    IdCuentaBancaria int NOT NULL,
    IdTipoTransaccionDocumento int NOT NULL,

    IdTipoCambio int NULL,
	MultDiv varchar(20) NULL,
	ImporteCambio decimal(18, 6) NOT NULL,
	IdMonedaBase varchar(3) NOT NULL,
	IdMonedaTransaccion varchar(3) NOT NULL,
    IdMonedaSistema varchar(3) NOT NULL,
    TotalMonedaTransaccion decimal(18, 6) NULL,
	TotalMonedaBase decimal(18, 6) NULL,
    FechaContable datetime NULL,
    FechaTipoCambio datetime NULL,

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

    FOREIGN KEY (IdTipoTransaccionDocumento) REFERENCES Configuracion.TipoTransaccionDocumento (Id),
    FOREIGN KEY (IdLote) REFERENCES Financiero.Lote (Id),
    FOREIGN KEY (IdEntidad) REFERENCES Maestros.Entidad (IdEntidad),

    FOREIGN KEY (IdTipoCambio) REFERENCES Maestros.TipoCambio (Id),
    FOREIGN KEY (IdMonedaBase) REFERENCES Maestros.Moneda (IdMoneda),
    FOREIGN KEY (IdMonedaTransaccion) REFERENCES Maestros.Moneda (IdMoneda),
    FOREIGN KEY (IdMonedaSistema) REFERENCES Maestros.Moneda (IdMoneda),

    FOREIGN KEY (IdCuentaBancaria) REFERENCES Maestros.CuentaBancaria (Id)
)

GO

CREATE TABLE Financiero.LoteTransaccionConciliacionDetalle (
    Id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    IdTransaccion INT NOT NULL,

    Codigo VARCHAR(30) NULL,

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

    FOREIGN KEY (IdTransaccion) REFERENCES Financiero.LoteTransaccionConciliacion (Id)
)

GO


CREATE VIEW Financiero.ViewLoteTransaccionConciliacion as
SELECT
    ltc.IdLote
    , ltc.Id

    , l.IdCompania
	, l.CodigoCompania
    , L.DescripcionCompania  

	, l.IdPeriodo
	, l.DescripcionPeriodo
    , CodigoPeriodo = l.CodigoAnioPeriodo

	, l.IdEstadoLote
	, l.CodigoEstadoLote
    , L.DescripcionEstadoLote

	, l.IdDiario
	, l.CodigoDiario
    , L.DescripcionDiario

	, L.IdLibro
	, L.CodigoLibro
    , L.DescripcionLibro

	, L.IdTipoLote
	, L.CodigoTipoLote
    , L.DescripcionTipoLote

    , ltc.IdTipoTransaccionDocumento
    , CodigoTipoTransaccionDocumento = ttd.Codigo
    , DescripcionTipoTransaccionDocumento = ttd.Descripcion

    , ltc.IdEntidad
    , CodigoEntidad = e.IdEntidad
    , DescripcionEntidad = e.NombreRazonSocial

    , ltc.IdCuentaBancaria
    , CodigoCuentaBancaria = cb.Codigo
    , DescripcionCuentaBancaria = cb.Descripcion

	, ltc.IdMonedaBase
    , DescripcionMonedaBase = MB.Nombre
	, CodigoMonedaBase = MB.Codigo

    , ltc.IdMonedaSistema
	, DescripcionMonedaSistema = MS.Nombre
	, CodigoMonedaSistema = MS.Codigo

    , ltc.IdMonedaTransaccion
	, DescripcionMonedaTransaccion = MT.Nombre 
	, CodigoMonedaTransaccion = MT.Codigo

    , ltc.IdTipoCambio
    , TC.Codigo CodigoTipoCambio
	, TC.Descripcion DescripcionTipoCambio

    , ltc.Numero
    , ltc.FechaConciliacion

    , ltc.ConciliadoSN
    , CodigoConciliadoSN = ltc.ConciliadoSN 
    , DescripcionConciliadoSN = case ltc.ConciliadoSN WHEN 'S' THEN 'S - SI' WHEN 'N' THEN 'N - NO' ELSE '' END

    , ltc.Descripcion

	, ltc.MultDiv
    , ltc.MultDiv CodigoMultDiv
	, iif(LTC.MultDiv='M','MULT','DIV') DescripcionMultDiv

	, ltc.ImporteCambio
    , ltc.TotalMonedaTransaccion
	, ltc.TotalMonedaBase
    , ltc.FechaTipoCambio
    , ltc.FechaContable
    
FROM Financiero.LoteTransaccionConciliacion AS ltc (NOLOCK) 
INNER JOIN Configuracion.TipoTransaccionDocumento AS ttd (NOLOCK) ON ltc.IdTipoTransaccionDocumento = ttd.Id
INNER JOIN	Financiero.ViewLote L	(NOLOCK) ON L.Id = ltc.IdLote 
INNER JOIN	Financiero.Anio VA	(nolock) ON L.IdAnio = VA.Id
LEFT JOIN Maestros.Entidad e (NOLOCK) ON ltc.IdEntidad = e.IdEntidad
LEFT JOIN Maestros.CuentaBancaria cb (NOLOCK) ON ltc.IdCuentaBancaria = cb.id

LEFT JOIN	Maestros.Moneda MB	(NOLOCK) ON MB.IdMoneda = ltc.IdMonedaBase 
LEFT JOIN	Maestros.Moneda MS	(NOLOCK) ON MS.IdMoneda = ltc.IdMonedaSistema
LEFT JOIN	Maestros.Moneda MT	(NOLOCK) ON MT.IdMoneda = ltc.IdMonedaTransaccion 

LEFT JOIN	Maestros.ViewTipoCambio TC	(nolock) ON TC.Id = ltc.IdTipoCambio




GO


CREATE VIEW Financiero.ViewLoteTransaccionConciliacionDetalle AS
SELECT
    ltcd.Id
    , ltcd.IdTransaccion
    , ltcd.Codigo
FROM Financiero.LoteTransaccionConciliacionDetalle AS ltcd

GO

INSERT INTO [Configuracion].[DiccionarioPantallaCampo](Pantalla, Campo, SP, TipoComponente, Formulario, CodigoPantalla, CodigoPantallaComponente, Section, SectionRow, SectionColumn, SectionColumnSize, SectionName, SectionOrden, [Label], Display, SPPropuesta, SPValidate)
SELECT 'FIN.TES.008' Pantalla, Campo, SP, TipoComponente, Formulario, 'FIN.TES.008' CodigoPantalla, CodigoPantallaComponente, Section, SectionRow, SectionColumn, SectionColumnSize, SectionName, SectionOrden, [Label], Display, SPPropuesta, SPValidate
FROM [Configuracion].[DiccionarioPantallaCampo] WHERE Pantalla = 'FIN.TES.004'
AND Campo LIKE 'Lote.%'

GO

INSERT INTO [Configuracion].[DiccionarioPantallaCampo](Pantalla, Campo, SP, TipoComponente, Formulario, CodigoPantalla
    , CodigoPantallaComponente, Section, SectionRow, SectionColumn, SectionColumnSize, SectionName
    , SectionOrden, [Label], Display, SPPropuesta, SPValidate)
SELECT 'FIN.TES.008' Pantalla, 'LoteTransaccionConciliacion' + SUBSTRING(Campo, CHARINDEX('.',Campo),12), SP, TipoComponente, Formulario, 'FIN.TES.008' CodigoPantalla
    , CodigoPantallaComponente, Section, SectionRow, SectionColumn, SectionColumnSize, SectionName
    , SectionOrden, [Label], Display, SPPropuesta, SPValidate
FROM [Configuracion].[DiccionarioPantallaCampo] WHERE Pantalla = 'FIN.TES.004'
AND Campo IN ('LoteTransaccionEfectivo.IdCompania'
    , 'LoteTransaccionEfectivo.IdLote'
    , 'LoteTransaccionEfectivo.Id')


GO

INSERT INTO [Configuracion].[DiccionarioPantallaCampo](Pantalla, Campo, SP, TipoComponente, Formulario, CodigoPantalla
    , CodigoPantallaComponente, Section, SectionRow, SectionColumn, SectionColumnSize, SectionName
    , SectionOrden, [Label], Display, SPPropuesta, SPValidate)
SELECT 'FIN.TES.008' Pantalla, 'LoteTransaccionConciliacion' + SUBSTRING(Campo, CHARINDEX('.', Campo), 20), SP, TipoComponente, Formulario, 'FIN.TES.008' CodigoPantalla, CodigoPantallaComponente, Section, SectionRow, SectionColumn, SectionColumnSize, SectionName, SectionOrden, [Label], Display, SPPropuesta, SPValidate
FROM [Configuracion].[DiccionarioPantallaCampo] WHERE Pantalla = 'FIN.TES.004'
AND Section = 'TipoCambio'

GO


CREATE PROCEDURE [Maestros].[usp_ObtenerDatosEntidadConciliacion]  
 @Descriptions   VarChar(Max),  
 @SearchText    VarChar(200)  
AS    
BEGIN    
 Declare @SelectComboGeneral   VarChar(Max);  
 Declare @Query      VarChar(Max);  
  
 Exec Maestros.usp_ObtenerSelectComboGeneral 'Maestros', 'V', 'ViewEntidad', 'tp', @Descriptions, @SelectComboGeneral output;  
  
 Set @Query = @SelectComboGeneral
 Set @Query = replace( @Query , 'tp.Codigo' , 'tp.IdEntidad' )
 Set @Query = replace( @Query , 'tp.Descripcion' , 'tp.NombreRazonSocial' )

 exec (@Query)
END


GO



CREATE procedure [Configuracion].[usp_ObtenerDatosTipoTransaccionDocumentoConciliacion]  
  	@Descriptions			VarChar(Max),  
	@SearchText				VarChar(200)
AS    
BEGIN    
    Declare @Select    VarChar(Max);  
    Declare @Query    VarChar(Max);  
  
    declare @IdTipoTransaccionDocumento int = 0  
    declare @TipoMovimiento varchar(1) = 'E'  
  

    Exec Maestros.usp_ObtenerSelectComboGeneral 'Configuracion', 'V', 'TipoTransaccionDocumento', 'TC', @Descriptions, @Select OutPut;    
    Set @Query = @Select  
        + ' inner join Configuracion.Modulo M '    
        + ' on TC.IdModulo = M.Id '  
        + ' WHERE M.Codigo = ''EFE'' '  
        + iif( isnull(@IdTipoTransaccionDocumento,0) = 0, '' ,  ' and TC.Codigo like ''' + @TipoMovimiento + '%'' ' )  
    Exec (@Query)
  
END 



GO


CREATE PROCEDURE [Maestros].[usp_ObtenerDatosCuentaBancariaConciliacion]  
    @Descriptions  VarChar(Max),  
    -- @IdEntidad  VarChar(25),  
    @IdMonedaTransaccion VarChar(3),  
    @SearchText    VarChar(200)  
AS    
BEGIN    
    Declare @Select  VarChar(Max);    
    Declare @Query   VarChar(Max);    
    Exec Maestros.usp_ObtenerSelectComboGeneral 'Maestros', 'V', 'ViewCuentaBancaria', 'VCB', @Descriptions, @Select OutPut;    
        -- Set @Query = @Select +  'Where VCB.IdEntidad = ''' + rtrim(Convert(VarChar(12), @IdEntidad)) + '''';    
        Set @Query = @Select  +  '  WHERE VCB.IdMonedaBancaria = ''' + @IdMonedaTransaccion + '''';    
    -- PRINT (@Query)    
    Exec (@Query)    
END

go

create procedure [Financiero].[ObtenerDatosViewLoteTransaccionConciliacionById]
    @id int
as
begin
    select * from Financiero.ViewLoteTransaccionConciliacion with(nolock) where id = @id
end



go



create procedure [Financiero].[ObtenerDatosViewLoteTransaccionConciliacionDetalleById]
    @id int
as
begin
    select * from Financiero.ViewLoteTransaccionConciliacionDetalle with(nolock) where IdTransaccion = @id
end


GO


CREATE PROCEDURE [Configuracion].[usp_ObtenerDatosMultDivConciliacion]
	@Descriptions   VarChar(Max),
	@SearchText				VarChar(200)AS  
BEGIN  
		exec [Configuracion].[usp_ObtenerDatosMultDivContable] @Descriptions,@SearchText
END 


GO


CREATE PROCEDURE [Maestros].[usp_ObtenerDatosMonedaTransaccionConciliacion]
 @Descriptions   VarChar(Max),    
 @SearchText    VarChar(200)    
AS      
BEGIN      

 Declare @SelectComboGeneral  VarChar(Max);      
 Declare @Query     VarChar(Max);      
      
 Exec Maestros.usp_ObtenerSelectComboGeneral 'Maestros', 'V', 'ViewMoneda', 'M', @Descriptions, @SelectComboGeneral OutPut;      
      
 Set @Query = @SelectComboGeneral     
 + ' WHERE M.Estado = ''A'' '

 Exec (@Query)      
    
END



GO




CREATE PROCEDURE [Maestros].[usp_ObtenerDatosTipoCambioConciliacion]  
 @Descriptions   VarChar(Max),  
 @SearchText    VarChar(200)  
AS    
BEGIN    

 Declare @SelectComboGeneral  VarChar(Max);    
 Declare @Query     VarChar(Max);    
    
 Exec Maestros.usp_ObtenerSelectComboGeneral 'Maestros', 'T', 'TipoCambio', 'TC', @Descriptions, @SelectComboGeneral OutPut;    
    
 Set @Query = @SelectComboGeneral;  
  
 Exec (@Query)    
  
END   


GO


CREATE PROCEDURE [Maestros].[usp_ObtenerDatosEntidadCompaniaConciliacion]
	@Descriptions			VarChar(Max),  
	@SearchText				VarChar(200)
AS    
BEGIN    

	exec [Maestros].[usp_ObtenerDatosEntidadCompaniaContable] @Descriptions, @SearchText

END 



GO


CREATE PROCEDURE [Financiero].[usp_GetPropuesta_FechaContableConciliacion]   
 @IdCompania    Int    
AS    
BEGIN    

 Declare @Value  Date = GetDate()  
 Declare @Visible Int = 1  
 Declare @Enable  Int = 1  
  
 Select @Value Value, @Visible Visible, @Enable Enable  
  
END


GO



CREATE PROCEDURE [Financiero].[usp_GetPropuesta_FechaTipoCambioConciliacion]   
 @IdCompania    Int    
 ,@FechaContable datetime
AS    
BEGIN    
 Declare @Value  Date = @FechaContable
 Declare @Visible Int = 1  
 Declare @Enable  Int = 1  
  
 Select isnull(@FechaContable,@Value) Value, @Visible Visible, @Enable Enable  
  
END 





GO





CREATE PROCEDURE [Maestros].[usp_GetPropuestaMonedaTransaccionConciliacion]
	@IdCompania    Int  
	,@IdMonedaTransaccionDetalle varchar(3)
AS  
BEGIN  

		if isnull(@IdMonedaTransaccionDetalle,'') = ''
		begin
				select	EC.idmonedabase Value
						--, VM.DescripcionControl Label
						, VM.Codigo Label
						, VM.Descripcion Descripcion
						, 1 Enable
						, 1 Visible  
				from	maestros.EntidadCompania EC
						Inner Join Maestros.ViewMoneda VM
						On EC.IdMonedaBase = VM.IdMoneda
				where	EC.id = @IdCompania  
		end
		else
		begin
				select	VM.idMoneda Value
						, VM.Codigo Label
						, VM.Descripcion Descripcion
						, 1 Enable
						, 1 Visible  
				from	Maestros.ViewMoneda VM
				where	VM.idMoneda = @IdMonedaTransaccionDetalle  
		end
END  





GO





CREATE   PROCEDURE [Financiero].[usp_GetPropuestaValidacion_TipoCambioConciliacion]  
 @IdTipoCambio VarChar(24)  
AS    
BEGIN  
    Declare @IdTipoCambioInternal   Int;  
  
    Set @IdTipoCambioInternal = Convert(Int, Replace(IsNull(@IdTipoCambio, 0), 'null', 0));  
   
    IF(@IdTipoCambioInternal = 0)  
  
    Select 'El Tipo de Cambio es requerido' Message  
  
    ElSE  
  
    Select ''  
    
END    
  


GO



CREATE PROCEDURE [Financiero].[usp_GetPropuestaValidacionFactorConciliacion]
	@MultDiv		VarChar(1)
AS  
BEGIN
	exec [Financiero].[usp_GetPropuestaValidacionFactorContable] @MultDiv
END


GO



CREATE   PROCEDURE [Financiero].[usp_GetPropuestaValidacion_ImporteCambioConciliacion]  
    @ImporteCambio VarChar(24)  
AS    
BEGIN  
    Declare @ImporteCambioInternal   Float;  
    Set @ImporteCambioInternal = Convert(Float, Replace(IsNull(@ImporteCambio, 0), 'null', 0));

    IF(@ImporteCambioInternal = 0)  
        Select 'El Importe de Cambio es requerido' Message  
    ElSE  
        Select ''  
END    
  


GO




CREATE PROCEDURE [Financiero].[usp_GetPropuestaValidacion_FechaContableConciliacion]    
    @FechaContable VarChar(20)    
AS
BEGIN    
    if isnull(@FechaContable,'')=''
        Select 'Fecha Contable es requerida'  Message   
    else
        select ''
END 




GO




CREATE procedure [Financiero].[usp_GetPropuesta_TipoTransaccionDocumento_TransaccionConciliacion]
    @IdCompania    Int    
    --,@IdAnioTipoAsiento Int  
AS
BEGIN
    Declare @Value		Int = 30
    Declare @Visible	Int = 1
    Declare @Enable		Int = 1
    Declare @Label nvarchar(max)
    Declare @Descripcion nvarchar(max)

    Select	
		    @Value Value
	    ,	@Visible Visible
	    ,	@Enable Enable
	    ,	Trim(Codigo) Label
	    ,	Trim(Descripcion) Descripcion
    From 
		    Configuracion.ViewTipoTransaccionDocumento Where Id = @Value
END



GO



CREATE PROCEDURE [Financiero].[usp_ObtenerDatosConciliadoSNConciliacion]    
 @Descriptions   VarChar(Max),    
 @SearchText    VarChar(200)
AS      
    BEGIN      
    
  Select 1 Id    
    , 'S' Valor    
    , 'S - SI' Description    
    , 'S' Code           
    , '' DatoDescriptionExtra    
    , '/' Url    
    , 0 IdUrl    
    , 0 Recent    
    , 1 view1    
    , 1 view2    
    , 0 view3    
    , 'N' FontBold     
  union all    
  Select 2 Id    
    , 'N' Valor    
    , 'N - NO' Description    
    , 'N' Code           
    , '' DatoDescriptionExtra    
    , '/' Url    
    , 0 IdUrl    
    , 0 Recent    
    , 1 view1    
    , 1 view2    
    , 0 view3    
    , 'N' FontBold     
    
    
END 
```