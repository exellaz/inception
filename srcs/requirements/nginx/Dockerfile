FROM debian:bullseye

RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

COPY conf/default.conf /etc/nginx/sites-available/default
COPY tools/generate_cert.sh /usr/local/bin/generate_cert.sh
RUN chmod +x /usr/local/bin/generate_cert.sh


RUN ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

ENTRYPOINT ["/usr/local/bin/generate_cert.sh"]

# Start NGINX in foreground
CMD ["nginx", "-g", "daemon off;"]

EXPOSE 443