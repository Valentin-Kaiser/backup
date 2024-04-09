#!/bin/sh -x

restic forget $RESTIC_FORGET_ARGS | tee -a /var/log/forget.log 2>&1