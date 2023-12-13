nodejs() {
  log=/tmp/roboshop.log

  echo -e "\e[36m>>>>>>>>>>>>  Create ${component} Service  <<<<<<<<<<<<\e[0m"
  cp ${component}.service /etc/systemd/system/${component}.service &>>${log}

  echo -e "\e[36m>>>>>>>> Create MongoDB Repo <<<<<<<<<<<<<<<\e[0m"
  cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}

  echo -e "\e[36m>>>>>>>> Download & Install Node Js Repo <<<<<<<<<<<<<<<\e[0m"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}

  echo -e "\e[36m>>>>>>>> Install Node JS  <<<<<<<<<<<<<<<\e[0m"
  yum install nodejs -y &>>${log}

  echo -e "\e[36m>>>>>>>> Create Application ${component} <<<<<<<<<<<<<<<\e[0m"
  useradd roboshop &>>${log}

  echo -e "\e[36m>>>>>>>> Removing old Content <<<<<<<<<<<<<<<\e[0m"
  rm -rf /app &>>${log}

  echo -e "\e[36m>>>>>>>> Create Application Directory <<<<<<<<<<<<<<<\e[0m"
  mkdir /app &>>${log}


  echo -e "\e[36m>>>>>>>> Download Application Content <<<<<<<<<<<<<<<\e[0m"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}


  echo -e "\e[36m>>>>>>>> Extract Application Content<<<<<<<<<<<<<<<\e[0m"
  cd /app &>>${log}
  unzip /tmp/${component}.zip
  cd /app &>>${log}

  echo -e "\e[36m>>>>>>>> Download NodeJS Dependencies <<<<<<<<<<<<<<<\e[0m"
  npm install &>>${log}

  echo -e "\e[36m>>>>>>>> Install Mongo Client <<<<<<<<<<<<<<<\e[0m"
  yum install mongodb-org-shell -y &>>${log}

  echo -e "\e[36m>>>>>>>> Load ${component} Schema <<<<<<<<<<<<<<<\e[0m"
  mongo --host mongodb.msahu.online </app/schema/${component}.js &>>${log}


  echo -e "\e[36m>>>>>>>> Start ${component} Service <<<<<<<<<<<<<<<\e[0m"
  systemctl daemon-reload &>>${log}
  systemctl enable ${component} &>>${log}
  systemctl restart ${component} &>>${log}
}