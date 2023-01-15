source common.sh

echo -e "\e[35m configuring nodejs\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
status_check

echo -e "\e[35m Install nodejs\e[0m"
yum install nodejs -y &>>${LOG}
status_check

echo -e "\e[35m add application user\e[0m"
useradd roboshop &>>${LOG}
status_check

mkdir -p /app &>>${LOG}

echo -e "\e[35m downloading app content\e[0m"
curl -L -o /tmp/catalog0ue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}
status_check

echo -e "\e[35m cleanup old content\e[0m"
rm -rf /app/* &>>${LOG}
status_check

echo -e "\e[35m extracting app content\e[0m"
cd /app &>>${LOG}
unzip /tmp/catalogue.zip &>>${LOG}
status_check

echo -e "\e[35m Installaling nodejs dependencies\e[0m"
cd /app &>>${LOG}
npm install &>>${LOG}
status_check

echo -e "\e[35m configuring catalogue service file\e[0m"
cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service &>>${LOG}
status_check

echo -e "\e[35m reload systemD\e[0m"
systemctl daemon-reload &>>${LOG}
status_check

echo -e "\e[35m enable catalogue service\e[0m"
systemctl enable catalogue &>>${LOG}
status_check

echo -e "\e[35m start catalogue service\e[0m"
systemctl start catalogue &>>${LOG}
status_check

echo -e "\e[35m configuring mongo repo\e[0m"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
status_check

echo -e "\e[35m Installing mongodb-client\e[0m"
yum install mongodb-org-shell -y &>>${LOG}
status_check

echo -e "\e[35m load schema\e[0m"
mongo --host mongodb-dev.learndevopsb70.online </app/schema/catalogue.js &>>${LOG}
status_check

