utilisateur inactif AD : 

 


# Charger le module Active Directory
Import-Module ActiveDirectory

# Définir la période d'inactivité (6 mois)
$thresholdDate = (Get-Date).AddMonths(-6)

# Récupérer tous les utilisateurs qui ne se sont pas connectés depuis plus de 6 mois
$inactiveUsers = Get-ADUser -Filter {LastLogonDate -lt $thresholdDate -and Enabled -eq $true} -Properties LastLogonDate | 
                 Select-Object Name, SamAccountName, LastLogonDate

# Afficher les utilisateurs inactifs
if ($inactiveUsers) {
    Write-Host "Utilisateurs inactifs depuis plus de 6 mois :" -ForegroundColor Yellow
    $inactiveUsers | Format-Table -AutoSize
} else {
    Write-Host "Aucun utilisateur inactif trouvé." -ForegroundColor Green
}

# Exporter les résultats dans un fichier CSV (optionnel)
$inactiveUsers | Export-Csv -Path "C:\Users\npersonnaz\Desktop\InactiveUsers.csv" -NoTypeInformation -Encoding UTF8
Write-Host "Les résultats ont été exportés vers C:\Users\Public\InactiveUsers.csv" -ForegroundColor Cyan


PC Inactif :

# Charger le module Active Directory
Import-Module ActiveDirectory

# Définir la période d'inactivité (6 mois)
$thresholdDate = (Get-Date).AddMonths(-6)
$thresholdFileTime = $thresholdDate.ToFileTimeUtc()

# Récupérer tous les ordinateurs qui ne se sont pas connectés depuis plus de 6 mois
$inactiveComputers = Get-ADComputer -Filter {LastLogonTimestamp -lt $thresholdFileTime -and Enabled -eq $true} -Properties LastLogonTimestamp |
                     Select-Object Name, DNSHostName, @{n="LastLogonDate";e={[DateTime]::FromFileTimeUtc($_.LastLogonTimestamp)}}

# Afficher les ordinateurs inactifs
if ($inactiveComputers) {
    Write-Host "Ordinateurs inactifs depuis plus de 6 mois :" -ForegroundColor Yellow
    $inactiveComputers | Format-Table -AutoSize
} else {
    Write-Host "Aucun ordinateur inactif trouvé." -ForegroundColor Green
}

# Exporter les résultats dans un fichier CSV (optionnel)
if ($inactiveComputers) {
    $inactiveComputers | Export-Csv -Path "C:\Users\npersonnaz\Desktop\InactiveComputers.csv" -NoTypeInformation -Encoding UTF8
    Write-Host "Les résultats ont été exportés vers C:\Users\npersonnaz\Desktop\InactiveComputers.csv" -ForegroundColor Cyan












SCRIPT POUR MICROSOFT 365 : 




Pour que le script fonctionne correctement, il est nécessaire d'installer les modules suivants :

Install-Module Microsoft.Graph -Force -AllowClobber
Install-Module AzureAD -Force -AllowClobber
Une fois les modules installés, vous devrez les importer dans le script en utilisant la commande appropriée.

Import-Module Microsoft.Graph
Import-Module AzureAD




script : 




# Connexion à Microsoft Graph
Connect-MgGraph -Scopes "AuditLog.Read.All", "Directory.Read.All"

# Définir la période d'inactivité (30 jours)
$last30DaysDate = (Get-Date).AddDays(-30)

# Récupérer tous les utilisateurs
Write-Host "Récupération des utilisateurs..." -ForegroundColor Cyan
$users = Get-MgUser -All | Where-Object { $_.UserPrincipalName -like '*@*' }

# Vérification des connexions
Write-Host "Récupération des informations de connexion pour tous les utilisateurs..." -ForegroundColor Cyan
$inactiveUsers = @()

if ($users) {
    foreach ($user in $users) {
        try {
            # Vérifier si l'utilisateur a une licence
            $userLicenses = Get-MgUserLicenseDetail -UserId $user.Id
            if ($userLicenses.Count -gt 0) {
                # Vérifier si une connexion récente existe pour cet utilisateur
                $recentSignIn = Get-MgAuditLogSignIn -Filter "userPrincipalName eq '$($user.UserPrincipalName)' and createdDateTime ge $($last30DaysDate.ToString('yyyy-MM-ddTHH:mm:ssZ'))" -Top 1

                if (-not $recentSignIn) {
                    # Ajouter l'utilisateur à la liste des inactifs
                    $inactiveUser = [PSCustomObject]@{
                        DisplayName      = $user.DisplayName
                        UserPrincipalName = $user.UserPrincipalName
                        Licenses         = $userLicenses.SkuPartNumber -join ", "
                    }
                    $inactiveUsers += $inactiveUser

                    # Afficher en temps réel
                    Write-Host "Utilisateur inactif détecté : $($user.DisplayName) ($($user.UserPrincipalName))" -ForegroundColor Yellow
                }
            }
        } catch {
            Write-Host "Erreur pour $($user.UserPrincipalName) : $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    # Exporter la liste finale des inactifs
    if ($inactiveUsers.Count -gt 0) {
        $inactiveUsers | Export-Csv -Path "C:\Users\Public\InactiveM365Users.csv" -NoTypeInformation -Encoding UTF8
        Write-Host "Les utilisateurs inactifs ont été exportés vers C:\Users\Public\InactiveM365Users.csv" -ForegroundColor Green
    } else {
        Write-Host "Aucun utilisateur inactif trouvé." -ForegroundColor Yellow
    }
} else {
    Write-Host "Aucun utilisateur trouvé dans Microsoft 365." -ForegroundColor Red
}