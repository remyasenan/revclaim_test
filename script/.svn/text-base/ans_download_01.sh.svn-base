#!/bin/sh
HOST='ftp.anslink.net'
USER='revftp@ssl'
PASSWD='4zkh8f5a'

dest='/home/revlogic/revsync/back_zip/'
remotedir='/users/revftp/Outbound/VEST/Claims/'
localdir='/home/surabil/ANS_FTP'


echo "Connecting";
ftp-ssl -pi $HOST <<END_SCRIPT

binary
cd "$remotedir"
lcd "$localdir"

!echo "Downloading"

mget *.zip

!echo "Quitting";
quit
END_SCRIPT


exit 0

