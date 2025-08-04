#!/bin/bash
# -----------------------------------------------------------------------------
# Script de sauvegarde automatique NIGHTLY de la base de données mspr3bdd (.sql)
# Version sécurisée ++
# Ce script est exécuté par l'utilisateur backupuser via une crontab quotidienne.
# Il applique des mesures de sécurité avancées, assure la rotation des sauvegardes
# et enregistre toutes les opérations dans un fichier log pour traçabilité.
# -----------------------------------------------------------------------------

# [Sécurité] Arrêt immédiat du script en cas d’erreur non gérée (ex: commande échouée)
set -e

# [Sécurité] Définit les permissions par défaut sur les fichiers créés :
# umask 0077 garantit que seuls l’utilisateur (ici backupuser) pourra lire ou écrire
umask 0077

# Répertoire cible contenant les sauvegardes horodatées (sur NAS monté via NFS)
DEST_DIR="/mnt/nas_backup/sql_nightly"

# Génère un nom de fichier basé sur la date et l’heure de l’exécution
DATE=$(date "+%F_%Hh%M")
FILENAME="backup-mspr3bdd-${DATE}.sql"
FULLPATH="${DEST_DIR}/${FILENAME}"

# Fichier de log dédié à cette tâche de sauvegarde
LOGFILE="/home/backupuser/backup_mspr3bdd.log"

# Log : début de la sauvegarde
echo "$(date) | DÉBUT sauvegarde NIGHTLY mysqldump" >> "$LOGFILE"

# [Sécurité] Vérifie que le répertoire de destination existe bien.
if [[ ! -d "$DEST_DIR" ]]; then
    echo "$(date) | ERREUR : Répertoire $DEST_DIR introuvable." >> "$LOGFILE"
    exit 1
fi

# Exécution de la commande mysqldump
# Le fichier .my.cnf permet de stocker les identifiants MySQL de manière sécurisée
mysqldump --defaults-file=/home/backupuser/.my.cnf --single-transaction mspr3bdd > "$FULLPATH" 2>> "$LOGFILE"

# [Validation] Vérifie que le fichier est bien présent et non vide
if [[ -s "$FULLPATH" ]]; then
    echo "$(date) | Sauvegarde NIGHTLY OK : $FULLPATH" >> "$LOGFILE"
else
    echo "$(date) | ERREUR NIGHTLY - Fichier vide : $FULLPATH" >> "$LOGFILE"
    rm -f "$FULLPATH"
    exit 1
fi

# [Maintenance] Rotation des sauvegardes
# On conserve uniquement les 30 fichiers les plus récents
ls -lt "$DEST_DIR"/backup-mspr3bdd-*.sql | tail -n +31 | xargs -r rm -f

# Log : fin de la sauvegarde
echo "$(date) | FIN sauvegarde NIGHTLY mysqldump" >> "$LOGFILE"
