script_location=$(pwd)
LOG=/tmp/roboshop.log

echo -e "\e[31m Install nginx\e[0m"
yum install nginx -y &>>$(log)

echo -e "\e[31m Enable nginx\e[0m"
systemctl enable nginx &>>$(log)

echo -e "\e[31m Start nginx\e[0m"
systemctl start nginx &>>$(log)

echo -e "\e[31m Remove nginx old content\e[0m"
rm -rf /usr/share/nginx/html/* &>>$(log)

echo -e "\e[31m Download frontend content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$(log)

cd /usr/share/nginx/html &>>$(log)

echo -e "\e[31m Extract frontend content\e[0m"
unzip /tmp/frontend.zip &>>$(log)

echo -e "\e[31m Copy roboshop nginx config file\e[0m"
cp ${script_location}/files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$(log)

echo -e "\e[31m Restart nginx\e[0m"
systemctl restart nginx &>>$(log)
