#!/bin/bash
set -e

if [ ! -d "/var/lib/mysql/mysql" ]; then
  mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

MYSQL_ROOT_PASS="$(cat /run/secrets/mysql_root_pass)"
MYSQL_USER_PASS="$(cat /run/secrets/mysql_user_pass)"

esc() { printf "%s" "$1" | sed "s/'/''/g"; }
ROOT_ESC="$(esc "$MYSQL_ROOT_PASS")"
USER_ESC="$(esc "$MYSQL_USER_PASS")"

cat > /etc/mysql/init.sql <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${ROOT_ESC}';
CREATE DATABASE IF NOT EXISTS \`wordpress\` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE USER IF NOT EXISTS 'mlitvino'@'%' IDENTIFIED BY '${USER_ESC}';
GRANT ALL PRIVILEGES ON \`wordpress\`.* TO 'mlitvino'@'%';
FLUSH PRIVILEGES;
EOF

exec /usr/bin/mariadbd-safe --datadir=/var/lib/mysql --user=mysql --console