# Spécifiez le chemin du dossier contenant les fichiers .exe
$folderPath = "C:\Program Files\LogiOptionsPlus"

# Parcourir tous les fichiers .exe du dossier
Get-ChildItem -Path $folderPath -Filter *.exe | ForEach-Object {
    $exePath = $_.FullName

    # Créez le nom de la clé de registre basée sur le chemin d'accès complet du fichier .exe
    $registryKeyPath = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers\$exePath"

    # Vérifiez si la clé existe déjà, sinon créez-la
    if (-not (Test-Path $registryKeyPath)) {
        New-Item -Path $registryKeyPath -Force | Out-Null
    }

    # Ajoutez la valeur pour activer le comportement de "système amélioré"
    Set-ItemProperty -Path $registryKeyPath -Name "(default)" -Value "~ HIGHDPIAWARE"
    
    Write-Host "Compatibilité mise à jour pour: $exePath"
}

Write-Host "Mise à jour terminée."
