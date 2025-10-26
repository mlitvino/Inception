#!/bin/bash
set -e
cd /var/www/html

WP_ADMIN_PASS="$(cat /run/secrets/admin_pass)"
WP_USER_PASS="$(cat /run/secrets/user_pass)"
WP_DB_PASS="$(cat /run/secrets/mysql_user_pass)"

DB_NAME="${WP_DB_NAME:-wordpress}"
DB_USER="${WP_DB_USER:-mlitvino}"
DB_HOST="${DB_HOST:-mariadb}"

curl -sS -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
./wp-cli.phar core download --allow-root

if [ ! -f wp-config.php ]; then
  ./wp-cli.phar config create \
    --dbname="$DB_NAME" \
    --dbuser="$DB_USER" \
    --dbpass="$WP_DB_PASS" \
    --dbhost="$DB_HOST" \
    --allow-root
fi

if ! ./wp-cli.phar core is-installed --allow-root >/dev/null 2>&1; then
  ./wp-cli.phar core install \
    --url="${WP_URL}" \
    --title="${WP_TITLE}" \
    --admin_user="${WP_ADMIN_NAME}" \
    --admin_password="${WP_ADMIN_PASS}" \
    --admin_email="${WP_ADMIN_EMAIL}" \
    --skip-email \
    --allow-root
fi

if [ -n "${WP_USER_NAME:-}" ] && ! ./wp-cli.phar user get "$WP_USER_NAME" --allow-root >/dev/null 2>&1; then
  ./wp-cli.phar user create "$WP_USER_NAME" "$WP_USER_EMAIL" --user_pass="$WP_USER_PASS" --role=author --allow-root
fi

exec php-fpm8.2 -F