#!/bin/bash

# MariaDB 데이터 디렉토리가 비어 있는지 확인
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "MariaDB 데이터 디렉토리가 비어 있음. 초기화 시작..."

    # MariaDB 데이터 디렉토리 초기화
    mysqld --initialize-insecure --user=mysql
    
    # MariaDB 시작
    mysqld_safe --skip-networking &
    sleep 5

    # root 비밀번호 설정
    mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"

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

# 포그라운드에서 MariaDB 실행 (컨테이너 유지)
exec mysqld_safe
