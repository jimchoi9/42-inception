FROM debian:bullseye

# MariaDB 설치
# dumb-init은 PID 1로 실행되는 init 프로세스 역할을 합니다.
# MariaDB 서버와 클라이언트를 함께 설치합니다.
# apt update로 다운로드된 패키지 목록 캐시를 삭제하여 이미지 크기를 줄이는 역할을 합니다.
RUN apt-get update && apt-get install -y \
	dumb-init \
	mariadb-server \
	mariadb-client \
	&& rm -rf /var/lib/apt/lists/* 


#mysql 디렉터리 설정
RUN mkdir -p /var/lib/mysql \
	&& chown -R mysql:mysql /var/lib/mysql \
	&& chmod 777 /var/lib/mysql

#설정파일, 초기화스크립트 복사
COPY ./conf/mariadb.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# 초기화 스크립트를 컨테이너에 복사하고 실행 권한 부여
# docker-entrypoint-initdb.d는 일반적으로 MariaDB/MySQL 초기화 스크립트 위치로 사용됨
COPY ./tools/init_mariadb.sh /docker-entrypoint-initdb.d/

#실행권한부여
RUN chmod +x /docker-entrypoint-initdb.d/init_mariadb.sh


# MariaDB 기본 포트 3306 노출
EXPOSE 3306

# 컨테이너 시작 시 실행할 명령 정의 (PID 1)
# 초기화 스크립트가 먼저 실행됨
ENTRYPOINT ["/docker-entrypoint-initdb.d/init_mariadb.sh"]

# MariaDB를 포그라운드에서 실행 (init_mariadb.sh가 자동 실행됨)
CMD ["mysqld_safe"]