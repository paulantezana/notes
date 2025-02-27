```sql
DECLARE @FilePath NVARCHAR(500);
DECLARE @ReportXML NVARCHAR(MAX);
DECLARE @ReportName NVARCHAR(255);
DECLARE @Command NVARCHAR(2000);

-- Crear una tabla PERMANENTE en tempdb para evitar el problema con xp_cmdshell
IF OBJECT_ID('tempdb..TempExportRDL') IS NOT NULL
    DROP TABLE tempdb..TempExportRDL;

CREATE TABLE tempdb..TempExportRDL (ReportXML NVARCHAR(MAX));

-- Obtener el contenido del RDL en formato XML
SELECT 
    @ReportName = C.Name,
    @ReportXML = CONVERT(NVARCHAR(MAX), CONVERT(XML, CONVERT(VARBINARY(MAX), C.Content))) 
FROM 
    dbo.Catalog C
WHERE 
    C.Type = 2  
    AND C.Path LIKE '/BackOffice/Contabilidad/%';

-- Insertar el XML convertido en la tabla permanente
INSERT INTO tempdb..TempExportRDL (ReportXML) VALUES (@ReportXML);

-- Definir la ruta de salida
SET @FilePath = '\\192.168.33.206\backoffice-documentos-web\testrdl\' + @ReportName + '.rdl';

-- Construir el comando BCP correctamente usando la tabla en tempdb
SET @Command = 'bcp "SELECT ReportXML FROM tempdb..TempExportRDL" queryout "' + @FilePath + '" -c -C 65001 -T -S ' + @@SERVERNAME;

-- Ejecutar BCP para exportar el archivo con codificación UTF-8
EXEC xp_cmdshell @Command;

-- Limpiar la tabla permanente después de la exportación
DROP TABLE tempdb..TempExportRDL;
```

```shell
$ssrsServer = "http://192.168.33.202/reports/api/v2.0/catalogitems"
$targetFolder = "/BackOffice/Contabilidad"
$reportName = "CTB001"
$rdlFilePath = "C:\Users\pantezana\Desktop\CTB001.rdl"
$Cred = Get-Credential  # Esto pedirá usuario y contraseña


$rdlContent = [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($rdlFilePath))
$body = @{
    "@odata.type" = "#Model.Report"
    "Content" = $rdlContent
    "ContentType" = "application/rdl"
    "Name" = $reportName
    "Path" = "$targetFolder/$reportName"
} | ConvertTo-Json -Depth 10

# Configurar sesión con autenticación NTLM
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$session.Credentials = $Cred

# Realizar la petición HTTP con NTLM
$response = Invoke-RestMethod -Uri $ssrsServer -Method Post -Body $body -ContentType "application/json" -WebSession $session
Write-Output "Reporte subido exitosamente: $($response.Id)"
```



```sql
DROP TABLE IF EXISTS #RdlCatalog;
SELECT
  [ItemID], [Path], [Name], [ParentID], [Type]
  ,[Content], [Intermediate], [SnapshotDataID], [LinkSourceID], [Property]
  ,[Description], [Hidden], [CreatedByID], [CreationDate], [ModifiedByID]
  ,[ModifiedDate], [MimeType], [SnapshotLimit], [Parameter], [PolicyID]
  ,[PolicyRoot], [ExecutionFlag], [ExecutionTime], [SubType], [ComponentID]
  ,[ContentSize]
  INTO #RdlCatalog
FROM ReportServer.dbo.Catalog C
WHERE C.Type = 2 AND C.Path = '/BackOffice/Contabilidad/CTB001';

INSERT INTO produccion.ReportServer.dbo.Catalog (
  [ItemID], [Path], [Name], [ParentID], [Type]
  ,[Content], [Intermediate], [SnapshotDataID], [LinkSourceID], [Property]
  ,[Description], [Hidden], [CreatedByID], [CreationDate], [ModifiedByID]
  ,[ModifiedDate], [MimeType], [SnapshotLimit], [Parameter], [PolicyID]
  ,[PolicyRoot], [ExecutionFlag], [ExecutionTime], [SubType], [ComponentID]
  ,[ContentSize]
)

SELECT
  [ItemID], [Path], [Name], '42825EDF-365C-4D98-A64C-7F397C5255DD' /*[ParentID]*/, [Type]
  ,[Content], [Intermediate], NULL /*[SnapshotDataID]*/, NULL /*[LinkSourceID]*/, [Property]
  ,[Description], [Hidden], 'C512674A-93DD-482B-9F6C-6712A909E049' /*[CreatedByID]*/, [CreationDate], 'C512674A-93DD-482B-9F6C-6712A909E049' /*[ModifiedByID]*/
  ,[ModifiedDate], [MimeType], [SnapshotLimit], [Parameter], '24521896-C9F6-488B-8517-BA885C06F93D' /*[PolicyID]*/
  ,[PolicyRoot], [ExecutionFlag], [ExecutionTime], [SubType], NULL /*[ComponentID]*/
  ,[ContentSize]
FROM #RdlCatalog;





INSERT INTO produccion.ReportServer.dbo.DataSource (
  [DSID], [ItemID], [SubscriptionID], [Name], [Extension]
  ,[Link], [CredentialRetrieval], [Prompt], [ConnectionString], [OriginalConnectionString]
  ,[OriginalConnectStringExpressionBased], [UserName], [Password], [Flags], [Version]
)
SELECT 
  d.[DSID], d.[ItemID], d.[SubscriptionID], d.[Name], d.[Extension]
  , '7C3AC573-DADF-45DB-8C58-6A1DE0DC277E' /*d.[Link]*/, d.[CredentialRetrieval], d.[Prompt], d.[ConnectionString], d.[OriginalConnectionString]
  ,d.[OriginalConnectStringExpressionBased], d.[UserName], d.[Password], d.[Flags], d.[Version]
  , (SELECT COUNT(1) FROM produccion.ReportServer.dbo.DataSource) + 1 /*d.DSIDNum*/
FROM ReportServer.dbo.Catalog c (nolock)
INNER JOIN  ReportServer.dbo.DataSource AS d (nolock) ON c.ItemID = d.ItemID
WHERE C.Type = 2 AND C.Path = '/BackOffice/Contabilidad/CTB001';
```
