#!/bin/bash
echo "starting mariadb"
if [ ! -d "/var/lib/mysql/mysql" ]; then
	mysqld --initialize --user=root --datadir=/var/lib/mysql
fi

mysqld --user=root --bootstrap << EOF
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
EOF

exec dumb-init -- mysqld_safe --user=root --datadir='/var/lib/mysql'
