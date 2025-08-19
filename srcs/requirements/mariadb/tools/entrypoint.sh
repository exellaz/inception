#!/bin/sh

# Create socket dir
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# Initialize DB if needed
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing database..."
    mysql_install_db --user=mysql --ldata=/var/lib/mysql > /dev/null
fi

# Start MariaDB (no networking) to run setup
echo "Starting temporary MariaDB..."
mysqld_safe --skip-networking &
pid="$!"

# Wait until it's ready
until mysqladmin ping --silent; do
    sleep 1
done

# Ensure env vars exist
: "${DB_NAME:?DB_NAME is required}"
: "${DB_USER:?DB_USER is required}"
: "${DB_PASSWORD:?DB_PASSWORD is required}"
: "${DB_ROOT_PASSWORD:?DB_ROOT_PASSWORD is required}"

# Set root password and create DB/user
echo "Setting up database and user..."
mysql -u root <<-EOSQL
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
    CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
    CREATE USER IF NOT EXISTS \`${DB_USER}\`@'%' IDENTIFIED BY '${DB_PASSWORD}';
    GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO \`${DB_USER}\`@'%';
    FLUSH PRIVILEGES;
EOSQL

# Shut down temporary DB
mysqladmin -u root -p"${DB_ROOT_PASSWORD}" shutdown

# Start MariaDB normally
echo "✅ Database ready. Starting MariaDB..."
exec mysqld --bind-address=0.0.0.0
