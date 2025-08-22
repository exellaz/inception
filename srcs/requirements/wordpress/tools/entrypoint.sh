#!/bin/sh
set -e

# Wait until MariaDB is available
echo "Waiting for MariaDB at $WORDPRESS_DB_HOST..."
until mysqladmin ping -h"${WORDPRESS_DB_HOST%%:*}" --silent; do
    sleep 1
done
echo "MariaDB is available!"

# Configure wp-config.php
if [ ! -f wp-config.php ]; then
    echo "Creating wp-config.php..."
    cp wp-config-sample.php wp-config.php
    sed -i "s/database_name_here/$WORDPRESS_DB_NAME/" wp-config.php
    sed -i "s/username_here/$WORDPRESS_DB_USER/" wp-config.php
    sed -i "s/password_here/$WORDPRESS_DB_PASSWORD/" wp-config.php
    sed -i "s/localhost/$WORDPRESS_DB_HOST/" wp-config.php
fi

if ! wp core is-installed --allow-root; then
    echo "Installing WordPress..."
    wp core install \
        --url=$DOMAIN_NAME \
        --title="Inception" \
        --admin_user=$WORDPRESS_ADMIN_USER \
        --admin_password=$WORDPRESS_ADMIN_PASSWORD \
        --admin_email=$WORDPRESS_ADMIN_EMAIL \
        --skip-email \
        --allow-root
    chown -R www-data:www-data /var/www/wordpress/wp-content || true
    chmod -R 755 /var/www/wordpress/wp-content || true
    wp plugin install redis-cache --activate --allow-root
    wp config set WP_REDIS_HOST "redis" --allow-root
    wp config set WP_REDIS_PORT 6379  --allow-root
    wp config set WP_REDIS_TIMEOUT 1 --allow-root
    wp config set WP_REDIS_READ_TIMEOUT 1 --allow-root
    wp config set WP_REDIS_DATABASE 0 --allow-root

else
    echo "WordPress already installed."
    wp plugin activate redis-cache --allow-root
fi

mkdir -p /run/php
wp redis enable --allow-root
exec php-fpm7.4 -F

