# syntax=docker/dockerfile:1

FROM php:8.3.12-apache as final

# enable Rewrites
RUN a2enmod rewrite

# Setup mysqli and pdo
RUN apt-get update && apt-get install -y libmariadb-dev \
    && docker-php-ext-install mysqli pdo_mysql \
    && docker-php-ext-enable mysqli pdo_mysql

# Install xdebug
RUN pecl install xdebug-3.4.1
RUN docker-php-ext-enable xdebug
    
# Setup xdebug
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
RUN echo "xdebug=true" >> "$PHP_INI_DIR/php.ini"
RUN echo "xdebug.mode=debug" >> "$PHP_INI_DIR/php.ini"
RUN echo "xdebug.client_host=host.docker.internal" >> "$PHP_INI_DIR/php.ini"
RUN echo "xdebug.start_with_request=yes" >> "$PHP_INI_DIR/php.ini"
RUN echo "xdebug.log=/dev/stdout" >> "$PHP_INI_DIR/php.ini"
RUN echo "xdebug.log_level=3" >> "$PHP_INI_DIR/php.ini"

# Copy the app dependencies from the previous install stage.
USER www-data
