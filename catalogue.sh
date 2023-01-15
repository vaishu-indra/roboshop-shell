script_location=$(pwd)
LOG=/tmp/roboshop.log

status_check() {
  if [ $? -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    echo "Refer log file for more information, LOG - ${LOG}"
  exit
  fi
}
echo -e "\e[31m configuring nodejs\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
status_check

echo -e "\e[31m Install nodejs\e[0m"
yum install nodejs -y &>>${LOG}
status_check

echo -e "\e[31m add application user\e[0m"
useradd roboshop &>>${LOG}
status_check

mkdir -p /app &>>${LOG}

echo -e "\e[31m downloading app content\e[0m"
curl -L -o /tmp/catalog0ue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}
status_check

echo -e "\e[31m cleanup old content\e[0m"
rm -rf /app/* &>>${LOG}
status_check

echo -e "\e[31m extracting app content\e[0m"
cd /app &>>${LOG}
unzip /tmp/catalogue.zip &>>${LOG}
status_check

echo -e "\e[31m Installaling nodejs dependencies\e[0m"
cd /app &>>${LOG}
npm install &>>${LOG}
status_check

echo -e "\e[31m configuring catalogue service file\e[0m"
cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service &>>${LOG}
status_check

echo -e "\e[31m reload systemD\e[0m"
systemctl daemon-reload &>>${LOG}
status_check

echo -e "\e[31m enable catalogue service\e[0m"
systemctl enable catalogue &>>${LOG}
status_check

echo -e "\e[31m start catalogue service\e[0m"
systemctl start catalogue &>>${LOG}
status_check

echo -e "\e[31m configuring mongo repo\e[0m"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
status_check

echo -e "\e[31m Installing mongodb-client\e[0m"
yum install mongodb-org-shell -y &>>${LOG}
status_check

echo -e "\e[31m load schema\e[0m"
mongo --host mongodb-dev.learndevopsb70.online </app/schema/catalogue.js &>>${LOG}
status_check

