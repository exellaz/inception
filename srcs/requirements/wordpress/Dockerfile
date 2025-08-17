FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    php-fpm \
    php-mysql \
    php-curl \
    php-xml \
    php-mbstring \
    php-zip \
    php-gd \
    php-cli \
    curl \
    mariadb-client \
    wget unzip && \
    rm -rf /var/lib/apt/lists/*

# Install WP-CLI
RUN curl -fsSL https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o /usr/local/bin/wp && \
    chmod +x /usr/local/bin/wp

# Download WordPress
RUN mkdir -p /var/www/wordpress && \
    curl -fsSL https://wordpress.org/wordpress-6.8.2.tar.gz | tar -xz --strip-components=1 -C /var/www/wordpress

COPY ./conf/wp-config.php /var/www/wordpress/wp-config.php

COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /var/www/wordpress

ENTRYPOINT ["entrypoint.sh"]
RUN sed -i 's|^listen = .*|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf
CMD ["php-fpm7.4", "-F"]