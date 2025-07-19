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

# Run DB setup
echo "Setting up database and user..."
mysql -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
mysql -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';"
mysql -e "FLUSH PRIVILEGES;"

# Kill temporary DB
mysqladmin shutdown

# Start MariaDB normally
echo "✅ Database ready. Starting MariaDB..."
exec mysqld --bind-address=0.0.0.0
