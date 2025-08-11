#!/bin/sh
set -e

# Create directory for MariaDB socket
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# Initialize DB if not already done
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing database..."
    mysql_install_db --user=mysql --ldata=/var/lib/mysql > /dev/null
fi

# Start MariaDB with temporary config and wait for it to be ready
echo "Starting temporary MariaDB..."
mysqld_safe --skip-networking &
pid="$!"

# Wait for MariaDB to be ready
until mysqladmin ping >/dev/null 2>&1; do
    sleep 1
done

# Ensure env vars exist
echo "Creating DB/user..."
: "${DB_NAME:?DB_NAME is required}"
: "${DB_USER:?DB_USER is required}"
: "${DB_PASSWORD:?DB_PASSWORD is required}"


# Run DB setup
echo "Setting up database and user..."
mysql -e "CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;"
mysql -e "CREATE USER IF NOT EXISTS \`${DB_USER}\`@'%' IDENTIFIED BY '${DB_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO \`${DB_USER}\`@'%';"
mysql -e "FLUSH PRIVILEGES;"

# Kill temporary DB
mysqladmin shutdown

# Start MariaDB normally
echo "✅ Database ready. Starting MariaDB..."
exec mysqld --bind-address=0.0.0.0
