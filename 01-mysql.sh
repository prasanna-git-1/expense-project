#!/bin/bash

timestamp=$(date +%F-%H-%M-%S)
scriptname=$( echo $0 | cut -d "." -f1)
logfile=/tmp/$scriptname-timestamp.log 

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

echo "please enter db password:"
read -s mysql-root-password

validate(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$2 .. $R failure $N" 
        exit 1 
    else 
         echo -e "$2 ..$G success $N" 
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
validate $? "enabling mysqld...."

systemctl start mysqld
validate $? "starting mysqld...."

mysql_secure_installation --set-root-pass ${mysql-root-password} &>>$logfile
validate $? "password setup "
