log=/tmp/roboshop.log

fun_apppreq(){

    echo -e "\e[36m>>>>>>>> Create ${component} Service <<<<<<<<<<<<<<<\e[0m"
    cp ${component}.service /etc/systemd/system/${component}.service &>>${log}

    echo -e "\e[36m>>>>>>>> Create Application ${component} <<<<<<<<<<<<<<<\e[0m"
    useradd roboshop &>>${log}

    echo -e "\e[36m>>>>>>>> Cleanup Existing Application Content <<<<<<<<<<<<<<<\e[0m"
    rm -rf /app &>>${log}

    echo -e "\e[36m>>>>>>>> Create Application Directory <<<<<<<<<<<<<<<\e[0m"
    mkdir /app &>>${log}


    echo -e "\e[36m>>>>>>>> Download Application Content <<<<<<<<<<<<<<<\e[0m"
    curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}


    echo -e "\e[36m>>>>>>>> Extract Application Content<<<<<<<<<<<<<<<\e[0m"
    cd /app &>>${log}
    unzip /tmp/${component}.zip &>>${log}
    cd /app &>>${log}
}

fun_systemd(){

  echo -e "\e[36m>>>>>>>> Start ${component} Service <<<<<<<<<<<<<<<\e[0m"
  systemctl daemon-reload &>>${log}
  systemctl enable ${component} &>>${log}
  systemctl restart ${component} &>>${log}
}

fun_nodejs() {

  echo -e "\e[36m>>>>>>>> Create MongoDB Repo <<<<<<<<<<<<<<<\e[0m"
  cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}

  echo -e "\e[36m>>>>>>>> Download & Install Node Js Repo <<<<<<<<<<<<<<<\e[0m"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}

  echo -e "\e[36m>>>>>>>> Install Node JS  <<<<<<<<<<<<<<<\e[0m"
  yum install nodejs -y &>>${log}

 fun_apppreq

  echo -e "\e[36m>>>>>>>> Download NodeJS Dependencies <<<<<<<<<<<<<<<\e[0m"
  npm install &>>${log}

  echo -e "\e[36m>>>>>>>> Install Mongo Client <<<<<<<<<<<<<<<\e[0m"
  yum install mongodb-org-shell -y &>>${log}

  echo -e "\e[36m>>>>>>>> Load ${component} Schema <<<<<<<<<<<<<<<\e[0m"
  mongo --host mongodb.msahu.online </app/schema/${component}.js &>>${log}

fun_systemd

}

fun_java(){

  echo -e "\e[36m>>>>>>>> Install Maven <<<<<<<<<<<<<<<\e[0m"
  yum install maven -y &>>${log}

  fun_apppreq

  echo -e "\e[36m>>>>>>>> Build ${component} service <<<<<<<<<<<<<<<\e[0m"
  mvn clean package &>>${log}
  mv target/${component}-1.0.jar ${component}.jar &>>${log}

  echo -e "\e[36m>>>>>>>> Install Mysql Client <<<<<<<<<<<<<<<\e[0m"
  yum install mysql -y &>>${log}

  echo -e "\e[36m>>>>>>>> Load Schema <<<<<<<<<<<<<<<\e[0m"
  mysql -h mysql.msahu.online -uroot -pRoboShop@1 < /app/schema/${component}.sql &>>${log}

  fun_systemd

}

fun_python(){

  echo -e "\e[36m>>>>>>>> Create ${component} Service <<<<<<<<<<<<<<<\e[0m"
  yum install python36 gcc python3-devel -y &>>${log}

  fun_apppreq

  echo -e "\e[36m>>>>>>>> Create ${component} Service <<<<<<<<<<<<<<<\e[0m"
  pip3.6 install -r requirements.txt &>>${log}

  fun_systemd

}