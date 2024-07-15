#!/bin/bash

userid=$(id -u)
timestamp=$(date +%F-%H-%M-%S)
scriptname=$(echo $0 | cut -d "." -f1 )
logfile=/tmp/$scriptname-$timestamp.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

# echo "please enter db password:"
# read -s mysql_root_password

validate(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$2 ...$R failure $N"
        exit 1
    else 
         echo -e "$2... $G success $N" 
    fi        
}

if [ $userid -ne 0 ]
then 
   echo "please run as a super user"
   exit 1
else 
    echo "you are a super user"
fi 


dnf install nginx -y 
validate $? "installing nginx"

systemctl enable nginx
validate $? "enabling nginx"

systemctl start nginx
validate $? "starting nginx"

rm -rf /usr/share/nginx/html/*

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip
validate $? "downloading frontend code"

cd /usr/share/nginx/html

unzip /tmp/frontend.zip

cp /tmp/expense-project/frontend.service /etc/nginx/default.d/expense.conf
validate $? "copied frontend code"

systemctl restart nginx
validate $? "restating nginx"
