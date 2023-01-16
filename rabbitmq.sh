source common.sh

if [ -z "${roboshop_rabbitmq_password}" ]; then
  echo "variable root_mysql_password is missing"
  exit 1
fi

print_head "configuring erlang YUM repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>>${LOG}
status_check

print_head "configuring RABBITMQ YUM Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${LOG}
status_check

print_head "install erlang $ RABBITMQ"
yum install erlang rabbitmq-server -y &>>${LOG}
status_check

print_head "Enable rabbitmq server"
systemctl enable rabbitmq-server &>>${LOG}
status_check

print_head "start rabbitmq server"
systemctl start rabbitmq-server &>>${LOG}
status_check

print_head "add application user"
rabbitmqctl list_users | grep roboshop &>>${LOG}
if [ $? ne 0 ]; then
    rabbitmqctl add_user roboshop ${roboshop_rabbitmq_password} &>>${LOG}
fi
status_check

print_head "add tags to application user"
rabbitmqctl set_user_tags roboshop administrator &>>${LOG}
status_check

print_head "add permissions to application user"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${LOG}
status_check