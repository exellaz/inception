FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y --no-install-recommends nginx openssl gettext-base && \
    rm -rf /var/lib/apt/lists/*

COPY conf/default.conf.template /etc/nginx/templates/default.conf.template
COPY tools/generate_cert.sh /usr/local/bin/generate_cert.sh
RUN chmod +x /usr/local/bin/generate_cert.sh

EXPOSE 443

ENTRYPOINT ["/usr/local/bin/generate_cert.sh"]

# Start NGINX in foreground
CMD ["nginx", "-g", "daemon off;"]
