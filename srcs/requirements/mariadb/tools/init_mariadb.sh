#!/bin/bash

# MariaDB 서비스 시작
service mariadb start

# root 비밀번호 설정 및 데이터베이스 생성을 위한 시간 지연
sleep 5

# 데이터베이스가 이미 초기화되었는지 확인
if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
    # 보안 설정 적용
    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"
    
    # WordPress 데이터베이스 생성
    mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"
    
    # WordPress 사용자 생성 및 권한 부여
    mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
    mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';"
    
    # 원격 접속 허용
    mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"
    
    # 권한 적용
    mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "FLUSH PRIVILEGES;"
    
    echo "MariaDB 초기화 완료"
else
    echo "MariaDB 이미 초기화됨"
fi

# MariaDB 서비스 중지 (docker-compose에서 자동으로 시작되므로)
service mariadb stop

# foreground에서 MariaDB 실행 (컨테이너가 종료되지 않도록)
exec mysqld_safe