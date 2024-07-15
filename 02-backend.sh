#!/bin/bash 

userid=$(id -u)
timestamp=$(date +%F-%H-%M-%S)
scriptname=$(echo $0 | cut -d "." -f1 )
logfile=/tmp/$scriptname-$timestamp.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

echo "please enter db password:"
read -s mysql_root_password

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

dnf module disable nodejs -y &>>$logfile
validate $? "disabling default nodejs" 

dnf module enable nodejs:20 -y &>>$logfile
validate $? "enabling nodejs.20 version "

dnf install nodejs -y &>>$logfile
validate $? "installing nodejs"

id expense  &>>$logfile
if [ $? -ne 0 ]
then 
    useradd expense 
    validate $? "creating expense user"
else 
     echo -e "user already created ....  $Y skipping $N"    
fi     

mkdir -p /app
validate $? "crating app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip 
validate $? "downloading backend code"

cd /app
rm -rf /app/*
unzip /tmp/backend.zip 
validate $? "unziping the backend code"

npm install -y
validate $? "downloading nodejs dependices"

cp /tmp/expense-project/backend.service /etc/systemd/system/backend.service
validate $? "copied backend service"

systemctl daemon-reload
validate $? "deamon reload"

systemctl start backend
validate $? "starting backend service"

systemctl enable backend
validate $? "enabling backend service"

dnf install mysql -y &>>$logfile
validate $? "installing mysql"

mysql -h 107.23.240.34 -uroot -p${mysql_root_password} < /app/schema/backend.sql
validate $? "schema reloading"


systemctl restart backend
validate $? "restating backend server"

















