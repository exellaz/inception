FROM debian:bullseye

# Install nginx and openssl for certs
RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Create folders
RUN mkdir -p /etc/nginx/certs /var/www/html

# Copy custom conf and cert generation script
COPY conf/default.conf /etc/nginx/sites-available/default
COPY tools/generate_cert.sh /usr/local/bin/generate_cert.sh

# Permissions
RUN chmod +x /usr/local/bin/generate_cert.sh

# Replace default site config
RUN ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# Use cert generation script as entrypoint
ENTRYPOINT ["/usr/local/bin/generate_cert.sh"]

# Start NGINX in foreground
CMD ["nginx", "-g", "daemon off;"]
