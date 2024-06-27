-- ==========================================================================================
-- ACTUALIZA DATA ENTIDAD POR DNI
-- ==========================================================================================
UPDATE en SET en.NombreRazonSocial = cc.ADESANE
-- SELECT en.IdEntidad, en.NombreRazonSocial, cc.ADESANE
FROM Maestros.Entidad en
INNER JOIN produccion.rsconcar.dbo.ct0032anex cc ON
    rtrim(en.IdEntidad) = rtrim(cc.ACODANE) collate SQL_Latin1_General_CP1_CI_AS
 where cc.AVANEXO = 'T'                    
    and len(rtrim(cc.ACODANE)) = 8                    
    and isnumeric(cc.ACODANE) = 1
    AND LEN(trim(en.NombreRazonSocial)) = 0
    AND LEN(trim(cc.ADESANE)) != 0;