#!/bin/bash
set -e

MYSQL_PASSWORD=$(cat /run/secrets/db_password)
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

if [ ! -d "/var/lib/mysql/mysql" ]; then

    echo "==> Initializing MariaDB data directory..."
    mariadb-install-db \
        --user=mysql \
        --datadir=/var/lib/mysql \
        --skip-test-db \
        --auth-root-authentication-method=normal

    cat > /tmp/init.sql << EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

    echo "==> Starting temporary MariaDB ..."
    mariadbd \
	--user=mysql \
	--datadir=/var/lib/mysql \
	--skip-networking &

    pid=$!

    echo "==> Waiting for MariaDB..."

    mariadb-admin --no-defaults \
    	--wait=30 \
    	--socket=/run/mysqld/mysqld.sock \
    	-u root ping
    mariadb --no-defaults \
        --socket=/run/mysqld/mysqld.sock \
        -u root < /tmp/init.sql

    rm -f /tmp/init.sql

    echo "==>Stoppping temporary MariaDB..."

    kill "$pid"
    wait "$pid"

fi

echo "==> Starting MariaDB server..."

exec mariadbd --user=mysql --datadir=/var/lib/mysql
