script_location=$(pwd)
LOG=/tmp/roboshop.log

echo -e "\e[31m copying mongodb repo\e[0m"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${LOG}

echo -e "\e[31m Install mongodb\e[0m"
yum install mongodb-org -y &>>${LOG}

echo -e "\e[31m changing bindip\e[0m"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${LOG}

echo -e "\e[31m enable mongodb\e[0m"
systemctl enable mongod &>>${LOG}

echo -e "\e[31m start mongodb\e[0m"
systemctl restart mongod &>>${LOG}
