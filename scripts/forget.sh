#!/bin/sh -x

DATE=$(date +"%Y.%m.%d %H:%M:%S")
echo "$DATE: => Starting forget" | tee -a /var/log/forget.log
restic forget $RESTIC_FORGET_ARGS | tee -a /var/log/forget.log 2>&1