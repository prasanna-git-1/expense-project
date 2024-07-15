#!/bin/bash

timestamp=$(date +%F-%H-%M-%S)
scriptname=$( echo $0 | cut -d "." -f1)
logfile=/tmp/$scriptname-timestamp.log 

validate(){
    if [ $1 -ne 0 ]
    then 
        echo "$2 is failure" 
        exit 1 
    else 
         echo "$2 is success" 
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

dnf install mysql-server -y &>>$logfile
validate $? "installing mysql-server"


systemctl enable mysqld

systemctl start mysqld

mysql_secure_installation --set-root-pass ExpenseApp@1
validate $? "password setup is "
