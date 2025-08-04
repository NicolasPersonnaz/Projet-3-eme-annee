# Script pour faire en sorte que l'écran tactile fonctionne bien en se connecectant à distance sur une tablette tactile windows 11


# Chemin de la clé de registre pour TabletTip
$keyPath = "HKCU:\Software\Microsoft\TabletTip\1.7"
# Liste des valeurs à définir dans cette clé
$values = @("EnableEmbeddedInkControl", "EdgeTargetDockedState", "EnableDesktopModeAutoInvoke")
 
# Vérifier si la clé existe, sinon elle est créée
if (!(Test-Path $keyPath)) {
    New-Item -Path $keyPath -Force | Out-Null
}
 
# Chemin de la clé ImmersiveShell
$immersiveShellKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ImmersiveShell"
 
# Vérifier si la clé ImmersiveShell existe, sinon la créer
if (!(Test-Path $immersiveShellKey)) {
    New-Item -Path $immersiveShellKey -Force | Out-Null
}
 
# Définir ou mettre à jour la valeur UseOnScreenKeyboard dans ImmersiveShell
Set-ItemProperty -Path $immersiveShellKey -Name "UseOnScreenKeyboard" -Value 1 -Type DWord -Force
Write-Output "La valeur UseOnScreenKeyboard a été définie sur 1 dans $immersiveShellKey"
 
# Définir ou mettre à jour la valeur TabletMode dans ImmersiveShell
Set-ItemProperty -Path $immersiveShellKey -Name "TabletMode" -Value 1 -Type DWord -Force
Write-Output "La valeur TabletMode a été définie sur 1 dans $immersiveShellKey"
 
# Créer ou mettre à jour chaque valeur dans TabletTip\1.7 sur 1
foreach ($value in $values) {
    Set-ItemProperty -Path $keyPath -Name $value -Value 1 -Type DWord -Force
    Write-Output "La valeur $value a été définie sur 1 dans $keyPath"
}
 

Write-Output "Configuration des valeurs de registre terminée."
