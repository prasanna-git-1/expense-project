#!/bin/bash

timestamp=$(date +%F-%H-%M-%S)
script-name=$( echo $0 | cut -d "." -f1)
logfile=/tmp/$script-name-timestamp.log 
userid=$(id -u)
if [ $userid -ne 0 ]
then 
    echo "run with a root user"
    exit 1
else 
    echo "you are a root user"
fi

validate(){
    if [ $1 -ne 0 ]
    then 
        echo "$2 is failure" &>>$logfile
        exit 1 
    else 
         echo "$2 is success" &>>$logfile
    fi      
}         

dnf -y install mysql &>>$logfile
validate $? "installing mysql"
