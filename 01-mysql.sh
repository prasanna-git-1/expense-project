#!/bin/bash

timestamp=$(date +%F-%H-%M-%S)
scriptname=$( echo $0 | cut -d "." -f1)
logfile=/tmp/$scriptname-timestamp.log 

validate(){
    if [ $1 -ne 0 ]
    then 
        echo "$2 is failure" &>>$logfile
        exit 1 
    else 
         echo "$2 is success" &>>$logfile
    fi      
}         


userid=$(id -u)
if [ $userid -ne 0 ]
then 
    echo "run with a root user"
    exit 1
else 
    echo "you are a root user"
fi



dnf install mysql -y &>>$logfile
validate $? "installing mysql"
