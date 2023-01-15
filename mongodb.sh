script_location=$(pwd)
LOG=/tmp/roboshop.log

echo -e "\e[31m copying mongodb repo\e[0m"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
exit
fi

echo -e "\e[31m Install mongodb\e[0m"
yum install mongodb-org -y &>>${LOG}
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
exit
fi

echo -e "\e[31m changing bindip\e[0m"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${LOG}
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
exit
fi

echo -e "\e[31m enable mongodb\e[0m"
systemctl enable mongod &>>${LOG}
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
exit
fi

echo -e "\e[31m restart mongodb\e[0m"
systemctl restart mongod &>>${LOG}
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
exit
fi

