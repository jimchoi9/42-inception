#!/bin/bash

# 데이터 디렉토리 초기화 확인
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysqld --initialize --user=root --datadir=/var/lib/mysql
fi

# MariaDB 부트스트랩 모드로 초기 데이터베이스 설정
mysqld --user=root --bootstrap << EOF
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
EOF

# MariaDB 서버를 데몬으로 실행
exec dumb-init -- mysqld_safe --user=root --datadir='/var/lib/mysql'