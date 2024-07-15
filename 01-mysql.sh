#!/bin/bash

timestamp=$(date +%F-%H-%M-%S)
scriptname=$( echo $0 | cut -d "." -f1)
logfile=/tmp/$scriptname-timestamp.log 

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

# echo "please enter db password:"
# read -s mysql_root_password

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

dnf install mysql-server -y 
validate $? "installing mysql-server"


systemctl enable mysqld
validate $? "enabling mysqld...."

systemctl start mysqld
validate $? "starting mysqld...."

# mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$logfile
# validate $? "password setup "

mysql -h 3.95.180.191 -uroot ExpenseApp@1 -e "show databases"; &>>$logfile
if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root--pass ExpenseApp@1 &>>$logfile
    validate $? "mysql root password setup"
else 
     echo -e "mysql root password is setup already... $Y skipping.. $N"
fi



