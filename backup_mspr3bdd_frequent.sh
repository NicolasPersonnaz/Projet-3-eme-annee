#!/bin/bash
# Code rédigé pendant les MSPR pour sauvegarder la base de données
set -e

# Répertoire de destination
DEST_DIR="/mnt/nas_backup/sql_frequent"

# Fichier de sortie
DATE=$(date +%F_%Hh%M)
FILENAME="backup-mspr3bdd-${DATE}.sql"
FULLPATH="${DEST_DIR}/${FILENAME}"

# Journalisation
LOGFILE="/home/backupuser/backup_mspr3bdd.log"
echo "$(date) | DÉBUT sauvegarde mysqldump" >> "$LOGFILE"

# Export SQL avec auth sécurisée
mysqldump --defaults-file=/home/backupuser/.my.cnf --single-transaction mspr3bdd > "$FULLPATH"

# Vérification de validité du fichier
if [[ $? -eq 0 && -s "$FULLPATH" ]]; then
    echo "$(date) Sauvegarde OK : $FULLPATH" >> "$LOGFILE"
else
    echo "$(date) ERREUR - Fichier vide ou échec : $FULLPATH" >> "$LOGFILE"
    rm -f "$FULLPATH"
fi

# Rotation : conserver uniquement les 12 dernières sauvegardes
ls -1t "$DEST_DIR"/backup-mspr3bdd-*.sql | tail -n +13 | xargs -r rm -f

echo "$(date) FIN sauvegarde mysqldump" >> "$LOGFILE"
