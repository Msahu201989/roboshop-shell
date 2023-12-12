cp user.service /etc/systemd/system/cart.service
cp mongo.repo /etc/yum.repos.d/mongo.repo

curl -sL https://rpm.nodesource.com/setup_its.x | bash
yum install nodejs -yum
useradd roboshop
mkdir /app
curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
cd /app
unzip /tmp/cart.zip
cd /app
npm install

yum install mongodb-org-shell -yum
mongo --host MONGODB-SERVER-IPADDRESS </app/schema/cart.js

systemctl daemon-reload
systemctl enable cart
systemctl restart cart