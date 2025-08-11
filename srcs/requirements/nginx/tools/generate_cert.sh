#!/bin/sh
set -e

CERT_DIR="/etc/nginx/certs"
DOMAIN="${DOMAIN_NAME:-localhost}"

mkdir -p $CERT_DIR

if [ ! -f "$CERT_DIR/$DOMAIN.crt" ]; then
    echo "🔐 Generating self-signed certificate for $DOMAIN..."
    openssl req -x509 -nodes -days 365 \
        -newkey rsa:2048 \
        -keyout "$CERT_DIR/$DOMAIN.key" \
        -out "$CERT_DIR/$DOMAIN.crt" \
        -subj "/C=MY/ST=/L=/O=/OU=/CN=$DOMAIN"
else
    echo "📄 Certificate already exists."
fi

envsubst '${DOMAIN_NAME}' < /etc/nginx/templates/default.conf.template \
        > /etc/nginx/conf.d/default.conf

exec "$@"
