#!/bin/sh -x

SNAPSHOT_TAG=$(date +"%Y.%m.%d_%H:%M:%S")

restic backup --tag "$SNAPSHOT_TAG" $RESTIC_BACKUP_ARGS "$RESTIC_SOURCE" | tee -a /var/log/backup.log 2>&1