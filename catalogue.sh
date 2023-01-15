source common.sh

print_head "configuring nodejs repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
status_check

print_head "Install nodejs"
yum install nodejs -y &>>${LOG}
status_check

print_head "35m add application user"
id roboshop  &>>${LOG}
if [ $? -ne 0 ] ;
 useradd roboshop &>>${LOG}
fi
status_check

print_head "downloading app content"
mkdir -p /app &>>${LOG}
curl -L -o /tmp/catalog0ue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}
status_check

print_head "cleanup old content"
rm -rf /app/* &>>${LOG}
status_check

print_head "extracting app content"
cd /app &>>${LOG}
unzip /tmp/catalogue.zip &>>${LOG}
status_check

print_head "Installaling nodejs dependencies"
cd /app &>>${LOG}
npm install &>>${LOG}
status_check

print_head "configuring catalogue service file"
cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service &>>${LOG}
status_check

print_head "reload systemD"
systemctl daemon-reload &>>${LOG}
status_check

print_head "enable catalogue service"
systemctl enable catalogue &>>${LOG}
status_check

print_head "start catalogue service"
systemctl start catalogue &>>${LOG}
status_check

print_head "configuring mongo repo"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
status_check

print_head "Installing mongodb-client"
yum install mongodb-org-shell -y &>>${LOG}
status_check

print_head "load schema"
mongo --host mongodb-dev.learndevopsb70.online </app/schema/catalogue.js &>>${LOG}
status_check

