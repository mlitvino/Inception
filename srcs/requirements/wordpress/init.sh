#!/bin/bash
cd /var/www/html

WP_ADMIN_PASS="$(cat /run/secrets/admin_pass)"
WP_USER_PASS="$(cat /run/secrets/user_pass)"

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
./wp-cli.phar core download --allow-root
./wp-cli.phar config create --dbname=wordpress \
	--dbuser=wpuser \
	--dbpass=password \
	--dbhost=mariadb \
	--allow-root

./wp-cli.phar core install --url="${WP_URL}" \
	--title="${WP_TITLE}" \
	--admin_user="${WP_ADMIN_NAME}" \
	--admin_password="${WP_ADMIN_PASS}" \
	--admin_email="${WP_ADMIN_EMAIL}" \
	--allow-root

./wp-cli.phar user create \
	"${WP_USER_NAME}" "${WP_USER_EMAIL}" --user_pass="${WP_USER_PASS}" \
	--role=author --allow-root

php-fpm8.2 -F
