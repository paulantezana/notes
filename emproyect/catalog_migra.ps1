$targetServer = "http://192.168.33.202/reports/api/v2.0/catalogitems"
$sourceServer = "http://192.168.33.206/reports/api/v2.0/catalogitems"
$targetFolder = "/BackOffice/Contabilidad"
$tempFolder = "C:\Temp\SSRS"

# Crear carpeta temporal si no existe
if (!(Test-Path $tempFolder)) {
    New-Item -ItemType Directory -Path $tempFolder | Out-Null
}

# Credenciales para los servidores
$sourceCred = Get-Credential -Message "Ingrese credenciales para el servidor de origen"
# $targetCred = Get-Credential -Message "Ingrese credenciales para el servidor de destino"

# Configurar sesiones
$sourceSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$sourceSession.Credentials = $sourceCred
# $targetSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
# $targetSession.Credentials = $targetCred

# Obtener ID de la carpeta
$folderUri = "$sourceServer(Path=%27$targetFolder%27)"
$folderResponse = Invoke-RestMethod -Uri $folderUri -Method Get -WebSession $sourceSession
$folderId = $folderResponse.Id

# Obtener lista de reportes en la carpeta
$reportsUri = "$sourceServer($folderId)/Model.Folder/catalogitems/?$orderby=name%20ASC"
$reportsResponse = Invoke-RestMethod -Uri $reportsUri -Method Get -WebSession $sourceSession

foreach ($report in $reportsResponse.value) {
    $reportId = $report.Id
    $reportName = $report.Name
    $downloadUri = "$sourceServer($reportId)/Content/$" + "value"
    $outputFile = "$tempFolder\$reportName.rdl"


    if ($reportName -eq "CTB001") {

        # ===========================================================================================
        # D E S C A R G A
        # ===========================================================================================
        Write-Output "Descargando: $reportName"
        Invoke-WebRequest -Uri $downloadUri -OutFile $outputFile -WebSession $sourceSession


        # ===========================================================================================
        # S U B I R
        # ===========================================================================================

        # Leer contenido del archivo descargado
        $rdlContent = [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($outputFile))
        $body = @{
            "@odata.type" = "#Model.Report"
            "Content" = $rdlContent
            "ContentType" = "application/rdl"
            "Name" = $reportName
            "Path" = "$targetFolder/$reportName"
        } | ConvertTo-Json -Depth 10


        # Guardar en un archivo JSON
        $body | Out-File -FilePath "C:\Temp\archivo.json" -Encoding utf8

        try {
            # Intentar subir el archivo
            $response = Invoke-RestMethod -Uri $targetServer -Method Post -Body $body -ContentType "application/json" -WebSession $sourceSession
            Write-Output "Reporte subido exitosamente: $($response.Id)"
        } catch {
            if ($_.Exception.Response.StatusCode -eq 409) {
                Write-Output "Conflicto detectado. Obteniendo el ID del reporte existente..."
                
                # Obtener ID del reporte existente
                $getUri = "$targetServer(Path=%27$targetFolder/$reportName%27)"
                $existingReport = Invoke-RestMethod -Uri $getUri -Method Get -WebSession $sourceSession
                
                if ($existingReport -and $existingReport.Id) {
                    Write-Output "Reporte existente encontrado. ID: $($existingReport.Id). Actualizando..."
                    
                    # Intentar actualizar el reporte existente con su ID
                    # $updateUri = "$targetServer($($existingReport.Id))"
                    # Invoke-RestMethod -Uri $updateUri -Method Put -Body $body -ContentType "application/json" -WebSession $sourceSession
                    # Write-Output "Reporte actualizado exitosamente."
                } else {
                    Write-Output "No se pudo obtener el ID del reporte existente."
                }
            } else {
                Write-Output "Error inesperado: $_"
            }
        }
    }
}

# Eliminar archivos temporales
Remove-Item -Path "$tempFolder\*.rdl" -Force
Write-Output "Archivos temporales eliminados."
