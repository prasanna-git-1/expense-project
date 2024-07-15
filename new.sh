curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip
validate $? "downloading files"

cd /app

unzip /tmp/backend.zip
validate $? "unziping the downladed files"

cd /app

npm install -y 
validate $? "downloading dependices"

