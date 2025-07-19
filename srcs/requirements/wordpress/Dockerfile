FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
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

RUN ln -s /usr/sbin/php-fpm8.1 /usr/local/bin/php-fpm

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Create user (optional)
RUN useradd -ms /bin/bash www

# Download WordPress
RUN mkdir -p /var/www/wordpress && \
    curl -o wordpress.tar.gz https://wordpress.org/latest.tar.gz && \
    tar -xzf wordpress.tar.gz -C /var/www && \
    rm wordpress.tar.gz

COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /var/www/wordpress

ENTRYPOINT ["entrypoint.sh"]
RUN sed -i 's|^listen = .*|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf
CMD ["php-fpm7.4", "-F"]
