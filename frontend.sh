script_location=$(pwd)
log=/tmp/roboshop.log

echo -e "\e[31m install nginx\e[0m"
yum install nginx -y &>>$(log)

echo -e "\e[31m enable nginx\e[0m"
systemctl enable nginx &>>$(log)

echo -e "\e[31m start nginx\e[0m"
systemctl start nginx &>>$(log)

echo -e "\e[31m remove nginx old content\e[0m"
rm -rf /usr/share/nginx/html/* &>>$(log)

echo -e "\e[31m download frontend content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$(log)

cd /usr/share/nginx/html &>>$(log)

echo -e "\e[31m extract frontend content\e[0m"
unzip /tmp/frontend.zip &>>$(log)

echo -e "\e[31m copy roboshop nginx config file\e[0m"
cp ${script_location}/files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$(log)

echo -e "\e[31m restart nginx\e[0m"
systemctl restart nginx &>>$(log)
