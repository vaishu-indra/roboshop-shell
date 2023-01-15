script_location=$(pwd)
LOG=/tmp/roboshop.log

echo -e "\e[31m configuring nodejs\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
exit
fi

echo -e "\e[31m Install nodejs\e[0m"
yum install nodejs -y &>>${LOG}
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
exit
fi

echo -e "\e[31m add application user\e[0m"
useradd roboshop &>>${LOG}
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
exit
fi

mkdir -p /app &>>${LOG}

echo -e "\e[31m downloading app content\e[0m"
curl -L -o /tmp/catalog0ue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
exit
fi

echo -e "\e[31m cleanup old content\e[0m"
rm -rf /app/* &>>${LOG}
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
exit
fi

echo -e "\e[31m extracting app content\e[0m"
cd /app &>>${LOG}
unzip /tmp/catalogue.zip &>>${LOG}
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
exit
fi

echo -e "\e[31m Installaling nodejs dependencies\e[0m"
cd /app &>>${LOG}
npm install &>>${LOG}
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
exit
fi

echo -e "\e[31m configuring catalogue service file\e[0m"
cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service &>>${LOG}
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
exit
fi

echo -e "\e[31m reload systemD\e[0m"
systemctl daemon-reload &>>${LOG}
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
exit
fi

echo -e "\e[31m enable catalogue service\e[0m"
systemctl enable catalogue &>>${LOG}
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
exit
fi

echo -e "\e[31m start catalogue service\e[0m"
systemctl start catalogue &>>${LOG}
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
exit
fi

echo -e "\e[31m configuring mongo repo\e[0m"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
exit
fi

echo -e "\e[31m Installing mongodb-client\e[0m"
yum install mongodb-org-shell -y &>>${LOG}
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
exit
fi

echo -e "\e[31m load schema\e[0m"
mongo --host mongodb-dev.learndevopsb70.online </app/schema/catalogue.js &>>${LOG}
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
exit
fi

