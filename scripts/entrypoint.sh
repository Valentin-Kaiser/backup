#!/bin/sh -x

# Initialize the repository if it doesn't exist
restic -r $RESTIC_REPOSITORY cat config 2>/dev/null || restic -r $RESTIC_REPOSITORY init && /backup.sh

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

# Start the cron daemon
crond -f -d 8