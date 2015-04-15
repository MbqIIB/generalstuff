#!/bin/sh
# Written by Jaypal Reddy Kalagiri on March 5 2013
# This script gets messages from the queue using MA01 Support Pac to a file
# and decrypts the file using gpg2 and then puts back into another queue using same MA01
PASSPATH=/WBIDATA/MB01/scripts
FPATH=/WBIDATA/MB01/scripts
FINAL_FPATH=/WBIDATA/MB01/scripts
PGPFILE=/home/wbiuser/scripts/pgp
DSTAMP=`date +”%d%m%Y%H%M%S”`
i=1
FName=Orders_${DSTAMP}_$$_$i.asc
INPUT_Q=TEST
OUTPUT_Q=TEST_OUTPUT
QMGR=QMBRKDEV01
$FPATH/q -m ${QMGR} -I${INPUT_Q} -L 1 -F $PGPFILE/$FName
MQCode=$?
while [ $MQCode -eq 0 ] && [ -s $PGPFILE/$FName ]; do
gpg2 –batch –passphrase-file $PASSPATH/.passf –decrypt $PGPFILE/$FName > $FINAL_FPATH/$FName.xml
if [ -f $FINAL_FPATH/$FName.xml ]; then
$FPATH/q -m ${QMGR} -O${OUTPUT_Q} -F $FINAL_FPATH/$FName.xml
fi
i=`expr $i + 1`
FName=Orders_${DSTAMP}_$$_$i.asc
$FPATH/q -m ${QMGR} -I${INPUT_Q} -L 1 -F $PGPFILE/$FName
MQCode=$?
done
rm $PGPFILE/$FName # This is to remove last blank file that it creates under $PGPFILE path