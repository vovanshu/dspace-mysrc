#!/bin/bash

DEST='/home/backup/dspace/'
BACKUPFILE=$DEST'bin40-'$(date +%Y-%m-%d-%H-%M-%S)
WORK='/home/dspace/bin40'
DBD='/home/dspace/db/dspace40.sql'
DBA=$DEST'bin40-db-'$(date +%Y-%m-%d-%H-%M-%S).tar.gz

tar -cvzp $DBD -f $DBA
tar --exclude="$WORK/assetstore" --exclude="$WORK/log" -cvzp $WORK -f $BACKUPFILE.tar.gz
tar -cvzp "$WORK/assetstore" -f $BACKUPFILE.assetstore.tar.gz
tar -cvzp "$WORK/log" -f $BACKUPFILE.log.tar.gz

exit 0