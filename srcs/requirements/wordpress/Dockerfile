FROM debian:bullseye

RUN apt update && apt install -y \
	curl \
	php \
	php-mysql \
	php7.4-fpm \
	mariadb-client 


RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar 
RUN chmod +x wp-cli.phar 
RUN mv wp-cli.phar /usr/local/bin/wp


COPY ./conf/www.conf /etc/php/7,4/fpm/pool.d
COPY ./tools/wordpress_setup.sh ./

RUN mkdir /run/php

EXPOSE 9000

ENTRYPOINT [ "sh", "wordpress_setup.sh" ]
