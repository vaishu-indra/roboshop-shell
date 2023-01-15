script_location=$(pwd)
LOG=/tmp/roboshop.log

echo -e "\e[35m Install nginx\e[0m"
yum install nginx -y &>>${LOG}
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
exit
fi

echo -e "\e[35m Enable nginx\e[0m"
systemctl enable nginx &>>${LOG}
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
exit
fi

echo -e "\e[35m Start nginx\e[0m"
systemctl start nginx &>>${LOG}
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
exit
fi

echo -e "\e[35m Remove nginx old content\e[0m"
rm -rf /usr/share/nginx/html/* &>>${LOG}
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
exit
fi

echo -e "\e[35m Download frontend content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${LOG}
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
exit
fi

cd /usr/share/nginx/html &>>${LOG}

echo -e "\e[35m Extract frontend content\e[0m"
unzip /tmp/frontend.zip &>>${LOG}
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
exit
fi

echo -e "\e[35m Copy roboshop nginx config file\e[0m"
cp ${script_location}/files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${LOG}
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
exit
fi

echo -e "\e[35m Restart nginx\e[0m"
systemctl restart nginx &>>${LOG}
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
exit
fi



