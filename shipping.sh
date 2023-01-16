source common.sh

if [ -z "${root_mysql_password}" ]; then
  echo "variable root_mysql_password is needed"
  exit 1
fi

component=shipping
schema_load=true
schema_type=mysql
MAVEN
