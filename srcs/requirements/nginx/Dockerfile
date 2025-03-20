FROM debian:bullseye


RUN apt update && \
	apt install -y nginx curl && \
	apt install -y openssl && \
	rm -rf /var/lib/apt/lists/*





# nginx 설정 파일 복사
COPY ./conf/nginx.conf /etc/nginx/sites-enabled/default
COPY ./tools/nginx.sh /home/nginx.sh
RUN chmod +x /home/nginx.sh

# 443 포트 개방
EXPOSE 443

ENTRYPOINT ["bash", "/home/nginx.sh"]
