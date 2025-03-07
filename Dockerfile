# syntax=docker/dockerfile:1
################################################################################

# Create a stage for installing app dependencies defined in Composer.
FROM composer:lts as deps

WORKDIR /app

# Download dependencies as a separate step to take advantage of Docker's caching.
# Leverage a bind mounts to composer.json and composer.lock to avoid having to copy them
# into this layer.
# Leverage a cache mount to /tmp/cache so that subsequent builds don't have to re-download packages.
RUN --mount=type=bind,source=composer.json,target=composer.json \
    --mount=type=bind,source=composer.lock,target=composer.lock \
    --mount=type=cache,target=/tmp/cache \
    composer install --no-dev --no-interaction

################################################################################

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
COPY --from=deps app/vendor/ /var/www/html/vendor
USER www-data
