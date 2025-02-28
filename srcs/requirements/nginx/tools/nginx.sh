#!/bin/sh

if [ ! -f $SSL_KEY ]; then
	mkdir -p /etc/ssl/private /etc/ssl/certs && \
	openssl req -newkey rsa:2048 -nodes -x509 -days 365 \
	-keyout $SSL_KEY \
	-out $SSL_CRT \
	-subj "/C=KR/ST=Seoul/L=Gaepo/O=hyeognsh/CN=$DOMAIN_NAME"
fi

nginx -g "daemon off;"