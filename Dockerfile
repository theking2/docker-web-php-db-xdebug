# syntax=docker/dockerfile:1

FROM php:8.3.12-apache as final

# enable Rewrites and setup mysqli, pdo, and xdebug
RUN a2enmod rewrite \
    && apt-get update && apt-get install -y libmariadb-dev \
    # Install and enable mysqli and pdo_mysql extensions
    && docker-php-ext-install mysqli pdo_mysql \
    && docker-php-ext-enable mysqli pdo_mysql \
    # Install and enable xdebug
    && pecl install xdebug-3.4.1 \
    && docker-php-ext-enable xdebug \
    # Move production php.ini and configure xdebug
    && mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
    && { \
        echo "xdebug=true"; \
        echo "xdebug.mode=debug"; \
        echo "xdebug.client_host=host.docker.internal"; \
        echo "xdebug.start_with_request=yes"; \
        echo "xdebug.log=/dev/stdout"; \
        echo "xdebug.log_level=3"; \
    } >> "$PHP_INI_DIR/php.ini"

# Copy the app dependencies from the previous install stage.
USER www-data
