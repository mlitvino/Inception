#!/bin/bash
set -e

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing database..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

MYSQL_ROOT_PASS="$(cat /run/secrets/mysql_root_pass)"
MYSQL_USER_PASS="$(cat /run/secrets/mysql_user_pass)"
cat > /etc/mysql/init.sql << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASS}';
CREATE DATABASE IF NOT EXISTS \`wordpress\` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE USER IF NOT EXISTS 'mlitvino'@'%' IDENTIFIED BY '${MYSQL_USER_PASS}';
GRANT ALL PRIVILEGES ON \`mariadb\`.* TO 'mlitvino'@'%';
FLUSH PRIVILEGES;
EOF

exec /usr/bin/mariadbd-safe --datadir=/var/lib/mysql --user=mysql --console
