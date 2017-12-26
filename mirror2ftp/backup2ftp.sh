#!/bin/bash

HOST="10.25.11.20"
USER="motiv"
PASS="privet123$"
FTPURL="ftp://$USER:$PASS@$HOST"
LCD="/var/Motiw/backup"
RCD="/motiv"
#DELETE="--delete"
lftp -c "set ftp:list-options -a; set ssl:verify-certificate false;
open '$FTPURL';
lcd $LCD;
cd $RCD;
mirror --reverse \
       $DELETE \
       --verbose \
"

#       --exclude-glob a-dir-to-exclude/ \
#       --exclude-glob a-file-to-exclude \
#       --exclude-glob a-file-group-to-exclude* \
#       --exclude-glob other-files-to-exclude"
