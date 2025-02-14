#!/bin/bash

# php-fpm 설정 디렉토리 생성
mkdir -p /run/php

# WordPress 설치 디렉토리로 이동
cd /var/www/html

# 기존 파일 확인 및 정리
if [ "$(ls -A /var/www/html)" ]; then
    echo "Directory is not empty, cleaning..."
    rm -rf /var/www/html/*
fi

# WordPress 코어 파일 다운로드
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

# 권한 설정
chown -R www-data:www-data /var/www/html

# php-fpm 실행
exec php-fpm7.4 -F



# # cd /var/www/html/

# if [ ! -f wp-config.php ]; then
#   # WordPress 다운로드
#   wp core download --allow-root

# #   # wp-config.php 생성
#   wp config create --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=$WORDPRESS_DB_HOST --allow-root
  
# #   # WordPress 설치
#   wp core install --url=$DOMAIN_NAME --title="My WordPress Site" --admin_user=$WORDPRESS_ADMIN --admin_password=$WORDPRESS_ADMIN_PASSWORD --admin_email=$WORDPRESS_ADMIN_EMAIL --allow-root
  
# #   # 새 사용자 생성
#   wp user create $WORDPRESS_USER user@test.com --role=contributor --user_pass=$WORDPRESS_USER_PASSWORD --allow-root

#   Redis Object Cache 플러그인 활성화
#   wp plugin install redis-cache --activate --allow-root

#   wp-config.php 파일에 Redis 설정 추가
#   wp config set WP_REDIS_HOST $WORDPRESS_REDIS_HOST --allow-root
#   wp config set WP_CACHE true --raw --allow-root

#   Redis 캐시 활성화
#   wp redis enable --allow-root
# fi


# PHP-FPM 시작
# php-fpm7.4 -F
# # tail -f