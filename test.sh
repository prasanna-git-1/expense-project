#!/bin/bash

logfile=/tmp/log.log

check(){
 if [ $1 -ne 0 ]
 then 
	echo "$2 is failure" 
	exit 1
else
         echo "$2 is success"
 fi	 
}
 ls -ltr &>$logfile
 check $? "listing the files"

 file=$(cat $logfile)
 echo "$file"
