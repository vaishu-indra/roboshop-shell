source common.sh

echo -e "\e[35m copying mongodb repo\e[0m"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
status_check

echo -e "\e[35m Install mongodb\e[0m"
yum install mongodb-org -y &>>${LOG}
status_check

echo -e "\e[35m change bindip\e[0m"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${LOG}
status_check

echo -e "\e[35m enable mongodb\e[0m"
systemctl enable mongod &>>${LOG}
status_check

echo -e "\e[35m restart mongodb\e[0m"
systemctl restart mongod &>>${LOG}
status_check

