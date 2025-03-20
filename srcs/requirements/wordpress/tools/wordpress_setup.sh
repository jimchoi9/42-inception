#!/bin/bash

  wp core download --path=./wordpress --allow-root

  cd wordpress

#   # wp-config.php 생성
  wp config create --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=$WP_DB_HOST --skip-check --allow-root
  
#   # WordPress 설치
  wp core install --url=$DOMAIN_NAME --title="inception" --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL --skip-email --allow-root
  
chown -R www-data:www-data /wordpress

# wp user create guest ${WP_EMAIL} --role=$WP_USER --user_pass=$WP_PASSWORD --allow-root
wp user create $WP_USER  user@test.com --role=contributor --user_pass=$WP_PASSWORD --allow-root
php-fpm7.4 -F