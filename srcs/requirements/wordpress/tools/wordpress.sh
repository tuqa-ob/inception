#! /bin/bash

set -e

MYSQL_PASSWORD=$(cat /run/secrets/db_password)

mkdir -p /var/www/html

if [ ! -f /var/www/html/wp-config.php ]; then
	cd /tmp
	curl -O https://wordpress.org/latest.tar.gz
	tar -xzf latest.tar.gz
	cp -r /tmp/wordpress/* /var/www/html/
	cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
	sed -i "s/database_name_here/${MYSQL_DATABASE}/" /var/www/html/wp-config.php
	sed -i "s/username_here/${MYSQL_USER}/" /var/www/html/wp-config.php
	sed -i "s/password_here/${MYSQL_PASSWORD}/" /var/www/html/wp-config.php
	sed -i "s/localhost/mariadb/" /var/www/html/wp-config.php
	curl -s https://api.wordpress.org/secret-key/1.1/salt > /tmp/wp-keys

	sed -i '/AUTH_KEY/,/NONCE_SALT/d' /var/www/html/wp-config.php

	sed -i "/DB_COLLATE/r /tmp/wp-keys" /var/www/html/wp-config.php

	rm -f /tmp/wp-keys
fi

export HTTP_HOST="${DOMAIN_NAME}"
export HTTPS="on"

if ! wp --allow-root --path=/var/www/html core is-installed; then
    echo "==> Installing WordPress..."

    wp --allow-root --path=/var/www/html core install \
        --url="https://${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email
fi

if ! wp --allow-root --path=/var/www/html user get "${WP_USER}" >/dev/null 2>&1; then
    echo "==> Creating WordPress user..."

    wp --allow-root --path=/var/www/html user create \
        "${WP_USER}" \
        "${WP_USER_EMAIL}" \
        --role="${WP_USER_ROLE}" \
	--porcelain

    wp --allow-root --path=/var/www/html eval '
	$user = get_user_by("login", getenv("WP_USER"));
	if (!$user) {
    exit("User not found");
			}
	wp_set_password(trim(file_get_contents("/run/secrets/wp_user_pass")), $user->ID); '
fi

exec php-fpm8.2 -F
