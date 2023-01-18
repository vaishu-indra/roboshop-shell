source common.sh

if [ -z "${root_mysql_password}" ]; then
  echo "variable root_mysql_password is missing"
  exit 1
fi

print_head "disable mysQL Default module"
dnf module disable mysql -y  &>>${LOG}
status_check

print_head "copy mysQL repo file"
cp ${script_location}/files/mysql.repo /etc/yum.repos.d/mysql.repo &>>${LOG}
status_check

print_head "install mysql community server"
yum install mysql-community-server -y &>>${LOG}
status_check

print_head "enable mysqld"
systemctl enable mysqld  &>>${LOG}
status_check

print_head "start mysqld"
systemctl restart mysqld &>>${LOG}
status_check

print_head "reset default database password"
mysql_secure_installation --set-root-pass ${root_mysql_password} &>>${LOG}
if [ $? - eq 1]; then
  echo "password is already changed"
fi
status_check




