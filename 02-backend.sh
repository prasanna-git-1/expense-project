#!/bin/bash 

userid=$(id -u)
timestamp=$(date +%F-%H-%M-%S)
scriptname=$(echo $0 | cut -d "." -f1 )
logfile=/tmp/$scriptname-$timestamp.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


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

mkdir /app
validate $? "crating app directory"























