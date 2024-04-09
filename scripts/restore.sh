#!/bin/sh

DATE=$(date +"%Y.%m.%d %H:%M:%S")
echo "$DATE: => Starting restore" | tee -a /var/log/restore.log

# Prompt the user to select a snapshot
restic snapshots --repo $RESTIC_REPOSITORY

# Prompt the user to select a snapshot
printf " \nEnter the ID of the snapshot you want to restore (default: latest):  \n"
read SNAPSHOT_ID

if [ -z "$SNAPSHOT_ID" ]; then
    SNAPSHOT_ID="latest"
fi

# Prompt the user to select a target directory
printf " \nEnter the target directory where you want to restore the files:  \n"
read TARGET_DIR

# Check if the target directory exists
if [ ! -d "$TARGET_DIR" ]; then
    printf " \nThe target directory does not exist! Do you want to create it? (y/n):  \n"
    read CREATE_DIR
    if [ "$CREATE_DIR" = "y" ]; then
        mkdir -p $TARGET_DIR
    else
        printf "The target directory does not exist! Exiting... \n"
        exit 1
    fi
fi


# Perform the restore
restic restore $SNAPSHOT_ID --target $TARGET_DIR | tee -a /var/log/restore.log 2>&1

printf "Restore process completed! \n"