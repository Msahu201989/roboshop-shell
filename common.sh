log=/tmp/roboshop.log

func_exit_status() {
  if [ $? -eq 0 ]; then
    echo -e "\e[32m SUCCESS \e[0m"
  else
    echo -e "\e[31m FAILURE \e[0m"
  fi
}

    fun_apppreq(){

    echo -e "\e[36m>>>>>>>> Create ${component} Service <<<<<<<<<<<<<<<\e[0m"
    cp ${component}.service /etc/systemd/system/${component}.service &>>${log}
    func_exit_status

    echo -e "\e[36m>>>>>>>> Create Application USER  ${component} <<<<<<<<<<<<<<<\e[0m"
    id roboshop &>>${log}
    if [ $? -ne 0 ]; then
    useradd roboshop &>>${log}
    fi
    func_exit_status

    echo -e "\e[36m>>>>>>>> Cleanup Existing Application Content <<<<<<<<<<<<<<<\e[0m"
    rm -rf /app &>>${log}
func_exit_status

    echo -e "\e[36m>>>>>>>> Create Application Directory <<<<<<<<<<<<<<<\e[0m"
    mkdir /app &>>${log}
func_exit_status


    echo -e "\e[36m>>>>>>>> Download Application Content <<<<<<<<<<<<<<<\e[0m"
    curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
func_exit_status


    echo -e "\e[36m>>>>>>>> Extract Application Content<<<<<<<<<<<<<<<\e[0m"
    cd /app &>>${log}
    unzip /tmp/${component}.zip &>>${log}
    cd /app &>>${log}
    func_exit_status
}

fun_systemd(){

  echo -e "\e[36m>>>>>>>> Start ${component} Service <<<<<<<<<<<<<<<\e[0m"
  systemctl daemon-reload &>>${log}
  systemctl enable ${component} &>>${log}
  systemctl restart ${component} &>>${log}
  func_exit_status
}

   fun_schema_setup(){
   if [ "${schema_type}" == "mongodb" ]; then
   echo -e "\e[36m>>>>>>>> Install Mongo Client <<<<<<<<<<<<<<<\e[0m"
   yum install mongodb-org-shell -y &>>${log}

   echo -e "\e[36m>>>>>>>> Load ${component} Schema <<<<<<<<<<<<<<<\e[0m"
   mongo --host mongodb.msahu.online </app/schema/${component}.js &>>${log}
   fi

   if [ "${schema_type}" == "mysql" ]; then
       echo -e "\e[36m>>>>>>>> Install Mysql Client <<<<<<<<<<<<<<<\e[0m"
       yum install mysql -y &>>${log}

       echo -e "\e[36m>>>>>>>> Load Schema <<<<<<<<<<<<<<<\e[0m"
       mysql -h mysql.msahu.online -uroot -pRoboShop@1 < /app/schema/${component}.sql &>>${log}
   fi
}

  fun_nodejs() {

  echo -e "\e[36m>>>>>>>> Create MongoDB Repo <<<<<<<<<<<<<<<\e[0m"
  cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}

  func_exit_status

  echo -e "\e[36m>>>>>>>> Download & Install Node Js Repo <<<<<<<<<<<<<<<\e[0m"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}

  func_exit_status

  echo -e "\e[36m>>>>>>>> Install Node JS  <<<<<<<<<<<<<<<\e[0m"
  yum install nodejs -y &>>${log}

 func_exit_status

 fun_apppreq

  echo -e "\e[36m>>>>>>>> Download NodeJS Dependencies <<<<<<<<<<<<<<<\e[0m"
  npm install &>>${log}

  func_exit_status

  fun_schema_setup

  fun_systemd

}

fun_java(){

  echo -e "\e[36m>>>>>>>> Install Maven <<<<<<<<<<<<<<<\e[0m"
  yum install maven -y &>>${log}
  func_exit_status

  fun_apppreq

  echo -e "\e[36m>>>>>>>> Build ${component} service <<<<<<<<<<<<<<<\e[0m"
  mvn clean package &>>${log}
  mv target/${component}-1.0.jar ${component}.jar &>>${log}
  func_exit_status

  fun_schema_setup

  fun_systemd

}

fun_python(){

  echo -e "\e[36m>>>>>>>> Create ${component} Service <<<<<<<<<<<<<<<\e[0m"
  yum install python36 gcc python3-devel -y &>>${log}
  func_exit_status

  fun_apppreq

  echo -e "\e[36m>>>>>>>> Create ${component} Service <<<<<<<<<<<<<<<\e[0m"
  pip3.6 install -r requirements.txt &>>${log}
  func_exit_status

  fun_systemd

}

fun_golang(){

echo -e "\e[36m>>>>>>>> Installing Golang <<<<<<<<<<<<<<<\e[0m"
dnf install golang -y &>>${log}
func_exit_status

fun_apppreq

echo -e "\e[36m>>>>>>>> Builing App Golang <<<<<<<<<<<<<<<\e[0m"
go mod init dispatch  &>>${log}
go get &>>${log}
go build &>>${log}
func_exit_status

fun_systemd
}