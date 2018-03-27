#!/bin/sh
LDIR="/ua13app/lifeua/ecom/scripts/OCL_quality_15/SKVYRSKVKY/OUT/"
MASK="SKVYRSKV_q15*"
echo "Start sending"
filesize=$(stat -c%s "$1")
SUBJECT="Quality 15 report for SKVYRSKVKY client"
EMAIL="denysenko@skviryanka.com.ua, Alexandra.Dranaya@raben-group.com"

if [ "$filesize" -lt "100" ]
then 
 echo "There are no shipments for today"|mailx -s "$SUBJECT" $EMAIL
else 
 echo "start sending"
 echo "Please find the report attached"|mailx -s "$SUBJECT" -a $1 $EMAIL
fi

echo "End"
