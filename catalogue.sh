echo -e "\e[36m>>>>>>>>>>>>  Create Catalogue Service  <<<<<<<<<<<<\e[0m"
cp catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[36m>>>>>>>> Create MongoDB Repo <<<<<<<<<<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m>>>>>>>> Download & Install Node Js Repo <<<<<<<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[36m>>>>>>>> Install Node JS  <<<<<<<<<<<<<<<\e[0m"
yum install nodejs -y

echo -e "\e[36m>>>>>>>> Create Application User <<<<<<<<<<<<<<<\e[0m"
useradd roboshop

echo -e "\e[36m>>>>>>>> Create Application Directory <<<<<<<<<<<<<<<\e[0m"
mkdir /app


echo -e "\e[36m>>>>>>>> Download Application Content <<<<<<<<<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip


echo -e "\e[36m>>>>>>>> Extract Application Content<<<<<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/catalogue.zip
cd /app

echo -e "\e[36m>>>>>>>> Download NodeJS Dependencies <<<<<<<<<<<<<<<\e[0m"
npm install

echo -e "\e[36m>>>>>>>> Install Mongo Client <<<<<<<<<<<<<<<\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[36m>>>>>>>> Load catalogue Schema <<<<<<<<<<<<<<<\e[0m"
mongo --host mongodb.msahu.online </app/schema/catalogue.js


echo -e "\e[36m>>>>>>>> Start catalogue Service <<<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue