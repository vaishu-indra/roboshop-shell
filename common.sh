script_location=$(pwd)
LOG=/tmp/roboshop.log

status_check() {
  if [ $? -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    echo "Refer log file for more information, LOG - ${LOG}"
  exit 1
  fi
}

print_head() {
  echo -e "\e[1m $1 \e[0m"
}

APP_PREREQ() {

  print_head "add application user"
    id roboshop  &>>${LOG}
    if [ $? -ne 0 ]; then
     useradd roboshop &>>${LOG}
    fi
    status_check

    print_head "downloading app content"
    mkdir -p /app &>>${LOG}
    curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${LOG}
    status_check

    print_head "cleanup old content"
    rm -rf /app/* &>>${LOG}
    status_check

    print_head "extracting app content"
    cd /app &>>${LOG}
    unzip /tmp/${component}.zip &>>${LOG}
    status_check

}

systemD_setup() {
  print_head "configuring ${component} service file"
    cp ${script_location}/files/${component}.service /etc/systemd/system/${component}.service &>>${LOG}
    status_check

    print_head "reload systemD"
    systemctl daemon-reload &>>${LOG}
    status_check

    print_head "enable ${component}  service"
    systemctl enable ${component} &>>${LOG}
    status_check

    print_head "start ${component} service"
    systemctl start ${component} &>>${LOG}
    status_check
}

LOAD_SCHEMA() {
  if [ ${schema_load} == "true" ]; then

    if [ ${schema_type} == "mongo" ]; then

      print_head "configuring mongo repo"
      cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
      status_check

      print_head "Installing mongodb-client"
      yum install mongodb-org-shell -y &>>${LOG}
      status_check

      print_head "load schema"
      mongo --host mongodb-dev.learndevopsb70.online </app/schema/${component}.js &>>${LOG}
      status_check

    fi

    if [ ${schema_type} == "mysql" ]; then

      print_head "Installing mysql-client"
      yum install mysql -y &>>${LOG}
      status_check

      print_head "load schema"
      mysql -h mysql-dev.learndevopsb70.online -uroot -p${root_mysql_password} < /app/schema/shipping.sql  &>>${LOG}
      status_check

    fi

fi

}

NODEJS() {
  print_head "configuring nodejs repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
  status_check

  print_head "Install nodejs"
  yum install nodejs -y &>>${LOG}
  status_check

  APP_PREREQ

  print_head "Installaling nodejs dependencies"
  cd /app &>>${LOG}
  npm install &>>${LOG}
  status_check

  systemD_setup

  LOAD_SCHEMA

}

MAVEN() {

    print_head "Install maven"
    yum install maven -y &>>${LOG}
    status_check

    APP_PREREQ

    print_head "build a package"
    mvn clean package &>>${LOG}
    status_check

    print_head "copy app file to app location"
    mv target/${component}-1.0.jar ${component}.jar
    status_check

    systemD_setup

    LOAD_SCHEMA

}

PYTHON() {

      print_head "Install python"
      yum install python36 gcc python3-devel -y &>>${LOG}
      status_check

      APP_PREREQ

      print_head "download dependencies"
      cd /app
      pip3.6 install -r requirements.txt &>>${LOG}
      status_check

      print_head "update passwords in service file"
      sed -i -e "s/roboshop_rabbitmq_password/${roboshop_rabbitmq_password}/" ${script_location}/files/${component}.service &>>${LOG}
      status_check

      systemD_setup

      LOAD_SCHEMA
}