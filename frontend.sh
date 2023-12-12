yum install nginx -yum

systemctl enable nginx
systemctl start nginx

curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"