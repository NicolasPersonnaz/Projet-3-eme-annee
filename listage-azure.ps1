# Connexion
Import-Module AzureAD
Connect-AzureAD

# Vérifier et créer le dossier temp
$folder = "C:\temp"
if (!(Test-Path -Path $folder)) {
    New-Item -Path $folder -ItemType Directory
}

# Export de 10 utilisateurs pour tester
$users = Get-AzureADUser -Top 1000

$export = foreach ($u in $users) {
    [PSCustomObject]@{
        'First Name' = $u.GivenName
        'Last Name'  = $u.Surname
        'Email'      = $u.UserPrincipalName
        'Position'   = $u.JobTitle
    }
}

$export | Export-Csv -Path "$folder\utilisateur.csv" -Encoding UTF8 -NoTypeInformation

Write-Host "✅ Test terminé ! Va voir dans C:\temp\utilisateur.csv"
