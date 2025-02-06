#!/bin/bash

# WordPress 코어 다운로드
wp core download --allow-root

# wp-config.php 생성
wp config create --allow-root \
    --dbname=$MYSQL_DATABASE \
    --dbuser=$MYSQL_USER \
    --dbpass=$MYSQL_PASSWORD \
    --dbhost=mariadb

# WordPress 설치
wp core install --allow-root \
    --url=$DOMAIN_NAME \
    --title="WordPress Site" \
    --admin_user=$WP_ADMIN_USER \
    --admin_password=$WP_ADMIN_PASSWORD \
    --admin_email=$WP_ADMIN_EMAIL

# php-fpm 실행
/usr/sbin/php-fpm7.3 -F