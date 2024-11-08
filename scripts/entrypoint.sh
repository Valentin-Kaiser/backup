#!/bin/sh

# If in mount mode, we fail if the lock file doesn't in the restic repository location
if [ "$RESTIC_TEST_MOUNT" = "true" ]; then
	if [ ! -f "$RESTIC_REPOSITORY/.mounted" ]; then
		echo "Lock file not found in $RESTIC_REPOSITORY"
		exit 1
	fi
fi

# Initialize the repository if it doesn't exist
restic -r $RESTIC_REPOSITORY cat config 2>/dev/null || (restic -r $RESTIC_REPOSITORY init && /backup.sh)

# Add the backup job to the crontab if it doesn't exist
crontab -l | grep -q "backup.sh" || (
	crontab -l
	echo "$BACKUP_SCHEDULE /backup.sh"
) | crontab -

# Add the forget job to the crontab if it doesn't exist
crontab -l | grep -q "forget.sh" || (
	crontab -l
	echo "$FORGET_SCHEDULE /forget.sh"
) | crontab -

# Start the cron daemon without logging
crond -L /dev/stdout

# Tail the log file
tail -f /var/log/backup.log