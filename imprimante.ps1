# Chemin de sortie pour le fichier CSV
$csvPath = "C:\printers.csv"

# Récupère les imprimantes installées sur le serveur
$imprimantes = Get-Printer | Select-Object Name, PortName, DriverName

# Crée une nouvelle liste compatible avec le script d'installation
$imprimantesCompatibles = $imprimantes | ForEach-Object {
    [PSCustomObject]@{
        Nom    = $_.Name
        Port   = $_.PortName
        Driver = $_.DriverName
    }
}

# Exporte les données dans un fichier CSV
$imprimantesCompatibles | Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8

Write-Output "Les imprimantes ont été exportées vers le fichier $csvPath"