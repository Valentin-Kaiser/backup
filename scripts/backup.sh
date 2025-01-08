#!/bin/sh -x

DATE=$(date +"%Y.%m.%d %H:%M:%S")
echo "$DATE: => Starting backup - $RESTIC_SOURCE" | tee -a /var/log/backup.log
restic backup $RESTIC_BACKUP_ARGS "$RESTIC_SOURCE" | tee -a /var/log/backup.log 2>&1
echo "$DATE: => Backup finished" | tee -a /var/log/backup.log