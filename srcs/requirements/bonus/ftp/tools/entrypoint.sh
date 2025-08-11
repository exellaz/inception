#!/bin/sh
set -e

# Create FTP user
adduser --disabled-password --gecos "" "$FTP_USER"
echo "$FTP_USER:$FTP_PASS" | chpasswd

# Ensure correct ownership
chown -R "$FTP_USER":"$FTP_USER" /var/www/wordpress

echo "✅ FTP server starting for user: $FTP_USER"
exec /usr/sbin/vsftpd /etc/vsftpd.conf
