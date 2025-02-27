# #!/bin/bash

# # MariaDB 서비스 시작
# service mysql start

# # 데이터베이스 및 사용자 생성
# << EOF cat > ./sql.sql
# CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
# CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
# GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
# ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
# FLUSH PRIVILEGES;
# EOF
# # mysql -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
# # mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
# # mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"
# # mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
# # mysql -e "FLUSH PRIVILEGES;"

# # MariaDB 안전하게 종료
# mysqld --bootstrap --user=mysql --skip-grant-tables=false < ./sql.sql
# # mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown

# # MariaDB 실행
# exec mysqld_safe

#!/bin/sh

# MariaDB를 임시로 시작 (초기화용)
echo "[INFO] Starting MariaDB for initialization..."
mysqld --user=mysql --skip-networking &
pid=$!

# MariaDB가 시작될 때까지 대기
echo "[INFO] Waiting for MariaDB to start..."
while ! mysqladmin ping --silent; do
    sleep 1
done

# 데이터베이스 및 사용자 초기화
echo "[INFO] Setting up the database..."
mysql -u root <<-EOSQL
    CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    FLUSH PRIVILEGES;
EOSQL

# 초기화 후 MariaDB 안전하게 종료
echo "[INFO] Stopping temporary MariaDB instance..."
if ! kill -s TERM "$pid" || ! wait "$pid"; then
    echo >&2 '[ERROR] MariaDB initialization process failed.'
    exit 1
fi

# ENTRYPOINT에서 전달받은 CMD 명령 실행 (일반적으로 mysqld)
echo "[INFO] Starting MariaDB server..."
exec "$@"