#!/bin/bash
# This script does the following steps.
#      Connects to the ANS ftp server. 
#      Download all the zip files in $remotedir.
#      Gets a list of the files on the server. This is needed for finding out the timestamp of the files.
#      Move all the zip files in $remotedir to $remotedir/Archive. To do this step a custom script is created by this script which is executed at the end.
#      Move all the zip files to the /home/revlogic/revsync/back_zip/
#      Creates a file for each of the zip with the timestamp in it.
#      Sends a message to some mail ids.
#
#      Dependencies - Needs ftp-ssl
#                     Needs the .netrc file configured with the host, username, password details.
#  
#      Created on 02-04-2008

HOST='ftp.anslink.net'
mailto=bgopinath@revenuemed.com,ssurabil@revenuemed.com,prakash.venkit@revenuemed.com
#mailto=bgopinath@revenuemed.com

################################################################
# These will need to be altered appropriately.
dest='/home/revlogic/revsync/back_zip'
remotedir='/users/revftp/Outbound/VEST/Claims'
localdir='/home/surabil/ANS_FTP'

result=/tmp/result.txt
dresult=/tmp/dresult.txt
timestamp=/tmp/time.txt

ftpscript=/tmp/ftpscript.sh

if [ -e $ftpscript ]; then
	rm $ftpscript
fi

date > $result;

###############################################################
#  Copnnect to the FTP server and download all the zip files

ftp-ssl -pi $HOST <<END_SCRIPT
binary
cd "$remotedir"
lcd "$localdir"
mget *.zip
quit
END_SCRIPT

############################################################
# Do nothing if there are no files downloaded.

cd $localdir
date >> $result;

LIST=$(ls *.zip 2>/dev/null)

if [ -z "$LIST" ]; then
	echo "No files to move" >> $result
else 

############################################################
# This section creates a temporary script for executing later. This script moves the files to the Archive folder on the FTP server.
# This also saves the timestamp of these files that are being downloaded in a temporary file.

ftpscript=/tmp/ftpscript.sh

echo "ftp-ssl -pi $HOST <<END_SCRIPT" > $ftpscript
echo "binary" >> $ftpscript
echo "cd $remotedir" >> $ftpscript
echo "ls" >> $ftpscript

for i in $LIST; do

	echo "Moving $i to $remotedir/Archive on $HOST" >> $result;
	echo "rename $i archive/$i" >> $ftpscript

done

echo "quit" >> $ftpscript
echo "END_SCRIPT" >> $ftpscript

chmod 700 $ftpscript

#############################################################
#  Execute the script created above.

. $ftpscript > $dresult

############################################################
#  Move the downloaded files to the final destination.
#  Create a file with the timestamp of the zip file.

for i in $LIST; do
	echo "Moving $i to $dest on $(hostname)" >> $result
	mv $localdir/$i $dest/$i
	cat $dresult | grep $i > $dest/$i.txt
done

fi

###########################################################
# Mail the Results

echo "===============" >> $result

if [ -e $ftpscript ]; then 
	cat $ftpscript >> $result
	echo "===============" >> $result
	cat $dresult | grep zip >> $result
fi

mail -s "$(hostname) - ANS FTP file Xfer" $mailto < $result
