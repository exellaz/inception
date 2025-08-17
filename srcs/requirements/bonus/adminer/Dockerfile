FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends php \
    php-mysqli \
    curl \
    ca-certificates && \
    update-ca-certificates && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/adminer && \
    curl -fsSL https://github.com/vrana/adminer/releases/download/v5.3.0/adminer-5.3.0.php -o /var/www/adminer/index.php

WORKDIR /var/www/adminer

EXPOSE 8080

# Run built-in PHP web server
CMD ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/adminer"]
