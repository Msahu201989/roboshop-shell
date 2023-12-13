echo ">>>>>>>> Create catalogue Service FIle <<<<<<<<<<<<<<<"
cp catalogue.service /etc/systemd/system/catalogue.service

echo ">>>>>>>> Create MongoDB Repo <<<<<<<<<<<<<<<"
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo ">>>>>>>> Download & Install Node Js Repo <<<<<<<<<<<<<<<"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo ">>>>>>>> Install Node JS  <<<<<<<<<<<<<<<"
yum install nodejs -y

echo ">>>>>>>> Create Application User <<<<<<<<<<<<<<<"
useradd roboshop

echo ">>>>>>>> Create Application Directory <<<<<<<<<<<<<<<"
mkdir /app


echo ">>>>>>>> Download Application Content <<<<<<<<<<<<<<<"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip


echo ">>>>>>>> Extract Application Content<<<<<<<<<<<<<<<"
cd /app
unzip /tmp/catalogue.zip
cd /app

echo ">>>>>>>> Download NodeJS Dependencies <<<<<<<<<<<<<<<"
npm install

echo ">>>>>>>> Install Mongo Client <<<<<<<<<<<<<<<"
yum install mongodb-org-shell -y

echo ">>>>>>>> Load catalogue Schema <<<<<<<<<<<<<<<"
mongo --host mongodb.msahu.online </app/schema/catalogue.js


echo ">>>>>>>> Start catalogue Service <<<<<<<<<<<<<<<"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue